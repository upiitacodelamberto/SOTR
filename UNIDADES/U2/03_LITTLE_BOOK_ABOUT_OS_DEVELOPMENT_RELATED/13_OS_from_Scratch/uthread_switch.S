/*	movl current_thread,%eax
	movl %esp,(%eax)
*/
	.text

/* Switch from current_thread to next_thread. Make next_thread
 * the current_thread, and set next_thread to 0.
 * Use eax as a temporary register, which should be caller saved.
 */
	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
	pushal                         /*save registers on stack*/
	movl current_thread,%eax       /*load addr of current_thread*/
	movl %esp,(%eax)               /*save esp reg in sp of thread*/
	movl next_thread,%eax          /*load addr of next_thread*/
	movl (%eax),%esp               /*load sp of thread in esp reg*/
	movl %eax,current_thread       /*next_thread -> current_thread*/       
	movl $0,next_thread            /*clear next_thread*/
	popal                          /*restore registers from stack*/

	ret				/* pop return address from stack */

