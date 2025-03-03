/*
 * Copyright (C) 2009 - 2018 Xilinx, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 *
 */

#include <stdio.h>

#include "xparameters.h"

#include "netif/xadapter.h"
#include "lwip/udp.h"
#include "platform.h"
#include "platform_config.h"
#if defined (__arm__) || defined(__aarch64__)
#include "xil_printf.h"
#endif

#include "xaxidma.h"
#include "adc_dma.h"
#include "sleep.h"
#include "dma_bd/dma_bd.h"

#include "xil_cache.h"

#if LWIP_IPV6==1
#include "lwip/ip.h"
#else
#if LWIP_DHCP==1
#include "lwip/dhcp.h"
#endif
#endif


static struct udp_pcb *udp8080_pcb = NULL;
static struct pbuf *udp8080_q = NULL;
static int udp8080_qlen = 0;
ip_addr_t target_addr;
char TargetHeader[8] = { 0, 0x00, 0x01, 0x00, 0x02 };
unsigned char ip_export[4];
unsigned char mac_export[6];

extern XAxiDma AxiDmaCh0;
extern XAxiDma AxiDmaCh1;

extern short CH0DmaRxBuffer[MAX_DMA_LEN/ADC_BYTE] ;
extern short CH1DmaRxBuffer[MAX_DMA_LEN/ADC_BYTE] ;

short CH0DmaBufferTmp[MAX_DMA_LEN/ADC_BYTE]  __attribute__ ((aligned(64)));
short CH1DmaBufferTmp[MAX_DMA_LEN/ADC_BYTE]  __attribute__ ((aligned(64)));
/*
 * BD buffer
 */
extern u32 Ch0BdChainBuffer[BD_ALIGNMENT*16] ;
extern u32 Ch1BdChainBuffer[BD_ALIGNMENT*16] ;



extern int ch0_s2mm_flag ;
extern int ch1_s2mm_flag ;

short sent_buf[ADC_SAMPLE_NUM]  __attribute__ ((aligned(4096)));


int FrameLengthCurr = 0 ;


/* defined by each RAW mode application */
int start_udp(unsigned int port);
int transfer_data(const char *pData, int len, const ip_addr_t *addr) ;
int send_adc_data(const char *frame, int data_len);

extern void XAxiDma_Adc(u32 *BdChainBuffer, u32 adc_addr, u32 adc_len, u16 BdCount, XAxiDma *AxiDma) ;
/* missing declaration in lwIP */
void lwip_init();

#if LWIP_IPV6==0
#if LWIP_DHCP==1
extern volatile int dhcp_timoutcntr;
err_t dhcp_start(struct netif *netif);
#endif
#endif

static struct netif server_netif;
struct netif *echo_netif;

#if LWIP_IPV6==1
void print_ip6(char *msg, ip_addr_t *ip)
{
	print(msg);
	xil_printf(" %x:%x:%x:%x:%x:%x:%x:%x\n\r",
			IP6_ADDR_BLOCK1(&ip->u_addr.ip6),
			IP6_ADDR_BLOCK2(&ip->u_addr.ip6),
			IP6_ADDR_BLOCK3(&ip->u_addr.ip6),
			IP6_ADDR_BLOCK4(&ip->u_addr.ip6),
			IP6_ADDR_BLOCK5(&ip->u_addr.ip6),
			IP6_ADDR_BLOCK6(&ip->u_addr.ip6),
			IP6_ADDR_BLOCK7(&ip->u_addr.ip6),
			IP6_ADDR_BLOCK8(&ip->u_addr.ip6));

}
#else
void
print_ip(char *msg, ip_addr_t *ip)
{
	print(msg);
	xil_printf("%d.%d.%d.%d\n\r", ip4_addr1(ip), ip4_addr2(ip),
			ip4_addr3(ip), ip4_addr4(ip));
}

void
print_ip_settings(ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw)
{

	print_ip("Board IP: ", ip);
	print_ip("Netmask : ", mask);
	print_ip("Gateway : ", gw);
}
#endif

void print_app_header() {
	xil_printf("\n\r\n\r-----AN108 lwIP UDP DEMO ------\n\r");
	xil_printf("UDP packets sent to port 8080\n\r");
}

#if defined (__arm__) && !defined (ARMR5)
#if XPAR_GIGE_PCS_PMA_SGMII_CORE_PRESENT == 1 || XPAR_GIGE_PCS_PMA_1000BASEX_CORE_PRESENT == 1
int ProgramSi5324(void);
int ProgramSfpPhy(void);
#endif
#endif

#ifdef XPS_BOARD_ZCU102
#ifdef XPAR_XIICPS_0_DEVICE_ID
int IicPhyReset(void);
#endif
#endif

int lwip_loop()
{
#if LWIP_IPV6==0
	ip_addr_t ipaddr, netmask, gw;

#endif
	/* the mac address of the board. this should be unique per board */
	unsigned char mac_ethernet_address[] =
	{ 0x00, 0x0a, 0x35, 0x00, 0x01, 0x02 };

	echo_netif = &server_netif;
#if defined (__arm__) && !defined (ARMR5)
#if XPAR_GIGE_PCS_PMA_SGMII_CORE_PRESENT == 1 || XPAR_GIGE_PCS_PMA_1000BASEX_CORE_PRESENT == 1
	ProgramSi5324();
	ProgramSfpPhy();
#endif
#endif

	/* Define this board specific macro in order perform PHY reset on ZCU102 */
#ifdef XPS_BOARD_ZCU102
	if(IicPhyReset()) {
		xil_printf("Error performing PHY reset \n\r");
		return -1;
	}
#endif

	init_platform();

#if LWIP_IPV6==0
#if LWIP_DHCP==1
	ipaddr.addr = 0;
	gw.addr = 0;
	netmask.addr = 0;
#else
	/* initliaze IP addresses to be used */
	IP4_ADDR(&ipaddr,  192, 168,   1, 10);
	IP4_ADDR(&netmask, 255, 255, 255,  0);
	IP4_ADDR(&gw,      192, 168,   1,  1);
#endif
#endif
	print_app_header();

	lwip_init();

#if (LWIP_IPV6 == 0)
	/* Add network interface to the netif_list, and set it as default */
	if (!xemac_add(echo_netif, &ipaddr, &netmask,
			&gw, mac_ethernet_address,
			PLATFORM_EMAC_BASEADDR)) {
		xil_printf("Error adding N/W interface\n\r");
		return -1;
	}
#else
	/* Add network interface to the netif_list, and set it as default */
	if (!xemac_add(echo_netif, NULL, NULL, NULL, mac_ethernet_address,
			PLATFORM_EMAC_BASEADDR)) {
		xil_printf("Error adding N/W interface\n\r");
		return -1;
	}
	echo_netif->ip6_autoconfig_enabled = 1;

	netif_create_ip6_linklocal_address(echo_netif, 1);
	netif_ip6_addr_set_state(echo_netif, 0, IP6_ADDR_VALID);

	print_ip6("\n\rBoard IPv6 address ", &echo_netif->ip6_addr[0].u_addr.ip6);

#endif
	netif_set_default(echo_netif);

	/* now enable interrupts */
	platform_enable_interrupts();

	/* specify that the network if is up */
	netif_set_up(echo_netif);

#if (LWIP_IPV6 == 0)
#if (LWIP_DHCP==1)
	/* Create a new DHCP client for this interface.
	 * Note: you must call dhcp_fine_tmr() and dhcp_coarse_tmr() at
	 * the predefined regular intervals after starting the client.
	 */
	dhcp_start(echo_netif);
	dhcp_timoutcntr = 24;

	while(((echo_netif->ip_addr.addr) == 0) && (dhcp_timoutcntr > 0))
		xemacif_input(echo_netif);

	if (dhcp_timoutcntr <= 0) {
		if ((echo_netif->ip_addr.addr) == 0) {
			xil_printf("DHCP Timeout\r\n");
			xil_printf("Configuring default IP of 192.168.1.10\r\n");
			IP4_ADDR(&(echo_netif->ip_addr),  192, 168,   1, 10);
			IP4_ADDR(&(echo_netif->netmask), 255, 255, 255,  0);
			IP4_ADDR(&(echo_netif->gw),      192, 168,   1,  1);
		}
	}

	ipaddr.addr = echo_netif->ip_addr.addr;
	gw.addr = echo_netif->gw.addr;
	netmask.addr = echo_netif->netmask.addr;
#endif

	print_ip_settings(&ipaddr, &netmask, &gw);
	memcpy(ip_export, &ipaddr, 4);
	memcpy(mac_export, &mac_ethernet_address, 6);

#endif
	/* start the application (web server, rxtest, txtest, etc..) */
	start_udp(8080);

	/* Start ADC channel 0 */
	XAxiDma_Adc(Ch0BdChainBuffer, AD9238_CH0_BASE, ADC_SAMPLE_NUM, BD_COUNT, &AxiDmaCh0) ;
	/* receive and process packets */
	while (1)
	{
		xemacif_input(echo_netif);
		/* Wait for times */
		usleep(1000) ;
		/* Check current frame length */
		if (FrameLengthCurr > 0)
		{
			/* Check if DMA completed */
			if (ch0_s2mm_flag >= 0)
			{
				int udp_len;
				Xil_DCacheInvalidateRange((u32) CH0DmaRxBuffer, FrameLengthCurr);
				/* change data to short */
				for(int i = 0 ; i < ADC_SAMPLE_NUM ; i++)
				{
					CH0DmaBufferTmp[i] = (short)(CH0DmaRxBuffer[i] - 2048) ;
				}
				/* Separate data into package */
				for (int i = 0; i < FrameLengthCurr; i += 1024)
				{
					if ((i + 1024) > FrameLengthCurr)
						udp_len = FrameLengthCurr - i;
					else
						udp_len = 1024;

					send_adc_data((const char *) CH0DmaBufferTmp + i, udp_len);
				}
				/* Start ADC channel 1 */
				XAxiDma_Adc(Ch0BdChainBuffer, AD9238_CH0_BASE, ADC_SAMPLE_NUM, BD_COUNT, &AxiDmaCh0) ;
				/* Clear DMA flag and frame length */
				ch0_s2mm_flag = -1;
				FrameLengthCurr = 0;
			}

			/* Check if DMA completed */
			else if (ch1_s2mm_flag >= 0)
			{
				int udp_len;
				Xil_DCacheInvalidateRange((u32) CH1DmaRxBuffer, FrameLengthCurr);
				/* change data to short */
				for(int i = 0 ; i < ADC_SAMPLE_NUM ; i++)
				{
					CH1DmaBufferTmp[i] = (short)(CH1DmaRxBuffer[i] - 2048) ;
				}
				/* Separate data into package */
				for (int i = 0; i < FrameLengthCurr; i += 1024)
				{
					if ((i + 1024) > FrameLengthCurr)
						udp_len = FrameLengthCurr - i;
					else
						udp_len = 1024;

					send_adc_data((const char *) CH1DmaBufferTmp + i, udp_len);
				}
				/* Start ADC channel 1 */
				XAxiDma_Adc(Ch1BdChainBuffer, AD9238_CH1_BASE, ADC_SAMPLE_NUM, BD_COUNT, &AxiDmaCh1) ;
				/* Clear DMA flag and frame length */
				ch1_s2mm_flag = -1;
				FrameLengthCurr = 0;

			}
		}
	}

	/* never reached */
	cleanup_platform();

	return 0;
}



/*
 * Transfer data with udp
 *
 * @param pData is data pointer will be send
 * @param len is the data length
 * @param addr is IP address
 *
 */
int transfer_data(const char *pData, int len, const ip_addr_t *addr)
{
	/* If parameter length bigger than udp8080_qlen, reallocate memory space */
	if(len > udp8080_qlen)
	{
		if(udp8080_q)
		{
			pbuf_free(udp8080_q);
		}
		udp8080_qlen = len;
		/* allocate memory space to pbuf */
		udp8080_q = pbuf_alloc(PBUF_TRANSPORT, udp8080_qlen, PBUF_POOL);
		if(!udp8080_q)
		{
			xil_printf("pbuf_alloc %d fail\n\r", udp8080_qlen);
			udp8080_qlen = 0;
			return -3;
		}
	}
	/* copy data to pbuf payload */
	memcpy(udp8080_q->payload, pData, len);
	udp8080_q->len = len;
	udp8080_q->tot_len = len;
	/* Start to send udp data */
	udp_sendto(udp8080_pcb, udp8080_q, addr, 8080);
	return 0;
}
/*
 * Transfer data with udp
 *
 * @param frame is data pointer will be send
 * @param data_len is the data length
 *
 */
int send_adc_data(const char *frame, int data_len)
{
	if (!TargetHeader[0]) {
		return -1;
	}
	struct pbuf *q;
	q = pbuf_alloc(PBUF_TRANSPORT, 8 + data_len, PBUF_POOL);
	if (!q) {
		xil_printf("pbuf_alloc %d fail\n\r", data_len + 8);
		return -3;
	}

	memcpy(q->payload, TargetHeader, 5);
	for (int i = 0; i < data_len; i += 2) {
		((char *) q->payload)[5 + i] = frame[i + 1];
		((char *) q->payload)[6 + i] = frame[i + 0];
	};
	q->len = q->tot_len = 5 + data_len;
	udp_sendto(udp8080_pcb, q, &target_addr, 8080);
	pbuf_free(q);
	return 0;
}


#define MAX_SEND_LEN ADC_BYTE*ADC_SAMPLE_NUM
/*
 * Call back funtion for udp receiver
 *
 * @param arg is argument
 * @param pcb is udp pcb pointer
 * @param p_rx is pbuf pointer
 * @param addr is IP address
 * @param port is udp port
 *
 */
void udp_recive(void *arg, struct udp_pcb *pcb, struct pbuf *p_rx,
		const ip_addr_t *addr, u16_t port) {
	char *pData;
	char buff[28];
	if (p_rx != NULL)
	{
		pData = (char *) p_rx->payload;

		if (p_rx->len >= 5) {
			if (((pData[0] & 0x01) == 0) && (pData[1] == 0x00)
					&& ((pData[2] == 0x01) || (pData[2] < 0x00))
					&& (pData[3]) == 0x00)
			{
				if (pData[4] == 1)
				{
					buff[0] = pData[0] | 1;
					buff[1] = 0x00;
					buff[2] = 0x01;
					buff[3] = 0x00;
					buff[4] = 0x01;
					//MAC address
					memcpy(buff + 5, mac_export, 6);
					memcpy(buff + 5 + 6, ip_export, 4);
					buff[15] = 1;
					buff[16] = ADC_BITS;
					buff[17] = 2;
					buff[18] = 1;
					buff[19] = (unsigned char) (32000000 >> 24);
					buff[20] = (unsigned char) (32000000 >> 16);
					buff[21] = (unsigned char) (32000000 >> 8);
					buff[22] = (unsigned char) (32000000 >> 0);
					buff[23] = (unsigned char) (MAX_SEND_LEN >> 24);
					buff[24] = (unsigned char) (MAX_SEND_LEN >> 16);
					buff[25] = (unsigned char) (MAX_SEND_LEN >> 8);
					buff[26] = (unsigned char) (MAX_SEND_LEN >> 0);
					transfer_data(buff, 27, addr);
				}
				else if (pData[4] == 2)
				{
					int sample_len = (pData[15] << 24) | (pData[16] << 16)
													| (pData[17] << 8) | (pData[18] << 0);

					TargetHeader[0] = pData[0] | 1;
					target_addr.addr = addr->addr;
					FrameLengthCurr = (FrameLengthCurr == 0)? sample_len*2 :FrameLengthCurr;
				}
			}
		}
		pbuf_free(p_rx);
	}
}
/*
 * Create new pcb, bind pcb and port, set call back function
 */
int start_udp(unsigned int port) {
	err_t err;
	udp8080_pcb = udp_new();
	if (!udp8080_pcb) {
		xil_printf("Error creating PCB. Out of Memory\n\r");
		return -1;
	}
	/* bind to specified @port */
	err = udp_bind(udp8080_pcb, IP_ADDR_ANY, port);
	if (err != ERR_OK) {
		xil_printf("Unable to bind to port %d: err = %d\n\r", port, err);
		return -2;
	}
	udp_recv(udp8080_pcb, udp_recive, 0);
	IP4_ADDR(&target_addr, 192,168,1,35);

	return 0;
}
