
kernel:     formato del fichero elf32-i386


Desensamblado de la sección .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 80 d6 10 80       	mov    $0x8010d680,%esp

  # Jump to kmain(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $kmain, %eax
8010002d:	b8 7a 2f 10 80       	mov    $0x80102f7a,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 b0 8d 10 80       	push   $0x80108db0
80100042:	68 80 d6 10 80       	push   $0x8010d680
80100047:	e8 82 54 00 00       	call   801054ce <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 90 15 11 80 84 	movl   $0x80111584,0x80111590
80100056:	15 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 94 15 11 80 84 	movl   $0x80111584,0x80111594
80100060:	15 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 b4 d6 10 80 	movl   $0x8010d6b4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 94 15 11 80       	mov    0x80111594,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 94 15 11 80       	mov    %eax,0x80111594

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
801000ad:	72 bd                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000af:	c9                   	leave  
801000b0:	c3                   	ret    

801000b1 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b1:	55                   	push   %ebp
801000b2:	89 e5                	mov    %esp,%ebp
801000b4:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b7:	83 ec 0c             	sub    $0xc,%esp
801000ba:	68 80 d6 10 80       	push   $0x8010d680
801000bf:	e8 2b 54 00 00       	call   801054ef <acquire>
801000c4:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c7:	a1 94 15 11 80       	mov    0x80111594,%eax
801000cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000cf:	eb 67                	jmp    80100138 <bget+0x87>
    if(b->dev == dev && b->blockno == blockno){
801000d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d4:	8b 40 04             	mov    0x4(%eax),%eax
801000d7:	3b 45 08             	cmp    0x8(%ebp),%eax
801000da:	75 53                	jne    8010012f <bget+0x7e>
801000dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000df:	8b 40 08             	mov    0x8(%eax),%eax
801000e2:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e5:	75 48                	jne    8010012f <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ea:	8b 00                	mov    (%eax),%eax
801000ec:	83 e0 01             	and    $0x1,%eax
801000ef:	85 c0                	test   %eax,%eax
801000f1:	75 27                	jne    8010011a <bget+0x69>
        b->flags |= B_BUSY;
801000f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f6:	8b 00                	mov    (%eax),%eax
801000f8:	83 c8 01             	or     $0x1,%eax
801000fb:	89 c2                	mov    %eax,%edx
801000fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100100:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100102:	83 ec 0c             	sub    $0xc,%esp
80100105:	68 80 d6 10 80       	push   $0x8010d680
8010010a:	e8 46 54 00 00       	call   80105555 <release>
8010010f:	83 c4 10             	add    $0x10,%esp
        return b;
80100112:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100115:	e9 98 00 00 00       	jmp    801001b2 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011a:	83 ec 08             	sub    $0x8,%esp
8010011d:	68 80 d6 10 80       	push   $0x8010d680
80100122:	ff 75 f4             	pushl  -0xc(%ebp)
80100125:	e8 e0 4c 00 00       	call   80104e0a <sleep>
8010012a:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012d:	eb 98                	jmp    801000c7 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010012f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100132:	8b 40 10             	mov    0x10(%eax),%eax
80100135:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100138:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
8010013f:	75 90                	jne    801000d1 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100141:	a1 90 15 11 80       	mov    0x80111590,%eax
80100146:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100149:	eb 51                	jmp    8010019c <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014e:	8b 00                	mov    (%eax),%eax
80100150:	83 e0 01             	and    $0x1,%eax
80100153:	85 c0                	test   %eax,%eax
80100155:	75 3c                	jne    80100193 <bget+0xe2>
80100157:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015a:	8b 00                	mov    (%eax),%eax
8010015c:	83 e0 04             	and    $0x4,%eax
8010015f:	85 c0                	test   %eax,%eax
80100161:	75 30                	jne    80100193 <bget+0xe2>
      b->dev = dev;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 08             	mov    0x8(%ebp),%edx
80100169:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	8b 55 0c             	mov    0xc(%ebp),%edx
80100172:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100175:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100178:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
8010017e:	83 ec 0c             	sub    $0xc,%esp
80100181:	68 80 d6 10 80       	push   $0x8010d680
80100186:	e8 ca 53 00 00       	call   80105555 <release>
8010018b:	83 c4 10             	add    $0x10,%esp
      return b;
8010018e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100191:	eb 1f                	jmp    801001b2 <bget+0x101>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100193:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100196:	8b 40 0c             	mov    0xc(%eax),%eax
80100199:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019c:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
801001a3:	75 a6                	jne    8010014b <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a5:	83 ec 0c             	sub    $0xc,%esp
801001a8:	68 b7 8d 10 80       	push   $0x80108db7
801001ad:	e8 f1 03 00 00       	call   801005a3 <panic>
}
801001b2:	c9                   	leave  
801001b3:	c3                   	ret    

801001b4 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001ba:	83 ec 08             	sub    $0x8,%esp
801001bd:	ff 75 0c             	pushl  0xc(%ebp)
801001c0:	ff 75 08             	pushl  0x8(%ebp)
801001c3:	e8 e9 fe ff ff       	call   801000b1 <bget>
801001c8:	83 c4 10             	add    $0x10,%esp
801001cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d1:	8b 00                	mov    (%eax),%eax
801001d3:	83 e0 02             	and    $0x2,%eax
801001d6:	85 c0                	test   %eax,%eax
801001d8:	75 0e                	jne    801001e8 <bread+0x34>
    iderw(b);
801001da:	83 ec 0c             	sub    $0xc,%esp
801001dd:	ff 75 f4             	pushl  -0xc(%ebp)
801001e0:	e8 af 27 00 00       	call   80102994 <iderw>
801001e5:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001eb:	c9                   	leave  
801001ec:	c3                   	ret    

801001ed <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ed:	55                   	push   %ebp
801001ee:	89 e5                	mov    %esp,%ebp
801001f0:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f3:	8b 45 08             	mov    0x8(%ebp),%eax
801001f6:	8b 00                	mov    (%eax),%eax
801001f8:	83 e0 01             	and    $0x1,%eax
801001fb:	85 c0                	test   %eax,%eax
801001fd:	75 0d                	jne    8010020c <bwrite+0x1f>
    panic("bwrite");
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	68 c8 8d 10 80       	push   $0x80108dc8
80100207:	e8 97 03 00 00       	call   801005a3 <panic>
  b->flags |= B_DIRTY;
8010020c:	8b 45 08             	mov    0x8(%ebp),%eax
8010020f:	8b 00                	mov    (%eax),%eax
80100211:	83 c8 04             	or     $0x4,%eax
80100214:	89 c2                	mov    %eax,%edx
80100216:	8b 45 08             	mov    0x8(%ebp),%eax
80100219:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021b:	83 ec 0c             	sub    $0xc,%esp
8010021e:	ff 75 08             	pushl  0x8(%ebp)
80100221:	e8 6e 27 00 00       	call   80102994 <iderw>
80100226:	83 c4 10             	add    $0x10,%esp
}
80100229:	c9                   	leave  
8010022a:	c3                   	ret    

8010022b <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022b:	55                   	push   %ebp
8010022c:	89 e5                	mov    %esp,%ebp
8010022e:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100231:	8b 45 08             	mov    0x8(%ebp),%eax
80100234:	8b 00                	mov    (%eax),%eax
80100236:	83 e0 01             	and    $0x1,%eax
80100239:	85 c0                	test   %eax,%eax
8010023b:	75 0d                	jne    8010024a <brelse+0x1f>
    panic("brelse");
8010023d:	83 ec 0c             	sub    $0xc,%esp
80100240:	68 cf 8d 10 80       	push   $0x80108dcf
80100245:	e8 59 03 00 00       	call   801005a3 <panic>

  acquire(&bcache.lock);
8010024a:	83 ec 0c             	sub    $0xc,%esp
8010024d:	68 80 d6 10 80       	push   $0x8010d680
80100252:	e8 98 52 00 00       	call   801054ef <acquire>
80100257:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025a:	8b 45 08             	mov    0x8(%ebp),%eax
8010025d:	8b 40 10             	mov    0x10(%eax),%eax
80100260:	8b 55 08             	mov    0x8(%ebp),%edx
80100263:	8b 52 0c             	mov    0xc(%edx),%edx
80100266:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100269:	8b 45 08             	mov    0x8(%ebp),%eax
8010026c:	8b 40 0c             	mov    0xc(%eax),%eax
8010026f:	8b 55 08             	mov    0x8(%ebp),%edx
80100272:	8b 52 10             	mov    0x10(%edx),%edx
80100275:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
80100278:	8b 15 94 15 11 80    	mov    0x80111594,%edx
8010027e:	8b 45 08             	mov    0x8(%ebp),%eax
80100281:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100284:	8b 45 08             	mov    0x8(%ebp),%eax
80100287:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
  bcache.head.next->prev = b;
8010028e:	a1 94 15 11 80       	mov    0x80111594,%eax
80100293:	8b 55 08             	mov    0x8(%ebp),%edx
80100296:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100299:	8b 45 08             	mov    0x8(%ebp),%eax
8010029c:	a3 94 15 11 80       	mov    %eax,0x80111594

  b->flags &= ~B_BUSY;
801002a1:	8b 45 08             	mov    0x8(%ebp),%eax
801002a4:	8b 00                	mov    (%eax),%eax
801002a6:	83 e0 fe             	and    $0xfffffffe,%eax
801002a9:	89 c2                	mov    %eax,%edx
801002ab:	8b 45 08             	mov    0x8(%ebp),%eax
801002ae:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b0:	83 ec 0c             	sub    $0xc,%esp
801002b3:	ff 75 08             	pushl  0x8(%ebp)
801002b6:	e8 38 4c 00 00       	call   80104ef3 <wakeup>
801002bb:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 80 d6 10 80       	push   $0x8010d680
801002c6:	e8 8a 52 00 00       	call   80105555 <release>
801002cb:	83 c4 10             	add    $0x10,%esp
}
801002ce:	c9                   	leave  
801002cf:	c3                   	ret    

801002d0 <inbyte>:
#include "types.h"
/*We use inbyte for reading from the I/O portsto get data from 
  devices such as the keyboard, to do so we need the 'inb' instruction, 
  which is only accesible from assembly. So the C function is simply a 
  wrapper around a single assembly instruction */
uint8_t inbyte(uint16_t port){
801002d0:	55                   	push   %ebp
801002d1:	89 e5                	mov    %esp,%ebp
801002d3:	83 ec 14             	sub    $0x14,%esp
801002d6:	8b 45 08             	mov    0x8(%ebp),%eax
801002d9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uint8_t ret;
  __asm__ __volatile__ ("inb %1,%0" : "=a"(ret) : "d"(port));
801002dd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e1:	89 c2                	mov    %eax,%edx
801002e3:	ec                   	in     (%dx),%al
801002e4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return ret;
801002e7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002eb:	c9                   	leave  
801002ec:	c3                   	ret    

801002ed <outbyte>:

/*We use outbyte to write to I/O ports, i.e. to send bytes to 
  devices. Again we use inline assembly for the stuff that can not be 
  done in C*/
void outbyte(uint16_t port,uint8_t dato){
801002ed:	55                   	push   %ebp
801002ee:	89 e5                	mov    %esp,%ebp
801002f0:	83 ec 08             	sub    $0x8,%esp
801002f3:	8b 55 08             	mov    0x8(%ebp),%edx
801002f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801002f9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002fd:	88 45 f8             	mov    %al,-0x8(%ebp)
  __asm__ __volatile__ ("outb %1,%0" : : "d"(port),"a"(dato));
80100300:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80100304:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100308:	ee                   	out    %al,(%dx)
}
80100309:	c9                   	leave  
8010030a:	c3                   	ret    

8010030b <sti>:

void sti(void){
8010030b:	55                   	push   %ebp
8010030c:	89 e5                	mov    %esp,%ebp
  __asm__ __volatile__ ("sti");
8010030e:	fb                   	sti    
}
8010030f:	5d                   	pop    %ebp
80100310:	c3                   	ret    

80100311 <cli>:

void cli(void){
80100311:	55                   	push   %ebp
80100312:	89 e5                	mov    %esp,%ebp
  __asm__ __volatile__ ("cli");
80100314:	fa                   	cli    
}
80100315:	5d                   	pop    %ebp
80100316:	c3                   	ret    

80100317 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80100317:	55                   	push   %ebp
80100318:	89 e5                	mov    %esp,%ebp
8010031a:	83 ec 14             	sub    $0x14,%esp
8010031d:	8b 45 08             	mov    0x8(%ebp),%eax
80100320:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100324:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80100328:	89 c2                	mov    %eax,%edx
8010032a:	ec                   	in     (%dx),%al
8010032b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010032e:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80100332:	c9                   	leave  
80100333:	c3                   	ret    

80100334 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80100334:	55                   	push   %ebp
80100335:	89 e5                	mov    %esp,%ebp
80100337:	83 ec 08             	sub    $0x8,%esp
8010033a:	8b 55 08             	mov    0x8(%ebp),%edx
8010033d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100340:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100344:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100347:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010034b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010034f:	ee                   	out    %al,(%dx)
}
80100350:	c9                   	leave  
80100351:	c3                   	ret    

80100352 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100352:	55                   	push   %ebp
80100353:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100355:	fa                   	cli    
}
80100356:	5d                   	pop    %ebp
80100357:	c3                   	ret    

80100358 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100358:	55                   	push   %ebp
80100359:	89 e5                	mov    %esp,%ebp
8010035b:	53                   	push   %ebx
8010035c:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010035f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100363:	74 1c                	je     80100381 <printint+0x29>
80100365:	8b 45 08             	mov    0x8(%ebp),%eax
80100368:	c1 e8 1f             	shr    $0x1f,%eax
8010036b:	0f b6 c0             	movzbl %al,%eax
8010036e:	89 45 10             	mov    %eax,0x10(%ebp)
80100371:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100375:	74 0a                	je     80100381 <printint+0x29>
    x = -xx;
80100377:	8b 45 08             	mov    0x8(%ebp),%eax
8010037a:	f7 d8                	neg    %eax
8010037c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010037f:	eb 06                	jmp    80100387 <printint+0x2f>
  else
    x = xx;
80100381:	8b 45 08             	mov    0x8(%ebp),%eax
80100384:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100387:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010038e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100391:	8d 41 01             	lea    0x1(%ecx),%eax
80100394:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100397:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010039a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010039d:	ba 00 00 00 00       	mov    $0x0,%edx
801003a2:	f7 f3                	div    %ebx
801003a4:	89 d0                	mov    %edx,%eax
801003a6:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
801003ad:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
801003b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801003b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003b7:	ba 00 00 00 00       	mov    $0x0,%edx
801003bc:	f7 f3                	div    %ebx
801003be:	89 45 f0             	mov    %eax,-0x10(%ebp)
801003c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801003c5:	75 c7                	jne    8010038e <printint+0x36>

  if(sign)
801003c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801003cb:	74 0e                	je     801003db <printint+0x83>
    buf[i++] = '-';
801003cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003d0:	8d 50 01             	lea    0x1(%eax),%edx
801003d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003d6:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
801003db:	eb 1a                	jmp    801003f7 <printint+0x9f>
    consputc(buf[i]);
801003dd:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003e3:	01 d0                	add    %edx,%eax
801003e5:	0f b6 00             	movzbl (%eax),%eax
801003e8:	0f be c0             	movsbl %al,%eax
801003eb:	83 ec 0c             	sub    $0xc,%esp
801003ee:	50                   	push   %eax
801003ef:	e8 be 03 00 00       	call   801007b2 <consputc>
801003f4:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003f7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003ff:	79 dc                	jns    801003dd <printint+0x85>
    consputc(buf[i]);
}
80100401:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100404:	c9                   	leave  
80100405:	c3                   	ret    

80100406 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100406:	55                   	push   %ebp
80100407:	89 e5                	mov    %esp,%ebp
80100409:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
8010040c:	a1 14 c6 10 80       	mov    0x8010c614,%eax
80100411:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
80100414:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100418:	74 10                	je     8010042a <cprintf+0x24>
    acquire(&cons.lock);
8010041a:	83 ec 0c             	sub    $0xc,%esp
8010041d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100422:	e8 c8 50 00 00       	call   801054ef <acquire>
80100427:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
8010042a:	8b 45 08             	mov    0x8(%ebp),%eax
8010042d:	85 c0                	test   %eax,%eax
8010042f:	75 0d                	jne    8010043e <cprintf+0x38>
    panic("null fmt");
80100431:	83 ec 0c             	sub    $0xc,%esp
80100434:	68 d6 8d 10 80       	push   $0x80108dd6
80100439:	e8 65 01 00 00       	call   801005a3 <panic>

  argp = (uint*)(void*)(&fmt + 1);
8010043e:	8d 45 0c             	lea    0xc(%ebp),%eax
80100441:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100444:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010044b:	e9 1b 01 00 00       	jmp    8010056b <cprintf+0x165>
    if(c != '%'){
80100450:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100454:	74 13                	je     80100469 <cprintf+0x63>
      consputc(c);
80100456:	83 ec 0c             	sub    $0xc,%esp
80100459:	ff 75 e4             	pushl  -0x1c(%ebp)
8010045c:	e8 51 03 00 00       	call   801007b2 <consputc>
80100461:	83 c4 10             	add    $0x10,%esp
      continue;
80100464:	e9 fe 00 00 00       	jmp    80100567 <cprintf+0x161>
    }
    c = fmt[++i] & 0xff;
80100469:	8b 55 08             	mov    0x8(%ebp),%edx
8010046c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100470:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100473:	01 d0                	add    %edx,%eax
80100475:	0f b6 00             	movzbl (%eax),%eax
80100478:	0f be c0             	movsbl %al,%eax
8010047b:	25 ff 00 00 00       	and    $0xff,%eax
80100480:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100483:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100487:	75 05                	jne    8010048e <cprintf+0x88>
      break;
80100489:	e9 fd 00 00 00       	jmp    8010058b <cprintf+0x185>
    switch(c){
8010048e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100491:	83 f8 70             	cmp    $0x70,%eax
80100494:	74 47                	je     801004dd <cprintf+0xd7>
80100496:	83 f8 70             	cmp    $0x70,%eax
80100499:	7f 13                	jg     801004ae <cprintf+0xa8>
8010049b:	83 f8 25             	cmp    $0x25,%eax
8010049e:	0f 84 98 00 00 00    	je     8010053c <cprintf+0x136>
801004a4:	83 f8 64             	cmp    $0x64,%eax
801004a7:	74 14                	je     801004bd <cprintf+0xb7>
801004a9:	e9 9d 00 00 00       	jmp    8010054b <cprintf+0x145>
801004ae:	83 f8 73             	cmp    $0x73,%eax
801004b1:	74 47                	je     801004fa <cprintf+0xf4>
801004b3:	83 f8 78             	cmp    $0x78,%eax
801004b6:	74 25                	je     801004dd <cprintf+0xd7>
801004b8:	e9 8e 00 00 00       	jmp    8010054b <cprintf+0x145>
    case 'd':
      printint(*argp++, 10, 1);
801004bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004c0:	8d 50 04             	lea    0x4(%eax),%edx
801004c3:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c6:	8b 00                	mov    (%eax),%eax
801004c8:	83 ec 04             	sub    $0x4,%esp
801004cb:	6a 01                	push   $0x1
801004cd:	6a 0a                	push   $0xa
801004cf:	50                   	push   %eax
801004d0:	e8 83 fe ff ff       	call   80100358 <printint>
801004d5:	83 c4 10             	add    $0x10,%esp
      break;
801004d8:	e9 8a 00 00 00       	jmp    80100567 <cprintf+0x161>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801004dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004e0:	8d 50 04             	lea    0x4(%eax),%edx
801004e3:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004e6:	8b 00                	mov    (%eax),%eax
801004e8:	83 ec 04             	sub    $0x4,%esp
801004eb:	6a 00                	push   $0x0
801004ed:	6a 10                	push   $0x10
801004ef:	50                   	push   %eax
801004f0:	e8 63 fe ff ff       	call   80100358 <printint>
801004f5:	83 c4 10             	add    $0x10,%esp
      break;
801004f8:	eb 6d                	jmp    80100567 <cprintf+0x161>
    case 's':
      if((s = (char*)*argp++) == 0)
801004fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004fd:	8d 50 04             	lea    0x4(%eax),%edx
80100500:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100503:	8b 00                	mov    (%eax),%eax
80100505:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100508:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010050c:	75 07                	jne    80100515 <cprintf+0x10f>
        s = "(null)";
8010050e:	c7 45 ec df 8d 10 80 	movl   $0x80108ddf,-0x14(%ebp)
      for(; *s; s++)
80100515:	eb 19                	jmp    80100530 <cprintf+0x12a>
        consputc(*s);
80100517:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010051a:	0f b6 00             	movzbl (%eax),%eax
8010051d:	0f be c0             	movsbl %al,%eax
80100520:	83 ec 0c             	sub    $0xc,%esp
80100523:	50                   	push   %eax
80100524:	e8 89 02 00 00       	call   801007b2 <consputc>
80100529:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
8010052c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100530:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100533:	0f b6 00             	movzbl (%eax),%eax
80100536:	84 c0                	test   %al,%al
80100538:	75 dd                	jne    80100517 <cprintf+0x111>
        consputc(*s);
      break;
8010053a:	eb 2b                	jmp    80100567 <cprintf+0x161>
    case '%':
      consputc('%');
8010053c:	83 ec 0c             	sub    $0xc,%esp
8010053f:	6a 25                	push   $0x25
80100541:	e8 6c 02 00 00       	call   801007b2 <consputc>
80100546:	83 c4 10             	add    $0x10,%esp
      break;
80100549:	eb 1c                	jmp    80100567 <cprintf+0x161>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010054b:	83 ec 0c             	sub    $0xc,%esp
8010054e:	6a 25                	push   $0x25
80100550:	e8 5d 02 00 00       	call   801007b2 <consputc>
80100555:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100558:	83 ec 0c             	sub    $0xc,%esp
8010055b:	ff 75 e4             	pushl  -0x1c(%ebp)
8010055e:	e8 4f 02 00 00       	call   801007b2 <consputc>
80100563:	83 c4 10             	add    $0x10,%esp
      break;
80100566:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100567:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010056b:	8b 55 08             	mov    0x8(%ebp),%edx
8010056e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100571:	01 d0                	add    %edx,%eax
80100573:	0f b6 00             	movzbl (%eax),%eax
80100576:	0f be c0             	movsbl %al,%eax
80100579:	25 ff 00 00 00       	and    $0xff,%eax
8010057e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100581:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100585:	0f 85 c5 fe ff ff    	jne    80100450 <cprintf+0x4a>
      consputc(c);
      break;
    }
  }

  if(locking)
8010058b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010058f:	74 10                	je     801005a1 <cprintf+0x19b>
    release(&cons.lock);
80100591:	83 ec 0c             	sub    $0xc,%esp
80100594:	68 e0 c5 10 80       	push   $0x8010c5e0
80100599:	e8 b7 4f 00 00       	call   80105555 <release>
8010059e:	83 c4 10             	add    $0x10,%esp
}
801005a1:	c9                   	leave  
801005a2:	c3                   	ret    

801005a3 <panic>:

void
panic(char *s)
{
801005a3:	55                   	push   %ebp
801005a4:	89 e5                	mov    %esp,%ebp
801005a6:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
801005a9:	e8 a4 fd ff ff       	call   80100352 <cli>
  cons.locking = 0;
801005ae:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
801005b5:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
801005b8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801005be:	0f b6 00             	movzbl (%eax),%eax
801005c1:	0f b6 c0             	movzbl %al,%eax
801005c4:	83 ec 08             	sub    $0x8,%esp
801005c7:	50                   	push   %eax
801005c8:	68 e6 8d 10 80       	push   $0x80108de6
801005cd:	e8 34 fe ff ff       	call   80100406 <cprintf>
801005d2:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
801005d5:	8b 45 08             	mov    0x8(%ebp),%eax
801005d8:	83 ec 0c             	sub    $0xc,%esp
801005db:	50                   	push   %eax
801005dc:	e8 25 fe ff ff       	call   80100406 <cprintf>
801005e1:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005e4:	83 ec 0c             	sub    $0xc,%esp
801005e7:	68 f5 8d 10 80       	push   $0x80108df5
801005ec:	e8 15 fe ff ff       	call   80100406 <cprintf>
801005f1:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005f4:	83 ec 08             	sub    $0x8,%esp
801005f7:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005fa:	50                   	push   %eax
801005fb:	8d 45 08             	lea    0x8(%ebp),%eax
801005fe:	50                   	push   %eax
801005ff:	e8 a2 4f 00 00       	call   801055a6 <getcallerpcs>
80100604:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100607:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010060e:	eb 1c                	jmp    8010062c <panic+0x89>
    cprintf(" %p", pcs[i]);
80100610:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100613:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100617:	83 ec 08             	sub    $0x8,%esp
8010061a:	50                   	push   %eax
8010061b:	68 f7 8d 10 80       	push   $0x80108df7
80100620:	e8 e1 fd ff ff       	call   80100406 <cprintf>
80100625:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
80100628:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010062c:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80100630:	7e de                	jle    80100610 <panic+0x6d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
80100632:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
80100639:	00 00 00 
  for(;;)
    ;
8010063c:	eb fe                	jmp    8010063c <panic+0x99>

8010063e <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
8010063e:	55                   	push   %ebp
8010063f:	89 e5                	mov    %esp,%ebp
80100641:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100644:	6a 0e                	push   $0xe
80100646:	68 d4 03 00 00       	push   $0x3d4
8010064b:	e8 e4 fc ff ff       	call   80100334 <outb>
80100650:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100653:	68 d5 03 00 00       	push   $0x3d5
80100658:	e8 ba fc ff ff       	call   80100317 <inb>
8010065d:	83 c4 04             	add    $0x4,%esp
80100660:	0f b6 c0             	movzbl %al,%eax
80100663:	c1 e0 08             	shl    $0x8,%eax
80100666:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100669:	6a 0f                	push   $0xf
8010066b:	68 d4 03 00 00       	push   $0x3d4
80100670:	e8 bf fc ff ff       	call   80100334 <outb>
80100675:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
80100678:	68 d5 03 00 00       	push   $0x3d5
8010067d:	e8 95 fc ff ff       	call   80100317 <inb>
80100682:	83 c4 04             	add    $0x4,%esp
80100685:	0f b6 c0             	movzbl %al,%eax
80100688:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010068b:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
8010068f:	75 30                	jne    801006c1 <cgaputc+0x83>
    pos += 80 - pos%80;
80100691:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100694:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100699:	89 c8                	mov    %ecx,%eax
8010069b:	f7 ea                	imul   %edx
8010069d:	c1 fa 05             	sar    $0x5,%edx
801006a0:	89 c8                	mov    %ecx,%eax
801006a2:	c1 f8 1f             	sar    $0x1f,%eax
801006a5:	29 c2                	sub    %eax,%edx
801006a7:	89 d0                	mov    %edx,%eax
801006a9:	c1 e0 02             	shl    $0x2,%eax
801006ac:	01 d0                	add    %edx,%eax
801006ae:	c1 e0 04             	shl    $0x4,%eax
801006b1:	29 c1                	sub    %eax,%ecx
801006b3:	89 ca                	mov    %ecx,%edx
801006b5:	b8 50 00 00 00       	mov    $0x50,%eax
801006ba:	29 d0                	sub    %edx,%eax
801006bc:	01 45 f4             	add    %eax,-0xc(%ebp)
801006bf:	eb 34                	jmp    801006f5 <cgaputc+0xb7>
  else if(c == BACKSPACE){
801006c1:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801006c8:	75 0c                	jne    801006d6 <cgaputc+0x98>
    if(pos > 0) --pos;
801006ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006ce:	7e 25                	jle    801006f5 <cgaputc+0xb7>
801006d0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801006d4:	eb 1f                	jmp    801006f5 <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801006d6:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
801006dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006df:	8d 50 01             	lea    0x1(%eax),%edx
801006e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006e5:	01 c0                	add    %eax,%eax
801006e7:	01 c8                	add    %ecx,%eax
801006e9:	8b 55 08             	mov    0x8(%ebp),%edx
801006ec:	0f b6 d2             	movzbl %dl,%edx
801006ef:	80 ce 07             	or     $0x7,%dh
801006f2:	66 89 10             	mov    %dx,(%eax)
  
  if((pos/80) >= 24){  // Scroll up.
801006f5:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006fc:	7e 4c                	jle    8010074a <cgaputc+0x10c>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006fe:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100703:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
80100709:	a1 00 a0 10 80       	mov    0x8010a000,%eax
8010070e:	83 ec 04             	sub    $0x4,%esp
80100711:	68 60 0e 00 00       	push   $0xe60
80100716:	52                   	push   %edx
80100717:	50                   	push   %eax
80100718:	e8 07 51 00 00       	call   80105824 <memmove>
8010071d:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
80100720:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100724:	b8 80 07 00 00       	mov    $0x780,%eax
80100729:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010072c:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010072f:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100734:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100737:	01 c9                	add    %ecx,%ecx
80100739:	01 c8                	add    %ecx,%eax
8010073b:	83 ec 04             	sub    $0x4,%esp
8010073e:	52                   	push   %edx
8010073f:	6a 00                	push   $0x0
80100741:	50                   	push   %eax
80100742:	e8 1e 50 00 00       	call   80105765 <memset>
80100747:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
8010074a:	83 ec 08             	sub    $0x8,%esp
8010074d:	6a 0e                	push   $0xe
8010074f:	68 d4 03 00 00       	push   $0x3d4
80100754:	e8 db fb ff ff       	call   80100334 <outb>
80100759:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010075c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010075f:	c1 f8 08             	sar    $0x8,%eax
80100762:	0f b6 c0             	movzbl %al,%eax
80100765:	83 ec 08             	sub    $0x8,%esp
80100768:	50                   	push   %eax
80100769:	68 d5 03 00 00       	push   $0x3d5
8010076e:	e8 c1 fb ff ff       	call   80100334 <outb>
80100773:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100776:	83 ec 08             	sub    $0x8,%esp
80100779:	6a 0f                	push   $0xf
8010077b:	68 d4 03 00 00       	push   $0x3d4
80100780:	e8 af fb ff ff       	call   80100334 <outb>
80100785:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
80100788:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010078b:	0f b6 c0             	movzbl %al,%eax
8010078e:	83 ec 08             	sub    $0x8,%esp
80100791:	50                   	push   %eax
80100792:	68 d5 03 00 00       	push   $0x3d5
80100797:	e8 98 fb ff ff       	call   80100334 <outb>
8010079c:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
8010079f:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801007a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801007a7:	01 d2                	add    %edx,%edx
801007a9:	01 d0                	add    %edx,%eax
801007ab:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
801007b0:	c9                   	leave  
801007b1:	c3                   	ret    

801007b2 <consputc>:

void
consputc(int c)
{
801007b2:	55                   	push   %ebp
801007b3:	89 e5                	mov    %esp,%ebp
801007b5:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
801007b8:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	74 07                	je     801007c8 <consputc+0x16>
    cli();
801007c1:	e8 8c fb ff ff       	call   80100352 <cli>
    for(;;)
      ;
801007c6:	eb fe                	jmp    801007c6 <consputc+0x14>
  }

  if(c == BACKSPACE){
801007c8:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007cf:	75 29                	jne    801007fa <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007d1:	83 ec 0c             	sub    $0xc,%esp
801007d4:	6a 08                	push   $0x8
801007d6:	e8 69 6c 00 00       	call   80107444 <uartputc>
801007db:	83 c4 10             	add    $0x10,%esp
801007de:	83 ec 0c             	sub    $0xc,%esp
801007e1:	6a 20                	push   $0x20
801007e3:	e8 5c 6c 00 00       	call   80107444 <uartputc>
801007e8:	83 c4 10             	add    $0x10,%esp
801007eb:	83 ec 0c             	sub    $0xc,%esp
801007ee:	6a 08                	push   $0x8
801007f0:	e8 4f 6c 00 00       	call   80107444 <uartputc>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	eb 0e                	jmp    80100808 <consputc+0x56>
  } else
    uartputc(c);
801007fa:	83 ec 0c             	sub    $0xc,%esp
801007fd:	ff 75 08             	pushl  0x8(%ebp)
80100800:	e8 3f 6c 00 00       	call   80107444 <uartputc>
80100805:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
80100808:	83 ec 0c             	sub    $0xc,%esp
8010080b:	ff 75 08             	pushl  0x8(%ebp)
8010080e:	e8 2b fe ff ff       	call   8010063e <cgaputc>
80100813:	83 c4 10             	add    $0x10,%esp
}
80100816:	c9                   	leave  
80100817:	c3                   	ret    

80100818 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100818:	55                   	push   %ebp
80100819:	89 e5                	mov    %esp,%ebp
8010081b:	83 ec 18             	sub    $0x18,%esp
  int c;

  acquire(&input.lock);
8010081e:	83 ec 0c             	sub    $0xc,%esp
80100821:	68 c0 17 11 80       	push   $0x801117c0
80100826:	e8 c4 4c 00 00       	call   801054ef <acquire>
8010082b:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
8010082e:	e9 43 01 00 00       	jmp    80100976 <consoleintr+0x15e>
    switch(c){
80100833:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100836:	83 f8 10             	cmp    $0x10,%eax
80100839:	74 1e                	je     80100859 <consoleintr+0x41>
8010083b:	83 f8 10             	cmp    $0x10,%eax
8010083e:	7f 0a                	jg     8010084a <consoleintr+0x32>
80100840:	83 f8 08             	cmp    $0x8,%eax
80100843:	74 67                	je     801008ac <consoleintr+0x94>
80100845:	e9 93 00 00 00       	jmp    801008dd <consoleintr+0xc5>
8010084a:	83 f8 15             	cmp    $0x15,%eax
8010084d:	74 31                	je     80100880 <consoleintr+0x68>
8010084f:	83 f8 7f             	cmp    $0x7f,%eax
80100852:	74 58                	je     801008ac <consoleintr+0x94>
80100854:	e9 84 00 00 00       	jmp    801008dd <consoleintr+0xc5>
    case C('P'):  // Process listing.
      procdump();
80100859:	e8 4f 47 00 00       	call   80104fad <procdump>
      break;
8010085e:	e9 13 01 00 00       	jmp    80100976 <consoleintr+0x15e>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100863:	a1 7c 18 11 80       	mov    0x8011187c,%eax
80100868:	83 e8 01             	sub    $0x1,%eax
8010086b:	a3 7c 18 11 80       	mov    %eax,0x8011187c
        consputc(BACKSPACE);
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 00 01 00 00       	push   $0x100
80100878:	e8 35 ff ff ff       	call   801007b2 <consputc>
8010087d:	83 c4 10             	add    $0x10,%esp
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100880:	8b 15 7c 18 11 80    	mov    0x8011187c,%edx
80100886:	a1 78 18 11 80       	mov    0x80111878,%eax
8010088b:	39 c2                	cmp    %eax,%edx
8010088d:	74 18                	je     801008a7 <consoleintr+0x8f>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010088f:	a1 7c 18 11 80       	mov    0x8011187c,%eax
80100894:	83 e8 01             	sub    $0x1,%eax
80100897:	83 e0 7f             	and    $0x7f,%eax
8010089a:	05 c0 17 11 80       	add    $0x801117c0,%eax
8010089f:	0f b6 40 34          	movzbl 0x34(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008a3:	3c 0a                	cmp    $0xa,%al
801008a5:	75 bc                	jne    80100863 <consoleintr+0x4b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008a7:	e9 ca 00 00 00       	jmp    80100976 <consoleintr+0x15e>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801008ac:	8b 15 7c 18 11 80    	mov    0x8011187c,%edx
801008b2:	a1 78 18 11 80       	mov    0x80111878,%eax
801008b7:	39 c2                	cmp    %eax,%edx
801008b9:	74 1d                	je     801008d8 <consoleintr+0xc0>
        input.e--;
801008bb:	a1 7c 18 11 80       	mov    0x8011187c,%eax
801008c0:	83 e8 01             	sub    $0x1,%eax
801008c3:	a3 7c 18 11 80       	mov    %eax,0x8011187c
        consputc(BACKSPACE);
801008c8:	83 ec 0c             	sub    $0xc,%esp
801008cb:	68 00 01 00 00       	push   $0x100
801008d0:	e8 dd fe ff ff       	call   801007b2 <consputc>
801008d5:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008d8:	e9 99 00 00 00       	jmp    80100976 <consoleintr+0x15e>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801008e1:	0f 84 8e 00 00 00    	je     80100975 <consoleintr+0x15d>
801008e7:	8b 15 7c 18 11 80    	mov    0x8011187c,%edx
801008ed:	a1 74 18 11 80       	mov    0x80111874,%eax
801008f2:	29 c2                	sub    %eax,%edx
801008f4:	89 d0                	mov    %edx,%eax
801008f6:	83 f8 7f             	cmp    $0x7f,%eax
801008f9:	77 7a                	ja     80100975 <consoleintr+0x15d>
        c = (c == '\r') ? '\n' : c;
801008fb:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
801008ff:	74 05                	je     80100906 <consoleintr+0xee>
80100901:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100904:	eb 05                	jmp    8010090b <consoleintr+0xf3>
80100906:	b8 0a 00 00 00       	mov    $0xa,%eax
8010090b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
8010090e:	a1 7c 18 11 80       	mov    0x8011187c,%eax
80100913:	8d 50 01             	lea    0x1(%eax),%edx
80100916:	89 15 7c 18 11 80    	mov    %edx,0x8011187c
8010091c:	83 e0 7f             	and    $0x7f,%eax
8010091f:	89 c2                	mov    %eax,%edx
80100921:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100924:	89 c1                	mov    %eax,%ecx
80100926:	8d 82 c0 17 11 80    	lea    -0x7feee840(%edx),%eax
8010092c:	88 48 34             	mov    %cl,0x34(%eax)
        consputc(c);
8010092f:	83 ec 0c             	sub    $0xc,%esp
80100932:	ff 75 f4             	pushl  -0xc(%ebp)
80100935:	e8 78 fe ff ff       	call   801007b2 <consputc>
8010093a:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010093d:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
80100941:	74 18                	je     8010095b <consoleintr+0x143>
80100943:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
80100947:	74 12                	je     8010095b <consoleintr+0x143>
80100949:	a1 7c 18 11 80       	mov    0x8011187c,%eax
8010094e:	8b 15 74 18 11 80    	mov    0x80111874,%edx
80100954:	83 ea 80             	sub    $0xffffff80,%edx
80100957:	39 d0                	cmp    %edx,%eax
80100959:	75 1a                	jne    80100975 <consoleintr+0x15d>
          input.w = input.e;
8010095b:	a1 7c 18 11 80       	mov    0x8011187c,%eax
80100960:	a3 78 18 11 80       	mov    %eax,0x80111878
          wakeup(&input.r);
80100965:	83 ec 0c             	sub    $0xc,%esp
80100968:	68 74 18 11 80       	push   $0x80111874
8010096d:	e8 81 45 00 00       	call   80104ef3 <wakeup>
80100972:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100975:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
80100976:	8b 45 08             	mov    0x8(%ebp),%eax
80100979:	ff d0                	call   *%eax
8010097b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010097e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100982:	0f 89 ab fe ff ff    	jns    80100833 <consoleintr+0x1b>
        }
      }
      break;
    }
  }
  release(&input.lock);
80100988:	83 ec 0c             	sub    $0xc,%esp
8010098b:	68 c0 17 11 80       	push   $0x801117c0
80100990:	e8 c0 4b 00 00       	call   80105555 <release>
80100995:	83 c4 10             	add    $0x10,%esp
}
80100998:	c9                   	leave  
80100999:	c3                   	ret    

8010099a <consoleread>:

//20160313--
int
consoleread(struct inode *ip, char *dst, int n)
{
8010099a:	55                   	push   %ebp
8010099b:	89 e5                	mov    %esp,%ebp
8010099d:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
801009a0:	83 ec 0c             	sub    $0xc,%esp
801009a3:	ff 75 08             	pushl  0x8(%ebp)
801009a6:	e8 65 11 00 00       	call   80101b10 <iunlock>
801009ab:	83 c4 10             	add    $0x10,%esp
  target = n;
801009ae:	8b 45 10             	mov    0x10(%ebp),%eax
801009b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
801009b4:	83 ec 0c             	sub    $0xc,%esp
801009b7:	68 c0 17 11 80       	push   $0x801117c0
801009bc:	e8 2e 4b 00 00       	call   801054ef <acquire>
801009c1:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009c4:	e9 b4 00 00 00       	jmp    80100a7d <consoleread+0xe3>
    while(input.r == input.w){
801009c9:	eb 4a                	jmp    80100a15 <consoleread+0x7b>
      if(proc->killed){
801009cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801009d1:	8b 40 24             	mov    0x24(%eax),%eax
801009d4:	85 c0                	test   %eax,%eax
801009d6:	74 28                	je     80100a00 <consoleread+0x66>
        release(&input.lock);
801009d8:	83 ec 0c             	sub    $0xc,%esp
801009db:	68 c0 17 11 80       	push   $0x801117c0
801009e0:	e8 70 4b 00 00       	call   80105555 <release>
801009e5:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
801009e8:	83 ec 0c             	sub    $0xc,%esp
801009eb:	ff 75 08             	pushl  0x8(%ebp)
801009ee:	e8 98 0f 00 00       	call   8010198b <ilock>
801009f3:	83 c4 10             	add    $0x10,%esp
        return -1;
801009f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009fb:	e9 af 00 00 00       	jmp    80100aaf <consoleread+0x115>
      }
      sleep(&input.r, &input.lock);
80100a00:	83 ec 08             	sub    $0x8,%esp
80100a03:	68 c0 17 11 80       	push   $0x801117c0
80100a08:	68 74 18 11 80       	push   $0x80111874
80100a0d:	e8 f8 43 00 00       	call   80104e0a <sleep>
80100a12:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
80100a15:	8b 15 74 18 11 80    	mov    0x80111874,%edx
80100a1b:	a1 78 18 11 80       	mov    0x80111878,%eax
80100a20:	39 c2                	cmp    %eax,%edx
80100a22:	74 a7                	je     801009cb <consoleread+0x31>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a24:	a1 74 18 11 80       	mov    0x80111874,%eax
80100a29:	8d 50 01             	lea    0x1(%eax),%edx
80100a2c:	89 15 74 18 11 80    	mov    %edx,0x80111874
80100a32:	83 e0 7f             	and    $0x7f,%eax
80100a35:	05 c0 17 11 80       	add    $0x801117c0,%eax
80100a3a:	0f b6 40 34          	movzbl 0x34(%eax),%eax
80100a3e:	0f be c0             	movsbl %al,%eax
80100a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a44:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a48:	75 19                	jne    80100a63 <consoleread+0xc9>
      if(n < target){
80100a4a:	8b 45 10             	mov    0x10(%ebp),%eax
80100a4d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a50:	73 0f                	jae    80100a61 <consoleread+0xc7>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a52:	a1 74 18 11 80       	mov    0x80111874,%eax
80100a57:	83 e8 01             	sub    $0x1,%eax
80100a5a:	a3 74 18 11 80       	mov    %eax,0x80111874
      }
      break;
80100a5f:	eb 26                	jmp    80100a87 <consoleread+0xed>
80100a61:	eb 24                	jmp    80100a87 <consoleread+0xed>
    }
    *dst++ = c;
80100a63:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a66:	8d 50 01             	lea    0x1(%eax),%edx
80100a69:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a6c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a6f:	88 10                	mov    %dl,(%eax)
    --n;
80100a71:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a75:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a79:	75 02                	jne    80100a7d <consoleread+0xe3>
      break;
80100a7b:	eb 0a                	jmp    80100a87 <consoleread+0xed>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
80100a7d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a81:	0f 8f 42 ff ff ff    	jg     801009c9 <consoleread+0x2f>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
80100a87:	83 ec 0c             	sub    $0xc,%esp
80100a8a:	68 c0 17 11 80       	push   $0x801117c0
80100a8f:	e8 c1 4a 00 00       	call   80105555 <release>
80100a94:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a97:	83 ec 0c             	sub    $0xc,%esp
80100a9a:	ff 75 08             	pushl  0x8(%ebp)
80100a9d:	e8 e9 0e 00 00       	call   8010198b <ilock>
80100aa2:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100aa5:	8b 45 10             	mov    0x10(%ebp),%eax
80100aa8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100aab:	29 c2                	sub    %eax,%edx
80100aad:	89 d0                	mov    %edx,%eax
}
80100aaf:	c9                   	leave  
80100ab0:	c3                   	ret    

80100ab1 <consolewrite>:

int
//20160313--
consolewrite(struct inode *ip, char *buf, int n)
{
80100ab1:	55                   	push   %ebp
80100ab2:	89 e5                	mov    %esp,%ebp
80100ab4:	83 ec 18             	sub    $0x18,%esp
  int i;

//20160313--
  iunlock(ip);
80100ab7:	83 ec 0c             	sub    $0xc,%esp
80100aba:	ff 75 08             	pushl  0x8(%ebp)
80100abd:	e8 4e 10 00 00       	call   80101b10 <iunlock>
80100ac2:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100ac5:	83 ec 0c             	sub    $0xc,%esp
80100ac8:	68 e0 c5 10 80       	push   $0x8010c5e0
80100acd:	e8 1d 4a 00 00       	call   801054ef <acquire>
80100ad2:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100ad5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100adc:	eb 21                	jmp    80100aff <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100ade:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ae4:	01 d0                	add    %edx,%eax
80100ae6:	0f b6 00             	movzbl (%eax),%eax
80100ae9:	0f be c0             	movsbl %al,%eax
80100aec:	0f b6 c0             	movzbl %al,%eax
80100aef:	83 ec 0c             	sub    $0xc,%esp
80100af2:	50                   	push   %eax
80100af3:	e8 ba fc ff ff       	call   801007b2 <consputc>
80100af8:	83 c4 10             	add    $0x10,%esp
  int i;

//20160313--
  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100afb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b02:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b05:	7c d7                	jl     80100ade <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100b07:	83 ec 0c             	sub    $0xc,%esp
80100b0a:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b0f:	e8 41 4a 00 00       	call   80105555 <release>
80100b14:	83 c4 10             	add    $0x10,%esp
//20160313--
  ilock(ip);
80100b17:	83 ec 0c             	sub    $0xc,%esp
80100b1a:	ff 75 08             	pushl  0x8(%ebp)
80100b1d:	e8 69 0e 00 00       	call   8010198b <ilock>
80100b22:	83 c4 10             	add    $0x10,%esp

  return n;
80100b25:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b28:	c9                   	leave  
80100b29:	c3                   	ret    

80100b2a <consoleinit>:

void
consoleinit(void)
{
80100b2a:	55                   	push   %ebp
80100b2b:	89 e5                	mov    %esp,%ebp
80100b2d:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b30:	83 ec 08             	sub    $0x8,%esp
80100b33:	68 fb 8d 10 80       	push   $0x80108dfb
80100b38:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b3d:	e8 8c 49 00 00       	call   801054ce <initlock>
80100b42:	83 c4 10             	add    $0x10,%esp
  initlock(&input.lock, "input");
80100b45:	83 ec 08             	sub    $0x8,%esp
80100b48:	68 03 8e 10 80       	push   $0x80108e03
80100b4d:	68 c0 17 11 80       	push   $0x801117c0
80100b52:	e8 77 49 00 00       	call   801054ce <initlock>
80100b57:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b5a:	c7 05 4c 22 11 80 b1 	movl   $0x80100ab1,0x8011224c
80100b61:	0a 10 80 
//20160313--
  devsw[CONSOLE].read = consoleread;
80100b64:	c7 05 48 22 11 80 9a 	movl   $0x8010099a,0x80112248
80100b6b:	09 10 80 
  cons.locking = 1;
80100b6e:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100b75:	00 00 00 

  picenable(IRQ_KBD);
80100b78:	83 ec 0c             	sub    $0xc,%esp
80100b7b:	6a 01                	push   $0x1
80100b7d:	e8 de 45 00 00       	call   80105160 <picenable>
80100b82:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b85:	83 ec 08             	sub    $0x8,%esp
80100b88:	6a 00                	push   $0x0
80100b8a:	6a 01                	push   $0x1
80100b8c:	e8 cc 1f 00 00       	call   80102b5d <ioapicenable>
80100b91:	83 c4 10             	add    $0x10,%esp
}
80100b94:	c9                   	leave  
80100b95:	c3                   	ret    

80100b96 <exec>:
#include "fs.h"
#include "file.h"

int
exec(char *path, char **argv)
{
80100b96:	55                   	push   %ebp
80100b97:	89 e5                	mov    %esp,%ebp
80100b99:	81 ec 18 01 00 00    	sub    $0x118,%esp

//cprintf("exec.c::int exec(char *path, char **argv)\n");
//cprintf("%s\n",path);
//cprintf("%s\n",argv[0]);
//cprintf("sizeof(struct inode)=%d\n",sizeof(struct inode));
  begin_op();
80100b9f:	e8 da 2c 00 00       	call   8010387e <begin_op>
  if((ip = namei(path)) == 0){
80100ba4:	83 ec 0c             	sub    $0xc,%esp
80100ba7:	ff 75 08             	pushl  0x8(%ebp)
80100baa:	e8 05 1a 00 00       	call   801025b4 <namei>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100bb5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100bb9:	75 0f                	jne    80100bca <exec+0x34>
    end_op();
80100bbb:	e8 4c 2d 00 00       	call   8010390c <end_op>
    return -1;
80100bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bc5:	e9 b9 03 00 00       	jmp    80100f83 <exec+0x3ed>
  }
//cprintf("ip=%p\n",ip);
  ilock(ip);
80100bca:	83 ec 0c             	sub    $0xc,%esp
80100bcd:	ff 75 d8             	pushl  -0x28(%ebp)
80100bd0:	e8 b6 0d 00 00       	call   8010198b <ilock>
80100bd5:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100bd8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100bdf:	6a 34                	push   $0x34
80100be1:	6a 00                	push   $0x0
80100be3:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100be9:	50                   	push   %eax
80100bea:	ff 75 d8             	pushl  -0x28(%ebp)
80100bed:	e8 51 13 00 00       	call   80101f43 <readi>
80100bf2:	83 c4 10             	add    $0x10,%esp
80100bf5:	83 f8 33             	cmp    $0x33,%eax
80100bf8:	77 05                	ja     80100bff <exec+0x69>
    goto bad;
80100bfa:	e9 52 03 00 00       	jmp    80100f51 <exec+0x3bb>
  if(elf.magic != ELF_MAGIC)
80100bff:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c05:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c0a:	74 05                	je     80100c11 <exec+0x7b>
    goto bad;
80100c0c:	e9 40 03 00 00       	jmp    80100f51 <exec+0x3bb>

  if((pgdir = setupkvm()) == 0)
80100c11:	e8 7e 79 00 00       	call   80108594 <setupkvm>
80100c16:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c19:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c1d:	75 05                	jne    80100c24 <exec+0x8e>
    goto bad;
80100c1f:	e9 2d 03 00 00       	jmp    80100f51 <exec+0x3bb>

  // Load program into memory.
  sz = 0;
80100c24:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c2b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c32:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100c38:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c3b:	e9 ae 00 00 00       	jmp    80100cee <exec+0x158>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c40:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c43:	6a 20                	push   $0x20
80100c45:	50                   	push   %eax
80100c46:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100c4c:	50                   	push   %eax
80100c4d:	ff 75 d8             	pushl  -0x28(%ebp)
80100c50:	e8 ee 12 00 00       	call   80101f43 <readi>
80100c55:	83 c4 10             	add    $0x10,%esp
80100c58:	83 f8 20             	cmp    $0x20,%eax
80100c5b:	74 05                	je     80100c62 <exec+0xcc>
      goto bad;
80100c5d:	e9 ef 02 00 00       	jmp    80100f51 <exec+0x3bb>
    if(ph.type != ELF_PROG_LOAD)
80100c62:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c68:	83 f8 01             	cmp    $0x1,%eax
80100c6b:	74 02                	je     80100c6f <exec+0xd9>
      continue;
80100c6d:	eb 72                	jmp    80100ce1 <exec+0x14b>
    if(ph.memsz < ph.filesz)
80100c6f:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c75:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c7b:	39 c2                	cmp    %eax,%edx
80100c7d:	73 05                	jae    80100c84 <exec+0xee>
      goto bad;
80100c7f:	e9 cd 02 00 00       	jmp    80100f51 <exec+0x3bb>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c84:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c8a:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c90:	01 d0                	add    %edx,%eax
80100c92:	83 ec 04             	sub    $0x4,%esp
80100c95:	50                   	push   %eax
80100c96:	ff 75 e0             	pushl  -0x20(%ebp)
80100c99:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c9c:	e8 96 7c 00 00       	call   80108937 <allocuvm>
80100ca1:	83 c4 10             	add    $0x10,%esp
80100ca4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100ca7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cab:	75 05                	jne    80100cb2 <exec+0x11c>
      goto bad;
80100cad:	e9 9f 02 00 00       	jmp    80100f51 <exec+0x3bb>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100cb2:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100cb8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cbe:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100cc4:	83 ec 0c             	sub    $0xc,%esp
80100cc7:	52                   	push   %edx
80100cc8:	50                   	push   %eax
80100cc9:	ff 75 d8             	pushl  -0x28(%ebp)
80100ccc:	51                   	push   %ecx
80100ccd:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cd0:	e8 8b 7b 00 00       	call   80108860 <loaduvm>
80100cd5:	83 c4 20             	add    $0x20,%esp
80100cd8:	85 c0                	test   %eax,%eax
80100cda:	79 05                	jns    80100ce1 <exec+0x14b>
      goto bad;
80100cdc:	e9 70 02 00 00       	jmp    80100f51 <exec+0x3bb>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ce1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100ce5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100ce8:	83 c0 20             	add    $0x20,%eax
80100ceb:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cee:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100cf5:	0f b7 c0             	movzwl %ax,%eax
80100cf8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100cfb:	0f 8f 3f ff ff ff    	jg     80100c40 <exec+0xaa>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100d01:	83 ec 0c             	sub    $0xc,%esp
80100d04:	ff 75 d8             	pushl  -0x28(%ebp)
80100d07:	e8 64 0f 00 00       	call   80101c70 <iunlockput>
80100d0c:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d0f:	e8 f8 2b 00 00       	call   8010390c <end_op>
  ip = 0;
80100d14:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d1e:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d28:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d2e:	05 00 20 00 00       	add    $0x2000,%eax
80100d33:	83 ec 04             	sub    $0x4,%esp
80100d36:	50                   	push   %eax
80100d37:	ff 75 e0             	pushl  -0x20(%ebp)
80100d3a:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d3d:	e8 f5 7b 00 00       	call   80108937 <allocuvm>
80100d42:	83 c4 10             	add    $0x10,%esp
80100d45:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d48:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d4c:	75 05                	jne    80100d53 <exec+0x1bd>
    goto bad;
80100d4e:	e9 fe 01 00 00       	jmp    80100f51 <exec+0x3bb>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d53:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d56:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d5b:	83 ec 08             	sub    $0x8,%esp
80100d5e:	50                   	push   %eax
80100d5f:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d62:	e8 f5 7d 00 00       	call   80108b5c <clearpteu>
80100d67:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100d6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d6d:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d70:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d77:	e9 98 00 00 00       	jmp    80100e14 <exec+0x27e>
    if(argc >= MAXARG)
80100d7c:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d80:	76 05                	jbe    80100d87 <exec+0x1f1>
      goto bad;
80100d82:	e9 ca 01 00 00       	jmp    80100f51 <exec+0x3bb>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d8a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d91:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d94:	01 d0                	add    %edx,%eax
80100d96:	8b 00                	mov    (%eax),%eax
80100d98:	83 ec 0c             	sub    $0xc,%esp
80100d9b:	50                   	push   %eax
80100d9c:	e8 13 4c 00 00       	call   801059b4 <strlen>
80100da1:	83 c4 10             	add    $0x10,%esp
80100da4:	89 c2                	mov    %eax,%edx
80100da6:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100da9:	29 d0                	sub    %edx,%eax
80100dab:	83 e8 01             	sub    $0x1,%eax
80100dae:	83 e0 fc             	and    $0xfffffffc,%eax
80100db1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100db4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100db7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dc1:	01 d0                	add    %edx,%eax
80100dc3:	8b 00                	mov    (%eax),%eax
80100dc5:	83 ec 0c             	sub    $0xc,%esp
80100dc8:	50                   	push   %eax
80100dc9:	e8 e6 4b 00 00       	call   801059b4 <strlen>
80100dce:	83 c4 10             	add    $0x10,%esp
80100dd1:	83 c0 01             	add    $0x1,%eax
80100dd4:	89 c1                	mov    %eax,%ecx
80100dd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100de0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100de3:	01 d0                	add    %edx,%eax
80100de5:	8b 00                	mov    (%eax),%eax
80100de7:	51                   	push   %ecx
80100de8:	50                   	push   %eax
80100de9:	ff 75 dc             	pushl  -0x24(%ebp)
80100dec:	ff 75 d4             	pushl  -0x2c(%ebp)
80100def:	e8 1e 7f 00 00       	call   80108d12 <copyout>
80100df4:	83 c4 10             	add    $0x10,%esp
80100df7:	85 c0                	test   %eax,%eax
80100df9:	79 05                	jns    80100e00 <exec+0x26a>
      goto bad;
80100dfb:	e9 51 01 00 00       	jmp    80100f51 <exec+0x3bb>
    ustack[3+argc] = sp;
80100e00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e03:	8d 50 03             	lea    0x3(%eax),%edx
80100e06:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e09:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e10:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e17:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e21:	01 d0                	add    %edx,%eax
80100e23:	8b 00                	mov    (%eax),%eax
80100e25:	85 c0                	test   %eax,%eax
80100e27:	0f 85 4f ff ff ff    	jne    80100d7c <exec+0x1e6>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100e2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e30:	83 c0 03             	add    $0x3,%eax
80100e33:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100e3a:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e3e:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100e45:	ff ff ff 
  ustack[1] = argc;
80100e48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e4b:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e54:	83 c0 01             	add    $0x1,%eax
80100e57:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e61:	29 d0                	sub    %edx,%eax
80100e63:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e6c:	83 c0 04             	add    $0x4,%eax
80100e6f:	c1 e0 02             	shl    $0x2,%eax
80100e72:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e78:	83 c0 04             	add    $0x4,%eax
80100e7b:	c1 e0 02             	shl    $0x2,%eax
80100e7e:	50                   	push   %eax
80100e7f:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e85:	50                   	push   %eax
80100e86:	ff 75 dc             	pushl  -0x24(%ebp)
80100e89:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e8c:	e8 81 7e 00 00       	call   80108d12 <copyout>
80100e91:	83 c4 10             	add    $0x10,%esp
80100e94:	85 c0                	test   %eax,%eax
80100e96:	79 05                	jns    80100e9d <exec+0x307>
    goto bad;
80100e98:	e9 b4 00 00 00       	jmp    80100f51 <exec+0x3bb>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e9d:	8b 45 08             	mov    0x8(%ebp),%eax
80100ea0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ea6:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100ea9:	eb 17                	jmp    80100ec2 <exec+0x32c>
    if(*s == '/')
80100eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eae:	0f b6 00             	movzbl (%eax),%eax
80100eb1:	3c 2f                	cmp    $0x2f,%al
80100eb3:	75 09                	jne    80100ebe <exec+0x328>
      last = s+1;
80100eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eb8:	83 c0 01             	add    $0x1,%eax
80100ebb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ebe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ec5:	0f b6 00             	movzbl (%eax),%eax
80100ec8:	84 c0                	test   %al,%al
80100eca:	75 df                	jne    80100eab <exec+0x315>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100ecc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed2:	83 c0 6c             	add    $0x6c,%eax
80100ed5:	83 ec 04             	sub    $0x4,%esp
80100ed8:	6a 10                	push   $0x10
80100eda:	ff 75 f0             	pushl  -0x10(%ebp)
80100edd:	50                   	push   %eax
80100ede:	e8 87 4a 00 00       	call   8010596a <safestrcpy>
80100ee3:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100ee6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eec:	8b 40 04             	mov    0x4(%eax),%eax
80100eef:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100ef2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ef8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100efb:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100efe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f04:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f07:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100f09:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f0f:	8b 40 18             	mov    0x18(%eax),%eax
80100f12:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100f18:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100f1b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f21:	8b 40 18             	mov    0x18(%eax),%eax
80100f24:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f27:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100f2a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f30:	83 ec 0c             	sub    $0xc,%esp
80100f33:	50                   	push   %eax
80100f34:	e8 40 77 00 00       	call   80108679 <switchuvm>
80100f39:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f3c:	83 ec 0c             	sub    $0xc,%esp
80100f3f:	ff 75 d0             	pushl  -0x30(%ebp)
80100f42:	e8 76 7b 00 00       	call   80108abd <freevm>
80100f47:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f4a:	b8 00 00 00 00       	mov    $0x0,%eax
80100f4f:	eb 32                	jmp    80100f83 <exec+0x3ed>

 bad:
  if(pgdir)
80100f51:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f55:	74 0e                	je     80100f65 <exec+0x3cf>
    freevm(pgdir);
80100f57:	83 ec 0c             	sub    $0xc,%esp
80100f5a:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f5d:	e8 5b 7b 00 00       	call   80108abd <freevm>
80100f62:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100f65:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f69:	74 13                	je     80100f7e <exec+0x3e8>
    iunlockput(ip);
80100f6b:	83 ec 0c             	sub    $0xc,%esp
80100f6e:	ff 75 d8             	pushl  -0x28(%ebp)
80100f71:	e8 fa 0c 00 00       	call   80101c70 <iunlockput>
80100f76:	83 c4 10             	add    $0x10,%esp
    end_op();
80100f79:	e8 8e 29 00 00       	call   8010390c <end_op>
  }
  return -1;
80100f7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f83:	c9                   	leave  
80100f84:	c3                   	ret    

80100f85 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f85:	55                   	push   %ebp
80100f86:	89 e5                	mov    %esp,%ebp
80100f88:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100f8b:	83 ec 08             	sub    $0x8,%esp
80100f8e:	68 09 8e 10 80       	push   $0x80108e09
80100f93:	68 80 18 11 80       	push   $0x80111880
80100f98:	e8 31 45 00 00       	call   801054ce <initlock>
80100f9d:	83 c4 10             	add    $0x10,%esp
}
80100fa0:	c9                   	leave  
80100fa1:	c3                   	ret    

80100fa2 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100fa2:	55                   	push   %ebp
80100fa3:	89 e5                	mov    %esp,%ebp
80100fa5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	68 80 18 11 80       	push   $0x80111880
80100fb0:	e8 3a 45 00 00       	call   801054ef <acquire>
80100fb5:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fb8:	c7 45 f4 b4 18 11 80 	movl   $0x801118b4,-0xc(%ebp)
80100fbf:	eb 2d                	jmp    80100fee <filealloc+0x4c>
    if(f->ref == 0){
80100fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fc4:	8b 40 04             	mov    0x4(%eax),%eax
80100fc7:	85 c0                	test   %eax,%eax
80100fc9:	75 1f                	jne    80100fea <filealloc+0x48>
      f->ref = 1;
80100fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fce:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100fd5:	83 ec 0c             	sub    $0xc,%esp
80100fd8:	68 80 18 11 80       	push   $0x80111880
80100fdd:	e8 73 45 00 00       	call   80105555 <release>
80100fe2:	83 c4 10             	add    $0x10,%esp
      return f;
80100fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fe8:	eb 22                	jmp    8010100c <filealloc+0x6a>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fea:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100fee:	81 7d f4 14 22 11 80 	cmpl   $0x80112214,-0xc(%ebp)
80100ff5:	72 ca                	jb     80100fc1 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100ff7:	83 ec 0c             	sub    $0xc,%esp
80100ffa:	68 80 18 11 80       	push   $0x80111880
80100fff:	e8 51 45 00 00       	call   80105555 <release>
80101004:	83 c4 10             	add    $0x10,%esp
  return 0;
80101007:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010100c:	c9                   	leave  
8010100d:	c3                   	ret    

8010100e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
8010100e:	55                   	push   %ebp
8010100f:	89 e5                	mov    %esp,%ebp
80101011:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101014:	83 ec 0c             	sub    $0xc,%esp
80101017:	68 80 18 11 80       	push   $0x80111880
8010101c:	e8 ce 44 00 00       	call   801054ef <acquire>
80101021:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101024:	8b 45 08             	mov    0x8(%ebp),%eax
80101027:	8b 40 04             	mov    0x4(%eax),%eax
8010102a:	85 c0                	test   %eax,%eax
8010102c:	7f 0d                	jg     8010103b <filedup+0x2d>
    panic("filedup");
8010102e:	83 ec 0c             	sub    $0xc,%esp
80101031:	68 10 8e 10 80       	push   $0x80108e10
80101036:	e8 68 f5 ff ff       	call   801005a3 <panic>
  f->ref++;
8010103b:	8b 45 08             	mov    0x8(%ebp),%eax
8010103e:	8b 40 04             	mov    0x4(%eax),%eax
80101041:	8d 50 01             	lea    0x1(%eax),%edx
80101044:	8b 45 08             	mov    0x8(%ebp),%eax
80101047:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010104a:	83 ec 0c             	sub    $0xc,%esp
8010104d:	68 80 18 11 80       	push   $0x80111880
80101052:	e8 fe 44 00 00       	call   80105555 <release>
80101057:	83 c4 10             	add    $0x10,%esp
  return f;
8010105a:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010105d:	c9                   	leave  
8010105e:	c3                   	ret    

8010105f <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
8010105f:	55                   	push   %ebp
80101060:	89 e5                	mov    %esp,%ebp
80101062:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
80101065:	83 ec 0c             	sub    $0xc,%esp
80101068:	68 80 18 11 80       	push   $0x80111880
8010106d:	e8 7d 44 00 00       	call   801054ef <acquire>
80101072:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101075:	8b 45 08             	mov    0x8(%ebp),%eax
80101078:	8b 40 04             	mov    0x4(%eax),%eax
8010107b:	85 c0                	test   %eax,%eax
8010107d:	7f 0d                	jg     8010108c <fileclose+0x2d>
    panic("fileclose");
8010107f:	83 ec 0c             	sub    $0xc,%esp
80101082:	68 18 8e 10 80       	push   $0x80108e18
80101087:	e8 17 f5 ff ff       	call   801005a3 <panic>
  if(--f->ref > 0){
8010108c:	8b 45 08             	mov    0x8(%ebp),%eax
8010108f:	8b 40 04             	mov    0x4(%eax),%eax
80101092:	8d 50 ff             	lea    -0x1(%eax),%edx
80101095:	8b 45 08             	mov    0x8(%ebp),%eax
80101098:	89 50 04             	mov    %edx,0x4(%eax)
8010109b:	8b 45 08             	mov    0x8(%ebp),%eax
8010109e:	8b 40 04             	mov    0x4(%eax),%eax
801010a1:	85 c0                	test   %eax,%eax
801010a3:	7e 15                	jle    801010ba <fileclose+0x5b>
    release(&ftable.lock);
801010a5:	83 ec 0c             	sub    $0xc,%esp
801010a8:	68 80 18 11 80       	push   $0x80111880
801010ad:	e8 a3 44 00 00       	call   80105555 <release>
801010b2:	83 c4 10             	add    $0x10,%esp
801010b5:	e9 8b 00 00 00       	jmp    80101145 <fileclose+0xe6>
    return;
  }
  ff = *f;
801010ba:	8b 45 08             	mov    0x8(%ebp),%eax
801010bd:	8b 10                	mov    (%eax),%edx
801010bf:	89 55 e0             	mov    %edx,-0x20(%ebp)
801010c2:	8b 50 04             	mov    0x4(%eax),%edx
801010c5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801010c8:	8b 50 08             	mov    0x8(%eax),%edx
801010cb:	89 55 e8             	mov    %edx,-0x18(%ebp)
801010ce:	8b 50 0c             	mov    0xc(%eax),%edx
801010d1:	89 55 ec             	mov    %edx,-0x14(%ebp)
801010d4:	8b 50 10             	mov    0x10(%eax),%edx
801010d7:	89 55 f0             	mov    %edx,-0x10(%ebp)
801010da:	8b 40 14             	mov    0x14(%eax),%eax
801010dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
801010e0:	8b 45 08             	mov    0x8(%ebp),%eax
801010e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801010ea:	8b 45 08             	mov    0x8(%ebp),%eax
801010ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801010f3:	83 ec 0c             	sub    $0xc,%esp
801010f6:	68 80 18 11 80       	push   $0x80111880
801010fb:	e8 55 44 00 00       	call   80105555 <release>
80101100:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
80101103:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101106:	83 f8 01             	cmp    $0x1,%eax
80101109:	75 19                	jne    80101124 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
8010110b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
8010110f:	0f be d0             	movsbl %al,%edx
80101112:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101115:	83 ec 08             	sub    $0x8,%esp
80101118:	52                   	push   %edx
80101119:	50                   	push   %eax
8010111a:	e8 7a 31 00 00       	call   80104299 <pipeclose>
8010111f:	83 c4 10             	add    $0x10,%esp
80101122:	eb 21                	jmp    80101145 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
80101124:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101127:	83 f8 02             	cmp    $0x2,%eax
8010112a:	75 19                	jne    80101145 <fileclose+0xe6>
//20160313--
    begin_op();
8010112c:	e8 4d 27 00 00       	call   8010387e <begin_op>
    iput(ff.ip);
80101131:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101134:	83 ec 0c             	sub    $0xc,%esp
80101137:	50                   	push   %eax
80101138:	e8 44 0a 00 00       	call   80101b81 <iput>
8010113d:	83 c4 10             	add    $0x10,%esp
    end_op();
80101140:	e8 c7 27 00 00       	call   8010390c <end_op>
  }
}
80101145:	c9                   	leave  
80101146:	c3                   	ret    

80101147 <filestat>:

//20160313--
// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101147:	55                   	push   %ebp
80101148:	89 e5                	mov    %esp,%ebp
8010114a:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
8010114d:	8b 45 08             	mov    0x8(%ebp),%eax
80101150:	8b 00                	mov    (%eax),%eax
80101152:	83 f8 02             	cmp    $0x2,%eax
80101155:	75 40                	jne    80101197 <filestat+0x50>
    ilock(f->ip);
80101157:	8b 45 08             	mov    0x8(%ebp),%eax
8010115a:	8b 40 10             	mov    0x10(%eax),%eax
8010115d:	83 ec 0c             	sub    $0xc,%esp
80101160:	50                   	push   %eax
80101161:	e8 25 08 00 00       	call   8010198b <ilock>
80101166:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
80101169:	8b 45 08             	mov    0x8(%ebp),%eax
8010116c:	8b 40 10             	mov    0x10(%eax),%eax
8010116f:	83 ec 08             	sub    $0x8,%esp
80101172:	ff 75 0c             	pushl  0xc(%ebp)
80101175:	50                   	push   %eax
80101176:	e8 5b 0d 00 00       	call   80101ed6 <stati>
8010117b:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
8010117e:	8b 45 08             	mov    0x8(%ebp),%eax
80101181:	8b 40 10             	mov    0x10(%eax),%eax
80101184:	83 ec 0c             	sub    $0xc,%esp
80101187:	50                   	push   %eax
80101188:	e8 83 09 00 00       	call   80101b10 <iunlock>
8010118d:	83 c4 10             	add    $0x10,%esp
    return 0;
80101190:	b8 00 00 00 00       	mov    $0x0,%eax
80101195:	eb 05                	jmp    8010119c <filestat+0x55>
  }
  return -1;
80101197:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010119c:	c9                   	leave  
8010119d:	c3                   	ret    

8010119e <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
8010119e:	55                   	push   %ebp
8010119f:	89 e5                	mov    %esp,%ebp
801011a1:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801011a4:	8b 45 08             	mov    0x8(%ebp),%eax
801011a7:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801011ab:	84 c0                	test   %al,%al
801011ad:	75 0a                	jne    801011b9 <fileread+0x1b>
    return -1;
801011af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011b4:	e9 9b 00 00 00       	jmp    80101254 <fileread+0xb6>
  if(f->type == FD_PIPE)
801011b9:	8b 45 08             	mov    0x8(%ebp),%eax
801011bc:	8b 00                	mov    (%eax),%eax
801011be:	83 f8 01             	cmp    $0x1,%eax
801011c1:	75 1a                	jne    801011dd <fileread+0x3f>
    return piperead(f->pipe, addr, n);
801011c3:	8b 45 08             	mov    0x8(%ebp),%eax
801011c6:	8b 40 0c             	mov    0xc(%eax),%eax
801011c9:	83 ec 04             	sub    $0x4,%esp
801011cc:	ff 75 10             	pushl  0x10(%ebp)
801011cf:	ff 75 0c             	pushl  0xc(%ebp)
801011d2:	50                   	push   %eax
801011d3:	e8 6e 32 00 00       	call   80104446 <piperead>
801011d8:	83 c4 10             	add    $0x10,%esp
801011db:	eb 77                	jmp    80101254 <fileread+0xb6>
  if(f->type == FD_INODE){
801011dd:	8b 45 08             	mov    0x8(%ebp),%eax
801011e0:	8b 00                	mov    (%eax),%eax
801011e2:	83 f8 02             	cmp    $0x2,%eax
801011e5:	75 60                	jne    80101247 <fileread+0xa9>
    ilock(f->ip);
801011e7:	8b 45 08             	mov    0x8(%ebp),%eax
801011ea:	8b 40 10             	mov    0x10(%eax),%eax
801011ed:	83 ec 0c             	sub    $0xc,%esp
801011f0:	50                   	push   %eax
801011f1:	e8 95 07 00 00       	call   8010198b <ilock>
801011f6:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011fc:	8b 45 08             	mov    0x8(%ebp),%eax
801011ff:	8b 50 14             	mov    0x14(%eax),%edx
80101202:	8b 45 08             	mov    0x8(%ebp),%eax
80101205:	8b 40 10             	mov    0x10(%eax),%eax
80101208:	51                   	push   %ecx
80101209:	52                   	push   %edx
8010120a:	ff 75 0c             	pushl  0xc(%ebp)
8010120d:	50                   	push   %eax
8010120e:	e8 30 0d 00 00       	call   80101f43 <readi>
80101213:	83 c4 10             	add    $0x10,%esp
80101216:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101219:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010121d:	7e 11                	jle    80101230 <fileread+0x92>
      f->off += r;
8010121f:	8b 45 08             	mov    0x8(%ebp),%eax
80101222:	8b 50 14             	mov    0x14(%eax),%edx
80101225:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101228:	01 c2                	add    %eax,%edx
8010122a:	8b 45 08             	mov    0x8(%ebp),%eax
8010122d:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101230:	8b 45 08             	mov    0x8(%ebp),%eax
80101233:	8b 40 10             	mov    0x10(%eax),%eax
80101236:	83 ec 0c             	sub    $0xc,%esp
80101239:	50                   	push   %eax
8010123a:	e8 d1 08 00 00       	call   80101b10 <iunlock>
8010123f:	83 c4 10             	add    $0x10,%esp
    return r;
80101242:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101245:	eb 0d                	jmp    80101254 <fileread+0xb6>
  }
  panic("fileread");
80101247:	83 ec 0c             	sub    $0xc,%esp
8010124a:	68 22 8e 10 80       	push   $0x80108e22
8010124f:	e8 4f f3 ff ff       	call   801005a3 <panic>
}
80101254:	c9                   	leave  
80101255:	c3                   	ret    

80101256 <filewrite>:
//20160313--
//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101256:	55                   	push   %ebp
80101257:	89 e5                	mov    %esp,%ebp
80101259:	53                   	push   %ebx
8010125a:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
8010125d:	8b 45 08             	mov    0x8(%ebp),%eax
80101260:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80101264:	84 c0                	test   %al,%al
80101266:	75 0a                	jne    80101272 <filewrite+0x1c>
    return -1;
80101268:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010126d:	e9 1a 01 00 00       	jmp    8010138c <filewrite+0x136>
  if(f->type == FD_PIPE)
80101272:	8b 45 08             	mov    0x8(%ebp),%eax
80101275:	8b 00                	mov    (%eax),%eax
80101277:	83 f8 01             	cmp    $0x1,%eax
8010127a:	75 1d                	jne    80101299 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
8010127c:	8b 45 08             	mov    0x8(%ebp),%eax
8010127f:	8b 40 0c             	mov    0xc(%eax),%eax
80101282:	83 ec 04             	sub    $0x4,%esp
80101285:	ff 75 10             	pushl  0x10(%ebp)
80101288:	ff 75 0c             	pushl  0xc(%ebp)
8010128b:	50                   	push   %eax
8010128c:	e8 b1 30 00 00       	call   80104342 <pipewrite>
80101291:	83 c4 10             	add    $0x10,%esp
80101294:	e9 f3 00 00 00       	jmp    8010138c <filewrite+0x136>
  if(f->type == FD_INODE){
80101299:	8b 45 08             	mov    0x8(%ebp),%eax
8010129c:	8b 00                	mov    (%eax),%eax
8010129e:	83 f8 02             	cmp    $0x2,%eax
801012a1:	0f 85 d8 00 00 00    	jne    8010137f <filewrite+0x129>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801012a7:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
801012ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801012b5:	e9 a5 00 00 00       	jmp    8010135f <filewrite+0x109>
      int n1 = n - i;
801012ba:	8b 45 10             	mov    0x10(%ebp),%eax
801012bd:	2b 45 f4             	sub    -0xc(%ebp),%eax
801012c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
801012c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012c6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801012c9:	7e 06                	jle    801012d1 <filewrite+0x7b>
        n1 = max;
801012cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801012ce:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
801012d1:	e8 a8 25 00 00       	call   8010387e <begin_op>
      ilock(f->ip);
801012d6:	8b 45 08             	mov    0x8(%ebp),%eax
801012d9:	8b 40 10             	mov    0x10(%eax),%eax
801012dc:	83 ec 0c             	sub    $0xc,%esp
801012df:	50                   	push   %eax
801012e0:	e8 a6 06 00 00       	call   8010198b <ilock>
801012e5:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012e8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801012eb:	8b 45 08             	mov    0x8(%ebp),%eax
801012ee:	8b 50 14             	mov    0x14(%eax),%edx
801012f1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801012f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801012f7:	01 c3                	add    %eax,%ebx
801012f9:	8b 45 08             	mov    0x8(%ebp),%eax
801012fc:	8b 40 10             	mov    0x10(%eax),%eax
801012ff:	51                   	push   %ecx
80101300:	52                   	push   %edx
80101301:	53                   	push   %ebx
80101302:	50                   	push   %eax
80101303:	e8 9c 0d 00 00       	call   801020a4 <writei>
80101308:	83 c4 10             	add    $0x10,%esp
8010130b:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010130e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101312:	7e 11                	jle    80101325 <filewrite+0xcf>
        f->off += r;
80101314:	8b 45 08             	mov    0x8(%ebp),%eax
80101317:	8b 50 14             	mov    0x14(%eax),%edx
8010131a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010131d:	01 c2                	add    %eax,%edx
8010131f:	8b 45 08             	mov    0x8(%ebp),%eax
80101322:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101325:	8b 45 08             	mov    0x8(%ebp),%eax
80101328:	8b 40 10             	mov    0x10(%eax),%eax
8010132b:	83 ec 0c             	sub    $0xc,%esp
8010132e:	50                   	push   %eax
8010132f:	e8 dc 07 00 00       	call   80101b10 <iunlock>
80101334:	83 c4 10             	add    $0x10,%esp
      end_op();
80101337:	e8 d0 25 00 00       	call   8010390c <end_op>

      if(r < 0)
8010133c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101340:	79 02                	jns    80101344 <filewrite+0xee>
        break;
80101342:	eb 27                	jmp    8010136b <filewrite+0x115>
      if(r != n1)
80101344:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101347:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010134a:	74 0d                	je     80101359 <filewrite+0x103>
        panic("short filewrite");
8010134c:	83 ec 0c             	sub    $0xc,%esp
8010134f:	68 2b 8e 10 80       	push   $0x80108e2b
80101354:	e8 4a f2 ff ff       	call   801005a3 <panic>
      i += r;
80101359:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010135c:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010135f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101362:	3b 45 10             	cmp    0x10(%ebp),%eax
80101365:	0f 8c 4f ff ff ff    	jl     801012ba <filewrite+0x64>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010136b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010136e:	3b 45 10             	cmp    0x10(%ebp),%eax
80101371:	75 05                	jne    80101378 <filewrite+0x122>
80101373:	8b 45 10             	mov    0x10(%ebp),%eax
80101376:	eb 14                	jmp    8010138c <filewrite+0x136>
80101378:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010137d:	eb 0d                	jmp    8010138c <filewrite+0x136>
  }
  panic("filewrite");
8010137f:	83 ec 0c             	sub    $0xc,%esp
80101382:	68 3b 8e 10 80       	push   $0x80108e3b
80101387:	e8 17 f2 ff ff       	call   801005a3 <panic>
}
8010138c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010138f:	c9                   	leave  
80101390:	c3                   	ret    

80101391 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101391:	55                   	push   %ebp
80101392:	89 e5                	mov    %esp,%ebp
80101394:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101397:	8b 45 08             	mov    0x8(%ebp),%eax
8010139a:	83 ec 08             	sub    $0x8,%esp
8010139d:	6a 01                	push   $0x1
8010139f:	50                   	push   %eax
801013a0:	e8 0f ee ff ff       	call   801001b4 <bread>
801013a5:	83 c4 10             	add    $0x10,%esp
801013a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801013ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013ae:	83 c0 18             	add    $0x18,%eax
801013b1:	83 ec 04             	sub    $0x4,%esp
801013b4:	6a 1c                	push   $0x1c
801013b6:	50                   	push   %eax
801013b7:	ff 75 0c             	pushl  0xc(%ebp)
801013ba:	e8 65 44 00 00       	call   80105824 <memmove>
801013bf:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801013c2:	83 ec 0c             	sub    $0xc,%esp
801013c5:	ff 75 f4             	pushl  -0xc(%ebp)
801013c8:	e8 5e ee ff ff       	call   8010022b <brelse>
801013cd:	83 c4 10             	add    $0x10,%esp
}
801013d0:	c9                   	leave  
801013d1:	c3                   	ret    

801013d2 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
801013d2:	55                   	push   %ebp
801013d3:	89 e5                	mov    %esp,%ebp
801013d5:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
801013d8:	8b 55 0c             	mov    0xc(%ebp),%edx
801013db:	8b 45 08             	mov    0x8(%ebp),%eax
801013de:	83 ec 08             	sub    $0x8,%esp
801013e1:	52                   	push   %edx
801013e2:	50                   	push   %eax
801013e3:	e8 cc ed ff ff       	call   801001b4 <bread>
801013e8:	83 c4 10             	add    $0x10,%esp
801013eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801013ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013f1:	83 c0 18             	add    $0x18,%eax
801013f4:	83 ec 04             	sub    $0x4,%esp
801013f7:	68 00 02 00 00       	push   $0x200
801013fc:	6a 00                	push   $0x0
801013fe:	50                   	push   %eax
801013ff:	e8 61 43 00 00       	call   80105765 <memset>
80101404:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101407:	83 ec 0c             	sub    $0xc,%esp
8010140a:	ff 75 f4             	pushl  -0xc(%ebp)
8010140d:	e8 a3 26 00 00       	call   80103ab5 <log_write>
80101412:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101415:	83 ec 0c             	sub    $0xc,%esp
80101418:	ff 75 f4             	pushl  -0xc(%ebp)
8010141b:	e8 0b ee ff ff       	call   8010022b <brelse>
80101420:	83 c4 10             	add    $0x10,%esp
}
80101423:	c9                   	leave  
80101424:	c3                   	ret    

80101425 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101425:	55                   	push   %ebp
80101426:	89 e5                	mov    %esp,%ebp
80101428:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
8010142b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101432:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101439:	e9 0a 01 00 00       	jmp    80101548 <balloc+0x123>
    bp = bread(dev, BBLOCK(b, sb));
8010143e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101441:	99                   	cltd   
80101442:	c1 ea 14             	shr    $0x14,%edx
80101445:	01 d0                	add    %edx,%eax
80101447:	c1 f8 0c             	sar    $0xc,%eax
8010144a:	89 c2                	mov    %eax,%edx
8010144c:	a1 d8 22 11 80       	mov    0x801122d8,%eax
80101451:	01 d0                	add    %edx,%eax
80101453:	83 ec 08             	sub    $0x8,%esp
80101456:	50                   	push   %eax
80101457:	ff 75 08             	pushl  0x8(%ebp)
8010145a:	e8 55 ed ff ff       	call   801001b4 <bread>
8010145f:	83 c4 10             	add    $0x10,%esp
80101462:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101465:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010146c:	e9 a2 00 00 00       	jmp    80101513 <balloc+0xee>
      m = 1 << (bi % 8);
80101471:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101474:	99                   	cltd   
80101475:	c1 ea 1d             	shr    $0x1d,%edx
80101478:	01 d0                	add    %edx,%eax
8010147a:	83 e0 07             	and    $0x7,%eax
8010147d:	29 d0                	sub    %edx,%eax
8010147f:	ba 01 00 00 00       	mov    $0x1,%edx
80101484:	89 c1                	mov    %eax,%ecx
80101486:	d3 e2                	shl    %cl,%edx
80101488:	89 d0                	mov    %edx,%eax
8010148a:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010148d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101490:	99                   	cltd   
80101491:	c1 ea 1d             	shr    $0x1d,%edx
80101494:	01 d0                	add    %edx,%eax
80101496:	c1 f8 03             	sar    $0x3,%eax
80101499:	89 c2                	mov    %eax,%edx
8010149b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010149e:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801014a3:	0f b6 c0             	movzbl %al,%eax
801014a6:	23 45 e8             	and    -0x18(%ebp),%eax
801014a9:	85 c0                	test   %eax,%eax
801014ab:	75 62                	jne    8010150f <balloc+0xea>
        bp->data[bi/8] |= m;  // Mark block in use.
801014ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014b0:	99                   	cltd   
801014b1:	c1 ea 1d             	shr    $0x1d,%edx
801014b4:	01 d0                	add    %edx,%eax
801014b6:	c1 f8 03             	sar    $0x3,%eax
801014b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014bc:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801014c1:	89 d1                	mov    %edx,%ecx
801014c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014c6:	09 ca                	or     %ecx,%edx
801014c8:	89 d1                	mov    %edx,%ecx
801014ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014cd:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
801014d1:	83 ec 0c             	sub    $0xc,%esp
801014d4:	ff 75 ec             	pushl  -0x14(%ebp)
801014d7:	e8 d9 25 00 00       	call   80103ab5 <log_write>
801014dc:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
801014df:	83 ec 0c             	sub    $0xc,%esp
801014e2:	ff 75 ec             	pushl  -0x14(%ebp)
801014e5:	e8 41 ed ff ff       	call   8010022b <brelse>
801014ea:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
801014ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014f3:	01 c2                	add    %eax,%edx
801014f5:	8b 45 08             	mov    0x8(%ebp),%eax
801014f8:	83 ec 08             	sub    $0x8,%esp
801014fb:	52                   	push   %edx
801014fc:	50                   	push   %eax
801014fd:	e8 d0 fe ff ff       	call   801013d2 <bzero>
80101502:	83 c4 10             	add    $0x10,%esp
        return b + bi;
80101505:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101508:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010150b:	01 d0                	add    %edx,%eax
8010150d:	eb 56                	jmp    80101565 <balloc+0x140>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010150f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101513:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
8010151a:	7f 17                	jg     80101533 <balloc+0x10e>
8010151c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010151f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101522:	01 d0                	add    %edx,%eax
80101524:	89 c2                	mov    %eax,%edx
80101526:	a1 c0 22 11 80       	mov    0x801122c0,%eax
8010152b:	39 c2                	cmp    %eax,%edx
8010152d:	0f 82 3e ff ff ff    	jb     80101471 <balloc+0x4c>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101533:	83 ec 0c             	sub    $0xc,%esp
80101536:	ff 75 ec             	pushl  -0x14(%ebp)
80101539:	e8 ed ec ff ff       	call   8010022b <brelse>
8010153e:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101541:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101548:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010154b:	a1 c0 22 11 80       	mov    0x801122c0,%eax
80101550:	39 c2                	cmp    %eax,%edx
80101552:	0f 82 e6 fe ff ff    	jb     8010143e <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101558:	83 ec 0c             	sub    $0xc,%esp
8010155b:	68 48 8e 10 80       	push   $0x80108e48
80101560:	e8 3e f0 ff ff       	call   801005a3 <panic>
}
80101565:	c9                   	leave  
80101566:	c3                   	ret    

80101567 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101567:	55                   	push   %ebp
80101568:	89 e5                	mov    %esp,%ebp
8010156a:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
8010156d:	83 ec 08             	sub    $0x8,%esp
80101570:	68 c0 22 11 80       	push   $0x801122c0
80101575:	ff 75 08             	pushl  0x8(%ebp)
80101578:	e8 14 fe ff ff       	call   80101391 <readsb>
8010157d:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101580:	8b 45 0c             	mov    0xc(%ebp),%eax
80101583:	c1 e8 0c             	shr    $0xc,%eax
80101586:	89 c2                	mov    %eax,%edx
80101588:	a1 d8 22 11 80       	mov    0x801122d8,%eax
8010158d:	01 c2                	add    %eax,%edx
8010158f:	8b 45 08             	mov    0x8(%ebp),%eax
80101592:	83 ec 08             	sub    $0x8,%esp
80101595:	52                   	push   %edx
80101596:	50                   	push   %eax
80101597:	e8 18 ec ff ff       	call   801001b4 <bread>
8010159c:	83 c4 10             	add    $0x10,%esp
8010159f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801015a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801015a5:	25 ff 0f 00 00       	and    $0xfff,%eax
801015aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801015ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015b0:	99                   	cltd   
801015b1:	c1 ea 1d             	shr    $0x1d,%edx
801015b4:	01 d0                	add    %edx,%eax
801015b6:	83 e0 07             	and    $0x7,%eax
801015b9:	29 d0                	sub    %edx,%eax
801015bb:	ba 01 00 00 00       	mov    $0x1,%edx
801015c0:	89 c1                	mov    %eax,%ecx
801015c2:	d3 e2                	shl    %cl,%edx
801015c4:	89 d0                	mov    %edx,%eax
801015c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
801015c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015cc:	99                   	cltd   
801015cd:	c1 ea 1d             	shr    $0x1d,%edx
801015d0:	01 d0                	add    %edx,%eax
801015d2:	c1 f8 03             	sar    $0x3,%eax
801015d5:	89 c2                	mov    %eax,%edx
801015d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015da:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801015df:	0f b6 c0             	movzbl %al,%eax
801015e2:	23 45 ec             	and    -0x14(%ebp),%eax
801015e5:	85 c0                	test   %eax,%eax
801015e7:	75 0d                	jne    801015f6 <bfree+0x8f>
    panic("freeing free block");
801015e9:	83 ec 0c             	sub    $0xc,%esp
801015ec:	68 5e 8e 10 80       	push   $0x80108e5e
801015f1:	e8 ad ef ff ff       	call   801005a3 <panic>
  bp->data[bi/8] &= ~m;
801015f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015f9:	99                   	cltd   
801015fa:	c1 ea 1d             	shr    $0x1d,%edx
801015fd:	01 d0                	add    %edx,%eax
801015ff:	c1 f8 03             	sar    $0x3,%eax
80101602:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101605:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010160a:	89 d1                	mov    %edx,%ecx
8010160c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010160f:	f7 d2                	not    %edx
80101611:	21 ca                	and    %ecx,%edx
80101613:	89 d1                	mov    %edx,%ecx
80101615:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101618:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
8010161c:	83 ec 0c             	sub    $0xc,%esp
8010161f:	ff 75 f4             	pushl  -0xc(%ebp)
80101622:	e8 8e 24 00 00       	call   80103ab5 <log_write>
80101627:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010162a:	83 ec 0c             	sub    $0xc,%esp
8010162d:	ff 75 f4             	pushl  -0xc(%ebp)
80101630:	e8 f6 eb ff ff       	call   8010022b <brelse>
80101635:	83 c4 10             	add    $0x10,%esp
}
80101638:	c9                   	leave  
80101639:	c3                   	ret    

8010163a <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
8010163a:	55                   	push   %ebp
8010163b:	89 e5                	mov    %esp,%ebp
8010163d:	57                   	push   %edi
8010163e:	56                   	push   %esi
8010163f:	53                   	push   %ebx
80101640:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
80101643:	83 ec 08             	sub    $0x8,%esp
80101646:	68 71 8e 10 80       	push   $0x80108e71
8010164b:	68 00 23 11 80       	push   $0x80112300
80101650:	e8 79 3e 00 00       	call   801054ce <initlock>
80101655:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80101658:	83 ec 08             	sub    $0x8,%esp
8010165b:	68 c0 22 11 80       	push   $0x801122c0
80101660:	ff 75 08             	pushl  0x8(%ebp)
80101663:	e8 29 fd ff ff       	call   80101391 <readsb>
80101668:	83 c4 10             	add    $0x10,%esp
  //cprintf("fs.c::void iinit(int dev)\n");
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
8010166b:	a1 d8 22 11 80       	mov    0x801122d8,%eax
80101670:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101673:	8b 3d d4 22 11 80    	mov    0x801122d4,%edi
80101679:	8b 35 d0 22 11 80    	mov    0x801122d0,%esi
8010167f:	8b 1d cc 22 11 80    	mov    0x801122cc,%ebx
80101685:	8b 0d c8 22 11 80    	mov    0x801122c8,%ecx
8010168b:	8b 15 c4 22 11 80    	mov    0x801122c4,%edx
80101691:	a1 c0 22 11 80       	mov    0x801122c0,%eax
80101696:	ff 75 e4             	pushl  -0x1c(%ebp)
80101699:	57                   	push   %edi
8010169a:	56                   	push   %esi
8010169b:	53                   	push   %ebx
8010169c:	51                   	push   %ecx
8010169d:	52                   	push   %edx
8010169e:	50                   	push   %eax
8010169f:	68 78 8e 10 80       	push   $0x80108e78
801016a4:	e8 5d ed ff ff       	call   80100406 <cprintf>
801016a9:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
801016ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016af:	5b                   	pop    %ebx
801016b0:	5e                   	pop    %esi
801016b1:	5f                   	pop    %edi
801016b2:	5d                   	pop    %ebp
801016b3:	c3                   	ret    

801016b4 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801016b4:	55                   	push   %ebp
801016b5:	89 e5                	mov    %esp,%ebp
801016b7:	83 ec 28             	sub    $0x28,%esp
801016ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801016bd:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801016c1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801016c8:	e9 9e 00 00 00       	jmp    8010176b <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
801016cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016d0:	c1 e8 03             	shr    $0x3,%eax
801016d3:	89 c2                	mov    %eax,%edx
801016d5:	a1 d4 22 11 80       	mov    0x801122d4,%eax
801016da:	01 d0                	add    %edx,%eax
801016dc:	83 ec 08             	sub    $0x8,%esp
801016df:	50                   	push   %eax
801016e0:	ff 75 08             	pushl  0x8(%ebp)
801016e3:	e8 cc ea ff ff       	call   801001b4 <bread>
801016e8:	83 c4 10             	add    $0x10,%esp
801016eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801016ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016f1:	8d 50 18             	lea    0x18(%eax),%edx
801016f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016f7:	83 e0 07             	and    $0x7,%eax
801016fa:	c1 e0 06             	shl    $0x6,%eax
801016fd:	01 d0                	add    %edx,%eax
801016ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101702:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101705:	0f b7 00             	movzwl (%eax),%eax
80101708:	66 85 c0             	test   %ax,%ax
8010170b:	75 4c                	jne    80101759 <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
8010170d:	83 ec 04             	sub    $0x4,%esp
80101710:	6a 40                	push   $0x40
80101712:	6a 00                	push   $0x0
80101714:	ff 75 ec             	pushl  -0x14(%ebp)
80101717:	e8 49 40 00 00       	call   80105765 <memset>
8010171c:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
8010171f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101722:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
80101726:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101729:	83 ec 0c             	sub    $0xc,%esp
8010172c:	ff 75 f0             	pushl  -0x10(%ebp)
8010172f:	e8 81 23 00 00       	call   80103ab5 <log_write>
80101734:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
80101737:	83 ec 0c             	sub    $0xc,%esp
8010173a:	ff 75 f0             	pushl  -0x10(%ebp)
8010173d:	e8 e9 ea ff ff       	call   8010022b <brelse>
80101742:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
80101745:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101748:	83 ec 08             	sub    $0x8,%esp
8010174b:	50                   	push   %eax
8010174c:	ff 75 08             	pushl  0x8(%ebp)
8010174f:	e8 1e 01 00 00       	call   80101872 <iget>
80101754:	83 c4 10             	add    $0x10,%esp
80101757:	eb 2f                	jmp    80101788 <ialloc+0xd4>
    }
    brelse(bp);
80101759:	83 ec 0c             	sub    $0xc,%esp
8010175c:	ff 75 f0             	pushl  -0x10(%ebp)
8010175f:	e8 c7 ea ff ff       	call   8010022b <brelse>
80101764:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101767:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010176b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010176e:	a1 c8 22 11 80       	mov    0x801122c8,%eax
80101773:	39 c2                	cmp    %eax,%edx
80101775:	0f 82 52 ff ff ff    	jb     801016cd <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
8010177b:	83 ec 0c             	sub    $0xc,%esp
8010177e:	68 cb 8e 10 80       	push   $0x80108ecb
80101783:	e8 1b ee ff ff       	call   801005a3 <panic>
}
80101788:	c9                   	leave  
80101789:	c3                   	ret    

8010178a <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
8010178a:	55                   	push   %ebp
8010178b:	89 e5                	mov    %esp,%ebp
8010178d:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101790:	8b 45 08             	mov    0x8(%ebp),%eax
80101793:	8b 40 04             	mov    0x4(%eax),%eax
80101796:	c1 e8 03             	shr    $0x3,%eax
80101799:	89 c2                	mov    %eax,%edx
8010179b:	a1 d4 22 11 80       	mov    0x801122d4,%eax
801017a0:	01 c2                	add    %eax,%edx
801017a2:	8b 45 08             	mov    0x8(%ebp),%eax
801017a5:	8b 00                	mov    (%eax),%eax
801017a7:	83 ec 08             	sub    $0x8,%esp
801017aa:	52                   	push   %edx
801017ab:	50                   	push   %eax
801017ac:	e8 03 ea ff ff       	call   801001b4 <bread>
801017b1:	83 c4 10             	add    $0x10,%esp
801017b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ba:	8d 50 18             	lea    0x18(%eax),%edx
801017bd:	8b 45 08             	mov    0x8(%ebp),%eax
801017c0:	8b 40 04             	mov    0x4(%eax),%eax
801017c3:	83 e0 07             	and    $0x7,%eax
801017c6:	c1 e0 06             	shl    $0x6,%eax
801017c9:	01 d0                	add    %edx,%eax
801017cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801017ce:	8b 45 08             	mov    0x8(%ebp),%eax
801017d1:	0f b7 50 10          	movzwl 0x10(%eax),%edx
801017d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017d8:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801017db:	8b 45 08             	mov    0x8(%ebp),%eax
801017de:	0f b7 50 12          	movzwl 0x12(%eax),%edx
801017e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017e5:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801017e9:	8b 45 08             	mov    0x8(%ebp),%eax
801017ec:	0f b7 50 14          	movzwl 0x14(%eax),%edx
801017f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017f3:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801017f7:	8b 45 08             	mov    0x8(%ebp),%eax
801017fa:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801017fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101801:	66 89 50 06          	mov    %dx,0x6(%eax)

  dip->ownerid=ip->ownerid;
80101805:	8b 45 08             	mov    0x8(%ebp),%eax
80101808:	0f b7 50 18          	movzwl 0x18(%eax),%edx
8010180c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010180f:	66 89 50 08          	mov    %dx,0x8(%eax)
  dip->groupid=ip->groupid;
80101813:	8b 45 08             	mov    0x8(%ebp),%eax
80101816:	0f b7 50 1a          	movzwl 0x1a(%eax),%edx
8010181a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010181d:	66 89 50 0a          	mov    %dx,0xa(%eax)
  dip->mode=ip->mode;
80101821:	8b 45 08             	mov    0x8(%ebp),%eax
80101824:	8b 50 1c             	mov    0x1c(%eax),%edx
80101827:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010182a:	89 50 0c             	mov    %edx,0xc(%eax)

  dip->size = ip->size;
8010182d:	8b 45 08             	mov    0x8(%ebp),%eax
80101830:	8b 50 20             	mov    0x20(%eax),%edx
80101833:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101836:	89 50 10             	mov    %edx,0x10(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101839:	8b 45 08             	mov    0x8(%ebp),%eax
8010183c:	8d 50 24             	lea    0x24(%eax),%edx
8010183f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101842:	83 c0 14             	add    $0x14,%eax
80101845:	83 ec 04             	sub    $0x4,%esp
80101848:	6a 2c                	push   $0x2c
8010184a:	52                   	push   %edx
8010184b:	50                   	push   %eax
8010184c:	e8 d3 3f 00 00       	call   80105824 <memmove>
80101851:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101854:	83 ec 0c             	sub    $0xc,%esp
80101857:	ff 75 f4             	pushl  -0xc(%ebp)
8010185a:	e8 56 22 00 00       	call   80103ab5 <log_write>
8010185f:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101862:	83 ec 0c             	sub    $0xc,%esp
80101865:	ff 75 f4             	pushl  -0xc(%ebp)
80101868:	e8 be e9 ff ff       	call   8010022b <brelse>
8010186d:	83 c4 10             	add    $0x10,%esp
}
80101870:	c9                   	leave  
80101871:	c3                   	ret    

80101872 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101872:	55                   	push   %ebp
80101873:	89 e5                	mov    %esp,%ebp
80101875:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 00 23 11 80       	push   $0x80112300
80101880:	e8 6a 3c 00 00       	call   801054ef <acquire>
80101885:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101888:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010188f:	c7 45 f4 34 23 11 80 	movl   $0x80112334,-0xc(%ebp)
80101896:	eb 5d                	jmp    801018f5 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101898:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010189b:	8b 40 08             	mov    0x8(%eax),%eax
8010189e:	85 c0                	test   %eax,%eax
801018a0:	7e 39                	jle    801018db <iget+0x69>
801018a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018a5:	8b 00                	mov    (%eax),%eax
801018a7:	3b 45 08             	cmp    0x8(%ebp),%eax
801018aa:	75 2f                	jne    801018db <iget+0x69>
801018ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018af:	8b 40 04             	mov    0x4(%eax),%eax
801018b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
801018b5:	75 24                	jne    801018db <iget+0x69>
      ip->ref++;
801018b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ba:	8b 40 08             	mov    0x8(%eax),%eax
801018bd:	8d 50 01             	lea    0x1(%eax),%edx
801018c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018c3:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801018c6:	83 ec 0c             	sub    $0xc,%esp
801018c9:	68 00 23 11 80       	push   $0x80112300
801018ce:	e8 82 3c 00 00       	call   80105555 <release>
801018d3:	83 c4 10             	add    $0x10,%esp
      return ip;
801018d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018d9:	eb 74                	jmp    8010194f <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801018db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018df:	75 10                	jne    801018f1 <iget+0x7f>
801018e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018e4:	8b 40 08             	mov    0x8(%eax),%eax
801018e7:	85 c0                	test   %eax,%eax
801018e9:	75 06                	jne    801018f1 <iget+0x7f>
      empty = ip;
801018eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ee:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018f1:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801018f5:	81 7d f4 d4 32 11 80 	cmpl   $0x801132d4,-0xc(%ebp)
801018fc:	72 9a                	jb     80101898 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801018fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101902:	75 0d                	jne    80101911 <iget+0x9f>
    panic("iget: no inodes");
80101904:	83 ec 0c             	sub    $0xc,%esp
80101907:	68 dd 8e 10 80       	push   $0x80108edd
8010190c:	e8 92 ec ff ff       	call   801005a3 <panic>

  ip = empty;
80101911:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101914:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101917:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010191a:	8b 55 08             	mov    0x8(%ebp),%edx
8010191d:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010191f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101922:	8b 55 0c             	mov    0xc(%ebp),%edx
80101925:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101928:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010192b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101932:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101935:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
8010193c:	83 ec 0c             	sub    $0xc,%esp
8010193f:	68 00 23 11 80       	push   $0x80112300
80101944:	e8 0c 3c 00 00       	call   80105555 <release>
80101949:	83 c4 10             	add    $0x10,%esp

  return ip;
8010194c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010194f:	c9                   	leave  
80101950:	c3                   	ret    

80101951 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101951:	55                   	push   %ebp
80101952:	89 e5                	mov    %esp,%ebp
80101954:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101957:	83 ec 0c             	sub    $0xc,%esp
8010195a:	68 00 23 11 80       	push   $0x80112300
8010195f:	e8 8b 3b 00 00       	call   801054ef <acquire>
80101964:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101967:	8b 45 08             	mov    0x8(%ebp),%eax
8010196a:	8b 40 08             	mov    0x8(%eax),%eax
8010196d:	8d 50 01             	lea    0x1(%eax),%edx
80101970:	8b 45 08             	mov    0x8(%ebp),%eax
80101973:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101976:	83 ec 0c             	sub    $0xc,%esp
80101979:	68 00 23 11 80       	push   $0x80112300
8010197e:	e8 d2 3b 00 00       	call   80105555 <release>
80101983:	83 c4 10             	add    $0x10,%esp
  return ip;
80101986:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101989:	c9                   	leave  
8010198a:	c3                   	ret    

8010198b <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
8010198b:	55                   	push   %ebp
8010198c:	89 e5                	mov    %esp,%ebp
8010198e:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101991:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101995:	74 0a                	je     801019a1 <ilock+0x16>
80101997:	8b 45 08             	mov    0x8(%ebp),%eax
8010199a:	8b 40 08             	mov    0x8(%eax),%eax
8010199d:	85 c0                	test   %eax,%eax
8010199f:	7f 0d                	jg     801019ae <ilock+0x23>
    panic("ilock");
801019a1:	83 ec 0c             	sub    $0xc,%esp
801019a4:	68 ed 8e 10 80       	push   $0x80108eed
801019a9:	e8 f5 eb ff ff       	call   801005a3 <panic>

  acquire(&icache.lock);
801019ae:	83 ec 0c             	sub    $0xc,%esp
801019b1:	68 00 23 11 80       	push   $0x80112300
801019b6:	e8 34 3b 00 00       	call   801054ef <acquire>
801019bb:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
801019be:	eb 13                	jmp    801019d3 <ilock+0x48>
    sleep(ip, &icache.lock);
801019c0:	83 ec 08             	sub    $0x8,%esp
801019c3:	68 00 23 11 80       	push   $0x80112300
801019c8:	ff 75 08             	pushl  0x8(%ebp)
801019cb:	e8 3a 34 00 00       	call   80104e0a <sleep>
801019d0:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801019d3:	8b 45 08             	mov    0x8(%ebp),%eax
801019d6:	8b 40 0c             	mov    0xc(%eax),%eax
801019d9:	83 e0 01             	and    $0x1,%eax
801019dc:	85 c0                	test   %eax,%eax
801019de:	75 e0                	jne    801019c0 <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801019e0:	8b 45 08             	mov    0x8(%ebp),%eax
801019e3:	8b 40 0c             	mov    0xc(%eax),%eax
801019e6:	83 c8 01             	or     $0x1,%eax
801019e9:	89 c2                	mov    %eax,%edx
801019eb:	8b 45 08             	mov    0x8(%ebp),%eax
801019ee:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801019f1:	83 ec 0c             	sub    $0xc,%esp
801019f4:	68 00 23 11 80       	push   $0x80112300
801019f9:	e8 57 3b 00 00       	call   80105555 <release>
801019fe:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101a01:	8b 45 08             	mov    0x8(%ebp),%eax
80101a04:	8b 40 0c             	mov    0xc(%eax),%eax
80101a07:	83 e0 02             	and    $0x2,%eax
80101a0a:	85 c0                	test   %eax,%eax
80101a0c:	0f 85 fc 00 00 00    	jne    80101b0e <ilock+0x183>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a12:	8b 45 08             	mov    0x8(%ebp),%eax
80101a15:	8b 40 04             	mov    0x4(%eax),%eax
80101a18:	c1 e8 03             	shr    $0x3,%eax
80101a1b:	89 c2                	mov    %eax,%edx
80101a1d:	a1 d4 22 11 80       	mov    0x801122d4,%eax
80101a22:	01 c2                	add    %eax,%edx
80101a24:	8b 45 08             	mov    0x8(%ebp),%eax
80101a27:	8b 00                	mov    (%eax),%eax
80101a29:	83 ec 08             	sub    $0x8,%esp
80101a2c:	52                   	push   %edx
80101a2d:	50                   	push   %eax
80101a2e:	e8 81 e7 ff ff       	call   801001b4 <bread>
80101a33:	83 c4 10             	add    $0x10,%esp
80101a36:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a3c:	8d 50 18             	lea    0x18(%eax),%edx
80101a3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a42:	8b 40 04             	mov    0x4(%eax),%eax
80101a45:	83 e0 07             	and    $0x7,%eax
80101a48:	c1 e0 06             	shl    $0x6,%eax
80101a4b:	01 d0                	add    %edx,%eax
80101a4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a53:	0f b7 10             	movzwl (%eax),%edx
80101a56:	8b 45 08             	mov    0x8(%ebp),%eax
80101a59:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a60:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101a64:	8b 45 08             	mov    0x8(%ebp),%eax
80101a67:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a6e:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101a72:	8b 45 08             	mov    0x8(%ebp),%eax
80101a75:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101a79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a7c:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101a80:	8b 45 08             	mov    0x8(%ebp),%eax
80101a83:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a8a:	8b 50 10             	mov    0x10(%eax),%edx
80101a8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a90:	89 50 20             	mov    %edx,0x20(%eax)

    //Read ownership permissions into memory.
    ip->ownerid = dip->ownerid;
80101a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a96:	0f b7 50 08          	movzwl 0x8(%eax),%edx
80101a9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9d:	66 89 50 18          	mov    %dx,0x18(%eax)
    ip->groupid = dip->groupid;
80101aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aa4:	0f b7 50 0a          	movzwl 0xa(%eax),%edx
80101aa8:	8b 45 08             	mov    0x8(%ebp),%eax
80101aab:	66 89 50 1a          	mov    %dx,0x1a(%eax)
    ip->mode = dip->mode;
80101aaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ab2:	8b 50 0c             	mov    0xc(%eax),%edx
80101ab5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab8:	89 50 1c             	mov    %edx,0x1c(%eax)

    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101abe:	8d 50 14             	lea    0x14(%eax),%edx
80101ac1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac4:	83 c0 24             	add    $0x24,%eax
80101ac7:	83 ec 04             	sub    $0x4,%esp
80101aca:	6a 2c                	push   $0x2c
80101acc:	52                   	push   %edx
80101acd:	50                   	push   %eax
80101ace:	e8 51 3d 00 00       	call   80105824 <memmove>
80101ad3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101ad6:	83 ec 0c             	sub    $0xc,%esp
80101ad9:	ff 75 f4             	pushl  -0xc(%ebp)
80101adc:	e8 4a e7 ff ff       	call   8010022b <brelse>
80101ae1:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101ae4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae7:	8b 40 0c             	mov    0xc(%eax),%eax
80101aea:	83 c8 02             	or     $0x2,%eax
80101aed:	89 c2                	mov    %eax,%edx
80101aef:	8b 45 08             	mov    0x8(%ebp),%eax
80101af2:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101af5:	8b 45 08             	mov    0x8(%ebp),%eax
80101af8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101afc:	66 85 c0             	test   %ax,%ax
80101aff:	75 0d                	jne    80101b0e <ilock+0x183>
      panic("ilock: no type");
80101b01:	83 ec 0c             	sub    $0xc,%esp
80101b04:	68 f3 8e 10 80       	push   $0x80108ef3
80101b09:	e8 95 ea ff ff       	call   801005a3 <panic>
  }
}
80101b0e:	c9                   	leave  
80101b0f:	c3                   	ret    

80101b10 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b10:	55                   	push   %ebp
80101b11:	89 e5                	mov    %esp,%ebp
80101b13:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101b16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b1a:	74 17                	je     80101b33 <iunlock+0x23>
80101b1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1f:	8b 40 0c             	mov    0xc(%eax),%eax
80101b22:	83 e0 01             	and    $0x1,%eax
80101b25:	85 c0                	test   %eax,%eax
80101b27:	74 0a                	je     80101b33 <iunlock+0x23>
80101b29:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2c:	8b 40 08             	mov    0x8(%eax),%eax
80101b2f:	85 c0                	test   %eax,%eax
80101b31:	7f 0d                	jg     80101b40 <iunlock+0x30>
    panic("iunlock");
80101b33:	83 ec 0c             	sub    $0xc,%esp
80101b36:	68 02 8f 10 80       	push   $0x80108f02
80101b3b:	e8 63 ea ff ff       	call   801005a3 <panic>

  acquire(&icache.lock);
80101b40:	83 ec 0c             	sub    $0xc,%esp
80101b43:	68 00 23 11 80       	push   $0x80112300
80101b48:	e8 a2 39 00 00       	call   801054ef <acquire>
80101b4d:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101b50:	8b 45 08             	mov    0x8(%ebp),%eax
80101b53:	8b 40 0c             	mov    0xc(%eax),%eax
80101b56:	83 e0 fe             	and    $0xfffffffe,%eax
80101b59:	89 c2                	mov    %eax,%edx
80101b5b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5e:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101b61:	83 ec 0c             	sub    $0xc,%esp
80101b64:	ff 75 08             	pushl  0x8(%ebp)
80101b67:	e8 87 33 00 00       	call   80104ef3 <wakeup>
80101b6c:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101b6f:	83 ec 0c             	sub    $0xc,%esp
80101b72:	68 00 23 11 80       	push   $0x80112300
80101b77:	e8 d9 39 00 00       	call   80105555 <release>
80101b7c:	83 c4 10             	add    $0x10,%esp
}
80101b7f:	c9                   	leave  
80101b80:	c3                   	ret    

80101b81 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b81:	55                   	push   %ebp
80101b82:	89 e5                	mov    %esp,%ebp
80101b84:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101b87:	83 ec 0c             	sub    $0xc,%esp
80101b8a:	68 00 23 11 80       	push   $0x80112300
80101b8f:	e8 5b 39 00 00       	call   801054ef <acquire>
80101b94:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101b97:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9a:	8b 40 08             	mov    0x8(%eax),%eax
80101b9d:	83 f8 01             	cmp    $0x1,%eax
80101ba0:	0f 85 a9 00 00 00    	jne    80101c4f <iput+0xce>
80101ba6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba9:	8b 40 0c             	mov    0xc(%eax),%eax
80101bac:	83 e0 02             	and    $0x2,%eax
80101baf:	85 c0                	test   %eax,%eax
80101bb1:	0f 84 98 00 00 00    	je     80101c4f <iput+0xce>
80101bb7:	8b 45 08             	mov    0x8(%ebp),%eax
80101bba:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101bbe:	66 85 c0             	test   %ax,%ax
80101bc1:	0f 85 88 00 00 00    	jne    80101c4f <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101bc7:	8b 45 08             	mov    0x8(%ebp),%eax
80101bca:	8b 40 0c             	mov    0xc(%eax),%eax
80101bcd:	83 e0 01             	and    $0x1,%eax
80101bd0:	85 c0                	test   %eax,%eax
80101bd2:	74 0d                	je     80101be1 <iput+0x60>
      panic("iput busy");
80101bd4:	83 ec 0c             	sub    $0xc,%esp
80101bd7:	68 0a 8f 10 80       	push   $0x80108f0a
80101bdc:	e8 c2 e9 ff ff       	call   801005a3 <panic>
    ip->flags |= I_BUSY;
80101be1:	8b 45 08             	mov    0x8(%ebp),%eax
80101be4:	8b 40 0c             	mov    0xc(%eax),%eax
80101be7:	83 c8 01             	or     $0x1,%eax
80101bea:	89 c2                	mov    %eax,%edx
80101bec:	8b 45 08             	mov    0x8(%ebp),%eax
80101bef:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101bf2:	83 ec 0c             	sub    $0xc,%esp
80101bf5:	68 00 23 11 80       	push   $0x80112300
80101bfa:	e8 56 39 00 00       	call   80105555 <release>
80101bff:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101c02:	83 ec 0c             	sub    $0xc,%esp
80101c05:	ff 75 08             	pushl  0x8(%ebp)
80101c08:	e8 a6 01 00 00       	call   80101db3 <itrunc>
80101c0d:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101c10:	8b 45 08             	mov    0x8(%ebp),%eax
80101c13:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101c19:	83 ec 0c             	sub    $0xc,%esp
80101c1c:	ff 75 08             	pushl  0x8(%ebp)
80101c1f:	e8 66 fb ff ff       	call   8010178a <iupdate>
80101c24:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101c27:	83 ec 0c             	sub    $0xc,%esp
80101c2a:	68 00 23 11 80       	push   $0x80112300
80101c2f:	e8 bb 38 00 00       	call   801054ef <acquire>
80101c34:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101c37:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101c41:	83 ec 0c             	sub    $0xc,%esp
80101c44:	ff 75 08             	pushl  0x8(%ebp)
80101c47:	e8 a7 32 00 00       	call   80104ef3 <wakeup>
80101c4c:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101c4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c52:	8b 40 08             	mov    0x8(%eax),%eax
80101c55:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c58:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5b:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c5e:	83 ec 0c             	sub    $0xc,%esp
80101c61:	68 00 23 11 80       	push   $0x80112300
80101c66:	e8 ea 38 00 00       	call   80105555 <release>
80101c6b:	83 c4 10             	add    $0x10,%esp
}
80101c6e:	c9                   	leave  
80101c6f:	c3                   	ret    

80101c70 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101c76:	83 ec 0c             	sub    $0xc,%esp
80101c79:	ff 75 08             	pushl  0x8(%ebp)
80101c7c:	e8 8f fe ff ff       	call   80101b10 <iunlock>
80101c81:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101c84:	83 ec 0c             	sub    $0xc,%esp
80101c87:	ff 75 08             	pushl  0x8(%ebp)
80101c8a:	e8 f2 fe ff ff       	call   80101b81 <iput>
80101c8f:	83 c4 10             	add    $0x10,%esp
}
80101c92:	c9                   	leave  
80101c93:	c3                   	ret    

80101c94 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c94:	55                   	push   %ebp
80101c95:	89 e5                	mov    %esp,%ebp
80101c97:	53                   	push   %ebx
80101c98:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c9b:	83 7d 0c 09          	cmpl   $0x9,0xc(%ebp)
80101c9f:	77 42                	ja     80101ce3 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101ca1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca4:	8b 55 0c             	mov    0xc(%ebp),%edx
80101ca7:	83 c2 08             	add    $0x8,%edx
80101caa:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80101cae:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cb5:	75 24                	jne    80101cdb <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101cb7:	8b 45 08             	mov    0x8(%ebp),%eax
80101cba:	8b 00                	mov    (%eax),%eax
80101cbc:	83 ec 0c             	sub    $0xc,%esp
80101cbf:	50                   	push   %eax
80101cc0:	e8 60 f7 ff ff       	call   80101425 <balloc>
80101cc5:	83 c4 10             	add    $0x10,%esp
80101cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ccb:	8b 45 08             	mov    0x8(%ebp),%eax
80101cce:	8b 55 0c             	mov    0xc(%ebp),%edx
80101cd1:	8d 4a 08             	lea    0x8(%edx),%ecx
80101cd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cd7:	89 54 88 04          	mov    %edx,0x4(%eax,%ecx,4)
    return addr;
80101cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cde:	e9 cb 00 00 00       	jmp    80101dae <bmap+0x11a>
  }
  bn -= NDIRECT;
80101ce3:	83 6d 0c 0a          	subl   $0xa,0xc(%ebp)

  if(bn < NINDIRECT){
80101ce7:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101ceb:	0f 87 b0 00 00 00    	ja     80101da1 <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101cf1:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf4:	8b 40 4c             	mov    0x4c(%eax),%eax
80101cf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cfa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cfe:	75 1d                	jne    80101d1d <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101d00:	8b 45 08             	mov    0x8(%ebp),%eax
80101d03:	8b 00                	mov    (%eax),%eax
80101d05:	83 ec 0c             	sub    $0xc,%esp
80101d08:	50                   	push   %eax
80101d09:	e8 17 f7 ff ff       	call   80101425 <balloc>
80101d0e:	83 c4 10             	add    $0x10,%esp
80101d11:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d14:	8b 45 08             	mov    0x8(%ebp),%eax
80101d17:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d1a:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101d1d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d20:	8b 00                	mov    (%eax),%eax
80101d22:	83 ec 08             	sub    $0x8,%esp
80101d25:	ff 75 f4             	pushl  -0xc(%ebp)
80101d28:	50                   	push   %eax
80101d29:	e8 86 e4 ff ff       	call   801001b4 <bread>
80101d2e:	83 c4 10             	add    $0x10,%esp
80101d31:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d37:	83 c0 18             	add    $0x18,%eax
80101d3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d40:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d47:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d4a:	01 d0                	add    %edx,%eax
80101d4c:	8b 00                	mov    (%eax),%eax
80101d4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d55:	75 37                	jne    80101d8e <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101d57:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d5a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d61:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d64:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101d67:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6a:	8b 00                	mov    (%eax),%eax
80101d6c:	83 ec 0c             	sub    $0xc,%esp
80101d6f:	50                   	push   %eax
80101d70:	e8 b0 f6 ff ff       	call   80101425 <balloc>
80101d75:	83 c4 10             	add    $0x10,%esp
80101d78:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d7e:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101d80:	83 ec 0c             	sub    $0xc,%esp
80101d83:	ff 75 f0             	pushl  -0x10(%ebp)
80101d86:	e8 2a 1d 00 00       	call   80103ab5 <log_write>
80101d8b:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101d8e:	83 ec 0c             	sub    $0xc,%esp
80101d91:	ff 75 f0             	pushl  -0x10(%ebp)
80101d94:	e8 92 e4 ff ff       	call   8010022b <brelse>
80101d99:	83 c4 10             	add    $0x10,%esp
    return addr;
80101d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d9f:	eb 0d                	jmp    80101dae <bmap+0x11a>
  }

  panic("bmap: out of range");
80101da1:	83 ec 0c             	sub    $0xc,%esp
80101da4:	68 14 8f 10 80       	push   $0x80108f14
80101da9:	e8 f5 e7 ff ff       	call   801005a3 <panic>
}
80101dae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101db1:	c9                   	leave  
80101db2:	c3                   	ret    

80101db3 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101db3:	55                   	push   %ebp
80101db4:	89 e5                	mov    %esp,%ebp
80101db6:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101db9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101dc0:	eb 45                	jmp    80101e07 <itrunc+0x54>
    if(ip->addrs[i]){
80101dc2:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dc8:	83 c2 08             	add    $0x8,%edx
80101dcb:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80101dcf:	85 c0                	test   %eax,%eax
80101dd1:	74 30                	je     80101e03 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101dd3:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dd9:	83 c2 08             	add    $0x8,%edx
80101ddc:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80101de0:	8b 55 08             	mov    0x8(%ebp),%edx
80101de3:	8b 12                	mov    (%edx),%edx
80101de5:	83 ec 08             	sub    $0x8,%esp
80101de8:	50                   	push   %eax
80101de9:	52                   	push   %edx
80101dea:	e8 78 f7 ff ff       	call   80101567 <bfree>
80101def:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101df2:	8b 45 08             	mov    0x8(%ebp),%eax
80101df5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101df8:	83 c2 08             	add    $0x8,%edx
80101dfb:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
80101e02:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e03:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101e07:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80101e0b:	7e b5                	jle    80101dc2 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101e0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e10:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e13:	85 c0                	test   %eax,%eax
80101e15:	0f 84 a1 00 00 00    	je     80101ebc <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101e1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e1e:	8b 50 4c             	mov    0x4c(%eax),%edx
80101e21:	8b 45 08             	mov    0x8(%ebp),%eax
80101e24:	8b 00                	mov    (%eax),%eax
80101e26:	83 ec 08             	sub    $0x8,%esp
80101e29:	52                   	push   %edx
80101e2a:	50                   	push   %eax
80101e2b:	e8 84 e3 ff ff       	call   801001b4 <bread>
80101e30:	83 c4 10             	add    $0x10,%esp
80101e33:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101e36:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e39:	83 c0 18             	add    $0x18,%eax
80101e3c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e3f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101e46:	eb 3c                	jmp    80101e84 <itrunc+0xd1>
      if(a[j])
80101e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e4b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e52:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e55:	01 d0                	add    %edx,%eax
80101e57:	8b 00                	mov    (%eax),%eax
80101e59:	85 c0                	test   %eax,%eax
80101e5b:	74 23                	je     80101e80 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101e5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e60:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e67:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e6a:	01 d0                	add    %edx,%eax
80101e6c:	8b 00                	mov    (%eax),%eax
80101e6e:	8b 55 08             	mov    0x8(%ebp),%edx
80101e71:	8b 12                	mov    (%edx),%edx
80101e73:	83 ec 08             	sub    $0x8,%esp
80101e76:	50                   	push   %eax
80101e77:	52                   	push   %edx
80101e78:	e8 ea f6 ff ff       	call   80101567 <bfree>
80101e7d:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101e80:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e87:	83 f8 7f             	cmp    $0x7f,%eax
80101e8a:	76 bc                	jbe    80101e48 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101e8c:	83 ec 0c             	sub    $0xc,%esp
80101e8f:	ff 75 ec             	pushl  -0x14(%ebp)
80101e92:	e8 94 e3 ff ff       	call   8010022b <brelse>
80101e97:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9d:	8b 40 4c             	mov    0x4c(%eax),%eax
80101ea0:	8b 55 08             	mov    0x8(%ebp),%edx
80101ea3:	8b 12                	mov    (%edx),%edx
80101ea5:	83 ec 08             	sub    $0x8,%esp
80101ea8:	50                   	push   %eax
80101ea9:	52                   	push   %edx
80101eaa:	e8 b8 f6 ff ff       	call   80101567 <bfree>
80101eaf:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101eb2:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb5:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101ebc:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebf:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  iupdate(ip);
80101ec6:	83 ec 0c             	sub    $0xc,%esp
80101ec9:	ff 75 08             	pushl  0x8(%ebp)
80101ecc:	e8 b9 f8 ff ff       	call   8010178a <iupdate>
80101ed1:	83 c4 10             	add    $0x10,%esp
}
80101ed4:	c9                   	leave  
80101ed5:	c3                   	ret    

80101ed6 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101ed6:	55                   	push   %ebp
80101ed7:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101ed9:	8b 45 08             	mov    0x8(%ebp),%eax
80101edc:	8b 00                	mov    (%eax),%eax
80101ede:	89 c2                	mov    %eax,%edx
80101ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ee3:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101ee6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee9:	8b 50 04             	mov    0x4(%eax),%edx
80101eec:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eef:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101ef2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef5:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101ef9:	8b 45 0c             	mov    0xc(%ebp),%eax
80101efc:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101eff:	8b 45 08             	mov    0x8(%ebp),%eax
80101f02:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101f06:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f09:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101f0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f10:	8b 50 20             	mov    0x20(%eax),%edx
80101f13:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f16:	89 50 18             	mov    %edx,0x18(%eax)

  st->ownerid = ip->ownerid;
80101f19:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1c:	0f b7 50 18          	movzwl 0x18(%eax),%edx
80101f20:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f23:	66 89 50 0e          	mov    %dx,0xe(%eax)
  st->groupid = ip->groupid;
80101f27:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2a:	0f b7 50 1a          	movzwl 0x1a(%eax),%edx
80101f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f31:	66 89 50 10          	mov    %dx,0x10(%eax)
  st->mode = ip->mode;
80101f35:	8b 45 08             	mov    0x8(%ebp),%eax
80101f38:	8b 50 1c             	mov    0x1c(%eax),%edx
80101f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f3e:	89 50 14             	mov    %edx,0x14(%eax)
}
80101f41:	5d                   	pop    %ebp
80101f42:	c3                   	ret    

80101f43 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f43:	55                   	push   %ebp
80101f44:	89 e5                	mov    %esp,%ebp
80101f46:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f49:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f50:	66 83 f8 03          	cmp    $0x3,%ax
80101f54:	75 5c                	jne    80101fb2 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f56:	8b 45 08             	mov    0x8(%ebp),%eax
80101f59:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f5d:	66 85 c0             	test   %ax,%ax
80101f60:	78 20                	js     80101f82 <readi+0x3f>
80101f62:	8b 45 08             	mov    0x8(%ebp),%eax
80101f65:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f69:	66 83 f8 09          	cmp    $0x9,%ax
80101f6d:	7f 13                	jg     80101f82 <readi+0x3f>
80101f6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f72:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f76:	98                   	cwtl   
80101f77:	8b 04 c5 40 22 11 80 	mov    -0x7feeddc0(,%eax,8),%eax
80101f7e:	85 c0                	test   %eax,%eax
80101f80:	75 0a                	jne    80101f8c <readi+0x49>
      return -1;
80101f82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f87:	e9 16 01 00 00       	jmp    801020a2 <readi+0x15f>
    return devsw[ip->major].read(ip, dst, n);
80101f8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8f:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f93:	98                   	cwtl   
80101f94:	8b 04 c5 40 22 11 80 	mov    -0x7feeddc0(,%eax,8),%eax
80101f9b:	8b 55 14             	mov    0x14(%ebp),%edx
80101f9e:	83 ec 04             	sub    $0x4,%esp
80101fa1:	52                   	push   %edx
80101fa2:	ff 75 0c             	pushl  0xc(%ebp)
80101fa5:	ff 75 08             	pushl  0x8(%ebp)
80101fa8:	ff d0                	call   *%eax
80101faa:	83 c4 10             	add    $0x10,%esp
80101fad:	e9 f0 00 00 00       	jmp    801020a2 <readi+0x15f>
  }

  if(off > ip->size || off + n < off)
80101fb2:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb5:	8b 40 20             	mov    0x20(%eax),%eax
80101fb8:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fbb:	72 0d                	jb     80101fca <readi+0x87>
80101fbd:	8b 55 10             	mov    0x10(%ebp),%edx
80101fc0:	8b 45 14             	mov    0x14(%ebp),%eax
80101fc3:	01 d0                	add    %edx,%eax
80101fc5:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fc8:	73 0a                	jae    80101fd4 <readi+0x91>
    return -1;
80101fca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fcf:	e9 ce 00 00 00       	jmp    801020a2 <readi+0x15f>
  if(off + n > ip->size)
80101fd4:	8b 55 10             	mov    0x10(%ebp),%edx
80101fd7:	8b 45 14             	mov    0x14(%ebp),%eax
80101fda:	01 c2                	add    %eax,%edx
80101fdc:	8b 45 08             	mov    0x8(%ebp),%eax
80101fdf:	8b 40 20             	mov    0x20(%eax),%eax
80101fe2:	39 c2                	cmp    %eax,%edx
80101fe4:	76 0c                	jbe    80101ff2 <readi+0xaf>
    n = ip->size - off;
80101fe6:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe9:	8b 40 20             	mov    0x20(%eax),%eax
80101fec:	2b 45 10             	sub    0x10(%ebp),%eax
80101fef:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ff2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101ff9:	e9 95 00 00 00       	jmp    80102093 <readi+0x150>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ffe:	8b 45 10             	mov    0x10(%ebp),%eax
80102001:	c1 e8 09             	shr    $0x9,%eax
80102004:	83 ec 08             	sub    $0x8,%esp
80102007:	50                   	push   %eax
80102008:	ff 75 08             	pushl  0x8(%ebp)
8010200b:	e8 84 fc ff ff       	call   80101c94 <bmap>
80102010:	83 c4 10             	add    $0x10,%esp
80102013:	89 c2                	mov    %eax,%edx
80102015:	8b 45 08             	mov    0x8(%ebp),%eax
80102018:	8b 00                	mov    (%eax),%eax
8010201a:	83 ec 08             	sub    $0x8,%esp
8010201d:	52                   	push   %edx
8010201e:	50                   	push   %eax
8010201f:	e8 90 e1 ff ff       	call   801001b4 <bread>
80102024:	83 c4 10             	add    $0x10,%esp
80102027:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010202a:	8b 45 10             	mov    0x10(%ebp),%eax
8010202d:	25 ff 01 00 00       	and    $0x1ff,%eax
80102032:	ba 00 02 00 00       	mov    $0x200,%edx
80102037:	89 d1                	mov    %edx,%ecx
80102039:	29 c1                	sub    %eax,%ecx
8010203b:	8b 45 14             	mov    0x14(%ebp),%eax
8010203e:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102041:	89 c2                	mov    %eax,%edx
80102043:	89 c8                	mov    %ecx,%eax
80102045:	39 d0                	cmp    %edx,%eax
80102047:	76 02                	jbe    8010204b <readi+0x108>
80102049:	89 d0                	mov    %edx,%eax
8010204b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
8010204e:	8b 45 10             	mov    0x10(%ebp),%eax
80102051:	25 ff 01 00 00       	and    $0x1ff,%eax
80102056:	8d 50 10             	lea    0x10(%eax),%edx
80102059:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010205c:	01 d0                	add    %edx,%eax
8010205e:	83 c0 08             	add    $0x8,%eax
80102061:	83 ec 04             	sub    $0x4,%esp
80102064:	ff 75 ec             	pushl  -0x14(%ebp)
80102067:	50                   	push   %eax
80102068:	ff 75 0c             	pushl  0xc(%ebp)
8010206b:	e8 b4 37 00 00       	call   80105824 <memmove>
80102070:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102073:	83 ec 0c             	sub    $0xc,%esp
80102076:	ff 75 f0             	pushl  -0x10(%ebp)
80102079:	e8 ad e1 ff ff       	call   8010022b <brelse>
8010207e:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102081:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102084:	01 45 f4             	add    %eax,-0xc(%ebp)
80102087:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010208a:	01 45 10             	add    %eax,0x10(%ebp)
8010208d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102090:	01 45 0c             	add    %eax,0xc(%ebp)
80102093:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102096:	3b 45 14             	cmp    0x14(%ebp),%eax
80102099:	0f 82 5f ff ff ff    	jb     80101ffe <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
8010209f:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020a2:	c9                   	leave  
801020a3:	c3                   	ret    

801020a4 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801020a4:	55                   	push   %ebp
801020a5:	89 e5                	mov    %esp,%ebp
801020a7:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801020aa:	8b 45 08             	mov    0x8(%ebp),%eax
801020ad:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020b1:	66 83 f8 03          	cmp    $0x3,%ax
801020b5:	75 5c                	jne    80102113 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801020b7:	8b 45 08             	mov    0x8(%ebp),%eax
801020ba:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020be:	66 85 c0             	test   %ax,%ax
801020c1:	78 20                	js     801020e3 <writei+0x3f>
801020c3:	8b 45 08             	mov    0x8(%ebp),%eax
801020c6:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020ca:	66 83 f8 09          	cmp    $0x9,%ax
801020ce:	7f 13                	jg     801020e3 <writei+0x3f>
801020d0:	8b 45 08             	mov    0x8(%ebp),%eax
801020d3:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020d7:	98                   	cwtl   
801020d8:	8b 04 c5 44 22 11 80 	mov    -0x7feeddbc(,%eax,8),%eax
801020df:	85 c0                	test   %eax,%eax
801020e1:	75 0a                	jne    801020ed <writei+0x49>
      return -1;
801020e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020e8:	e9 47 01 00 00       	jmp    80102234 <writei+0x190>
    return devsw[ip->major].write(ip, src, n);
801020ed:	8b 45 08             	mov    0x8(%ebp),%eax
801020f0:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020f4:	98                   	cwtl   
801020f5:	8b 04 c5 44 22 11 80 	mov    -0x7feeddbc(,%eax,8),%eax
801020fc:	8b 55 14             	mov    0x14(%ebp),%edx
801020ff:	83 ec 04             	sub    $0x4,%esp
80102102:	52                   	push   %edx
80102103:	ff 75 0c             	pushl  0xc(%ebp)
80102106:	ff 75 08             	pushl  0x8(%ebp)
80102109:	ff d0                	call   *%eax
8010210b:	83 c4 10             	add    $0x10,%esp
8010210e:	e9 21 01 00 00       	jmp    80102234 <writei+0x190>
  }

  if(off > ip->size || off + n < off)
80102113:	8b 45 08             	mov    0x8(%ebp),%eax
80102116:	8b 40 20             	mov    0x20(%eax),%eax
80102119:	3b 45 10             	cmp    0x10(%ebp),%eax
8010211c:	72 0d                	jb     8010212b <writei+0x87>
8010211e:	8b 55 10             	mov    0x10(%ebp),%edx
80102121:	8b 45 14             	mov    0x14(%ebp),%eax
80102124:	01 d0                	add    %edx,%eax
80102126:	3b 45 10             	cmp    0x10(%ebp),%eax
80102129:	73 0a                	jae    80102135 <writei+0x91>
    return -1;
8010212b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102130:	e9 ff 00 00 00       	jmp    80102234 <writei+0x190>
  if(off + n > MAXFILE*BSIZE)
80102135:	8b 55 10             	mov    0x10(%ebp),%edx
80102138:	8b 45 14             	mov    0x14(%ebp),%eax
8010213b:	01 d0                	add    %edx,%eax
8010213d:	3d 00 14 01 00       	cmp    $0x11400,%eax
80102142:	76 0a                	jbe    8010214e <writei+0xaa>
    return -1;
80102144:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102149:	e9 e6 00 00 00       	jmp    80102234 <writei+0x190>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010214e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102155:	e9 a3 00 00 00       	jmp    801021fd <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010215a:	8b 45 10             	mov    0x10(%ebp),%eax
8010215d:	c1 e8 09             	shr    $0x9,%eax
80102160:	83 ec 08             	sub    $0x8,%esp
80102163:	50                   	push   %eax
80102164:	ff 75 08             	pushl  0x8(%ebp)
80102167:	e8 28 fb ff ff       	call   80101c94 <bmap>
8010216c:	83 c4 10             	add    $0x10,%esp
8010216f:	89 c2                	mov    %eax,%edx
80102171:	8b 45 08             	mov    0x8(%ebp),%eax
80102174:	8b 00                	mov    (%eax),%eax
80102176:	83 ec 08             	sub    $0x8,%esp
80102179:	52                   	push   %edx
8010217a:	50                   	push   %eax
8010217b:	e8 34 e0 ff ff       	call   801001b4 <bread>
80102180:	83 c4 10             	add    $0x10,%esp
80102183:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102186:	8b 45 10             	mov    0x10(%ebp),%eax
80102189:	25 ff 01 00 00       	and    $0x1ff,%eax
8010218e:	ba 00 02 00 00       	mov    $0x200,%edx
80102193:	89 d1                	mov    %edx,%ecx
80102195:	29 c1                	sub    %eax,%ecx
80102197:	8b 45 14             	mov    0x14(%ebp),%eax
8010219a:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010219d:	89 c2                	mov    %eax,%edx
8010219f:	89 c8                	mov    %ecx,%eax
801021a1:	39 d0                	cmp    %edx,%eax
801021a3:	76 02                	jbe    801021a7 <writei+0x103>
801021a5:	89 d0                	mov    %edx,%eax
801021a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801021aa:	8b 45 10             	mov    0x10(%ebp),%eax
801021ad:	25 ff 01 00 00       	and    $0x1ff,%eax
801021b2:	8d 50 10             	lea    0x10(%eax),%edx
801021b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021b8:	01 d0                	add    %edx,%eax
801021ba:	83 c0 08             	add    $0x8,%eax
801021bd:	83 ec 04             	sub    $0x4,%esp
801021c0:	ff 75 ec             	pushl  -0x14(%ebp)
801021c3:	ff 75 0c             	pushl  0xc(%ebp)
801021c6:	50                   	push   %eax
801021c7:	e8 58 36 00 00       	call   80105824 <memmove>
801021cc:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
801021cf:	83 ec 0c             	sub    $0xc,%esp
801021d2:	ff 75 f0             	pushl  -0x10(%ebp)
801021d5:	e8 db 18 00 00       	call   80103ab5 <log_write>
801021da:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801021dd:	83 ec 0c             	sub    $0xc,%esp
801021e0:	ff 75 f0             	pushl  -0x10(%ebp)
801021e3:	e8 43 e0 ff ff       	call   8010022b <brelse>
801021e8:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801021eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021ee:	01 45 f4             	add    %eax,-0xc(%ebp)
801021f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021f4:	01 45 10             	add    %eax,0x10(%ebp)
801021f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021fa:	01 45 0c             	add    %eax,0xc(%ebp)
801021fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102200:	3b 45 14             	cmp    0x14(%ebp),%eax
80102203:	0f 82 51 ff ff ff    	jb     8010215a <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102209:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010220d:	74 22                	je     80102231 <writei+0x18d>
8010220f:	8b 45 08             	mov    0x8(%ebp),%eax
80102212:	8b 40 20             	mov    0x20(%eax),%eax
80102215:	3b 45 10             	cmp    0x10(%ebp),%eax
80102218:	73 17                	jae    80102231 <writei+0x18d>
    ip->size = off;
8010221a:	8b 45 08             	mov    0x8(%ebp),%eax
8010221d:	8b 55 10             	mov    0x10(%ebp),%edx
80102220:	89 50 20             	mov    %edx,0x20(%eax)
    iupdate(ip);
80102223:	83 ec 0c             	sub    $0xc,%esp
80102226:	ff 75 08             	pushl  0x8(%ebp)
80102229:	e8 5c f5 ff ff       	call   8010178a <iupdate>
8010222e:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102231:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102234:	c9                   	leave  
80102235:	c3                   	ret    

80102236 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102236:	55                   	push   %ebp
80102237:	89 e5                	mov    %esp,%ebp
80102239:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
8010223c:	83 ec 04             	sub    $0x4,%esp
8010223f:	6a 0e                	push   $0xe
80102241:	ff 75 0c             	pushl  0xc(%ebp)
80102244:	ff 75 08             	pushl  0x8(%ebp)
80102247:	e8 70 36 00 00       	call   801058bc <strncmp>
8010224c:	83 c4 10             	add    $0x10,%esp
}
8010224f:	c9                   	leave  
80102250:	c3                   	ret    

80102251 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102251:	55                   	push   %ebp
80102252:	89 e5                	mov    %esp,%ebp
80102254:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102257:	8b 45 08             	mov    0x8(%ebp),%eax
8010225a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010225e:	66 83 f8 01          	cmp    $0x1,%ax
80102262:	74 0d                	je     80102271 <dirlookup+0x20>
    panic("dirlookup not DIR");
80102264:	83 ec 0c             	sub    $0xc,%esp
80102267:	68 27 8f 10 80       	push   $0x80108f27
8010226c:	e8 32 e3 ff ff       	call   801005a3 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102271:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102278:	eb 7c                	jmp    801022f6 <dirlookup+0xa5>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010227a:	6a 10                	push   $0x10
8010227c:	ff 75 f4             	pushl  -0xc(%ebp)
8010227f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102282:	50                   	push   %eax
80102283:	ff 75 08             	pushl  0x8(%ebp)
80102286:	e8 b8 fc ff ff       	call   80101f43 <readi>
8010228b:	83 c4 10             	add    $0x10,%esp
8010228e:	83 f8 10             	cmp    $0x10,%eax
80102291:	74 0d                	je     801022a0 <dirlookup+0x4f>
      panic("dirlink read");
80102293:	83 ec 0c             	sub    $0xc,%esp
80102296:	68 39 8f 10 80       	push   $0x80108f39
8010229b:	e8 03 e3 ff ff       	call   801005a3 <panic>
    if(de.inum == 0)
801022a0:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022a4:	66 85 c0             	test   %ax,%ax
801022a7:	75 02                	jne    801022ab <dirlookup+0x5a>
      continue;
801022a9:	eb 47                	jmp    801022f2 <dirlookup+0xa1>
    if(namecmp(name, de.name) == 0){
801022ab:	83 ec 08             	sub    $0x8,%esp
801022ae:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022b1:	83 c0 02             	add    $0x2,%eax
801022b4:	50                   	push   %eax
801022b5:	ff 75 0c             	pushl  0xc(%ebp)
801022b8:	e8 79 ff ff ff       	call   80102236 <namecmp>
801022bd:	83 c4 10             	add    $0x10,%esp
801022c0:	85 c0                	test   %eax,%eax
801022c2:	75 2e                	jne    801022f2 <dirlookup+0xa1>
      // entry matches path element
      if(poff)
801022c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801022c8:	74 08                	je     801022d2 <dirlookup+0x81>
        *poff = off;
801022ca:	8b 45 10             	mov    0x10(%ebp),%eax
801022cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801022d0:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801022d2:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022d6:	0f b7 c0             	movzwl %ax,%eax
801022d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801022dc:	8b 45 08             	mov    0x8(%ebp),%eax
801022df:	8b 00                	mov    (%eax),%eax
801022e1:	83 ec 08             	sub    $0x8,%esp
801022e4:	ff 75 f0             	pushl  -0x10(%ebp)
801022e7:	50                   	push   %eax
801022e8:	e8 85 f5 ff ff       	call   80101872 <iget>
801022ed:	83 c4 10             	add    $0x10,%esp
801022f0:	eb 18                	jmp    8010230a <dirlookup+0xb9>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801022f2:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801022f6:	8b 45 08             	mov    0x8(%ebp),%eax
801022f9:	8b 40 20             	mov    0x20(%eax),%eax
801022fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801022ff:	0f 87 75 ff ff ff    	ja     8010227a <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102305:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010230a:	c9                   	leave  
8010230b:	c3                   	ret    

8010230c <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
8010230c:	55                   	push   %ebp
8010230d:	89 e5                	mov    %esp,%ebp
8010230f:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102312:	83 ec 04             	sub    $0x4,%esp
80102315:	6a 00                	push   $0x0
80102317:	ff 75 0c             	pushl  0xc(%ebp)
8010231a:	ff 75 08             	pushl  0x8(%ebp)
8010231d:	e8 2f ff ff ff       	call   80102251 <dirlookup>
80102322:	83 c4 10             	add    $0x10,%esp
80102325:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102328:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010232c:	74 18                	je     80102346 <dirlink+0x3a>
    iput(ip);
8010232e:	83 ec 0c             	sub    $0xc,%esp
80102331:	ff 75 f0             	pushl  -0x10(%ebp)
80102334:	e8 48 f8 ff ff       	call   80101b81 <iput>
80102339:	83 c4 10             	add    $0x10,%esp
    return -1;
8010233c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102341:	e9 9b 00 00 00       	jmp    801023e1 <dirlink+0xd5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010234d:	eb 3b                	jmp    8010238a <dirlink+0x7e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102352:	6a 10                	push   $0x10
80102354:	50                   	push   %eax
80102355:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102358:	50                   	push   %eax
80102359:	ff 75 08             	pushl  0x8(%ebp)
8010235c:	e8 e2 fb ff ff       	call   80101f43 <readi>
80102361:	83 c4 10             	add    $0x10,%esp
80102364:	83 f8 10             	cmp    $0x10,%eax
80102367:	74 0d                	je     80102376 <dirlink+0x6a>
      panic("dirlink read");
80102369:	83 ec 0c             	sub    $0xc,%esp
8010236c:	68 39 8f 10 80       	push   $0x80108f39
80102371:	e8 2d e2 ff ff       	call   801005a3 <panic>
    if(de.inum == 0)
80102376:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010237a:	66 85 c0             	test   %ax,%ax
8010237d:	75 02                	jne    80102381 <dirlink+0x75>
      break;
8010237f:	eb 16                	jmp    80102397 <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102381:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102384:	83 c0 10             	add    $0x10,%eax
80102387:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010238a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010238d:	8b 45 08             	mov    0x8(%ebp),%eax
80102390:	8b 40 20             	mov    0x20(%eax),%eax
80102393:	39 c2                	cmp    %eax,%edx
80102395:	72 b8                	jb     8010234f <dirlink+0x43>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80102397:	83 ec 04             	sub    $0x4,%esp
8010239a:	6a 0e                	push   $0xe
8010239c:	ff 75 0c             	pushl  0xc(%ebp)
8010239f:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023a2:	83 c0 02             	add    $0x2,%eax
801023a5:	50                   	push   %eax
801023a6:	e8 67 35 00 00       	call   80105912 <strncpy>
801023ab:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801023ae:	8b 45 10             	mov    0x10(%ebp),%eax
801023b1:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023b8:	6a 10                	push   $0x10
801023ba:	50                   	push   %eax
801023bb:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023be:	50                   	push   %eax
801023bf:	ff 75 08             	pushl  0x8(%ebp)
801023c2:	e8 dd fc ff ff       	call   801020a4 <writei>
801023c7:	83 c4 10             	add    $0x10,%esp
801023ca:	83 f8 10             	cmp    $0x10,%eax
801023cd:	74 0d                	je     801023dc <dirlink+0xd0>
    panic("dirlink");
801023cf:	83 ec 0c             	sub    $0xc,%esp
801023d2:	68 46 8f 10 80       	push   $0x80108f46
801023d7:	e8 c7 e1 ff ff       	call   801005a3 <panic>
  
  return 0;
801023dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801023e1:	c9                   	leave  
801023e2:	c3                   	ret    

801023e3 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801023e3:	55                   	push   %ebp
801023e4:	89 e5                	mov    %esp,%ebp
801023e6:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
801023e9:	eb 04                	jmp    801023ef <skipelem+0xc>
    path++;
801023eb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801023ef:	8b 45 08             	mov    0x8(%ebp),%eax
801023f2:	0f b6 00             	movzbl (%eax),%eax
801023f5:	3c 2f                	cmp    $0x2f,%al
801023f7:	74 f2                	je     801023eb <skipelem+0x8>
    path++;
  if(*path == 0)
801023f9:	8b 45 08             	mov    0x8(%ebp),%eax
801023fc:	0f b6 00             	movzbl (%eax),%eax
801023ff:	84 c0                	test   %al,%al
80102401:	75 07                	jne    8010240a <skipelem+0x27>
    return 0;
80102403:	b8 00 00 00 00       	mov    $0x0,%eax
80102408:	eb 7b                	jmp    80102485 <skipelem+0xa2>
  s = path;
8010240a:	8b 45 08             	mov    0x8(%ebp),%eax
8010240d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102410:	eb 04                	jmp    80102416 <skipelem+0x33>
    path++;
80102412:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102416:	8b 45 08             	mov    0x8(%ebp),%eax
80102419:	0f b6 00             	movzbl (%eax),%eax
8010241c:	3c 2f                	cmp    $0x2f,%al
8010241e:	74 0a                	je     8010242a <skipelem+0x47>
80102420:	8b 45 08             	mov    0x8(%ebp),%eax
80102423:	0f b6 00             	movzbl (%eax),%eax
80102426:	84 c0                	test   %al,%al
80102428:	75 e8                	jne    80102412 <skipelem+0x2f>
    path++;
  len = path - s;
8010242a:	8b 55 08             	mov    0x8(%ebp),%edx
8010242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102430:	29 c2                	sub    %eax,%edx
80102432:	89 d0                	mov    %edx,%eax
80102434:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102437:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010243b:	7e 15                	jle    80102452 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
8010243d:	83 ec 04             	sub    $0x4,%esp
80102440:	6a 0e                	push   $0xe
80102442:	ff 75 f4             	pushl  -0xc(%ebp)
80102445:	ff 75 0c             	pushl  0xc(%ebp)
80102448:	e8 d7 33 00 00       	call   80105824 <memmove>
8010244d:	83 c4 10             	add    $0x10,%esp
80102450:	eb 20                	jmp    80102472 <skipelem+0x8f>
  else {
    memmove(name, s, len);
80102452:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102455:	83 ec 04             	sub    $0x4,%esp
80102458:	50                   	push   %eax
80102459:	ff 75 f4             	pushl  -0xc(%ebp)
8010245c:	ff 75 0c             	pushl  0xc(%ebp)
8010245f:	e8 c0 33 00 00       	call   80105824 <memmove>
80102464:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102467:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010246a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010246d:	01 d0                	add    %edx,%eax
8010246f:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102472:	eb 04                	jmp    80102478 <skipelem+0x95>
    path++;
80102474:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102478:	8b 45 08             	mov    0x8(%ebp),%eax
8010247b:	0f b6 00             	movzbl (%eax),%eax
8010247e:	3c 2f                	cmp    $0x2f,%al
80102480:	74 f2                	je     80102474 <skipelem+0x91>
    path++;
  return path;
80102482:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102485:	c9                   	leave  
80102486:	c3                   	ret    

80102487 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102487:	55                   	push   %ebp
80102488:	89 e5                	mov    %esp,%ebp
8010248a:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/'){
8010248d:	8b 45 08             	mov    0x8(%ebp),%eax
80102490:	0f b6 00             	movzbl (%eax),%eax
80102493:	3c 2f                	cmp    $0x2f,%al
80102495:	75 24                	jne    801024bb <namex+0x34>
cprintf("fs.c::static struct inode* namex(char *path, int nameiparent, char *name)\n");
80102497:	83 ec 0c             	sub    $0xc,%esp
8010249a:	68 50 8f 10 80       	push   $0x80108f50
8010249f:	e8 62 df ff ff       	call   80100406 <cprintf>
801024a4:	83 c4 10             	add    $0x10,%esp
    ip = iget(ROOTDEV, ROOTINO);
801024a7:	83 ec 08             	sub    $0x8,%esp
801024aa:	6a 01                	push   $0x1
801024ac:	6a 01                	push   $0x1
801024ae:	e8 bf f3 ff ff       	call   80101872 <iget>
801024b3:	83 c4 10             	add    $0x10,%esp
801024b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801024b9:	eb 18                	jmp    801024d3 <namex+0x4c>
}
  else
    ip = idup(proc->cwd);
801024bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801024c1:	8b 40 68             	mov    0x68(%eax),%eax
801024c4:	83 ec 0c             	sub    $0xc,%esp
801024c7:	50                   	push   %eax
801024c8:	e8 84 f4 ff ff       	call   80101951 <idup>
801024cd:	83 c4 10             	add    $0x10,%esp
801024d0:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801024d3:	e9 9e 00 00 00       	jmp    80102576 <namex+0xef>
    ilock(ip);
801024d8:	83 ec 0c             	sub    $0xc,%esp
801024db:	ff 75 f4             	pushl  -0xc(%ebp)
801024de:	e8 a8 f4 ff ff       	call   8010198b <ilock>
801024e3:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
801024e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024e9:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801024ed:	66 83 f8 01          	cmp    $0x1,%ax
801024f1:	74 18                	je     8010250b <namex+0x84>
      iunlockput(ip);
801024f3:	83 ec 0c             	sub    $0xc,%esp
801024f6:	ff 75 f4             	pushl  -0xc(%ebp)
801024f9:	e8 72 f7 ff ff       	call   80101c70 <iunlockput>
801024fe:	83 c4 10             	add    $0x10,%esp
      return 0;
80102501:	b8 00 00 00 00       	mov    $0x0,%eax
80102506:	e9 a7 00 00 00       	jmp    801025b2 <namex+0x12b>
    }
    if(nameiparent && *path == '\0'){
8010250b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010250f:	74 20                	je     80102531 <namex+0xaa>
80102511:	8b 45 08             	mov    0x8(%ebp),%eax
80102514:	0f b6 00             	movzbl (%eax),%eax
80102517:	84 c0                	test   %al,%al
80102519:	75 16                	jne    80102531 <namex+0xaa>
      // Stop one level early.
      iunlock(ip);
8010251b:	83 ec 0c             	sub    $0xc,%esp
8010251e:	ff 75 f4             	pushl  -0xc(%ebp)
80102521:	e8 ea f5 ff ff       	call   80101b10 <iunlock>
80102526:	83 c4 10             	add    $0x10,%esp
      return ip;
80102529:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010252c:	e9 81 00 00 00       	jmp    801025b2 <namex+0x12b>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102531:	83 ec 04             	sub    $0x4,%esp
80102534:	6a 00                	push   $0x0
80102536:	ff 75 10             	pushl  0x10(%ebp)
80102539:	ff 75 f4             	pushl  -0xc(%ebp)
8010253c:	e8 10 fd ff ff       	call   80102251 <dirlookup>
80102541:	83 c4 10             	add    $0x10,%esp
80102544:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102547:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010254b:	75 15                	jne    80102562 <namex+0xdb>
      iunlockput(ip);
8010254d:	83 ec 0c             	sub    $0xc,%esp
80102550:	ff 75 f4             	pushl  -0xc(%ebp)
80102553:	e8 18 f7 ff ff       	call   80101c70 <iunlockput>
80102558:	83 c4 10             	add    $0x10,%esp
      return 0;
8010255b:	b8 00 00 00 00       	mov    $0x0,%eax
80102560:	eb 50                	jmp    801025b2 <namex+0x12b>
    }
    iunlockput(ip);
80102562:	83 ec 0c             	sub    $0xc,%esp
80102565:	ff 75 f4             	pushl  -0xc(%ebp)
80102568:	e8 03 f7 ff ff       	call   80101c70 <iunlockput>
8010256d:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102570:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102573:	89 45 f4             	mov    %eax,-0xc(%ebp)
    ip = iget(ROOTDEV, ROOTINO);
}
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102576:	83 ec 08             	sub    $0x8,%esp
80102579:	ff 75 10             	pushl  0x10(%ebp)
8010257c:	ff 75 08             	pushl  0x8(%ebp)
8010257f:	e8 5f fe ff ff       	call   801023e3 <skipelem>
80102584:	83 c4 10             	add    $0x10,%esp
80102587:	89 45 08             	mov    %eax,0x8(%ebp)
8010258a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010258e:	0f 85 44 ff ff ff    	jne    801024d8 <namex+0x51>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102594:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102598:	74 15                	je     801025af <namex+0x128>
    iput(ip);
8010259a:	83 ec 0c             	sub    $0xc,%esp
8010259d:	ff 75 f4             	pushl  -0xc(%ebp)
801025a0:	e8 dc f5 ff ff       	call   80101b81 <iput>
801025a5:	83 c4 10             	add    $0x10,%esp
    return 0;
801025a8:	b8 00 00 00 00       	mov    $0x0,%eax
801025ad:	eb 03                	jmp    801025b2 <namex+0x12b>
  }
  return ip;
801025af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801025b2:	c9                   	leave  
801025b3:	c3                   	ret    

801025b4 <namei>:

struct inode*
namei(char *path)
{
801025b4:	55                   	push   %ebp
801025b5:	89 e5                	mov    %esp,%ebp
801025b7:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801025ba:	83 ec 04             	sub    $0x4,%esp
801025bd:	8d 45 ea             	lea    -0x16(%ebp),%eax
801025c0:	50                   	push   %eax
801025c1:	6a 00                	push   $0x0
801025c3:	ff 75 08             	pushl  0x8(%ebp)
801025c6:	e8 bc fe ff ff       	call   80102487 <namex>
801025cb:	83 c4 10             	add    $0x10,%esp
}
801025ce:	c9                   	leave  
801025cf:	c3                   	ret    

801025d0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801025d6:	83 ec 04             	sub    $0x4,%esp
801025d9:	ff 75 0c             	pushl  0xc(%ebp)
801025dc:	6a 01                	push   $0x1
801025de:	ff 75 08             	pushl  0x8(%ebp)
801025e1:	e8 a1 fe ff ff       	call   80102487 <namex>
801025e6:	83 c4 10             	add    $0x10,%esp
}
801025e9:	c9                   	leave  
801025ea:	c3                   	ret    

801025eb <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801025eb:	55                   	push   %ebp
801025ec:	89 e5                	mov    %esp,%ebp
801025ee:	83 ec 14             	sub    $0x14,%esp
801025f1:	8b 45 08             	mov    0x8(%ebp),%eax
801025f4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025f8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801025fc:	89 c2                	mov    %eax,%edx
801025fe:	ec                   	in     (%dx),%al
801025ff:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102602:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102606:	c9                   	leave  
80102607:	c3                   	ret    

80102608 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102608:	55                   	push   %ebp
80102609:	89 e5                	mov    %esp,%ebp
8010260b:	57                   	push   %edi
8010260c:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010260d:	8b 55 08             	mov    0x8(%ebp),%edx
80102610:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102613:	8b 45 10             	mov    0x10(%ebp),%eax
80102616:	89 cb                	mov    %ecx,%ebx
80102618:	89 df                	mov    %ebx,%edi
8010261a:	89 c1                	mov    %eax,%ecx
8010261c:	fc                   	cld    
8010261d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010261f:	89 c8                	mov    %ecx,%eax
80102621:	89 fb                	mov    %edi,%ebx
80102623:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102626:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102629:	5b                   	pop    %ebx
8010262a:	5f                   	pop    %edi
8010262b:	5d                   	pop    %ebp
8010262c:	c3                   	ret    

8010262d <outb>:

static inline void
outb(ushort port, uchar data)
{
8010262d:	55                   	push   %ebp
8010262e:	89 e5                	mov    %esp,%ebp
80102630:	83 ec 08             	sub    $0x8,%esp
80102633:	8b 55 08             	mov    0x8(%ebp),%edx
80102636:	8b 45 0c             	mov    0xc(%ebp),%eax
80102639:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010263d:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102640:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102644:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102648:	ee                   	out    %al,(%dx)
}
80102649:	c9                   	leave  
8010264a:	c3                   	ret    

8010264b <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
8010264b:	55                   	push   %ebp
8010264c:	89 e5                	mov    %esp,%ebp
8010264e:	56                   	push   %esi
8010264f:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102650:	8b 55 08             	mov    0x8(%ebp),%edx
80102653:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102656:	8b 45 10             	mov    0x10(%ebp),%eax
80102659:	89 cb                	mov    %ecx,%ebx
8010265b:	89 de                	mov    %ebx,%esi
8010265d:	89 c1                	mov    %eax,%ecx
8010265f:	fc                   	cld    
80102660:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102662:	89 c8                	mov    %ecx,%eax
80102664:	89 f3                	mov    %esi,%ebx
80102666:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102669:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
8010266c:	5b                   	pop    %ebx
8010266d:	5e                   	pop    %esi
8010266e:	5d                   	pop    %ebp
8010266f:	c3                   	ret    

80102670 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102670:	55                   	push   %ebp
80102671:	89 e5                	mov    %esp,%ebp
80102673:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102676:	90                   	nop
80102677:	68 f7 01 00 00       	push   $0x1f7
8010267c:	e8 6a ff ff ff       	call   801025eb <inb>
80102681:	83 c4 04             	add    $0x4,%esp
80102684:	0f b6 c0             	movzbl %al,%eax
80102687:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010268a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010268d:	25 c0 00 00 00       	and    $0xc0,%eax
80102692:	83 f8 40             	cmp    $0x40,%eax
80102695:	75 e0                	jne    80102677 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102697:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010269b:	74 11                	je     801026ae <idewait+0x3e>
8010269d:	8b 45 fc             	mov    -0x4(%ebp),%eax
801026a0:	83 e0 21             	and    $0x21,%eax
801026a3:	85 c0                	test   %eax,%eax
801026a5:	74 07                	je     801026ae <idewait+0x3e>
    return -1;
801026a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801026ac:	eb 05                	jmp    801026b3 <idewait+0x43>
  return 0;
801026ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
801026b3:	c9                   	leave  
801026b4:	c3                   	ret    

801026b5 <ideinit>:

void
ideinit(void)
{
801026b5:	55                   	push   %ebp
801026b6:	89 e5                	mov    %esp,%ebp
801026b8:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
801026bb:	83 ec 08             	sub    $0x8,%esp
801026be:	68 9b 8f 10 80       	push   $0x80108f9b
801026c3:	68 20 c6 10 80       	push   $0x8010c620
801026c8:	e8 01 2e 00 00       	call   801054ce <initlock>
801026cd:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801026d0:	83 ec 0c             	sub    $0xc,%esp
801026d3:	6a 0e                	push   $0xe
801026d5:	e8 86 2a 00 00       	call   80105160 <picenable>
801026da:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801026dd:	a1 60 3a 11 80       	mov    0x80113a60,%eax
801026e2:	83 e8 01             	sub    $0x1,%eax
801026e5:	83 ec 08             	sub    $0x8,%esp
801026e8:	50                   	push   %eax
801026e9:	6a 0e                	push   $0xe
801026eb:	e8 6d 04 00 00       	call   80102b5d <ioapicenable>
801026f0:	83 c4 10             	add    $0x10,%esp
  idewait(0);
801026f3:	83 ec 0c             	sub    $0xc,%esp
801026f6:	6a 00                	push   $0x0
801026f8:	e8 73 ff ff ff       	call   80102670 <idewait>
801026fd:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102700:	83 ec 08             	sub    $0x8,%esp
80102703:	68 f0 00 00 00       	push   $0xf0
80102708:	68 f6 01 00 00       	push   $0x1f6
8010270d:	e8 1b ff ff ff       	call   8010262d <outb>
80102712:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102715:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010271c:	eb 24                	jmp    80102742 <ideinit+0x8d>
    if(inb(0x1f7) != 0){
8010271e:	83 ec 0c             	sub    $0xc,%esp
80102721:	68 f7 01 00 00       	push   $0x1f7
80102726:	e8 c0 fe ff ff       	call   801025eb <inb>
8010272b:	83 c4 10             	add    $0x10,%esp
8010272e:	84 c0                	test   %al,%al
80102730:	74 0c                	je     8010273e <ideinit+0x89>
      havedisk1 = 1;
80102732:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
80102739:	00 00 00 
      break;
8010273c:	eb 0d                	jmp    8010274b <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
8010273e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102742:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102749:	7e d3                	jle    8010271e <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
8010274b:	83 ec 08             	sub    $0x8,%esp
8010274e:	68 e0 00 00 00       	push   $0xe0
80102753:	68 f6 01 00 00       	push   $0x1f6
80102758:	e8 d0 fe ff ff       	call   8010262d <outb>
8010275d:	83 c4 10             	add    $0x10,%esp
}
80102760:	c9                   	leave  
80102761:	c3                   	ret    

80102762 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102762:	55                   	push   %ebp
80102763:	89 e5                	mov    %esp,%ebp
80102765:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102768:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010276c:	75 0d                	jne    8010277b <idestart+0x19>
    panic("idestart");
8010276e:	83 ec 0c             	sub    $0xc,%esp
80102771:	68 9f 8f 10 80       	push   $0x80108f9f
80102776:	e8 28 de ff ff       	call   801005a3 <panic>
  if(b->blockno >= FSSIZE)
8010277b:	8b 45 08             	mov    0x8(%ebp),%eax
8010277e:	8b 40 08             	mov    0x8(%eax),%eax
80102781:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80102786:	76 0d                	jbe    80102795 <idestart+0x33>
    panic("incorrect blockno");
80102788:	83 ec 0c             	sub    $0xc,%esp
8010278b:	68 a8 8f 10 80       	push   $0x80108fa8
80102790:	e8 0e de ff ff       	call   801005a3 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102795:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
8010279c:	8b 45 08             	mov    0x8(%ebp),%eax
8010279f:	8b 50 08             	mov    0x8(%eax),%edx
801027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027a5:	0f af c2             	imul   %edx,%eax
801027a8:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
801027ab:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801027af:	7e 0d                	jle    801027be <idestart+0x5c>
801027b1:	83 ec 0c             	sub    $0xc,%esp
801027b4:	68 9f 8f 10 80       	push   $0x80108f9f
801027b9:	e8 e5 dd ff ff       	call   801005a3 <panic>
  
  idewait(0);
801027be:	83 ec 0c             	sub    $0xc,%esp
801027c1:	6a 00                	push   $0x0
801027c3:	e8 a8 fe ff ff       	call   80102670 <idewait>
801027c8:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
801027cb:	83 ec 08             	sub    $0x8,%esp
801027ce:	6a 00                	push   $0x0
801027d0:	68 f6 03 00 00       	push   $0x3f6
801027d5:	e8 53 fe ff ff       	call   8010262d <outb>
801027da:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
801027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027e0:	0f b6 c0             	movzbl %al,%eax
801027e3:	83 ec 08             	sub    $0x8,%esp
801027e6:	50                   	push   %eax
801027e7:	68 f2 01 00 00       	push   $0x1f2
801027ec:	e8 3c fe ff ff       	call   8010262d <outb>
801027f1:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
801027f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027f7:	0f b6 c0             	movzbl %al,%eax
801027fa:	83 ec 08             	sub    $0x8,%esp
801027fd:	50                   	push   %eax
801027fe:	68 f3 01 00 00       	push   $0x1f3
80102803:	e8 25 fe ff ff       	call   8010262d <outb>
80102808:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
8010280b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010280e:	c1 f8 08             	sar    $0x8,%eax
80102811:	0f b6 c0             	movzbl %al,%eax
80102814:	83 ec 08             	sub    $0x8,%esp
80102817:	50                   	push   %eax
80102818:	68 f4 01 00 00       	push   $0x1f4
8010281d:	e8 0b fe ff ff       	call   8010262d <outb>
80102822:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
80102825:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102828:	c1 f8 10             	sar    $0x10,%eax
8010282b:	0f b6 c0             	movzbl %al,%eax
8010282e:	83 ec 08             	sub    $0x8,%esp
80102831:	50                   	push   %eax
80102832:	68 f5 01 00 00       	push   $0x1f5
80102837:	e8 f1 fd ff ff       	call   8010262d <outb>
8010283c:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010283f:	8b 45 08             	mov    0x8(%ebp),%eax
80102842:	8b 40 04             	mov    0x4(%eax),%eax
80102845:	83 e0 01             	and    $0x1,%eax
80102848:	c1 e0 04             	shl    $0x4,%eax
8010284b:	89 c2                	mov    %eax,%edx
8010284d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102850:	c1 f8 18             	sar    $0x18,%eax
80102853:	83 e0 0f             	and    $0xf,%eax
80102856:	09 d0                	or     %edx,%eax
80102858:	83 c8 e0             	or     $0xffffffe0,%eax
8010285b:	0f b6 c0             	movzbl %al,%eax
8010285e:	83 ec 08             	sub    $0x8,%esp
80102861:	50                   	push   %eax
80102862:	68 f6 01 00 00       	push   $0x1f6
80102867:	e8 c1 fd ff ff       	call   8010262d <outb>
8010286c:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
8010286f:	8b 45 08             	mov    0x8(%ebp),%eax
80102872:	8b 00                	mov    (%eax),%eax
80102874:	83 e0 04             	and    $0x4,%eax
80102877:	85 c0                	test   %eax,%eax
80102879:	74 30                	je     801028ab <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
8010287b:	83 ec 08             	sub    $0x8,%esp
8010287e:	6a 30                	push   $0x30
80102880:	68 f7 01 00 00       	push   $0x1f7
80102885:	e8 a3 fd ff ff       	call   8010262d <outb>
8010288a:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
8010288d:	8b 45 08             	mov    0x8(%ebp),%eax
80102890:	83 c0 18             	add    $0x18,%eax
80102893:	83 ec 04             	sub    $0x4,%esp
80102896:	68 80 00 00 00       	push   $0x80
8010289b:	50                   	push   %eax
8010289c:	68 f0 01 00 00       	push   $0x1f0
801028a1:	e8 a5 fd ff ff       	call   8010264b <outsl>
801028a6:	83 c4 10             	add    $0x10,%esp
801028a9:	eb 12                	jmp    801028bd <idestart+0x15b>
  } else {
    outb(0x1f7, IDE_CMD_READ);
801028ab:	83 ec 08             	sub    $0x8,%esp
801028ae:	6a 20                	push   $0x20
801028b0:	68 f7 01 00 00       	push   $0x1f7
801028b5:	e8 73 fd ff ff       	call   8010262d <outb>
801028ba:	83 c4 10             	add    $0x10,%esp
  }
}
801028bd:	c9                   	leave  
801028be:	c3                   	ret    

801028bf <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801028bf:	55                   	push   %ebp
801028c0:	89 e5                	mov    %esp,%ebp
801028c2:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801028c5:	83 ec 0c             	sub    $0xc,%esp
801028c8:	68 20 c6 10 80       	push   $0x8010c620
801028cd:	e8 1d 2c 00 00       	call   801054ef <acquire>
801028d2:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801028d5:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801028da:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801028e1:	75 15                	jne    801028f8 <ideintr+0x39>
    release(&idelock);
801028e3:	83 ec 0c             	sub    $0xc,%esp
801028e6:	68 20 c6 10 80       	push   $0x8010c620
801028eb:	e8 65 2c 00 00       	call   80105555 <release>
801028f0:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
801028f3:	e9 9a 00 00 00       	jmp    80102992 <ideintr+0xd3>
  }
  idequeue = b->qnext;
801028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028fb:	8b 40 14             	mov    0x14(%eax),%eax
801028fe:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102903:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102906:	8b 00                	mov    (%eax),%eax
80102908:	83 e0 04             	and    $0x4,%eax
8010290b:	85 c0                	test   %eax,%eax
8010290d:	75 2d                	jne    8010293c <ideintr+0x7d>
8010290f:	83 ec 0c             	sub    $0xc,%esp
80102912:	6a 01                	push   $0x1
80102914:	e8 57 fd ff ff       	call   80102670 <idewait>
80102919:	83 c4 10             	add    $0x10,%esp
8010291c:	85 c0                	test   %eax,%eax
8010291e:	78 1c                	js     8010293c <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
80102920:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102923:	83 c0 18             	add    $0x18,%eax
80102926:	83 ec 04             	sub    $0x4,%esp
80102929:	68 80 00 00 00       	push   $0x80
8010292e:	50                   	push   %eax
8010292f:	68 f0 01 00 00       	push   $0x1f0
80102934:	e8 cf fc ff ff       	call   80102608 <insl>
80102939:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010293f:	8b 00                	mov    (%eax),%eax
80102941:	83 c8 02             	or     $0x2,%eax
80102944:	89 c2                	mov    %eax,%edx
80102946:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102949:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
8010294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010294e:	8b 00                	mov    (%eax),%eax
80102950:	83 e0 fb             	and    $0xfffffffb,%eax
80102953:	89 c2                	mov    %eax,%edx
80102955:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102958:	89 10                	mov    %edx,(%eax)
  wakeup(b);
8010295a:	83 ec 0c             	sub    $0xc,%esp
8010295d:	ff 75 f4             	pushl  -0xc(%ebp)
80102960:	e8 8e 25 00 00       	call   80104ef3 <wakeup>
80102965:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102968:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010296d:	85 c0                	test   %eax,%eax
8010296f:	74 11                	je     80102982 <ideintr+0xc3>
    idestart(idequeue);
80102971:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102976:	83 ec 0c             	sub    $0xc,%esp
80102979:	50                   	push   %eax
8010297a:	e8 e3 fd ff ff       	call   80102762 <idestart>
8010297f:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102982:	83 ec 0c             	sub    $0xc,%esp
80102985:	68 20 c6 10 80       	push   $0x8010c620
8010298a:	e8 c6 2b 00 00       	call   80105555 <release>
8010298f:	83 c4 10             	add    $0x10,%esp
}
80102992:	c9                   	leave  
80102993:	c3                   	ret    

80102994 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102994:	55                   	push   %ebp
80102995:	89 e5                	mov    %esp,%ebp
80102997:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
8010299a:	8b 45 08             	mov    0x8(%ebp),%eax
8010299d:	8b 00                	mov    (%eax),%eax
8010299f:	83 e0 01             	and    $0x1,%eax
801029a2:	85 c0                	test   %eax,%eax
801029a4:	75 0d                	jne    801029b3 <iderw+0x1f>
    panic("iderw: buf not busy");
801029a6:	83 ec 0c             	sub    $0xc,%esp
801029a9:	68 ba 8f 10 80       	push   $0x80108fba
801029ae:	e8 f0 db ff ff       	call   801005a3 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801029b3:	8b 45 08             	mov    0x8(%ebp),%eax
801029b6:	8b 00                	mov    (%eax),%eax
801029b8:	83 e0 06             	and    $0x6,%eax
801029bb:	83 f8 02             	cmp    $0x2,%eax
801029be:	75 0d                	jne    801029cd <iderw+0x39>
    panic("iderw: nothing to do");
801029c0:	83 ec 0c             	sub    $0xc,%esp
801029c3:	68 ce 8f 10 80       	push   $0x80108fce
801029c8:	e8 d6 db ff ff       	call   801005a3 <panic>
  if(b->dev != 0 && !havedisk1)
801029cd:	8b 45 08             	mov    0x8(%ebp),%eax
801029d0:	8b 40 04             	mov    0x4(%eax),%eax
801029d3:	85 c0                	test   %eax,%eax
801029d5:	74 16                	je     801029ed <iderw+0x59>
801029d7:	a1 58 c6 10 80       	mov    0x8010c658,%eax
801029dc:	85 c0                	test   %eax,%eax
801029de:	75 0d                	jne    801029ed <iderw+0x59>
    panic("iderw: ide disk 1 not present");
801029e0:	83 ec 0c             	sub    $0xc,%esp
801029e3:	68 e3 8f 10 80       	push   $0x80108fe3
801029e8:	e8 b6 db ff ff       	call   801005a3 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801029ed:	83 ec 0c             	sub    $0xc,%esp
801029f0:	68 20 c6 10 80       	push   $0x8010c620
801029f5:	e8 f5 2a 00 00       	call   801054ef <acquire>
801029fa:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
801029fd:	8b 45 08             	mov    0x8(%ebp),%eax
80102a00:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a07:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
80102a0e:	eb 0b                	jmp    80102a1b <iderw+0x87>
80102a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a13:	8b 00                	mov    (%eax),%eax
80102a15:	83 c0 14             	add    $0x14,%eax
80102a18:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a1e:	8b 00                	mov    (%eax),%eax
80102a20:	85 c0                	test   %eax,%eax
80102a22:	75 ec                	jne    80102a10 <iderw+0x7c>
    ;
  *pp = b;
80102a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a27:	8b 55 08             	mov    0x8(%ebp),%edx
80102a2a:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102a2c:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102a31:	3b 45 08             	cmp    0x8(%ebp),%eax
80102a34:	75 0e                	jne    80102a44 <iderw+0xb0>
    idestart(b);
80102a36:	83 ec 0c             	sub    $0xc,%esp
80102a39:	ff 75 08             	pushl  0x8(%ebp)
80102a3c:	e8 21 fd ff ff       	call   80102762 <idestart>
80102a41:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a44:	eb 13                	jmp    80102a59 <iderw+0xc5>
    sleep(b, &idelock);
80102a46:	83 ec 08             	sub    $0x8,%esp
80102a49:	68 20 c6 10 80       	push   $0x8010c620
80102a4e:	ff 75 08             	pushl  0x8(%ebp)
80102a51:	e8 b4 23 00 00       	call   80104e0a <sleep>
80102a56:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a59:	8b 45 08             	mov    0x8(%ebp),%eax
80102a5c:	8b 00                	mov    (%eax),%eax
80102a5e:	83 e0 06             	and    $0x6,%eax
80102a61:	83 f8 02             	cmp    $0x2,%eax
80102a64:	75 e0                	jne    80102a46 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102a66:	83 ec 0c             	sub    $0xc,%esp
80102a69:	68 20 c6 10 80       	push   $0x8010c620
80102a6e:	e8 e2 2a 00 00       	call   80105555 <release>
80102a73:	83 c4 10             	add    $0x10,%esp
}
80102a76:	c9                   	leave  
80102a77:	c3                   	ret    

80102a78 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102a78:	55                   	push   %ebp
80102a79:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a7b:	a1 d4 32 11 80       	mov    0x801132d4,%eax
80102a80:	8b 55 08             	mov    0x8(%ebp),%edx
80102a83:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102a85:	a1 d4 32 11 80       	mov    0x801132d4,%eax
80102a8a:	8b 40 10             	mov    0x10(%eax),%eax
}
80102a8d:	5d                   	pop    %ebp
80102a8e:	c3                   	ret    

80102a8f <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102a8f:	55                   	push   %ebp
80102a90:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a92:	a1 d4 32 11 80       	mov    0x801132d4,%eax
80102a97:	8b 55 08             	mov    0x8(%ebp),%edx
80102a9a:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102a9c:	a1 d4 32 11 80       	mov    0x801132d4,%eax
80102aa1:	8b 55 0c             	mov    0xc(%ebp),%edx
80102aa4:	89 50 10             	mov    %edx,0x10(%eax)
}
80102aa7:	5d                   	pop    %ebp
80102aa8:	c3                   	ret    

80102aa9 <ioapicinit>:

void
ioapicinit(void)
{
80102aa9:	55                   	push   %ebp
80102aaa:	89 e5                	mov    %esp,%ebp
80102aac:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102aaf:	a1 44 34 11 80       	mov    0x80113444,%eax
80102ab4:	85 c0                	test   %eax,%eax
80102ab6:	75 05                	jne    80102abd <ioapicinit+0x14>
    return;
80102ab8:	e9 9e 00 00 00       	jmp    80102b5b <ioapicinit+0xb2>

  ioapic = (volatile struct ioapic*)IOAPIC;
80102abd:	c7 05 d4 32 11 80 00 	movl   $0xfec00000,0x801132d4
80102ac4:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102ac7:	6a 01                	push   $0x1
80102ac9:	e8 aa ff ff ff       	call   80102a78 <ioapicread>
80102ace:	83 c4 04             	add    $0x4,%esp
80102ad1:	c1 e8 10             	shr    $0x10,%eax
80102ad4:	25 ff 00 00 00       	and    $0xff,%eax
80102ad9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102adc:	6a 00                	push   $0x0
80102ade:	e8 95 ff ff ff       	call   80102a78 <ioapicread>
80102ae3:	83 c4 04             	add    $0x4,%esp
80102ae6:	c1 e8 18             	shr    $0x18,%eax
80102ae9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102aec:	0f b6 05 40 34 11 80 	movzbl 0x80113440,%eax
80102af3:	0f b6 c0             	movzbl %al,%eax
80102af6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102af9:	74 10                	je     80102b0b <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102afb:	83 ec 0c             	sub    $0xc,%esp
80102afe:	68 04 90 10 80       	push   $0x80109004
80102b03:	e8 fe d8 ff ff       	call   80100406 <cprintf>
80102b08:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102b12:	eb 3f                	jmp    80102b53 <ioapicinit+0xaa>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b17:	83 c0 20             	add    $0x20,%eax
80102b1a:	0d 00 00 01 00       	or     $0x10000,%eax
80102b1f:	89 c2                	mov    %eax,%edx
80102b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b24:	83 c0 08             	add    $0x8,%eax
80102b27:	01 c0                	add    %eax,%eax
80102b29:	83 ec 08             	sub    $0x8,%esp
80102b2c:	52                   	push   %edx
80102b2d:	50                   	push   %eax
80102b2e:	e8 5c ff ff ff       	call   80102a8f <ioapicwrite>
80102b33:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b39:	83 c0 08             	add    $0x8,%eax
80102b3c:	01 c0                	add    %eax,%eax
80102b3e:	83 c0 01             	add    $0x1,%eax
80102b41:	83 ec 08             	sub    $0x8,%esp
80102b44:	6a 00                	push   $0x0
80102b46:	50                   	push   %eax
80102b47:	e8 43 ff ff ff       	call   80102a8f <ioapicwrite>
80102b4c:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b4f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b56:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102b59:	7e b9                	jle    80102b14 <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102b5b:	c9                   	leave  
80102b5c:	c3                   	ret    

80102b5d <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b5d:	55                   	push   %ebp
80102b5e:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102b60:	a1 44 34 11 80       	mov    0x80113444,%eax
80102b65:	85 c0                	test   %eax,%eax
80102b67:	75 02                	jne    80102b6b <ioapicenable+0xe>
    return;
80102b69:	eb 37                	jmp    80102ba2 <ioapicenable+0x45>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b6b:	8b 45 08             	mov    0x8(%ebp),%eax
80102b6e:	83 c0 20             	add    $0x20,%eax
80102b71:	89 c2                	mov    %eax,%edx
80102b73:	8b 45 08             	mov    0x8(%ebp),%eax
80102b76:	83 c0 08             	add    $0x8,%eax
80102b79:	01 c0                	add    %eax,%eax
80102b7b:	52                   	push   %edx
80102b7c:	50                   	push   %eax
80102b7d:	e8 0d ff ff ff       	call   80102a8f <ioapicwrite>
80102b82:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b85:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b88:	c1 e0 18             	shl    $0x18,%eax
80102b8b:	89 c2                	mov    %eax,%edx
80102b8d:	8b 45 08             	mov    0x8(%ebp),%eax
80102b90:	83 c0 08             	add    $0x8,%eax
80102b93:	01 c0                	add    %eax,%eax
80102b95:	83 c0 01             	add    $0x1,%eax
80102b98:	52                   	push   %edx
80102b99:	50                   	push   %eax
80102b9a:	e8 f0 fe ff ff       	call   80102a8f <ioapicwrite>
80102b9f:	83 c4 08             	add    $0x8,%esp
}
80102ba2:	c9                   	leave  
80102ba3:	c3                   	ret    

80102ba4 <timer_handler>:

/* Handles the timer (irq0). In this case, ot's very simple: We 
 * increment the 'timer_ticks' variable every time the 
 * timer fires. by default, the timer fires 18.222 times 
 * per second. */
void timer_handler(void){
80102ba4:	55                   	push   %ebp
80102ba5:	89 e5                	mov    %esp,%ebp
  /*Increment our 'tick count'*/
  timer_ticks++;
80102ba7:	a1 d8 32 11 80       	mov    0x801132d8,%eax
80102bac:	83 c0 01             	add    $0x1,%eax
80102baf:	a3 d8 32 11 80       	mov    %eax,0x801132d8

  /*Every 18 clocks (approximately 1 second), we will 
   *do something*/
  if(timer_ticks % 18 == 0){
80102bb4:	8b 0d d8 32 11 80    	mov    0x801132d8,%ecx
80102bba:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
80102bbf:	89 c8                	mov    %ecx,%eax
80102bc1:	f7 ea                	imul   %edx
80102bc3:	c1 fa 02             	sar    $0x2,%edx
80102bc6:	89 c8                	mov    %ecx,%eax
80102bc8:	c1 f8 1f             	sar    $0x1f,%eax
80102bcb:	29 c2                	sub    %eax,%edx
80102bcd:	89 d0                	mov    %edx,%eax
80102bcf:	c1 e0 03             	shl    $0x3,%eax
80102bd2:	01 d0                	add    %edx,%eax
80102bd4:	01 c0                	add    %eax,%eax
80102bd6:	29 c1                	sub    %eax,%ecx
    /*do whatever you want*/
  }
}
80102bd8:	5d                   	pop    %ebp
80102bd9:	c3                   	ret    

80102bda <timer_phase>:

/*set timer phase*/
void timer_phase(int hz){
80102bda:	55                   	push   %ebp
80102bdb:	89 e5                	mov    %esp,%ebp
80102bdd:	83 ec 18             	sub    $0x18,%esp
  int divisor=1193180/hz;      /*Calculate our divisor*/
80102be0:	b8 dc 34 12 00       	mov    $0x1234dc,%eax
80102be5:	99                   	cltd   
80102be6:	f7 7d 08             	idivl  0x8(%ebp)
80102be9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outportb(0x43,0x36);         /*Set our command byte 0x36*/
80102bec:	83 ec 08             	sub    $0x8,%esp
80102bef:	6a 36                	push   $0x36
80102bf1:	6a 43                	push   $0x43
80102bf3:	e8 f5 d6 ff ff       	call   801002ed <outbyte>
80102bf8:	83 c4 10             	add    $0x10,%esp
  outportb(0x40,divisor&0xFF); /*Set low byte of divisor*/
80102bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bfe:	0f b6 c0             	movzbl %al,%eax
80102c01:	83 ec 08             	sub    $0x8,%esp
80102c04:	50                   	push   %eax
80102c05:	6a 40                	push   $0x40
80102c07:	e8 e1 d6 ff ff       	call   801002ed <outbyte>
80102c0c:	83 c4 10             	add    $0x10,%esp
  outportb(0x40,divisor>>8);   /*Set higt byte of divisor*/
80102c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c12:	c1 f8 08             	sar    $0x8,%eax
80102c15:	0f b6 c0             	movzbl %al,%eax
80102c18:	83 ec 08             	sub    $0x8,%esp
80102c1b:	50                   	push   %eax
80102c1c:	6a 40                	push   $0x40
80102c1e:	e8 ca d6 ff ff       	call   801002ed <outbyte>
80102c23:	83 c4 10             	add    $0x10,%esp
}
80102c26:	c9                   	leave  
80102c27:	c3                   	ret    

80102c28 <interrupt>:
#include "regs.h"
void interrupt(regs_t *regst,int iterr){
80102c28:	55                   	push   %ebp
80102c29:	89 e5                	mov    %esp,%ebp
}
80102c2b:	5d                   	pop    %ebp
80102c2c:	c3                   	ret    

80102c2d <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102c2d:	55                   	push   %ebp
80102c2e:	89 e5                	mov    %esp,%ebp
80102c30:	83 ec 14             	sub    $0x14,%esp
80102c33:	8b 45 08             	mov    0x8(%ebp),%eax
80102c36:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102c3e:	89 c2                	mov    %eax,%edx
80102c40:	ec                   	in     (%dx),%al
80102c41:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102c44:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102c48:	c9                   	leave  
80102c49:	c3                   	ret    

80102c4a <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102c4a:	55                   	push   %ebp
80102c4b:	89 e5                	mov    %esp,%ebp
80102c4d:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102c50:	6a 64                	push   $0x64
80102c52:	e8 d6 ff ff ff       	call   80102c2d <inb>
80102c57:	83 c4 04             	add    $0x4,%esp
80102c5a:	0f b6 c0             	movzbl %al,%eax
80102c5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c63:	83 e0 01             	and    $0x1,%eax
80102c66:	85 c0                	test   %eax,%eax
80102c68:	75 0a                	jne    80102c74 <kbdgetc+0x2a>
    return -1;
80102c6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c6f:	e9 23 01 00 00       	jmp    80102d97 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102c74:	6a 60                	push   $0x60
80102c76:	e8 b2 ff ff ff       	call   80102c2d <inb>
80102c7b:	83 c4 04             	add    $0x4,%esp
80102c7e:	0f b6 c0             	movzbl %al,%eax
80102c81:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102c84:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102c8b:	75 17                	jne    80102ca4 <kbdgetc+0x5a>
    shift |= E0ESC;
80102c8d:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c92:	83 c8 40             	or     $0x40,%eax
80102c95:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102c9a:	b8 00 00 00 00       	mov    $0x0,%eax
80102c9f:	e9 f3 00 00 00       	jmp    80102d97 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102ca4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ca7:	25 80 00 00 00       	and    $0x80,%eax
80102cac:	85 c0                	test   %eax,%eax
80102cae:	74 45                	je     80102cf5 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102cb0:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cb5:	83 e0 40             	and    $0x40,%eax
80102cb8:	85 c0                	test   %eax,%eax
80102cba:	75 08                	jne    80102cc4 <kbdgetc+0x7a>
80102cbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cbf:	83 e0 7f             	and    $0x7f,%eax
80102cc2:	eb 03                	jmp    80102cc7 <kbdgetc+0x7d>
80102cc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102cca:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ccd:	05 40 a0 10 80       	add    $0x8010a040,%eax
80102cd2:	0f b6 00             	movzbl (%eax),%eax
80102cd5:	83 c8 40             	or     $0x40,%eax
80102cd8:	0f b6 c0             	movzbl %al,%eax
80102cdb:	f7 d0                	not    %eax
80102cdd:	89 c2                	mov    %eax,%edx
80102cdf:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102ce4:	21 d0                	and    %edx,%eax
80102ce6:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102ceb:	b8 00 00 00 00       	mov    $0x0,%eax
80102cf0:	e9 a2 00 00 00       	jmp    80102d97 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102cf5:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cfa:	83 e0 40             	and    $0x40,%eax
80102cfd:	85 c0                	test   %eax,%eax
80102cff:	74 14                	je     80102d15 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102d01:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102d08:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d0d:	83 e0 bf             	and    $0xffffffbf,%eax
80102d10:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102d15:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d18:	05 40 a0 10 80       	add    $0x8010a040,%eax
80102d1d:	0f b6 00             	movzbl (%eax),%eax
80102d20:	0f b6 d0             	movzbl %al,%edx
80102d23:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d28:	09 d0                	or     %edx,%eax
80102d2a:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102d2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d32:	05 40 a1 10 80       	add    $0x8010a140,%eax
80102d37:	0f b6 00             	movzbl (%eax),%eax
80102d3a:	0f b6 d0             	movzbl %al,%edx
80102d3d:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d42:	31 d0                	xor    %edx,%eax
80102d44:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102d49:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d4e:	83 e0 03             	and    $0x3,%eax
80102d51:	8b 14 85 40 a5 10 80 	mov    -0x7fef5ac0(,%eax,4),%edx
80102d58:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d5b:	01 d0                	add    %edx,%eax
80102d5d:	0f b6 00             	movzbl (%eax),%eax
80102d60:	0f b6 c0             	movzbl %al,%eax
80102d63:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102d66:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d6b:	83 e0 08             	and    $0x8,%eax
80102d6e:	85 c0                	test   %eax,%eax
80102d70:	74 22                	je     80102d94 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102d72:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102d76:	76 0c                	jbe    80102d84 <kbdgetc+0x13a>
80102d78:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102d7c:	77 06                	ja     80102d84 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102d7e:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102d82:	eb 10                	jmp    80102d94 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102d84:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102d88:	76 0a                	jbe    80102d94 <kbdgetc+0x14a>
80102d8a:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102d8e:	77 04                	ja     80102d94 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102d90:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102d94:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d97:	c9                   	leave  
80102d98:	c3                   	ret    

80102d99 <kbdintr>:

void
kbdintr(void)
{
80102d99:	55                   	push   %ebp
80102d9a:	89 e5                	mov    %esp,%ebp
80102d9c:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102d9f:	83 ec 0c             	sub    $0xc,%esp
80102da2:	68 4a 2c 10 80       	push   $0x80102c4a
80102da7:	e8 6c da ff ff       	call   80100818 <consoleintr>
80102dac:	83 c4 10             	add    $0x10,%esp
}
80102daf:	c9                   	leave  
80102db0:	c3                   	ret    

80102db1 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102db1:	55                   	push   %ebp
80102db2:	89 e5                	mov    %esp,%ebp
80102db4:	8b 45 08             	mov    0x8(%ebp),%eax
80102db7:	05 00 00 00 80       	add    $0x80000000,%eax
80102dbc:	5d                   	pop    %ebp
80102dbd:	c3                   	ret    

80102dbe <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102dbe:	55                   	push   %ebp
80102dbf:	89 e5                	mov    %esp,%ebp
80102dc1:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102dc4:	83 ec 08             	sub    $0x8,%esp
80102dc7:	68 36 90 10 80       	push   $0x80109036
80102dcc:	68 e0 32 11 80       	push   $0x801132e0
80102dd1:	e8 f8 26 00 00       	call   801054ce <initlock>
80102dd6:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102dd9:	c7 05 14 33 11 80 00 	movl   $0x0,0x80113314
80102de0:	00 00 00 
  freerange(vstart, vend);
80102de3:	83 ec 08             	sub    $0x8,%esp
80102de6:	ff 75 0c             	pushl  0xc(%ebp)
80102de9:	ff 75 08             	pushl  0x8(%ebp)
80102dec:	e8 28 00 00 00       	call   80102e19 <freerange>
80102df1:	83 c4 10             	add    $0x10,%esp
}
80102df4:	c9                   	leave  
80102df5:	c3                   	ret    

80102df6 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102df6:	55                   	push   %ebp
80102df7:	89 e5                	mov    %esp,%ebp
80102df9:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102dfc:	83 ec 08             	sub    $0x8,%esp
80102dff:	ff 75 0c             	pushl  0xc(%ebp)
80102e02:	ff 75 08             	pushl  0x8(%ebp)
80102e05:	e8 0f 00 00 00       	call   80102e19 <freerange>
80102e0a:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102e0d:	c7 05 14 33 11 80 01 	movl   $0x1,0x80113314
80102e14:	00 00 00 
}
80102e17:	c9                   	leave  
80102e18:	c3                   	ret    

80102e19 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102e19:	55                   	push   %ebp
80102e1a:	89 e5                	mov    %esp,%ebp
80102e1c:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102e1f:	8b 45 08             	mov    0x8(%ebp),%eax
80102e22:	05 ff 0f 00 00       	add    $0xfff,%eax
80102e27:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102e2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e2f:	eb 15                	jmp    80102e46 <freerange+0x2d>
    kfree(p);
80102e31:	83 ec 0c             	sub    $0xc,%esp
80102e34:	ff 75 f4             	pushl  -0xc(%ebp)
80102e37:	e8 19 00 00 00       	call   80102e55 <kfree>
80102e3c:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e3f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e49:	05 00 10 00 00       	add    $0x1000,%eax
80102e4e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102e51:	76 de                	jbe    80102e31 <freerange+0x18>
    kfree(p);
}
80102e53:	c9                   	leave  
80102e54:	c3                   	ret    

80102e55 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102e55:	55                   	push   %ebp
80102e56:	89 e5                	mov    %esp,%ebp
80102e58:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102e5b:	8b 45 08             	mov    0x8(%ebp),%eax
80102e5e:	25 ff 0f 00 00       	and    $0xfff,%eax
80102e63:	85 c0                	test   %eax,%eax
80102e65:	75 1b                	jne    80102e82 <kfree+0x2d>
80102e67:	81 7d 08 dc 63 11 80 	cmpl   $0x801163dc,0x8(%ebp)
80102e6e:	72 12                	jb     80102e82 <kfree+0x2d>
80102e70:	ff 75 08             	pushl  0x8(%ebp)
80102e73:	e8 39 ff ff ff       	call   80102db1 <v2p>
80102e78:	83 c4 04             	add    $0x4,%esp
80102e7b:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102e80:	76 0d                	jbe    80102e8f <kfree+0x3a>
    panic("kfree");
80102e82:	83 ec 0c             	sub    $0xc,%esp
80102e85:	68 3b 90 10 80       	push   $0x8010903b
80102e8a:	e8 14 d7 ff ff       	call   801005a3 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102e8f:	83 ec 04             	sub    $0x4,%esp
80102e92:	68 00 10 00 00       	push   $0x1000
80102e97:	6a 01                	push   $0x1
80102e99:	ff 75 08             	pushl  0x8(%ebp)
80102e9c:	e8 c4 28 00 00       	call   80105765 <memset>
80102ea1:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102ea4:	a1 14 33 11 80       	mov    0x80113314,%eax
80102ea9:	85 c0                	test   %eax,%eax
80102eab:	74 10                	je     80102ebd <kfree+0x68>
    acquire(&kmem.lock);
80102ead:	83 ec 0c             	sub    $0xc,%esp
80102eb0:	68 e0 32 11 80       	push   $0x801132e0
80102eb5:	e8 35 26 00 00       	call   801054ef <acquire>
80102eba:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102ebd:	8b 45 08             	mov    0x8(%ebp),%eax
80102ec0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102ec3:	8b 15 18 33 11 80    	mov    0x80113318,%edx
80102ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ecc:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ed1:	a3 18 33 11 80       	mov    %eax,0x80113318
  if(kmem.use_lock)
80102ed6:	a1 14 33 11 80       	mov    0x80113314,%eax
80102edb:	85 c0                	test   %eax,%eax
80102edd:	74 10                	je     80102eef <kfree+0x9a>
    release(&kmem.lock);
80102edf:	83 ec 0c             	sub    $0xc,%esp
80102ee2:	68 e0 32 11 80       	push   $0x801132e0
80102ee7:	e8 69 26 00 00       	call   80105555 <release>
80102eec:	83 c4 10             	add    $0x10,%esp
}
80102eef:	c9                   	leave  
80102ef0:	c3                   	ret    

80102ef1 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102ef1:	55                   	push   %ebp
80102ef2:	89 e5                	mov    %esp,%ebp
80102ef4:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102ef7:	a1 14 33 11 80       	mov    0x80113314,%eax
80102efc:	85 c0                	test   %eax,%eax
80102efe:	74 10                	je     80102f10 <kalloc+0x1f>
    acquire(&kmem.lock);
80102f00:	83 ec 0c             	sub    $0xc,%esp
80102f03:	68 e0 32 11 80       	push   $0x801132e0
80102f08:	e8 e2 25 00 00       	call   801054ef <acquire>
80102f0d:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102f10:	a1 18 33 11 80       	mov    0x80113318,%eax
80102f15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102f18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102f1c:	74 0a                	je     80102f28 <kalloc+0x37>
    kmem.freelist = r->next;
80102f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f21:	8b 00                	mov    (%eax),%eax
80102f23:	a3 18 33 11 80       	mov    %eax,0x80113318
  if(kmem.use_lock)
80102f28:	a1 14 33 11 80       	mov    0x80113314,%eax
80102f2d:	85 c0                	test   %eax,%eax
80102f2f:	74 10                	je     80102f41 <kalloc+0x50>
    release(&kmem.lock);
80102f31:	83 ec 0c             	sub    $0xc,%esp
80102f34:	68 e0 32 11 80       	push   $0x801132e0
80102f39:	e8 17 26 00 00       	call   80105555 <release>
80102f3e:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102f44:	c9                   	leave  
80102f45:	c3                   	ret    

80102f46 <v2p>:
80102f46:	55                   	push   %ebp
80102f47:	89 e5                	mov    %esp,%ebp
80102f49:	8b 45 08             	mov    0x8(%ebp),%eax
80102f4c:	05 00 00 00 80       	add    $0x80000000,%eax
80102f51:	5d                   	pop    %ebp
80102f52:	c3                   	ret    

80102f53 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80102f53:	55                   	push   %ebp
80102f54:	89 e5                	mov    %esp,%ebp
80102f56:	8b 45 08             	mov    0x8(%ebp),%eax
80102f59:	05 00 00 00 80       	add    $0x80000000,%eax
80102f5e:	5d                   	pop    %ebp
80102f5f:	c3                   	ret    

80102f60 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80102f60:	55                   	push   %ebp
80102f61:	89 e5                	mov    %esp,%ebp
80102f63:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102f66:	8b 55 08             	mov    0x8(%ebp),%edx
80102f69:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102f6f:	f0 87 02             	lock xchg %eax,(%edx)
80102f72:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80102f75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102f78:	c9                   	leave  
80102f79:	c3                   	ret    

80102f7a <kmain>:
extern char *argv1[];
extern char *argv2[];
//Estas variables de definen en ese archivo

/*int main(void){*/
void kmain(void){
80102f7a:	55                   	push   %ebp
80102f7b:	89 e5                	mov    %esp,%ebp
80102f7d:	83 ec 08             	sub    $0x8,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102f80:	83 ec 08             	sub    $0x8,%esp
80102f83:	68 00 00 40 80       	push   $0x80400000
80102f88:	68 dc 63 11 80       	push   $0x801163dc
80102f8d:	e8 2c fe ff ff       	call   80102dbe <kinit1>
80102f92:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80102f95:	e8 ac 56 00 00       	call   80108646 <kvmalloc>
  mpinit();        // collect info about this machine
80102f9a:	e8 c4 0e 00 00       	call   80103e63 <mpinit>
  lapicinit();
80102f9f:	e8 46 02 00 00       	call   801031ea <lapicinit>
  seginit();       // set up segments
80102fa4:	e8 45 50 00 00       	call   80107fee <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80102fa9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80102faf:	0f b6 00             	movzbl (%eax),%eax
80102fb2:	0f b6 c0             	movzbl %al,%eax
80102fb5:	83 ec 08             	sub    $0x8,%esp
80102fb8:	50                   	push   %eax
80102fb9:	68 44 90 10 80       	push   $0x80109044
80102fbe:	e8 43 d4 ff ff       	call   80100406 <cprintf>
80102fc3:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80102fc6:	e8 c1 21 00 00       	call   8010518c <picinit>
  ioapicinit();    // another interrupt controller
80102fcb:	e8 d9 fa ff ff       	call   80102aa9 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80102fd0:	e8 55 db ff ff       	call   80100b2a <consoleinit>
  uartinit();      // serial port
80102fd5:	e8 77 43 00 00       	call   80107351 <uartinit>
  pinit();         // process table
80102fda:	e8 7e 15 00 00       	call   8010455d <pinit>
  tvinit();        // trap vectors
80102fdf:	e8 3c 3f 00 00       	call   80106f20 <tvinit>
  binit();         // buffer cache
80102fe4:	e8 4b d0 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80102fe9:	e8 97 df ff ff       	call   80100f85 <fileinit>
  ideinit();       // disk
80102fee:	e8 c2 f6 ff ff       	call   801026b5 <ideinit>
  if(!ismp){/*En ::void mpinit(void): se hace  ismp=1*/
80102ff3:	a1 44 34 11 80       	mov    0x80113444,%eax
80102ff8:	85 c0                	test   %eax,%eax
80102ffa:	75 15                	jne    80103011 <kmain+0x97>
    cprintf("Starting uniprocessor timer...\n");
80102ffc:	83 ec 0c             	sub    $0xc,%esp
80102fff:	68 5c 90 10 80       	push   $0x8010905c
80103004:	e8 fd d3 ff ff       	call   80100406 <cprintf>
80103009:	83 c4 10             	add    $0x10,%esp
    timerinit();   // uniprocessor timer
8010300c:	e8 6e 3e 00 00       	call   80106e7f <timerinit>
  }
  startothers();   // start other processors
80103011:	e8 7f 00 00 00       	call   80103095 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103016:	83 ec 08             	sub    $0x8,%esp
80103019:	68 00 00 00 8e       	push   $0x8e000000
8010301e:	68 00 00 40 80       	push   $0x80400000
80103023:	e8 ce fd ff ff       	call   80102df6 <kinit2>
80103028:	83 c4 10             	add    $0x10,%esp
//2016.04.20
//  createTask(1, TaskId_1,argv1);
//  createTask(2, TaskId_2,argv2);

  userinit();      // first user process
8010302b:	e8 4f 16 00 00       	call   8010467f <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103030:	e8 1a 00 00 00       	call   8010304f <mpmain>

80103035 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103035:	55                   	push   %ebp
80103036:	89 e5                	mov    %esp,%ebp
80103038:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
8010303b:	e8 1d 56 00 00       	call   8010865d <switchkvm>
  seginit();
80103040:	e8 a9 4f 00 00       	call   80107fee <seginit>
  lapicinit();
80103045:	e8 a0 01 00 00       	call   801031ea <lapicinit>
  mpmain();
8010304a:	e8 00 00 00 00       	call   8010304f <mpmain>

8010304f <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
8010304f:	55                   	push   %ebp
80103050:	89 e5                	mov    %esp,%ebp
80103052:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103055:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010305b:	0f b6 00             	movzbl (%eax),%eax
8010305e:	0f b6 c0             	movzbl %al,%eax
80103061:	83 ec 08             	sub    $0x8,%esp
80103064:	50                   	push   %eax
80103065:	68 7c 90 10 80       	push   $0x8010907c
8010306a:	e8 97 d3 ff ff       	call   80100406 <cprintf>
8010306f:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103072:	e8 1e 40 00 00       	call   80107095 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103077:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010307d:	05 a8 00 00 00       	add    $0xa8,%eax
80103082:	83 ec 08             	sub    $0x8,%esp
80103085:	6a 01                	push   $0x1
80103087:	50                   	push   %eax
80103088:	e8 d3 fe ff ff       	call   80102f60 <xchg>
8010308d:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103090:	e8 97 1b 00 00       	call   80104c2c <scheduler>

80103095 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103095:	55                   	push   %ebp
80103096:	89 e5                	mov    %esp,%ebp
80103098:	53                   	push   %ebx
80103099:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
8010309c:	68 00 70 00 00       	push   $0x7000
801030a1:	e8 ad fe ff ff       	call   80102f53 <p2v>
801030a6:	83 c4 04             	add    $0x4,%esp
801030a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030ac:	b8 8a 00 00 00       	mov    $0x8a,%eax
801030b1:	83 ec 04             	sub    $0x4,%esp
801030b4:	50                   	push   %eax
801030b5:	68 2c c5 10 80       	push   $0x8010c52c
801030ba:	ff 75 f0             	pushl  -0x10(%ebp)
801030bd:	e8 62 27 00 00       	call   80105824 <memmove>
801030c2:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
801030c5:	c7 45 f4 80 34 11 80 	movl   $0x80113480,-0xc(%ebp)
801030cc:	e9 8f 00 00 00       	jmp    80103160 <startothers+0xcb>
    if(c == cpus+cpunum())  // We've started already.
801030d1:	e8 30 02 00 00       	call   80103306 <cpunum>
801030d6:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801030dc:	05 80 34 11 80       	add    $0x80113480,%eax
801030e1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801030e4:	75 02                	jne    801030e8 <startothers+0x53>
      continue;
801030e6:	eb 71                	jmp    80103159 <startothers+0xc4>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801030e8:	e8 04 fe ff ff       	call   80102ef1 <kalloc>
801030ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
801030f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030f3:	83 e8 04             	sub    $0x4,%eax
801030f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801030f9:	81 c2 00 10 00 00    	add    $0x1000,%edx
801030ff:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103101:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103104:	83 e8 08             	sub    $0x8,%eax
80103107:	c7 00 35 30 10 80    	movl   $0x80103035,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
8010310d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103110:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103113:	83 ec 0c             	sub    $0xc,%esp
80103116:	68 00 b0 10 80       	push   $0x8010b000
8010311b:	e8 26 fe ff ff       	call   80102f46 <v2p>
80103120:	83 c4 10             	add    $0x10,%esp
80103123:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103125:	83 ec 0c             	sub    $0xc,%esp
80103128:	ff 75 f0             	pushl  -0x10(%ebp)
8010312b:	e8 16 fe ff ff       	call   80102f46 <v2p>
80103130:	83 c4 10             	add    $0x10,%esp
80103133:	89 c2                	mov    %eax,%edx
80103135:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103138:	0f b6 00             	movzbl (%eax),%eax
8010313b:	0f b6 c0             	movzbl %al,%eax
8010313e:	83 ec 08             	sub    $0x8,%esp
80103141:	52                   	push   %edx
80103142:	50                   	push   %eax
80103143:	e8 36 02 00 00       	call   8010337e <lapicstartap>
80103148:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
8010314b:	90                   	nop
8010314c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010314f:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103155:	85 c0                	test   %eax,%eax
80103157:	74 f3                	je     8010314c <startothers+0xb7>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103159:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103160:	a1 60 3a 11 80       	mov    0x80113a60,%eax
80103165:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010316b:	05 80 34 11 80       	add    $0x80113480,%eax
80103170:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103173:	0f 87 58 ff ff ff    	ja     801030d1 <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103179:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010317c:	c9                   	leave  
8010317d:	c3                   	ret    

8010317e <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010317e:	55                   	push   %ebp
8010317f:	89 e5                	mov    %esp,%ebp
80103181:	83 ec 14             	sub    $0x14,%esp
80103184:	8b 45 08             	mov    0x8(%ebp),%eax
80103187:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010318b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010318f:	89 c2                	mov    %eax,%edx
80103191:	ec                   	in     (%dx),%al
80103192:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103195:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103199:	c9                   	leave  
8010319a:	c3                   	ret    

8010319b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010319b:	55                   	push   %ebp
8010319c:	89 e5                	mov    %esp,%ebp
8010319e:	83 ec 08             	sub    $0x8,%esp
801031a1:	8b 55 08             	mov    0x8(%ebp),%edx
801031a4:	8b 45 0c             	mov    0xc(%ebp),%eax
801031a7:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801031ab:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031ae:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801031b2:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801031b6:	ee                   	out    %al,(%dx)
}
801031b7:	c9                   	leave  
801031b8:	c3                   	ret    

801031b9 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801031b9:	55                   	push   %ebp
801031ba:	89 e5                	mov    %esp,%ebp
801031bc:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801031bf:	9c                   	pushf  
801031c0:	58                   	pop    %eax
801031c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801031c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801031c7:	c9                   	leave  
801031c8:	c3                   	ret    

801031c9 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
801031c9:	55                   	push   %ebp
801031ca:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
801031cc:	a1 1c 33 11 80       	mov    0x8011331c,%eax
801031d1:	8b 55 08             	mov    0x8(%ebp),%edx
801031d4:	c1 e2 02             	shl    $0x2,%edx
801031d7:	01 c2                	add    %eax,%edx
801031d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801031dc:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
801031de:	a1 1c 33 11 80       	mov    0x8011331c,%eax
801031e3:	83 c0 20             	add    $0x20,%eax
801031e6:	8b 00                	mov    (%eax),%eax
}
801031e8:	5d                   	pop    %ebp
801031e9:	c3                   	ret    

801031ea <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
801031ea:	55                   	push   %ebp
801031eb:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
801031ed:	a1 1c 33 11 80       	mov    0x8011331c,%eax
801031f2:	85 c0                	test   %eax,%eax
801031f4:	75 05                	jne    801031fb <lapicinit+0x11>
    return;
801031f6:	e9 09 01 00 00       	jmp    80103304 <lapicinit+0x11a>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
801031fb:	68 3f 01 00 00       	push   $0x13f
80103200:	6a 3c                	push   $0x3c
80103202:	e8 c2 ff ff ff       	call   801031c9 <lapicw>
80103207:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
8010320a:	6a 0b                	push   $0xb
8010320c:	68 f8 00 00 00       	push   $0xf8
80103211:	e8 b3 ff ff ff       	call   801031c9 <lapicw>
80103216:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80103219:	68 20 00 02 00       	push   $0x20020
8010321e:	68 c8 00 00 00       	push   $0xc8
80103223:	e8 a1 ff ff ff       	call   801031c9 <lapicw>
80103228:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
8010322b:	68 80 96 98 00       	push   $0x989680
80103230:	68 e0 00 00 00       	push   $0xe0
80103235:	e8 8f ff ff ff       	call   801031c9 <lapicw>
8010323a:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
8010323d:	68 00 00 01 00       	push   $0x10000
80103242:	68 d4 00 00 00       	push   $0xd4
80103247:	e8 7d ff ff ff       	call   801031c9 <lapicw>
8010324c:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
8010324f:	68 00 00 01 00       	push   $0x10000
80103254:	68 d8 00 00 00       	push   $0xd8
80103259:	e8 6b ff ff ff       	call   801031c9 <lapicw>
8010325e:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80103261:	a1 1c 33 11 80       	mov    0x8011331c,%eax
80103266:	83 c0 30             	add    $0x30,%eax
80103269:	8b 00                	mov    (%eax),%eax
8010326b:	c1 e8 10             	shr    $0x10,%eax
8010326e:	0f b6 c0             	movzbl %al,%eax
80103271:	83 f8 03             	cmp    $0x3,%eax
80103274:	76 12                	jbe    80103288 <lapicinit+0x9e>
    lapicw(PCINT, MASKED);
80103276:	68 00 00 01 00       	push   $0x10000
8010327b:	68 d0 00 00 00       	push   $0xd0
80103280:	e8 44 ff ff ff       	call   801031c9 <lapicw>
80103285:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80103288:	6a 33                	push   $0x33
8010328a:	68 dc 00 00 00       	push   $0xdc
8010328f:	e8 35 ff ff ff       	call   801031c9 <lapicw>
80103294:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80103297:	6a 00                	push   $0x0
80103299:	68 a0 00 00 00       	push   $0xa0
8010329e:	e8 26 ff ff ff       	call   801031c9 <lapicw>
801032a3:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
801032a6:	6a 00                	push   $0x0
801032a8:	68 a0 00 00 00       	push   $0xa0
801032ad:	e8 17 ff ff ff       	call   801031c9 <lapicw>
801032b2:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
801032b5:	6a 00                	push   $0x0
801032b7:	6a 2c                	push   $0x2c
801032b9:	e8 0b ff ff ff       	call   801031c9 <lapicw>
801032be:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
801032c1:	6a 00                	push   $0x0
801032c3:	68 c4 00 00 00       	push   $0xc4
801032c8:	e8 fc fe ff ff       	call   801031c9 <lapicw>
801032cd:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
801032d0:	68 00 85 08 00       	push   $0x88500
801032d5:	68 c0 00 00 00       	push   $0xc0
801032da:	e8 ea fe ff ff       	call   801031c9 <lapicw>
801032df:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
801032e2:	90                   	nop
801032e3:	a1 1c 33 11 80       	mov    0x8011331c,%eax
801032e8:	05 00 03 00 00       	add    $0x300,%eax
801032ed:	8b 00                	mov    (%eax),%eax
801032ef:	25 00 10 00 00       	and    $0x1000,%eax
801032f4:	85 c0                	test   %eax,%eax
801032f6:	75 eb                	jne    801032e3 <lapicinit+0xf9>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
801032f8:	6a 00                	push   $0x0
801032fa:	6a 20                	push   $0x20
801032fc:	e8 c8 fe ff ff       	call   801031c9 <lapicw>
80103301:	83 c4 08             	add    $0x8,%esp
}
80103304:	c9                   	leave  
80103305:	c3                   	ret    

80103306 <cpunum>:

int
cpunum(void)
{
80103306:	55                   	push   %ebp
80103307:	89 e5                	mov    %esp,%ebp
80103309:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
8010330c:	e8 a8 fe ff ff       	call   801031b9 <readeflags>
80103311:	25 00 02 00 00       	and    $0x200,%eax
80103316:	85 c0                	test   %eax,%eax
80103318:	74 26                	je     80103340 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
8010331a:	a1 60 c6 10 80       	mov    0x8010c660,%eax
8010331f:	8d 50 01             	lea    0x1(%eax),%edx
80103322:	89 15 60 c6 10 80    	mov    %edx,0x8010c660
80103328:	85 c0                	test   %eax,%eax
8010332a:	75 14                	jne    80103340 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
8010332c:	8b 45 04             	mov    0x4(%ebp),%eax
8010332f:	83 ec 08             	sub    $0x8,%esp
80103332:	50                   	push   %eax
80103333:	68 90 90 10 80       	push   $0x80109090
80103338:	e8 c9 d0 ff ff       	call   80100406 <cprintf>
8010333d:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80103340:	a1 1c 33 11 80       	mov    0x8011331c,%eax
80103345:	85 c0                	test   %eax,%eax
80103347:	74 0f                	je     80103358 <cpunum+0x52>
    return lapic[ID]>>24;
80103349:	a1 1c 33 11 80       	mov    0x8011331c,%eax
8010334e:	83 c0 20             	add    $0x20,%eax
80103351:	8b 00                	mov    (%eax),%eax
80103353:	c1 e8 18             	shr    $0x18,%eax
80103356:	eb 05                	jmp    8010335d <cpunum+0x57>
  return 0;
80103358:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010335d:	c9                   	leave  
8010335e:	c3                   	ret    

8010335f <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
8010335f:	55                   	push   %ebp
80103360:	89 e5                	mov    %esp,%ebp
  if(lapic)
80103362:	a1 1c 33 11 80       	mov    0x8011331c,%eax
80103367:	85 c0                	test   %eax,%eax
80103369:	74 0c                	je     80103377 <lapiceoi+0x18>
    lapicw(EOI, 0);
8010336b:	6a 00                	push   $0x0
8010336d:	6a 2c                	push   $0x2c
8010336f:	e8 55 fe ff ff       	call   801031c9 <lapicw>
80103374:	83 c4 08             	add    $0x8,%esp
}
80103377:	c9                   	leave  
80103378:	c3                   	ret    

80103379 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103379:	55                   	push   %ebp
8010337a:	89 e5                	mov    %esp,%ebp
}
8010337c:	5d                   	pop    %ebp
8010337d:	c3                   	ret    

8010337e <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
8010337e:	55                   	push   %ebp
8010337f:	89 e5                	mov    %esp,%ebp
80103381:	83 ec 14             	sub    $0x14,%esp
80103384:	8b 45 08             	mov    0x8(%ebp),%eax
80103387:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
8010338a:	6a 0f                	push   $0xf
8010338c:	6a 70                	push   $0x70
8010338e:	e8 08 fe ff ff       	call   8010319b <outb>
80103393:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80103396:	6a 0a                	push   $0xa
80103398:	6a 71                	push   $0x71
8010339a:	e8 fc fd ff ff       	call   8010319b <outb>
8010339f:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
801033a2:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
801033a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
801033ac:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
801033b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801033b4:	83 c0 02             	add    $0x2,%eax
801033b7:	8b 55 0c             	mov    0xc(%ebp),%edx
801033ba:	c1 ea 04             	shr    $0x4,%edx
801033bd:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801033c0:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801033c4:	c1 e0 18             	shl    $0x18,%eax
801033c7:	50                   	push   %eax
801033c8:	68 c4 00 00 00       	push   $0xc4
801033cd:	e8 f7 fd ff ff       	call   801031c9 <lapicw>
801033d2:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801033d5:	68 00 c5 00 00       	push   $0xc500
801033da:	68 c0 00 00 00       	push   $0xc0
801033df:	e8 e5 fd ff ff       	call   801031c9 <lapicw>
801033e4:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801033e7:	68 c8 00 00 00       	push   $0xc8
801033ec:	e8 88 ff ff ff       	call   80103379 <microdelay>
801033f1:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
801033f4:	68 00 85 00 00       	push   $0x8500
801033f9:	68 c0 00 00 00       	push   $0xc0
801033fe:	e8 c6 fd ff ff       	call   801031c9 <lapicw>
80103403:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103406:	6a 64                	push   $0x64
80103408:	e8 6c ff ff ff       	call   80103379 <microdelay>
8010340d:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103410:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103417:	eb 3d                	jmp    80103456 <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
80103419:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010341d:	c1 e0 18             	shl    $0x18,%eax
80103420:	50                   	push   %eax
80103421:	68 c4 00 00 00       	push   $0xc4
80103426:	e8 9e fd ff ff       	call   801031c9 <lapicw>
8010342b:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
8010342e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103431:	c1 e8 0c             	shr    $0xc,%eax
80103434:	80 cc 06             	or     $0x6,%ah
80103437:	50                   	push   %eax
80103438:	68 c0 00 00 00       	push   $0xc0
8010343d:	e8 87 fd ff ff       	call   801031c9 <lapicw>
80103442:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80103445:	68 c8 00 00 00       	push   $0xc8
8010344a:	e8 2a ff ff ff       	call   80103379 <microdelay>
8010344f:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103452:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103456:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
8010345a:	7e bd                	jle    80103419 <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010345c:	c9                   	leave  
8010345d:	c3                   	ret    

8010345e <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
8010345e:	55                   	push   %ebp
8010345f:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80103461:	8b 45 08             	mov    0x8(%ebp),%eax
80103464:	0f b6 c0             	movzbl %al,%eax
80103467:	50                   	push   %eax
80103468:	6a 70                	push   $0x70
8010346a:	e8 2c fd ff ff       	call   8010319b <outb>
8010346f:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103472:	68 c8 00 00 00       	push   $0xc8
80103477:	e8 fd fe ff ff       	call   80103379 <microdelay>
8010347c:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
8010347f:	6a 71                	push   $0x71
80103481:	e8 f8 fc ff ff       	call   8010317e <inb>
80103486:	83 c4 04             	add    $0x4,%esp
80103489:	0f b6 c0             	movzbl %al,%eax
}
8010348c:	c9                   	leave  
8010348d:	c3                   	ret    

8010348e <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
8010348e:	55                   	push   %ebp
8010348f:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80103491:	6a 00                	push   $0x0
80103493:	e8 c6 ff ff ff       	call   8010345e <cmos_read>
80103498:	83 c4 04             	add    $0x4,%esp
8010349b:	89 c2                	mov    %eax,%edx
8010349d:	8b 45 08             	mov    0x8(%ebp),%eax
801034a0:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
801034a2:	6a 02                	push   $0x2
801034a4:	e8 b5 ff ff ff       	call   8010345e <cmos_read>
801034a9:	83 c4 04             	add    $0x4,%esp
801034ac:	89 c2                	mov    %eax,%edx
801034ae:	8b 45 08             	mov    0x8(%ebp),%eax
801034b1:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
801034b4:	6a 04                	push   $0x4
801034b6:	e8 a3 ff ff ff       	call   8010345e <cmos_read>
801034bb:	83 c4 04             	add    $0x4,%esp
801034be:	89 c2                	mov    %eax,%edx
801034c0:	8b 45 08             	mov    0x8(%ebp),%eax
801034c3:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
801034c6:	6a 07                	push   $0x7
801034c8:	e8 91 ff ff ff       	call   8010345e <cmos_read>
801034cd:	83 c4 04             	add    $0x4,%esp
801034d0:	89 c2                	mov    %eax,%edx
801034d2:	8b 45 08             	mov    0x8(%ebp),%eax
801034d5:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
801034d8:	6a 08                	push   $0x8
801034da:	e8 7f ff ff ff       	call   8010345e <cmos_read>
801034df:	83 c4 04             	add    $0x4,%esp
801034e2:	89 c2                	mov    %eax,%edx
801034e4:	8b 45 08             	mov    0x8(%ebp),%eax
801034e7:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
801034ea:	6a 09                	push   $0x9
801034ec:	e8 6d ff ff ff       	call   8010345e <cmos_read>
801034f1:	83 c4 04             	add    $0x4,%esp
801034f4:	89 c2                	mov    %eax,%edx
801034f6:	8b 45 08             	mov    0x8(%ebp),%eax
801034f9:	89 50 14             	mov    %edx,0x14(%eax)
}
801034fc:	c9                   	leave  
801034fd:	c3                   	ret    

801034fe <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801034fe:	55                   	push   %ebp
801034ff:	89 e5                	mov    %esp,%ebp
80103501:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103504:	6a 0b                	push   $0xb
80103506:	e8 53 ff ff ff       	call   8010345e <cmos_read>
8010350b:	83 c4 04             	add    $0x4,%esp
8010350e:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103511:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103514:	83 e0 04             	and    $0x4,%eax
80103517:	85 c0                	test   %eax,%eax
80103519:	0f 94 c0             	sete   %al
8010351c:	0f b6 c0             	movzbl %al,%eax
8010351f:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
80103522:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103525:	50                   	push   %eax
80103526:	e8 63 ff ff ff       	call   8010348e <fill_rtcdate>
8010352b:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
8010352e:	6a 0a                	push   $0xa
80103530:	e8 29 ff ff ff       	call   8010345e <cmos_read>
80103535:	83 c4 04             	add    $0x4,%esp
80103538:	25 80 00 00 00       	and    $0x80,%eax
8010353d:	85 c0                	test   %eax,%eax
8010353f:	74 02                	je     80103543 <cmostime+0x45>
        continue;
80103541:	eb 32                	jmp    80103575 <cmostime+0x77>
    fill_rtcdate(&t2);
80103543:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103546:	50                   	push   %eax
80103547:	e8 42 ff ff ff       	call   8010348e <fill_rtcdate>
8010354c:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
8010354f:	83 ec 04             	sub    $0x4,%esp
80103552:	6a 18                	push   $0x18
80103554:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103557:	50                   	push   %eax
80103558:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010355b:	50                   	push   %eax
8010355c:	e8 6b 22 00 00       	call   801057cc <memcmp>
80103561:	83 c4 10             	add    $0x10,%esp
80103564:	85 c0                	test   %eax,%eax
80103566:	75 0d                	jne    80103575 <cmostime+0x77>
      break;
80103568:	90                   	nop
  }

  // convert
  if (bcd) {
80103569:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010356d:	0f 84 b8 00 00 00    	je     8010362b <cmostime+0x12d>
80103573:	eb 02                	jmp    80103577 <cmostime+0x79>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103575:	eb ab                	jmp    80103522 <cmostime+0x24>

  // convert
  if (bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103577:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010357a:	c1 e8 04             	shr    $0x4,%eax
8010357d:	89 c2                	mov    %eax,%edx
8010357f:	89 d0                	mov    %edx,%eax
80103581:	c1 e0 02             	shl    $0x2,%eax
80103584:	01 d0                	add    %edx,%eax
80103586:	01 c0                	add    %eax,%eax
80103588:	89 c2                	mov    %eax,%edx
8010358a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010358d:	83 e0 0f             	and    $0xf,%eax
80103590:	01 d0                	add    %edx,%eax
80103592:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103595:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103598:	c1 e8 04             	shr    $0x4,%eax
8010359b:	89 c2                	mov    %eax,%edx
8010359d:	89 d0                	mov    %edx,%eax
8010359f:	c1 e0 02             	shl    $0x2,%eax
801035a2:	01 d0                	add    %edx,%eax
801035a4:	01 c0                	add    %eax,%eax
801035a6:	89 c2                	mov    %eax,%edx
801035a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801035ab:	83 e0 0f             	and    $0xf,%eax
801035ae:	01 d0                	add    %edx,%eax
801035b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801035b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801035b6:	c1 e8 04             	shr    $0x4,%eax
801035b9:	89 c2                	mov    %eax,%edx
801035bb:	89 d0                	mov    %edx,%eax
801035bd:	c1 e0 02             	shl    $0x2,%eax
801035c0:	01 d0                	add    %edx,%eax
801035c2:	01 c0                	add    %eax,%eax
801035c4:	89 c2                	mov    %eax,%edx
801035c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801035c9:	83 e0 0f             	and    $0xf,%eax
801035cc:	01 d0                	add    %edx,%eax
801035ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801035d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801035d4:	c1 e8 04             	shr    $0x4,%eax
801035d7:	89 c2                	mov    %eax,%edx
801035d9:	89 d0                	mov    %edx,%eax
801035db:	c1 e0 02             	shl    $0x2,%eax
801035de:	01 d0                	add    %edx,%eax
801035e0:	01 c0                	add    %eax,%eax
801035e2:	89 c2                	mov    %eax,%edx
801035e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801035e7:	83 e0 0f             	and    $0xf,%eax
801035ea:	01 d0                	add    %edx,%eax
801035ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801035ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
801035f2:	c1 e8 04             	shr    $0x4,%eax
801035f5:	89 c2                	mov    %eax,%edx
801035f7:	89 d0                	mov    %edx,%eax
801035f9:	c1 e0 02             	shl    $0x2,%eax
801035fc:	01 d0                	add    %edx,%eax
801035fe:	01 c0                	add    %eax,%eax
80103600:	89 c2                	mov    %eax,%edx
80103602:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103605:	83 e0 0f             	and    $0xf,%eax
80103608:	01 d0                	add    %edx,%eax
8010360a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
8010360d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103610:	c1 e8 04             	shr    $0x4,%eax
80103613:	89 c2                	mov    %eax,%edx
80103615:	89 d0                	mov    %edx,%eax
80103617:	c1 e0 02             	shl    $0x2,%eax
8010361a:	01 d0                	add    %edx,%eax
8010361c:	01 c0                	add    %eax,%eax
8010361e:	89 c2                	mov    %eax,%edx
80103620:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103623:	83 e0 0f             	and    $0xf,%eax
80103626:	01 d0                	add    %edx,%eax
80103628:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
8010362b:	8b 45 08             	mov    0x8(%ebp),%eax
8010362e:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103631:	89 10                	mov    %edx,(%eax)
80103633:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103636:	89 50 04             	mov    %edx,0x4(%eax)
80103639:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010363c:	89 50 08             	mov    %edx,0x8(%eax)
8010363f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103642:	89 50 0c             	mov    %edx,0xc(%eax)
80103645:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103648:	89 50 10             	mov    %edx,0x10(%eax)
8010364b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010364e:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103651:	8b 45 08             	mov    0x8(%ebp),%eax
80103654:	8b 40 14             	mov    0x14(%eax),%eax
80103657:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
8010365d:	8b 45 08             	mov    0x8(%ebp),%eax
80103660:	89 50 14             	mov    %edx,0x14(%eax)
}
80103663:	c9                   	leave  
80103664:	c3                   	ret    

80103665 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103665:	55                   	push   %ebp
80103666:	89 e5                	mov    %esp,%ebp
80103668:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010366b:	83 ec 08             	sub    $0x8,%esp
8010366e:	68 bc 90 10 80       	push   $0x801090bc
80103673:	68 40 33 11 80       	push   $0x80113340
80103678:	e8 51 1e 00 00       	call   801054ce <initlock>
8010367d:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80103680:	83 ec 08             	sub    $0x8,%esp
80103683:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103686:	50                   	push   %eax
80103687:	ff 75 08             	pushl  0x8(%ebp)
8010368a:	e8 02 dd ff ff       	call   80101391 <readsb>
8010368f:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80103692:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103695:	a3 74 33 11 80       	mov    %eax,0x80113374
  log.size = sb.nlog;
8010369a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010369d:	a3 78 33 11 80       	mov    %eax,0x80113378
  log.dev = dev;
801036a2:	8b 45 08             	mov    0x8(%ebp),%eax
801036a5:	a3 84 33 11 80       	mov    %eax,0x80113384
  recover_from_log();
801036aa:	e8 ae 01 00 00       	call   8010385d <recover_from_log>
}
801036af:	c9                   	leave  
801036b0:	c3                   	ret    

801036b1 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801036b1:	55                   	push   %ebp
801036b2:	89 e5                	mov    %esp,%ebp
801036b4:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036be:	e9 95 00 00 00       	jmp    80103758 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801036c3:	8b 15 74 33 11 80    	mov    0x80113374,%edx
801036c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036cc:	01 d0                	add    %edx,%eax
801036ce:	83 c0 01             	add    $0x1,%eax
801036d1:	89 c2                	mov    %eax,%edx
801036d3:	a1 84 33 11 80       	mov    0x80113384,%eax
801036d8:	83 ec 08             	sub    $0x8,%esp
801036db:	52                   	push   %edx
801036dc:	50                   	push   %eax
801036dd:	e8 d2 ca ff ff       	call   801001b4 <bread>
801036e2:	83 c4 10             	add    $0x10,%esp
801036e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801036e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036eb:	83 c0 10             	add    $0x10,%eax
801036ee:	8b 04 85 4c 33 11 80 	mov    -0x7feeccb4(,%eax,4),%eax
801036f5:	89 c2                	mov    %eax,%edx
801036f7:	a1 84 33 11 80       	mov    0x80113384,%eax
801036fc:	83 ec 08             	sub    $0x8,%esp
801036ff:	52                   	push   %edx
80103700:	50                   	push   %eax
80103701:	e8 ae ca ff ff       	call   801001b4 <bread>
80103706:	83 c4 10             	add    $0x10,%esp
80103709:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010370c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010370f:	8d 50 18             	lea    0x18(%eax),%edx
80103712:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103715:	83 c0 18             	add    $0x18,%eax
80103718:	83 ec 04             	sub    $0x4,%esp
8010371b:	68 00 02 00 00       	push   $0x200
80103720:	52                   	push   %edx
80103721:	50                   	push   %eax
80103722:	e8 fd 20 00 00       	call   80105824 <memmove>
80103727:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
8010372a:	83 ec 0c             	sub    $0xc,%esp
8010372d:	ff 75 ec             	pushl  -0x14(%ebp)
80103730:	e8 b8 ca ff ff       	call   801001ed <bwrite>
80103735:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
80103738:	83 ec 0c             	sub    $0xc,%esp
8010373b:	ff 75 f0             	pushl  -0x10(%ebp)
8010373e:	e8 e8 ca ff ff       	call   8010022b <brelse>
80103743:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80103746:	83 ec 0c             	sub    $0xc,%esp
80103749:	ff 75 ec             	pushl  -0x14(%ebp)
8010374c:	e8 da ca ff ff       	call   8010022b <brelse>
80103751:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103754:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103758:	a1 88 33 11 80       	mov    0x80113388,%eax
8010375d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103760:	0f 8f 5d ff ff ff    	jg     801036c3 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103766:	c9                   	leave  
80103767:	c3                   	ret    

80103768 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103768:	55                   	push   %ebp
80103769:	89 e5                	mov    %esp,%ebp
8010376b:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010376e:	a1 74 33 11 80       	mov    0x80113374,%eax
80103773:	89 c2                	mov    %eax,%edx
80103775:	a1 84 33 11 80       	mov    0x80113384,%eax
8010377a:	83 ec 08             	sub    $0x8,%esp
8010377d:	52                   	push   %edx
8010377e:	50                   	push   %eax
8010377f:	e8 30 ca ff ff       	call   801001b4 <bread>
80103784:	83 c4 10             	add    $0x10,%esp
80103787:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
8010378a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010378d:	83 c0 18             	add    $0x18,%eax
80103790:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103793:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103796:	8b 00                	mov    (%eax),%eax
80103798:	a3 88 33 11 80       	mov    %eax,0x80113388
  for (i = 0; i < log.lh.n; i++) {
8010379d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801037a4:	eb 1b                	jmp    801037c1 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
801037a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801037ac:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801037b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801037b3:	83 c2 10             	add    $0x10,%edx
801037b6:	89 04 95 4c 33 11 80 	mov    %eax,-0x7feeccb4(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801037bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801037c1:	a1 88 33 11 80       	mov    0x80113388,%eax
801037c6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037c9:	7f db                	jg     801037a6 <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
801037cb:	83 ec 0c             	sub    $0xc,%esp
801037ce:	ff 75 f0             	pushl  -0x10(%ebp)
801037d1:	e8 55 ca ff ff       	call   8010022b <brelse>
801037d6:	83 c4 10             	add    $0x10,%esp
}
801037d9:	c9                   	leave  
801037da:	c3                   	ret    

801037db <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801037db:	55                   	push   %ebp
801037dc:	89 e5                	mov    %esp,%ebp
801037de:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801037e1:	a1 74 33 11 80       	mov    0x80113374,%eax
801037e6:	89 c2                	mov    %eax,%edx
801037e8:	a1 84 33 11 80       	mov    0x80113384,%eax
801037ed:	83 ec 08             	sub    $0x8,%esp
801037f0:	52                   	push   %edx
801037f1:	50                   	push   %eax
801037f2:	e8 bd c9 ff ff       	call   801001b4 <bread>
801037f7:	83 c4 10             	add    $0x10,%esp
801037fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801037fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103800:	83 c0 18             	add    $0x18,%eax
80103803:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103806:	8b 15 88 33 11 80    	mov    0x80113388,%edx
8010380c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010380f:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103811:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103818:	eb 1b                	jmp    80103835 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
8010381a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010381d:	83 c0 10             	add    $0x10,%eax
80103820:	8b 0c 85 4c 33 11 80 	mov    -0x7feeccb4(,%eax,4),%ecx
80103827:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010382a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010382d:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103831:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103835:	a1 88 33 11 80       	mov    0x80113388,%eax
8010383a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010383d:	7f db                	jg     8010381a <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
8010383f:	83 ec 0c             	sub    $0xc,%esp
80103842:	ff 75 f0             	pushl  -0x10(%ebp)
80103845:	e8 a3 c9 ff ff       	call   801001ed <bwrite>
8010384a:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
8010384d:	83 ec 0c             	sub    $0xc,%esp
80103850:	ff 75 f0             	pushl  -0x10(%ebp)
80103853:	e8 d3 c9 ff ff       	call   8010022b <brelse>
80103858:	83 c4 10             	add    $0x10,%esp
}
8010385b:	c9                   	leave  
8010385c:	c3                   	ret    

8010385d <recover_from_log>:

static void
recover_from_log(void)
{
8010385d:	55                   	push   %ebp
8010385e:	89 e5                	mov    %esp,%ebp
80103860:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103863:	e8 00 ff ff ff       	call   80103768 <read_head>
  install_trans(); // if committed, copy from log to disk
80103868:	e8 44 fe ff ff       	call   801036b1 <install_trans>
  log.lh.n = 0;
8010386d:	c7 05 88 33 11 80 00 	movl   $0x0,0x80113388
80103874:	00 00 00 
  write_head(); // clear the log
80103877:	e8 5f ff ff ff       	call   801037db <write_head>
}
8010387c:	c9                   	leave  
8010387d:	c3                   	ret    

8010387e <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
8010387e:	55                   	push   %ebp
8010387f:	89 e5                	mov    %esp,%ebp
80103881:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103884:	83 ec 0c             	sub    $0xc,%esp
80103887:	68 40 33 11 80       	push   $0x80113340
8010388c:	e8 5e 1c 00 00       	call   801054ef <acquire>
80103891:	83 c4 10             	add    $0x10,%esp
  while(2){
    if(log.committing){
80103894:	a1 80 33 11 80       	mov    0x80113380,%eax
80103899:	85 c0                	test   %eax,%eax
8010389b:	74 17                	je     801038b4 <begin_op+0x36>
      sleep(&log, &log.lock);
8010389d:	83 ec 08             	sub    $0x8,%esp
801038a0:	68 40 33 11 80       	push   $0x80113340
801038a5:	68 40 33 11 80       	push   $0x80113340
801038aa:	e8 5b 15 00 00       	call   80104e0a <sleep>
801038af:	83 c4 10             	add    $0x10,%esp
801038b2:	eb 54                	jmp    80103908 <begin_op+0x8a>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801038b4:	8b 0d 88 33 11 80    	mov    0x80113388,%ecx
801038ba:	a1 7c 33 11 80       	mov    0x8011337c,%eax
801038bf:	8d 50 01             	lea    0x1(%eax),%edx
801038c2:	89 d0                	mov    %edx,%eax
801038c4:	c1 e0 02             	shl    $0x2,%eax
801038c7:	01 d0                	add    %edx,%eax
801038c9:	01 c0                	add    %eax,%eax
801038cb:	01 c8                	add    %ecx,%eax
801038cd:	83 f8 1e             	cmp    $0x1e,%eax
801038d0:	7e 17                	jle    801038e9 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801038d2:	83 ec 08             	sub    $0x8,%esp
801038d5:	68 40 33 11 80       	push   $0x80113340
801038da:	68 40 33 11 80       	push   $0x80113340
801038df:	e8 26 15 00 00       	call   80104e0a <sleep>
801038e4:	83 c4 10             	add    $0x10,%esp
801038e7:	eb 1f                	jmp    80103908 <begin_op+0x8a>
    } else {
      log.outstanding += 1;
801038e9:	a1 7c 33 11 80       	mov    0x8011337c,%eax
801038ee:	83 c0 01             	add    $0x1,%eax
801038f1:	a3 7c 33 11 80       	mov    %eax,0x8011337c
      release(&log.lock);
801038f6:	83 ec 0c             	sub    $0xc,%esp
801038f9:	68 40 33 11 80       	push   $0x80113340
801038fe:	e8 52 1c 00 00       	call   80105555 <release>
80103903:	83 c4 10             	add    $0x10,%esp
      break;
80103906:	eb 02                	jmp    8010390a <begin_op+0x8c>
    }
  }
80103908:	eb 8a                	jmp    80103894 <begin_op+0x16>
}
8010390a:	c9                   	leave  
8010390b:	c3                   	ret    

8010390c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010390c:	55                   	push   %ebp
8010390d:	89 e5                	mov    %esp,%ebp
8010390f:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103912:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103919:	83 ec 0c             	sub    $0xc,%esp
8010391c:	68 40 33 11 80       	push   $0x80113340
80103921:	e8 c9 1b 00 00       	call   801054ef <acquire>
80103926:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103929:	a1 7c 33 11 80       	mov    0x8011337c,%eax
8010392e:	83 e8 01             	sub    $0x1,%eax
80103931:	a3 7c 33 11 80       	mov    %eax,0x8011337c
  if(log.committing)
80103936:	a1 80 33 11 80       	mov    0x80113380,%eax
8010393b:	85 c0                	test   %eax,%eax
8010393d:	74 0d                	je     8010394c <end_op+0x40>
    panic("log.committing");
8010393f:	83 ec 0c             	sub    $0xc,%esp
80103942:	68 c0 90 10 80       	push   $0x801090c0
80103947:	e8 57 cc ff ff       	call   801005a3 <panic>
  if(log.outstanding == 0){
8010394c:	a1 7c 33 11 80       	mov    0x8011337c,%eax
80103951:	85 c0                	test   %eax,%eax
80103953:	75 13                	jne    80103968 <end_op+0x5c>
    do_commit = 1;
80103955:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
8010395c:	c7 05 80 33 11 80 01 	movl   $0x1,0x80113380
80103963:	00 00 00 
80103966:	eb 10                	jmp    80103978 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80103968:	83 ec 0c             	sub    $0xc,%esp
8010396b:	68 40 33 11 80       	push   $0x80113340
80103970:	e8 7e 15 00 00       	call   80104ef3 <wakeup>
80103975:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103978:	83 ec 0c             	sub    $0xc,%esp
8010397b:	68 40 33 11 80       	push   $0x80113340
80103980:	e8 d0 1b 00 00       	call   80105555 <release>
80103985:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
80103988:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010398c:	74 3f                	je     801039cd <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
8010398e:	e8 f3 00 00 00       	call   80103a86 <commit>
    acquire(&log.lock);
80103993:	83 ec 0c             	sub    $0xc,%esp
80103996:	68 40 33 11 80       	push   $0x80113340
8010399b:	e8 4f 1b 00 00       	call   801054ef <acquire>
801039a0:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
801039a3:	c7 05 80 33 11 80 00 	movl   $0x0,0x80113380
801039aa:	00 00 00 
    wakeup(&log);
801039ad:	83 ec 0c             	sub    $0xc,%esp
801039b0:	68 40 33 11 80       	push   $0x80113340
801039b5:	e8 39 15 00 00       	call   80104ef3 <wakeup>
801039ba:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801039bd:	83 ec 0c             	sub    $0xc,%esp
801039c0:	68 40 33 11 80       	push   $0x80113340
801039c5:	e8 8b 1b 00 00       	call   80105555 <release>
801039ca:	83 c4 10             	add    $0x10,%esp
  }
}
801039cd:	c9                   	leave  
801039ce:	c3                   	ret    

801039cf <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
801039cf:	55                   	push   %ebp
801039d0:	89 e5                	mov    %esp,%ebp
801039d2:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801039d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801039dc:	e9 95 00 00 00       	jmp    80103a76 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801039e1:	8b 15 74 33 11 80    	mov    0x80113374,%edx
801039e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039ea:	01 d0                	add    %edx,%eax
801039ec:	83 c0 01             	add    $0x1,%eax
801039ef:	89 c2                	mov    %eax,%edx
801039f1:	a1 84 33 11 80       	mov    0x80113384,%eax
801039f6:	83 ec 08             	sub    $0x8,%esp
801039f9:	52                   	push   %edx
801039fa:	50                   	push   %eax
801039fb:	e8 b4 c7 ff ff       	call   801001b4 <bread>
80103a00:	83 c4 10             	add    $0x10,%esp
80103a03:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a09:	83 c0 10             	add    $0x10,%eax
80103a0c:	8b 04 85 4c 33 11 80 	mov    -0x7feeccb4(,%eax,4),%eax
80103a13:	89 c2                	mov    %eax,%edx
80103a15:	a1 84 33 11 80       	mov    0x80113384,%eax
80103a1a:	83 ec 08             	sub    $0x8,%esp
80103a1d:	52                   	push   %edx
80103a1e:	50                   	push   %eax
80103a1f:	e8 90 c7 ff ff       	call   801001b4 <bread>
80103a24:	83 c4 10             	add    $0x10,%esp
80103a27:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103a2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a2d:	8d 50 18             	lea    0x18(%eax),%edx
80103a30:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a33:	83 c0 18             	add    $0x18,%eax
80103a36:	83 ec 04             	sub    $0x4,%esp
80103a39:	68 00 02 00 00       	push   $0x200
80103a3e:	52                   	push   %edx
80103a3f:	50                   	push   %eax
80103a40:	e8 df 1d 00 00       	call   80105824 <memmove>
80103a45:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
80103a48:	83 ec 0c             	sub    $0xc,%esp
80103a4b:	ff 75 f0             	pushl  -0x10(%ebp)
80103a4e:	e8 9a c7 ff ff       	call   801001ed <bwrite>
80103a53:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
80103a56:	83 ec 0c             	sub    $0xc,%esp
80103a59:	ff 75 ec             	pushl  -0x14(%ebp)
80103a5c:	e8 ca c7 ff ff       	call   8010022b <brelse>
80103a61:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103a64:	83 ec 0c             	sub    $0xc,%esp
80103a67:	ff 75 f0             	pushl  -0x10(%ebp)
80103a6a:	e8 bc c7 ff ff       	call   8010022b <brelse>
80103a6f:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103a72:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103a76:	a1 88 33 11 80       	mov    0x80113388,%eax
80103a7b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a7e:	0f 8f 5d ff ff ff    	jg     801039e1 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
80103a84:	c9                   	leave  
80103a85:	c3                   	ret    

80103a86 <commit>:

static void
commit()
{
80103a86:	55                   	push   %ebp
80103a87:	89 e5                	mov    %esp,%ebp
80103a89:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103a8c:	a1 88 33 11 80       	mov    0x80113388,%eax
80103a91:	85 c0                	test   %eax,%eax
80103a93:	7e 1e                	jle    80103ab3 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103a95:	e8 35 ff ff ff       	call   801039cf <write_log>
    write_head();    // Write header to disk -- the real commit
80103a9a:	e8 3c fd ff ff       	call   801037db <write_head>
    install_trans(); // Now install writes to home locations
80103a9f:	e8 0d fc ff ff       	call   801036b1 <install_trans>
    log.lh.n = 0; 
80103aa4:	c7 05 88 33 11 80 00 	movl   $0x0,0x80113388
80103aab:	00 00 00 
    write_head();    // Erase the transaction from the log
80103aae:	e8 28 fd ff ff       	call   801037db <write_head>
  }
}
80103ab3:	c9                   	leave  
80103ab4:	c3                   	ret    

80103ab5 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103ab5:	55                   	push   %ebp
80103ab6:	89 e5                	mov    %esp,%ebp
80103ab8:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103abb:	a1 88 33 11 80       	mov    0x80113388,%eax
80103ac0:	83 f8 1d             	cmp    $0x1d,%eax
80103ac3:	7f 12                	jg     80103ad7 <log_write+0x22>
80103ac5:	a1 88 33 11 80       	mov    0x80113388,%eax
80103aca:	8b 15 78 33 11 80    	mov    0x80113378,%edx
80103ad0:	83 ea 01             	sub    $0x1,%edx
80103ad3:	39 d0                	cmp    %edx,%eax
80103ad5:	7c 0d                	jl     80103ae4 <log_write+0x2f>
    panic("too big a transaction");
80103ad7:	83 ec 0c             	sub    $0xc,%esp
80103ada:	68 cf 90 10 80       	push   $0x801090cf
80103adf:	e8 bf ca ff ff       	call   801005a3 <panic>
  if (log.outstanding < 1)
80103ae4:	a1 7c 33 11 80       	mov    0x8011337c,%eax
80103ae9:	85 c0                	test   %eax,%eax
80103aeb:	7f 0d                	jg     80103afa <log_write+0x45>
    panic("log_write outside of trans");
80103aed:	83 ec 0c             	sub    $0xc,%esp
80103af0:	68 e5 90 10 80       	push   $0x801090e5
80103af5:	e8 a9 ca ff ff       	call   801005a3 <panic>

  acquire(&log.lock);
80103afa:	83 ec 0c             	sub    $0xc,%esp
80103afd:	68 40 33 11 80       	push   $0x80113340
80103b02:	e8 e8 19 00 00       	call   801054ef <acquire>
80103b07:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103b0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103b11:	eb 1f                	jmp    80103b32 <log_write+0x7d>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b16:	83 c0 10             	add    $0x10,%eax
80103b19:	8b 04 85 4c 33 11 80 	mov    -0x7feeccb4(,%eax,4),%eax
80103b20:	89 c2                	mov    %eax,%edx
80103b22:	8b 45 08             	mov    0x8(%ebp),%eax
80103b25:	8b 40 08             	mov    0x8(%eax),%eax
80103b28:	39 c2                	cmp    %eax,%edx
80103b2a:	75 02                	jne    80103b2e <log_write+0x79>
      break;
80103b2c:	eb 0e                	jmp    80103b3c <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103b2e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103b32:	a1 88 33 11 80       	mov    0x80113388,%eax
80103b37:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b3a:	7f d7                	jg     80103b13 <log_write+0x5e>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103b3c:	8b 45 08             	mov    0x8(%ebp),%eax
80103b3f:	8b 40 08             	mov    0x8(%eax),%eax
80103b42:	89 c2                	mov    %eax,%edx
80103b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b47:	83 c0 10             	add    $0x10,%eax
80103b4a:	89 14 85 4c 33 11 80 	mov    %edx,-0x7feeccb4(,%eax,4)
  if (i == log.lh.n)
80103b51:	a1 88 33 11 80       	mov    0x80113388,%eax
80103b56:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b59:	75 0d                	jne    80103b68 <log_write+0xb3>
    log.lh.n++;
80103b5b:	a1 88 33 11 80       	mov    0x80113388,%eax
80103b60:	83 c0 01             	add    $0x1,%eax
80103b63:	a3 88 33 11 80       	mov    %eax,0x80113388
  b->flags |= B_DIRTY; // prevent eviction
80103b68:	8b 45 08             	mov    0x8(%ebp),%eax
80103b6b:	8b 00                	mov    (%eax),%eax
80103b6d:	83 c8 04             	or     $0x4,%eax
80103b70:	89 c2                	mov    %eax,%edx
80103b72:	8b 45 08             	mov    0x8(%ebp),%eax
80103b75:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103b77:	83 ec 0c             	sub    $0xc,%esp
80103b7a:	68 40 33 11 80       	push   $0x80113340
80103b7f:	e8 d1 19 00 00       	call   80105555 <release>
80103b84:	83 c4 10             	add    $0x10,%esp
}
80103b87:	c9                   	leave  
80103b88:	c3                   	ret    

80103b89 <memcpy1>:
/*convinient functions for manipuling memory*/
unsigned char *memcpy1(unsigned char *dest,const unsigned char *src,int count){
80103b89:	55                   	push   %ebp
80103b8a:	89 e5                	mov    %esp,%ebp
80103b8c:	83 ec 10             	sub    $0x10,%esp
  int i;
  for(i=0;i<count;i++)
80103b8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103b96:	eb 19                	jmp    80103bb1 <memcpy1+0x28>
    dest[i]=src[i];
80103b98:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103b9b:	8b 45 08             	mov    0x8(%ebp),%eax
80103b9e:	01 c2                	add    %eax,%edx
80103ba0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
80103ba3:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ba6:	01 c8                	add    %ecx,%eax
80103ba8:	0f b6 00             	movzbl (%eax),%eax
80103bab:	88 02                	mov    %al,(%edx)
/*convinient functions for manipuling memory*/
unsigned char *memcpy1(unsigned char *dest,const unsigned char *src,int count){
  int i;
  for(i=0;i<count;i++)
80103bad:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103bb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103bb4:	3b 45 10             	cmp    0x10(%ebp),%eax
80103bb7:	7c df                	jl     80103b98 <memcpy1+0xf>
    dest[i]=src[i];
  return dest;
80103bb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
80103bbc:	c9                   	leave  
80103bbd:	c3                   	ret    

80103bbe <memset1>:

unsigned char *memset1(unsigned char *dest,unsigned char val,int count){
80103bbe:	55                   	push   %ebp
80103bbf:	89 e5                	mov    %esp,%ebp
80103bc1:	83 ec 14             	sub    $0x14,%esp
80103bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
80103bc7:	88 45 ec             	mov    %al,-0x14(%ebp)
  int i;
  for(i=0;i<count;i++)
80103bca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103bd1:	eb 12                	jmp    80103be5 <memset1+0x27>
    dest[i]=val;
80103bd3:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103bd6:	8b 45 08             	mov    0x8(%ebp),%eax
80103bd9:	01 c2                	add    %eax,%edx
80103bdb:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103bdf:	88 02                	mov    %al,(%edx)
  return dest;
}

unsigned char *memset1(unsigned char *dest,unsigned char val,int count){
  int i;
  for(i=0;i<count;i++)
80103be1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103be5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103be8:	3b 45 10             	cmp    0x10(%ebp),%eax
80103beb:	7c e6                	jl     80103bd3 <memset1+0x15>
    dest[i]=val;
  return dest;
80103bed:	8b 45 08             	mov    0x8(%ebp),%eax
}
80103bf0:	c9                   	leave  
80103bf1:	c3                   	ret    

80103bf2 <p2v>:
80103bf2:	55                   	push   %ebp
80103bf3:	89 e5                	mov    %esp,%ebp
80103bf5:	8b 45 08             	mov    0x8(%ebp),%eax
80103bf8:	05 00 00 00 80       	add    $0x80000000,%eax
80103bfd:	5d                   	pop    %ebp
80103bfe:	c3                   	ret    

80103bff <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103bff:	55                   	push   %ebp
80103c00:	89 e5                	mov    %esp,%ebp
80103c02:	83 ec 14             	sub    $0x14,%esp
80103c05:	8b 45 08             	mov    0x8(%ebp),%eax
80103c08:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103c0c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103c10:	89 c2                	mov    %eax,%edx
80103c12:	ec                   	in     (%dx),%al
80103c13:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103c16:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103c1a:	c9                   	leave  
80103c1b:	c3                   	ret    

80103c1c <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103c1c:	55                   	push   %ebp
80103c1d:	89 e5                	mov    %esp,%ebp
80103c1f:	83 ec 08             	sub    $0x8,%esp
80103c22:	8b 55 08             	mov    0x8(%ebp),%edx
80103c25:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c28:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103c2c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103c2f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103c33:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103c37:	ee                   	out    %al,(%dx)
}
80103c38:	c9                   	leave  
80103c39:	c3                   	ret    

80103c3a <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103c3a:	55                   	push   %ebp
80103c3b:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103c3d:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80103c42:	89 c2                	mov    %eax,%edx
80103c44:	b8 80 34 11 80       	mov    $0x80113480,%eax
80103c49:	29 c2                	sub    %eax,%edx
80103c4b:	89 d0                	mov    %edx,%eax
80103c4d:	c1 f8 02             	sar    $0x2,%eax
80103c50:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103c56:	5d                   	pop    %ebp
80103c57:	c3                   	ret    

80103c58 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103c58:	55                   	push   %ebp
80103c59:	89 e5                	mov    %esp,%ebp
80103c5b:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103c5e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103c65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103c6c:	eb 15                	jmp    80103c83 <sum+0x2b>
    sum += addr[i];
80103c6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103c71:	8b 45 08             	mov    0x8(%ebp),%eax
80103c74:	01 d0                	add    %edx,%eax
80103c76:	0f b6 00             	movzbl (%eax),%eax
80103c79:	0f b6 c0             	movzbl %al,%eax
80103c7c:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103c7f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103c83:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103c86:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103c89:	7c e3                	jl     80103c6e <sum+0x16>
    sum += addr[i];
  return sum;
80103c8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103c8e:	c9                   	leave  
80103c8f:	c3                   	ret    

80103c90 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103c96:	ff 75 08             	pushl  0x8(%ebp)
80103c99:	e8 54 ff ff ff       	call   80103bf2 <p2v>
80103c9e:	83 c4 04             	add    $0x4,%esp
80103ca1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103ca4:	8b 55 0c             	mov    0xc(%ebp),%edx
80103ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103caa:	01 d0                	add    %edx,%eax
80103cac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103cb5:	eb 36                	jmp    80103ced <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103cb7:	83 ec 04             	sub    $0x4,%esp
80103cba:	6a 04                	push   $0x4
80103cbc:	68 00 91 10 80       	push   $0x80109100
80103cc1:	ff 75 f4             	pushl  -0xc(%ebp)
80103cc4:	e8 03 1b 00 00       	call   801057cc <memcmp>
80103cc9:	83 c4 10             	add    $0x10,%esp
80103ccc:	85 c0                	test   %eax,%eax
80103cce:	75 19                	jne    80103ce9 <mpsearch1+0x59>
80103cd0:	83 ec 08             	sub    $0x8,%esp
80103cd3:	6a 10                	push   $0x10
80103cd5:	ff 75 f4             	pushl  -0xc(%ebp)
80103cd8:	e8 7b ff ff ff       	call   80103c58 <sum>
80103cdd:	83 c4 10             	add    $0x10,%esp
80103ce0:	84 c0                	test   %al,%al
80103ce2:	75 05                	jne    80103ce9 <mpsearch1+0x59>
      return (struct mp*)p;
80103ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ce7:	eb 11                	jmp    80103cfa <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103ce9:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cf0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103cf3:	72 c2                	jb     80103cb7 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103cf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103cfa:	c9                   	leave  
80103cfb:	c3                   	ret    

80103cfc <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103cfc:	55                   	push   %ebp
80103cfd:	89 e5                	mov    %esp,%ebp
80103cff:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103d02:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d0c:	83 c0 0f             	add    $0xf,%eax
80103d0f:	0f b6 00             	movzbl (%eax),%eax
80103d12:	0f b6 c0             	movzbl %al,%eax
80103d15:	c1 e0 08             	shl    $0x8,%eax
80103d18:	89 c2                	mov    %eax,%edx
80103d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d1d:	83 c0 0e             	add    $0xe,%eax
80103d20:	0f b6 00             	movzbl (%eax),%eax
80103d23:	0f b6 c0             	movzbl %al,%eax
80103d26:	09 d0                	or     %edx,%eax
80103d28:	c1 e0 04             	shl    $0x4,%eax
80103d2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103d2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103d32:	74 21                	je     80103d55 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103d34:	83 ec 08             	sub    $0x8,%esp
80103d37:	68 00 04 00 00       	push   $0x400
80103d3c:	ff 75 f0             	pushl  -0x10(%ebp)
80103d3f:	e8 4c ff ff ff       	call   80103c90 <mpsearch1>
80103d44:	83 c4 10             	add    $0x10,%esp
80103d47:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d4a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103d4e:	74 51                	je     80103da1 <mpsearch+0xa5>
      return mp;
80103d50:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d53:	eb 61                	jmp    80103db6 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d58:	83 c0 14             	add    $0x14,%eax
80103d5b:	0f b6 00             	movzbl (%eax),%eax
80103d5e:	0f b6 c0             	movzbl %al,%eax
80103d61:	c1 e0 08             	shl    $0x8,%eax
80103d64:	89 c2                	mov    %eax,%edx
80103d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d69:	83 c0 13             	add    $0x13,%eax
80103d6c:	0f b6 00             	movzbl (%eax),%eax
80103d6f:	0f b6 c0             	movzbl %al,%eax
80103d72:	09 d0                	or     %edx,%eax
80103d74:	c1 e0 0a             	shl    $0xa,%eax
80103d77:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d7d:	2d 00 04 00 00       	sub    $0x400,%eax
80103d82:	83 ec 08             	sub    $0x8,%esp
80103d85:	68 00 04 00 00       	push   $0x400
80103d8a:	50                   	push   %eax
80103d8b:	e8 00 ff ff ff       	call   80103c90 <mpsearch1>
80103d90:	83 c4 10             	add    $0x10,%esp
80103d93:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d96:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103d9a:	74 05                	je     80103da1 <mpsearch+0xa5>
      return mp;
80103d9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d9f:	eb 15                	jmp    80103db6 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103da1:	83 ec 08             	sub    $0x8,%esp
80103da4:	68 00 00 01 00       	push   $0x10000
80103da9:	68 00 00 0f 00       	push   $0xf0000
80103dae:	e8 dd fe ff ff       	call   80103c90 <mpsearch1>
80103db3:	83 c4 10             	add    $0x10,%esp
}
80103db6:	c9                   	leave  
80103db7:	c3                   	ret    

80103db8 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103db8:	55                   	push   %ebp
80103db9:	89 e5                	mov    %esp,%ebp
80103dbb:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103dbe:	e8 39 ff ff ff       	call   80103cfc <mpsearch>
80103dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103dc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103dca:	74 0a                	je     80103dd6 <mpconfig+0x1e>
80103dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dcf:	8b 40 04             	mov    0x4(%eax),%eax
80103dd2:	85 c0                	test   %eax,%eax
80103dd4:	75 0a                	jne    80103de0 <mpconfig+0x28>
    return 0;
80103dd6:	b8 00 00 00 00       	mov    $0x0,%eax
80103ddb:	e9 81 00 00 00       	jmp    80103e61 <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103de3:	8b 40 04             	mov    0x4(%eax),%eax
80103de6:	83 ec 0c             	sub    $0xc,%esp
80103de9:	50                   	push   %eax
80103dea:	e8 03 fe ff ff       	call   80103bf2 <p2v>
80103def:	83 c4 10             	add    $0x10,%esp
80103df2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103df5:	83 ec 04             	sub    $0x4,%esp
80103df8:	6a 04                	push   $0x4
80103dfa:	68 05 91 10 80       	push   $0x80109105
80103dff:	ff 75 f0             	pushl  -0x10(%ebp)
80103e02:	e8 c5 19 00 00       	call   801057cc <memcmp>
80103e07:	83 c4 10             	add    $0x10,%esp
80103e0a:	85 c0                	test   %eax,%eax
80103e0c:	74 07                	je     80103e15 <mpconfig+0x5d>
    return 0;
80103e0e:	b8 00 00 00 00       	mov    $0x0,%eax
80103e13:	eb 4c                	jmp    80103e61 <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103e15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e18:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103e1c:	3c 01                	cmp    $0x1,%al
80103e1e:	74 12                	je     80103e32 <mpconfig+0x7a>
80103e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e23:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103e27:	3c 04                	cmp    $0x4,%al
80103e29:	74 07                	je     80103e32 <mpconfig+0x7a>
    return 0;
80103e2b:	b8 00 00 00 00       	mov    $0x0,%eax
80103e30:	eb 2f                	jmp    80103e61 <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103e32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e35:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103e39:	0f b7 c0             	movzwl %ax,%eax
80103e3c:	83 ec 08             	sub    $0x8,%esp
80103e3f:	50                   	push   %eax
80103e40:	ff 75 f0             	pushl  -0x10(%ebp)
80103e43:	e8 10 fe ff ff       	call   80103c58 <sum>
80103e48:	83 c4 10             	add    $0x10,%esp
80103e4b:	84 c0                	test   %al,%al
80103e4d:	74 07                	je     80103e56 <mpconfig+0x9e>
    return 0;
80103e4f:	b8 00 00 00 00       	mov    $0x0,%eax
80103e54:	eb 0b                	jmp    80103e61 <mpconfig+0xa9>
  *pmp = mp;
80103e56:	8b 45 08             	mov    0x8(%ebp),%eax
80103e59:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e5c:	89 10                	mov    %edx,(%eax)
  return conf;
80103e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103e61:	c9                   	leave  
80103e62:	c3                   	ret    

80103e63 <mpinit>:

void
mpinit(void)
{
80103e63:	55                   	push   %ebp
80103e64:	89 e5                	mov    %esp,%ebp
80103e66:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103e69:	c7 05 64 c6 10 80 80 	movl   $0x80113480,0x8010c664
80103e70:	34 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103e73:	83 ec 0c             	sub    $0xc,%esp
80103e76:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103e79:	50                   	push   %eax
80103e7a:	e8 39 ff ff ff       	call   80103db8 <mpconfig>
80103e7f:	83 c4 10             	add    $0x10,%esp
80103e82:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103e85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103e89:	75 05                	jne    80103e90 <mpinit+0x2d>
    return;
80103e8b:	e9 ba 01 00 00       	jmp    8010404a <mpinit+0x1e7>
  ismp = 1;
80103e90:	c7 05 44 34 11 80 01 	movl   $0x1,0x80113444
80103e97:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103e9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e9d:	8b 40 24             	mov    0x24(%eax),%eax
80103ea0:	a3 1c 33 11 80       	mov    %eax,0x8011331c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ea8:	83 c0 2c             	add    $0x2c,%eax
80103eab:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103eae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103eb1:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103eb5:	0f b7 d0             	movzwl %ax,%edx
80103eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ebb:	01 d0                	add    %edx,%eax
80103ebd:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103ec0:	e9 f2 00 00 00       	jmp    80103fb7 <mpinit+0x154>
    switch(*p){
80103ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ec8:	0f b6 00             	movzbl (%eax),%eax
80103ecb:	0f b6 c0             	movzbl %al,%eax
80103ece:	83 f8 04             	cmp    $0x4,%eax
80103ed1:	0f 87 bc 00 00 00    	ja     80103f93 <mpinit+0x130>
80103ed7:	8b 04 85 d0 91 10 80 	mov    -0x7fef6e30(,%eax,4),%eax
80103ede:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ee3:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103ee6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103ee9:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103eed:	0f b6 d0             	movzbl %al,%edx
80103ef0:	a1 60 3a 11 80       	mov    0x80113a60,%eax
80103ef5:	39 c2                	cmp    %eax,%edx
80103ef7:	74 2b                	je     80103f24 <mpinit+0xc1>
        cprintf("mp.c::void mpinit(void):mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103ef9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103efc:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103f00:	0f b6 d0             	movzbl %al,%edx
80103f03:	a1 60 3a 11 80       	mov    0x80113a60,%eax
80103f08:	83 ec 04             	sub    $0x4,%esp
80103f0b:	52                   	push   %edx
80103f0c:	50                   	push   %eax
80103f0d:	68 0c 91 10 80       	push   $0x8010910c
80103f12:	e8 ef c4 ff ff       	call   80100406 <cprintf>
80103f17:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103f1a:	c7 05 44 34 11 80 00 	movl   $0x0,0x80113444
80103f21:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103f24:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103f27:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103f2b:	0f b6 c0             	movzbl %al,%eax
80103f2e:	83 e0 02             	and    $0x2,%eax
80103f31:	85 c0                	test   %eax,%eax
80103f33:	74 15                	je     80103f4a <mpinit+0xe7>
        bcpu = &cpus[ncpu];
80103f35:	a1 60 3a 11 80       	mov    0x80113a60,%eax
80103f3a:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103f40:	05 80 34 11 80       	add    $0x80113480,%eax
80103f45:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103f4a:	a1 60 3a 11 80       	mov    0x80113a60,%eax
80103f4f:	8b 15 60 3a 11 80    	mov    0x80113a60,%edx
80103f55:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103f5b:	05 80 34 11 80       	add    $0x80113480,%eax
80103f60:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103f62:	a1 60 3a 11 80       	mov    0x80113a60,%eax
80103f67:	83 c0 01             	add    $0x1,%eax
80103f6a:	a3 60 3a 11 80       	mov    %eax,0x80113a60
      p += sizeof(struct mpproc);
80103f6f:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103f73:	eb 42                	jmp    80103fb7 <mpinit+0x154>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103f7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103f7e:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103f82:	a2 40 34 11 80       	mov    %al,0x80113440
      p += sizeof(struct mpioapic);
80103f87:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103f8b:	eb 2a                	jmp    80103fb7 <mpinit+0x154>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103f8d:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103f91:	eb 24                	jmp    80103fb7 <mpinit+0x154>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f96:	0f b6 00             	movzbl (%eax),%eax
80103f99:	0f b6 c0             	movzbl %al,%eax
80103f9c:	83 ec 08             	sub    $0x8,%esp
80103f9f:	50                   	push   %eax
80103fa0:	68 40 91 10 80       	push   $0x80109140
80103fa5:	e8 5c c4 ff ff       	call   80100406 <cprintf>
80103faa:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103fad:	c7 05 44 34 11 80 00 	movl   $0x0,0x80113444
80103fb4:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fba:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103fbd:	0f 82 02 ff ff ff    	jb     80103ec5 <mpinit+0x62>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103fc3:	a1 44 34 11 80       	mov    0x80113444,%eax
80103fc8:	85 c0                	test   %eax,%eax
80103fca:	75 2d                	jne    80103ff9 <mpinit+0x196>
    // Didn't like what we found; fall back to no MP.
cprintf("mp.c::void mpinit(void): Didn't like what we found; fall back to no MP.\n");
80103fcc:	83 ec 0c             	sub    $0xc,%esp
80103fcf:	68 60 91 10 80       	push   $0x80109160
80103fd4:	e8 2d c4 ff ff       	call   80100406 <cprintf>
80103fd9:	83 c4 10             	add    $0x10,%esp
    ncpu = 1;
80103fdc:	c7 05 60 3a 11 80 01 	movl   $0x1,0x80113a60
80103fe3:	00 00 00 
    lapic = 0;
80103fe6:	c7 05 1c 33 11 80 00 	movl   $0x0,0x8011331c
80103fed:	00 00 00 
    ioapicid = 0;
80103ff0:	c6 05 40 34 11 80 00 	movb   $0x0,0x80113440
    return;
80103ff7:	eb 51                	jmp    8010404a <mpinit+0x1e7>
  }
cprintf("mp.c::void mpinit(void): ismp=%d\n",ismp);
80103ff9:	a1 44 34 11 80       	mov    0x80113444,%eax
80103ffe:	83 ec 08             	sub    $0x8,%esp
80104001:	50                   	push   %eax
80104002:	68 ac 91 10 80       	push   $0x801091ac
80104007:	e8 fa c3 ff ff       	call   80100406 <cprintf>
8010400c:	83 c4 10             	add    $0x10,%esp

  if(mp->imcrp){
8010400f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104012:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80104016:	84 c0                	test   %al,%al
80104018:	74 30                	je     8010404a <mpinit+0x1e7>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
8010401a:	83 ec 08             	sub    $0x8,%esp
8010401d:	6a 70                	push   $0x70
8010401f:	6a 22                	push   $0x22
80104021:	e8 f6 fb ff ff       	call   80103c1c <outb>
80104026:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80104029:	83 ec 0c             	sub    $0xc,%esp
8010402c:	6a 23                	push   $0x23
8010402e:	e8 cc fb ff ff       	call   80103bff <inb>
80104033:	83 c4 10             	add    $0x10,%esp
80104036:	83 c8 01             	or     $0x1,%eax
80104039:	0f b6 c0             	movzbl %al,%eax
8010403c:	83 ec 08             	sub    $0x8,%esp
8010403f:	50                   	push   %eax
80104040:	6a 23                	push   $0x23
80104042:	e8 d5 fb ff ff       	call   80103c1c <outb>
80104047:	83 c4 10             	add    $0x10,%esp
  }
}
8010404a:	c9                   	leave  
8010404b:	c3                   	ret    

8010404c <enableIRQ>:
#define inportb inbyte 
#define outportb  outbyte


/*enable all passible IRQ interrupts*/
void enableIRQ(void){
8010404c:	55                   	push   %ebp
8010404d:	89 e5                	mov    %esp,%ebp
8010404f:	83 ec 08             	sub    $0x8,%esp
  outportb(PIC1e,PICenable);
80104052:	83 ec 08             	sub    $0x8,%esp
80104055:	6a 00                	push   $0x0
80104057:	6a 21                	push   $0x21
80104059:	e8 8f c2 ff ff       	call   801002ed <outbyte>
8010405e:	83 c4 10             	add    $0x10,%esp
  outportb(PIC2e,PICenable);
80104061:	83 ec 08             	sub    $0x8,%esp
80104064:	6a 00                	push   $0x0
80104066:	68 a1 00 00 00       	push   $0xa1
8010406b:	e8 7d c2 ff ff       	call   801002ed <outbyte>
80104070:	83 c4 10             	add    $0x10,%esp
  sti();
80104073:	e8 93 c2 ff ff       	call   8010030b <sti>
}
80104078:	c9                   	leave  
80104079:	c3                   	ret    

8010407a <disableIRQ>:

/*disable all IRQs*/
void disableIRQ(void){
8010407a:	55                   	push   %ebp
8010407b:	89 e5                	mov    %esp,%ebp
8010407d:	83 ec 08             	sub    $0x8,%esp
  outportb(PIC1e,PICdisable);
80104080:	83 ec 08             	sub    $0x8,%esp
80104083:	68 ff 00 00 00       	push   $0xff
80104088:	6a 21                	push   $0x21
8010408a:	e8 5e c2 ff ff       	call   801002ed <outbyte>
8010408f:	83 c4 10             	add    $0x10,%esp
}
80104092:	c9                   	leave  
80104093:	c3                   	ret    

80104094 <init_pics>:

/* init_pics()
 * init the PICs and remap the,
 */
static void init_pics(int pic1,int pic2){
80104094:	55                   	push   %ebp
80104095:	89 e5                	mov    %esp,%ebp
80104097:	83 ec 08             	sub    $0x8,%esp
  /*send ICW1*/
  outportb(PIC1,ICW1);
8010409a:	83 ec 08             	sub    $0x8,%esp
8010409d:	6a 11                	push   $0x11
8010409f:	6a 20                	push   $0x20
801040a1:	e8 47 c2 ff ff       	call   801002ed <outbyte>
801040a6:	83 c4 10             	add    $0x10,%esp
  outportb(PIC2,ICW1);
801040a9:	83 ec 08             	sub    $0x8,%esp
801040ac:	6a 11                	push   $0x11
801040ae:	68 a0 00 00 00       	push   $0xa0
801040b3:	e8 35 c2 ff ff       	call   801002ed <outbyte>
801040b8:	83 c4 10             	add    $0x10,%esp

  /*send ICW2*/
  outportb(PIC1e,pic1); /*remap*/
801040bb:	8b 45 08             	mov    0x8(%ebp),%eax
801040be:	0f b6 c0             	movzbl %al,%eax
801040c1:	83 ec 08             	sub    $0x8,%esp
801040c4:	50                   	push   %eax
801040c5:	6a 21                	push   $0x21
801040c7:	e8 21 c2 ff ff       	call   801002ed <outbyte>
801040cc:	83 c4 10             	add    $0x10,%esp
  outportb(PIC2e,pic2);
801040cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801040d2:	0f b6 c0             	movzbl %al,%eax
801040d5:	83 ec 08             	sub    $0x8,%esp
801040d8:	50                   	push   %eax
801040d9:	68 a1 00 00 00       	push   $0xa1
801040de:	e8 0a c2 ff ff       	call   801002ed <outbyte>
801040e3:	83 c4 10             	add    $0x10,%esp

  /*send ICW3*/
  outportb(PIC1e,4); /*IRQ2 -> connection to slave*/
801040e6:	83 ec 08             	sub    $0x8,%esp
801040e9:	6a 04                	push   $0x4
801040eb:	6a 21                	push   $0x21
801040ed:	e8 fb c1 ff ff       	call   801002ed <outbyte>
801040f2:	83 c4 10             	add    $0x10,%esp
  outportb(PIC2e,2);
801040f5:	83 ec 08             	sub    $0x8,%esp
801040f8:	6a 02                	push   $0x2
801040fa:	68 a1 00 00 00       	push   $0xa1
801040ff:	e8 e9 c1 ff ff       	call   801002ed <outbyte>
80104104:	83 c4 10             	add    $0x10,%esp

  /*send ICW4*/
  outportb(PIC1e,ICW4);
80104107:	83 ec 08             	sub    $0x8,%esp
8010410a:	6a 01                	push   $0x1
8010410c:	6a 21                	push   $0x21
8010410e:	e8 da c1 ff ff       	call   801002ed <outbyte>
80104113:	83 c4 10             	add    $0x10,%esp
  outportb(PIC2e,ICW4);
80104116:	83 ec 08             	sub    $0x8,%esp
80104119:	6a 01                	push   $0x1
8010411b:	68 a1 00 00 00       	push   $0xa1
80104120:	e8 c8 c1 ff ff       	call   801002ed <outbyte>
80104125:	83 c4 10             	add    $0x10,%esp
}
80104128:	c9                   	leave  
80104129:	c3                   	ret    

8010412a <remap_pics>:

/*remap IRQs to 0x20-0x2f*/
void remap_pics(void){
8010412a:	55                   	push   %ebp
8010412b:	89 e5                	mov    %esp,%ebp
8010412d:	83 ec 08             	sub    $0x8,%esp
  init_pics(0x20,0x28);
80104130:	83 ec 08             	sub    $0x8,%esp
80104133:	6a 28                	push   $0x28
80104135:	6a 20                	push   $0x20
80104137:	e8 58 ff ff ff       	call   80104094 <init_pics>
8010413c:	83 c4 10             	add    $0x10,%esp
  enableIRQ();
8010413f:	e8 08 ff ff ff       	call   8010404c <enableIRQ>
}
80104144:	c9                   	leave  
80104145:	c3                   	ret    

80104146 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104146:	55                   	push   %ebp
80104147:	89 e5                	mov    %esp,%ebp
80104149:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
8010414c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80104153:	8b 45 0c             	mov    0xc(%ebp),%eax
80104156:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010415c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010415f:	8b 10                	mov    (%eax),%edx
80104161:	8b 45 08             	mov    0x8(%ebp),%eax
80104164:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80104166:	e8 37 ce ff ff       	call   80100fa2 <filealloc>
8010416b:	89 c2                	mov    %eax,%edx
8010416d:	8b 45 08             	mov    0x8(%ebp),%eax
80104170:	89 10                	mov    %edx,(%eax)
80104172:	8b 45 08             	mov    0x8(%ebp),%eax
80104175:	8b 00                	mov    (%eax),%eax
80104177:	85 c0                	test   %eax,%eax
80104179:	0f 84 cb 00 00 00    	je     8010424a <pipealloc+0x104>
8010417f:	e8 1e ce ff ff       	call   80100fa2 <filealloc>
80104184:	89 c2                	mov    %eax,%edx
80104186:	8b 45 0c             	mov    0xc(%ebp),%eax
80104189:	89 10                	mov    %edx,(%eax)
8010418b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010418e:	8b 00                	mov    (%eax),%eax
80104190:	85 c0                	test   %eax,%eax
80104192:	0f 84 b2 00 00 00    	je     8010424a <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104198:	e8 54 ed ff ff       	call   80102ef1 <kalloc>
8010419d:	89 45 f4             	mov    %eax,-0xc(%ebp)
801041a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801041a4:	75 05                	jne    801041ab <pipealloc+0x65>
    goto bad;
801041a6:	e9 9f 00 00 00       	jmp    8010424a <pipealloc+0x104>
  p->readopen = 1;
801041ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ae:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801041b5:	00 00 00 
  p->writeopen = 1;
801041b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041bb:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801041c2:	00 00 00 
  p->nwrite = 0;
801041c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041c8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801041cf:	00 00 00 
  p->nread = 0;
801041d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041d5:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801041dc:	00 00 00 
  initlock(&p->lock, "pipe");
801041df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041e2:	83 ec 08             	sub    $0x8,%esp
801041e5:	68 e4 91 10 80       	push   $0x801091e4
801041ea:	50                   	push   %eax
801041eb:	e8 de 12 00 00       	call   801054ce <initlock>
801041f0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801041f3:	8b 45 08             	mov    0x8(%ebp),%eax
801041f6:	8b 00                	mov    (%eax),%eax
801041f8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801041fe:	8b 45 08             	mov    0x8(%ebp),%eax
80104201:	8b 00                	mov    (%eax),%eax
80104203:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104207:	8b 45 08             	mov    0x8(%ebp),%eax
8010420a:	8b 00                	mov    (%eax),%eax
8010420c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104210:	8b 45 08             	mov    0x8(%ebp),%eax
80104213:	8b 00                	mov    (%eax),%eax
80104215:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104218:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010421b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010421e:	8b 00                	mov    (%eax),%eax
80104220:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104226:	8b 45 0c             	mov    0xc(%ebp),%eax
80104229:	8b 00                	mov    (%eax),%eax
8010422b:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010422f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104232:	8b 00                	mov    (%eax),%eax
80104234:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104238:	8b 45 0c             	mov    0xc(%ebp),%eax
8010423b:	8b 00                	mov    (%eax),%eax
8010423d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104240:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80104243:	b8 00 00 00 00       	mov    $0x0,%eax
80104248:	eb 4d                	jmp    80104297 <pipealloc+0x151>

//PAGEBREAK: 20
 bad:
  if(p)
8010424a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010424e:	74 0e                	je     8010425e <pipealloc+0x118>
    kfree((char*)p);
80104250:	83 ec 0c             	sub    $0xc,%esp
80104253:	ff 75 f4             	pushl  -0xc(%ebp)
80104256:	e8 fa eb ff ff       	call   80102e55 <kfree>
8010425b:	83 c4 10             	add    $0x10,%esp
  if(*f0)
8010425e:	8b 45 08             	mov    0x8(%ebp),%eax
80104261:	8b 00                	mov    (%eax),%eax
80104263:	85 c0                	test   %eax,%eax
80104265:	74 11                	je     80104278 <pipealloc+0x132>
    fileclose(*f0);
80104267:	8b 45 08             	mov    0x8(%ebp),%eax
8010426a:	8b 00                	mov    (%eax),%eax
8010426c:	83 ec 0c             	sub    $0xc,%esp
8010426f:	50                   	push   %eax
80104270:	e8 ea cd ff ff       	call   8010105f <fileclose>
80104275:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104278:	8b 45 0c             	mov    0xc(%ebp),%eax
8010427b:	8b 00                	mov    (%eax),%eax
8010427d:	85 c0                	test   %eax,%eax
8010427f:	74 11                	je     80104292 <pipealloc+0x14c>
    fileclose(*f1);
80104281:	8b 45 0c             	mov    0xc(%ebp),%eax
80104284:	8b 00                	mov    (%eax),%eax
80104286:	83 ec 0c             	sub    $0xc,%esp
80104289:	50                   	push   %eax
8010428a:	e8 d0 cd ff ff       	call   8010105f <fileclose>
8010428f:	83 c4 10             	add    $0x10,%esp
  return -1;
80104292:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104297:	c9                   	leave  
80104298:	c3                   	ret    

80104299 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104299:	55                   	push   %ebp
8010429a:	89 e5                	mov    %esp,%ebp
8010429c:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
8010429f:	8b 45 08             	mov    0x8(%ebp),%eax
801042a2:	83 ec 0c             	sub    $0xc,%esp
801042a5:	50                   	push   %eax
801042a6:	e8 44 12 00 00       	call   801054ef <acquire>
801042ab:	83 c4 10             	add    $0x10,%esp
  if(writable){
801042ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801042b2:	74 23                	je     801042d7 <pipeclose+0x3e>
    p->writeopen = 0;
801042b4:	8b 45 08             	mov    0x8(%ebp),%eax
801042b7:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801042be:	00 00 00 
    wakeup(&p->nread);
801042c1:	8b 45 08             	mov    0x8(%ebp),%eax
801042c4:	05 34 02 00 00       	add    $0x234,%eax
801042c9:	83 ec 0c             	sub    $0xc,%esp
801042cc:	50                   	push   %eax
801042cd:	e8 21 0c 00 00       	call   80104ef3 <wakeup>
801042d2:	83 c4 10             	add    $0x10,%esp
801042d5:	eb 21                	jmp    801042f8 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
801042d7:	8b 45 08             	mov    0x8(%ebp),%eax
801042da:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801042e1:	00 00 00 
    wakeup(&p->nwrite);
801042e4:	8b 45 08             	mov    0x8(%ebp),%eax
801042e7:	05 38 02 00 00       	add    $0x238,%eax
801042ec:	83 ec 0c             	sub    $0xc,%esp
801042ef:	50                   	push   %eax
801042f0:	e8 fe 0b 00 00       	call   80104ef3 <wakeup>
801042f5:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
801042f8:	8b 45 08             	mov    0x8(%ebp),%eax
801042fb:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104301:	85 c0                	test   %eax,%eax
80104303:	75 2c                	jne    80104331 <pipeclose+0x98>
80104305:	8b 45 08             	mov    0x8(%ebp),%eax
80104308:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010430e:	85 c0                	test   %eax,%eax
80104310:	75 1f                	jne    80104331 <pipeclose+0x98>
    release(&p->lock);
80104312:	8b 45 08             	mov    0x8(%ebp),%eax
80104315:	83 ec 0c             	sub    $0xc,%esp
80104318:	50                   	push   %eax
80104319:	e8 37 12 00 00       	call   80105555 <release>
8010431e:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80104321:	83 ec 0c             	sub    $0xc,%esp
80104324:	ff 75 08             	pushl  0x8(%ebp)
80104327:	e8 29 eb ff ff       	call   80102e55 <kfree>
8010432c:	83 c4 10             	add    $0x10,%esp
8010432f:	eb 0f                	jmp    80104340 <pipeclose+0xa7>
  } else
    release(&p->lock);
80104331:	8b 45 08             	mov    0x8(%ebp),%eax
80104334:	83 ec 0c             	sub    $0xc,%esp
80104337:	50                   	push   %eax
80104338:	e8 18 12 00 00       	call   80105555 <release>
8010433d:	83 c4 10             	add    $0x10,%esp
}
80104340:	c9                   	leave  
80104341:	c3                   	ret    

80104342 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104342:	55                   	push   %ebp
80104343:	89 e5                	mov    %esp,%ebp
80104345:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80104348:	8b 45 08             	mov    0x8(%ebp),%eax
8010434b:	83 ec 0c             	sub    $0xc,%esp
8010434e:	50                   	push   %eax
8010434f:	e8 9b 11 00 00       	call   801054ef <acquire>
80104354:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80104357:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010435e:	e9 af 00 00 00       	jmp    80104412 <pipewrite+0xd0>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104363:	eb 60                	jmp    801043c5 <pipewrite+0x83>
      if(p->readopen == 0 || proc->killed){
80104365:	8b 45 08             	mov    0x8(%ebp),%eax
80104368:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010436e:	85 c0                	test   %eax,%eax
80104370:	74 0d                	je     8010437f <pipewrite+0x3d>
80104372:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104378:	8b 40 24             	mov    0x24(%eax),%eax
8010437b:	85 c0                	test   %eax,%eax
8010437d:	74 19                	je     80104398 <pipewrite+0x56>
        release(&p->lock);
8010437f:	8b 45 08             	mov    0x8(%ebp),%eax
80104382:	83 ec 0c             	sub    $0xc,%esp
80104385:	50                   	push   %eax
80104386:	e8 ca 11 00 00       	call   80105555 <release>
8010438b:	83 c4 10             	add    $0x10,%esp
        return -1;
8010438e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104393:	e9 ac 00 00 00       	jmp    80104444 <pipewrite+0x102>
      }
      wakeup(&p->nread);
80104398:	8b 45 08             	mov    0x8(%ebp),%eax
8010439b:	05 34 02 00 00       	add    $0x234,%eax
801043a0:	83 ec 0c             	sub    $0xc,%esp
801043a3:	50                   	push   %eax
801043a4:	e8 4a 0b 00 00       	call   80104ef3 <wakeup>
801043a9:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801043ac:	8b 45 08             	mov    0x8(%ebp),%eax
801043af:	8b 55 08             	mov    0x8(%ebp),%edx
801043b2:	81 c2 38 02 00 00    	add    $0x238,%edx
801043b8:	83 ec 08             	sub    $0x8,%esp
801043bb:	50                   	push   %eax
801043bc:	52                   	push   %edx
801043bd:	e8 48 0a 00 00       	call   80104e0a <sleep>
801043c2:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801043c5:	8b 45 08             	mov    0x8(%ebp),%eax
801043c8:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801043ce:	8b 45 08             	mov    0x8(%ebp),%eax
801043d1:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801043d7:	05 00 02 00 00       	add    $0x200,%eax
801043dc:	39 c2                	cmp    %eax,%edx
801043de:	74 85                	je     80104365 <pipewrite+0x23>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801043e0:	8b 45 08             	mov    0x8(%ebp),%eax
801043e3:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801043e9:	8d 48 01             	lea    0x1(%eax),%ecx
801043ec:	8b 55 08             	mov    0x8(%ebp),%edx
801043ef:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801043f5:	25 ff 01 00 00       	and    $0x1ff,%eax
801043fa:	89 c1                	mov    %eax,%ecx
801043fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80104402:	01 d0                	add    %edx,%eax
80104404:	0f b6 10             	movzbl (%eax),%edx
80104407:	8b 45 08             	mov    0x8(%ebp),%eax
8010440a:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
8010440e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104412:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104415:	3b 45 10             	cmp    0x10(%ebp),%eax
80104418:	0f 8c 45 ff ff ff    	jl     80104363 <pipewrite+0x21>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010441e:	8b 45 08             	mov    0x8(%ebp),%eax
80104421:	05 34 02 00 00       	add    $0x234,%eax
80104426:	83 ec 0c             	sub    $0xc,%esp
80104429:	50                   	push   %eax
8010442a:	e8 c4 0a 00 00       	call   80104ef3 <wakeup>
8010442f:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104432:	8b 45 08             	mov    0x8(%ebp),%eax
80104435:	83 ec 0c             	sub    $0xc,%esp
80104438:	50                   	push   %eax
80104439:	e8 17 11 00 00       	call   80105555 <release>
8010443e:	83 c4 10             	add    $0x10,%esp
  return n;
80104441:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104444:	c9                   	leave  
80104445:	c3                   	ret    

80104446 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104446:	55                   	push   %ebp
80104447:	89 e5                	mov    %esp,%ebp
80104449:	53                   	push   %ebx
8010444a:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
8010444d:	8b 45 08             	mov    0x8(%ebp),%eax
80104450:	83 ec 0c             	sub    $0xc,%esp
80104453:	50                   	push   %eax
80104454:	e8 96 10 00 00       	call   801054ef <acquire>
80104459:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010445c:	eb 3f                	jmp    8010449d <piperead+0x57>
    if(proc->killed){
8010445e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104464:	8b 40 24             	mov    0x24(%eax),%eax
80104467:	85 c0                	test   %eax,%eax
80104469:	74 19                	je     80104484 <piperead+0x3e>
      release(&p->lock);
8010446b:	8b 45 08             	mov    0x8(%ebp),%eax
8010446e:	83 ec 0c             	sub    $0xc,%esp
80104471:	50                   	push   %eax
80104472:	e8 de 10 00 00       	call   80105555 <release>
80104477:	83 c4 10             	add    $0x10,%esp
      return -1;
8010447a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010447f:	e9 be 00 00 00       	jmp    80104542 <piperead+0xfc>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104484:	8b 45 08             	mov    0x8(%ebp),%eax
80104487:	8b 55 08             	mov    0x8(%ebp),%edx
8010448a:	81 c2 34 02 00 00    	add    $0x234,%edx
80104490:	83 ec 08             	sub    $0x8,%esp
80104493:	50                   	push   %eax
80104494:	52                   	push   %edx
80104495:	e8 70 09 00 00       	call   80104e0a <sleep>
8010449a:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010449d:	8b 45 08             	mov    0x8(%ebp),%eax
801044a0:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801044a6:	8b 45 08             	mov    0x8(%ebp),%eax
801044a9:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801044af:	39 c2                	cmp    %eax,%edx
801044b1:	75 0d                	jne    801044c0 <piperead+0x7a>
801044b3:	8b 45 08             	mov    0x8(%ebp),%eax
801044b6:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801044bc:	85 c0                	test   %eax,%eax
801044be:	75 9e                	jne    8010445e <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801044c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801044c7:	eb 4b                	jmp    80104514 <piperead+0xce>
    if(p->nread == p->nwrite)
801044c9:	8b 45 08             	mov    0x8(%ebp),%eax
801044cc:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801044d2:	8b 45 08             	mov    0x8(%ebp),%eax
801044d5:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801044db:	39 c2                	cmp    %eax,%edx
801044dd:	75 02                	jne    801044e1 <piperead+0x9b>
      break;
801044df:	eb 3b                	jmp    8010451c <piperead+0xd6>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801044e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801044e7:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801044ea:	8b 45 08             	mov    0x8(%ebp),%eax
801044ed:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801044f3:	8d 48 01             	lea    0x1(%eax),%ecx
801044f6:	8b 55 08             	mov    0x8(%ebp),%edx
801044f9:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801044ff:	25 ff 01 00 00       	and    $0x1ff,%eax
80104504:	89 c2                	mov    %eax,%edx
80104506:	8b 45 08             	mov    0x8(%ebp),%eax
80104509:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
8010450e:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104510:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104514:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104517:	3b 45 10             	cmp    0x10(%ebp),%eax
8010451a:	7c ad                	jl     801044c9 <piperead+0x83>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010451c:	8b 45 08             	mov    0x8(%ebp),%eax
8010451f:	05 38 02 00 00       	add    $0x238,%eax
80104524:	83 ec 0c             	sub    $0xc,%esp
80104527:	50                   	push   %eax
80104528:	e8 c6 09 00 00       	call   80104ef3 <wakeup>
8010452d:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104530:	8b 45 08             	mov    0x8(%ebp),%eax
80104533:	83 ec 0c             	sub    $0xc,%esp
80104536:	50                   	push   %eax
80104537:	e8 19 10 00 00       	call   80105555 <release>
8010453c:	83 c4 10             	add    $0x10,%esp
  return i;
8010453f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104542:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104545:	c9                   	leave  
80104546:	c3                   	ret    

80104547 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104547:	55                   	push   %ebp
80104548:	89 e5                	mov    %esp,%ebp
8010454a:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010454d:	9c                   	pushf  
8010454e:	58                   	pop    %eax
8010454f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104552:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104555:	c9                   	leave  
80104556:	c3                   	ret    

80104557 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104557:	55                   	push   %ebp
80104558:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010455a:	fb                   	sti    
}
8010455b:	5d                   	pop    %ebp
8010455c:	c3                   	ret    

8010455d <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
8010455d:	55                   	push   %ebp
8010455e:	89 e5                	mov    %esp,%ebp
80104560:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
80104563:	83 ec 08             	sub    $0x8,%esp
80104566:	68 ec 91 10 80       	push   $0x801091ec
8010456b:	68 80 3a 11 80       	push   $0x80113a80
80104570:	e8 59 0f 00 00       	call   801054ce <initlock>
80104575:	83 c4 10             	add    $0x10,%esp
}
80104578:	c9                   	leave  
80104579:	c3                   	ret    

8010457a <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc* 
allocproc(void)
{
8010457a:	55                   	push   %ebp
8010457b:	89 e5                	mov    %esp,%ebp
8010457d:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104580:	83 ec 0c             	sub    $0xc,%esp
80104583:	68 80 3a 11 80       	push   $0x80113a80
80104588:	e8 62 0f 00 00       	call   801054ef <acquire>
8010458d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104590:	c7 45 f4 b4 3a 11 80 	movl   $0x80113ab4,-0xc(%ebp)
80104597:	eb 56                	jmp    801045ef <allocproc+0x75>
    if(p->state == UNUSED)
80104599:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010459c:	8b 40 0c             	mov    0xc(%eax),%eax
8010459f:	85 c0                	test   %eax,%eax
801045a1:	75 48                	jne    801045eb <allocproc+0x71>
      goto found;
801045a3:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801045a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a7:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
801045ae:	a1 00 c0 10 80       	mov    0x8010c000,%eax
801045b3:	8d 50 01             	lea    0x1(%eax),%edx
801045b6:	89 15 00 c0 10 80    	mov    %edx,0x8010c000
801045bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045bf:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
801045c2:	83 ec 0c             	sub    $0xc,%esp
801045c5:	68 80 3a 11 80       	push   $0x80113a80
801045ca:	e8 86 0f 00 00       	call   80105555 <release>
801045cf:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801045d2:	e8 1a e9 ff ff       	call   80102ef1 <kalloc>
801045d7:	89 c2                	mov    %eax,%edx
801045d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045dc:	89 50 08             	mov    %edx,0x8(%eax)
801045df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e2:	8b 40 08             	mov    0x8(%eax),%eax
801045e5:	85 c0                	test   %eax,%eax
801045e7:	75 37                	jne    80104620 <allocproc+0xa6>
801045e9:	eb 24                	jmp    8010460f <allocproc+0x95>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045eb:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801045ef:	81 7d f4 b4 59 11 80 	cmpl   $0x801159b4,-0xc(%ebp)
801045f6:	72 a1                	jb     80104599 <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
801045f8:	83 ec 0c             	sub    $0xc,%esp
801045fb:	68 80 3a 11 80       	push   $0x80113a80
80104600:	e8 50 0f 00 00       	call   80105555 <release>
80104605:	83 c4 10             	add    $0x10,%esp
  return 0;
80104608:	b8 00 00 00 00       	mov    $0x0,%eax
8010460d:	eb 6e                	jmp    8010467d <allocproc+0x103>
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010460f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104612:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104619:	b8 00 00 00 00       	mov    $0x0,%eax
8010461e:	eb 5d                	jmp    8010467d <allocproc+0x103>
  }
  sp = p->kstack + KSTACKSIZE;
80104620:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104623:	8b 40 08             	mov    0x8(%eax),%eax
80104626:	05 00 10 00 00       	add    $0x1000,%eax
8010462b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010462e:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104632:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104635:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104638:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
8010463b:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
8010463f:	ba db 6e 10 80       	mov    $0x80106edb,%edx
80104644:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104647:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104649:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
8010464d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104650:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104653:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104656:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104659:	8b 40 1c             	mov    0x1c(%eax),%eax
8010465c:	83 ec 04             	sub    $0x4,%esp
8010465f:	6a 14                	push   $0x14
80104661:	6a 00                	push   $0x0
80104663:	50                   	push   %eax
80104664:	e8 fc 10 00 00       	call   80105765 <memset>
80104669:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010466c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010466f:	8b 40 1c             	mov    0x1c(%eax),%eax
80104672:	ba c5 4d 10 80       	mov    $0x80104dc5,%edx
80104677:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
8010467a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010467d:	c9                   	leave  
8010467e:	c3                   	ret    

8010467f <userinit>:
//20160313--
//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
8010467f:	55                   	push   %ebp
80104680:	89 e5                	mov    %esp,%ebp
80104682:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
80104685:	e8 f0 fe ff ff       	call   8010457a <allocproc>
8010468a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
8010468d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104690:	a3 68 c6 10 80       	mov    %eax,0x8010c668
  if((p->pgdir = setupkvm()) == 0)
80104695:	e8 fa 3e 00 00       	call   80108594 <setupkvm>
8010469a:	89 c2                	mov    %eax,%edx
8010469c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010469f:	89 50 04             	mov    %edx,0x4(%eax)
801046a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a5:	8b 40 04             	mov    0x4(%eax),%eax
801046a8:	85 c0                	test   %eax,%eax
801046aa:	75 0d                	jne    801046b9 <userinit+0x3a>
    panic("userinit: out of memory?");
801046ac:	83 ec 0c             	sub    $0xc,%esp
801046af:	68 f3 91 10 80       	push   $0x801091f3
801046b4:	e8 ea be ff ff       	call   801005a3 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801046b9:	ba 2c 00 00 00       	mov    $0x2c,%edx
801046be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c1:	8b 40 04             	mov    0x4(%eax),%eax
801046c4:	83 ec 04             	sub    $0x4,%esp
801046c7:	52                   	push   %edx
801046c8:	68 00 c5 10 80       	push   $0x8010c500
801046cd:	50                   	push   %eax
801046ce:	e8 18 41 00 00       	call   801087eb <inituvm>
801046d3:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
801046d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d9:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801046df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e2:	8b 40 18             	mov    0x18(%eax),%eax
801046e5:	83 ec 04             	sub    $0x4,%esp
801046e8:	6a 4c                	push   $0x4c
801046ea:	6a 00                	push   $0x0
801046ec:	50                   	push   %eax
801046ed:	e8 73 10 00 00       	call   80105765 <memset>
801046f2:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801046f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f8:	8b 40 18             	mov    0x18(%eax),%eax
801046fb:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104701:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104704:	8b 40 18             	mov    0x18(%eax),%eax
80104707:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010470d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104710:	8b 40 18             	mov    0x18(%eax),%eax
80104713:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104716:	8b 52 18             	mov    0x18(%edx),%edx
80104719:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010471d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104721:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104724:	8b 40 18             	mov    0x18(%eax),%eax
80104727:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010472a:	8b 52 18             	mov    0x18(%edx),%edx
8010472d:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104731:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104735:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104738:	8b 40 18             	mov    0x18(%eax),%eax
8010473b:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104742:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104745:	8b 40 18             	mov    0x18(%eax),%eax
80104748:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010474f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104752:	8b 40 18             	mov    0x18(%eax),%eax
80104755:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010475c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010475f:	83 c0 6c             	add    $0x6c,%eax
80104762:	83 ec 04             	sub    $0x4,%esp
80104765:	6a 10                	push   $0x10
80104767:	68 0c 92 10 80       	push   $0x8010920c
8010476c:	50                   	push   %eax
8010476d:	e8 f8 11 00 00       	call   8010596a <safestrcpy>
80104772:	83 c4 10             	add    $0x10,%esp
//20160313--
  p->cwd = namei("/");
80104775:	83 ec 0c             	sub    $0xc,%esp
80104778:	68 15 92 10 80       	push   $0x80109215
8010477d:	e8 32 de ff ff       	call   801025b4 <namei>
80104782:	83 c4 10             	add    $0x10,%esp
80104785:	89 c2                	mov    %eax,%edx
80104787:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010478a:	89 50 68             	mov    %edx,0x68(%eax)
  p->state = RUNNABLE;
8010478d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104790:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
80104797:	c9                   	leave  
80104798:	c3                   	ret    

80104799 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104799:	55                   	push   %ebp
8010479a:	89 e5                	mov    %esp,%ebp
8010479c:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
8010479f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047a5:	8b 00                	mov    (%eax),%eax
801047a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801047aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801047ae:	7e 31                	jle    801047e1 <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801047b0:	8b 55 08             	mov    0x8(%ebp),%edx
801047b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b6:	01 c2                	add    %eax,%edx
801047b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047be:	8b 40 04             	mov    0x4(%eax),%eax
801047c1:	83 ec 04             	sub    $0x4,%esp
801047c4:	52                   	push   %edx
801047c5:	ff 75 f4             	pushl  -0xc(%ebp)
801047c8:	50                   	push   %eax
801047c9:	e8 69 41 00 00       	call   80108937 <allocuvm>
801047ce:	83 c4 10             	add    $0x10,%esp
801047d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801047d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801047d8:	75 3e                	jne    80104818 <growproc+0x7f>
      return -1;
801047da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047df:	eb 59                	jmp    8010483a <growproc+0xa1>
  } else if(n < 0){
801047e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801047e5:	79 31                	jns    80104818 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801047e7:	8b 55 08             	mov    0x8(%ebp),%edx
801047ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ed:	01 c2                	add    %eax,%edx
801047ef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047f5:	8b 40 04             	mov    0x4(%eax),%eax
801047f8:	83 ec 04             	sub    $0x4,%esp
801047fb:	52                   	push   %edx
801047fc:	ff 75 f4             	pushl  -0xc(%ebp)
801047ff:	50                   	push   %eax
80104800:	e8 fb 41 00 00       	call   80108a00 <deallocuvm>
80104805:	83 c4 10             	add    $0x10,%esp
80104808:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010480b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010480f:	75 07                	jne    80104818 <growproc+0x7f>
      return -1;
80104811:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104816:	eb 22                	jmp    8010483a <growproc+0xa1>
  }
  proc->sz = sz;
80104818:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010481e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104821:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104823:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104829:	83 ec 0c             	sub    $0xc,%esp
8010482c:	50                   	push   %eax
8010482d:	e8 47 3e 00 00       	call   80108679 <switchuvm>
80104832:	83 c4 10             	add    $0x10,%esp
  return 0;
80104835:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010483a:	c9                   	leave  
8010483b:	c3                   	ret    

8010483c <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
8010483c:	55                   	push   %ebp
8010483d:	89 e5                	mov    %esp,%ebp
8010483f:	57                   	push   %edi
80104840:	56                   	push   %esi
80104841:	53                   	push   %ebx
80104842:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104845:	e8 30 fd ff ff       	call   8010457a <allocproc>
8010484a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010484d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104851:	75 0a                	jne    8010485d <fork+0x21>
    return -1;
80104853:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104858:	e9 68 01 00 00       	jmp    801049c5 <fork+0x189>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
8010485d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104863:	8b 10                	mov    (%eax),%edx
80104865:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010486b:	8b 40 04             	mov    0x4(%eax),%eax
8010486e:	83 ec 08             	sub    $0x8,%esp
80104871:	52                   	push   %edx
80104872:	50                   	push   %eax
80104873:	e8 24 43 00 00       	call   80108b9c <copyuvm>
80104878:	83 c4 10             	add    $0x10,%esp
8010487b:	89 c2                	mov    %eax,%edx
8010487d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104880:	89 50 04             	mov    %edx,0x4(%eax)
80104883:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104886:	8b 40 04             	mov    0x4(%eax),%eax
80104889:	85 c0                	test   %eax,%eax
8010488b:	75 30                	jne    801048bd <fork+0x81>
    kfree(np->kstack);
8010488d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104890:	8b 40 08             	mov    0x8(%eax),%eax
80104893:	83 ec 0c             	sub    $0xc,%esp
80104896:	50                   	push   %eax
80104897:	e8 b9 e5 ff ff       	call   80102e55 <kfree>
8010489c:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
8010489f:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801048a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048ac:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
801048b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048b8:	e9 08 01 00 00       	jmp    801049c5 <fork+0x189>
  }
  np->sz = proc->sz;
801048bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048c3:	8b 10                	mov    (%eax),%edx
801048c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048c8:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
801048ca:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801048d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048d4:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
801048d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048da:	8b 50 18             	mov    0x18(%eax),%edx
801048dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048e3:	8b 40 18             	mov    0x18(%eax),%eax
801048e6:	89 c3                	mov    %eax,%ebx
801048e8:	b8 13 00 00 00       	mov    $0x13,%eax
801048ed:	89 d7                	mov    %edx,%edi
801048ef:	89 de                	mov    %ebx,%esi
801048f1:	89 c1                	mov    %eax,%ecx
801048f3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801048f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048f8:	8b 40 18             	mov    0x18(%eax),%eax
801048fb:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104902:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104909:	eb 43                	jmp    8010494e <fork+0x112>
    if(proc->ofile[i])
8010490b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104911:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104914:	83 c2 08             	add    $0x8,%edx
80104917:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010491b:	85 c0                	test   %eax,%eax
8010491d:	74 2b                	je     8010494a <fork+0x10e>
      np->ofile[i] = filedup(proc->ofile[i]);
8010491f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104925:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104928:	83 c2 08             	add    $0x8,%edx
8010492b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010492f:	83 ec 0c             	sub    $0xc,%esp
80104932:	50                   	push   %eax
80104933:	e8 d6 c6 ff ff       	call   8010100e <filedup>
80104938:	83 c4 10             	add    $0x10,%esp
8010493b:	89 c1                	mov    %eax,%ecx
8010493d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104940:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104943:	83 c2 08             	add    $0x8,%edx
80104946:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010494a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010494e:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104952:	7e b7                	jle    8010490b <fork+0xcf>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
//20160313--
  np->cwd = idup(proc->cwd);
80104954:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010495a:	8b 40 68             	mov    0x68(%eax),%eax
8010495d:	83 ec 0c             	sub    $0xc,%esp
80104960:	50                   	push   %eax
80104961:	e8 eb cf ff ff       	call   80101951 <idup>
80104966:	83 c4 10             	add    $0x10,%esp
80104969:	89 c2                	mov    %eax,%edx
8010496b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010496e:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104971:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104977:	8d 50 6c             	lea    0x6c(%eax),%edx
8010497a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010497d:	83 c0 6c             	add    $0x6c,%eax
80104980:	83 ec 04             	sub    $0x4,%esp
80104983:	6a 10                	push   $0x10
80104985:	52                   	push   %edx
80104986:	50                   	push   %eax
80104987:	e8 de 0f 00 00       	call   8010596a <safestrcpy>
8010498c:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
8010498f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104992:	8b 40 10             	mov    0x10(%eax),%eax
80104995:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104998:	83 ec 0c             	sub    $0xc,%esp
8010499b:	68 80 3a 11 80       	push   $0x80113a80
801049a0:	e8 4a 0b 00 00       	call   801054ef <acquire>
801049a5:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
801049a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049ab:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
801049b2:	83 ec 0c             	sub    $0xc,%esp
801049b5:	68 80 3a 11 80       	push   $0x80113a80
801049ba:	e8 96 0b 00 00       	call   80105555 <release>
801049bf:	83 c4 10             	add    $0x10,%esp
  
  return pid;
801049c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801049c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049c8:	5b                   	pop    %ebx
801049c9:	5e                   	pop    %esi
801049ca:	5f                   	pop    %edi
801049cb:	5d                   	pop    %ebp
801049cc:	c3                   	ret    

801049cd <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
801049cd:	55                   	push   %ebp
801049ce:	89 e5                	mov    %esp,%ebp
801049d0:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

//2016.04.20
  if(proc == initproc){
801049d3:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801049da:	a1 68 c6 10 80       	mov    0x8010c668,%eax
801049df:	39 c2                	cmp    %eax,%edx
801049e1:	75 10                	jne    801049f3 <exit+0x26>
//    panic("init exiting");
    cprintf("Ahora hay que cambiar el planificador. En scheduler() \
801049e3:	83 ec 0c             	sub    $0xc,%esp
801049e6:	68 18 92 10 80       	push   $0x80109218
801049eb:	e8 16 ba ff ff       	call   80100406 <cprintf>
801049f0:	83 c4 10             	add    $0x10,%esp
o sched()? creo que en scheduler().");
  }

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801049f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801049fa:	eb 48                	jmp    80104a44 <exit+0x77>
    if(proc->ofile[fd]){
801049fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a02:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a05:	83 c2 08             	add    $0x8,%edx
80104a08:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a0c:	85 c0                	test   %eax,%eax
80104a0e:	74 30                	je     80104a40 <exit+0x73>
      fileclose(proc->ofile[fd]);
80104a10:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a16:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a19:	83 c2 08             	add    $0x8,%edx
80104a1c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a20:	83 ec 0c             	sub    $0xc,%esp
80104a23:	50                   	push   %eax
80104a24:	e8 36 c6 ff ff       	call   8010105f <fileclose>
80104a29:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104a2c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a32:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a35:	83 c2 08             	add    $0x8,%edx
80104a38:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104a3f:	00 
    cprintf("Ahora hay que cambiar el planificador. En scheduler() \
o sched()? creo que en scheduler().");
  }

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104a40:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104a44:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104a48:	7e b2                	jle    801049fc <exit+0x2f>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104a4a:	e8 2f ee ff ff       	call   8010387e <begin_op>
  iput(proc->cwd);
80104a4f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a55:	8b 40 68             	mov    0x68(%eax),%eax
80104a58:	83 ec 0c             	sub    $0xc,%esp
80104a5b:	50                   	push   %eax
80104a5c:	e8 20 d1 ff ff       	call   80101b81 <iput>
80104a61:	83 c4 10             	add    $0x10,%esp
  end_op();
80104a64:	e8 a3 ee ff ff       	call   8010390c <end_op>
  proc->cwd = 0;
80104a69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a6f:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104a76:	83 ec 0c             	sub    $0xc,%esp
80104a79:	68 80 3a 11 80       	push   $0x80113a80
80104a7e:	e8 6c 0a 00 00       	call   801054ef <acquire>
80104a83:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104a86:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a8c:	8b 40 14             	mov    0x14(%eax),%eax
80104a8f:	83 ec 0c             	sub    $0xc,%esp
80104a92:	50                   	push   %eax
80104a93:	e8 1d 04 00 00       	call   80104eb5 <wakeup1>
80104a98:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a9b:	c7 45 f4 b4 3a 11 80 	movl   $0x80113ab4,-0xc(%ebp)
80104aa2:	eb 3c                	jmp    80104ae0 <exit+0x113>
    if(p->parent == proc){
80104aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa7:	8b 50 14             	mov    0x14(%eax),%edx
80104aaa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ab0:	39 c2                	cmp    %eax,%edx
80104ab2:	75 28                	jne    80104adc <exit+0x10f>
      p->parent = initproc;
80104ab4:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80104aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104abd:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac3:	8b 40 0c             	mov    0xc(%eax),%eax
80104ac6:	83 f8 05             	cmp    $0x5,%eax
80104ac9:	75 11                	jne    80104adc <exit+0x10f>
        wakeup1(initproc);
80104acb:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104ad0:	83 ec 0c             	sub    $0xc,%esp
80104ad3:	50                   	push   %eax
80104ad4:	e8 dc 03 00 00       	call   80104eb5 <wakeup1>
80104ad9:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104adc:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104ae0:	81 7d f4 b4 59 11 80 	cmpl   $0x801159b4,-0xc(%ebp)
80104ae7:	72 bb                	jb     80104aa4 <exit+0xd7>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104ae9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aef:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104af6:	e8 d5 01 00 00       	call   80104cd0 <sched>
  panic("zombie exit");
80104afb:	83 ec 0c             	sub    $0xc,%esp
80104afe:	68 72 92 10 80       	push   $0x80109272
80104b03:	e8 9b ba ff ff       	call   801005a3 <panic>

80104b08 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104b08:	55                   	push   %ebp
80104b09:	89 e5                	mov    %esp,%ebp
80104b0b:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104b0e:	83 ec 0c             	sub    $0xc,%esp
80104b11:	68 80 3a 11 80       	push   $0x80113a80
80104b16:	e8 d4 09 00 00       	call   801054ef <acquire>
80104b1b:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104b1e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b25:	c7 45 f4 b4 3a 11 80 	movl   $0x80113ab4,-0xc(%ebp)
80104b2c:	e9 a6 00 00 00       	jmp    80104bd7 <wait+0xcf>
      if(p->parent != proc)
80104b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b34:	8b 50 14             	mov    0x14(%eax),%edx
80104b37:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b3d:	39 c2                	cmp    %eax,%edx
80104b3f:	74 05                	je     80104b46 <wait+0x3e>
        continue;
80104b41:	e9 8d 00 00 00       	jmp    80104bd3 <wait+0xcb>
      havekids = 1;
80104b46:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b50:	8b 40 0c             	mov    0xc(%eax),%eax
80104b53:	83 f8 05             	cmp    $0x5,%eax
80104b56:	75 7b                	jne    80104bd3 <wait+0xcb>
        // Found one.
        pid = p->pid;
80104b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b5b:	8b 40 10             	mov    0x10(%eax),%eax
80104b5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b64:	8b 40 08             	mov    0x8(%eax),%eax
80104b67:	83 ec 0c             	sub    $0xc,%esp
80104b6a:	50                   	push   %eax
80104b6b:	e8 e5 e2 ff ff       	call   80102e55 <kfree>
80104b70:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b76:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b80:	8b 40 04             	mov    0x4(%eax),%eax
80104b83:	83 ec 0c             	sub    $0xc,%esp
80104b86:	50                   	push   %eax
80104b87:	e8 31 3f 00 00       	call   80108abd <freevm>
80104b8c:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b92:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b9c:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba6:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb0:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb7:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104bbe:	83 ec 0c             	sub    $0xc,%esp
80104bc1:	68 80 3a 11 80       	push   $0x80113a80
80104bc6:	e8 8a 09 00 00       	call   80105555 <release>
80104bcb:	83 c4 10             	add    $0x10,%esp
        return pid;
80104bce:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104bd1:	eb 57                	jmp    80104c2a <wait+0x122>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bd3:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104bd7:	81 7d f4 b4 59 11 80 	cmpl   $0x801159b4,-0xc(%ebp)
80104bde:	0f 82 4d ff ff ff    	jb     80104b31 <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104be4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104be8:	74 0d                	je     80104bf7 <wait+0xef>
80104bea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bf0:	8b 40 24             	mov    0x24(%eax),%eax
80104bf3:	85 c0                	test   %eax,%eax
80104bf5:	74 17                	je     80104c0e <wait+0x106>
      release(&ptable.lock);
80104bf7:	83 ec 0c             	sub    $0xc,%esp
80104bfa:	68 80 3a 11 80       	push   $0x80113a80
80104bff:	e8 51 09 00 00       	call   80105555 <release>
80104c04:	83 c4 10             	add    $0x10,%esp
      return -1;
80104c07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c0c:	eb 1c                	jmp    80104c2a <wait+0x122>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104c0e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c14:	83 ec 08             	sub    $0x8,%esp
80104c17:	68 80 3a 11 80       	push   $0x80113a80
80104c1c:	50                   	push   %eax
80104c1d:	e8 e8 01 00 00       	call   80104e0a <sleep>
80104c22:	83 c4 10             	add    $0x10,%esp
  }
80104c25:	e9 f4 fe ff ff       	jmp    80104b1e <wait+0x16>
}
80104c2a:	c9                   	leave  
80104c2b:	c3                   	ret    

80104c2c <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104c2c:	55                   	push   %ebp
80104c2d:	89 e5                	mov    %esp,%ebp
80104c2f:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104c32:	e8 20 f9 ff ff       	call   80104557 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104c37:	83 ec 0c             	sub    $0xc,%esp
80104c3a:	68 80 3a 11 80       	push   $0x80113a80
80104c3f:	e8 ab 08 00 00       	call   801054ef <acquire>
80104c44:	83 c4 10             	add    $0x10,%esp
    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c47:	c7 45 f4 b4 3a 11 80 	movl   $0x80113ab4,-0xc(%ebp)
80104c4e:	eb 62                	jmp    80104cb2 <scheduler+0x86>
      if(p->state != RUNNABLE)
80104c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c53:	8b 40 0c             	mov    0xc(%eax),%eax
80104c56:	83 f8 03             	cmp    $0x3,%eax
80104c59:	74 02                	je     80104c5d <scheduler+0x31>
        continue;
80104c5b:	eb 51                	jmp    80104cae <scheduler+0x82>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c60:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104c66:	83 ec 0c             	sub    $0xc,%esp
80104c69:	ff 75 f4             	pushl  -0xc(%ebp)
80104c6c:	e8 08 3a 00 00       	call   80108679 <switchuvm>
80104c71:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c77:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104c7e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c84:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c87:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104c8e:	83 c2 04             	add    $0x4,%edx
80104c91:	83 ec 08             	sub    $0x8,%esp
80104c94:	50                   	push   %eax
80104c95:	52                   	push   %edx
80104c96:	e8 66 0a 00 00       	call   80105701 <swtch>
80104c9b:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104c9e:	e8 ba 39 00 00       	call   8010865d <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104ca3:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104caa:	00 00 00 00 
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cae:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104cb2:	81 7d f4 b4 59 11 80 	cmpl   $0x801159b4,-0xc(%ebp)
80104cb9:	72 95                	jb     80104c50 <scheduler+0x24>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104cbb:	83 ec 0c             	sub    $0xc,%esp
80104cbe:	68 80 3a 11 80       	push   $0x80113a80
80104cc3:	e8 8d 08 00 00       	call   80105555 <release>
80104cc8:	83 c4 10             	add    $0x10,%esp

  }
80104ccb:	e9 62 ff ff ff       	jmp    80104c32 <scheduler+0x6>

80104cd0 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104cd6:	83 ec 0c             	sub    $0xc,%esp
80104cd9:	68 80 3a 11 80       	push   $0x80113a80
80104cde:	e8 3c 09 00 00       	call   8010561f <holding>
80104ce3:	83 c4 10             	add    $0x10,%esp
80104ce6:	85 c0                	test   %eax,%eax
80104ce8:	75 0d                	jne    80104cf7 <sched+0x27>
    panic("sched ptable.lock");
80104cea:	83 ec 0c             	sub    $0xc,%esp
80104ced:	68 7e 92 10 80       	push   $0x8010927e
80104cf2:	e8 ac b8 ff ff       	call   801005a3 <panic>
  if(cpu->ncli != 1)
80104cf7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104cfd:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104d03:	83 f8 01             	cmp    $0x1,%eax
80104d06:	74 0d                	je     80104d15 <sched+0x45>
    panic("sched locks");
80104d08:	83 ec 0c             	sub    $0xc,%esp
80104d0b:	68 90 92 10 80       	push   $0x80109290
80104d10:	e8 8e b8 ff ff       	call   801005a3 <panic>
  if(proc->state == RUNNING)
80104d15:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d1b:	8b 40 0c             	mov    0xc(%eax),%eax
80104d1e:	83 f8 04             	cmp    $0x4,%eax
80104d21:	75 0d                	jne    80104d30 <sched+0x60>
    panic("sched running");
80104d23:	83 ec 0c             	sub    $0xc,%esp
80104d26:	68 9c 92 10 80       	push   $0x8010929c
80104d2b:	e8 73 b8 ff ff       	call   801005a3 <panic>
  if(readeflags()&FL_IF)
80104d30:	e8 12 f8 ff ff       	call   80104547 <readeflags>
80104d35:	25 00 02 00 00       	and    $0x200,%eax
80104d3a:	85 c0                	test   %eax,%eax
80104d3c:	74 0d                	je     80104d4b <sched+0x7b>
    panic("sched interruptible");
80104d3e:	83 ec 0c             	sub    $0xc,%esp
80104d41:	68 aa 92 10 80       	push   $0x801092aa
80104d46:	e8 58 b8 ff ff       	call   801005a3 <panic>
  intena = cpu->intena;
80104d4b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d51:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104d57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104d5a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d60:	8b 40 04             	mov    0x4(%eax),%eax
80104d63:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104d6a:	83 c2 1c             	add    $0x1c,%edx
80104d6d:	83 ec 08             	sub    $0x8,%esp
80104d70:	50                   	push   %eax
80104d71:	52                   	push   %edx
80104d72:	e8 8a 09 00 00       	call   80105701 <swtch>
80104d77:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104d7a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d80:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d83:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104d89:	c9                   	leave  
80104d8a:	c3                   	ret    

80104d8b <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104d8b:	55                   	push   %ebp
80104d8c:	89 e5                	mov    %esp,%ebp
80104d8e:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104d91:	83 ec 0c             	sub    $0xc,%esp
80104d94:	68 80 3a 11 80       	push   $0x80113a80
80104d99:	e8 51 07 00 00       	call   801054ef <acquire>
80104d9e:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104da1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104da7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104dae:	e8 1d ff ff ff       	call   80104cd0 <sched>
  release(&ptable.lock);
80104db3:	83 ec 0c             	sub    $0xc,%esp
80104db6:	68 80 3a 11 80       	push   $0x80113a80
80104dbb:	e8 95 07 00 00       	call   80105555 <release>
80104dc0:	83 c4 10             	add    $0x10,%esp
}
80104dc3:	c9                   	leave  
80104dc4:	c3                   	ret    

80104dc5 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104dc5:	55                   	push   %ebp
80104dc6:	89 e5                	mov    %esp,%ebp
80104dc8:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104dcb:	83 ec 0c             	sub    $0xc,%esp
80104dce:	68 80 3a 11 80       	push   $0x80113a80
80104dd3:	e8 7d 07 00 00       	call   80105555 <release>
80104dd8:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104ddb:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104de0:	85 c0                	test   %eax,%eax
80104de2:	74 24                	je     80104e08 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104de4:	c7 05 04 c0 10 80 00 	movl   $0x0,0x8010c004
80104deb:	00 00 00 
//20160313--
    iinit(ROOTDEV);
80104dee:	83 ec 0c             	sub    $0xc,%esp
80104df1:	6a 01                	push   $0x1
80104df3:	e8 42 c8 ff ff       	call   8010163a <iinit>
80104df8:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104dfb:	83 ec 0c             	sub    $0xc,%esp
80104dfe:	6a 01                	push   $0x1
80104e00:	e8 60 e8 ff ff       	call   80103665 <initlog>
80104e05:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104e08:	c9                   	leave  
80104e09:	c3                   	ret    

80104e0a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104e0a:	55                   	push   %ebp
80104e0b:	89 e5                	mov    %esp,%ebp
80104e0d:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104e10:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e16:	85 c0                	test   %eax,%eax
80104e18:	75 0d                	jne    80104e27 <sleep+0x1d>
    panic("sleep");
80104e1a:	83 ec 0c             	sub    $0xc,%esp
80104e1d:	68 be 92 10 80       	push   $0x801092be
80104e22:	e8 7c b7 ff ff       	call   801005a3 <panic>

  if(lk == 0)
80104e27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104e2b:	75 0d                	jne    80104e3a <sleep+0x30>
    panic("sleep without lk");
80104e2d:	83 ec 0c             	sub    $0xc,%esp
80104e30:	68 c4 92 10 80       	push   $0x801092c4
80104e35:	e8 69 b7 ff ff       	call   801005a3 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104e3a:	81 7d 0c 80 3a 11 80 	cmpl   $0x80113a80,0xc(%ebp)
80104e41:	74 1e                	je     80104e61 <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104e43:	83 ec 0c             	sub    $0xc,%esp
80104e46:	68 80 3a 11 80       	push   $0x80113a80
80104e4b:	e8 9f 06 00 00       	call   801054ef <acquire>
80104e50:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104e53:	83 ec 0c             	sub    $0xc,%esp
80104e56:	ff 75 0c             	pushl  0xc(%ebp)
80104e59:	e8 f7 06 00 00       	call   80105555 <release>
80104e5e:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104e61:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e67:	8b 55 08             	mov    0x8(%ebp),%edx
80104e6a:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104e6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e73:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104e7a:	e8 51 fe ff ff       	call   80104cd0 <sched>

  // Tidy up.
  proc->chan = 0;
80104e7f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e85:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104e8c:	81 7d 0c 80 3a 11 80 	cmpl   $0x80113a80,0xc(%ebp)
80104e93:	74 1e                	je     80104eb3 <sleep+0xa9>
    release(&ptable.lock);
80104e95:	83 ec 0c             	sub    $0xc,%esp
80104e98:	68 80 3a 11 80       	push   $0x80113a80
80104e9d:	e8 b3 06 00 00       	call   80105555 <release>
80104ea2:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104ea5:	83 ec 0c             	sub    $0xc,%esp
80104ea8:	ff 75 0c             	pushl  0xc(%ebp)
80104eab:	e8 3f 06 00 00       	call   801054ef <acquire>
80104eb0:	83 c4 10             	add    $0x10,%esp
  }
}
80104eb3:	c9                   	leave  
80104eb4:	c3                   	ret    

80104eb5 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104eb5:	55                   	push   %ebp
80104eb6:	89 e5                	mov    %esp,%ebp
80104eb8:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ebb:	c7 45 fc b4 3a 11 80 	movl   $0x80113ab4,-0x4(%ebp)
80104ec2:	eb 24                	jmp    80104ee8 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104ec4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ec7:	8b 40 0c             	mov    0xc(%eax),%eax
80104eca:	83 f8 02             	cmp    $0x2,%eax
80104ecd:	75 15                	jne    80104ee4 <wakeup1+0x2f>
80104ecf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ed2:	8b 40 20             	mov    0x20(%eax),%eax
80104ed5:	3b 45 08             	cmp    0x8(%ebp),%eax
80104ed8:	75 0a                	jne    80104ee4 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104eda:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104edd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ee4:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104ee8:	81 7d fc b4 59 11 80 	cmpl   $0x801159b4,-0x4(%ebp)
80104eef:	72 d3                	jb     80104ec4 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104ef1:	c9                   	leave  
80104ef2:	c3                   	ret    

80104ef3 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104ef3:	55                   	push   %ebp
80104ef4:	89 e5                	mov    %esp,%ebp
80104ef6:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104ef9:	83 ec 0c             	sub    $0xc,%esp
80104efc:	68 80 3a 11 80       	push   $0x80113a80
80104f01:	e8 e9 05 00 00       	call   801054ef <acquire>
80104f06:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104f09:	83 ec 0c             	sub    $0xc,%esp
80104f0c:	ff 75 08             	pushl  0x8(%ebp)
80104f0f:	e8 a1 ff ff ff       	call   80104eb5 <wakeup1>
80104f14:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104f17:	83 ec 0c             	sub    $0xc,%esp
80104f1a:	68 80 3a 11 80       	push   $0x80113a80
80104f1f:	e8 31 06 00 00       	call   80105555 <release>
80104f24:	83 c4 10             	add    $0x10,%esp
}
80104f27:	c9                   	leave  
80104f28:	c3                   	ret    

80104f29 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104f29:	55                   	push   %ebp
80104f2a:	89 e5                	mov    %esp,%ebp
80104f2c:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104f2f:	83 ec 0c             	sub    $0xc,%esp
80104f32:	68 80 3a 11 80       	push   $0x80113a80
80104f37:	e8 b3 05 00 00       	call   801054ef <acquire>
80104f3c:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f3f:	c7 45 f4 b4 3a 11 80 	movl   $0x80113ab4,-0xc(%ebp)
80104f46:	eb 45                	jmp    80104f8d <kill+0x64>
    if(p->pid == pid){
80104f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f4b:	8b 40 10             	mov    0x10(%eax),%eax
80104f4e:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f51:	75 36                	jne    80104f89 <kill+0x60>
      p->killed = 1;
80104f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f56:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f60:	8b 40 0c             	mov    0xc(%eax),%eax
80104f63:	83 f8 02             	cmp    $0x2,%eax
80104f66:	75 0a                	jne    80104f72 <kill+0x49>
        p->state = RUNNABLE;
80104f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f6b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104f72:	83 ec 0c             	sub    $0xc,%esp
80104f75:	68 80 3a 11 80       	push   $0x80113a80
80104f7a:	e8 d6 05 00 00       	call   80105555 <release>
80104f7f:	83 c4 10             	add    $0x10,%esp
      return 0;
80104f82:	b8 00 00 00 00       	mov    $0x0,%eax
80104f87:	eb 22                	jmp    80104fab <kill+0x82>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f89:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104f8d:	81 7d f4 b4 59 11 80 	cmpl   $0x801159b4,-0xc(%ebp)
80104f94:	72 b2                	jb     80104f48 <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104f96:	83 ec 0c             	sub    $0xc,%esp
80104f99:	68 80 3a 11 80       	push   $0x80113a80
80104f9e:	e8 b2 05 00 00       	call   80105555 <release>
80104fa3:	83 c4 10             	add    $0x10,%esp
  return -1;
80104fa6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fab:	c9                   	leave  
80104fac:	c3                   	ret    

80104fad <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104fad:	55                   	push   %ebp
80104fae:	89 e5                	mov    %esp,%ebp
80104fb0:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fb3:	c7 45 f0 b4 3a 11 80 	movl   $0x80113ab4,-0x10(%ebp)
80104fba:	e9 d5 00 00 00       	jmp    80105094 <procdump+0xe7>
    if(p->state == UNUSED)
80104fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fc2:	8b 40 0c             	mov    0xc(%eax),%eax
80104fc5:	85 c0                	test   %eax,%eax
80104fc7:	75 05                	jne    80104fce <procdump+0x21>
      continue;
80104fc9:	e9 c2 00 00 00       	jmp    80105090 <procdump+0xe3>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fd1:	8b 40 0c             	mov    0xc(%eax),%eax
80104fd4:	83 f8 05             	cmp    $0x5,%eax
80104fd7:	77 23                	ja     80104ffc <procdump+0x4f>
80104fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fdc:	8b 40 0c             	mov    0xc(%eax),%eax
80104fdf:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104fe6:	85 c0                	test   %eax,%eax
80104fe8:	74 12                	je     80104ffc <procdump+0x4f>
      state = states[p->state];
80104fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fed:	8b 40 0c             	mov    0xc(%eax),%eax
80104ff0:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104ff7:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104ffa:	eb 07                	jmp    80105003 <procdump+0x56>
    else
      state = "???";
80104ffc:	c7 45 ec d5 92 10 80 	movl   $0x801092d5,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80105003:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105006:	8d 50 6c             	lea    0x6c(%eax),%edx
80105009:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010500c:	8b 40 10             	mov    0x10(%eax),%eax
8010500f:	52                   	push   %edx
80105010:	ff 75 ec             	pushl  -0x14(%ebp)
80105013:	50                   	push   %eax
80105014:	68 d9 92 10 80       	push   $0x801092d9
80105019:	e8 e8 b3 ff ff       	call   80100406 <cprintf>
8010501e:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80105021:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105024:	8b 40 0c             	mov    0xc(%eax),%eax
80105027:	83 f8 02             	cmp    $0x2,%eax
8010502a:	75 54                	jne    80105080 <procdump+0xd3>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010502c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010502f:	8b 40 1c             	mov    0x1c(%eax),%eax
80105032:	8b 40 0c             	mov    0xc(%eax),%eax
80105035:	83 c0 08             	add    $0x8,%eax
80105038:	89 c2                	mov    %eax,%edx
8010503a:	83 ec 08             	sub    $0x8,%esp
8010503d:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105040:	50                   	push   %eax
80105041:	52                   	push   %edx
80105042:	e8 5f 05 00 00       	call   801055a6 <getcallerpcs>
80105047:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
8010504a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105051:	eb 1c                	jmp    8010506f <procdump+0xc2>
        cprintf(" %p", pc[i]);
80105053:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105056:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010505a:	83 ec 08             	sub    $0x8,%esp
8010505d:	50                   	push   %eax
8010505e:	68 e2 92 10 80       	push   $0x801092e2
80105063:	e8 9e b3 ff ff       	call   80100406 <cprintf>
80105068:	83 c4 10             	add    $0x10,%esp
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
8010506b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010506f:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105073:	7f 0b                	jg     80105080 <procdump+0xd3>
80105075:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105078:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010507c:	85 c0                	test   %eax,%eax
8010507e:	75 d3                	jne    80105053 <procdump+0xa6>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105080:	83 ec 0c             	sub    $0xc,%esp
80105083:	68 e6 92 10 80       	push   $0x801092e6
80105088:	e8 79 b3 ff ff       	call   80100406 <cprintf>
8010508d:	83 c4 10             	add    $0x10,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105090:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80105094:	81 7d f0 b4 59 11 80 	cmpl   $0x801159b4,-0x10(%ebp)
8010509b:	0f 82 1e ff ff ff    	jb     80104fbf <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801050a1:	c9                   	leave  
801050a2:	c3                   	ret    

801050a3 <candprocs>:

int
candprocs(void)
{
801050a3:	55                   	push   %ebp
801050a4:	89 e5                	mov    %esp,%ebp
801050a6:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int count=0;
801050a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  acquire(&ptable.lock);  /* ptable is a struct defined above */
801050b0:	83 ec 0c             	sub    $0xc,%esp
801050b3:	68 80 3a 11 80       	push   $0x80113a80
801050b8:	e8 32 04 00 00       	call   801054ef <acquire>
801050bd:	83 c4 10             	add    $0x10,%esp
  for(p=ptable.proc;p<ptable.proc+NPROC;p++)
801050c0:	c7 45 f4 b4 3a 11 80 	movl   $0x80113ab4,-0xc(%ebp)
801050c7:	eb 12                	jmp    801050db <candprocs+0x38>
    if(p->state==UNUSED)
801050c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050cc:	8b 40 0c             	mov    0xc(%eax),%eax
801050cf:	85 c0                	test   %eax,%eax
801050d1:	75 04                	jne    801050d7 <candprocs+0x34>
      count++;
801050d3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
candprocs(void)
{
  struct proc *p;
  int count=0;
  acquire(&ptable.lock);  /* ptable is a struct defined above */
  for(p=ptable.proc;p<ptable.proc+NPROC;p++)
801050d7:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801050db:	81 7d f4 b4 59 11 80 	cmpl   $0x801159b4,-0xc(%ebp)
801050e2:	72 e5                	jb     801050c9 <candprocs+0x26>
    if(p->state==UNUSED)
      count++;
  release(&ptable.lock);
801050e4:	83 ec 0c             	sub    $0xc,%esp
801050e7:	68 80 3a 11 80       	push   $0x80113a80
801050ec:	e8 64 04 00 00       	call   80105555 <release>
801050f1:	83 c4 10             	add    $0x10,%esp
  return NPROC-count;
801050f4:	b8 40 00 00 00       	mov    $0x40,%eax
801050f9:	2b 45 f0             	sub    -0x10(%ebp),%eax
}
801050fc:	c9                   	leave  
801050fd:	c3                   	ret    

801050fe <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801050fe:	55                   	push   %ebp
801050ff:	89 e5                	mov    %esp,%ebp
80105101:	83 ec 08             	sub    $0x8,%esp
80105104:	8b 55 08             	mov    0x8(%ebp),%edx
80105107:	8b 45 0c             	mov    0xc(%ebp),%eax
8010510a:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010510e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105111:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80105115:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80105119:	ee                   	out    %al,(%dx)
}
8010511a:	c9                   	leave  
8010511b:	c3                   	ret    

8010511c <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
8010511c:	55                   	push   %ebp
8010511d:	89 e5                	mov    %esp,%ebp
8010511f:	83 ec 04             	sub    $0x4,%esp
80105122:	8b 45 08             	mov    0x8(%ebp),%eax
80105125:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80105129:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010512d:	66 a3 20 c0 10 80    	mov    %ax,0x8010c020
  outb(IO_PIC1+1, mask);
80105133:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80105137:	0f b6 c0             	movzbl %al,%eax
8010513a:	50                   	push   %eax
8010513b:	6a 21                	push   $0x21
8010513d:	e8 bc ff ff ff       	call   801050fe <outb>
80105142:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80105145:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80105149:	66 c1 e8 08          	shr    $0x8,%ax
8010514d:	0f b6 c0             	movzbl %al,%eax
80105150:	50                   	push   %eax
80105151:	68 a1 00 00 00       	push   $0xa1
80105156:	e8 a3 ff ff ff       	call   801050fe <outb>
8010515b:	83 c4 08             	add    $0x8,%esp
}
8010515e:	c9                   	leave  
8010515f:	c3                   	ret    

80105160 <picenable>:

void
picenable(int irq)
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80105163:	8b 45 08             	mov    0x8(%ebp),%eax
80105166:	ba 01 00 00 00       	mov    $0x1,%edx
8010516b:	89 c1                	mov    %eax,%ecx
8010516d:	d3 e2                	shl    %cl,%edx
8010516f:	89 d0                	mov    %edx,%eax
80105171:	f7 d0                	not    %eax
80105173:	89 c2                	mov    %eax,%edx
80105175:	0f b7 05 20 c0 10 80 	movzwl 0x8010c020,%eax
8010517c:	21 d0                	and    %edx,%eax
8010517e:	0f b7 c0             	movzwl %ax,%eax
80105181:	50                   	push   %eax
80105182:	e8 95 ff ff ff       	call   8010511c <picsetmask>
80105187:	83 c4 04             	add    $0x4,%esp
}
8010518a:	c9                   	leave  
8010518b:	c3                   	ret    

8010518c <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
8010518c:	55                   	push   %ebp
8010518d:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
8010518f:	68 ff 00 00 00       	push   $0xff
80105194:	6a 21                	push   $0x21
80105196:	e8 63 ff ff ff       	call   801050fe <outb>
8010519b:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
8010519e:	68 ff 00 00 00       	push   $0xff
801051a3:	68 a1 00 00 00       	push   $0xa1
801051a8:	e8 51 ff ff ff       	call   801050fe <outb>
801051ad:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
801051b0:	6a 11                	push   $0x11
801051b2:	6a 20                	push   $0x20
801051b4:	e8 45 ff ff ff       	call   801050fe <outb>
801051b9:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
801051bc:	6a 20                	push   $0x20
801051be:	6a 21                	push   $0x21
801051c0:	e8 39 ff ff ff       	call   801050fe <outb>
801051c5:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
801051c8:	6a 04                	push   $0x4
801051ca:	6a 21                	push   $0x21
801051cc:	e8 2d ff ff ff       	call   801050fe <outb>
801051d1:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
801051d4:	6a 03                	push   $0x3
801051d6:	6a 21                	push   $0x21
801051d8:	e8 21 ff ff ff       	call   801050fe <outb>
801051dd:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
801051e0:	6a 11                	push   $0x11
801051e2:	68 a0 00 00 00       	push   $0xa0
801051e7:	e8 12 ff ff ff       	call   801050fe <outb>
801051ec:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
801051ef:	6a 28                	push   $0x28
801051f1:	68 a1 00 00 00       	push   $0xa1
801051f6:	e8 03 ff ff ff       	call   801050fe <outb>
801051fb:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
801051fe:	6a 02                	push   $0x2
80105200:	68 a1 00 00 00       	push   $0xa1
80105205:	e8 f4 fe ff ff       	call   801050fe <outb>
8010520a:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
8010520d:	6a 03                	push   $0x3
8010520f:	68 a1 00 00 00       	push   $0xa1
80105214:	e8 e5 fe ff ff       	call   801050fe <outb>
80105219:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
8010521c:	6a 68                	push   $0x68
8010521e:	6a 20                	push   $0x20
80105220:	e8 d9 fe ff ff       	call   801050fe <outb>
80105225:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80105228:	6a 0a                	push   $0xa
8010522a:	6a 20                	push   $0x20
8010522c:	e8 cd fe ff ff       	call   801050fe <outb>
80105231:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80105234:	6a 68                	push   $0x68
80105236:	68 a0 00 00 00       	push   $0xa0
8010523b:	e8 be fe ff ff       	call   801050fe <outb>
80105240:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80105243:	6a 0a                	push   $0xa
80105245:	68 a0 00 00 00       	push   $0xa0
8010524a:	e8 af fe ff ff       	call   801050fe <outb>
8010524f:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80105252:	0f b7 05 20 c0 10 80 	movzwl 0x8010c020,%eax
80105259:	66 83 f8 ff          	cmp    $0xffff,%ax
8010525d:	74 13                	je     80105272 <picinit+0xe6>
    picsetmask(irqmask);
8010525f:	0f b7 05 20 c0 10 80 	movzwl 0x8010c020,%eax
80105266:	0f b7 c0             	movzwl %ax,%eax
80105269:	50                   	push   %eax
8010526a:	e8 ad fe ff ff       	call   8010511c <picsetmask>
8010526f:	83 c4 04             	add    $0x4,%esp
}
80105272:	c9                   	leave  
80105273:	c3                   	ret    

80105274 <scroll>:
uint16_t *Scrn;  /*Screen area*/
int Curx=0,Cury=0;  /*current cursor cordinates*/
uint16_t EmptySpace=COLOURS<<8|0x20; /*0x20 is ascii value of space*/

/*scroll the screen (a 'copy and blank' operation)*/
void scroll(void){
80105274:	55                   	push   %ebp
80105275:	89 e5                	mov    %esp,%ebp
80105277:	83 ec 28             	sub    $0x28,%esp
  int dist=Cury-ROWS+1;
8010527a:	a1 70 c6 10 80       	mov    0x8010c670,%eax
8010527f:	83 e8 18             	sub    $0x18,%eax
80105282:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(dist>0){
80105285:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105289:	0f 8e 91 00 00 00    	jle    80105320 <scroll+0xac>
    uint8_t *newstart=((uint8_t*)Scrn)+dist*COLS*2;
8010528f:	8b 0d b4 5a 11 80    	mov    0x80115ab4,%ecx
80105295:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105298:	89 d0                	mov    %edx,%eax
8010529a:	c1 e0 02             	shl    $0x2,%eax
8010529d:	01 d0                	add    %edx,%eax
8010529f:	c1 e0 05             	shl    $0x5,%eax
801052a2:	01 c8                	add    %ecx,%eax
801052a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int bytesToCopy=(ROWS-dist)*COLS*2;
801052a7:	b8 19 00 00 00       	mov    $0x19,%eax
801052ac:	2b 45 f4             	sub    -0xc(%ebp),%eax
801052af:	89 c2                	mov    %eax,%edx
801052b1:	89 d0                	mov    %edx,%eax
801052b3:	c1 e0 02             	shl    $0x2,%eax
801052b6:	01 d0                	add    %edx,%eax
801052b8:	c1 e0 05             	shl    $0x5,%eax
801052bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    uint16_t *newblankstart=Scrn+(ROWS-dist)*COLS;
801052be:	8b 0d b4 5a 11 80    	mov    0x80115ab4,%ecx
801052c4:	b8 19 00 00 00       	mov    $0x19,%eax
801052c9:	2b 45 f4             	sub    -0xc(%ebp),%eax
801052cc:	89 c2                	mov    %eax,%edx
801052ce:	89 d0                	mov    %edx,%eax
801052d0:	c1 e0 02             	shl    $0x2,%eax
801052d3:	01 d0                	add    %edx,%eax
801052d5:	c1 e0 05             	shl    $0x5,%eax
801052d8:	01 c8                	add    %ecx,%eax
801052da:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int bytesToBlank=dist*COLS*2;
801052dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052e0:	89 d0                	mov    %edx,%eax
801052e2:	c1 e0 02             	shl    $0x2,%eax
801052e5:	01 d0                	add    %edx,%eax
801052e7:	c1 e0 05             	shl    $0x5,%eax
801052ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    memcpy1((uint8_t*)Scrn,newstart,bytesToCopy);
801052ed:	a1 b4 5a 11 80       	mov    0x80115ab4,%eax
801052f2:	83 ec 04             	sub    $0x4,%esp
801052f5:	ff 75 ec             	pushl  -0x14(%ebp)
801052f8:	ff 75 f0             	pushl  -0x10(%ebp)
801052fb:	50                   	push   %eax
801052fc:	e8 88 e8 ff ff       	call   80103b89 <memcpy1>
80105301:	83 c4 10             	add    $0x10,%esp
    memset1((uint8_t*)newblankstart,EmptySpace,bytesToBlank);
80105304:	0f b7 05 22 c0 10 80 	movzwl 0x8010c022,%eax
8010530b:	0f b6 c0             	movzbl %al,%eax
8010530e:	83 ec 04             	sub    $0x4,%esp
80105311:	ff 75 e4             	pushl  -0x1c(%ebp)
80105314:	50                   	push   %eax
80105315:	ff 75 e8             	pushl  -0x18(%ebp)
80105318:	e8 a1 e8 ff ff       	call   80103bbe <memset1>
8010531d:	83 c4 10             	add    $0x10,%esp
  }
}
80105320:	c9                   	leave  
80105321:	c3                   	ret    

80105322 <putchar>:

/*Print a character on the screen*/
void putchar(uint8_t c){
80105322:	55                   	push   %ebp
80105323:	89 e5                	mov    %esp,%ebp
80105325:	83 ec 28             	sub    $0x28,%esp
80105328:	8b 45 08             	mov    0x8(%ebp),%eax
8010532b:	88 45 e4             	mov    %al,-0x1c(%ebp)
  uint16_t *addr;
  
  /*first handle a few special characters*/
  /*tab -> move cursor in steps of 4*/
  if(c=='\t')Curx=((Curx+4)/4)*4;
8010532e:	80 7d e4 09          	cmpb   $0x9,-0x1c(%ebp)
80105332:	75 1e                	jne    80105352 <putchar+0x30>
80105334:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80105339:	83 c0 04             	add    $0x4,%eax
8010533c:	99                   	cltd   
8010533d:	c1 ea 1e             	shr    $0x1e,%edx
80105340:	01 d0                	add    %edx,%eax
80105342:	c1 f8 02             	sar    $0x2,%eax
80105345:	c1 e0 02             	shl    $0x2,%eax
80105348:	a3 6c c6 10 80       	mov    %eax,0x8010c66c
8010534d:	e9 9b 00 00 00       	jmp    801053ed <putchar+0xcb>
  /*carriage return->reset x pos*/
  else if(c=='\r')Curx=0;
80105352:	80 7d e4 0d          	cmpb   $0xd,-0x1c(%ebp)
80105356:	75 0f                	jne    80105367 <putchar+0x45>
80105358:	c7 05 6c c6 10 80 00 	movl   $0x0,0x8010c66c
8010535f:	00 00 00 
80105362:	e9 86 00 00 00       	jmp    801053ed <putchar+0xcb>
  /*newline:reset x pos and go to newline*/
  else if(c=='\n'){
80105367:	80 7d e4 0a          	cmpb   $0xa,-0x1c(%ebp)
8010536b:	75 19                	jne    80105386 <putchar+0x64>
    Curx=0;
8010536d:	c7 05 6c c6 10 80 00 	movl   $0x0,0x8010c66c
80105374:	00 00 00 
    Cury++;
80105377:	a1 70 c6 10 80       	mov    0x8010c670,%eax
8010537c:	83 c0 01             	add    $0x1,%eax
8010537f:	a3 70 c6 10 80       	mov    %eax,0x8010c670
80105384:	eb 67                	jmp    801053ed <putchar+0xcb>
  }
  /*backspace->cursor moves left*/
  else if(c==0x08 && Curx!=0)Curx--;
80105386:	80 7d e4 08          	cmpb   $0x8,-0x1c(%ebp)
8010538a:	75 18                	jne    801053a4 <putchar+0x82>
8010538c:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80105391:	85 c0                	test   %eax,%eax
80105393:	74 0f                	je     801053a4 <putchar+0x82>
80105395:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
8010539a:	83 e8 01             	sub    $0x1,%eax
8010539d:	a3 6c c6 10 80       	mov    %eax,0x8010c66c
801053a2:	eb 49                	jmp    801053ed <putchar+0xcb>
  /*finally, if a normal character, print it*/
  else if(PRINTABLE(c)){
801053a4:	80 7d e4 1f          	cmpb   $0x1f,-0x1c(%ebp)
801053a8:	76 43                	jbe    801053ed <putchar+0xcb>
    addr=Scrn+(Cury*COLS+Curx);
801053aa:	8b 0d b4 5a 11 80    	mov    0x80115ab4,%ecx
801053b0:	8b 15 70 c6 10 80    	mov    0x8010c670,%edx
801053b6:	89 d0                	mov    %edx,%eax
801053b8:	c1 e0 02             	shl    $0x2,%eax
801053bb:	01 d0                	add    %edx,%eax
801053bd:	c1 e0 04             	shl    $0x4,%eax
801053c0:	89 c2                	mov    %eax,%edx
801053c2:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
801053c7:	01 d0                	add    %edx,%eax
801053c9:	01 c0                	add    %eax,%eax
801053cb:	01 c8                	add    %ecx,%eax
801053cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    *addr=(COLOURS<<8)|c;
801053d0:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
801053d4:	66 0d 00 f0          	or     $0xf000,%ax
801053d8:	89 c2                	mov    %eax,%edx
801053da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053dd:	66 89 10             	mov    %dx,(%eax)
    Curx++;
801053e0:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
801053e5:	83 c0 01             	add    $0x1,%eax
801053e8:	a3 6c c6 10 80       	mov    %eax,0x8010c66c
  }
  /*if we have reached the end of the line, move to the next*/
  if(Curx>=COLS){
801053ed:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
801053f2:	83 f8 4f             	cmp    $0x4f,%eax
801053f5:	7e 17                	jle    8010540e <putchar+0xec>
    Curx=0;
801053f7:	c7 05 6c c6 10 80 00 	movl   $0x0,0x8010c66c
801053fe:	00 00 00 
    Cury++;
80105401:	a1 70 c6 10 80       	mov    0x8010c670,%eax
80105406:	83 c0 01             	add    $0x1,%eax
80105409:	a3 70 c6 10 80       	mov    %eax,0x8010c670
  }
  /*also scroll if needed*/
  scroll();
8010540e:	e8 61 fe ff ff       	call   80105274 <scroll>
}
80105413:	c9                   	leave  
80105414:	c3                   	ret    

80105415 <puts>:

/*print a longer string*/
void puts(unsigned char *str){
80105415:	55                   	push   %ebp
80105416:	89 e5                	mov    %esp,%ebp
80105418:	83 ec 08             	sub    $0x8,%esp
  while(*str){putchar(*str); str++;}
8010541b:	eb 19                	jmp    80105436 <puts+0x21>
8010541d:	8b 45 08             	mov    0x8(%ebp),%eax
80105420:	0f b6 00             	movzbl (%eax),%eax
80105423:	0f b6 c0             	movzbl %al,%eax
80105426:	83 ec 0c             	sub    $0xc,%esp
80105429:	50                   	push   %eax
8010542a:	e8 f3 fe ff ff       	call   80105322 <putchar>
8010542f:	83 c4 10             	add    $0x10,%esp
80105432:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105436:	8b 45 08             	mov    0x8(%ebp),%eax
80105439:	0f b6 00             	movzbl (%eax),%eax
8010543c:	84 c0                	test   %al,%al
8010543e:	75 dd                	jne    8010541d <puts+0x8>
}
80105440:	c9                   	leave  
80105441:	c3                   	ret    

80105442 <clear>:

/*clear the screen*/
void clear(){
80105442:	55                   	push   %ebp
80105443:	89 e5                	mov    %esp,%ebp
80105445:	83 ec 18             	sub    $0x18,%esp
  int i;
  for(i=0;i<ROWS*COLS;i++)
80105448:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010544f:	eb 11                	jmp    80105462 <clear+0x20>
    putchar(' ');
80105451:	83 ec 0c             	sub    $0xc,%esp
80105454:	6a 20                	push   $0x20
80105456:	e8 c7 fe ff ff       	call   80105322 <putchar>
8010545b:	83 c4 10             	add    $0x10,%esp
}

/*clear the screen*/
void clear(){
  int i;
  for(i=0;i<ROWS*COLS;i++)
8010545e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105462:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
80105469:	7e e6                	jle    80105451 <clear+0xf>
    putchar(' ');
  Curx=Cury=0;
8010546b:	c7 05 70 c6 10 80 00 	movl   $0x0,0x8010c670
80105472:	00 00 00 
80105475:	a1 70 c6 10 80       	mov    0x8010c670,%eax
8010547a:	a3 6c c6 10 80       	mov    %eax,0x8010c66c
}
8010547f:	c9                   	leave  
80105480:	c3                   	ret    

80105481 <vga_init>:

//init and clear screen
void vga_init(void){
80105481:	55                   	push   %ebp
80105482:	89 e5                	mov    %esp,%ebp
80105484:	83 ec 08             	sub    $0x8,%esp
  Scrn=(unsigned short*)VGA_START;
80105487:	c7 05 b4 5a 11 80 00 	movl   $0xb8000,0x80115ab4
8010548e:	80 0b 00 
  clear();
80105491:	e8 ac ff ff ff       	call   80105442 <clear>
}
80105496:	c9                   	leave  
80105497:	c3                   	ret    

80105498 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105498:	55                   	push   %ebp
80105499:	89 e5                	mov    %esp,%ebp
8010549b:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010549e:	9c                   	pushf  
8010549f:	58                   	pop    %eax
801054a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801054a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801054a6:	c9                   	leave  
801054a7:	c3                   	ret    

801054a8 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801054a8:	55                   	push   %ebp
801054a9:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801054ab:	fa                   	cli    
}
801054ac:	5d                   	pop    %ebp
801054ad:	c3                   	ret    

801054ae <sti>:

static inline void
sti(void)
{
801054ae:	55                   	push   %ebp
801054af:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801054b1:	fb                   	sti    
}
801054b2:	5d                   	pop    %ebp
801054b3:	c3                   	ret    

801054b4 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801054b4:	55                   	push   %ebp
801054b5:	89 e5                	mov    %esp,%ebp
801054b7:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801054ba:	8b 55 08             	mov    0x8(%ebp),%edx
801054bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801054c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
801054c3:	f0 87 02             	lock xchg %eax,(%edx)
801054c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801054c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801054cc:	c9                   	leave  
801054cd:	c3                   	ret    

801054ce <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801054ce:	55                   	push   %ebp
801054cf:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801054d1:	8b 45 08             	mov    0x8(%ebp),%eax
801054d4:	8b 55 0c             	mov    0xc(%ebp),%edx
801054d7:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801054da:	8b 45 08             	mov    0x8(%ebp),%eax
801054dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801054e3:	8b 45 08             	mov    0x8(%ebp),%eax
801054e6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801054ed:	5d                   	pop    %ebp
801054ee:	c3                   	ret    

801054ef <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801054ef:	55                   	push   %ebp
801054f0:	89 e5                	mov    %esp,%ebp
801054f2:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801054f5:	e8 4f 01 00 00       	call   80105649 <pushcli>
  if(holding(lk))
801054fa:	8b 45 08             	mov    0x8(%ebp),%eax
801054fd:	83 ec 0c             	sub    $0xc,%esp
80105500:	50                   	push   %eax
80105501:	e8 19 01 00 00       	call   8010561f <holding>
80105506:	83 c4 10             	add    $0x10,%esp
80105509:	85 c0                	test   %eax,%eax
8010550b:	74 0d                	je     8010551a <acquire+0x2b>
    panic("acquire");
8010550d:	83 ec 0c             	sub    $0xc,%esp
80105510:	68 12 93 10 80       	push   $0x80109312
80105515:	e8 89 b0 ff ff       	call   801005a3 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
8010551a:	90                   	nop
8010551b:	8b 45 08             	mov    0x8(%ebp),%eax
8010551e:	83 ec 08             	sub    $0x8,%esp
80105521:	6a 01                	push   $0x1
80105523:	50                   	push   %eax
80105524:	e8 8b ff ff ff       	call   801054b4 <xchg>
80105529:	83 c4 10             	add    $0x10,%esp
8010552c:	85 c0                	test   %eax,%eax
8010552e:	75 eb                	jne    8010551b <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80105530:	8b 45 08             	mov    0x8(%ebp),%eax
80105533:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010553a:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
8010553d:	8b 45 08             	mov    0x8(%ebp),%eax
80105540:	83 c0 0c             	add    $0xc,%eax
80105543:	83 ec 08             	sub    $0x8,%esp
80105546:	50                   	push   %eax
80105547:	8d 45 08             	lea    0x8(%ebp),%eax
8010554a:	50                   	push   %eax
8010554b:	e8 56 00 00 00       	call   801055a6 <getcallerpcs>
80105550:	83 c4 10             	add    $0x10,%esp
}
80105553:	c9                   	leave  
80105554:	c3                   	ret    

80105555 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105555:	55                   	push   %ebp
80105556:	89 e5                	mov    %esp,%ebp
80105558:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
8010555b:	83 ec 0c             	sub    $0xc,%esp
8010555e:	ff 75 08             	pushl  0x8(%ebp)
80105561:	e8 b9 00 00 00       	call   8010561f <holding>
80105566:	83 c4 10             	add    $0x10,%esp
80105569:	85 c0                	test   %eax,%eax
8010556b:	75 0d                	jne    8010557a <release+0x25>
    panic("release");
8010556d:	83 ec 0c             	sub    $0xc,%esp
80105570:	68 1a 93 10 80       	push   $0x8010931a
80105575:	e8 29 b0 ff ff       	call   801005a3 <panic>

  lk->pcs[0] = 0;
8010557a:	8b 45 08             	mov    0x8(%ebp),%eax
8010557d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105584:	8b 45 08             	mov    0x8(%ebp),%eax
80105587:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010558e:	8b 45 08             	mov    0x8(%ebp),%eax
80105591:	83 ec 08             	sub    $0x8,%esp
80105594:	6a 00                	push   $0x0
80105596:	50                   	push   %eax
80105597:	e8 18 ff ff ff       	call   801054b4 <xchg>
8010559c:	83 c4 10             	add    $0x10,%esp

  popcli();
8010559f:	e8 e9 00 00 00       	call   8010568d <popcli>
}
801055a4:	c9                   	leave  
801055a5:	c3                   	ret    

801055a6 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801055a6:	55                   	push   %ebp
801055a7:	89 e5                	mov    %esp,%ebp
801055a9:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
801055ac:	8b 45 08             	mov    0x8(%ebp),%eax
801055af:	83 e8 08             	sub    $0x8,%eax
801055b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801055b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801055bc:	eb 38                	jmp    801055f6 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801055be:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801055c2:	74 38                	je     801055fc <getcallerpcs+0x56>
801055c4:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801055cb:	76 2f                	jbe    801055fc <getcallerpcs+0x56>
801055cd:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801055d1:	74 29                	je     801055fc <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
801055d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801055dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801055e0:	01 c2                	add    %eax,%edx
801055e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055e5:	8b 40 04             	mov    0x4(%eax),%eax
801055e8:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801055ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055ed:	8b 00                	mov    (%eax),%eax
801055ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801055f2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801055f6:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801055fa:	7e c2                	jle    801055be <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801055fc:	eb 19                	jmp    80105617 <getcallerpcs+0x71>
    pcs[i] = 0;
801055fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105601:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105608:	8b 45 0c             	mov    0xc(%ebp),%eax
8010560b:	01 d0                	add    %edx,%eax
8010560d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105613:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105617:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010561b:	7e e1                	jle    801055fe <getcallerpcs+0x58>
    pcs[i] = 0;
}
8010561d:	c9                   	leave  
8010561e:	c3                   	ret    

8010561f <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
8010561f:	55                   	push   %ebp
80105620:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80105622:	8b 45 08             	mov    0x8(%ebp),%eax
80105625:	8b 00                	mov    (%eax),%eax
80105627:	85 c0                	test   %eax,%eax
80105629:	74 17                	je     80105642 <holding+0x23>
8010562b:	8b 45 08             	mov    0x8(%ebp),%eax
8010562e:	8b 50 08             	mov    0x8(%eax),%edx
80105631:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105637:	39 c2                	cmp    %eax,%edx
80105639:	75 07                	jne    80105642 <holding+0x23>
8010563b:	b8 01 00 00 00       	mov    $0x1,%eax
80105640:	eb 05                	jmp    80105647 <holding+0x28>
80105642:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105647:	5d                   	pop    %ebp
80105648:	c3                   	ret    

80105649 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105649:	55                   	push   %ebp
8010564a:	89 e5                	mov    %esp,%ebp
8010564c:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
8010564f:	e8 44 fe ff ff       	call   80105498 <readeflags>
80105654:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105657:	e8 4c fe ff ff       	call   801054a8 <cli>
  if(cpu->ncli++ == 0)
8010565c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105663:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80105669:	8d 48 01             	lea    0x1(%eax),%ecx
8010566c:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80105672:	85 c0                	test   %eax,%eax
80105674:	75 15                	jne    8010568b <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80105676:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010567c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010567f:	81 e2 00 02 00 00    	and    $0x200,%edx
80105685:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010568b:	c9                   	leave  
8010568c:	c3                   	ret    

8010568d <popcli>:

void
popcli(void)
{
8010568d:	55                   	push   %ebp
8010568e:	89 e5                	mov    %esp,%ebp
80105690:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80105693:	e8 00 fe ff ff       	call   80105498 <readeflags>
80105698:	25 00 02 00 00       	and    $0x200,%eax
8010569d:	85 c0                	test   %eax,%eax
8010569f:	74 0d                	je     801056ae <popcli+0x21>
    panic("popcli - interruptible");
801056a1:	83 ec 0c             	sub    $0xc,%esp
801056a4:	68 22 93 10 80       	push   $0x80109322
801056a9:	e8 f5 ae ff ff       	call   801005a3 <panic>
  if(--cpu->ncli < 0)
801056ae:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801056b4:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801056ba:	83 ea 01             	sub    $0x1,%edx
801056bd:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801056c3:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801056c9:	85 c0                	test   %eax,%eax
801056cb:	79 0d                	jns    801056da <popcli+0x4d>
    panic("popcli");
801056cd:	83 ec 0c             	sub    $0xc,%esp
801056d0:	68 39 93 10 80       	push   $0x80109339
801056d5:	e8 c9 ae ff ff       	call   801005a3 <panic>
  if(cpu->ncli == 0 && cpu->intena)
801056da:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801056e0:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801056e6:	85 c0                	test   %eax,%eax
801056e8:	75 15                	jne    801056ff <popcli+0x72>
801056ea:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801056f0:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801056f6:	85 c0                	test   %eax,%eax
801056f8:	74 05                	je     801056ff <popcli+0x72>
    sti();
801056fa:	e8 af fd ff ff       	call   801054ae <sti>
}
801056ff:	c9                   	leave  
80105700:	c3                   	ret    

80105701 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105701:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105705:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105709:	55                   	push   %ebp
  pushl %ebx
8010570a:	53                   	push   %ebx
  pushl %esi
8010570b:	56                   	push   %esi
  pushl %edi
8010570c:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010570d:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010570f:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105711:	5f                   	pop    %edi
  popl %esi
80105712:	5e                   	pop    %esi
  popl %ebx
80105713:	5b                   	pop    %ebx
  popl %ebp
80105714:	5d                   	pop    %ebp
  ret
80105715:	c3                   	ret    

80105716 <syscall_handler>:
#include "regs.h"
void syscall_handler(regs_t *regst){
80105716:	55                   	push   %ebp
80105717:	89 e5                	mov    %esp,%ebp
}
80105719:	5d                   	pop    %ebp
8010571a:	c3                   	ret    

8010571b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
8010571b:	55                   	push   %ebp
8010571c:	89 e5                	mov    %esp,%ebp
8010571e:	57                   	push   %edi
8010571f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105720:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105723:	8b 55 10             	mov    0x10(%ebp),%edx
80105726:	8b 45 0c             	mov    0xc(%ebp),%eax
80105729:	89 cb                	mov    %ecx,%ebx
8010572b:	89 df                	mov    %ebx,%edi
8010572d:	89 d1                	mov    %edx,%ecx
8010572f:	fc                   	cld    
80105730:	f3 aa                	rep stos %al,%es:(%edi)
80105732:	89 ca                	mov    %ecx,%edx
80105734:	89 fb                	mov    %edi,%ebx
80105736:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105739:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010573c:	5b                   	pop    %ebx
8010573d:	5f                   	pop    %edi
8010573e:	5d                   	pop    %ebp
8010573f:	c3                   	ret    

80105740 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	57                   	push   %edi
80105744:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105745:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105748:	8b 55 10             	mov    0x10(%ebp),%edx
8010574b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010574e:	89 cb                	mov    %ecx,%ebx
80105750:	89 df                	mov    %ebx,%edi
80105752:	89 d1                	mov    %edx,%ecx
80105754:	fc                   	cld    
80105755:	f3 ab                	rep stos %eax,%es:(%edi)
80105757:	89 ca                	mov    %ecx,%edx
80105759:	89 fb                	mov    %edi,%ebx
8010575b:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010575e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105761:	5b                   	pop    %ebx
80105762:	5f                   	pop    %edi
80105763:	5d                   	pop    %ebp
80105764:	c3                   	ret    

80105765 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105765:	55                   	push   %ebp
80105766:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105768:	8b 45 08             	mov    0x8(%ebp),%eax
8010576b:	83 e0 03             	and    $0x3,%eax
8010576e:	85 c0                	test   %eax,%eax
80105770:	75 43                	jne    801057b5 <memset+0x50>
80105772:	8b 45 10             	mov    0x10(%ebp),%eax
80105775:	83 e0 03             	and    $0x3,%eax
80105778:	85 c0                	test   %eax,%eax
8010577a:	75 39                	jne    801057b5 <memset+0x50>
    c &= 0xFF;
8010577c:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105783:	8b 45 10             	mov    0x10(%ebp),%eax
80105786:	c1 e8 02             	shr    $0x2,%eax
80105789:	89 c1                	mov    %eax,%ecx
8010578b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010578e:	c1 e0 18             	shl    $0x18,%eax
80105791:	89 c2                	mov    %eax,%edx
80105793:	8b 45 0c             	mov    0xc(%ebp),%eax
80105796:	c1 e0 10             	shl    $0x10,%eax
80105799:	09 c2                	or     %eax,%edx
8010579b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010579e:	c1 e0 08             	shl    $0x8,%eax
801057a1:	09 d0                	or     %edx,%eax
801057a3:	0b 45 0c             	or     0xc(%ebp),%eax
801057a6:	51                   	push   %ecx
801057a7:	50                   	push   %eax
801057a8:	ff 75 08             	pushl  0x8(%ebp)
801057ab:	e8 90 ff ff ff       	call   80105740 <stosl>
801057b0:	83 c4 0c             	add    $0xc,%esp
801057b3:	eb 12                	jmp    801057c7 <memset+0x62>
  } else
    stosb(dst, c, n);
801057b5:	8b 45 10             	mov    0x10(%ebp),%eax
801057b8:	50                   	push   %eax
801057b9:	ff 75 0c             	pushl  0xc(%ebp)
801057bc:	ff 75 08             	pushl  0x8(%ebp)
801057bf:	e8 57 ff ff ff       	call   8010571b <stosb>
801057c4:	83 c4 0c             	add    $0xc,%esp
  return dst;
801057c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
801057ca:	c9                   	leave  
801057cb:	c3                   	ret    

801057cc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801057cc:	55                   	push   %ebp
801057cd:	89 e5                	mov    %esp,%ebp
801057cf:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
801057d2:	8b 45 08             	mov    0x8(%ebp),%eax
801057d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801057d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801057db:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801057de:	eb 30                	jmp    80105810 <memcmp+0x44>
    if(*s1 != *s2)
801057e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057e3:	0f b6 10             	movzbl (%eax),%edx
801057e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
801057e9:	0f b6 00             	movzbl (%eax),%eax
801057ec:	38 c2                	cmp    %al,%dl
801057ee:	74 18                	je     80105808 <memcmp+0x3c>
      return *s1 - *s2;
801057f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057f3:	0f b6 00             	movzbl (%eax),%eax
801057f6:	0f b6 d0             	movzbl %al,%edx
801057f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
801057fc:	0f b6 00             	movzbl (%eax),%eax
801057ff:	0f b6 c0             	movzbl %al,%eax
80105802:	29 c2                	sub    %eax,%edx
80105804:	89 d0                	mov    %edx,%eax
80105806:	eb 1a                	jmp    80105822 <memcmp+0x56>
    s1++, s2++;
80105808:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010580c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105810:	8b 45 10             	mov    0x10(%ebp),%eax
80105813:	8d 50 ff             	lea    -0x1(%eax),%edx
80105816:	89 55 10             	mov    %edx,0x10(%ebp)
80105819:	85 c0                	test   %eax,%eax
8010581b:	75 c3                	jne    801057e0 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010581d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105822:	c9                   	leave  
80105823:	c3                   	ret    

80105824 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105824:	55                   	push   %ebp
80105825:	89 e5                	mov    %esp,%ebp
80105827:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
8010582a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010582d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105830:	8b 45 08             	mov    0x8(%ebp),%eax
80105833:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105836:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105839:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010583c:	73 3d                	jae    8010587b <memmove+0x57>
8010583e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105841:	8b 45 10             	mov    0x10(%ebp),%eax
80105844:	01 d0                	add    %edx,%eax
80105846:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105849:	76 30                	jbe    8010587b <memmove+0x57>
    s += n;
8010584b:	8b 45 10             	mov    0x10(%ebp),%eax
8010584e:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105851:	8b 45 10             	mov    0x10(%ebp),%eax
80105854:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105857:	eb 13                	jmp    8010586c <memmove+0x48>
      *--d = *--s;
80105859:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
8010585d:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105861:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105864:	0f b6 10             	movzbl (%eax),%edx
80105867:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010586a:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010586c:	8b 45 10             	mov    0x10(%ebp),%eax
8010586f:	8d 50 ff             	lea    -0x1(%eax),%edx
80105872:	89 55 10             	mov    %edx,0x10(%ebp)
80105875:	85 c0                	test   %eax,%eax
80105877:	75 e0                	jne    80105859 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105879:	eb 26                	jmp    801058a1 <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010587b:	eb 17                	jmp    80105894 <memmove+0x70>
      *d++ = *s++;
8010587d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105880:	8d 50 01             	lea    0x1(%eax),%edx
80105883:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105886:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105889:	8d 4a 01             	lea    0x1(%edx),%ecx
8010588c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
8010588f:	0f b6 12             	movzbl (%edx),%edx
80105892:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105894:	8b 45 10             	mov    0x10(%ebp),%eax
80105897:	8d 50 ff             	lea    -0x1(%eax),%edx
8010589a:	89 55 10             	mov    %edx,0x10(%ebp)
8010589d:	85 c0                	test   %eax,%eax
8010589f:	75 dc                	jne    8010587d <memmove+0x59>
      *d++ = *s++;

  return dst;
801058a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
801058a4:	c9                   	leave  
801058a5:	c3                   	ret    

801058a6 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801058a6:	55                   	push   %ebp
801058a7:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
801058a9:	ff 75 10             	pushl  0x10(%ebp)
801058ac:	ff 75 0c             	pushl  0xc(%ebp)
801058af:	ff 75 08             	pushl  0x8(%ebp)
801058b2:	e8 6d ff ff ff       	call   80105824 <memmove>
801058b7:	83 c4 0c             	add    $0xc,%esp
}
801058ba:	c9                   	leave  
801058bb:	c3                   	ret    

801058bc <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801058bc:	55                   	push   %ebp
801058bd:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801058bf:	eb 0c                	jmp    801058cd <strncmp+0x11>
    n--, p++, q++;
801058c1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801058c5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801058c9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801058cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801058d1:	74 1a                	je     801058ed <strncmp+0x31>
801058d3:	8b 45 08             	mov    0x8(%ebp),%eax
801058d6:	0f b6 00             	movzbl (%eax),%eax
801058d9:	84 c0                	test   %al,%al
801058db:	74 10                	je     801058ed <strncmp+0x31>
801058dd:	8b 45 08             	mov    0x8(%ebp),%eax
801058e0:	0f b6 10             	movzbl (%eax),%edx
801058e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801058e6:	0f b6 00             	movzbl (%eax),%eax
801058e9:	38 c2                	cmp    %al,%dl
801058eb:	74 d4                	je     801058c1 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801058ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801058f1:	75 07                	jne    801058fa <strncmp+0x3e>
    return 0;
801058f3:	b8 00 00 00 00       	mov    $0x0,%eax
801058f8:	eb 16                	jmp    80105910 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
801058fa:	8b 45 08             	mov    0x8(%ebp),%eax
801058fd:	0f b6 00             	movzbl (%eax),%eax
80105900:	0f b6 d0             	movzbl %al,%edx
80105903:	8b 45 0c             	mov    0xc(%ebp),%eax
80105906:	0f b6 00             	movzbl (%eax),%eax
80105909:	0f b6 c0             	movzbl %al,%eax
8010590c:	29 c2                	sub    %eax,%edx
8010590e:	89 d0                	mov    %edx,%eax
}
80105910:	5d                   	pop    %ebp
80105911:	c3                   	ret    

80105912 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105912:	55                   	push   %ebp
80105913:	89 e5                	mov    %esp,%ebp
80105915:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105918:	8b 45 08             	mov    0x8(%ebp),%eax
8010591b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010591e:	90                   	nop
8010591f:	8b 45 10             	mov    0x10(%ebp),%eax
80105922:	8d 50 ff             	lea    -0x1(%eax),%edx
80105925:	89 55 10             	mov    %edx,0x10(%ebp)
80105928:	85 c0                	test   %eax,%eax
8010592a:	7e 1e                	jle    8010594a <strncpy+0x38>
8010592c:	8b 45 08             	mov    0x8(%ebp),%eax
8010592f:	8d 50 01             	lea    0x1(%eax),%edx
80105932:	89 55 08             	mov    %edx,0x8(%ebp)
80105935:	8b 55 0c             	mov    0xc(%ebp),%edx
80105938:	8d 4a 01             	lea    0x1(%edx),%ecx
8010593b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010593e:	0f b6 12             	movzbl (%edx),%edx
80105941:	88 10                	mov    %dl,(%eax)
80105943:	0f b6 00             	movzbl (%eax),%eax
80105946:	84 c0                	test   %al,%al
80105948:	75 d5                	jne    8010591f <strncpy+0xd>
    ;
  while(n-- > 0)
8010594a:	eb 0c                	jmp    80105958 <strncpy+0x46>
    *s++ = 0;
8010594c:	8b 45 08             	mov    0x8(%ebp),%eax
8010594f:	8d 50 01             	lea    0x1(%eax),%edx
80105952:	89 55 08             	mov    %edx,0x8(%ebp)
80105955:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105958:	8b 45 10             	mov    0x10(%ebp),%eax
8010595b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010595e:	89 55 10             	mov    %edx,0x10(%ebp)
80105961:	85 c0                	test   %eax,%eax
80105963:	7f e7                	jg     8010594c <strncpy+0x3a>
    *s++ = 0;
  return os;
80105965:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105968:	c9                   	leave  
80105969:	c3                   	ret    

8010596a <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
8010596a:	55                   	push   %ebp
8010596b:	89 e5                	mov    %esp,%ebp
8010596d:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105970:	8b 45 08             	mov    0x8(%ebp),%eax
80105973:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105976:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010597a:	7f 05                	jg     80105981 <safestrcpy+0x17>
    return os;
8010597c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010597f:	eb 31                	jmp    801059b2 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105981:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105985:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105989:	7e 1e                	jle    801059a9 <safestrcpy+0x3f>
8010598b:	8b 45 08             	mov    0x8(%ebp),%eax
8010598e:	8d 50 01             	lea    0x1(%eax),%edx
80105991:	89 55 08             	mov    %edx,0x8(%ebp)
80105994:	8b 55 0c             	mov    0xc(%ebp),%edx
80105997:	8d 4a 01             	lea    0x1(%edx),%ecx
8010599a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010599d:	0f b6 12             	movzbl (%edx),%edx
801059a0:	88 10                	mov    %dl,(%eax)
801059a2:	0f b6 00             	movzbl (%eax),%eax
801059a5:	84 c0                	test   %al,%al
801059a7:	75 d8                	jne    80105981 <safestrcpy+0x17>
    ;
  *s = 0;
801059a9:	8b 45 08             	mov    0x8(%ebp),%eax
801059ac:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801059af:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801059b2:	c9                   	leave  
801059b3:	c3                   	ret    

801059b4 <strlen>:

int
strlen(const char *s)
{
801059b4:	55                   	push   %ebp
801059b5:	89 e5                	mov    %esp,%ebp
801059b7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801059ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801059c1:	eb 04                	jmp    801059c7 <strlen+0x13>
801059c3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801059c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
801059ca:	8b 45 08             	mov    0x8(%ebp),%eax
801059cd:	01 d0                	add    %edx,%eax
801059cf:	0f b6 00             	movzbl (%eax),%eax
801059d2:	84 c0                	test   %al,%al
801059d4:	75 ed                	jne    801059c3 <strlen+0xf>
    ;
  return n;
801059d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801059d9:	c9                   	leave  
801059da:	c3                   	ret    

801059db <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801059db:	55                   	push   %ebp
801059dc:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
801059de:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059e4:	8b 00                	mov    (%eax),%eax
801059e6:	3b 45 08             	cmp    0x8(%ebp),%eax
801059e9:	76 12                	jbe    801059fd <fetchint+0x22>
801059eb:	8b 45 08             	mov    0x8(%ebp),%eax
801059ee:	8d 50 04             	lea    0x4(%eax),%edx
801059f1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059f7:	8b 00                	mov    (%eax),%eax
801059f9:	39 c2                	cmp    %eax,%edx
801059fb:	76 07                	jbe    80105a04 <fetchint+0x29>
    return -1;
801059fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a02:	eb 0f                	jmp    80105a13 <fetchint+0x38>
  *ip = *(int*)(addr);
80105a04:	8b 45 08             	mov    0x8(%ebp),%eax
80105a07:	8b 10                	mov    (%eax),%edx
80105a09:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a0c:	89 10                	mov    %edx,(%eax)
  return 0;
80105a0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a13:	5d                   	pop    %ebp
80105a14:	c3                   	ret    

80105a15 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105a15:	55                   	push   %ebp
80105a16:	89 e5                	mov    %esp,%ebp
80105a18:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105a1b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a21:	8b 00                	mov    (%eax),%eax
80105a23:	3b 45 08             	cmp    0x8(%ebp),%eax
80105a26:	77 07                	ja     80105a2f <fetchstr+0x1a>
    return -1;
80105a28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a2d:	eb 46                	jmp    80105a75 <fetchstr+0x60>
  *pp = (char*)addr;
80105a2f:	8b 55 08             	mov    0x8(%ebp),%edx
80105a32:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a35:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105a37:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a3d:	8b 00                	mov    (%eax),%eax
80105a3f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105a42:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a45:	8b 00                	mov    (%eax),%eax
80105a47:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105a4a:	eb 1c                	jmp    80105a68 <fetchstr+0x53>
    if(*s == 0)
80105a4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a4f:	0f b6 00             	movzbl (%eax),%eax
80105a52:	84 c0                	test   %al,%al
80105a54:	75 0e                	jne    80105a64 <fetchstr+0x4f>
      return s - *pp;
80105a56:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a59:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a5c:	8b 00                	mov    (%eax),%eax
80105a5e:	29 c2                	sub    %eax,%edx
80105a60:	89 d0                	mov    %edx,%eax
80105a62:	eb 11                	jmp    80105a75 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80105a64:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105a68:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a6b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105a6e:	72 dc                	jb     80105a4c <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80105a70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a75:	c9                   	leave  
80105a76:	c3                   	ret    

80105a77 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105a77:	55                   	push   %ebp
80105a78:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105a7a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a80:	8b 40 18             	mov    0x18(%eax),%eax
80105a83:	8b 40 44             	mov    0x44(%eax),%eax
80105a86:	8b 55 08             	mov    0x8(%ebp),%edx
80105a89:	c1 e2 02             	shl    $0x2,%edx
80105a8c:	01 d0                	add    %edx,%eax
80105a8e:	83 c0 04             	add    $0x4,%eax
80105a91:	ff 75 0c             	pushl  0xc(%ebp)
80105a94:	50                   	push   %eax
80105a95:	e8 41 ff ff ff       	call   801059db <fetchint>
80105a9a:	83 c4 08             	add    $0x8,%esp
}
80105a9d:	c9                   	leave  
80105a9e:	c3                   	ret    

80105a9f <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105a9f:	55                   	push   %ebp
80105aa0:	89 e5                	mov    %esp,%ebp
80105aa2:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105aa5:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105aa8:	50                   	push   %eax
80105aa9:	ff 75 08             	pushl  0x8(%ebp)
80105aac:	e8 c6 ff ff ff       	call   80105a77 <argint>
80105ab1:	83 c4 08             	add    $0x8,%esp
80105ab4:	85 c0                	test   %eax,%eax
80105ab6:	79 07                	jns    80105abf <argptr+0x20>
    return -1;
80105ab8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105abd:	eb 3d                	jmp    80105afc <argptr+0x5d>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105abf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ac2:	89 c2                	mov    %eax,%edx
80105ac4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105aca:	8b 00                	mov    (%eax),%eax
80105acc:	39 c2                	cmp    %eax,%edx
80105ace:	73 16                	jae    80105ae6 <argptr+0x47>
80105ad0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ad3:	89 c2                	mov    %eax,%edx
80105ad5:	8b 45 10             	mov    0x10(%ebp),%eax
80105ad8:	01 c2                	add    %eax,%edx
80105ada:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ae0:	8b 00                	mov    (%eax),%eax
80105ae2:	39 c2                	cmp    %eax,%edx
80105ae4:	76 07                	jbe    80105aed <argptr+0x4e>
    return -1;
80105ae6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aeb:	eb 0f                	jmp    80105afc <argptr+0x5d>
  *pp = (char*)i;
80105aed:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105af0:	89 c2                	mov    %eax,%edx
80105af2:	8b 45 0c             	mov    0xc(%ebp),%eax
80105af5:	89 10                	mov    %edx,(%eax)
  return 0;
80105af7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105afc:	c9                   	leave  
80105afd:	c3                   	ret    

80105afe <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105afe:	55                   	push   %ebp
80105aff:	89 e5                	mov    %esp,%ebp
80105b01:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105b04:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105b07:	50                   	push   %eax
80105b08:	ff 75 08             	pushl  0x8(%ebp)
80105b0b:	e8 67 ff ff ff       	call   80105a77 <argint>
80105b10:	83 c4 08             	add    $0x8,%esp
80105b13:	85 c0                	test   %eax,%eax
80105b15:	79 07                	jns    80105b1e <argstr+0x20>
    return -1;
80105b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b1c:	eb 0f                	jmp    80105b2d <argstr+0x2f>
  return fetchstr(addr, pp);
80105b1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b21:	ff 75 0c             	pushl  0xc(%ebp)
80105b24:	50                   	push   %eax
80105b25:	e8 eb fe ff ff       	call   80105a15 <fetchstr>
80105b2a:	83 c4 08             	add    $0x8,%esp
}
80105b2d:	c9                   	leave  
80105b2e:	c3                   	ret    

80105b2f <syscall>:
[SYS_candprocs]  sys_candprocs
};

void
syscall(void)
{
80105b2f:	55                   	push   %ebp
80105b30:	89 e5                	mov    %esp,%ebp
80105b32:	53                   	push   %ebx
80105b33:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80105b36:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b3c:	8b 40 18             	mov    0x18(%eax),%eax
80105b3f:	8b 40 1c             	mov    0x1c(%eax),%eax
80105b42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105b45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b49:	7e 30                	jle    80105b7b <syscall+0x4c>
80105b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b4e:	83 f8 1b             	cmp    $0x1b,%eax
80105b51:	77 28                	ja     80105b7b <syscall+0x4c>
80105b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b56:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105b5d:	85 c0                	test   %eax,%eax
80105b5f:	74 1a                	je     80105b7b <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105b61:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b67:	8b 58 18             	mov    0x18(%eax),%ebx
80105b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b6d:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105b74:	ff d0                	call   *%eax
80105b76:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105b79:	eb 4e                	jmp    80105bc9 <syscall+0x9a>
  } else {
cprintf("proc->pid=%d\n",proc->pid);
80105b7b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b81:	8b 40 10             	mov    0x10(%eax),%eax
80105b84:	83 ec 08             	sub    $0x8,%esp
80105b87:	50                   	push   %eax
80105b88:	68 40 93 10 80       	push   $0x80109340
80105b8d:	e8 74 a8 ff ff       	call   80100406 <cprintf>
80105b92:	83 c4 10             	add    $0x10,%esp
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105b95:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b9b:	8d 50 6c             	lea    0x6c(%eax),%edx
80105b9e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
cprintf("proc->pid=%d\n",proc->pid);
    cprintf("%d %s: unknown sys call %d\n",
80105ba4:	8b 40 10             	mov    0x10(%eax),%eax
80105ba7:	ff 75 f4             	pushl  -0xc(%ebp)
80105baa:	52                   	push   %edx
80105bab:	50                   	push   %eax
80105bac:	68 4e 93 10 80       	push   $0x8010934e
80105bb1:	e8 50 a8 ff ff       	call   80100406 <cprintf>
80105bb6:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105bb9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bbf:	8b 40 18             	mov    0x18(%eax),%eax
80105bc2:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105bc9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bcc:	c9                   	leave  
80105bcd:	c3                   	ret    

80105bce <sys_fork>:
#include "tareas.h"
#include "osHeader.h"

int
sys_fork(void)
{
80105bce:	55                   	push   %ebp
80105bcf:	89 e5                	mov    %esp,%ebp
80105bd1:	83 ec 08             	sub    $0x8,%esp
  return fork();
80105bd4:	e8 63 ec ff ff       	call   8010483c <fork>
}
80105bd9:	c9                   	leave  
80105bda:	c3                   	ret    

80105bdb <sys_exit>:

int
sys_exit(void)
{
80105bdb:	55                   	push   %ebp
80105bdc:	89 e5                	mov    %esp,%ebp
80105bde:	83 ec 08             	sub    $0x8,%esp
  exit();
80105be1:	e8 e7 ed ff ff       	call   801049cd <exit>
  return 0;  // not reached
80105be6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105beb:	c9                   	leave  
80105bec:	c3                   	ret    

80105bed <sys_wait>:

int
sys_wait(void)
{
80105bed:	55                   	push   %ebp
80105bee:	89 e5                	mov    %esp,%ebp
80105bf0:	83 ec 08             	sub    $0x8,%esp
  return wait();
80105bf3:	e8 10 ef ff ff       	call   80104b08 <wait>
}
80105bf8:	c9                   	leave  
80105bf9:	c3                   	ret    

80105bfa <sys_kill>:

int
sys_kill(void)
{
80105bfa:	55                   	push   %ebp
80105bfb:	89 e5                	mov    %esp,%ebp
80105bfd:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105c00:	83 ec 08             	sub    $0x8,%esp
80105c03:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c06:	50                   	push   %eax
80105c07:	6a 00                	push   $0x0
80105c09:	e8 69 fe ff ff       	call   80105a77 <argint>
80105c0e:	83 c4 10             	add    $0x10,%esp
80105c11:	85 c0                	test   %eax,%eax
80105c13:	79 07                	jns    80105c1c <sys_kill+0x22>
    return -1;
80105c15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c1a:	eb 0f                	jmp    80105c2b <sys_kill+0x31>
  return kill(pid);
80105c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c1f:	83 ec 0c             	sub    $0xc,%esp
80105c22:	50                   	push   %eax
80105c23:	e8 01 f3 ff ff       	call   80104f29 <kill>
80105c28:	83 c4 10             	add    $0x10,%esp
}
80105c2b:	c9                   	leave  
80105c2c:	c3                   	ret    

80105c2d <sys_getpid>:

int
sys_getpid(void)
{
80105c2d:	55                   	push   %ebp
80105c2e:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80105c30:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c36:	8b 40 10             	mov    0x10(%eax),%eax
}
80105c39:	5d                   	pop    %ebp
80105c3a:	c3                   	ret    

80105c3b <sys_sbrk>:

int
sys_sbrk(void)
{
80105c3b:	55                   	push   %ebp
80105c3c:	89 e5                	mov    %esp,%ebp
80105c3e:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c41:	83 ec 08             	sub    $0x8,%esp
80105c44:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c47:	50                   	push   %eax
80105c48:	6a 00                	push   $0x0
80105c4a:	e8 28 fe ff ff       	call   80105a77 <argint>
80105c4f:	83 c4 10             	add    $0x10,%esp
80105c52:	85 c0                	test   %eax,%eax
80105c54:	79 07                	jns    80105c5d <sys_sbrk+0x22>
    return -1;
80105c56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c5b:	eb 28                	jmp    80105c85 <sys_sbrk+0x4a>
  addr = proc->sz;
80105c5d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c63:	8b 00                	mov    (%eax),%eax
80105c65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80105c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c6b:	83 ec 0c             	sub    $0xc,%esp
80105c6e:	50                   	push   %eax
80105c6f:	e8 25 eb ff ff       	call   80104799 <growproc>
80105c74:	83 c4 10             	add    $0x10,%esp
80105c77:	85 c0                	test   %eax,%eax
80105c79:	79 07                	jns    80105c82 <sys_sbrk+0x47>
    return -1;
80105c7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c80:	eb 03                	jmp    80105c85 <sys_sbrk+0x4a>
  return addr;
80105c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105c85:	c9                   	leave  
80105c86:	c3                   	ret    

80105c87 <sys_sleep>:

int
sys_sleep(void)
{
80105c87:	55                   	push   %ebp
80105c88:	89 e5                	mov    %esp,%ebp
80105c8a:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80105c8d:	83 ec 08             	sub    $0x8,%esp
80105c90:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c93:	50                   	push   %eax
80105c94:	6a 00                	push   $0x0
80105c96:	e8 dc fd ff ff       	call   80105a77 <argint>
80105c9b:	83 c4 10             	add    $0x10,%esp
80105c9e:	85 c0                	test   %eax,%eax
80105ca0:	79 07                	jns    80105ca9 <sys_sleep+0x22>
    return -1;
80105ca2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ca7:	eb 77                	jmp    80105d20 <sys_sleep+0x99>
  acquire(&tickslock);
80105ca9:	83 ec 0c             	sub    $0xc,%esp
80105cac:	68 40 5b 11 80       	push   $0x80115b40
80105cb1:	e8 39 f8 ff ff       	call   801054ef <acquire>
80105cb6:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105cb9:	a1 80 63 11 80       	mov    0x80116380,%eax
80105cbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80105cc1:	eb 39                	jmp    80105cfc <sys_sleep+0x75>
    if(proc->killed){
80105cc3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cc9:	8b 40 24             	mov    0x24(%eax),%eax
80105ccc:	85 c0                	test   %eax,%eax
80105cce:	74 17                	je     80105ce7 <sys_sleep+0x60>
      release(&tickslock);
80105cd0:	83 ec 0c             	sub    $0xc,%esp
80105cd3:	68 40 5b 11 80       	push   $0x80115b40
80105cd8:	e8 78 f8 ff ff       	call   80105555 <release>
80105cdd:	83 c4 10             	add    $0x10,%esp
      return -1;
80105ce0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ce5:	eb 39                	jmp    80105d20 <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
80105ce7:	83 ec 08             	sub    $0x8,%esp
80105cea:	68 40 5b 11 80       	push   $0x80115b40
80105cef:	68 80 63 11 80       	push   $0x80116380
80105cf4:	e8 11 f1 ff ff       	call   80104e0a <sleep>
80105cf9:	83 c4 10             	add    $0x10,%esp
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105cfc:	a1 80 63 11 80       	mov    0x80116380,%eax
80105d01:	2b 45 f4             	sub    -0xc(%ebp),%eax
80105d04:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d07:	39 d0                	cmp    %edx,%eax
80105d09:	72 b8                	jb     80105cc3 <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105d0b:	83 ec 0c             	sub    $0xc,%esp
80105d0e:	68 40 5b 11 80       	push   $0x80115b40
80105d13:	e8 3d f8 ff ff       	call   80105555 <release>
80105d18:	83 c4 10             	add    $0x10,%esp
  return 0;
80105d1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d20:	c9                   	leave  
80105d21:	c3                   	ret    

80105d22 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105d22:	55                   	push   %ebp
80105d23:	89 e5                	mov    %esp,%ebp
80105d25:	83 ec 18             	sub    $0x18,%esp
  uint xticks;
  
  acquire(&tickslock);
80105d28:	83 ec 0c             	sub    $0xc,%esp
80105d2b:	68 40 5b 11 80       	push   $0x80115b40
80105d30:	e8 ba f7 ff ff       	call   801054ef <acquire>
80105d35:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80105d38:	a1 80 63 11 80       	mov    0x80116380,%eax
80105d3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80105d40:	83 ec 0c             	sub    $0xc,%esp
80105d43:	68 40 5b 11 80       	push   $0x80115b40
80105d48:	e8 08 f8 ff ff       	call   80105555 <release>
80105d4d:	83 c4 10             	add    $0x10,%esp
  return xticks;
80105d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105d53:	c9                   	leave  
80105d54:	c3                   	ret    

80105d55 <sys_createTask>:
char *argv1[] = { "TaskId_1", 0 };
char *argv2[] = { "TaskId_2", 0 };

int
sys_createTask(void)
{
80105d55:	55                   	push   %ebp
80105d56:	89 e5                	mov    %esp,%ebp
80105d58:	83 ec 18             	sub    $0x18,%esp
  int iPriority,iTaskId;
  if(argint(0,&iPriority)<0)
80105d5b:	83 ec 08             	sub    $0x8,%esp
80105d5e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d61:	50                   	push   %eax
80105d62:	6a 00                	push   $0x0
80105d64:	e8 0e fd ff ff       	call   80105a77 <argint>
80105d69:	83 c4 10             	add    $0x10,%esp
80105d6c:	85 c0                	test   %eax,%eax
80105d6e:	79 07                	jns    80105d77 <sys_createTask+0x22>
    return -1;
80105d70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d75:	eb 64                	jmp    80105ddb <sys_createTask+0x86>
  if(argint(1,&iTaskId)<0)
80105d77:	83 ec 08             	sub    $0x8,%esp
80105d7a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d7d:	50                   	push   %eax
80105d7e:	6a 01                	push   $0x1
80105d80:	e8 f2 fc ff ff       	call   80105a77 <argint>
80105d85:	83 c4 10             	add    $0x10,%esp
80105d88:	85 c0                	test   %eax,%eax
80105d8a:	79 07                	jns    80105d93 <sys_createTask+0x3e>
    return -1;
80105d8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d91:	eb 48                	jmp    80105ddb <sys_createTask+0x86>
  switch(iTaskId){
80105d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d96:	83 f8 0a             	cmp    $0xa,%eax
80105d99:	74 07                	je     80105da2 <sys_createTask+0x4d>
80105d9b:	83 f8 14             	cmp    $0x14,%eax
80105d9e:	74 1c                	je     80105dbc <sys_createTask+0x67>
80105da0:	eb 34                	jmp    80105dd6 <sys_createTask+0x81>
    case 10:{return createTask(iPriority,iTaskId,argv1);break;}
80105da2:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105da8:	83 ec 04             	sub    $0x4,%esp
80105dab:	68 b0 c0 10 80       	push   $0x8010c0b0
80105db0:	52                   	push   %edx
80105db1:	50                   	push   %eax
80105db2:	e8 b3 0e 00 00       	call   80106c6a <createTask>
80105db7:	83 c4 10             	add    $0x10,%esp
80105dba:	eb 1f                	jmp    80105ddb <sys_createTask+0x86>
    case 20:{return createTask(iPriority,iTaskId,argv2);break;}
80105dbc:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dc2:	83 ec 04             	sub    $0x4,%esp
80105dc5:	68 b8 c0 10 80       	push   $0x8010c0b8
80105dca:	52                   	push   %edx
80105dcb:	50                   	push   %eax
80105dcc:	e8 99 0e 00 00       	call   80106c6a <createTask>
80105dd1:	83 c4 10             	add    $0x10,%esp
80105dd4:	eb 05                	jmp    80105ddb <sys_createTask+0x86>
    default:return -1;
80105dd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
80105ddb:	c9                   	leave  
80105ddc:	c3                   	ret    

80105ddd <sys_startTask>:

int
sys_startTask(void)
{
80105ddd:	55                   	push   %ebp
80105dde:	89 e5                	mov    %esp,%ebp
80105de0:	83 ec 18             	sub    $0x18,%esp
  int TaskId;
  if(argint(0,&TaskId)<0)
80105de3:	83 ec 08             	sub    $0x8,%esp
80105de6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105de9:	50                   	push   %eax
80105dea:	6a 00                	push   $0x0
80105dec:	e8 86 fc ff ff       	call   80105a77 <argint>
80105df1:	83 c4 10             	add    $0x10,%esp
80105df4:	85 c0                	test   %eax,%eax
80105df6:	79 07                	jns    80105dff <sys_startTask+0x22>
    return -1;
80105df8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dfd:	eb 0f                	jmp    80105e0e <sys_startTask+0x31>
  return startTask(TaskId);
80105dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e02:	83 ec 0c             	sub    $0xc,%esp
80105e05:	50                   	push   %eax
80105e06:	e8 08 0f 00 00       	call   80106d13 <startTask>
80105e0b:	83 c4 10             	add    $0x10,%esp
}
80105e0e:	c9                   	leave  
80105e0f:	c3                   	ret    

80105e10 <sys_WaitTask>:

int
sys_WaitTask(void)
{
80105e10:	55                   	push   %ebp
80105e11:	89 e5                	mov    %esp,%ebp
80105e13:	83 ec 08             	sub    $0x8,%esp
  return waitTask();
80105e16:	e8 56 0f 00 00       	call   80106d71 <waitTask>
}
80105e1b:	c9                   	leave  
80105e1c:	c3                   	ret    

80105e1d <sys_Sched>:

int
sys_Sched(void)
{
80105e1d:	55                   	push   %ebp
80105e1e:	89 e5                	mov    %esp,%ebp
80105e20:	83 ec 08             	sub    $0x8,%esp
  return Sched();
80105e23:	e8 77 0f 00 00       	call   80106d9f <Sched>
}
80105e28:	c9                   	leave  
80105e29:	c3                   	ret    

80105e2a <sys_candprocs>:

int
sys_candprocs(void)
{
80105e2a:	55                   	push   %ebp
80105e2b:	89 e5                	mov    %esp,%ebp
80105e2d:	83 ec 08             	sub    $0x8,%esp
  return candprocs();
80105e30:	e8 6e f2 ff ff       	call   801050a3 <candprocs>
}
80105e35:	c9                   	leave  
80105e36:	c3                   	ret    

80105e37 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105e37:	55                   	push   %ebp
80105e38:	89 e5                	mov    %esp,%ebp
80105e3a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105e3d:	83 ec 08             	sub    $0x8,%esp
80105e40:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e43:	50                   	push   %eax
80105e44:	ff 75 08             	pushl  0x8(%ebp)
80105e47:	e8 2b fc ff ff       	call   80105a77 <argint>
80105e4c:	83 c4 10             	add    $0x10,%esp
80105e4f:	85 c0                	test   %eax,%eax
80105e51:	79 07                	jns    80105e5a <argfd+0x23>
    return -1;
80105e53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e58:	eb 50                	jmp    80105eaa <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e5d:	85 c0                	test   %eax,%eax
80105e5f:	78 21                	js     80105e82 <argfd+0x4b>
80105e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e64:	83 f8 0f             	cmp    $0xf,%eax
80105e67:	7f 19                	jg     80105e82 <argfd+0x4b>
80105e69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105e72:	83 c2 08             	add    $0x8,%edx
80105e75:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105e79:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e80:	75 07                	jne    80105e89 <argfd+0x52>
    return -1;
80105e82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e87:	eb 21                	jmp    80105eaa <argfd+0x73>
  if(pfd)
80105e89:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105e8d:	74 08                	je     80105e97 <argfd+0x60>
    *pfd = fd;
80105e8f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105e92:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e95:	89 10                	mov    %edx,(%eax)
  if(pf)
80105e97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105e9b:	74 08                	je     80105ea5 <argfd+0x6e>
    *pf = f;
80105e9d:	8b 45 10             	mov    0x10(%ebp),%eax
80105ea0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ea3:	89 10                	mov    %edx,(%eax)
  return 0;
80105ea5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105eaa:	c9                   	leave  
80105eab:	c3                   	ret    

80105eac <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105eac:	55                   	push   %ebp
80105ead:	89 e5                	mov    %esp,%ebp
80105eaf:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105eb2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105eb9:	eb 30                	jmp    80105eeb <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105ebb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ec1:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105ec4:	83 c2 08             	add    $0x8,%edx
80105ec7:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105ecb:	85 c0                	test   %eax,%eax
80105ecd:	75 18                	jne    80105ee7 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105ecf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ed5:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105ed8:	8d 4a 08             	lea    0x8(%edx),%ecx
80105edb:	8b 55 08             	mov    0x8(%ebp),%edx
80105ede:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105ee2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ee5:	eb 0f                	jmp    80105ef6 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105ee7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105eeb:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105eef:	7e ca                	jle    80105ebb <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105ef1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ef6:	c9                   	leave  
80105ef7:	c3                   	ret    

80105ef8 <sys_dup>:

int
sys_dup(void)
{
80105ef8:	55                   	push   %ebp
80105ef9:	89 e5                	mov    %esp,%ebp
80105efb:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105efe:	83 ec 04             	sub    $0x4,%esp
80105f01:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f04:	50                   	push   %eax
80105f05:	6a 00                	push   $0x0
80105f07:	6a 00                	push   $0x0
80105f09:	e8 29 ff ff ff       	call   80105e37 <argfd>
80105f0e:	83 c4 10             	add    $0x10,%esp
80105f11:	85 c0                	test   %eax,%eax
80105f13:	79 07                	jns    80105f1c <sys_dup+0x24>
    return -1;
80105f15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f1a:	eb 31                	jmp    80105f4d <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105f1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f1f:	83 ec 0c             	sub    $0xc,%esp
80105f22:	50                   	push   %eax
80105f23:	e8 84 ff ff ff       	call   80105eac <fdalloc>
80105f28:	83 c4 10             	add    $0x10,%esp
80105f2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f32:	79 07                	jns    80105f3b <sys_dup+0x43>
    return -1;
80105f34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f39:	eb 12                	jmp    80105f4d <sys_dup+0x55>
  filedup(f);
80105f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f3e:	83 ec 0c             	sub    $0xc,%esp
80105f41:	50                   	push   %eax
80105f42:	e8 c7 b0 ff ff       	call   8010100e <filedup>
80105f47:	83 c4 10             	add    $0x10,%esp
  return fd;
80105f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105f4d:	c9                   	leave  
80105f4e:	c3                   	ret    

80105f4f <sys_read>:

//20160313--
int
sys_read(void)
{
80105f4f:	55                   	push   %ebp
80105f50:	89 e5                	mov    %esp,%ebp
80105f52:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105f55:	83 ec 04             	sub    $0x4,%esp
80105f58:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f5b:	50                   	push   %eax
80105f5c:	6a 00                	push   $0x0
80105f5e:	6a 00                	push   $0x0
80105f60:	e8 d2 fe ff ff       	call   80105e37 <argfd>
80105f65:	83 c4 10             	add    $0x10,%esp
80105f68:	85 c0                	test   %eax,%eax
80105f6a:	78 2e                	js     80105f9a <sys_read+0x4b>
80105f6c:	83 ec 08             	sub    $0x8,%esp
80105f6f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f72:	50                   	push   %eax
80105f73:	6a 02                	push   $0x2
80105f75:	e8 fd fa ff ff       	call   80105a77 <argint>
80105f7a:	83 c4 10             	add    $0x10,%esp
80105f7d:	85 c0                	test   %eax,%eax
80105f7f:	78 19                	js     80105f9a <sys_read+0x4b>
80105f81:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f84:	83 ec 04             	sub    $0x4,%esp
80105f87:	50                   	push   %eax
80105f88:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f8b:	50                   	push   %eax
80105f8c:	6a 01                	push   $0x1
80105f8e:	e8 0c fb ff ff       	call   80105a9f <argptr>
80105f93:	83 c4 10             	add    $0x10,%esp
80105f96:	85 c0                	test   %eax,%eax
80105f98:	79 07                	jns    80105fa1 <sys_read+0x52>
    return -1;
80105f9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f9f:	eb 17                	jmp    80105fb8 <sys_read+0x69>
  return fileread(f, p, n);
80105fa1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105fa4:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105faa:	83 ec 04             	sub    $0x4,%esp
80105fad:	51                   	push   %ecx
80105fae:	52                   	push   %edx
80105faf:	50                   	push   %eax
80105fb0:	e8 e9 b1 ff ff       	call   8010119e <fileread>
80105fb5:	83 c4 10             	add    $0x10,%esp
}
80105fb8:	c9                   	leave  
80105fb9:	c3                   	ret    

80105fba <sys_write>:

//20160313--
int
sys_write(void)
{
80105fba:	55                   	push   %ebp
80105fbb:	89 e5                	mov    %esp,%ebp
80105fbd:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105fc0:	83 ec 04             	sub    $0x4,%esp
80105fc3:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fc6:	50                   	push   %eax
80105fc7:	6a 00                	push   $0x0
80105fc9:	6a 00                	push   $0x0
80105fcb:	e8 67 fe ff ff       	call   80105e37 <argfd>
80105fd0:	83 c4 10             	add    $0x10,%esp
80105fd3:	85 c0                	test   %eax,%eax
80105fd5:	78 2e                	js     80106005 <sys_write+0x4b>
80105fd7:	83 ec 08             	sub    $0x8,%esp
80105fda:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105fdd:	50                   	push   %eax
80105fde:	6a 02                	push   $0x2
80105fe0:	e8 92 fa ff ff       	call   80105a77 <argint>
80105fe5:	83 c4 10             	add    $0x10,%esp
80105fe8:	85 c0                	test   %eax,%eax
80105fea:	78 19                	js     80106005 <sys_write+0x4b>
80105fec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fef:	83 ec 04             	sub    $0x4,%esp
80105ff2:	50                   	push   %eax
80105ff3:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ff6:	50                   	push   %eax
80105ff7:	6a 01                	push   $0x1
80105ff9:	e8 a1 fa ff ff       	call   80105a9f <argptr>
80105ffe:	83 c4 10             	add    $0x10,%esp
80106001:	85 c0                	test   %eax,%eax
80106003:	79 07                	jns    8010600c <sys_write+0x52>
    return -1;
80106005:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010600a:	eb 17                	jmp    80106023 <sys_write+0x69>
  return filewrite(f, p, n);
8010600c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010600f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106012:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106015:	83 ec 04             	sub    $0x4,%esp
80106018:	51                   	push   %ecx
80106019:	52                   	push   %edx
8010601a:	50                   	push   %eax
8010601b:	e8 36 b2 ff ff       	call   80101256 <filewrite>
80106020:	83 c4 10             	add    $0x10,%esp
}
80106023:	c9                   	leave  
80106024:	c3                   	ret    

80106025 <sys_close>:

int
sys_close(void)
{
80106025:	55                   	push   %ebp
80106026:	89 e5                	mov    %esp,%ebp
80106028:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
8010602b:	83 ec 04             	sub    $0x4,%esp
8010602e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106031:	50                   	push   %eax
80106032:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106035:	50                   	push   %eax
80106036:	6a 00                	push   $0x0
80106038:	e8 fa fd ff ff       	call   80105e37 <argfd>
8010603d:	83 c4 10             	add    $0x10,%esp
80106040:	85 c0                	test   %eax,%eax
80106042:	79 07                	jns    8010604b <sys_close+0x26>
    return -1;
80106044:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106049:	eb 28                	jmp    80106073 <sys_close+0x4e>
  proc->ofile[fd] = 0;
8010604b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106051:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106054:	83 c2 08             	add    $0x8,%edx
80106057:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010605e:	00 
  fileclose(f);
8010605f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106062:	83 ec 0c             	sub    $0xc,%esp
80106065:	50                   	push   %eax
80106066:	e8 f4 af ff ff       	call   8010105f <fileclose>
8010606b:	83 c4 10             	add    $0x10,%esp
  return 0;
8010606e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106073:	c9                   	leave  
80106074:	c3                   	ret    

80106075 <sys_fstat>:

//20160313--
int
sys_fstat(void)
{
80106075:	55                   	push   %ebp
80106076:	89 e5                	mov    %esp,%ebp
80106078:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010607b:	83 ec 04             	sub    $0x4,%esp
8010607e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106081:	50                   	push   %eax
80106082:	6a 00                	push   $0x0
80106084:	6a 00                	push   $0x0
80106086:	e8 ac fd ff ff       	call   80105e37 <argfd>
8010608b:	83 c4 10             	add    $0x10,%esp
8010608e:	85 c0                	test   %eax,%eax
80106090:	78 17                	js     801060a9 <sys_fstat+0x34>
80106092:	83 ec 04             	sub    $0x4,%esp
80106095:	6a 1c                	push   $0x1c
80106097:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010609a:	50                   	push   %eax
8010609b:	6a 01                	push   $0x1
8010609d:	e8 fd f9 ff ff       	call   80105a9f <argptr>
801060a2:	83 c4 10             	add    $0x10,%esp
801060a5:	85 c0                	test   %eax,%eax
801060a7:	79 07                	jns    801060b0 <sys_fstat+0x3b>
    return -1;
801060a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060ae:	eb 13                	jmp    801060c3 <sys_fstat+0x4e>
  return filestat(f, st);
801060b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801060b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060b6:	83 ec 08             	sub    $0x8,%esp
801060b9:	52                   	push   %edx
801060ba:	50                   	push   %eax
801060bb:	e8 87 b0 ff ff       	call   80101147 <filestat>
801060c0:	83 c4 10             	add    $0x10,%esp
}
801060c3:	c9                   	leave  
801060c4:	c3                   	ret    

801060c5 <sys_link>:

//20160313--
// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801060c5:	55                   	push   %ebp
801060c6:	89 e5                	mov    %esp,%ebp
801060c8:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801060cb:	83 ec 08             	sub    $0x8,%esp
801060ce:	8d 45 d8             	lea    -0x28(%ebp),%eax
801060d1:	50                   	push   %eax
801060d2:	6a 00                	push   $0x0
801060d4:	e8 25 fa ff ff       	call   80105afe <argstr>
801060d9:	83 c4 10             	add    $0x10,%esp
801060dc:	85 c0                	test   %eax,%eax
801060de:	78 15                	js     801060f5 <sys_link+0x30>
801060e0:	83 ec 08             	sub    $0x8,%esp
801060e3:	8d 45 dc             	lea    -0x24(%ebp),%eax
801060e6:	50                   	push   %eax
801060e7:	6a 01                	push   $0x1
801060e9:	e8 10 fa ff ff       	call   80105afe <argstr>
801060ee:	83 c4 10             	add    $0x10,%esp
801060f1:	85 c0                	test   %eax,%eax
801060f3:	79 0a                	jns    801060ff <sys_link+0x3a>
    return -1;
801060f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060fa:	e9 69 01 00 00       	jmp    80106268 <sys_link+0x1a3>

  begin_op();
801060ff:	e8 7a d7 ff ff       	call   8010387e <begin_op>
  if((ip = namei(old)) == 0){
80106104:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106107:	83 ec 0c             	sub    $0xc,%esp
8010610a:	50                   	push   %eax
8010610b:	e8 a4 c4 ff ff       	call   801025b4 <namei>
80106110:	83 c4 10             	add    $0x10,%esp
80106113:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106116:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010611a:	75 0f                	jne    8010612b <sys_link+0x66>
    end_op();
8010611c:	e8 eb d7 ff ff       	call   8010390c <end_op>
    return -1;
80106121:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106126:	e9 3d 01 00 00       	jmp    80106268 <sys_link+0x1a3>
  }

  ilock(ip);
8010612b:	83 ec 0c             	sub    $0xc,%esp
8010612e:	ff 75 f4             	pushl  -0xc(%ebp)
80106131:	e8 55 b8 ff ff       	call   8010198b <ilock>
80106136:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80106139:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010613c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106140:	66 83 f8 01          	cmp    $0x1,%ax
80106144:	75 1d                	jne    80106163 <sys_link+0x9e>
    iunlockput(ip);
80106146:	83 ec 0c             	sub    $0xc,%esp
80106149:	ff 75 f4             	pushl  -0xc(%ebp)
8010614c:	e8 1f bb ff ff       	call   80101c70 <iunlockput>
80106151:	83 c4 10             	add    $0x10,%esp
    end_op();
80106154:	e8 b3 d7 ff ff       	call   8010390c <end_op>
    return -1;
80106159:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010615e:	e9 05 01 00 00       	jmp    80106268 <sys_link+0x1a3>
  }

  ip->nlink++;
80106163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106166:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010616a:	83 c0 01             	add    $0x1,%eax
8010616d:	89 c2                	mov    %eax,%edx
8010616f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106172:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106176:	83 ec 0c             	sub    $0xc,%esp
80106179:	ff 75 f4             	pushl  -0xc(%ebp)
8010617c:	e8 09 b6 ff ff       	call   8010178a <iupdate>
80106181:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80106184:	83 ec 0c             	sub    $0xc,%esp
80106187:	ff 75 f4             	pushl  -0xc(%ebp)
8010618a:	e8 81 b9 ff ff       	call   80101b10 <iunlock>
8010618f:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80106192:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106195:	83 ec 08             	sub    $0x8,%esp
80106198:	8d 55 e2             	lea    -0x1e(%ebp),%edx
8010619b:	52                   	push   %edx
8010619c:	50                   	push   %eax
8010619d:	e8 2e c4 ff ff       	call   801025d0 <nameiparent>
801061a2:	83 c4 10             	add    $0x10,%esp
801061a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801061a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801061ac:	75 02                	jne    801061b0 <sys_link+0xeb>
    goto bad;
801061ae:	eb 71                	jmp    80106221 <sys_link+0x15c>
  ilock(dp);
801061b0:	83 ec 0c             	sub    $0xc,%esp
801061b3:	ff 75 f0             	pushl  -0x10(%ebp)
801061b6:	e8 d0 b7 ff ff       	call   8010198b <ilock>
801061bb:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801061be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061c1:	8b 10                	mov    (%eax),%edx
801061c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061c6:	8b 00                	mov    (%eax),%eax
801061c8:	39 c2                	cmp    %eax,%edx
801061ca:	75 1d                	jne    801061e9 <sys_link+0x124>
801061cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061cf:	8b 40 04             	mov    0x4(%eax),%eax
801061d2:	83 ec 04             	sub    $0x4,%esp
801061d5:	50                   	push   %eax
801061d6:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801061d9:	50                   	push   %eax
801061da:	ff 75 f0             	pushl  -0x10(%ebp)
801061dd:	e8 2a c1 ff ff       	call   8010230c <dirlink>
801061e2:	83 c4 10             	add    $0x10,%esp
801061e5:	85 c0                	test   %eax,%eax
801061e7:	79 10                	jns    801061f9 <sys_link+0x134>
    iunlockput(dp);
801061e9:	83 ec 0c             	sub    $0xc,%esp
801061ec:	ff 75 f0             	pushl  -0x10(%ebp)
801061ef:	e8 7c ba ff ff       	call   80101c70 <iunlockput>
801061f4:	83 c4 10             	add    $0x10,%esp
    goto bad;
801061f7:	eb 28                	jmp    80106221 <sys_link+0x15c>
  }
  iunlockput(dp);
801061f9:	83 ec 0c             	sub    $0xc,%esp
801061fc:	ff 75 f0             	pushl  -0x10(%ebp)
801061ff:	e8 6c ba ff ff       	call   80101c70 <iunlockput>
80106204:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80106207:	83 ec 0c             	sub    $0xc,%esp
8010620a:	ff 75 f4             	pushl  -0xc(%ebp)
8010620d:	e8 6f b9 ff ff       	call   80101b81 <iput>
80106212:	83 c4 10             	add    $0x10,%esp

  end_op();
80106215:	e8 f2 d6 ff ff       	call   8010390c <end_op>

  return 0;
8010621a:	b8 00 00 00 00       	mov    $0x0,%eax
8010621f:	eb 47                	jmp    80106268 <sys_link+0x1a3>

bad:
  ilock(ip);
80106221:	83 ec 0c             	sub    $0xc,%esp
80106224:	ff 75 f4             	pushl  -0xc(%ebp)
80106227:	e8 5f b7 ff ff       	call   8010198b <ilock>
8010622c:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
8010622f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106232:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106236:	83 e8 01             	sub    $0x1,%eax
80106239:	89 c2                	mov    %eax,%edx
8010623b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010623e:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106242:	83 ec 0c             	sub    $0xc,%esp
80106245:	ff 75 f4             	pushl  -0xc(%ebp)
80106248:	e8 3d b5 ff ff       	call   8010178a <iupdate>
8010624d:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106250:	83 ec 0c             	sub    $0xc,%esp
80106253:	ff 75 f4             	pushl  -0xc(%ebp)
80106256:	e8 15 ba ff ff       	call   80101c70 <iunlockput>
8010625b:	83 c4 10             	add    $0x10,%esp
  end_op();
8010625e:	e8 a9 d6 ff ff       	call   8010390c <end_op>
  return -1;
80106263:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106268:	c9                   	leave  
80106269:	c3                   	ret    

8010626a <isdirempty>:

//20160313--
// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010626a:	55                   	push   %ebp
8010626b:	89 e5                	mov    %esp,%ebp
8010626d:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106270:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106277:	eb 40                	jmp    801062b9 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106279:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010627c:	6a 10                	push   $0x10
8010627e:	50                   	push   %eax
8010627f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106282:	50                   	push   %eax
80106283:	ff 75 08             	pushl  0x8(%ebp)
80106286:	e8 b8 bc ff ff       	call   80101f43 <readi>
8010628b:	83 c4 10             	add    $0x10,%esp
8010628e:	83 f8 10             	cmp    $0x10,%eax
80106291:	74 0d                	je     801062a0 <isdirempty+0x36>
      panic("isdirempty: readi");
80106293:	83 ec 0c             	sub    $0xc,%esp
80106296:	68 7c 93 10 80       	push   $0x8010937c
8010629b:	e8 03 a3 ff ff       	call   801005a3 <panic>
    if(de.inum != 0)
801062a0:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801062a4:	66 85 c0             	test   %ax,%ax
801062a7:	74 07                	je     801062b0 <isdirempty+0x46>
      return 0;
801062a9:	b8 00 00 00 00       	mov    $0x0,%eax
801062ae:	eb 1b                	jmp    801062cb <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801062b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062b3:	83 c0 10             	add    $0x10,%eax
801062b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062bc:	8b 45 08             	mov    0x8(%ebp),%eax
801062bf:	8b 40 20             	mov    0x20(%eax),%eax
801062c2:	39 c2                	cmp    %eax,%edx
801062c4:	72 b3                	jb     80106279 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
801062c6:	b8 01 00 00 00       	mov    $0x1,%eax
}
801062cb:	c9                   	leave  
801062cc:	c3                   	ret    

801062cd <sys_unlink>:

//20160313--
////PAGEBREAK!
int
sys_unlink(void)
{
801062cd:	55                   	push   %ebp
801062ce:	89 e5                	mov    %esp,%ebp
801062d0:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801062d3:	83 ec 08             	sub    $0x8,%esp
801062d6:	8d 45 cc             	lea    -0x34(%ebp),%eax
801062d9:	50                   	push   %eax
801062da:	6a 00                	push   $0x0
801062dc:	e8 1d f8 ff ff       	call   80105afe <argstr>
801062e1:	83 c4 10             	add    $0x10,%esp
801062e4:	85 c0                	test   %eax,%eax
801062e6:	79 0a                	jns    801062f2 <sys_unlink+0x25>
    return -1;
801062e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062ed:	e9 bc 01 00 00       	jmp    801064ae <sys_unlink+0x1e1>

  begin_op();
801062f2:	e8 87 d5 ff ff       	call   8010387e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801062f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
801062fa:	83 ec 08             	sub    $0x8,%esp
801062fd:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80106300:	52                   	push   %edx
80106301:	50                   	push   %eax
80106302:	e8 c9 c2 ff ff       	call   801025d0 <nameiparent>
80106307:	83 c4 10             	add    $0x10,%esp
8010630a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010630d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106311:	75 0f                	jne    80106322 <sys_unlink+0x55>
    end_op();
80106313:	e8 f4 d5 ff ff       	call   8010390c <end_op>
    return -1;
80106318:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010631d:	e9 8c 01 00 00       	jmp    801064ae <sys_unlink+0x1e1>
  }

  ilock(dp);
80106322:	83 ec 0c             	sub    $0xc,%esp
80106325:	ff 75 f4             	pushl  -0xc(%ebp)
80106328:	e8 5e b6 ff ff       	call   8010198b <ilock>
8010632d:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106330:	83 ec 08             	sub    $0x8,%esp
80106333:	68 8e 93 10 80       	push   $0x8010938e
80106338:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010633b:	50                   	push   %eax
8010633c:	e8 f5 be ff ff       	call   80102236 <namecmp>
80106341:	83 c4 10             	add    $0x10,%esp
80106344:	85 c0                	test   %eax,%eax
80106346:	0f 84 4a 01 00 00    	je     80106496 <sys_unlink+0x1c9>
8010634c:	83 ec 08             	sub    $0x8,%esp
8010634f:	68 90 93 10 80       	push   $0x80109390
80106354:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106357:	50                   	push   %eax
80106358:	e8 d9 be ff ff       	call   80102236 <namecmp>
8010635d:	83 c4 10             	add    $0x10,%esp
80106360:	85 c0                	test   %eax,%eax
80106362:	0f 84 2e 01 00 00    	je     80106496 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106368:	83 ec 04             	sub    $0x4,%esp
8010636b:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010636e:	50                   	push   %eax
8010636f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106372:	50                   	push   %eax
80106373:	ff 75 f4             	pushl  -0xc(%ebp)
80106376:	e8 d6 be ff ff       	call   80102251 <dirlookup>
8010637b:	83 c4 10             	add    $0x10,%esp
8010637e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106381:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106385:	75 05                	jne    8010638c <sys_unlink+0xbf>
    goto bad;
80106387:	e9 0a 01 00 00       	jmp    80106496 <sys_unlink+0x1c9>
  ilock(ip);
8010638c:	83 ec 0c             	sub    $0xc,%esp
8010638f:	ff 75 f0             	pushl  -0x10(%ebp)
80106392:	e8 f4 b5 ff ff       	call   8010198b <ilock>
80106397:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
8010639a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010639d:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801063a1:	66 85 c0             	test   %ax,%ax
801063a4:	7f 0d                	jg     801063b3 <sys_unlink+0xe6>
    panic("unlink: nlink < 1");
801063a6:	83 ec 0c             	sub    $0xc,%esp
801063a9:	68 93 93 10 80       	push   $0x80109393
801063ae:	e8 f0 a1 ff ff       	call   801005a3 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801063b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063b6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801063ba:	66 83 f8 01          	cmp    $0x1,%ax
801063be:	75 25                	jne    801063e5 <sys_unlink+0x118>
801063c0:	83 ec 0c             	sub    $0xc,%esp
801063c3:	ff 75 f0             	pushl  -0x10(%ebp)
801063c6:	e8 9f fe ff ff       	call   8010626a <isdirempty>
801063cb:	83 c4 10             	add    $0x10,%esp
801063ce:	85 c0                	test   %eax,%eax
801063d0:	75 13                	jne    801063e5 <sys_unlink+0x118>
    iunlockput(ip);
801063d2:	83 ec 0c             	sub    $0xc,%esp
801063d5:	ff 75 f0             	pushl  -0x10(%ebp)
801063d8:	e8 93 b8 ff ff       	call   80101c70 <iunlockput>
801063dd:	83 c4 10             	add    $0x10,%esp
    goto bad;
801063e0:	e9 b1 00 00 00       	jmp    80106496 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
801063e5:	83 ec 04             	sub    $0x4,%esp
801063e8:	6a 10                	push   $0x10
801063ea:	6a 00                	push   $0x0
801063ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
801063ef:	50                   	push   %eax
801063f0:	e8 70 f3 ff ff       	call   80105765 <memset>
801063f5:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801063f8:	8b 45 c8             	mov    -0x38(%ebp),%eax
801063fb:	6a 10                	push   $0x10
801063fd:	50                   	push   %eax
801063fe:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106401:	50                   	push   %eax
80106402:	ff 75 f4             	pushl  -0xc(%ebp)
80106405:	e8 9a bc ff ff       	call   801020a4 <writei>
8010640a:	83 c4 10             	add    $0x10,%esp
8010640d:	83 f8 10             	cmp    $0x10,%eax
80106410:	74 0d                	je     8010641f <sys_unlink+0x152>
    panic("unlink: writei");
80106412:	83 ec 0c             	sub    $0xc,%esp
80106415:	68 a5 93 10 80       	push   $0x801093a5
8010641a:	e8 84 a1 ff ff       	call   801005a3 <panic>
  if(ip->type == T_DIR){
8010641f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106422:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106426:	66 83 f8 01          	cmp    $0x1,%ax
8010642a:	75 21                	jne    8010644d <sys_unlink+0x180>
    dp->nlink--;
8010642c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010642f:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106433:	83 e8 01             	sub    $0x1,%eax
80106436:	89 c2                	mov    %eax,%edx
80106438:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010643b:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010643f:	83 ec 0c             	sub    $0xc,%esp
80106442:	ff 75 f4             	pushl  -0xc(%ebp)
80106445:	e8 40 b3 ff ff       	call   8010178a <iupdate>
8010644a:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
8010644d:	83 ec 0c             	sub    $0xc,%esp
80106450:	ff 75 f4             	pushl  -0xc(%ebp)
80106453:	e8 18 b8 ff ff       	call   80101c70 <iunlockput>
80106458:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
8010645b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010645e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106462:	83 e8 01             	sub    $0x1,%eax
80106465:	89 c2                	mov    %eax,%edx
80106467:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010646a:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010646e:	83 ec 0c             	sub    $0xc,%esp
80106471:	ff 75 f0             	pushl  -0x10(%ebp)
80106474:	e8 11 b3 ff ff       	call   8010178a <iupdate>
80106479:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010647c:	83 ec 0c             	sub    $0xc,%esp
8010647f:	ff 75 f0             	pushl  -0x10(%ebp)
80106482:	e8 e9 b7 ff ff       	call   80101c70 <iunlockput>
80106487:	83 c4 10             	add    $0x10,%esp

  end_op();
8010648a:	e8 7d d4 ff ff       	call   8010390c <end_op>

  return 0;
8010648f:	b8 00 00 00 00       	mov    $0x0,%eax
80106494:	eb 18                	jmp    801064ae <sys_unlink+0x1e1>

bad:
  iunlockput(dp);
80106496:	83 ec 0c             	sub    $0xc,%esp
80106499:	ff 75 f4             	pushl  -0xc(%ebp)
8010649c:	e8 cf b7 ff ff       	call   80101c70 <iunlockput>
801064a1:	83 c4 10             	add    $0x10,%esp
  end_op();
801064a4:	e8 63 d4 ff ff       	call   8010390c <end_op>
  return -1;
801064a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064ae:	c9                   	leave  
801064af:	c3                   	ret    

801064b0 <create>:

//20160313--
static struct inode*
create(char *path, short type, short major, short minor)
{
801064b0:	55                   	push   %ebp
801064b1:	89 e5                	mov    %esp,%ebp
801064b3:	83 ec 38             	sub    $0x38,%esp
801064b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801064b9:	8b 55 10             	mov    0x10(%ebp),%edx
801064bc:	8b 45 14             	mov    0x14(%ebp),%eax
801064bf:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
801064c3:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801064c7:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801064cb:	83 ec 08             	sub    $0x8,%esp
801064ce:	8d 45 de             	lea    -0x22(%ebp),%eax
801064d1:	50                   	push   %eax
801064d2:	ff 75 08             	pushl  0x8(%ebp)
801064d5:	e8 f6 c0 ff ff       	call   801025d0 <nameiparent>
801064da:	83 c4 10             	add    $0x10,%esp
801064dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064e4:	75 0a                	jne    801064f0 <create+0x40>
    return 0;
801064e6:	b8 00 00 00 00       	mov    $0x0,%eax
801064eb:	e9 90 01 00 00       	jmp    80106680 <create+0x1d0>
  ilock(dp);
801064f0:	83 ec 0c             	sub    $0xc,%esp
801064f3:	ff 75 f4             	pushl  -0xc(%ebp)
801064f6:	e8 90 b4 ff ff       	call   8010198b <ilock>
801064fb:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
801064fe:	83 ec 04             	sub    $0x4,%esp
80106501:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106504:	50                   	push   %eax
80106505:	8d 45 de             	lea    -0x22(%ebp),%eax
80106508:	50                   	push   %eax
80106509:	ff 75 f4             	pushl  -0xc(%ebp)
8010650c:	e8 40 bd ff ff       	call   80102251 <dirlookup>
80106511:	83 c4 10             	add    $0x10,%esp
80106514:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106517:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010651b:	74 50                	je     8010656d <create+0xbd>
    iunlockput(dp);
8010651d:	83 ec 0c             	sub    $0xc,%esp
80106520:	ff 75 f4             	pushl  -0xc(%ebp)
80106523:	e8 48 b7 ff ff       	call   80101c70 <iunlockput>
80106528:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
8010652b:	83 ec 0c             	sub    $0xc,%esp
8010652e:	ff 75 f0             	pushl  -0x10(%ebp)
80106531:	e8 55 b4 ff ff       	call   8010198b <ilock>
80106536:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80106539:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010653e:	75 15                	jne    80106555 <create+0xa5>
80106540:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106543:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106547:	66 83 f8 02          	cmp    $0x2,%ax
8010654b:	75 08                	jne    80106555 <create+0xa5>
      return ip;
8010654d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106550:	e9 2b 01 00 00       	jmp    80106680 <create+0x1d0>
    iunlockput(ip);
80106555:	83 ec 0c             	sub    $0xc,%esp
80106558:	ff 75 f0             	pushl  -0x10(%ebp)
8010655b:	e8 10 b7 ff ff       	call   80101c70 <iunlockput>
80106560:	83 c4 10             	add    $0x10,%esp
    return 0;
80106563:	b8 00 00 00 00       	mov    $0x0,%eax
80106568:	e9 13 01 00 00       	jmp    80106680 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
8010656d:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80106571:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106574:	8b 00                	mov    (%eax),%eax
80106576:	83 ec 08             	sub    $0x8,%esp
80106579:	52                   	push   %edx
8010657a:	50                   	push   %eax
8010657b:	e8 34 b1 ff ff       	call   801016b4 <ialloc>
80106580:	83 c4 10             	add    $0x10,%esp
80106583:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106586:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010658a:	75 0d                	jne    80106599 <create+0xe9>
    panic("create: ialloc");
8010658c:	83 ec 0c             	sub    $0xc,%esp
8010658f:	68 b4 93 10 80       	push   $0x801093b4
80106594:	e8 0a a0 ff ff       	call   801005a3 <panic>

  ilock(ip);
80106599:	83 ec 0c             	sub    $0xc,%esp
8010659c:	ff 75 f0             	pushl  -0x10(%ebp)
8010659f:	e8 e7 b3 ff ff       	call   8010198b <ilock>
801065a4:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
801065a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065aa:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801065ae:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
801065b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065b5:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801065b9:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
801065bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065c0:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
801065c6:	83 ec 0c             	sub    $0xc,%esp
801065c9:	ff 75 f0             	pushl  -0x10(%ebp)
801065cc:	e8 b9 b1 ff ff       	call   8010178a <iupdate>
801065d1:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
801065d4:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801065d9:	75 6a                	jne    80106645 <create+0x195>
    dp->nlink++;  // for ".."
801065db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065de:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801065e2:	83 c0 01             	add    $0x1,%eax
801065e5:	89 c2                	mov    %eax,%edx
801065e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065ea:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801065ee:	83 ec 0c             	sub    $0xc,%esp
801065f1:	ff 75 f4             	pushl  -0xc(%ebp)
801065f4:	e8 91 b1 ff ff       	call   8010178a <iupdate>
801065f9:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801065fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065ff:	8b 40 04             	mov    0x4(%eax),%eax
80106602:	83 ec 04             	sub    $0x4,%esp
80106605:	50                   	push   %eax
80106606:	68 8e 93 10 80       	push   $0x8010938e
8010660b:	ff 75 f0             	pushl  -0x10(%ebp)
8010660e:	e8 f9 bc ff ff       	call   8010230c <dirlink>
80106613:	83 c4 10             	add    $0x10,%esp
80106616:	85 c0                	test   %eax,%eax
80106618:	78 1e                	js     80106638 <create+0x188>
8010661a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010661d:	8b 40 04             	mov    0x4(%eax),%eax
80106620:	83 ec 04             	sub    $0x4,%esp
80106623:	50                   	push   %eax
80106624:	68 90 93 10 80       	push   $0x80109390
80106629:	ff 75 f0             	pushl  -0x10(%ebp)
8010662c:	e8 db bc ff ff       	call   8010230c <dirlink>
80106631:	83 c4 10             	add    $0x10,%esp
80106634:	85 c0                	test   %eax,%eax
80106636:	79 0d                	jns    80106645 <create+0x195>
      panic("create dots");
80106638:	83 ec 0c             	sub    $0xc,%esp
8010663b:	68 c3 93 10 80       	push   $0x801093c3
80106640:	e8 5e 9f ff ff       	call   801005a3 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106645:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106648:	8b 40 04             	mov    0x4(%eax),%eax
8010664b:	83 ec 04             	sub    $0x4,%esp
8010664e:	50                   	push   %eax
8010664f:	8d 45 de             	lea    -0x22(%ebp),%eax
80106652:	50                   	push   %eax
80106653:	ff 75 f4             	pushl  -0xc(%ebp)
80106656:	e8 b1 bc ff ff       	call   8010230c <dirlink>
8010665b:	83 c4 10             	add    $0x10,%esp
8010665e:	85 c0                	test   %eax,%eax
80106660:	79 0d                	jns    8010666f <create+0x1bf>
    panic("create: dirlink");
80106662:	83 ec 0c             	sub    $0xc,%esp
80106665:	68 cf 93 10 80       	push   $0x801093cf
8010666a:	e8 34 9f ff ff       	call   801005a3 <panic>

  iunlockput(dp);
8010666f:	83 ec 0c             	sub    $0xc,%esp
80106672:	ff 75 f4             	pushl  -0xc(%ebp)
80106675:	e8 f6 b5 ff ff       	call   80101c70 <iunlockput>
8010667a:	83 c4 10             	add    $0x10,%esp

  return ip;
8010667d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106680:	c9                   	leave  
80106681:	c3                   	ret    

80106682 <sys_open>:

//20160313--
int
sys_open(void)
{
80106682:	55                   	push   %ebp
80106683:	89 e5                	mov    %esp,%ebp
80106685:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106688:	83 ec 08             	sub    $0x8,%esp
8010668b:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010668e:	50                   	push   %eax
8010668f:	6a 00                	push   $0x0
80106691:	e8 68 f4 ff ff       	call   80105afe <argstr>
80106696:	83 c4 10             	add    $0x10,%esp
80106699:	85 c0                	test   %eax,%eax
8010669b:	78 15                	js     801066b2 <sys_open+0x30>
8010669d:	83 ec 08             	sub    $0x8,%esp
801066a0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801066a3:	50                   	push   %eax
801066a4:	6a 01                	push   $0x1
801066a6:	e8 cc f3 ff ff       	call   80105a77 <argint>
801066ab:	83 c4 10             	add    $0x10,%esp
801066ae:	85 c0                	test   %eax,%eax
801066b0:	79 0a                	jns    801066bc <sys_open+0x3a>
    return -1;
801066b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066b7:	e9 61 01 00 00       	jmp    8010681d <sys_open+0x19b>

  begin_op();
801066bc:	e8 bd d1 ff ff       	call   8010387e <begin_op>

  if(omode & O_CREATE){
801066c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066c4:	25 00 02 00 00       	and    $0x200,%eax
801066c9:	85 c0                	test   %eax,%eax
801066cb:	74 2a                	je     801066f7 <sys_open+0x75>
//20160313--
    ip = create(path, T_FILE, 0, 0);
801066cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
801066d0:	6a 00                	push   $0x0
801066d2:	6a 00                	push   $0x0
801066d4:	6a 02                	push   $0x2
801066d6:	50                   	push   %eax
801066d7:	e8 d4 fd ff ff       	call   801064b0 <create>
801066dc:	83 c4 10             	add    $0x10,%esp
801066df:	89 45 f4             	mov    %eax,-0xc(%ebp)
//ip=0;
    if(ip == 0){
801066e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066e6:	75 75                	jne    8010675d <sys_open+0xdb>
      end_op();
801066e8:	e8 1f d2 ff ff       	call   8010390c <end_op>
      return -1;
801066ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066f2:	e9 26 01 00 00       	jmp    8010681d <sys_open+0x19b>
    }
  } else {
//20160313--
    if((ip = namei(path)) == 0){
801066f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801066fa:	83 ec 0c             	sub    $0xc,%esp
801066fd:	50                   	push   %eax
801066fe:	e8 b1 be ff ff       	call   801025b4 <namei>
80106703:	83 c4 10             	add    $0x10,%esp
80106706:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106709:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010670d:	75 0f                	jne    8010671e <sys_open+0x9c>
//ip=0;
//    if(ip == 0){
      end_op();
8010670f:	e8 f8 d1 ff ff       	call   8010390c <end_op>
      return -1;
80106714:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106719:	e9 ff 00 00 00       	jmp    8010681d <sys_open+0x19b>
    }
    ilock(ip);
8010671e:	83 ec 0c             	sub    $0xc,%esp
80106721:	ff 75 f4             	pushl  -0xc(%ebp)
80106724:	e8 62 b2 ff ff       	call   8010198b <ilock>
80106729:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
8010672c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010672f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106733:	66 83 f8 01          	cmp    $0x1,%ax
80106737:	75 24                	jne    8010675d <sys_open+0xdb>
80106739:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010673c:	85 c0                	test   %eax,%eax
8010673e:	74 1d                	je     8010675d <sys_open+0xdb>
      iunlockput(ip);
80106740:	83 ec 0c             	sub    $0xc,%esp
80106743:	ff 75 f4             	pushl  -0xc(%ebp)
80106746:	e8 25 b5 ff ff       	call   80101c70 <iunlockput>
8010674b:	83 c4 10             	add    $0x10,%esp
      end_op();
8010674e:	e8 b9 d1 ff ff       	call   8010390c <end_op>
      return -1;
80106753:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106758:	e9 c0 00 00 00       	jmp    8010681d <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010675d:	e8 40 a8 ff ff       	call   80100fa2 <filealloc>
80106762:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106765:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106769:	74 17                	je     80106782 <sys_open+0x100>
8010676b:	83 ec 0c             	sub    $0xc,%esp
8010676e:	ff 75 f0             	pushl  -0x10(%ebp)
80106771:	e8 36 f7 ff ff       	call   80105eac <fdalloc>
80106776:	83 c4 10             	add    $0x10,%esp
80106779:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010677c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106780:	79 2e                	jns    801067b0 <sys_open+0x12e>
    if(f)
80106782:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106786:	74 0e                	je     80106796 <sys_open+0x114>
      fileclose(f);
80106788:	83 ec 0c             	sub    $0xc,%esp
8010678b:	ff 75 f0             	pushl  -0x10(%ebp)
8010678e:	e8 cc a8 ff ff       	call   8010105f <fileclose>
80106793:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106796:	83 ec 0c             	sub    $0xc,%esp
80106799:	ff 75 f4             	pushl  -0xc(%ebp)
8010679c:	e8 cf b4 ff ff       	call   80101c70 <iunlockput>
801067a1:	83 c4 10             	add    $0x10,%esp
    end_op();
801067a4:	e8 63 d1 ff ff       	call   8010390c <end_op>
    return -1;
801067a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067ae:	eb 6d                	jmp    8010681d <sys_open+0x19b>
  }
  iunlock(ip);
801067b0:	83 ec 0c             	sub    $0xc,%esp
801067b3:	ff 75 f4             	pushl  -0xc(%ebp)
801067b6:	e8 55 b3 ff ff       	call   80101b10 <iunlock>
801067bb:	83 c4 10             	add    $0x10,%esp
  end_op();
801067be:	e8 49 d1 ff ff       	call   8010390c <end_op>

  f->type = FD_INODE;
801067c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067c6:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801067cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801067d2:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801067d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067d8:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801067df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067e2:	83 e0 01             	and    $0x1,%eax
801067e5:	85 c0                	test   %eax,%eax
801067e7:	0f 94 c0             	sete   %al
801067ea:	89 c2                	mov    %eax,%edx
801067ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067ef:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801067f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067f5:	83 e0 01             	and    $0x1,%eax
801067f8:	85 c0                	test   %eax,%eax
801067fa:	75 0a                	jne    80106806 <sys_open+0x184>
801067fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067ff:	83 e0 02             	and    $0x2,%eax
80106802:	85 c0                	test   %eax,%eax
80106804:	74 07                	je     8010680d <sys_open+0x18b>
80106806:	b8 01 00 00 00       	mov    $0x1,%eax
8010680b:	eb 05                	jmp    80106812 <sys_open+0x190>
8010680d:	b8 00 00 00 00       	mov    $0x0,%eax
80106812:	89 c2                	mov    %eax,%edx
80106814:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106817:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010681a:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010681d:	c9                   	leave  
8010681e:	c3                   	ret    

8010681f <sys_mkdir>:

//20160313--
int
sys_mkdir(void)
{
8010681f:	55                   	push   %ebp
80106820:	89 e5                	mov    %esp,%ebp
80106822:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106825:	e8 54 d0 ff ff       	call   8010387e <begin_op>
//20160313--
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010682a:	83 ec 08             	sub    $0x8,%esp
8010682d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106830:	50                   	push   %eax
80106831:	6a 00                	push   $0x0
80106833:	e8 c6 f2 ff ff       	call   80105afe <argstr>
80106838:	83 c4 10             	add    $0x10,%esp
8010683b:	85 c0                	test   %eax,%eax
8010683d:	78 1b                	js     8010685a <sys_mkdir+0x3b>
8010683f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106842:	6a 00                	push   $0x0
80106844:	6a 00                	push   $0x0
80106846:	6a 01                	push   $0x1
80106848:	50                   	push   %eax
80106849:	e8 62 fc ff ff       	call   801064b0 <create>
8010684e:	83 c4 10             	add    $0x10,%esp
80106851:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106854:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106858:	75 0c                	jne    80106866 <sys_mkdir+0x47>
//ip=0;
//  if(argstr(0, &path) < 0 || (ip == 0)){
    end_op();
8010685a:	e8 ad d0 ff ff       	call   8010390c <end_op>
    return -1;
8010685f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106864:	eb 18                	jmp    8010687e <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80106866:	83 ec 0c             	sub    $0xc,%esp
80106869:	ff 75 f4             	pushl  -0xc(%ebp)
8010686c:	e8 ff b3 ff ff       	call   80101c70 <iunlockput>
80106871:	83 c4 10             	add    $0x10,%esp
  end_op();
80106874:	e8 93 d0 ff ff       	call   8010390c <end_op>
  return 0;
80106879:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010687e:	c9                   	leave  
8010687f:	c3                   	ret    

80106880 <sys_mknod>:

//20160313--
int
sys_mknod(void)
{
80106880:	55                   	push   %ebp
80106881:	89 e5                	mov    %esp,%ebp
80106883:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106886:	e8 f3 cf ff ff       	call   8010387e <begin_op>
//20160313
//ip=0;
  if((len=argstr(0, &path)) < 0 ||
8010688b:	83 ec 08             	sub    $0x8,%esp
8010688e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106891:	50                   	push   %eax
80106892:	6a 00                	push   $0x0
80106894:	e8 65 f2 ff ff       	call   80105afe <argstr>
80106899:	83 c4 10             	add    $0x10,%esp
8010689c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010689f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801068a3:	78 4f                	js     801068f4 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
801068a5:	83 ec 08             	sub    $0x8,%esp
801068a8:	8d 45 e8             	lea    -0x18(%ebp),%eax
801068ab:	50                   	push   %eax
801068ac:	6a 01                	push   $0x1
801068ae:	e8 c4 f1 ff ff       	call   80105a77 <argint>
801068b3:	83 c4 10             	add    $0x10,%esp
  int major, minor;
  
  begin_op();
//20160313
//ip=0;
  if((len=argstr(0, &path)) < 0 ||
801068b6:	85 c0                	test   %eax,%eax
801068b8:	78 3a                	js     801068f4 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801068ba:	83 ec 08             	sub    $0x8,%esp
801068bd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801068c0:	50                   	push   %eax
801068c1:	6a 02                	push   $0x2
801068c3:	e8 af f1 ff ff       	call   80105a77 <argint>
801068c8:	83 c4 10             	add    $0x10,%esp
  
  begin_op();
//20160313
//ip=0;
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801068cb:	85 c0                	test   %eax,%eax
801068cd:	78 25                	js     801068f4 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
//20160313--
     (ip = create(path, T_DEV, major, minor)) == 0){
801068cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068d2:	0f bf c8             	movswl %ax,%ecx
801068d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801068d8:	0f bf d0             	movswl %ax,%edx
801068db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  begin_op();
//20160313
//ip=0;
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801068de:	51                   	push   %ecx
801068df:	52                   	push   %edx
801068e0:	6a 03                	push   $0x3
801068e2:	50                   	push   %eax
801068e3:	e8 c8 fb ff ff       	call   801064b0 <create>
801068e8:	83 c4 10             	add    $0x10,%esp
801068eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
801068ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801068f2:	75 0c                	jne    80106900 <sys_mknod+0x80>
//20160313--
     (ip = create(path, T_DEV, major, minor)) == 0){
//     (ip == 0)){
    end_op();
801068f4:	e8 13 d0 ff ff       	call   8010390c <end_op>
    return -1;
801068f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068fe:	eb 18                	jmp    80106918 <sys_mknod+0x98>
  }
  iunlockput(ip);
80106900:	83 ec 0c             	sub    $0xc,%esp
80106903:	ff 75 f0             	pushl  -0x10(%ebp)
80106906:	e8 65 b3 ff ff       	call   80101c70 <iunlockput>
8010690b:	83 c4 10             	add    $0x10,%esp
  end_op();
8010690e:	e8 f9 cf ff ff       	call   8010390c <end_op>
  return 0;
80106913:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106918:	c9                   	leave  
80106919:	c3                   	ret    

8010691a <sys_chdir>:

//20160313--
int
sys_chdir(void)
{
8010691a:	55                   	push   %ebp
8010691b:	89 e5                	mov    %esp,%ebp
8010691d:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106920:	e8 59 cf ff ff       	call   8010387e <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106925:	83 ec 08             	sub    $0x8,%esp
80106928:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010692b:	50                   	push   %eax
8010692c:	6a 00                	push   $0x0
8010692e:	e8 cb f1 ff ff       	call   80105afe <argstr>
80106933:	83 c4 10             	add    $0x10,%esp
80106936:	85 c0                	test   %eax,%eax
80106938:	78 18                	js     80106952 <sys_chdir+0x38>
8010693a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010693d:	83 ec 0c             	sub    $0xc,%esp
80106940:	50                   	push   %eax
80106941:	e8 6e bc ff ff       	call   801025b4 <namei>
80106946:	83 c4 10             	add    $0x10,%esp
80106949:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010694c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106950:	75 0c                	jne    8010695e <sys_chdir+0x44>
    end_op();
80106952:	e8 b5 cf ff ff       	call   8010390c <end_op>
    return -1;
80106957:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010695c:	eb 6e                	jmp    801069cc <sys_chdir+0xb2>
  }
  ilock(ip);
8010695e:	83 ec 0c             	sub    $0xc,%esp
80106961:	ff 75 f4             	pushl  -0xc(%ebp)
80106964:	e8 22 b0 ff ff       	call   8010198b <ilock>
80106969:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
8010696c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010696f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106973:	66 83 f8 01          	cmp    $0x1,%ax
80106977:	74 1a                	je     80106993 <sys_chdir+0x79>
    iunlockput(ip);
80106979:	83 ec 0c             	sub    $0xc,%esp
8010697c:	ff 75 f4             	pushl  -0xc(%ebp)
8010697f:	e8 ec b2 ff ff       	call   80101c70 <iunlockput>
80106984:	83 c4 10             	add    $0x10,%esp
    end_op();
80106987:	e8 80 cf ff ff       	call   8010390c <end_op>
    return -1;
8010698c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106991:	eb 39                	jmp    801069cc <sys_chdir+0xb2>
  }
  iunlock(ip);
80106993:	83 ec 0c             	sub    $0xc,%esp
80106996:	ff 75 f4             	pushl  -0xc(%ebp)
80106999:	e8 72 b1 ff ff       	call   80101b10 <iunlock>
8010699e:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
801069a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069a7:	8b 40 68             	mov    0x68(%eax),%eax
801069aa:	83 ec 0c             	sub    $0xc,%esp
801069ad:	50                   	push   %eax
801069ae:	e8 ce b1 ff ff       	call   80101b81 <iput>
801069b3:	83 c4 10             	add    $0x10,%esp
  end_op();
801069b6:	e8 51 cf ff ff       	call   8010390c <end_op>
  proc->cwd = ip;
801069bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801069c4:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801069c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069cc:	c9                   	leave  
801069cd:	c3                   	ret    

801069ce <sys_exec>:

//20160313--
int
sys_exec(void)
{
801069ce:	55                   	push   %ebp
801069cf:	89 e5                	mov    %esp,%ebp
801069d1:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801069d7:	83 ec 08             	sub    $0x8,%esp
801069da:	8d 45 f0             	lea    -0x10(%ebp),%eax
801069dd:	50                   	push   %eax
801069de:	6a 00                	push   $0x0
801069e0:	e8 19 f1 ff ff       	call   80105afe <argstr>
801069e5:	83 c4 10             	add    $0x10,%esp
801069e8:	85 c0                	test   %eax,%eax
801069ea:	78 18                	js     80106a04 <sys_exec+0x36>
801069ec:	83 ec 08             	sub    $0x8,%esp
801069ef:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801069f5:	50                   	push   %eax
801069f6:	6a 01                	push   $0x1
801069f8:	e8 7a f0 ff ff       	call   80105a77 <argint>
801069fd:	83 c4 10             	add    $0x10,%esp
80106a00:	85 c0                	test   %eax,%eax
80106a02:	79 0a                	jns    80106a0e <sys_exec+0x40>
    return -1;
80106a04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a09:	e9 c6 00 00 00       	jmp    80106ad4 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80106a0e:	83 ec 04             	sub    $0x4,%esp
80106a11:	68 80 00 00 00       	push   $0x80
80106a16:	6a 00                	push   $0x0
80106a18:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106a1e:	50                   	push   %eax
80106a1f:	e8 41 ed ff ff       	call   80105765 <memset>
80106a24:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80106a27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a31:	83 f8 1f             	cmp    $0x1f,%eax
80106a34:	76 0a                	jbe    80106a40 <sys_exec+0x72>
      return -1;
80106a36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a3b:	e9 94 00 00 00       	jmp    80106ad4 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a43:	c1 e0 02             	shl    $0x2,%eax
80106a46:	89 c2                	mov    %eax,%edx
80106a48:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106a4e:	01 c2                	add    %eax,%edx
80106a50:	83 ec 08             	sub    $0x8,%esp
80106a53:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106a59:	50                   	push   %eax
80106a5a:	52                   	push   %edx
80106a5b:	e8 7b ef ff ff       	call   801059db <fetchint>
80106a60:	83 c4 10             	add    $0x10,%esp
80106a63:	85 c0                	test   %eax,%eax
80106a65:	79 07                	jns    80106a6e <sys_exec+0xa0>
      return -1;
80106a67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a6c:	eb 66                	jmp    80106ad4 <sys_exec+0x106>
    if(uarg == 0){
80106a6e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106a74:	85 c0                	test   %eax,%eax
80106a76:	75 27                	jne    80106a9f <sys_exec+0xd1>
      argv[i] = 0;
80106a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a7b:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106a82:	00 00 00 00 
      break;
80106a86:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a8a:	83 ec 08             	sub    $0x8,%esp
80106a8d:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106a93:	52                   	push   %edx
80106a94:	50                   	push   %eax
80106a95:	e8 fc a0 ff ff       	call   80100b96 <exec>
80106a9a:	83 c4 10             	add    $0x10,%esp
80106a9d:	eb 35                	jmp    80106ad4 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106a9f:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106aa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106aa8:	c1 e2 02             	shl    $0x2,%edx
80106aab:	01 c2                	add    %eax,%edx
80106aad:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106ab3:	83 ec 08             	sub    $0x8,%esp
80106ab6:	52                   	push   %edx
80106ab7:	50                   	push   %eax
80106ab8:	e8 58 ef ff ff       	call   80105a15 <fetchstr>
80106abd:	83 c4 10             	add    $0x10,%esp
80106ac0:	85 c0                	test   %eax,%eax
80106ac2:	79 07                	jns    80106acb <sys_exec+0xfd>
      return -1;
80106ac4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ac9:	eb 09                	jmp    80106ad4 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106acb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106acf:	e9 5a ff ff ff       	jmp    80106a2e <sys_exec+0x60>
  return exec(path, argv);
}
80106ad4:	c9                   	leave  
80106ad5:	c3                   	ret    

80106ad6 <sys_pipe>:

int
sys_pipe(void)
{
80106ad6:	55                   	push   %ebp
80106ad7:	89 e5                	mov    %esp,%ebp
80106ad9:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106adc:	83 ec 04             	sub    $0x4,%esp
80106adf:	6a 08                	push   $0x8
80106ae1:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106ae4:	50                   	push   %eax
80106ae5:	6a 00                	push   $0x0
80106ae7:	e8 b3 ef ff ff       	call   80105a9f <argptr>
80106aec:	83 c4 10             	add    $0x10,%esp
80106aef:	85 c0                	test   %eax,%eax
80106af1:	79 0a                	jns    80106afd <sys_pipe+0x27>
    return -1;
80106af3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106af8:	e9 af 00 00 00       	jmp    80106bac <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80106afd:	83 ec 08             	sub    $0x8,%esp
80106b00:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106b03:	50                   	push   %eax
80106b04:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106b07:	50                   	push   %eax
80106b08:	e8 39 d6 ff ff       	call   80104146 <pipealloc>
80106b0d:	83 c4 10             	add    $0x10,%esp
80106b10:	85 c0                	test   %eax,%eax
80106b12:	79 0a                	jns    80106b1e <sys_pipe+0x48>
    return -1;
80106b14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b19:	e9 8e 00 00 00       	jmp    80106bac <sys_pipe+0xd6>
  fd0 = -1;
80106b1e:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106b25:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106b28:	83 ec 0c             	sub    $0xc,%esp
80106b2b:	50                   	push   %eax
80106b2c:	e8 7b f3 ff ff       	call   80105eac <fdalloc>
80106b31:	83 c4 10             	add    $0x10,%esp
80106b34:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106b37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106b3b:	78 18                	js     80106b55 <sys_pipe+0x7f>
80106b3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b40:	83 ec 0c             	sub    $0xc,%esp
80106b43:	50                   	push   %eax
80106b44:	e8 63 f3 ff ff       	call   80105eac <fdalloc>
80106b49:	83 c4 10             	add    $0x10,%esp
80106b4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106b4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106b53:	79 3f                	jns    80106b94 <sys_pipe+0xbe>
    if(fd0 >= 0)
80106b55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106b59:	78 14                	js     80106b6f <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80106b5b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b61:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106b64:	83 c2 08             	add    $0x8,%edx
80106b67:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106b6e:	00 
    fileclose(rf);
80106b6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106b72:	83 ec 0c             	sub    $0xc,%esp
80106b75:	50                   	push   %eax
80106b76:	e8 e4 a4 ff ff       	call   8010105f <fileclose>
80106b7b:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80106b7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b81:	83 ec 0c             	sub    $0xc,%esp
80106b84:	50                   	push   %eax
80106b85:	e8 d5 a4 ff ff       	call   8010105f <fileclose>
80106b8a:	83 c4 10             	add    $0x10,%esp
    return -1;
80106b8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b92:	eb 18                	jmp    80106bac <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80106b94:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106b97:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106b9a:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106b9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106b9f:	8d 50 04             	lea    0x4(%eax),%edx
80106ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ba5:	89 02                	mov    %eax,(%edx)
  return 0;
80106ba7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106bac:	c9                   	leave  
80106bad:	c3                   	ret    

80106bae <sys_chmod>:

int 
sys_chmod(void)
{
80106bae:	55                   	push   %ebp
80106baf:	89 e5                	mov    %esp,%ebp
80106bb1:	83 ec 18             	sub    $0x18,%esp
  char *path;
  int mode;
  struct inode *ip;
  if(argstr(0,&path)<0 || argint(1,&mode)<0)
80106bb4:	83 ec 08             	sub    $0x8,%esp
80106bb7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106bba:	50                   	push   %eax
80106bbb:	6a 00                	push   $0x0
80106bbd:	e8 3c ef ff ff       	call   80105afe <argstr>
80106bc2:	83 c4 10             	add    $0x10,%esp
80106bc5:	85 c0                	test   %eax,%eax
80106bc7:	78 15                	js     80106bde <sys_chmod+0x30>
80106bc9:	83 ec 08             	sub    $0x8,%esp
80106bcc:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106bcf:	50                   	push   %eax
80106bd0:	6a 01                	push   $0x1
80106bd2:	e8 a0 ee ff ff       	call   80105a77 <argint>
80106bd7:	83 c4 10             	add    $0x10,%esp
80106bda:	85 c0                	test   %eax,%eax
80106bdc:	79 0a                	jns    80106be8 <sys_chmod+0x3a>
    return -1;
80106bde:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106be3:	e9 80 00 00 00       	jmp    80106c68 <sys_chmod+0xba>

cprintf("sysfile.c::sys_chmod(void):%s %x\n",path,mode);
80106be8:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106bee:	83 ec 04             	sub    $0x4,%esp
80106bf1:	52                   	push   %edx
80106bf2:	50                   	push   %eax
80106bf3:	68 e0 93 10 80       	push   $0x801093e0
80106bf8:	e8 09 98 ff ff       	call   80100406 <cprintf>
80106bfd:	83 c4 10             	add    $0x10,%esp
  begin_op();
80106c00:	e8 79 cc ff ff       	call   8010387e <begin_op>
  if((ip=namei(path))==0){
80106c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c08:	83 ec 0c             	sub    $0xc,%esp
80106c0b:	50                   	push   %eax
80106c0c:	e8 a3 b9 ff ff       	call   801025b4 <namei>
80106c11:	83 c4 10             	add    $0x10,%esp
80106c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106c17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106c1b:	75 0c                	jne    80106c29 <sys_chmod+0x7b>
    end_op();
80106c1d:	e8 ea cc ff ff       	call   8010390c <end_op>
    return -1;
80106c22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c27:	eb 3f                	jmp    80106c68 <sys_chmod+0xba>
  }
  
  ilock(ip);
80106c29:	83 ec 0c             	sub    $0xc,%esp
80106c2c:	ff 75 f4             	pushl  -0xc(%ebp)
80106c2f:	e8 57 ad ff ff       	call   8010198b <ilock>
80106c34:	83 c4 10             	add    $0x10,%esp
  ip->mode=mode;
80106c37:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106c3a:	89 c2                	mov    %eax,%edx
80106c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c3f:	89 50 1c             	mov    %edx,0x1c(%eax)
  iupdate(ip);   //copy to disk
80106c42:	83 ec 0c             	sub    $0xc,%esp
80106c45:	ff 75 f4             	pushl  -0xc(%ebp)
80106c48:	e8 3d ab ff ff       	call   8010178a <iupdate>
80106c4d:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106c50:	83 ec 0c             	sub    $0xc,%esp
80106c53:	ff 75 f4             	pushl  -0xc(%ebp)
80106c56:	e8 15 b0 ff ff       	call   80101c70 <iunlockput>
80106c5b:	83 c4 10             	add    $0x10,%esp
  end_op();
80106c5e:	e8 a9 cc ff ff       	call   8010390c <end_op>
  return 0;
80106c63:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c68:	c9                   	leave  
80106c69:	c3                   	ret    

80106c6a <createTask>:
int iTaskcount;
int PriorityTable[3];
int iHighPriorityTask;
int iIndexPriority;

int createTask(int iPriority,int iTaskId,char *arg[]){
80106c6a:	55                   	push   %ebp
80106c6b:	89 e5                	mov    %esp,%ebp
  //Save priority
  arrTaskTable[iTaskcount].Priority = iPriority;
80106c6d:	8b 15 c0 5a 11 80    	mov    0x80115ac0,%edx
80106c73:	89 d0                	mov    %edx,%eax
80106c75:	c1 e0 02             	shl    $0x2,%eax
80106c78:	01 d0                	add    %edx,%eax
80106c7a:	c1 e0 02             	shl    $0x2,%eax
80106c7d:	8d 90 e0 5a 11 80    	lea    -0x7feea520(%eax),%edx
80106c83:	8b 45 08             	mov    0x8(%ebp),%eax
80106c86:	89 42 08             	mov    %eax,0x8(%edx)

  //Save task address
//  arrTaskTable[iTaskcount].ptrTask = ptrTask;

  //Save task ID
  arrTaskTable[iTaskcount].TaskId = iTaskId;
80106c89:	8b 15 c0 5a 11 80    	mov    0x80115ac0,%edx
80106c8f:	89 d0                	mov    %edx,%eax
80106c91:	c1 e0 02             	shl    $0x2,%eax
80106c94:	01 d0                	add    %edx,%eax
80106c96:	c1 e0 02             	shl    $0x2,%eax
80106c99:	83 c0 10             	add    $0x10,%eax
80106c9c:	8d 90 e0 5a 11 80    	lea    -0x7feea520(%eax),%edx
80106ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ca5:	89 02                	mov    %eax,(%edx)

  //Make the task ready
  arrTaskTable[iTaskcount].Ready = 1;
80106ca7:	8b 15 c0 5a 11 80    	mov    0x80115ac0,%edx
80106cad:	89 d0                	mov    %edx,%eax
80106caf:	c1 e0 02             	shl    $0x2,%eax
80106cb2:	01 d0                	add    %edx,%eax
80106cb4:	c1 e0 02             	shl    $0x2,%eax
80106cb7:	05 e0 5a 11 80       	add    $0x80115ae0,%eax
80106cbc:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)

  arrTaskTable[iTaskcount].argv[0]=arg[0];
80106cc3:	8b 15 c0 5a 11 80    	mov    0x80115ac0,%edx
80106cc9:	8b 45 10             	mov    0x10(%ebp),%eax
80106ccc:	8b 08                	mov    (%eax),%ecx
80106cce:	89 d0                	mov    %edx,%eax
80106cd0:	c1 e0 02             	shl    $0x2,%eax
80106cd3:	01 d0                	add    %edx,%eax
80106cd5:	c1 e0 02             	shl    $0x2,%eax
80106cd8:	05 e0 5a 11 80       	add    $0x80115ae0,%eax
80106cdd:	89 08                	mov    %ecx,(%eax)
  arrTaskTable[iTaskcount].argv[1]=arg[1];
80106cdf:	8b 15 c0 5a 11 80    	mov    0x80115ac0,%edx
80106ce5:	8b 45 10             	mov    0x10(%ebp),%eax
80106ce8:	8b 48 04             	mov    0x4(%eax),%ecx
80106ceb:	89 d0                	mov    %edx,%eax
80106ced:	c1 e0 02             	shl    $0x2,%eax
80106cf0:	01 d0                	add    %edx,%eax
80106cf2:	c1 e0 02             	shl    $0x2,%eax
80106cf5:	83 c0 04             	add    $0x4,%eax
80106cf8:	05 e0 5a 11 80       	add    $0x80115ae0,%eax
80106cfd:	89 08                	mov    %ecx,(%eax)

  //Increment iTaskcount
  iTaskcount ++;
80106cff:	a1 c0 5a 11 80       	mov    0x80115ac0,%eax
80106d04:	83 c0 01             	add    $0x1,%eax
80106d07:	a3 c0 5a 11 80       	mov    %eax,0x80115ac0

  return 0;
80106d0c:	b8 00 00 00 00       	mov    $0x0,%eax
}//end createTask()
80106d11:	5d                   	pop    %ebp
80106d12:	c3                   	ret    

80106d13 <startTask>:

int startTask(int TaskId){
80106d13:	55                   	push   %ebp
80106d14:	89 e5                	mov    %esp,%ebp
80106d16:	83 ec 18             	sub    $0x18,%esp
  int iIndex;

  for(iIndex = 0; iIndex < iTaskcount; iIndex++){
80106d19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106d20:	eb 39                	jmp    80106d5b <startTask+0x48>
    if(TaskId == arrTaskTable[iIndex].TaskId){
80106d22:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106d25:	89 d0                	mov    %edx,%eax
80106d27:	c1 e0 02             	shl    $0x2,%eax
80106d2a:	01 d0                	add    %edx,%eax
80106d2c:	c1 e0 02             	shl    $0x2,%eax
80106d2f:	83 c0 10             	add    $0x10,%eax
80106d32:	05 e0 5a 11 80       	add    $0x80115ae0,%eax
80106d37:	8b 00                	mov    (%eax),%eax
80106d39:	3b 45 08             	cmp    0x8(%ebp),%eax
80106d3c:	75 19                	jne    80106d57 <startTask+0x44>
      arrTaskTable[iIndex].Ready = 1;
80106d3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106d41:	89 d0                	mov    %edx,%eax
80106d43:	c1 e0 02             	shl    $0x2,%eax
80106d46:	01 d0                	add    %edx,%eax
80106d48:	c1 e0 02             	shl    $0x2,%eax
80106d4b:	05 e0 5a 11 80       	add    $0x80115ae0,%eax
80106d50:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
}//end createTask()

int startTask(int TaskId){
  int iIndex;

  for(iIndex = 0; iIndex < iTaskcount; iIndex++){
80106d57:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106d5b:	a1 c0 5a 11 80       	mov    0x80115ac0,%eax
80106d60:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80106d63:	7c bd                	jl     80106d22 <startTask+0xf>
      arrTaskTable[iIndex].Ready = 1;
    }
  }

  //Call Sched
  Sched();
80106d65:	e8 35 00 00 00       	call   80106d9f <Sched>
  return 0;
80106d6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106d6f:	c9                   	leave  
80106d70:	c3                   	ret    

80106d71 <waitTask>:

int waitTask(void){
80106d71:	55                   	push   %ebp
80106d72:	89 e5                	mov    %esp,%ebp
80106d74:	83 ec 08             	sub    $0x8,%esp
  arrTaskTable[iIndexPriority].Ready = 0;
80106d77:	8b 15 c4 5a 11 80    	mov    0x80115ac4,%edx
80106d7d:	89 d0                	mov    %edx,%eax
80106d7f:	c1 e0 02             	shl    $0x2,%eax
80106d82:	01 d0                	add    %edx,%eax
80106d84:	c1 e0 02             	shl    $0x2,%eax
80106d87:	05 e0 5a 11 80       	add    $0x80115ae0,%eax
80106d8c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  Sched();
80106d93:	e8 07 00 00 00       	call   80106d9f <Sched>
  return 0;
80106d98:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106d9d:	c9                   	leave  
80106d9e:	c3                   	ret    

80106d9f <Sched>:

int Sched(void){
80106d9f:	55                   	push   %ebp
80106da0:	89 e5                	mov    %esp,%ebp
80106da2:	83 ec 18             	sub    $0x18,%esp
  int iIndex;

  //Select task with high priority
  iHighPriorityTask = 10;
80106da5:	c7 05 1c 5b 11 80 0a 	movl   $0xa,0x80115b1c
80106dac:	00 00 00 

  for(iIndex = 0; iIndex < iTaskcount; iIndex++){
80106daf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106db6:	eb 5e                	jmp    80106e16 <Sched+0x77>
    if((arrTaskTable[iIndex].Priority <= iHighPriorityTask) &&
80106db8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106dbb:	89 d0                	mov    %edx,%eax
80106dbd:	c1 e0 02             	shl    $0x2,%eax
80106dc0:	01 d0                	add    %edx,%eax
80106dc2:	c1 e0 02             	shl    $0x2,%eax
80106dc5:	05 e0 5a 11 80       	add    $0x80115ae0,%eax
80106dca:	8b 50 08             	mov    0x8(%eax),%edx
80106dcd:	a1 1c 5b 11 80       	mov    0x80115b1c,%eax
80106dd2:	39 c2                	cmp    %eax,%edx
80106dd4:	7f 3c                	jg     80106e12 <Sched+0x73>
                            (arrTaskTable[iIndex].Ready == 1)){
80106dd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106dd9:	89 d0                	mov    %edx,%eax
80106ddb:	c1 e0 02             	shl    $0x2,%eax
80106dde:	01 d0                	add    %edx,%eax
80106de0:	c1 e0 02             	shl    $0x2,%eax
80106de3:	05 e0 5a 11 80       	add    $0x80115ae0,%eax
80106de8:	8b 40 0c             	mov    0xc(%eax),%eax

  //Select task with high priority
  iHighPriorityTask = 10;

  for(iIndex = 0; iIndex < iTaskcount; iIndex++){
    if((arrTaskTable[iIndex].Priority <= iHighPriorityTask) &&
80106deb:	83 f8 01             	cmp    $0x1,%eax
80106dee:	75 22                	jne    80106e12 <Sched+0x73>
                            (arrTaskTable[iIndex].Ready == 1)){
      iHighPriorityTask = arrTaskTable[iIndex].Priority;
80106df0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106df3:	89 d0                	mov    %edx,%eax
80106df5:	c1 e0 02             	shl    $0x2,%eax
80106df8:	01 d0                	add    %edx,%eax
80106dfa:	c1 e0 02             	shl    $0x2,%eax
80106dfd:	05 e0 5a 11 80       	add    $0x80115ae0,%eax
80106e02:	8b 40 08             	mov    0x8(%eax),%eax
80106e05:	a3 1c 5b 11 80       	mov    %eax,0x80115b1c
      iIndexPriority = iIndex;
80106e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e0d:	a3 c4 5a 11 80       	mov    %eax,0x80115ac4
  int iIndex;

  //Select task with high priority
  iHighPriorityTask = 10;

  for(iIndex = 0; iIndex < iTaskcount; iIndex++){
80106e12:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106e16:	a1 c0 5a 11 80       	mov    0x80115ac0,%eax
80106e1b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80106e1e:	7c 98                	jl     80106db8 <Sched+0x19>
    }
  }

  //Call task with high priority
//  (*arrTaskTable[iIndexPriority].ptrTask) ();
  exec(arrTaskTable[iIndexPriority].argv[0],arrTaskTable[iIndexPriority].argv);
80106e20:	8b 15 c4 5a 11 80    	mov    0x80115ac4,%edx
80106e26:	89 d0                	mov    %edx,%eax
80106e28:	c1 e0 02             	shl    $0x2,%eax
80106e2b:	01 d0                	add    %edx,%eax
80106e2d:	c1 e0 02             	shl    $0x2,%eax
80106e30:	8d 88 e0 5a 11 80    	lea    -0x7feea520(%eax),%ecx
80106e36:	8b 15 c4 5a 11 80    	mov    0x80115ac4,%edx
80106e3c:	89 d0                	mov    %edx,%eax
80106e3e:	c1 e0 02             	shl    $0x2,%eax
80106e41:	01 d0                	add    %edx,%eax
80106e43:	c1 e0 02             	shl    $0x2,%eax
80106e46:	05 e0 5a 11 80       	add    $0x80115ae0,%eax
80106e4b:	8b 00                	mov    (%eax),%eax
80106e4d:	83 ec 08             	sub    $0x8,%esp
80106e50:	51                   	push   %ecx
80106e51:	50                   	push   %eax
80106e52:	e8 3f 9d ff ff       	call   80100b96 <exec>
80106e57:	83 c4 10             	add    $0x10,%esp
  return 0;
80106e5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106e5f:	c9                   	leave  
80106e60:	c3                   	ret    

80106e61 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106e61:	55                   	push   %ebp
80106e62:	89 e5                	mov    %esp,%ebp
80106e64:	83 ec 08             	sub    $0x8,%esp
80106e67:	8b 55 08             	mov    0x8(%ebp),%edx
80106e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e6d:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106e71:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106e74:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106e78:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106e7c:	ee                   	out    %al,(%dx)
}
80106e7d:	c9                   	leave  
80106e7e:	c3                   	ret    

80106e7f <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106e7f:	55                   	push   %ebp
80106e80:	89 e5                	mov    %esp,%ebp
80106e82:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106e85:	6a 34                	push   $0x34
80106e87:	6a 43                	push   $0x43
80106e89:	e8 d3 ff ff ff       	call   80106e61 <outb>
80106e8e:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106e91:	68 9c 00 00 00       	push   $0x9c
80106e96:	6a 40                	push   $0x40
80106e98:	e8 c4 ff ff ff       	call   80106e61 <outb>
80106e9d:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106ea0:	6a 2e                	push   $0x2e
80106ea2:	6a 40                	push   $0x40
80106ea4:	e8 b8 ff ff ff       	call   80106e61 <outb>
80106ea9:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80106eac:	83 ec 0c             	sub    $0xc,%esp
80106eaf:	6a 00                	push   $0x0
80106eb1:	e8 aa e2 ff ff       	call   80105160 <picenable>
80106eb6:	83 c4 10             	add    $0x10,%esp
}
80106eb9:	c9                   	leave  
80106eba:	c3                   	ret    

80106ebb <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106ebb:	1e                   	push   %ds
  pushl %es
80106ebc:	06                   	push   %es
  pushl %fs
80106ebd:	0f a0                	push   %fs
  pushl %gs
80106ebf:	0f a8                	push   %gs
  pushal
80106ec1:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106ec2:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106ec6:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106ec8:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106eca:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106ece:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106ed0:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106ed2:	54                   	push   %esp
  call trap
80106ed3:	e8 d4 01 00 00       	call   801070ac <trap>
  addl $4, %esp
80106ed8:	83 c4 04             	add    $0x4,%esp

80106edb <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106edb:	61                   	popa   
  popl %gs
80106edc:	0f a9                	pop    %gs
  popl %fs
80106ede:	0f a1                	pop    %fs
  popl %es
80106ee0:	07                   	pop    %es
  popl %ds
80106ee1:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106ee2:	83 c4 08             	add    $0x8,%esp
  iret
80106ee5:	cf                   	iret   

80106ee6 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106ee6:	55                   	push   %ebp
80106ee7:	89 e5                	mov    %esp,%ebp
80106ee9:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106eec:	8b 45 0c             	mov    0xc(%ebp),%eax
80106eef:	83 e8 01             	sub    $0x1,%eax
80106ef2:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106ef6:	8b 45 08             	mov    0x8(%ebp),%eax
80106ef9:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106efd:	8b 45 08             	mov    0x8(%ebp),%eax
80106f00:	c1 e8 10             	shr    $0x10,%eax
80106f03:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106f07:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106f0a:	0f 01 18             	lidtl  (%eax)
}
80106f0d:	c9                   	leave  
80106f0e:	c3                   	ret    

80106f0f <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106f0f:	55                   	push   %ebp
80106f10:	89 e5                	mov    %esp,%ebp
80106f12:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106f15:	0f 20 d0             	mov    %cr2,%eax
80106f18:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106f1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106f1e:	c9                   	leave  
80106f1f:	c3                   	ret    

80106f20 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++){
80106f26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106f2d:	e9 c3 00 00 00       	jmp    80106ff5 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f35:	8b 04 85 c0 c0 10 80 	mov    -0x7fef3f40(,%eax,4),%eax
80106f3c:	89 c2                	mov    %eax,%edx
80106f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f41:	66 89 14 c5 80 5b 11 	mov    %dx,-0x7feea480(,%eax,8)
80106f48:	80 
80106f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f4c:	66 c7 04 c5 82 5b 11 	movw   $0x8,-0x7feea47e(,%eax,8)
80106f53:	80 08 00 
80106f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f59:	0f b6 14 c5 84 5b 11 	movzbl -0x7feea47c(,%eax,8),%edx
80106f60:	80 
80106f61:	83 e2 e0             	and    $0xffffffe0,%edx
80106f64:	88 14 c5 84 5b 11 80 	mov    %dl,-0x7feea47c(,%eax,8)
80106f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f6e:	0f b6 14 c5 84 5b 11 	movzbl -0x7feea47c(,%eax,8),%edx
80106f75:	80 
80106f76:	83 e2 1f             	and    $0x1f,%edx
80106f79:	88 14 c5 84 5b 11 80 	mov    %dl,-0x7feea47c(,%eax,8)
80106f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f83:	0f b6 14 c5 85 5b 11 	movzbl -0x7feea47b(,%eax,8),%edx
80106f8a:	80 
80106f8b:	83 e2 f0             	and    $0xfffffff0,%edx
80106f8e:	83 ca 0e             	or     $0xe,%edx
80106f91:	88 14 c5 85 5b 11 80 	mov    %dl,-0x7feea47b(,%eax,8)
80106f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f9b:	0f b6 14 c5 85 5b 11 	movzbl -0x7feea47b(,%eax,8),%edx
80106fa2:	80 
80106fa3:	83 e2 ef             	and    $0xffffffef,%edx
80106fa6:	88 14 c5 85 5b 11 80 	mov    %dl,-0x7feea47b(,%eax,8)
80106fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fb0:	0f b6 14 c5 85 5b 11 	movzbl -0x7feea47b(,%eax,8),%edx
80106fb7:	80 
80106fb8:	83 e2 9f             	and    $0xffffff9f,%edx
80106fbb:	88 14 c5 85 5b 11 80 	mov    %dl,-0x7feea47b(,%eax,8)
80106fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fc5:	0f b6 14 c5 85 5b 11 	movzbl -0x7feea47b(,%eax,8),%edx
80106fcc:	80 
80106fcd:	83 ca 80             	or     $0xffffff80,%edx
80106fd0:	88 14 c5 85 5b 11 80 	mov    %dl,-0x7feea47b(,%eax,8)
80106fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fda:	8b 04 85 c0 c0 10 80 	mov    -0x7fef3f40(,%eax,4),%eax
80106fe1:	c1 e8 10             	shr    $0x10,%eax
80106fe4:	89 c2                	mov    %eax,%edx
80106fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fe9:	66 89 14 c5 86 5b 11 	mov    %dx,-0x7feea47a(,%eax,8)
80106ff0:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++){
80106ff1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106ff5:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106ffc:	0f 8e 30 ff ff ff    	jle    80106f32 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  }
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107002:	a1 c0 c1 10 80       	mov    0x8010c1c0,%eax
80107007:	66 a3 80 5d 11 80    	mov    %ax,0x80115d80
8010700d:	66 c7 05 82 5d 11 80 	movw   $0x8,0x80115d82
80107014:	08 00 
80107016:	0f b6 05 84 5d 11 80 	movzbl 0x80115d84,%eax
8010701d:	83 e0 e0             	and    $0xffffffe0,%eax
80107020:	a2 84 5d 11 80       	mov    %al,0x80115d84
80107025:	0f b6 05 84 5d 11 80 	movzbl 0x80115d84,%eax
8010702c:	83 e0 1f             	and    $0x1f,%eax
8010702f:	a2 84 5d 11 80       	mov    %al,0x80115d84
80107034:	0f b6 05 85 5d 11 80 	movzbl 0x80115d85,%eax
8010703b:	83 c8 0f             	or     $0xf,%eax
8010703e:	a2 85 5d 11 80       	mov    %al,0x80115d85
80107043:	0f b6 05 85 5d 11 80 	movzbl 0x80115d85,%eax
8010704a:	83 e0 ef             	and    $0xffffffef,%eax
8010704d:	a2 85 5d 11 80       	mov    %al,0x80115d85
80107052:	0f b6 05 85 5d 11 80 	movzbl 0x80115d85,%eax
80107059:	83 c8 60             	or     $0x60,%eax
8010705c:	a2 85 5d 11 80       	mov    %al,0x80115d85
80107061:	0f b6 05 85 5d 11 80 	movzbl 0x80115d85,%eax
80107068:	83 c8 80             	or     $0xffffff80,%eax
8010706b:	a2 85 5d 11 80       	mov    %al,0x80115d85
80107070:	a1 c0 c1 10 80       	mov    0x8010c1c0,%eax
80107075:	c1 e8 10             	shr    $0x10,%eax
80107078:	66 a3 86 5d 11 80    	mov    %ax,0x80115d86
  
  initlock(&tickslock, "time");
8010707e:	83 ec 08             	sub    $0x8,%esp
80107081:	68 04 94 10 80       	push   $0x80109404
80107086:	68 40 5b 11 80       	push   $0x80115b40
8010708b:	e8 3e e4 ff ff       	call   801054ce <initlock>
80107090:	83 c4 10             	add    $0x10,%esp
}
80107093:	c9                   	leave  
80107094:	c3                   	ret    

80107095 <idtinit>:

void
idtinit(void)
{
80107095:	55                   	push   %ebp
80107096:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80107098:	68 00 08 00 00       	push   $0x800
8010709d:	68 80 5b 11 80       	push   $0x80115b80
801070a2:	e8 3f fe ff ff       	call   80106ee6 <lidt>
801070a7:	83 c4 08             	add    $0x8,%esp
}
801070aa:	c9                   	leave  
801070ab:	c3                   	ret    

801070ac <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801070ac:	55                   	push   %ebp
801070ad:	89 e5                	mov    %esp,%ebp
801070af:	57                   	push   %edi
801070b0:	56                   	push   %esi
801070b1:	53                   	push   %ebx
801070b2:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
801070b5:	8b 45 08             	mov    0x8(%ebp),%eax
801070b8:	8b 40 30             	mov    0x30(%eax),%eax
801070bb:	83 f8 40             	cmp    $0x40,%eax
801070be:	75 3f                	jne    801070ff <trap+0x53>
    if(proc->killed)
801070c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070c6:	8b 40 24             	mov    0x24(%eax),%eax
801070c9:	85 c0                	test   %eax,%eax
801070cb:	74 05                	je     801070d2 <trap+0x26>
      exit();
801070cd:	e8 fb d8 ff ff       	call   801049cd <exit>
    proc->tf = tf;
801070d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070d8:	8b 55 08             	mov    0x8(%ebp),%edx
801070db:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801070de:	e8 4c ea ff ff       	call   80105b2f <syscall>
    if(proc->killed)
801070e3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070e9:	8b 40 24             	mov    0x24(%eax),%eax
801070ec:	85 c0                	test   %eax,%eax
801070ee:	74 0a                	je     801070fa <trap+0x4e>
      exit();
801070f0:	e8 d8 d8 ff ff       	call   801049cd <exit>
    return;
801070f5:	e9 14 02 00 00       	jmp    8010730e <trap+0x262>
801070fa:	e9 0f 02 00 00       	jmp    8010730e <trap+0x262>
  }

  switch(tf->trapno){
801070ff:	8b 45 08             	mov    0x8(%ebp),%eax
80107102:	8b 40 30             	mov    0x30(%eax),%eax
80107105:	83 e8 20             	sub    $0x20,%eax
80107108:	83 f8 1f             	cmp    $0x1f,%eax
8010710b:	0f 87 c0 00 00 00    	ja     801071d1 <trap+0x125>
80107111:	8b 04 85 ac 94 10 80 	mov    -0x7fef6b54(,%eax,4),%eax
80107118:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
8010711a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107120:	0f b6 00             	movzbl (%eax),%eax
80107123:	84 c0                	test   %al,%al
80107125:	75 3d                	jne    80107164 <trap+0xb8>
      acquire(&tickslock);
80107127:	83 ec 0c             	sub    $0xc,%esp
8010712a:	68 40 5b 11 80       	push   $0x80115b40
8010712f:	e8 bb e3 ff ff       	call   801054ef <acquire>
80107134:	83 c4 10             	add    $0x10,%esp
      ticks++;
80107137:	a1 80 63 11 80       	mov    0x80116380,%eax
8010713c:	83 c0 01             	add    $0x1,%eax
8010713f:	a3 80 63 11 80       	mov    %eax,0x80116380
      wakeup(&ticks);
80107144:	83 ec 0c             	sub    $0xc,%esp
80107147:	68 80 63 11 80       	push   $0x80116380
8010714c:	e8 a2 dd ff ff       	call   80104ef3 <wakeup>
80107151:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80107154:	83 ec 0c             	sub    $0xc,%esp
80107157:	68 40 5b 11 80       	push   $0x80115b40
8010715c:	e8 f4 e3 ff ff       	call   80105555 <release>
80107161:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80107164:	e8 f6 c1 ff ff       	call   8010335f <lapiceoi>
    break;
80107169:	e9 1c 01 00 00       	jmp    8010728a <trap+0x1de>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
8010716e:	e8 4c b7 ff ff       	call   801028bf <ideintr>
    lapiceoi();
80107173:	e8 e7 c1 ff ff       	call   8010335f <lapiceoi>
    break;
80107178:	e9 0d 01 00 00       	jmp    8010728a <trap+0x1de>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
8010717d:	e8 17 bc ff ff       	call   80102d99 <kbdintr>
    lapiceoi();
80107182:	e8 d8 c1 ff ff       	call   8010335f <lapiceoi>
    break;
80107187:	e9 fe 00 00 00       	jmp    8010728a <trap+0x1de>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
8010718c:	e8 5a 03 00 00       	call   801074eb <uartintr>
    lapiceoi();
80107191:	e8 c9 c1 ff ff       	call   8010335f <lapiceoi>
    break;
80107196:	e9 ef 00 00 00       	jmp    8010728a <trap+0x1de>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010719b:	8b 45 08             	mov    0x8(%ebp),%eax
8010719e:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
801071a1:	8b 45 08             	mov    0x8(%ebp),%eax
801071a4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801071a8:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
801071ab:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801071b1:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801071b4:	0f b6 c0             	movzbl %al,%eax
801071b7:	51                   	push   %ecx
801071b8:	52                   	push   %edx
801071b9:	50                   	push   %eax
801071ba:	68 0c 94 10 80       	push   $0x8010940c
801071bf:	e8 42 92 ff ff       	call   80100406 <cprintf>
801071c4:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
801071c7:	e8 93 c1 ff ff       	call   8010335f <lapiceoi>
    break;
801071cc:	e9 b9 00 00 00       	jmp    8010728a <trap+0x1de>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801071d1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071d7:	85 c0                	test   %eax,%eax
801071d9:	74 11                	je     801071ec <trap+0x140>
801071db:	8b 45 08             	mov    0x8(%ebp),%eax
801071de:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801071e2:	0f b7 c0             	movzwl %ax,%eax
801071e5:	83 e0 03             	and    $0x3,%eax
801071e8:	85 c0                	test   %eax,%eax
801071ea:	75 40                	jne    8010722c <trap+0x180>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801071ec:	e8 1e fd ff ff       	call   80106f0f <rcr2>
801071f1:	89 c3                	mov    %eax,%ebx
801071f3:	8b 45 08             	mov    0x8(%ebp),%eax
801071f6:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
801071f9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801071ff:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107202:	0f b6 d0             	movzbl %al,%edx
80107205:	8b 45 08             	mov    0x8(%ebp),%eax
80107208:	8b 40 30             	mov    0x30(%eax),%eax
8010720b:	83 ec 0c             	sub    $0xc,%esp
8010720e:	53                   	push   %ebx
8010720f:	51                   	push   %ecx
80107210:	52                   	push   %edx
80107211:	50                   	push   %eax
80107212:	68 30 94 10 80       	push   $0x80109430
80107217:	e8 ea 91 ff ff       	call   80100406 <cprintf>
8010721c:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
8010721f:	83 ec 0c             	sub    $0xc,%esp
80107222:	68 62 94 10 80       	push   $0x80109462
80107227:	e8 77 93 ff ff       	call   801005a3 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010722c:	e8 de fc ff ff       	call   80106f0f <rcr2>
80107231:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107234:	8b 45 08             	mov    0x8(%ebp),%eax
80107237:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010723a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107240:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107243:	0f b6 d8             	movzbl %al,%ebx
80107246:	8b 45 08             	mov    0x8(%ebp),%eax
80107249:	8b 48 34             	mov    0x34(%eax),%ecx
8010724c:	8b 45 08             	mov    0x8(%ebp),%eax
8010724f:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107252:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107258:	8d 78 6c             	lea    0x6c(%eax),%edi
8010725b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107261:	8b 40 10             	mov    0x10(%eax),%eax
80107264:	ff 75 e4             	pushl  -0x1c(%ebp)
80107267:	56                   	push   %esi
80107268:	53                   	push   %ebx
80107269:	51                   	push   %ecx
8010726a:	52                   	push   %edx
8010726b:	57                   	push   %edi
8010726c:	50                   	push   %eax
8010726d:	68 68 94 10 80       	push   $0x80109468
80107272:	e8 8f 91 ff ff       	call   80100406 <cprintf>
80107277:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
8010727a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107280:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80107287:	eb 01                	jmp    8010728a <trap+0x1de>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80107289:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010728a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107290:	85 c0                	test   %eax,%eax
80107292:	74 24                	je     801072b8 <trap+0x20c>
80107294:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010729a:	8b 40 24             	mov    0x24(%eax),%eax
8010729d:	85 c0                	test   %eax,%eax
8010729f:	74 17                	je     801072b8 <trap+0x20c>
801072a1:	8b 45 08             	mov    0x8(%ebp),%eax
801072a4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801072a8:	0f b7 c0             	movzwl %ax,%eax
801072ab:	83 e0 03             	and    $0x3,%eax
801072ae:	83 f8 03             	cmp    $0x3,%eax
801072b1:	75 05                	jne    801072b8 <trap+0x20c>
    exit();
801072b3:	e8 15 d7 ff ff       	call   801049cd <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801072b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072be:	85 c0                	test   %eax,%eax
801072c0:	74 1e                	je     801072e0 <trap+0x234>
801072c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072c8:	8b 40 0c             	mov    0xc(%eax),%eax
801072cb:	83 f8 04             	cmp    $0x4,%eax
801072ce:	75 10                	jne    801072e0 <trap+0x234>
801072d0:	8b 45 08             	mov    0x8(%ebp),%eax
801072d3:	8b 40 30             	mov    0x30(%eax),%eax
801072d6:	83 f8 20             	cmp    $0x20,%eax
801072d9:	75 05                	jne    801072e0 <trap+0x234>
    yield();
801072db:	e8 ab da ff ff       	call   80104d8b <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801072e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072e6:	85 c0                	test   %eax,%eax
801072e8:	74 24                	je     8010730e <trap+0x262>
801072ea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072f0:	8b 40 24             	mov    0x24(%eax),%eax
801072f3:	85 c0                	test   %eax,%eax
801072f5:	74 17                	je     8010730e <trap+0x262>
801072f7:	8b 45 08             	mov    0x8(%ebp),%eax
801072fa:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801072fe:	0f b7 c0             	movzwl %ax,%eax
80107301:	83 e0 03             	and    $0x3,%eax
80107304:	83 f8 03             	cmp    $0x3,%eax
80107307:	75 05                	jne    8010730e <trap+0x262>
    exit();
80107309:	e8 bf d6 ff ff       	call   801049cd <exit>
}
8010730e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107311:	5b                   	pop    %ebx
80107312:	5e                   	pop    %esi
80107313:	5f                   	pop    %edi
80107314:	5d                   	pop    %ebp
80107315:	c3                   	ret    

80107316 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80107316:	55                   	push   %ebp
80107317:	89 e5                	mov    %esp,%ebp
80107319:	83 ec 14             	sub    $0x14,%esp
8010731c:	8b 45 08             	mov    0x8(%ebp),%eax
8010731f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107323:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107327:	89 c2                	mov    %eax,%edx
80107329:	ec                   	in     (%dx),%al
8010732a:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010732d:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107331:	c9                   	leave  
80107332:	c3                   	ret    

80107333 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107333:	55                   	push   %ebp
80107334:	89 e5                	mov    %esp,%ebp
80107336:	83 ec 08             	sub    $0x8,%esp
80107339:	8b 55 08             	mov    0x8(%ebp),%edx
8010733c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010733f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107343:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107346:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010734a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010734e:	ee                   	out    %al,(%dx)
}
8010734f:	c9                   	leave  
80107350:	c3                   	ret    

80107351 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107351:	55                   	push   %ebp
80107352:	89 e5                	mov    %esp,%ebp
80107354:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107357:	6a 00                	push   $0x0
80107359:	68 fa 03 00 00       	push   $0x3fa
8010735e:	e8 d0 ff ff ff       	call   80107333 <outb>
80107363:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107366:	68 80 00 00 00       	push   $0x80
8010736b:	68 fb 03 00 00       	push   $0x3fb
80107370:	e8 be ff ff ff       	call   80107333 <outb>
80107375:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107378:	6a 0c                	push   $0xc
8010737a:	68 f8 03 00 00       	push   $0x3f8
8010737f:	e8 af ff ff ff       	call   80107333 <outb>
80107384:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107387:	6a 00                	push   $0x0
80107389:	68 f9 03 00 00       	push   $0x3f9
8010738e:	e8 a0 ff ff ff       	call   80107333 <outb>
80107393:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107396:	6a 03                	push   $0x3
80107398:	68 fb 03 00 00       	push   $0x3fb
8010739d:	e8 91 ff ff ff       	call   80107333 <outb>
801073a2:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
801073a5:	6a 00                	push   $0x0
801073a7:	68 fc 03 00 00       	push   $0x3fc
801073ac:	e8 82 ff ff ff       	call   80107333 <outb>
801073b1:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801073b4:	6a 01                	push   $0x1
801073b6:	68 f9 03 00 00       	push   $0x3f9
801073bb:	e8 73 ff ff ff       	call   80107333 <outb>
801073c0:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801073c3:	68 fd 03 00 00       	push   $0x3fd
801073c8:	e8 49 ff ff ff       	call   80107316 <inb>
801073cd:	83 c4 04             	add    $0x4,%esp
801073d0:	3c ff                	cmp    $0xff,%al
801073d2:	75 02                	jne    801073d6 <uartinit+0x85>
    return;
801073d4:	eb 6c                	jmp    80107442 <uartinit+0xf1>
  uart = 1;
801073d6:	c7 05 74 c6 10 80 01 	movl   $0x1,0x8010c674
801073dd:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801073e0:	68 fa 03 00 00       	push   $0x3fa
801073e5:	e8 2c ff ff ff       	call   80107316 <inb>
801073ea:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
801073ed:	68 f8 03 00 00       	push   $0x3f8
801073f2:	e8 1f ff ff ff       	call   80107316 <inb>
801073f7:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
801073fa:	83 ec 0c             	sub    $0xc,%esp
801073fd:	6a 04                	push   $0x4
801073ff:	e8 5c dd ff ff       	call   80105160 <picenable>
80107404:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80107407:	83 ec 08             	sub    $0x8,%esp
8010740a:	6a 00                	push   $0x0
8010740c:	6a 04                	push   $0x4
8010740e:	e8 4a b7 ff ff       	call   80102b5d <ioapicenable>
80107413:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107416:	c7 45 f4 2c 95 10 80 	movl   $0x8010952c,-0xc(%ebp)
8010741d:	eb 19                	jmp    80107438 <uartinit+0xe7>
    uartputc(*p);
8010741f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107422:	0f b6 00             	movzbl (%eax),%eax
80107425:	0f be c0             	movsbl %al,%eax
80107428:	83 ec 0c             	sub    $0xc,%esp
8010742b:	50                   	push   %eax
8010742c:	e8 13 00 00 00       	call   80107444 <uartputc>
80107431:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107434:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107438:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010743b:	0f b6 00             	movzbl (%eax),%eax
8010743e:	84 c0                	test   %al,%al
80107440:	75 dd                	jne    8010741f <uartinit+0xce>
    uartputc(*p);
}
80107442:	c9                   	leave  
80107443:	c3                   	ret    

80107444 <uartputc>:

void
uartputc(int c)
{
80107444:	55                   	push   %ebp
80107445:	89 e5                	mov    %esp,%ebp
80107447:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
8010744a:	a1 74 c6 10 80       	mov    0x8010c674,%eax
8010744f:	85 c0                	test   %eax,%eax
80107451:	75 02                	jne    80107455 <uartputc+0x11>
    return;
80107453:	eb 51                	jmp    801074a6 <uartputc+0x62>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107455:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010745c:	eb 11                	jmp    8010746f <uartputc+0x2b>
    microdelay(10);
8010745e:	83 ec 0c             	sub    $0xc,%esp
80107461:	6a 0a                	push   $0xa
80107463:	e8 11 bf ff ff       	call   80103379 <microdelay>
80107468:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010746b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010746f:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107473:	7f 1a                	jg     8010748f <uartputc+0x4b>
80107475:	83 ec 0c             	sub    $0xc,%esp
80107478:	68 fd 03 00 00       	push   $0x3fd
8010747d:	e8 94 fe ff ff       	call   80107316 <inb>
80107482:	83 c4 10             	add    $0x10,%esp
80107485:	0f b6 c0             	movzbl %al,%eax
80107488:	83 e0 20             	and    $0x20,%eax
8010748b:	85 c0                	test   %eax,%eax
8010748d:	74 cf                	je     8010745e <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
8010748f:	8b 45 08             	mov    0x8(%ebp),%eax
80107492:	0f b6 c0             	movzbl %al,%eax
80107495:	83 ec 08             	sub    $0x8,%esp
80107498:	50                   	push   %eax
80107499:	68 f8 03 00 00       	push   $0x3f8
8010749e:	e8 90 fe ff ff       	call   80107333 <outb>
801074a3:	83 c4 10             	add    $0x10,%esp
}
801074a6:	c9                   	leave  
801074a7:	c3                   	ret    

801074a8 <uartgetc>:

static int
uartgetc(void)
{
801074a8:	55                   	push   %ebp
801074a9:	89 e5                	mov    %esp,%ebp
  if(!uart)
801074ab:	a1 74 c6 10 80       	mov    0x8010c674,%eax
801074b0:	85 c0                	test   %eax,%eax
801074b2:	75 07                	jne    801074bb <uartgetc+0x13>
    return -1;
801074b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074b9:	eb 2e                	jmp    801074e9 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
801074bb:	68 fd 03 00 00       	push   $0x3fd
801074c0:	e8 51 fe ff ff       	call   80107316 <inb>
801074c5:	83 c4 04             	add    $0x4,%esp
801074c8:	0f b6 c0             	movzbl %al,%eax
801074cb:	83 e0 01             	and    $0x1,%eax
801074ce:	85 c0                	test   %eax,%eax
801074d0:	75 07                	jne    801074d9 <uartgetc+0x31>
    return -1;
801074d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074d7:	eb 10                	jmp    801074e9 <uartgetc+0x41>
  return inb(COM1+0);
801074d9:	68 f8 03 00 00       	push   $0x3f8
801074de:	e8 33 fe ff ff       	call   80107316 <inb>
801074e3:	83 c4 04             	add    $0x4,%esp
801074e6:	0f b6 c0             	movzbl %al,%eax
}
801074e9:	c9                   	leave  
801074ea:	c3                   	ret    

801074eb <uartintr>:

void
uartintr(void)
{
801074eb:	55                   	push   %ebp
801074ec:	89 e5                	mov    %esp,%ebp
801074ee:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
801074f1:	83 ec 0c             	sub    $0xc,%esp
801074f4:	68 a8 74 10 80       	push   $0x801074a8
801074f9:	e8 1a 93 ff ff       	call   80100818 <consoleintr>
801074fe:	83 c4 10             	add    $0x10,%esp
}
80107501:	c9                   	leave  
80107502:	c3                   	ret    

80107503 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107503:	6a 00                	push   $0x0
  pushl $0
80107505:	6a 00                	push   $0x0
  jmp alltraps
80107507:	e9 af f9 ff ff       	jmp    80106ebb <alltraps>

8010750c <vector1>:
.globl vector1
vector1:
  pushl $0
8010750c:	6a 00                	push   $0x0
  pushl $1
8010750e:	6a 01                	push   $0x1
  jmp alltraps
80107510:	e9 a6 f9 ff ff       	jmp    80106ebb <alltraps>

80107515 <vector2>:
.globl vector2
vector2:
  pushl $0
80107515:	6a 00                	push   $0x0
  pushl $2
80107517:	6a 02                	push   $0x2
  jmp alltraps
80107519:	e9 9d f9 ff ff       	jmp    80106ebb <alltraps>

8010751e <vector3>:
.globl vector3
vector3:
  pushl $0
8010751e:	6a 00                	push   $0x0
  pushl $3
80107520:	6a 03                	push   $0x3
  jmp alltraps
80107522:	e9 94 f9 ff ff       	jmp    80106ebb <alltraps>

80107527 <vector4>:
.globl vector4
vector4:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $4
80107529:	6a 04                	push   $0x4
  jmp alltraps
8010752b:	e9 8b f9 ff ff       	jmp    80106ebb <alltraps>

80107530 <vector5>:
.globl vector5
vector5:
  pushl $0
80107530:	6a 00                	push   $0x0
  pushl $5
80107532:	6a 05                	push   $0x5
  jmp alltraps
80107534:	e9 82 f9 ff ff       	jmp    80106ebb <alltraps>

80107539 <vector6>:
.globl vector6
vector6:
  pushl $0
80107539:	6a 00                	push   $0x0
  pushl $6
8010753b:	6a 06                	push   $0x6
  jmp alltraps
8010753d:	e9 79 f9 ff ff       	jmp    80106ebb <alltraps>

80107542 <vector7>:
.globl vector7
vector7:
  pushl $0
80107542:	6a 00                	push   $0x0
  pushl $7
80107544:	6a 07                	push   $0x7
  jmp alltraps
80107546:	e9 70 f9 ff ff       	jmp    80106ebb <alltraps>

8010754b <vector8>:
.globl vector8
vector8:
  pushl $8
8010754b:	6a 08                	push   $0x8
  jmp alltraps
8010754d:	e9 69 f9 ff ff       	jmp    80106ebb <alltraps>

80107552 <vector9>:
.globl vector9
vector9:
  pushl $0
80107552:	6a 00                	push   $0x0
  pushl $9
80107554:	6a 09                	push   $0x9
  jmp alltraps
80107556:	e9 60 f9 ff ff       	jmp    80106ebb <alltraps>

8010755b <vector10>:
.globl vector10
vector10:
  pushl $10
8010755b:	6a 0a                	push   $0xa
  jmp alltraps
8010755d:	e9 59 f9 ff ff       	jmp    80106ebb <alltraps>

80107562 <vector11>:
.globl vector11
vector11:
  pushl $11
80107562:	6a 0b                	push   $0xb
  jmp alltraps
80107564:	e9 52 f9 ff ff       	jmp    80106ebb <alltraps>

80107569 <vector12>:
.globl vector12
vector12:
  pushl $12
80107569:	6a 0c                	push   $0xc
  jmp alltraps
8010756b:	e9 4b f9 ff ff       	jmp    80106ebb <alltraps>

80107570 <vector13>:
.globl vector13
vector13:
  pushl $13
80107570:	6a 0d                	push   $0xd
  jmp alltraps
80107572:	e9 44 f9 ff ff       	jmp    80106ebb <alltraps>

80107577 <vector14>:
.globl vector14
vector14:
  pushl $14
80107577:	6a 0e                	push   $0xe
  jmp alltraps
80107579:	e9 3d f9 ff ff       	jmp    80106ebb <alltraps>

8010757e <vector15>:
.globl vector15
vector15:
  pushl $0
8010757e:	6a 00                	push   $0x0
  pushl $15
80107580:	6a 0f                	push   $0xf
  jmp alltraps
80107582:	e9 34 f9 ff ff       	jmp    80106ebb <alltraps>

80107587 <vector16>:
.globl vector16
vector16:
  pushl $0
80107587:	6a 00                	push   $0x0
  pushl $16
80107589:	6a 10                	push   $0x10
  jmp alltraps
8010758b:	e9 2b f9 ff ff       	jmp    80106ebb <alltraps>

80107590 <vector17>:
.globl vector17
vector17:
  pushl $17
80107590:	6a 11                	push   $0x11
  jmp alltraps
80107592:	e9 24 f9 ff ff       	jmp    80106ebb <alltraps>

80107597 <vector18>:
.globl vector18
vector18:
  pushl $0
80107597:	6a 00                	push   $0x0
  pushl $18
80107599:	6a 12                	push   $0x12
  jmp alltraps
8010759b:	e9 1b f9 ff ff       	jmp    80106ebb <alltraps>

801075a0 <vector19>:
.globl vector19
vector19:
  pushl $0
801075a0:	6a 00                	push   $0x0
  pushl $19
801075a2:	6a 13                	push   $0x13
  jmp alltraps
801075a4:	e9 12 f9 ff ff       	jmp    80106ebb <alltraps>

801075a9 <vector20>:
.globl vector20
vector20:
  pushl $0
801075a9:	6a 00                	push   $0x0
  pushl $20
801075ab:	6a 14                	push   $0x14
  jmp alltraps
801075ad:	e9 09 f9 ff ff       	jmp    80106ebb <alltraps>

801075b2 <vector21>:
.globl vector21
vector21:
  pushl $0
801075b2:	6a 00                	push   $0x0
  pushl $21
801075b4:	6a 15                	push   $0x15
  jmp alltraps
801075b6:	e9 00 f9 ff ff       	jmp    80106ebb <alltraps>

801075bb <vector22>:
.globl vector22
vector22:
  pushl $0
801075bb:	6a 00                	push   $0x0
  pushl $22
801075bd:	6a 16                	push   $0x16
  jmp alltraps
801075bf:	e9 f7 f8 ff ff       	jmp    80106ebb <alltraps>

801075c4 <vector23>:
.globl vector23
vector23:
  pushl $0
801075c4:	6a 00                	push   $0x0
  pushl $23
801075c6:	6a 17                	push   $0x17
  jmp alltraps
801075c8:	e9 ee f8 ff ff       	jmp    80106ebb <alltraps>

801075cd <vector24>:
.globl vector24
vector24:
  pushl $0
801075cd:	6a 00                	push   $0x0
  pushl $24
801075cf:	6a 18                	push   $0x18
  jmp alltraps
801075d1:	e9 e5 f8 ff ff       	jmp    80106ebb <alltraps>

801075d6 <vector25>:
.globl vector25
vector25:
  pushl $0
801075d6:	6a 00                	push   $0x0
  pushl $25
801075d8:	6a 19                	push   $0x19
  jmp alltraps
801075da:	e9 dc f8 ff ff       	jmp    80106ebb <alltraps>

801075df <vector26>:
.globl vector26
vector26:
  pushl $0
801075df:	6a 00                	push   $0x0
  pushl $26
801075e1:	6a 1a                	push   $0x1a
  jmp alltraps
801075e3:	e9 d3 f8 ff ff       	jmp    80106ebb <alltraps>

801075e8 <vector27>:
.globl vector27
vector27:
  pushl $0
801075e8:	6a 00                	push   $0x0
  pushl $27
801075ea:	6a 1b                	push   $0x1b
  jmp alltraps
801075ec:	e9 ca f8 ff ff       	jmp    80106ebb <alltraps>

801075f1 <vector28>:
.globl vector28
vector28:
  pushl $0
801075f1:	6a 00                	push   $0x0
  pushl $28
801075f3:	6a 1c                	push   $0x1c
  jmp alltraps
801075f5:	e9 c1 f8 ff ff       	jmp    80106ebb <alltraps>

801075fa <vector29>:
.globl vector29
vector29:
  pushl $0
801075fa:	6a 00                	push   $0x0
  pushl $29
801075fc:	6a 1d                	push   $0x1d
  jmp alltraps
801075fe:	e9 b8 f8 ff ff       	jmp    80106ebb <alltraps>

80107603 <vector30>:
.globl vector30
vector30:
  pushl $0
80107603:	6a 00                	push   $0x0
  pushl $30
80107605:	6a 1e                	push   $0x1e
  jmp alltraps
80107607:	e9 af f8 ff ff       	jmp    80106ebb <alltraps>

8010760c <vector31>:
.globl vector31
vector31:
  pushl $0
8010760c:	6a 00                	push   $0x0
  pushl $31
8010760e:	6a 1f                	push   $0x1f
  jmp alltraps
80107610:	e9 a6 f8 ff ff       	jmp    80106ebb <alltraps>

80107615 <vector32>:
.globl vector32
vector32:
  pushl $0
80107615:	6a 00                	push   $0x0
  pushl $32
80107617:	6a 20                	push   $0x20
  jmp alltraps
80107619:	e9 9d f8 ff ff       	jmp    80106ebb <alltraps>

8010761e <vector33>:
.globl vector33
vector33:
  pushl $0
8010761e:	6a 00                	push   $0x0
  pushl $33
80107620:	6a 21                	push   $0x21
  jmp alltraps
80107622:	e9 94 f8 ff ff       	jmp    80106ebb <alltraps>

80107627 <vector34>:
.globl vector34
vector34:
  pushl $0
80107627:	6a 00                	push   $0x0
  pushl $34
80107629:	6a 22                	push   $0x22
  jmp alltraps
8010762b:	e9 8b f8 ff ff       	jmp    80106ebb <alltraps>

80107630 <vector35>:
.globl vector35
vector35:
  pushl $0
80107630:	6a 00                	push   $0x0
  pushl $35
80107632:	6a 23                	push   $0x23
  jmp alltraps
80107634:	e9 82 f8 ff ff       	jmp    80106ebb <alltraps>

80107639 <vector36>:
.globl vector36
vector36:
  pushl $0
80107639:	6a 00                	push   $0x0
  pushl $36
8010763b:	6a 24                	push   $0x24
  jmp alltraps
8010763d:	e9 79 f8 ff ff       	jmp    80106ebb <alltraps>

80107642 <vector37>:
.globl vector37
vector37:
  pushl $0
80107642:	6a 00                	push   $0x0
  pushl $37
80107644:	6a 25                	push   $0x25
  jmp alltraps
80107646:	e9 70 f8 ff ff       	jmp    80106ebb <alltraps>

8010764b <vector38>:
.globl vector38
vector38:
  pushl $0
8010764b:	6a 00                	push   $0x0
  pushl $38
8010764d:	6a 26                	push   $0x26
  jmp alltraps
8010764f:	e9 67 f8 ff ff       	jmp    80106ebb <alltraps>

80107654 <vector39>:
.globl vector39
vector39:
  pushl $0
80107654:	6a 00                	push   $0x0
  pushl $39
80107656:	6a 27                	push   $0x27
  jmp alltraps
80107658:	e9 5e f8 ff ff       	jmp    80106ebb <alltraps>

8010765d <vector40>:
.globl vector40
vector40:
  pushl $0
8010765d:	6a 00                	push   $0x0
  pushl $40
8010765f:	6a 28                	push   $0x28
  jmp alltraps
80107661:	e9 55 f8 ff ff       	jmp    80106ebb <alltraps>

80107666 <vector41>:
.globl vector41
vector41:
  pushl $0
80107666:	6a 00                	push   $0x0
  pushl $41
80107668:	6a 29                	push   $0x29
  jmp alltraps
8010766a:	e9 4c f8 ff ff       	jmp    80106ebb <alltraps>

8010766f <vector42>:
.globl vector42
vector42:
  pushl $0
8010766f:	6a 00                	push   $0x0
  pushl $42
80107671:	6a 2a                	push   $0x2a
  jmp alltraps
80107673:	e9 43 f8 ff ff       	jmp    80106ebb <alltraps>

80107678 <vector43>:
.globl vector43
vector43:
  pushl $0
80107678:	6a 00                	push   $0x0
  pushl $43
8010767a:	6a 2b                	push   $0x2b
  jmp alltraps
8010767c:	e9 3a f8 ff ff       	jmp    80106ebb <alltraps>

80107681 <vector44>:
.globl vector44
vector44:
  pushl $0
80107681:	6a 00                	push   $0x0
  pushl $44
80107683:	6a 2c                	push   $0x2c
  jmp alltraps
80107685:	e9 31 f8 ff ff       	jmp    80106ebb <alltraps>

8010768a <vector45>:
.globl vector45
vector45:
  pushl $0
8010768a:	6a 00                	push   $0x0
  pushl $45
8010768c:	6a 2d                	push   $0x2d
  jmp alltraps
8010768e:	e9 28 f8 ff ff       	jmp    80106ebb <alltraps>

80107693 <vector46>:
.globl vector46
vector46:
  pushl $0
80107693:	6a 00                	push   $0x0
  pushl $46
80107695:	6a 2e                	push   $0x2e
  jmp alltraps
80107697:	e9 1f f8 ff ff       	jmp    80106ebb <alltraps>

8010769c <vector47>:
.globl vector47
vector47:
  pushl $0
8010769c:	6a 00                	push   $0x0
  pushl $47
8010769e:	6a 2f                	push   $0x2f
  jmp alltraps
801076a0:	e9 16 f8 ff ff       	jmp    80106ebb <alltraps>

801076a5 <vector48>:
.globl vector48
vector48:
  pushl $0
801076a5:	6a 00                	push   $0x0
  pushl $48
801076a7:	6a 30                	push   $0x30
  jmp alltraps
801076a9:	e9 0d f8 ff ff       	jmp    80106ebb <alltraps>

801076ae <vector49>:
.globl vector49
vector49:
  pushl $0
801076ae:	6a 00                	push   $0x0
  pushl $49
801076b0:	6a 31                	push   $0x31
  jmp alltraps
801076b2:	e9 04 f8 ff ff       	jmp    80106ebb <alltraps>

801076b7 <vector50>:
.globl vector50
vector50:
  pushl $0
801076b7:	6a 00                	push   $0x0
  pushl $50
801076b9:	6a 32                	push   $0x32
  jmp alltraps
801076bb:	e9 fb f7 ff ff       	jmp    80106ebb <alltraps>

801076c0 <vector51>:
.globl vector51
vector51:
  pushl $0
801076c0:	6a 00                	push   $0x0
  pushl $51
801076c2:	6a 33                	push   $0x33
  jmp alltraps
801076c4:	e9 f2 f7 ff ff       	jmp    80106ebb <alltraps>

801076c9 <vector52>:
.globl vector52
vector52:
  pushl $0
801076c9:	6a 00                	push   $0x0
  pushl $52
801076cb:	6a 34                	push   $0x34
  jmp alltraps
801076cd:	e9 e9 f7 ff ff       	jmp    80106ebb <alltraps>

801076d2 <vector53>:
.globl vector53
vector53:
  pushl $0
801076d2:	6a 00                	push   $0x0
  pushl $53
801076d4:	6a 35                	push   $0x35
  jmp alltraps
801076d6:	e9 e0 f7 ff ff       	jmp    80106ebb <alltraps>

801076db <vector54>:
.globl vector54
vector54:
  pushl $0
801076db:	6a 00                	push   $0x0
  pushl $54
801076dd:	6a 36                	push   $0x36
  jmp alltraps
801076df:	e9 d7 f7 ff ff       	jmp    80106ebb <alltraps>

801076e4 <vector55>:
.globl vector55
vector55:
  pushl $0
801076e4:	6a 00                	push   $0x0
  pushl $55
801076e6:	6a 37                	push   $0x37
  jmp alltraps
801076e8:	e9 ce f7 ff ff       	jmp    80106ebb <alltraps>

801076ed <vector56>:
.globl vector56
vector56:
  pushl $0
801076ed:	6a 00                	push   $0x0
  pushl $56
801076ef:	6a 38                	push   $0x38
  jmp alltraps
801076f1:	e9 c5 f7 ff ff       	jmp    80106ebb <alltraps>

801076f6 <vector57>:
.globl vector57
vector57:
  pushl $0
801076f6:	6a 00                	push   $0x0
  pushl $57
801076f8:	6a 39                	push   $0x39
  jmp alltraps
801076fa:	e9 bc f7 ff ff       	jmp    80106ebb <alltraps>

801076ff <vector58>:
.globl vector58
vector58:
  pushl $0
801076ff:	6a 00                	push   $0x0
  pushl $58
80107701:	6a 3a                	push   $0x3a
  jmp alltraps
80107703:	e9 b3 f7 ff ff       	jmp    80106ebb <alltraps>

80107708 <vector59>:
.globl vector59
vector59:
  pushl $0
80107708:	6a 00                	push   $0x0
  pushl $59
8010770a:	6a 3b                	push   $0x3b
  jmp alltraps
8010770c:	e9 aa f7 ff ff       	jmp    80106ebb <alltraps>

80107711 <vector60>:
.globl vector60
vector60:
  pushl $0
80107711:	6a 00                	push   $0x0
  pushl $60
80107713:	6a 3c                	push   $0x3c
  jmp alltraps
80107715:	e9 a1 f7 ff ff       	jmp    80106ebb <alltraps>

8010771a <vector61>:
.globl vector61
vector61:
  pushl $0
8010771a:	6a 00                	push   $0x0
  pushl $61
8010771c:	6a 3d                	push   $0x3d
  jmp alltraps
8010771e:	e9 98 f7 ff ff       	jmp    80106ebb <alltraps>

80107723 <vector62>:
.globl vector62
vector62:
  pushl $0
80107723:	6a 00                	push   $0x0
  pushl $62
80107725:	6a 3e                	push   $0x3e
  jmp alltraps
80107727:	e9 8f f7 ff ff       	jmp    80106ebb <alltraps>

8010772c <vector63>:
.globl vector63
vector63:
  pushl $0
8010772c:	6a 00                	push   $0x0
  pushl $63
8010772e:	6a 3f                	push   $0x3f
  jmp alltraps
80107730:	e9 86 f7 ff ff       	jmp    80106ebb <alltraps>

80107735 <vector64>:
.globl vector64
vector64:
  pushl $0
80107735:	6a 00                	push   $0x0
  pushl $64
80107737:	6a 40                	push   $0x40
  jmp alltraps
80107739:	e9 7d f7 ff ff       	jmp    80106ebb <alltraps>

8010773e <vector65>:
.globl vector65
vector65:
  pushl $0
8010773e:	6a 00                	push   $0x0
  pushl $65
80107740:	6a 41                	push   $0x41
  jmp alltraps
80107742:	e9 74 f7 ff ff       	jmp    80106ebb <alltraps>

80107747 <vector66>:
.globl vector66
vector66:
  pushl $0
80107747:	6a 00                	push   $0x0
  pushl $66
80107749:	6a 42                	push   $0x42
  jmp alltraps
8010774b:	e9 6b f7 ff ff       	jmp    80106ebb <alltraps>

80107750 <vector67>:
.globl vector67
vector67:
  pushl $0
80107750:	6a 00                	push   $0x0
  pushl $67
80107752:	6a 43                	push   $0x43
  jmp alltraps
80107754:	e9 62 f7 ff ff       	jmp    80106ebb <alltraps>

80107759 <vector68>:
.globl vector68
vector68:
  pushl $0
80107759:	6a 00                	push   $0x0
  pushl $68
8010775b:	6a 44                	push   $0x44
  jmp alltraps
8010775d:	e9 59 f7 ff ff       	jmp    80106ebb <alltraps>

80107762 <vector69>:
.globl vector69
vector69:
  pushl $0
80107762:	6a 00                	push   $0x0
  pushl $69
80107764:	6a 45                	push   $0x45
  jmp alltraps
80107766:	e9 50 f7 ff ff       	jmp    80106ebb <alltraps>

8010776b <vector70>:
.globl vector70
vector70:
  pushl $0
8010776b:	6a 00                	push   $0x0
  pushl $70
8010776d:	6a 46                	push   $0x46
  jmp alltraps
8010776f:	e9 47 f7 ff ff       	jmp    80106ebb <alltraps>

80107774 <vector71>:
.globl vector71
vector71:
  pushl $0
80107774:	6a 00                	push   $0x0
  pushl $71
80107776:	6a 47                	push   $0x47
  jmp alltraps
80107778:	e9 3e f7 ff ff       	jmp    80106ebb <alltraps>

8010777d <vector72>:
.globl vector72
vector72:
  pushl $0
8010777d:	6a 00                	push   $0x0
  pushl $72
8010777f:	6a 48                	push   $0x48
  jmp alltraps
80107781:	e9 35 f7 ff ff       	jmp    80106ebb <alltraps>

80107786 <vector73>:
.globl vector73
vector73:
  pushl $0
80107786:	6a 00                	push   $0x0
  pushl $73
80107788:	6a 49                	push   $0x49
  jmp alltraps
8010778a:	e9 2c f7 ff ff       	jmp    80106ebb <alltraps>

8010778f <vector74>:
.globl vector74
vector74:
  pushl $0
8010778f:	6a 00                	push   $0x0
  pushl $74
80107791:	6a 4a                	push   $0x4a
  jmp alltraps
80107793:	e9 23 f7 ff ff       	jmp    80106ebb <alltraps>

80107798 <vector75>:
.globl vector75
vector75:
  pushl $0
80107798:	6a 00                	push   $0x0
  pushl $75
8010779a:	6a 4b                	push   $0x4b
  jmp alltraps
8010779c:	e9 1a f7 ff ff       	jmp    80106ebb <alltraps>

801077a1 <vector76>:
.globl vector76
vector76:
  pushl $0
801077a1:	6a 00                	push   $0x0
  pushl $76
801077a3:	6a 4c                	push   $0x4c
  jmp alltraps
801077a5:	e9 11 f7 ff ff       	jmp    80106ebb <alltraps>

801077aa <vector77>:
.globl vector77
vector77:
  pushl $0
801077aa:	6a 00                	push   $0x0
  pushl $77
801077ac:	6a 4d                	push   $0x4d
  jmp alltraps
801077ae:	e9 08 f7 ff ff       	jmp    80106ebb <alltraps>

801077b3 <vector78>:
.globl vector78
vector78:
  pushl $0
801077b3:	6a 00                	push   $0x0
  pushl $78
801077b5:	6a 4e                	push   $0x4e
  jmp alltraps
801077b7:	e9 ff f6 ff ff       	jmp    80106ebb <alltraps>

801077bc <vector79>:
.globl vector79
vector79:
  pushl $0
801077bc:	6a 00                	push   $0x0
  pushl $79
801077be:	6a 4f                	push   $0x4f
  jmp alltraps
801077c0:	e9 f6 f6 ff ff       	jmp    80106ebb <alltraps>

801077c5 <vector80>:
.globl vector80
vector80:
  pushl $0
801077c5:	6a 00                	push   $0x0
  pushl $80
801077c7:	6a 50                	push   $0x50
  jmp alltraps
801077c9:	e9 ed f6 ff ff       	jmp    80106ebb <alltraps>

801077ce <vector81>:
.globl vector81
vector81:
  pushl $0
801077ce:	6a 00                	push   $0x0
  pushl $81
801077d0:	6a 51                	push   $0x51
  jmp alltraps
801077d2:	e9 e4 f6 ff ff       	jmp    80106ebb <alltraps>

801077d7 <vector82>:
.globl vector82
vector82:
  pushl $0
801077d7:	6a 00                	push   $0x0
  pushl $82
801077d9:	6a 52                	push   $0x52
  jmp alltraps
801077db:	e9 db f6 ff ff       	jmp    80106ebb <alltraps>

801077e0 <vector83>:
.globl vector83
vector83:
  pushl $0
801077e0:	6a 00                	push   $0x0
  pushl $83
801077e2:	6a 53                	push   $0x53
  jmp alltraps
801077e4:	e9 d2 f6 ff ff       	jmp    80106ebb <alltraps>

801077e9 <vector84>:
.globl vector84
vector84:
  pushl $0
801077e9:	6a 00                	push   $0x0
  pushl $84
801077eb:	6a 54                	push   $0x54
  jmp alltraps
801077ed:	e9 c9 f6 ff ff       	jmp    80106ebb <alltraps>

801077f2 <vector85>:
.globl vector85
vector85:
  pushl $0
801077f2:	6a 00                	push   $0x0
  pushl $85
801077f4:	6a 55                	push   $0x55
  jmp alltraps
801077f6:	e9 c0 f6 ff ff       	jmp    80106ebb <alltraps>

801077fb <vector86>:
.globl vector86
vector86:
  pushl $0
801077fb:	6a 00                	push   $0x0
  pushl $86
801077fd:	6a 56                	push   $0x56
  jmp alltraps
801077ff:	e9 b7 f6 ff ff       	jmp    80106ebb <alltraps>

80107804 <vector87>:
.globl vector87
vector87:
  pushl $0
80107804:	6a 00                	push   $0x0
  pushl $87
80107806:	6a 57                	push   $0x57
  jmp alltraps
80107808:	e9 ae f6 ff ff       	jmp    80106ebb <alltraps>

8010780d <vector88>:
.globl vector88
vector88:
  pushl $0
8010780d:	6a 00                	push   $0x0
  pushl $88
8010780f:	6a 58                	push   $0x58
  jmp alltraps
80107811:	e9 a5 f6 ff ff       	jmp    80106ebb <alltraps>

80107816 <vector89>:
.globl vector89
vector89:
  pushl $0
80107816:	6a 00                	push   $0x0
  pushl $89
80107818:	6a 59                	push   $0x59
  jmp alltraps
8010781a:	e9 9c f6 ff ff       	jmp    80106ebb <alltraps>

8010781f <vector90>:
.globl vector90
vector90:
  pushl $0
8010781f:	6a 00                	push   $0x0
  pushl $90
80107821:	6a 5a                	push   $0x5a
  jmp alltraps
80107823:	e9 93 f6 ff ff       	jmp    80106ebb <alltraps>

80107828 <vector91>:
.globl vector91
vector91:
  pushl $0
80107828:	6a 00                	push   $0x0
  pushl $91
8010782a:	6a 5b                	push   $0x5b
  jmp alltraps
8010782c:	e9 8a f6 ff ff       	jmp    80106ebb <alltraps>

80107831 <vector92>:
.globl vector92
vector92:
  pushl $0
80107831:	6a 00                	push   $0x0
  pushl $92
80107833:	6a 5c                	push   $0x5c
  jmp alltraps
80107835:	e9 81 f6 ff ff       	jmp    80106ebb <alltraps>

8010783a <vector93>:
.globl vector93
vector93:
  pushl $0
8010783a:	6a 00                	push   $0x0
  pushl $93
8010783c:	6a 5d                	push   $0x5d
  jmp alltraps
8010783e:	e9 78 f6 ff ff       	jmp    80106ebb <alltraps>

80107843 <vector94>:
.globl vector94
vector94:
  pushl $0
80107843:	6a 00                	push   $0x0
  pushl $94
80107845:	6a 5e                	push   $0x5e
  jmp alltraps
80107847:	e9 6f f6 ff ff       	jmp    80106ebb <alltraps>

8010784c <vector95>:
.globl vector95
vector95:
  pushl $0
8010784c:	6a 00                	push   $0x0
  pushl $95
8010784e:	6a 5f                	push   $0x5f
  jmp alltraps
80107850:	e9 66 f6 ff ff       	jmp    80106ebb <alltraps>

80107855 <vector96>:
.globl vector96
vector96:
  pushl $0
80107855:	6a 00                	push   $0x0
  pushl $96
80107857:	6a 60                	push   $0x60
  jmp alltraps
80107859:	e9 5d f6 ff ff       	jmp    80106ebb <alltraps>

8010785e <vector97>:
.globl vector97
vector97:
  pushl $0
8010785e:	6a 00                	push   $0x0
  pushl $97
80107860:	6a 61                	push   $0x61
  jmp alltraps
80107862:	e9 54 f6 ff ff       	jmp    80106ebb <alltraps>

80107867 <vector98>:
.globl vector98
vector98:
  pushl $0
80107867:	6a 00                	push   $0x0
  pushl $98
80107869:	6a 62                	push   $0x62
  jmp alltraps
8010786b:	e9 4b f6 ff ff       	jmp    80106ebb <alltraps>

80107870 <vector99>:
.globl vector99
vector99:
  pushl $0
80107870:	6a 00                	push   $0x0
  pushl $99
80107872:	6a 63                	push   $0x63
  jmp alltraps
80107874:	e9 42 f6 ff ff       	jmp    80106ebb <alltraps>

80107879 <vector100>:
.globl vector100
vector100:
  pushl $0
80107879:	6a 00                	push   $0x0
  pushl $100
8010787b:	6a 64                	push   $0x64
  jmp alltraps
8010787d:	e9 39 f6 ff ff       	jmp    80106ebb <alltraps>

80107882 <vector101>:
.globl vector101
vector101:
  pushl $0
80107882:	6a 00                	push   $0x0
  pushl $101
80107884:	6a 65                	push   $0x65
  jmp alltraps
80107886:	e9 30 f6 ff ff       	jmp    80106ebb <alltraps>

8010788b <vector102>:
.globl vector102
vector102:
  pushl $0
8010788b:	6a 00                	push   $0x0
  pushl $102
8010788d:	6a 66                	push   $0x66
  jmp alltraps
8010788f:	e9 27 f6 ff ff       	jmp    80106ebb <alltraps>

80107894 <vector103>:
.globl vector103
vector103:
  pushl $0
80107894:	6a 00                	push   $0x0
  pushl $103
80107896:	6a 67                	push   $0x67
  jmp alltraps
80107898:	e9 1e f6 ff ff       	jmp    80106ebb <alltraps>

8010789d <vector104>:
.globl vector104
vector104:
  pushl $0
8010789d:	6a 00                	push   $0x0
  pushl $104
8010789f:	6a 68                	push   $0x68
  jmp alltraps
801078a1:	e9 15 f6 ff ff       	jmp    80106ebb <alltraps>

801078a6 <vector105>:
.globl vector105
vector105:
  pushl $0
801078a6:	6a 00                	push   $0x0
  pushl $105
801078a8:	6a 69                	push   $0x69
  jmp alltraps
801078aa:	e9 0c f6 ff ff       	jmp    80106ebb <alltraps>

801078af <vector106>:
.globl vector106
vector106:
  pushl $0
801078af:	6a 00                	push   $0x0
  pushl $106
801078b1:	6a 6a                	push   $0x6a
  jmp alltraps
801078b3:	e9 03 f6 ff ff       	jmp    80106ebb <alltraps>

801078b8 <vector107>:
.globl vector107
vector107:
  pushl $0
801078b8:	6a 00                	push   $0x0
  pushl $107
801078ba:	6a 6b                	push   $0x6b
  jmp alltraps
801078bc:	e9 fa f5 ff ff       	jmp    80106ebb <alltraps>

801078c1 <vector108>:
.globl vector108
vector108:
  pushl $0
801078c1:	6a 00                	push   $0x0
  pushl $108
801078c3:	6a 6c                	push   $0x6c
  jmp alltraps
801078c5:	e9 f1 f5 ff ff       	jmp    80106ebb <alltraps>

801078ca <vector109>:
.globl vector109
vector109:
  pushl $0
801078ca:	6a 00                	push   $0x0
  pushl $109
801078cc:	6a 6d                	push   $0x6d
  jmp alltraps
801078ce:	e9 e8 f5 ff ff       	jmp    80106ebb <alltraps>

801078d3 <vector110>:
.globl vector110
vector110:
  pushl $0
801078d3:	6a 00                	push   $0x0
  pushl $110
801078d5:	6a 6e                	push   $0x6e
  jmp alltraps
801078d7:	e9 df f5 ff ff       	jmp    80106ebb <alltraps>

801078dc <vector111>:
.globl vector111
vector111:
  pushl $0
801078dc:	6a 00                	push   $0x0
  pushl $111
801078de:	6a 6f                	push   $0x6f
  jmp alltraps
801078e0:	e9 d6 f5 ff ff       	jmp    80106ebb <alltraps>

801078e5 <vector112>:
.globl vector112
vector112:
  pushl $0
801078e5:	6a 00                	push   $0x0
  pushl $112
801078e7:	6a 70                	push   $0x70
  jmp alltraps
801078e9:	e9 cd f5 ff ff       	jmp    80106ebb <alltraps>

801078ee <vector113>:
.globl vector113
vector113:
  pushl $0
801078ee:	6a 00                	push   $0x0
  pushl $113
801078f0:	6a 71                	push   $0x71
  jmp alltraps
801078f2:	e9 c4 f5 ff ff       	jmp    80106ebb <alltraps>

801078f7 <vector114>:
.globl vector114
vector114:
  pushl $0
801078f7:	6a 00                	push   $0x0
  pushl $114
801078f9:	6a 72                	push   $0x72
  jmp alltraps
801078fb:	e9 bb f5 ff ff       	jmp    80106ebb <alltraps>

80107900 <vector115>:
.globl vector115
vector115:
  pushl $0
80107900:	6a 00                	push   $0x0
  pushl $115
80107902:	6a 73                	push   $0x73
  jmp alltraps
80107904:	e9 b2 f5 ff ff       	jmp    80106ebb <alltraps>

80107909 <vector116>:
.globl vector116
vector116:
  pushl $0
80107909:	6a 00                	push   $0x0
  pushl $116
8010790b:	6a 74                	push   $0x74
  jmp alltraps
8010790d:	e9 a9 f5 ff ff       	jmp    80106ebb <alltraps>

80107912 <vector117>:
.globl vector117
vector117:
  pushl $0
80107912:	6a 00                	push   $0x0
  pushl $117
80107914:	6a 75                	push   $0x75
  jmp alltraps
80107916:	e9 a0 f5 ff ff       	jmp    80106ebb <alltraps>

8010791b <vector118>:
.globl vector118
vector118:
  pushl $0
8010791b:	6a 00                	push   $0x0
  pushl $118
8010791d:	6a 76                	push   $0x76
  jmp alltraps
8010791f:	e9 97 f5 ff ff       	jmp    80106ebb <alltraps>

80107924 <vector119>:
.globl vector119
vector119:
  pushl $0
80107924:	6a 00                	push   $0x0
  pushl $119
80107926:	6a 77                	push   $0x77
  jmp alltraps
80107928:	e9 8e f5 ff ff       	jmp    80106ebb <alltraps>

8010792d <vector120>:
.globl vector120
vector120:
  pushl $0
8010792d:	6a 00                	push   $0x0
  pushl $120
8010792f:	6a 78                	push   $0x78
  jmp alltraps
80107931:	e9 85 f5 ff ff       	jmp    80106ebb <alltraps>

80107936 <vector121>:
.globl vector121
vector121:
  pushl $0
80107936:	6a 00                	push   $0x0
  pushl $121
80107938:	6a 79                	push   $0x79
  jmp alltraps
8010793a:	e9 7c f5 ff ff       	jmp    80106ebb <alltraps>

8010793f <vector122>:
.globl vector122
vector122:
  pushl $0
8010793f:	6a 00                	push   $0x0
  pushl $122
80107941:	6a 7a                	push   $0x7a
  jmp alltraps
80107943:	e9 73 f5 ff ff       	jmp    80106ebb <alltraps>

80107948 <vector123>:
.globl vector123
vector123:
  pushl $0
80107948:	6a 00                	push   $0x0
  pushl $123
8010794a:	6a 7b                	push   $0x7b
  jmp alltraps
8010794c:	e9 6a f5 ff ff       	jmp    80106ebb <alltraps>

80107951 <vector124>:
.globl vector124
vector124:
  pushl $0
80107951:	6a 00                	push   $0x0
  pushl $124
80107953:	6a 7c                	push   $0x7c
  jmp alltraps
80107955:	e9 61 f5 ff ff       	jmp    80106ebb <alltraps>

8010795a <vector125>:
.globl vector125
vector125:
  pushl $0
8010795a:	6a 00                	push   $0x0
  pushl $125
8010795c:	6a 7d                	push   $0x7d
  jmp alltraps
8010795e:	e9 58 f5 ff ff       	jmp    80106ebb <alltraps>

80107963 <vector126>:
.globl vector126
vector126:
  pushl $0
80107963:	6a 00                	push   $0x0
  pushl $126
80107965:	6a 7e                	push   $0x7e
  jmp alltraps
80107967:	e9 4f f5 ff ff       	jmp    80106ebb <alltraps>

8010796c <vector127>:
.globl vector127
vector127:
  pushl $0
8010796c:	6a 00                	push   $0x0
  pushl $127
8010796e:	6a 7f                	push   $0x7f
  jmp alltraps
80107970:	e9 46 f5 ff ff       	jmp    80106ebb <alltraps>

80107975 <vector128>:
.globl vector128
vector128:
  pushl $0
80107975:	6a 00                	push   $0x0
  pushl $128
80107977:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010797c:	e9 3a f5 ff ff       	jmp    80106ebb <alltraps>

80107981 <vector129>:
.globl vector129
vector129:
  pushl $0
80107981:	6a 00                	push   $0x0
  pushl $129
80107983:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107988:	e9 2e f5 ff ff       	jmp    80106ebb <alltraps>

8010798d <vector130>:
.globl vector130
vector130:
  pushl $0
8010798d:	6a 00                	push   $0x0
  pushl $130
8010798f:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107994:	e9 22 f5 ff ff       	jmp    80106ebb <alltraps>

80107999 <vector131>:
.globl vector131
vector131:
  pushl $0
80107999:	6a 00                	push   $0x0
  pushl $131
8010799b:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801079a0:	e9 16 f5 ff ff       	jmp    80106ebb <alltraps>

801079a5 <vector132>:
.globl vector132
vector132:
  pushl $0
801079a5:	6a 00                	push   $0x0
  pushl $132
801079a7:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801079ac:	e9 0a f5 ff ff       	jmp    80106ebb <alltraps>

801079b1 <vector133>:
.globl vector133
vector133:
  pushl $0
801079b1:	6a 00                	push   $0x0
  pushl $133
801079b3:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801079b8:	e9 fe f4 ff ff       	jmp    80106ebb <alltraps>

801079bd <vector134>:
.globl vector134
vector134:
  pushl $0
801079bd:	6a 00                	push   $0x0
  pushl $134
801079bf:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801079c4:	e9 f2 f4 ff ff       	jmp    80106ebb <alltraps>

801079c9 <vector135>:
.globl vector135
vector135:
  pushl $0
801079c9:	6a 00                	push   $0x0
  pushl $135
801079cb:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801079d0:	e9 e6 f4 ff ff       	jmp    80106ebb <alltraps>

801079d5 <vector136>:
.globl vector136
vector136:
  pushl $0
801079d5:	6a 00                	push   $0x0
  pushl $136
801079d7:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801079dc:	e9 da f4 ff ff       	jmp    80106ebb <alltraps>

801079e1 <vector137>:
.globl vector137
vector137:
  pushl $0
801079e1:	6a 00                	push   $0x0
  pushl $137
801079e3:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801079e8:	e9 ce f4 ff ff       	jmp    80106ebb <alltraps>

801079ed <vector138>:
.globl vector138
vector138:
  pushl $0
801079ed:	6a 00                	push   $0x0
  pushl $138
801079ef:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801079f4:	e9 c2 f4 ff ff       	jmp    80106ebb <alltraps>

801079f9 <vector139>:
.globl vector139
vector139:
  pushl $0
801079f9:	6a 00                	push   $0x0
  pushl $139
801079fb:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107a00:	e9 b6 f4 ff ff       	jmp    80106ebb <alltraps>

80107a05 <vector140>:
.globl vector140
vector140:
  pushl $0
80107a05:	6a 00                	push   $0x0
  pushl $140
80107a07:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107a0c:	e9 aa f4 ff ff       	jmp    80106ebb <alltraps>

80107a11 <vector141>:
.globl vector141
vector141:
  pushl $0
80107a11:	6a 00                	push   $0x0
  pushl $141
80107a13:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107a18:	e9 9e f4 ff ff       	jmp    80106ebb <alltraps>

80107a1d <vector142>:
.globl vector142
vector142:
  pushl $0
80107a1d:	6a 00                	push   $0x0
  pushl $142
80107a1f:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107a24:	e9 92 f4 ff ff       	jmp    80106ebb <alltraps>

80107a29 <vector143>:
.globl vector143
vector143:
  pushl $0
80107a29:	6a 00                	push   $0x0
  pushl $143
80107a2b:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107a30:	e9 86 f4 ff ff       	jmp    80106ebb <alltraps>

80107a35 <vector144>:
.globl vector144
vector144:
  pushl $0
80107a35:	6a 00                	push   $0x0
  pushl $144
80107a37:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107a3c:	e9 7a f4 ff ff       	jmp    80106ebb <alltraps>

80107a41 <vector145>:
.globl vector145
vector145:
  pushl $0
80107a41:	6a 00                	push   $0x0
  pushl $145
80107a43:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107a48:	e9 6e f4 ff ff       	jmp    80106ebb <alltraps>

80107a4d <vector146>:
.globl vector146
vector146:
  pushl $0
80107a4d:	6a 00                	push   $0x0
  pushl $146
80107a4f:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107a54:	e9 62 f4 ff ff       	jmp    80106ebb <alltraps>

80107a59 <vector147>:
.globl vector147
vector147:
  pushl $0
80107a59:	6a 00                	push   $0x0
  pushl $147
80107a5b:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107a60:	e9 56 f4 ff ff       	jmp    80106ebb <alltraps>

80107a65 <vector148>:
.globl vector148
vector148:
  pushl $0
80107a65:	6a 00                	push   $0x0
  pushl $148
80107a67:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107a6c:	e9 4a f4 ff ff       	jmp    80106ebb <alltraps>

80107a71 <vector149>:
.globl vector149
vector149:
  pushl $0
80107a71:	6a 00                	push   $0x0
  pushl $149
80107a73:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107a78:	e9 3e f4 ff ff       	jmp    80106ebb <alltraps>

80107a7d <vector150>:
.globl vector150
vector150:
  pushl $0
80107a7d:	6a 00                	push   $0x0
  pushl $150
80107a7f:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107a84:	e9 32 f4 ff ff       	jmp    80106ebb <alltraps>

80107a89 <vector151>:
.globl vector151
vector151:
  pushl $0
80107a89:	6a 00                	push   $0x0
  pushl $151
80107a8b:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107a90:	e9 26 f4 ff ff       	jmp    80106ebb <alltraps>

80107a95 <vector152>:
.globl vector152
vector152:
  pushl $0
80107a95:	6a 00                	push   $0x0
  pushl $152
80107a97:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107a9c:	e9 1a f4 ff ff       	jmp    80106ebb <alltraps>

80107aa1 <vector153>:
.globl vector153
vector153:
  pushl $0
80107aa1:	6a 00                	push   $0x0
  pushl $153
80107aa3:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107aa8:	e9 0e f4 ff ff       	jmp    80106ebb <alltraps>

80107aad <vector154>:
.globl vector154
vector154:
  pushl $0
80107aad:	6a 00                	push   $0x0
  pushl $154
80107aaf:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107ab4:	e9 02 f4 ff ff       	jmp    80106ebb <alltraps>

80107ab9 <vector155>:
.globl vector155
vector155:
  pushl $0
80107ab9:	6a 00                	push   $0x0
  pushl $155
80107abb:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107ac0:	e9 f6 f3 ff ff       	jmp    80106ebb <alltraps>

80107ac5 <vector156>:
.globl vector156
vector156:
  pushl $0
80107ac5:	6a 00                	push   $0x0
  pushl $156
80107ac7:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107acc:	e9 ea f3 ff ff       	jmp    80106ebb <alltraps>

80107ad1 <vector157>:
.globl vector157
vector157:
  pushl $0
80107ad1:	6a 00                	push   $0x0
  pushl $157
80107ad3:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107ad8:	e9 de f3 ff ff       	jmp    80106ebb <alltraps>

80107add <vector158>:
.globl vector158
vector158:
  pushl $0
80107add:	6a 00                	push   $0x0
  pushl $158
80107adf:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107ae4:	e9 d2 f3 ff ff       	jmp    80106ebb <alltraps>

80107ae9 <vector159>:
.globl vector159
vector159:
  pushl $0
80107ae9:	6a 00                	push   $0x0
  pushl $159
80107aeb:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107af0:	e9 c6 f3 ff ff       	jmp    80106ebb <alltraps>

80107af5 <vector160>:
.globl vector160
vector160:
  pushl $0
80107af5:	6a 00                	push   $0x0
  pushl $160
80107af7:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107afc:	e9 ba f3 ff ff       	jmp    80106ebb <alltraps>

80107b01 <vector161>:
.globl vector161
vector161:
  pushl $0
80107b01:	6a 00                	push   $0x0
  pushl $161
80107b03:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107b08:	e9 ae f3 ff ff       	jmp    80106ebb <alltraps>

80107b0d <vector162>:
.globl vector162
vector162:
  pushl $0
80107b0d:	6a 00                	push   $0x0
  pushl $162
80107b0f:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107b14:	e9 a2 f3 ff ff       	jmp    80106ebb <alltraps>

80107b19 <vector163>:
.globl vector163
vector163:
  pushl $0
80107b19:	6a 00                	push   $0x0
  pushl $163
80107b1b:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107b20:	e9 96 f3 ff ff       	jmp    80106ebb <alltraps>

80107b25 <vector164>:
.globl vector164
vector164:
  pushl $0
80107b25:	6a 00                	push   $0x0
  pushl $164
80107b27:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107b2c:	e9 8a f3 ff ff       	jmp    80106ebb <alltraps>

80107b31 <vector165>:
.globl vector165
vector165:
  pushl $0
80107b31:	6a 00                	push   $0x0
  pushl $165
80107b33:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107b38:	e9 7e f3 ff ff       	jmp    80106ebb <alltraps>

80107b3d <vector166>:
.globl vector166
vector166:
  pushl $0
80107b3d:	6a 00                	push   $0x0
  pushl $166
80107b3f:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107b44:	e9 72 f3 ff ff       	jmp    80106ebb <alltraps>

80107b49 <vector167>:
.globl vector167
vector167:
  pushl $0
80107b49:	6a 00                	push   $0x0
  pushl $167
80107b4b:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107b50:	e9 66 f3 ff ff       	jmp    80106ebb <alltraps>

80107b55 <vector168>:
.globl vector168
vector168:
  pushl $0
80107b55:	6a 00                	push   $0x0
  pushl $168
80107b57:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107b5c:	e9 5a f3 ff ff       	jmp    80106ebb <alltraps>

80107b61 <vector169>:
.globl vector169
vector169:
  pushl $0
80107b61:	6a 00                	push   $0x0
  pushl $169
80107b63:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107b68:	e9 4e f3 ff ff       	jmp    80106ebb <alltraps>

80107b6d <vector170>:
.globl vector170
vector170:
  pushl $0
80107b6d:	6a 00                	push   $0x0
  pushl $170
80107b6f:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107b74:	e9 42 f3 ff ff       	jmp    80106ebb <alltraps>

80107b79 <vector171>:
.globl vector171
vector171:
  pushl $0
80107b79:	6a 00                	push   $0x0
  pushl $171
80107b7b:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107b80:	e9 36 f3 ff ff       	jmp    80106ebb <alltraps>

80107b85 <vector172>:
.globl vector172
vector172:
  pushl $0
80107b85:	6a 00                	push   $0x0
  pushl $172
80107b87:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107b8c:	e9 2a f3 ff ff       	jmp    80106ebb <alltraps>

80107b91 <vector173>:
.globl vector173
vector173:
  pushl $0
80107b91:	6a 00                	push   $0x0
  pushl $173
80107b93:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107b98:	e9 1e f3 ff ff       	jmp    80106ebb <alltraps>

80107b9d <vector174>:
.globl vector174
vector174:
  pushl $0
80107b9d:	6a 00                	push   $0x0
  pushl $174
80107b9f:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107ba4:	e9 12 f3 ff ff       	jmp    80106ebb <alltraps>

80107ba9 <vector175>:
.globl vector175
vector175:
  pushl $0
80107ba9:	6a 00                	push   $0x0
  pushl $175
80107bab:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107bb0:	e9 06 f3 ff ff       	jmp    80106ebb <alltraps>

80107bb5 <vector176>:
.globl vector176
vector176:
  pushl $0
80107bb5:	6a 00                	push   $0x0
  pushl $176
80107bb7:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107bbc:	e9 fa f2 ff ff       	jmp    80106ebb <alltraps>

80107bc1 <vector177>:
.globl vector177
vector177:
  pushl $0
80107bc1:	6a 00                	push   $0x0
  pushl $177
80107bc3:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107bc8:	e9 ee f2 ff ff       	jmp    80106ebb <alltraps>

80107bcd <vector178>:
.globl vector178
vector178:
  pushl $0
80107bcd:	6a 00                	push   $0x0
  pushl $178
80107bcf:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107bd4:	e9 e2 f2 ff ff       	jmp    80106ebb <alltraps>

80107bd9 <vector179>:
.globl vector179
vector179:
  pushl $0
80107bd9:	6a 00                	push   $0x0
  pushl $179
80107bdb:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107be0:	e9 d6 f2 ff ff       	jmp    80106ebb <alltraps>

80107be5 <vector180>:
.globl vector180
vector180:
  pushl $0
80107be5:	6a 00                	push   $0x0
  pushl $180
80107be7:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107bec:	e9 ca f2 ff ff       	jmp    80106ebb <alltraps>

80107bf1 <vector181>:
.globl vector181
vector181:
  pushl $0
80107bf1:	6a 00                	push   $0x0
  pushl $181
80107bf3:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107bf8:	e9 be f2 ff ff       	jmp    80106ebb <alltraps>

80107bfd <vector182>:
.globl vector182
vector182:
  pushl $0
80107bfd:	6a 00                	push   $0x0
  pushl $182
80107bff:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107c04:	e9 b2 f2 ff ff       	jmp    80106ebb <alltraps>

80107c09 <vector183>:
.globl vector183
vector183:
  pushl $0
80107c09:	6a 00                	push   $0x0
  pushl $183
80107c0b:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107c10:	e9 a6 f2 ff ff       	jmp    80106ebb <alltraps>

80107c15 <vector184>:
.globl vector184
vector184:
  pushl $0
80107c15:	6a 00                	push   $0x0
  pushl $184
80107c17:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107c1c:	e9 9a f2 ff ff       	jmp    80106ebb <alltraps>

80107c21 <vector185>:
.globl vector185
vector185:
  pushl $0
80107c21:	6a 00                	push   $0x0
  pushl $185
80107c23:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107c28:	e9 8e f2 ff ff       	jmp    80106ebb <alltraps>

80107c2d <vector186>:
.globl vector186
vector186:
  pushl $0
80107c2d:	6a 00                	push   $0x0
  pushl $186
80107c2f:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107c34:	e9 82 f2 ff ff       	jmp    80106ebb <alltraps>

80107c39 <vector187>:
.globl vector187
vector187:
  pushl $0
80107c39:	6a 00                	push   $0x0
  pushl $187
80107c3b:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107c40:	e9 76 f2 ff ff       	jmp    80106ebb <alltraps>

80107c45 <vector188>:
.globl vector188
vector188:
  pushl $0
80107c45:	6a 00                	push   $0x0
  pushl $188
80107c47:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107c4c:	e9 6a f2 ff ff       	jmp    80106ebb <alltraps>

80107c51 <vector189>:
.globl vector189
vector189:
  pushl $0
80107c51:	6a 00                	push   $0x0
  pushl $189
80107c53:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107c58:	e9 5e f2 ff ff       	jmp    80106ebb <alltraps>

80107c5d <vector190>:
.globl vector190
vector190:
  pushl $0
80107c5d:	6a 00                	push   $0x0
  pushl $190
80107c5f:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107c64:	e9 52 f2 ff ff       	jmp    80106ebb <alltraps>

80107c69 <vector191>:
.globl vector191
vector191:
  pushl $0
80107c69:	6a 00                	push   $0x0
  pushl $191
80107c6b:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107c70:	e9 46 f2 ff ff       	jmp    80106ebb <alltraps>

80107c75 <vector192>:
.globl vector192
vector192:
  pushl $0
80107c75:	6a 00                	push   $0x0
  pushl $192
80107c77:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107c7c:	e9 3a f2 ff ff       	jmp    80106ebb <alltraps>

80107c81 <vector193>:
.globl vector193
vector193:
  pushl $0
80107c81:	6a 00                	push   $0x0
  pushl $193
80107c83:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107c88:	e9 2e f2 ff ff       	jmp    80106ebb <alltraps>

80107c8d <vector194>:
.globl vector194
vector194:
  pushl $0
80107c8d:	6a 00                	push   $0x0
  pushl $194
80107c8f:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107c94:	e9 22 f2 ff ff       	jmp    80106ebb <alltraps>

80107c99 <vector195>:
.globl vector195
vector195:
  pushl $0
80107c99:	6a 00                	push   $0x0
  pushl $195
80107c9b:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107ca0:	e9 16 f2 ff ff       	jmp    80106ebb <alltraps>

80107ca5 <vector196>:
.globl vector196
vector196:
  pushl $0
80107ca5:	6a 00                	push   $0x0
  pushl $196
80107ca7:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107cac:	e9 0a f2 ff ff       	jmp    80106ebb <alltraps>

80107cb1 <vector197>:
.globl vector197
vector197:
  pushl $0
80107cb1:	6a 00                	push   $0x0
  pushl $197
80107cb3:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107cb8:	e9 fe f1 ff ff       	jmp    80106ebb <alltraps>

80107cbd <vector198>:
.globl vector198
vector198:
  pushl $0
80107cbd:	6a 00                	push   $0x0
  pushl $198
80107cbf:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107cc4:	e9 f2 f1 ff ff       	jmp    80106ebb <alltraps>

80107cc9 <vector199>:
.globl vector199
vector199:
  pushl $0
80107cc9:	6a 00                	push   $0x0
  pushl $199
80107ccb:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107cd0:	e9 e6 f1 ff ff       	jmp    80106ebb <alltraps>

80107cd5 <vector200>:
.globl vector200
vector200:
  pushl $0
80107cd5:	6a 00                	push   $0x0
  pushl $200
80107cd7:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107cdc:	e9 da f1 ff ff       	jmp    80106ebb <alltraps>

80107ce1 <vector201>:
.globl vector201
vector201:
  pushl $0
80107ce1:	6a 00                	push   $0x0
  pushl $201
80107ce3:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107ce8:	e9 ce f1 ff ff       	jmp    80106ebb <alltraps>

80107ced <vector202>:
.globl vector202
vector202:
  pushl $0
80107ced:	6a 00                	push   $0x0
  pushl $202
80107cef:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107cf4:	e9 c2 f1 ff ff       	jmp    80106ebb <alltraps>

80107cf9 <vector203>:
.globl vector203
vector203:
  pushl $0
80107cf9:	6a 00                	push   $0x0
  pushl $203
80107cfb:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107d00:	e9 b6 f1 ff ff       	jmp    80106ebb <alltraps>

80107d05 <vector204>:
.globl vector204
vector204:
  pushl $0
80107d05:	6a 00                	push   $0x0
  pushl $204
80107d07:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107d0c:	e9 aa f1 ff ff       	jmp    80106ebb <alltraps>

80107d11 <vector205>:
.globl vector205
vector205:
  pushl $0
80107d11:	6a 00                	push   $0x0
  pushl $205
80107d13:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107d18:	e9 9e f1 ff ff       	jmp    80106ebb <alltraps>

80107d1d <vector206>:
.globl vector206
vector206:
  pushl $0
80107d1d:	6a 00                	push   $0x0
  pushl $206
80107d1f:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107d24:	e9 92 f1 ff ff       	jmp    80106ebb <alltraps>

80107d29 <vector207>:
.globl vector207
vector207:
  pushl $0
80107d29:	6a 00                	push   $0x0
  pushl $207
80107d2b:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107d30:	e9 86 f1 ff ff       	jmp    80106ebb <alltraps>

80107d35 <vector208>:
.globl vector208
vector208:
  pushl $0
80107d35:	6a 00                	push   $0x0
  pushl $208
80107d37:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107d3c:	e9 7a f1 ff ff       	jmp    80106ebb <alltraps>

80107d41 <vector209>:
.globl vector209
vector209:
  pushl $0
80107d41:	6a 00                	push   $0x0
  pushl $209
80107d43:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107d48:	e9 6e f1 ff ff       	jmp    80106ebb <alltraps>

80107d4d <vector210>:
.globl vector210
vector210:
  pushl $0
80107d4d:	6a 00                	push   $0x0
  pushl $210
80107d4f:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107d54:	e9 62 f1 ff ff       	jmp    80106ebb <alltraps>

80107d59 <vector211>:
.globl vector211
vector211:
  pushl $0
80107d59:	6a 00                	push   $0x0
  pushl $211
80107d5b:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107d60:	e9 56 f1 ff ff       	jmp    80106ebb <alltraps>

80107d65 <vector212>:
.globl vector212
vector212:
  pushl $0
80107d65:	6a 00                	push   $0x0
  pushl $212
80107d67:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107d6c:	e9 4a f1 ff ff       	jmp    80106ebb <alltraps>

80107d71 <vector213>:
.globl vector213
vector213:
  pushl $0
80107d71:	6a 00                	push   $0x0
  pushl $213
80107d73:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107d78:	e9 3e f1 ff ff       	jmp    80106ebb <alltraps>

80107d7d <vector214>:
.globl vector214
vector214:
  pushl $0
80107d7d:	6a 00                	push   $0x0
  pushl $214
80107d7f:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107d84:	e9 32 f1 ff ff       	jmp    80106ebb <alltraps>

80107d89 <vector215>:
.globl vector215
vector215:
  pushl $0
80107d89:	6a 00                	push   $0x0
  pushl $215
80107d8b:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107d90:	e9 26 f1 ff ff       	jmp    80106ebb <alltraps>

80107d95 <vector216>:
.globl vector216
vector216:
  pushl $0
80107d95:	6a 00                	push   $0x0
  pushl $216
80107d97:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107d9c:	e9 1a f1 ff ff       	jmp    80106ebb <alltraps>

80107da1 <vector217>:
.globl vector217
vector217:
  pushl $0
80107da1:	6a 00                	push   $0x0
  pushl $217
80107da3:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107da8:	e9 0e f1 ff ff       	jmp    80106ebb <alltraps>

80107dad <vector218>:
.globl vector218
vector218:
  pushl $0
80107dad:	6a 00                	push   $0x0
  pushl $218
80107daf:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107db4:	e9 02 f1 ff ff       	jmp    80106ebb <alltraps>

80107db9 <vector219>:
.globl vector219
vector219:
  pushl $0
80107db9:	6a 00                	push   $0x0
  pushl $219
80107dbb:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107dc0:	e9 f6 f0 ff ff       	jmp    80106ebb <alltraps>

80107dc5 <vector220>:
.globl vector220
vector220:
  pushl $0
80107dc5:	6a 00                	push   $0x0
  pushl $220
80107dc7:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107dcc:	e9 ea f0 ff ff       	jmp    80106ebb <alltraps>

80107dd1 <vector221>:
.globl vector221
vector221:
  pushl $0
80107dd1:	6a 00                	push   $0x0
  pushl $221
80107dd3:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107dd8:	e9 de f0 ff ff       	jmp    80106ebb <alltraps>

80107ddd <vector222>:
.globl vector222
vector222:
  pushl $0
80107ddd:	6a 00                	push   $0x0
  pushl $222
80107ddf:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107de4:	e9 d2 f0 ff ff       	jmp    80106ebb <alltraps>

80107de9 <vector223>:
.globl vector223
vector223:
  pushl $0
80107de9:	6a 00                	push   $0x0
  pushl $223
80107deb:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107df0:	e9 c6 f0 ff ff       	jmp    80106ebb <alltraps>

80107df5 <vector224>:
.globl vector224
vector224:
  pushl $0
80107df5:	6a 00                	push   $0x0
  pushl $224
80107df7:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107dfc:	e9 ba f0 ff ff       	jmp    80106ebb <alltraps>

80107e01 <vector225>:
.globl vector225
vector225:
  pushl $0
80107e01:	6a 00                	push   $0x0
  pushl $225
80107e03:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107e08:	e9 ae f0 ff ff       	jmp    80106ebb <alltraps>

80107e0d <vector226>:
.globl vector226
vector226:
  pushl $0
80107e0d:	6a 00                	push   $0x0
  pushl $226
80107e0f:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107e14:	e9 a2 f0 ff ff       	jmp    80106ebb <alltraps>

80107e19 <vector227>:
.globl vector227
vector227:
  pushl $0
80107e19:	6a 00                	push   $0x0
  pushl $227
80107e1b:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107e20:	e9 96 f0 ff ff       	jmp    80106ebb <alltraps>

80107e25 <vector228>:
.globl vector228
vector228:
  pushl $0
80107e25:	6a 00                	push   $0x0
  pushl $228
80107e27:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107e2c:	e9 8a f0 ff ff       	jmp    80106ebb <alltraps>

80107e31 <vector229>:
.globl vector229
vector229:
  pushl $0
80107e31:	6a 00                	push   $0x0
  pushl $229
80107e33:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107e38:	e9 7e f0 ff ff       	jmp    80106ebb <alltraps>

80107e3d <vector230>:
.globl vector230
vector230:
  pushl $0
80107e3d:	6a 00                	push   $0x0
  pushl $230
80107e3f:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107e44:	e9 72 f0 ff ff       	jmp    80106ebb <alltraps>

80107e49 <vector231>:
.globl vector231
vector231:
  pushl $0
80107e49:	6a 00                	push   $0x0
  pushl $231
80107e4b:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107e50:	e9 66 f0 ff ff       	jmp    80106ebb <alltraps>

80107e55 <vector232>:
.globl vector232
vector232:
  pushl $0
80107e55:	6a 00                	push   $0x0
  pushl $232
80107e57:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107e5c:	e9 5a f0 ff ff       	jmp    80106ebb <alltraps>

80107e61 <vector233>:
.globl vector233
vector233:
  pushl $0
80107e61:	6a 00                	push   $0x0
  pushl $233
80107e63:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107e68:	e9 4e f0 ff ff       	jmp    80106ebb <alltraps>

80107e6d <vector234>:
.globl vector234
vector234:
  pushl $0
80107e6d:	6a 00                	push   $0x0
  pushl $234
80107e6f:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107e74:	e9 42 f0 ff ff       	jmp    80106ebb <alltraps>

80107e79 <vector235>:
.globl vector235
vector235:
  pushl $0
80107e79:	6a 00                	push   $0x0
  pushl $235
80107e7b:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107e80:	e9 36 f0 ff ff       	jmp    80106ebb <alltraps>

80107e85 <vector236>:
.globl vector236
vector236:
  pushl $0
80107e85:	6a 00                	push   $0x0
  pushl $236
80107e87:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107e8c:	e9 2a f0 ff ff       	jmp    80106ebb <alltraps>

80107e91 <vector237>:
.globl vector237
vector237:
  pushl $0
80107e91:	6a 00                	push   $0x0
  pushl $237
80107e93:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107e98:	e9 1e f0 ff ff       	jmp    80106ebb <alltraps>

80107e9d <vector238>:
.globl vector238
vector238:
  pushl $0
80107e9d:	6a 00                	push   $0x0
  pushl $238
80107e9f:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107ea4:	e9 12 f0 ff ff       	jmp    80106ebb <alltraps>

80107ea9 <vector239>:
.globl vector239
vector239:
  pushl $0
80107ea9:	6a 00                	push   $0x0
  pushl $239
80107eab:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107eb0:	e9 06 f0 ff ff       	jmp    80106ebb <alltraps>

80107eb5 <vector240>:
.globl vector240
vector240:
  pushl $0
80107eb5:	6a 00                	push   $0x0
  pushl $240
80107eb7:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107ebc:	e9 fa ef ff ff       	jmp    80106ebb <alltraps>

80107ec1 <vector241>:
.globl vector241
vector241:
  pushl $0
80107ec1:	6a 00                	push   $0x0
  pushl $241
80107ec3:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107ec8:	e9 ee ef ff ff       	jmp    80106ebb <alltraps>

80107ecd <vector242>:
.globl vector242
vector242:
  pushl $0
80107ecd:	6a 00                	push   $0x0
  pushl $242
80107ecf:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107ed4:	e9 e2 ef ff ff       	jmp    80106ebb <alltraps>

80107ed9 <vector243>:
.globl vector243
vector243:
  pushl $0
80107ed9:	6a 00                	push   $0x0
  pushl $243
80107edb:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107ee0:	e9 d6 ef ff ff       	jmp    80106ebb <alltraps>

80107ee5 <vector244>:
.globl vector244
vector244:
  pushl $0
80107ee5:	6a 00                	push   $0x0
  pushl $244
80107ee7:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107eec:	e9 ca ef ff ff       	jmp    80106ebb <alltraps>

80107ef1 <vector245>:
.globl vector245
vector245:
  pushl $0
80107ef1:	6a 00                	push   $0x0
  pushl $245
80107ef3:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107ef8:	e9 be ef ff ff       	jmp    80106ebb <alltraps>

80107efd <vector246>:
.globl vector246
vector246:
  pushl $0
80107efd:	6a 00                	push   $0x0
  pushl $246
80107eff:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107f04:	e9 b2 ef ff ff       	jmp    80106ebb <alltraps>

80107f09 <vector247>:
.globl vector247
vector247:
  pushl $0
80107f09:	6a 00                	push   $0x0
  pushl $247
80107f0b:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107f10:	e9 a6 ef ff ff       	jmp    80106ebb <alltraps>

80107f15 <vector248>:
.globl vector248
vector248:
  pushl $0
80107f15:	6a 00                	push   $0x0
  pushl $248
80107f17:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107f1c:	e9 9a ef ff ff       	jmp    80106ebb <alltraps>

80107f21 <vector249>:
.globl vector249
vector249:
  pushl $0
80107f21:	6a 00                	push   $0x0
  pushl $249
80107f23:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107f28:	e9 8e ef ff ff       	jmp    80106ebb <alltraps>

80107f2d <vector250>:
.globl vector250
vector250:
  pushl $0
80107f2d:	6a 00                	push   $0x0
  pushl $250
80107f2f:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107f34:	e9 82 ef ff ff       	jmp    80106ebb <alltraps>

80107f39 <vector251>:
.globl vector251
vector251:
  pushl $0
80107f39:	6a 00                	push   $0x0
  pushl $251
80107f3b:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107f40:	e9 76 ef ff ff       	jmp    80106ebb <alltraps>

80107f45 <vector252>:
.globl vector252
vector252:
  pushl $0
80107f45:	6a 00                	push   $0x0
  pushl $252
80107f47:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107f4c:	e9 6a ef ff ff       	jmp    80106ebb <alltraps>

80107f51 <vector253>:
.globl vector253
vector253:
  pushl $0
80107f51:	6a 00                	push   $0x0
  pushl $253
80107f53:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107f58:	e9 5e ef ff ff       	jmp    80106ebb <alltraps>

80107f5d <vector254>:
.globl vector254
vector254:
  pushl $0
80107f5d:	6a 00                	push   $0x0
  pushl $254
80107f5f:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107f64:	e9 52 ef ff ff       	jmp    80106ebb <alltraps>

80107f69 <vector255>:
.globl vector255
vector255:
  pushl $0
80107f69:	6a 00                	push   $0x0
  pushl $255
80107f6b:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107f70:	e9 46 ef ff ff       	jmp    80106ebb <alltraps>

80107f75 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107f75:	55                   	push   %ebp
80107f76:	89 e5                	mov    %esp,%ebp
80107f78:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f7e:	83 e8 01             	sub    $0x1,%eax
80107f81:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107f85:	8b 45 08             	mov    0x8(%ebp),%eax
80107f88:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107f8c:	8b 45 08             	mov    0x8(%ebp),%eax
80107f8f:	c1 e8 10             	shr    $0x10,%eax
80107f92:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107f96:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107f99:	0f 01 10             	lgdtl  (%eax)
}
80107f9c:	c9                   	leave  
80107f9d:	c3                   	ret    

80107f9e <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107f9e:	55                   	push   %ebp
80107f9f:	89 e5                	mov    %esp,%ebp
80107fa1:	83 ec 04             	sub    $0x4,%esp
80107fa4:	8b 45 08             	mov    0x8(%ebp),%eax
80107fa7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107fab:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107faf:	0f 00 d8             	ltr    %ax
}
80107fb2:	c9                   	leave  
80107fb3:	c3                   	ret    

80107fb4 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107fb4:	55                   	push   %ebp
80107fb5:	89 e5                	mov    %esp,%ebp
80107fb7:	83 ec 04             	sub    $0x4,%esp
80107fba:	8b 45 08             	mov    0x8(%ebp),%eax
80107fbd:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107fc1:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107fc5:	8e e8                	mov    %eax,%gs
}
80107fc7:	c9                   	leave  
80107fc8:	c3                   	ret    

80107fc9 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107fc9:	55                   	push   %ebp
80107fca:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107fcc:	8b 45 08             	mov    0x8(%ebp),%eax
80107fcf:	0f 22 d8             	mov    %eax,%cr3
}
80107fd2:	5d                   	pop    %ebp
80107fd3:	c3                   	ret    

80107fd4 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107fd4:	55                   	push   %ebp
80107fd5:	89 e5                	mov    %esp,%ebp
80107fd7:	8b 45 08             	mov    0x8(%ebp),%eax
80107fda:	05 00 00 00 80       	add    $0x80000000,%eax
80107fdf:	5d                   	pop    %ebp
80107fe0:	c3                   	ret    

80107fe1 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107fe1:	55                   	push   %ebp
80107fe2:	89 e5                	mov    %esp,%ebp
80107fe4:	8b 45 08             	mov    0x8(%ebp),%eax
80107fe7:	05 00 00 00 80       	add    $0x80000000,%eax
80107fec:	5d                   	pop    %ebp
80107fed:	c3                   	ret    

80107fee <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107fee:	55                   	push   %ebp
80107fef:	89 e5                	mov    %esp,%ebp
80107ff1:	53                   	push   %ebx
80107ff2:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107ff5:	e8 0c b3 ff ff       	call   80103306 <cpunum>
80107ffa:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80108000:	05 80 34 11 80       	add    $0x80113480,%eax
80108005:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108008:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010800b:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80108011:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108014:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
8010801a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010801d:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80108021:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108024:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108028:	83 e2 f0             	and    $0xfffffff0,%edx
8010802b:	83 ca 0a             	or     $0xa,%edx
8010802e:	88 50 7d             	mov    %dl,0x7d(%eax)
80108031:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108034:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108038:	83 ca 10             	or     $0x10,%edx
8010803b:	88 50 7d             	mov    %dl,0x7d(%eax)
8010803e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108041:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108045:	83 e2 9f             	and    $0xffffff9f,%edx
80108048:	88 50 7d             	mov    %dl,0x7d(%eax)
8010804b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010804e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108052:	83 ca 80             	or     $0xffffff80,%edx
80108055:	88 50 7d             	mov    %dl,0x7d(%eax)
80108058:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010805b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010805f:	83 ca 0f             	or     $0xf,%edx
80108062:	88 50 7e             	mov    %dl,0x7e(%eax)
80108065:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108068:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010806c:	83 e2 ef             	and    $0xffffffef,%edx
8010806f:	88 50 7e             	mov    %dl,0x7e(%eax)
80108072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108075:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108079:	83 e2 df             	and    $0xffffffdf,%edx
8010807c:	88 50 7e             	mov    %dl,0x7e(%eax)
8010807f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108082:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108086:	83 ca 40             	or     $0x40,%edx
80108089:	88 50 7e             	mov    %dl,0x7e(%eax)
8010808c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010808f:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108093:	83 ca 80             	or     $0xffffff80,%edx
80108096:	88 50 7e             	mov    %dl,0x7e(%eax)
80108099:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010809c:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801080a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a3:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801080aa:	ff ff 
801080ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080af:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801080b6:	00 00 
801080b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080bb:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801080c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c5:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801080cc:	83 e2 f0             	and    $0xfffffff0,%edx
801080cf:	83 ca 02             	or     $0x2,%edx
801080d2:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801080d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080db:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801080e2:	83 ca 10             	or     $0x10,%edx
801080e5:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801080eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ee:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801080f5:	83 e2 9f             	and    $0xffffff9f,%edx
801080f8:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801080fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108101:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108108:	83 ca 80             	or     $0xffffff80,%edx
8010810b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108111:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108114:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010811b:	83 ca 0f             	or     $0xf,%edx
8010811e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108124:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108127:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010812e:	83 e2 ef             	and    $0xffffffef,%edx
80108131:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108137:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010813a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108141:	83 e2 df             	and    $0xffffffdf,%edx
80108144:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010814a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010814d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108154:	83 ca 40             	or     $0x40,%edx
80108157:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010815d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108160:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108167:	83 ca 80             	or     $0xffffff80,%edx
8010816a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108170:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108173:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010817a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010817d:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80108184:	ff ff 
80108186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108189:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80108190:	00 00 
80108192:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108195:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
8010819c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010819f:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801081a6:	83 e2 f0             	and    $0xfffffff0,%edx
801081a9:	83 ca 0a             	or     $0xa,%edx
801081ac:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801081b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b5:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801081bc:	83 ca 10             	or     $0x10,%edx
801081bf:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801081c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c8:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801081cf:	83 ca 60             	or     $0x60,%edx
801081d2:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801081d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081db:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801081e2:	83 ca 80             	or     $0xffffff80,%edx
801081e5:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801081eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ee:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801081f5:	83 ca 0f             	or     $0xf,%edx
801081f8:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108201:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108208:	83 e2 ef             	and    $0xffffffef,%edx
8010820b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108211:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108214:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010821b:	83 e2 df             	and    $0xffffffdf,%edx
8010821e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108224:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108227:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010822e:	83 ca 40             	or     $0x40,%edx
80108231:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108237:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010823a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108241:	83 ca 80             	or     $0xffffff80,%edx
80108244:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010824a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010824d:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108254:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108257:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
8010825e:	ff ff 
80108260:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108263:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
8010826a:	00 00 
8010826c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010826f:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80108276:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108279:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108280:	83 e2 f0             	and    $0xfffffff0,%edx
80108283:	83 ca 02             	or     $0x2,%edx
80108286:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010828c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010828f:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108296:	83 ca 10             	or     $0x10,%edx
80108299:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010829f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a2:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801082a9:	83 ca 60             	or     $0x60,%edx
801082ac:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801082b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082b5:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801082bc:	83 ca 80             	or     $0xffffff80,%edx
801082bf:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801082c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082c8:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801082cf:	83 ca 0f             	or     $0xf,%edx
801082d2:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801082d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082db:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801082e2:	83 e2 ef             	and    $0xffffffef,%edx
801082e5:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801082eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ee:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801082f5:	83 e2 df             	and    $0xffffffdf,%edx
801082f8:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801082fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108301:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108308:	83 ca 40             	or     $0x40,%edx
8010830b:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108311:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108314:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010831b:	83 ca 80             	or     $0xffffff80,%edx
8010831e:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108324:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108327:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010832e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108331:	05 b4 00 00 00       	add    $0xb4,%eax
80108336:	89 c3                	mov    %eax,%ebx
80108338:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010833b:	05 b4 00 00 00       	add    $0xb4,%eax
80108340:	c1 e8 10             	shr    $0x10,%eax
80108343:	89 c2                	mov    %eax,%edx
80108345:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108348:	05 b4 00 00 00       	add    $0xb4,%eax
8010834d:	c1 e8 18             	shr    $0x18,%eax
80108350:	89 c1                	mov    %eax,%ecx
80108352:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108355:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
8010835c:	00 00 
8010835e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108361:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108368:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010836b:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80108371:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108374:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010837b:	83 e2 f0             	and    $0xfffffff0,%edx
8010837e:	83 ca 02             	or     $0x2,%edx
80108381:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108387:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010838a:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108391:	83 ca 10             	or     $0x10,%edx
80108394:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010839a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010839d:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801083a4:	83 e2 9f             	and    $0xffffff9f,%edx
801083a7:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801083ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083b0:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801083b7:	83 ca 80             	or     $0xffffff80,%edx
801083ba:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801083c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083c3:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801083ca:	83 e2 f0             	and    $0xfffffff0,%edx
801083cd:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801083d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083d6:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801083dd:	83 e2 ef             	and    $0xffffffef,%edx
801083e0:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801083e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083e9:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801083f0:	83 e2 df             	and    $0xffffffdf,%edx
801083f3:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801083f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083fc:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108403:	83 ca 40             	or     $0x40,%edx
80108406:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010840c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010840f:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108416:	83 ca 80             	or     $0xffffff80,%edx
80108419:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010841f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108422:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108428:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010842b:	83 c0 70             	add    $0x70,%eax
8010842e:	83 ec 08             	sub    $0x8,%esp
80108431:	6a 38                	push   $0x38
80108433:	50                   	push   %eax
80108434:	e8 3c fb ff ff       	call   80107f75 <lgdt>
80108439:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
8010843c:	83 ec 0c             	sub    $0xc,%esp
8010843f:	6a 18                	push   $0x18
80108441:	e8 6e fb ff ff       	call   80107fb4 <loadgs>
80108446:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80108449:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010844c:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80108452:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108459:	00 00 00 00 
}
8010845d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108460:	c9                   	leave  
80108461:	c3                   	ret    

80108462 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80108462:	55                   	push   %ebp
80108463:	89 e5                	mov    %esp,%ebp
80108465:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108468:	8b 45 0c             	mov    0xc(%ebp),%eax
8010846b:	c1 e8 16             	shr    $0x16,%eax
8010846e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108475:	8b 45 08             	mov    0x8(%ebp),%eax
80108478:	01 d0                	add    %edx,%eax
8010847a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
8010847d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108480:	8b 00                	mov    (%eax),%eax
80108482:	83 e0 01             	and    $0x1,%eax
80108485:	85 c0                	test   %eax,%eax
80108487:	74 18                	je     801084a1 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80108489:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010848c:	8b 00                	mov    (%eax),%eax
8010848e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108493:	50                   	push   %eax
80108494:	e8 48 fb ff ff       	call   80107fe1 <p2v>
80108499:	83 c4 04             	add    $0x4,%esp
8010849c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010849f:	eb 48                	jmp    801084e9 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801084a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801084a5:	74 0e                	je     801084b5 <walkpgdir+0x53>
801084a7:	e8 45 aa ff ff       	call   80102ef1 <kalloc>
801084ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
801084af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801084b3:	75 07                	jne    801084bc <walkpgdir+0x5a>
      return 0;
801084b5:	b8 00 00 00 00       	mov    $0x0,%eax
801084ba:	eb 44                	jmp    80108500 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801084bc:	83 ec 04             	sub    $0x4,%esp
801084bf:	68 00 10 00 00       	push   $0x1000
801084c4:	6a 00                	push   $0x0
801084c6:	ff 75 f4             	pushl  -0xc(%ebp)
801084c9:	e8 97 d2 ff ff       	call   80105765 <memset>
801084ce:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801084d1:	83 ec 0c             	sub    $0xc,%esp
801084d4:	ff 75 f4             	pushl  -0xc(%ebp)
801084d7:	e8 f8 fa ff ff       	call   80107fd4 <v2p>
801084dc:	83 c4 10             	add    $0x10,%esp
801084df:	83 c8 07             	or     $0x7,%eax
801084e2:	89 c2                	mov    %eax,%edx
801084e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084e7:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801084e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801084ec:	c1 e8 0c             	shr    $0xc,%eax
801084ef:	25 ff 03 00 00       	and    $0x3ff,%eax
801084f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801084fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084fe:	01 d0                	add    %edx,%eax
}
80108500:	c9                   	leave  
80108501:	c3                   	ret    

80108502 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108502:	55                   	push   %ebp
80108503:	89 e5                	mov    %esp,%ebp
80108505:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108508:	8b 45 0c             	mov    0xc(%ebp),%eax
8010850b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108510:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108513:	8b 55 0c             	mov    0xc(%ebp),%edx
80108516:	8b 45 10             	mov    0x10(%ebp),%eax
80108519:	01 d0                	add    %edx,%eax
8010851b:	83 e8 01             	sub    $0x1,%eax
8010851e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108523:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108526:	83 ec 04             	sub    $0x4,%esp
80108529:	6a 01                	push   $0x1
8010852b:	ff 75 f4             	pushl  -0xc(%ebp)
8010852e:	ff 75 08             	pushl  0x8(%ebp)
80108531:	e8 2c ff ff ff       	call   80108462 <walkpgdir>
80108536:	83 c4 10             	add    $0x10,%esp
80108539:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010853c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108540:	75 07                	jne    80108549 <mappages+0x47>
      return -1;
80108542:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108547:	eb 49                	jmp    80108592 <mappages+0x90>
    if(*pte & PTE_P)
80108549:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010854c:	8b 00                	mov    (%eax),%eax
8010854e:	83 e0 01             	and    $0x1,%eax
80108551:	85 c0                	test   %eax,%eax
80108553:	74 0d                	je     80108562 <mappages+0x60>
      panic("remap");
80108555:	83 ec 0c             	sub    $0xc,%esp
80108558:	68 34 95 10 80       	push   $0x80109534
8010855d:	e8 41 80 ff ff       	call   801005a3 <panic>
    *pte = pa | perm | PTE_P;
80108562:	8b 45 18             	mov    0x18(%ebp),%eax
80108565:	0b 45 14             	or     0x14(%ebp),%eax
80108568:	83 c8 01             	or     $0x1,%eax
8010856b:	89 c2                	mov    %eax,%edx
8010856d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108570:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108572:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108575:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108578:	75 08                	jne    80108582 <mappages+0x80>
      break;
8010857a:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010857b:	b8 00 00 00 00       	mov    $0x0,%eax
80108580:	eb 10                	jmp    80108592 <mappages+0x90>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80108582:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108589:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80108590:	eb 94                	jmp    80108526 <mappages+0x24>
  return 0;
}
80108592:	c9                   	leave  
80108593:	c3                   	ret    

80108594 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80108594:	55                   	push   %ebp
80108595:	89 e5                	mov    %esp,%ebp
80108597:	53                   	push   %ebx
80108598:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
8010859b:	e8 51 a9 ff ff       	call   80102ef1 <kalloc>
801085a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801085a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801085a7:	75 0a                	jne    801085b3 <setupkvm+0x1f>
    return 0;
801085a9:	b8 00 00 00 00       	mov    $0x0,%eax
801085ae:	e9 8e 00 00 00       	jmp    80108641 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
801085b3:	83 ec 04             	sub    $0x4,%esp
801085b6:	68 00 10 00 00       	push   $0x1000
801085bb:	6a 00                	push   $0x0
801085bd:	ff 75 f0             	pushl  -0x10(%ebp)
801085c0:	e8 a0 d1 ff ff       	call   80105765 <memset>
801085c5:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801085c8:	83 ec 0c             	sub    $0xc,%esp
801085cb:	68 00 00 00 0e       	push   $0xe000000
801085d0:	e8 0c fa ff ff       	call   80107fe1 <p2v>
801085d5:	83 c4 10             	add    $0x10,%esp
801085d8:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801085dd:	76 0d                	jbe    801085ec <setupkvm+0x58>
    panic("PHYSTOP too high");
801085df:	83 ec 0c             	sub    $0xc,%esp
801085e2:	68 3a 95 10 80       	push   $0x8010953a
801085e7:	e8 b7 7f ff ff       	call   801005a3 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801085ec:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
801085f3:	eb 40                	jmp    80108635 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801085f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085f8:	8b 48 0c             	mov    0xc(%eax),%ecx
801085fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085fe:	8b 50 04             	mov    0x4(%eax),%edx
80108601:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108604:	8b 58 08             	mov    0x8(%eax),%ebx
80108607:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010860a:	8b 40 04             	mov    0x4(%eax),%eax
8010860d:	29 c3                	sub    %eax,%ebx
8010860f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108612:	8b 00                	mov    (%eax),%eax
80108614:	83 ec 0c             	sub    $0xc,%esp
80108617:	51                   	push   %ecx
80108618:	52                   	push   %edx
80108619:	53                   	push   %ebx
8010861a:	50                   	push   %eax
8010861b:	ff 75 f0             	pushl  -0x10(%ebp)
8010861e:	e8 df fe ff ff       	call   80108502 <mappages>
80108623:	83 c4 20             	add    $0x20,%esp
80108626:	85 c0                	test   %eax,%eax
80108628:	79 07                	jns    80108631 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
8010862a:	b8 00 00 00 00       	mov    $0x0,%eax
8010862f:	eb 10                	jmp    80108641 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108631:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108635:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
8010863c:	72 b7                	jb     801085f5 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
8010863e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108641:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108644:	c9                   	leave  
80108645:	c3                   	ret    

80108646 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108646:	55                   	push   %ebp
80108647:	89 e5                	mov    %esp,%ebp
80108649:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010864c:	e8 43 ff ff ff       	call   80108594 <setupkvm>
80108651:	a3 d8 63 11 80       	mov    %eax,0x801163d8
  switchkvm();
80108656:	e8 02 00 00 00       	call   8010865d <switchkvm>
}
8010865b:	c9                   	leave  
8010865c:	c3                   	ret    

8010865d <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010865d:	55                   	push   %ebp
8010865e:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80108660:	a1 d8 63 11 80       	mov    0x801163d8,%eax
80108665:	50                   	push   %eax
80108666:	e8 69 f9 ff ff       	call   80107fd4 <v2p>
8010866b:	83 c4 04             	add    $0x4,%esp
8010866e:	50                   	push   %eax
8010866f:	e8 55 f9 ff ff       	call   80107fc9 <lcr3>
80108674:	83 c4 04             	add    $0x4,%esp
}
80108677:	c9                   	leave  
80108678:	c3                   	ret    

80108679 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108679:	55                   	push   %ebp
8010867a:	89 e5                	mov    %esp,%ebp
8010867c:	56                   	push   %esi
8010867d:	53                   	push   %ebx
  pushcli();
8010867e:	e8 c6 cf ff ff       	call   80105649 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108683:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108689:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108690:	83 c2 08             	add    $0x8,%edx
80108693:	89 d6                	mov    %edx,%esi
80108695:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010869c:	83 c2 08             	add    $0x8,%edx
8010869f:	c1 ea 10             	shr    $0x10,%edx
801086a2:	89 d3                	mov    %edx,%ebx
801086a4:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801086ab:	83 c2 08             	add    $0x8,%edx
801086ae:	c1 ea 18             	shr    $0x18,%edx
801086b1:	89 d1                	mov    %edx,%ecx
801086b3:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801086ba:	67 00 
801086bc:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
801086c3:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
801086c9:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801086d0:	83 e2 f0             	and    $0xfffffff0,%edx
801086d3:	83 ca 09             	or     $0x9,%edx
801086d6:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801086dc:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801086e3:	83 ca 10             	or     $0x10,%edx
801086e6:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801086ec:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801086f3:	83 e2 9f             	and    $0xffffff9f,%edx
801086f6:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801086fc:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108703:	83 ca 80             	or     $0xffffff80,%edx
80108706:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010870c:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108713:	83 e2 f0             	and    $0xfffffff0,%edx
80108716:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010871c:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108723:	83 e2 ef             	and    $0xffffffef,%edx
80108726:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010872c:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108733:	83 e2 df             	and    $0xffffffdf,%edx
80108736:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010873c:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108743:	83 ca 40             	or     $0x40,%edx
80108746:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010874c:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108753:	83 e2 7f             	and    $0x7f,%edx
80108756:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010875c:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80108762:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108768:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010876f:	83 e2 ef             	and    $0xffffffef,%edx
80108772:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80108778:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010877e:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108784:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010878a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80108791:	8b 52 08             	mov    0x8(%edx),%edx
80108794:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010879a:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
8010879d:	83 ec 0c             	sub    $0xc,%esp
801087a0:	6a 30                	push   $0x30
801087a2:	e8 f7 f7 ff ff       	call   80107f9e <ltr>
801087a7:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
801087aa:	8b 45 08             	mov    0x8(%ebp),%eax
801087ad:	8b 40 04             	mov    0x4(%eax),%eax
801087b0:	85 c0                	test   %eax,%eax
801087b2:	75 0d                	jne    801087c1 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
801087b4:	83 ec 0c             	sub    $0xc,%esp
801087b7:	68 4b 95 10 80       	push   $0x8010954b
801087bc:	e8 e2 7d ff ff       	call   801005a3 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
801087c1:	8b 45 08             	mov    0x8(%ebp),%eax
801087c4:	8b 40 04             	mov    0x4(%eax),%eax
801087c7:	83 ec 0c             	sub    $0xc,%esp
801087ca:	50                   	push   %eax
801087cb:	e8 04 f8 ff ff       	call   80107fd4 <v2p>
801087d0:	83 c4 10             	add    $0x10,%esp
801087d3:	83 ec 0c             	sub    $0xc,%esp
801087d6:	50                   	push   %eax
801087d7:	e8 ed f7 ff ff       	call   80107fc9 <lcr3>
801087dc:	83 c4 10             	add    $0x10,%esp
  popcli();
801087df:	e8 a9 ce ff ff       	call   8010568d <popcli>
}
801087e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801087e7:	5b                   	pop    %ebx
801087e8:	5e                   	pop    %esi
801087e9:	5d                   	pop    %ebp
801087ea:	c3                   	ret    

801087eb <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801087eb:	55                   	push   %ebp
801087ec:	89 e5                	mov    %esp,%ebp
801087ee:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
801087f1:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801087f8:	76 0d                	jbe    80108807 <inituvm+0x1c>
    panic("inituvm: more than a page");
801087fa:	83 ec 0c             	sub    $0xc,%esp
801087fd:	68 5f 95 10 80       	push   $0x8010955f
80108802:	e8 9c 7d ff ff       	call   801005a3 <panic>
  mem = kalloc();
80108807:	e8 e5 a6 ff ff       	call   80102ef1 <kalloc>
8010880c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010880f:	83 ec 04             	sub    $0x4,%esp
80108812:	68 00 10 00 00       	push   $0x1000
80108817:	6a 00                	push   $0x0
80108819:	ff 75 f4             	pushl  -0xc(%ebp)
8010881c:	e8 44 cf ff ff       	call   80105765 <memset>
80108821:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108824:	83 ec 0c             	sub    $0xc,%esp
80108827:	ff 75 f4             	pushl  -0xc(%ebp)
8010882a:	e8 a5 f7 ff ff       	call   80107fd4 <v2p>
8010882f:	83 c4 10             	add    $0x10,%esp
80108832:	83 ec 0c             	sub    $0xc,%esp
80108835:	6a 06                	push   $0x6
80108837:	50                   	push   %eax
80108838:	68 00 10 00 00       	push   $0x1000
8010883d:	6a 00                	push   $0x0
8010883f:	ff 75 08             	pushl  0x8(%ebp)
80108842:	e8 bb fc ff ff       	call   80108502 <mappages>
80108847:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
8010884a:	83 ec 04             	sub    $0x4,%esp
8010884d:	ff 75 10             	pushl  0x10(%ebp)
80108850:	ff 75 0c             	pushl  0xc(%ebp)
80108853:	ff 75 f4             	pushl  -0xc(%ebp)
80108856:	e8 c9 cf ff ff       	call   80105824 <memmove>
8010885b:	83 c4 10             	add    $0x10,%esp
}
8010885e:	c9                   	leave  
8010885f:	c3                   	ret    

80108860 <loaduvm>:
// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
//20160313--
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108860:	55                   	push   %ebp
80108861:	89 e5                	mov    %esp,%ebp
80108863:	53                   	push   %ebx
80108864:	83 ec 14             	sub    $0x14,%esp
//20160313--
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108867:	8b 45 0c             	mov    0xc(%ebp),%eax
8010886a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010886f:	85 c0                	test   %eax,%eax
80108871:	74 0d                	je     80108880 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80108873:	83 ec 0c             	sub    $0xc,%esp
80108876:	68 7c 95 10 80       	push   $0x8010957c
8010887b:	e8 23 7d ff ff       	call   801005a3 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108880:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108887:	e9 95 00 00 00       	jmp    80108921 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010888c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010888f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108892:	01 d0                	add    %edx,%eax
80108894:	83 ec 04             	sub    $0x4,%esp
80108897:	6a 00                	push   $0x0
80108899:	50                   	push   %eax
8010889a:	ff 75 08             	pushl  0x8(%ebp)
8010889d:	e8 c0 fb ff ff       	call   80108462 <walkpgdir>
801088a2:	83 c4 10             	add    $0x10,%esp
801088a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
801088a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801088ac:	75 0d                	jne    801088bb <loaduvm+0x5b>
      panic("loaduvm: address should exist");
801088ae:	83 ec 0c             	sub    $0xc,%esp
801088b1:	68 9f 95 10 80       	push   $0x8010959f
801088b6:	e8 e8 7c ff ff       	call   801005a3 <panic>
//20160313--
    pa = PTE_ADDR(*pte);
801088bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088be:	8b 00                	mov    (%eax),%eax
801088c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
//20160313--
    if(sz - i < PGSIZE)
801088c8:	8b 45 18             	mov    0x18(%ebp),%eax
801088cb:	2b 45 f4             	sub    -0xc(%ebp),%eax
801088ce:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801088d3:	77 0b                	ja     801088e0 <loaduvm+0x80>
      n = sz - i;
801088d5:	8b 45 18             	mov    0x18(%ebp),%eax
801088d8:	2b 45 f4             	sub    -0xc(%ebp),%eax
801088db:	89 45 f0             	mov    %eax,-0x10(%ebp)
801088de:	eb 07                	jmp    801088e7 <loaduvm+0x87>
    else
      n = PGSIZE;
801088e0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
//20160313--
    if(readi(ip, p2v(pa), offset+i, n) != n)
801088e7:	8b 55 14             	mov    0x14(%ebp),%edx
801088ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088ed:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801088f0:	83 ec 0c             	sub    $0xc,%esp
801088f3:	ff 75 e8             	pushl  -0x18(%ebp)
801088f6:	e8 e6 f6 ff ff       	call   80107fe1 <p2v>
801088fb:	83 c4 10             	add    $0x10,%esp
801088fe:	ff 75 f0             	pushl  -0x10(%ebp)
80108901:	53                   	push   %ebx
80108902:	50                   	push   %eax
80108903:	ff 75 10             	pushl  0x10(%ebp)
80108906:	e8 38 96 ff ff       	call   80101f43 <readi>
8010890b:	83 c4 10             	add    $0x10,%esp
8010890e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108911:	74 07                	je     8010891a <loaduvm+0xba>
      return -1;
80108913:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108918:	eb 18                	jmp    80108932 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010891a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108921:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108924:	3b 45 18             	cmp    0x18(%ebp),%eax
80108927:	0f 82 5f ff ff ff    	jb     8010888c <loaduvm+0x2c>
      n = PGSIZE;
//20160313--
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010892d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108932:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108935:	c9                   	leave  
80108936:	c3                   	ret    

80108937 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108937:	55                   	push   %ebp
80108938:	89 e5                	mov    %esp,%ebp
8010893a:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010893d:	8b 45 10             	mov    0x10(%ebp),%eax
80108940:	85 c0                	test   %eax,%eax
80108942:	79 0a                	jns    8010894e <allocuvm+0x17>
    return 0;
80108944:	b8 00 00 00 00       	mov    $0x0,%eax
80108949:	e9 b0 00 00 00       	jmp    801089fe <allocuvm+0xc7>
  if(newsz < oldsz)
8010894e:	8b 45 10             	mov    0x10(%ebp),%eax
80108951:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108954:	73 08                	jae    8010895e <allocuvm+0x27>
    return oldsz;
80108956:	8b 45 0c             	mov    0xc(%ebp),%eax
80108959:	e9 a0 00 00 00       	jmp    801089fe <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
8010895e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108961:	05 ff 0f 00 00       	add    $0xfff,%eax
80108966:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010896b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010896e:	eb 7f                	jmp    801089ef <allocuvm+0xb8>
    mem = kalloc();
80108970:	e8 7c a5 ff ff       	call   80102ef1 <kalloc>
80108975:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108978:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010897c:	75 2b                	jne    801089a9 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
8010897e:	83 ec 0c             	sub    $0xc,%esp
80108981:	68 bd 95 10 80       	push   $0x801095bd
80108986:	e8 7b 7a ff ff       	call   80100406 <cprintf>
8010898b:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
8010898e:	83 ec 04             	sub    $0x4,%esp
80108991:	ff 75 0c             	pushl  0xc(%ebp)
80108994:	ff 75 10             	pushl  0x10(%ebp)
80108997:	ff 75 08             	pushl  0x8(%ebp)
8010899a:	e8 61 00 00 00       	call   80108a00 <deallocuvm>
8010899f:	83 c4 10             	add    $0x10,%esp
      return 0;
801089a2:	b8 00 00 00 00       	mov    $0x0,%eax
801089a7:	eb 55                	jmp    801089fe <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
801089a9:	83 ec 04             	sub    $0x4,%esp
801089ac:	68 00 10 00 00       	push   $0x1000
801089b1:	6a 00                	push   $0x0
801089b3:	ff 75 f0             	pushl  -0x10(%ebp)
801089b6:	e8 aa cd ff ff       	call   80105765 <memset>
801089bb:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801089be:	83 ec 0c             	sub    $0xc,%esp
801089c1:	ff 75 f0             	pushl  -0x10(%ebp)
801089c4:	e8 0b f6 ff ff       	call   80107fd4 <v2p>
801089c9:	83 c4 10             	add    $0x10,%esp
801089cc:	89 c2                	mov    %eax,%edx
801089ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089d1:	83 ec 0c             	sub    $0xc,%esp
801089d4:	6a 06                	push   $0x6
801089d6:	52                   	push   %edx
801089d7:	68 00 10 00 00       	push   $0x1000
801089dc:	50                   	push   %eax
801089dd:	ff 75 08             	pushl  0x8(%ebp)
801089e0:	e8 1d fb ff ff       	call   80108502 <mappages>
801089e5:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801089e8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801089ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089f2:	3b 45 10             	cmp    0x10(%ebp),%eax
801089f5:	0f 82 75 ff ff ff    	jb     80108970 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
801089fb:	8b 45 10             	mov    0x10(%ebp),%eax
}
801089fe:	c9                   	leave  
801089ff:	c3                   	ret    

80108a00 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108a00:	55                   	push   %ebp
80108a01:	89 e5                	mov    %esp,%ebp
80108a03:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108a06:	8b 45 10             	mov    0x10(%ebp),%eax
80108a09:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108a0c:	72 08                	jb     80108a16 <deallocuvm+0x16>
    return oldsz;
80108a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a11:	e9 a5 00 00 00       	jmp    80108abb <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80108a16:	8b 45 10             	mov    0x10(%ebp),%eax
80108a19:	05 ff 0f 00 00       	add    $0xfff,%eax
80108a1e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108a26:	e9 81 00 00 00       	jmp    80108aac <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a2e:	83 ec 04             	sub    $0x4,%esp
80108a31:	6a 00                	push   $0x0
80108a33:	50                   	push   %eax
80108a34:	ff 75 08             	pushl  0x8(%ebp)
80108a37:	e8 26 fa ff ff       	call   80108462 <walkpgdir>
80108a3c:	83 c4 10             	add    $0x10,%esp
80108a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108a42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108a46:	75 09                	jne    80108a51 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80108a48:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108a4f:	eb 54                	jmp    80108aa5 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80108a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a54:	8b 00                	mov    (%eax),%eax
80108a56:	83 e0 01             	and    $0x1,%eax
80108a59:	85 c0                	test   %eax,%eax
80108a5b:	74 48                	je     80108aa5 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80108a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a60:	8b 00                	mov    (%eax),%eax
80108a62:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a67:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108a6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108a6e:	75 0d                	jne    80108a7d <deallocuvm+0x7d>
        panic("kfree");
80108a70:	83 ec 0c             	sub    $0xc,%esp
80108a73:	68 d5 95 10 80       	push   $0x801095d5
80108a78:	e8 26 7b ff ff       	call   801005a3 <panic>
      char *v = p2v(pa);
80108a7d:	83 ec 0c             	sub    $0xc,%esp
80108a80:	ff 75 ec             	pushl  -0x14(%ebp)
80108a83:	e8 59 f5 ff ff       	call   80107fe1 <p2v>
80108a88:	83 c4 10             	add    $0x10,%esp
80108a8b:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108a8e:	83 ec 0c             	sub    $0xc,%esp
80108a91:	ff 75 e8             	pushl  -0x18(%ebp)
80108a94:	e8 bc a3 ff ff       	call   80102e55 <kfree>
80108a99:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108aa5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aaf:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108ab2:	0f 82 73 ff ff ff    	jb     80108a2b <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108ab8:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108abb:	c9                   	leave  
80108abc:	c3                   	ret    

80108abd <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108abd:	55                   	push   %ebp
80108abe:	89 e5                	mov    %esp,%ebp
80108ac0:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80108ac3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108ac7:	75 0d                	jne    80108ad6 <freevm+0x19>
    panic("freevm: no pgdir");
80108ac9:	83 ec 0c             	sub    $0xc,%esp
80108acc:	68 db 95 10 80       	push   $0x801095db
80108ad1:	e8 cd 7a ff ff       	call   801005a3 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108ad6:	83 ec 04             	sub    $0x4,%esp
80108ad9:	6a 00                	push   $0x0
80108adb:	68 00 00 00 80       	push   $0x80000000
80108ae0:	ff 75 08             	pushl  0x8(%ebp)
80108ae3:	e8 18 ff ff ff       	call   80108a00 <deallocuvm>
80108ae8:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108aeb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108af2:	eb 4f                	jmp    80108b43 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80108af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108af7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108afe:	8b 45 08             	mov    0x8(%ebp),%eax
80108b01:	01 d0                	add    %edx,%eax
80108b03:	8b 00                	mov    (%eax),%eax
80108b05:	83 e0 01             	and    $0x1,%eax
80108b08:	85 c0                	test   %eax,%eax
80108b0a:	74 33                	je     80108b3f <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b0f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108b16:	8b 45 08             	mov    0x8(%ebp),%eax
80108b19:	01 d0                	add    %edx,%eax
80108b1b:	8b 00                	mov    (%eax),%eax
80108b1d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b22:	83 ec 0c             	sub    $0xc,%esp
80108b25:	50                   	push   %eax
80108b26:	e8 b6 f4 ff ff       	call   80107fe1 <p2v>
80108b2b:	83 c4 10             	add    $0x10,%esp
80108b2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108b31:	83 ec 0c             	sub    $0xc,%esp
80108b34:	ff 75 f0             	pushl  -0x10(%ebp)
80108b37:	e8 19 a3 ff ff       	call   80102e55 <kfree>
80108b3c:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108b3f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108b43:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108b4a:	76 a8                	jbe    80108af4 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108b4c:	83 ec 0c             	sub    $0xc,%esp
80108b4f:	ff 75 08             	pushl  0x8(%ebp)
80108b52:	e8 fe a2 ff ff       	call   80102e55 <kfree>
80108b57:	83 c4 10             	add    $0x10,%esp
}
80108b5a:	c9                   	leave  
80108b5b:	c3                   	ret    

80108b5c <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108b5c:	55                   	push   %ebp
80108b5d:	89 e5                	mov    %esp,%ebp
80108b5f:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108b62:	83 ec 04             	sub    $0x4,%esp
80108b65:	6a 00                	push   $0x0
80108b67:	ff 75 0c             	pushl  0xc(%ebp)
80108b6a:	ff 75 08             	pushl  0x8(%ebp)
80108b6d:	e8 f0 f8 ff ff       	call   80108462 <walkpgdir>
80108b72:	83 c4 10             	add    $0x10,%esp
80108b75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108b78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108b7c:	75 0d                	jne    80108b8b <clearpteu+0x2f>
    panic("clearpteu");
80108b7e:	83 ec 0c             	sub    $0xc,%esp
80108b81:	68 ec 95 10 80       	push   $0x801095ec
80108b86:	e8 18 7a ff ff       	call   801005a3 <panic>
  *pte &= ~PTE_U;
80108b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b8e:	8b 00                	mov    (%eax),%eax
80108b90:	83 e0 fb             	and    $0xfffffffb,%eax
80108b93:	89 c2                	mov    %eax,%edx
80108b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b98:	89 10                	mov    %edx,(%eax)
}
80108b9a:	c9                   	leave  
80108b9b:	c3                   	ret    

80108b9c <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108b9c:	55                   	push   %ebp
80108b9d:	89 e5                	mov    %esp,%ebp
80108b9f:	53                   	push   %ebx
80108ba0:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108ba3:	e8 ec f9 ff ff       	call   80108594 <setupkvm>
80108ba8:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108bab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108baf:	75 0a                	jne    80108bbb <copyuvm+0x1f>
    return 0;
80108bb1:	b8 00 00 00 00       	mov    $0x0,%eax
80108bb6:	e9 f8 00 00 00       	jmp    80108cb3 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80108bbb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108bc2:	e9 c8 00 00 00       	jmp    80108c8f <copyuvm+0xf3>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bca:	83 ec 04             	sub    $0x4,%esp
80108bcd:	6a 00                	push   $0x0
80108bcf:	50                   	push   %eax
80108bd0:	ff 75 08             	pushl  0x8(%ebp)
80108bd3:	e8 8a f8 ff ff       	call   80108462 <walkpgdir>
80108bd8:	83 c4 10             	add    $0x10,%esp
80108bdb:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108bde:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108be2:	75 0d                	jne    80108bf1 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80108be4:	83 ec 0c             	sub    $0xc,%esp
80108be7:	68 f6 95 10 80       	push   $0x801095f6
80108bec:	e8 b2 79 ff ff       	call   801005a3 <panic>
    if(!(*pte & PTE_P))
80108bf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bf4:	8b 00                	mov    (%eax),%eax
80108bf6:	83 e0 01             	and    $0x1,%eax
80108bf9:	85 c0                	test   %eax,%eax
80108bfb:	75 0d                	jne    80108c0a <copyuvm+0x6e>
      panic("copyuvm: page not present");
80108bfd:	83 ec 0c             	sub    $0xc,%esp
80108c00:	68 10 96 10 80       	push   $0x80109610
80108c05:	e8 99 79 ff ff       	call   801005a3 <panic>
    pa = PTE_ADDR(*pte);
80108c0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c0d:	8b 00                	mov    (%eax),%eax
80108c0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c14:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108c17:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c1a:	8b 00                	mov    (%eax),%eax
80108c1c:	25 ff 0f 00 00       	and    $0xfff,%eax
80108c21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108c24:	e8 c8 a2 ff ff       	call   80102ef1 <kalloc>
80108c29:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108c2c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108c30:	75 02                	jne    80108c34 <copyuvm+0x98>
      goto bad;
80108c32:	eb 6c                	jmp    80108ca0 <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108c34:	83 ec 0c             	sub    $0xc,%esp
80108c37:	ff 75 e8             	pushl  -0x18(%ebp)
80108c3a:	e8 a2 f3 ff ff       	call   80107fe1 <p2v>
80108c3f:	83 c4 10             	add    $0x10,%esp
80108c42:	83 ec 04             	sub    $0x4,%esp
80108c45:	68 00 10 00 00       	push   $0x1000
80108c4a:	50                   	push   %eax
80108c4b:	ff 75 e0             	pushl  -0x20(%ebp)
80108c4e:	e8 d1 cb ff ff       	call   80105824 <memmove>
80108c53:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108c56:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108c59:	83 ec 0c             	sub    $0xc,%esp
80108c5c:	ff 75 e0             	pushl  -0x20(%ebp)
80108c5f:	e8 70 f3 ff ff       	call   80107fd4 <v2p>
80108c64:	83 c4 10             	add    $0x10,%esp
80108c67:	89 c2                	mov    %eax,%edx
80108c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c6c:	83 ec 0c             	sub    $0xc,%esp
80108c6f:	53                   	push   %ebx
80108c70:	52                   	push   %edx
80108c71:	68 00 10 00 00       	push   $0x1000
80108c76:	50                   	push   %eax
80108c77:	ff 75 f0             	pushl  -0x10(%ebp)
80108c7a:	e8 83 f8 ff ff       	call   80108502 <mappages>
80108c7f:	83 c4 20             	add    $0x20,%esp
80108c82:	85 c0                	test   %eax,%eax
80108c84:	79 02                	jns    80108c88 <copyuvm+0xec>
      goto bad;
80108c86:	eb 18                	jmp    80108ca0 <copyuvm+0x104>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108c88:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c92:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108c95:	0f 82 2c ff ff ff    	jb     80108bc7 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c9e:	eb 13                	jmp    80108cb3 <copyuvm+0x117>

bad:
  freevm(d);
80108ca0:	83 ec 0c             	sub    $0xc,%esp
80108ca3:	ff 75 f0             	pushl  -0x10(%ebp)
80108ca6:	e8 12 fe ff ff       	call   80108abd <freevm>
80108cab:	83 c4 10             	add    $0x10,%esp
  return 0;
80108cae:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108cb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108cb6:	c9                   	leave  
80108cb7:	c3                   	ret    

80108cb8 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108cb8:	55                   	push   %ebp
80108cb9:	89 e5                	mov    %esp,%ebp
80108cbb:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108cbe:	83 ec 04             	sub    $0x4,%esp
80108cc1:	6a 00                	push   $0x0
80108cc3:	ff 75 0c             	pushl  0xc(%ebp)
80108cc6:	ff 75 08             	pushl  0x8(%ebp)
80108cc9:	e8 94 f7 ff ff       	call   80108462 <walkpgdir>
80108cce:	83 c4 10             	add    $0x10,%esp
80108cd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cd7:	8b 00                	mov    (%eax),%eax
80108cd9:	83 e0 01             	and    $0x1,%eax
80108cdc:	85 c0                	test   %eax,%eax
80108cde:	75 07                	jne    80108ce7 <uva2ka+0x2f>
    return 0;
80108ce0:	b8 00 00 00 00       	mov    $0x0,%eax
80108ce5:	eb 29                	jmp    80108d10 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cea:	8b 00                	mov    (%eax),%eax
80108cec:	83 e0 04             	and    $0x4,%eax
80108cef:	85 c0                	test   %eax,%eax
80108cf1:	75 07                	jne    80108cfa <uva2ka+0x42>
    return 0;
80108cf3:	b8 00 00 00 00       	mov    $0x0,%eax
80108cf8:	eb 16                	jmp    80108d10 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80108cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cfd:	8b 00                	mov    (%eax),%eax
80108cff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108d04:	83 ec 0c             	sub    $0xc,%esp
80108d07:	50                   	push   %eax
80108d08:	e8 d4 f2 ff ff       	call   80107fe1 <p2v>
80108d0d:	83 c4 10             	add    $0x10,%esp
}
80108d10:	c9                   	leave  
80108d11:	c3                   	ret    

80108d12 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108d12:	55                   	push   %ebp
80108d13:	89 e5                	mov    %esp,%ebp
80108d15:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108d18:	8b 45 10             	mov    0x10(%ebp),%eax
80108d1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108d1e:	eb 7f                	jmp    80108d9f <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108d20:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108d28:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108d2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d2e:	83 ec 08             	sub    $0x8,%esp
80108d31:	50                   	push   %eax
80108d32:	ff 75 08             	pushl  0x8(%ebp)
80108d35:	e8 7e ff ff ff       	call   80108cb8 <uva2ka>
80108d3a:	83 c4 10             	add    $0x10,%esp
80108d3d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108d40:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108d44:	75 07                	jne    80108d4d <copyout+0x3b>
      return -1;
80108d46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108d4b:	eb 61                	jmp    80108dae <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108d4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d50:	2b 45 0c             	sub    0xc(%ebp),%eax
80108d53:	05 00 10 00 00       	add    $0x1000,%eax
80108d58:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d5e:	3b 45 14             	cmp    0x14(%ebp),%eax
80108d61:	76 06                	jbe    80108d69 <copyout+0x57>
      n = len;
80108d63:	8b 45 14             	mov    0x14(%ebp),%eax
80108d66:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108d69:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d6c:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108d6f:	89 c2                	mov    %eax,%edx
80108d71:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d74:	01 d0                	add    %edx,%eax
80108d76:	83 ec 04             	sub    $0x4,%esp
80108d79:	ff 75 f0             	pushl  -0x10(%ebp)
80108d7c:	ff 75 f4             	pushl  -0xc(%ebp)
80108d7f:	50                   	push   %eax
80108d80:	e8 9f ca ff ff       	call   80105824 <memmove>
80108d85:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d8b:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d91:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108d94:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d97:	05 00 10 00 00       	add    $0x1000,%eax
80108d9c:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108d9f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108da3:	0f 85 77 ff ff ff    	jne    80108d20 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108da9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108dae:	c9                   	leave  
80108daf:	c3                   	ret    
