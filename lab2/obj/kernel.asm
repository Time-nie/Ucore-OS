
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 80 11 00       	mov    $0x118000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 80 11 c0       	mov    %eax,0xc0118000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));

static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	ba 28 af 11 c0       	mov    $0xc011af28,%edx
c0100041:	b8 00 a0 11 c0       	mov    $0xc011a000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	83 ec 04             	sub    $0x4,%esp
c010004d:	50                   	push   %eax
c010004e:	6a 00                	push   $0x0
c0100050:	68 00 a0 11 c0       	push   $0xc011a000
c0100055:	e8 a5 52 00 00       	call   c01052ff <memset>
c010005a:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c010005d:	e8 70 15 00 00       	call   c01015d2 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100062:	c7 45 f4 a0 5a 10 c0 	movl   $0xc0105aa0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100069:	83 ec 08             	sub    $0x8,%esp
c010006c:	ff 75 f4             	pushl  -0xc(%ebp)
c010006f:	68 bc 5a 10 c0       	push   $0xc0105abc
c0100074:	e8 fa 01 00 00       	call   c0100273 <cprintf>
c0100079:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c010007c:	e8 91 08 00 00       	call   c0100912 <print_kerninfo>

    grade_backtrace();
c0100081:	e8 74 00 00 00       	call   c01000fa <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100086:	e8 86 30 00 00       	call   c0103111 <pmm_init>

    pic_init();                 // init interrupt controller
c010008b:	e8 b4 16 00 00       	call   c0101744 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100090:	e8 36 18 00 00       	call   c01018cb <idt_init>

    clock_init();               // init clock interrupt
c0100095:	e8 db 0c 00 00       	call   c0100d75 <clock_init>
    intr_enable();              // enable irq interrupt
c010009a:	e8 e2 17 00 00       	call   c0101881 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c010009f:	eb fe                	jmp    c010009f <kern_init+0x69>

c01000a1 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a1:	55                   	push   %ebp
c01000a2:	89 e5                	mov    %esp,%ebp
c01000a4:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
c01000a7:	83 ec 04             	sub    $0x4,%esp
c01000aa:	6a 00                	push   $0x0
c01000ac:	6a 00                	push   $0x0
c01000ae:	6a 00                	push   $0x0
c01000b0:	e8 ae 0c 00 00       	call   c0100d63 <mon_backtrace>
c01000b5:	83 c4 10             	add    $0x10,%esp
}
c01000b8:	90                   	nop
c01000b9:	c9                   	leave  
c01000ba:	c3                   	ret    

c01000bb <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000bb:	55                   	push   %ebp
c01000bc:	89 e5                	mov    %esp,%ebp
c01000be:	53                   	push   %ebx
c01000bf:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c2:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000c5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000c8:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01000ce:	51                   	push   %ecx
c01000cf:	52                   	push   %edx
c01000d0:	53                   	push   %ebx
c01000d1:	50                   	push   %eax
c01000d2:	e8 ca ff ff ff       	call   c01000a1 <grade_backtrace2>
c01000d7:	83 c4 10             	add    $0x10,%esp
}
c01000da:	90                   	nop
c01000db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000de:	c9                   	leave  
c01000df:	c3                   	ret    

c01000e0 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000e0:	55                   	push   %ebp
c01000e1:	89 e5                	mov    %esp,%ebp
c01000e3:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
c01000e6:	83 ec 08             	sub    $0x8,%esp
c01000e9:	ff 75 10             	pushl  0x10(%ebp)
c01000ec:	ff 75 08             	pushl  0x8(%ebp)
c01000ef:	e8 c7 ff ff ff       	call   c01000bb <grade_backtrace1>
c01000f4:	83 c4 10             	add    $0x10,%esp
}
c01000f7:	90                   	nop
c01000f8:	c9                   	leave  
c01000f9:	c3                   	ret    

c01000fa <grade_backtrace>:

void
grade_backtrace(void) {
c01000fa:	55                   	push   %ebp
c01000fb:	89 e5                	mov    %esp,%ebp
c01000fd:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100100:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c0100105:	83 ec 04             	sub    $0x4,%esp
c0100108:	68 00 00 ff ff       	push   $0xffff0000
c010010d:	50                   	push   %eax
c010010e:	6a 00                	push   $0x0
c0100110:	e8 cb ff ff ff       	call   c01000e0 <grade_backtrace0>
c0100115:	83 c4 10             	add    $0x10,%esp
}
c0100118:	90                   	nop
c0100119:	c9                   	leave  
c010011a:	c3                   	ret    

c010011b <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010011b:	55                   	push   %ebp
c010011c:	89 e5                	mov    %esp,%ebp
c010011e:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100121:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100124:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100127:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010012a:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010012d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100131:	0f b7 c0             	movzwl %ax,%eax
c0100134:	83 e0 03             	and    $0x3,%eax
c0100137:	89 c2                	mov    %eax,%edx
c0100139:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c010013e:	83 ec 04             	sub    $0x4,%esp
c0100141:	52                   	push   %edx
c0100142:	50                   	push   %eax
c0100143:	68 c1 5a 10 c0       	push   $0xc0105ac1
c0100148:	e8 26 01 00 00       	call   c0100273 <cprintf>
c010014d:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c0100150:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100154:	0f b7 d0             	movzwl %ax,%edx
c0100157:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c010015c:	83 ec 04             	sub    $0x4,%esp
c010015f:	52                   	push   %edx
c0100160:	50                   	push   %eax
c0100161:	68 cf 5a 10 c0       	push   $0xc0105acf
c0100166:	e8 08 01 00 00       	call   c0100273 <cprintf>
c010016b:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c010016e:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100172:	0f b7 d0             	movzwl %ax,%edx
c0100175:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c010017a:	83 ec 04             	sub    $0x4,%esp
c010017d:	52                   	push   %edx
c010017e:	50                   	push   %eax
c010017f:	68 dd 5a 10 c0       	push   $0xc0105add
c0100184:	e8 ea 00 00 00       	call   c0100273 <cprintf>
c0100189:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c010018c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100190:	0f b7 d0             	movzwl %ax,%edx
c0100193:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100198:	83 ec 04             	sub    $0x4,%esp
c010019b:	52                   	push   %edx
c010019c:	50                   	push   %eax
c010019d:	68 eb 5a 10 c0       	push   $0xc0105aeb
c01001a2:	e8 cc 00 00 00       	call   c0100273 <cprintf>
c01001a7:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c01001aa:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001ae:	0f b7 d0             	movzwl %ax,%edx
c01001b1:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001b6:	83 ec 04             	sub    $0x4,%esp
c01001b9:	52                   	push   %edx
c01001ba:	50                   	push   %eax
c01001bb:	68 f9 5a 10 c0       	push   $0xc0105af9
c01001c0:	e8 ae 00 00 00       	call   c0100273 <cprintf>
c01001c5:	83 c4 10             	add    $0x10,%esp
    round ++;
c01001c8:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001cd:	83 c0 01             	add    $0x1,%eax
c01001d0:	a3 00 a0 11 c0       	mov    %eax,0xc011a000
}
c01001d5:	90                   	nop
c01001d6:	c9                   	leave  
c01001d7:	c3                   	ret    

c01001d8 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001d8:	55                   	push   %ebp
c01001d9:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001db:	90                   	nop
c01001dc:	5d                   	pop    %ebp
c01001dd:	c3                   	ret    

c01001de <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001de:	55                   	push   %ebp
c01001df:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001e1:	90                   	nop
c01001e2:	5d                   	pop    %ebp
c01001e3:	c3                   	ret    

c01001e4 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001e4:	55                   	push   %ebp
c01001e5:	89 e5                	mov    %esp,%ebp
c01001e7:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
c01001ea:	e8 2c ff ff ff       	call   c010011b <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c01001ef:	83 ec 0c             	sub    $0xc,%esp
c01001f2:	68 08 5b 10 c0       	push   $0xc0105b08
c01001f7:	e8 77 00 00 00       	call   c0100273 <cprintf>
c01001fc:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c01001ff:	e8 d4 ff ff ff       	call   c01001d8 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100204:	e8 12 ff ff ff       	call   c010011b <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100209:	83 ec 0c             	sub    $0xc,%esp
c010020c:	68 28 5b 10 c0       	push   $0xc0105b28
c0100211:	e8 5d 00 00 00       	call   c0100273 <cprintf>
c0100216:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
c0100219:	e8 c0 ff ff ff       	call   c01001de <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010021e:	e8 f8 fe ff ff       	call   c010011b <lab1_print_cur_status>
}
c0100223:	90                   	nop
c0100224:	c9                   	leave  
c0100225:	c3                   	ret    

c0100226 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100226:	55                   	push   %ebp
c0100227:	89 e5                	mov    %esp,%ebp
c0100229:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c010022c:	83 ec 0c             	sub    $0xc,%esp
c010022f:	ff 75 08             	pushl  0x8(%ebp)
c0100232:	e8 cc 13 00 00       	call   c0101603 <cons_putc>
c0100237:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
c010023a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010023d:	8b 00                	mov    (%eax),%eax
c010023f:	8d 50 01             	lea    0x1(%eax),%edx
c0100242:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100245:	89 10                	mov    %edx,(%eax)
}
c0100247:	90                   	nop
c0100248:	c9                   	leave  
c0100249:	c3                   	ret    

c010024a <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010024a:	55                   	push   %ebp
c010024b:	89 e5                	mov    %esp,%ebp
c010024d:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c0100250:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100257:	ff 75 0c             	pushl  0xc(%ebp)
c010025a:	ff 75 08             	pushl  0x8(%ebp)
c010025d:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100260:	50                   	push   %eax
c0100261:	68 26 02 10 c0       	push   $0xc0100226
c0100266:	e8 ca 53 00 00       	call   c0105635 <vprintfmt>
c010026b:	83 c4 10             	add    $0x10,%esp
    return cnt;
c010026e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100271:	c9                   	leave  
c0100272:	c3                   	ret    

c0100273 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100273:	55                   	push   %ebp
c0100274:	89 e5                	mov    %esp,%ebp
c0100276:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100279:	8d 45 0c             	lea    0xc(%ebp),%eax
c010027c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c010027f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100282:	83 ec 08             	sub    $0x8,%esp
c0100285:	50                   	push   %eax
c0100286:	ff 75 08             	pushl  0x8(%ebp)
c0100289:	e8 bc ff ff ff       	call   c010024a <vcprintf>
c010028e:	83 c4 10             	add    $0x10,%esp
c0100291:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100294:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100297:	c9                   	leave  
c0100298:	c3                   	ret    

c0100299 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100299:	55                   	push   %ebp
c010029a:	89 e5                	mov    %esp,%ebp
c010029c:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c010029f:	83 ec 0c             	sub    $0xc,%esp
c01002a2:	ff 75 08             	pushl  0x8(%ebp)
c01002a5:	e8 59 13 00 00       	call   c0101603 <cons_putc>
c01002aa:	83 c4 10             	add    $0x10,%esp
}
c01002ad:	90                   	nop
c01002ae:	c9                   	leave  
c01002af:	c3                   	ret    

c01002b0 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002b0:	55                   	push   %ebp
c01002b1:	89 e5                	mov    %esp,%ebp
c01002b3:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c01002b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002bd:	eb 14                	jmp    c01002d3 <cputs+0x23>
        cputch(c, &cnt);
c01002bf:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002c3:	83 ec 08             	sub    $0x8,%esp
c01002c6:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002c9:	52                   	push   %edx
c01002ca:	50                   	push   %eax
c01002cb:	e8 56 ff ff ff       	call   c0100226 <cputch>
c01002d0:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
c01002d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01002d6:	8d 50 01             	lea    0x1(%eax),%edx
c01002d9:	89 55 08             	mov    %edx,0x8(%ebp)
c01002dc:	0f b6 00             	movzbl (%eax),%eax
c01002df:	88 45 f7             	mov    %al,-0x9(%ebp)
c01002e2:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01002e6:	75 d7                	jne    c01002bf <cputs+0xf>
    }
    cputch('\n', &cnt);
c01002e8:	83 ec 08             	sub    $0x8,%esp
c01002eb:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01002ee:	50                   	push   %eax
c01002ef:	6a 0a                	push   $0xa
c01002f1:	e8 30 ff ff ff       	call   c0100226 <cputch>
c01002f6:	83 c4 10             	add    $0x10,%esp
    return cnt;
c01002f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01002fc:	c9                   	leave  
c01002fd:	c3                   	ret    

c01002fe <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01002fe:	55                   	push   %ebp
c01002ff:	89 e5                	mov    %esp,%ebp
c0100301:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c0100304:	e8 43 13 00 00       	call   c010164c <cons_getc>
c0100309:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010030c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100310:	74 f2                	je     c0100304 <getchar+0x6>
        /* do nothing */;
    return c;
c0100312:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100315:	c9                   	leave  
c0100316:	c3                   	ret    

c0100317 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100317:	55                   	push   %ebp
c0100318:	89 e5                	mov    %esp,%ebp
c010031a:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
c010031d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100321:	74 13                	je     c0100336 <readline+0x1f>
        cprintf("%s", prompt);
c0100323:	83 ec 08             	sub    $0x8,%esp
c0100326:	ff 75 08             	pushl  0x8(%ebp)
c0100329:	68 47 5b 10 c0       	push   $0xc0105b47
c010032e:	e8 40 ff ff ff       	call   c0100273 <cprintf>
c0100333:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
c0100336:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c010033d:	e8 bc ff ff ff       	call   c01002fe <getchar>
c0100342:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100345:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100349:	79 0a                	jns    c0100355 <readline+0x3e>
            return NULL;
c010034b:	b8 00 00 00 00       	mov    $0x0,%eax
c0100350:	e9 82 00 00 00       	jmp    c01003d7 <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100355:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100359:	7e 2b                	jle    c0100386 <readline+0x6f>
c010035b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100362:	7f 22                	jg     c0100386 <readline+0x6f>
            cputchar(c);
c0100364:	83 ec 0c             	sub    $0xc,%esp
c0100367:	ff 75 f0             	pushl  -0x10(%ebp)
c010036a:	e8 2a ff ff ff       	call   c0100299 <cputchar>
c010036f:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
c0100372:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100375:	8d 50 01             	lea    0x1(%eax),%edx
c0100378:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010037b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010037e:	88 90 20 a0 11 c0    	mov    %dl,-0x3fee5fe0(%eax)
c0100384:	eb 4c                	jmp    c01003d2 <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
c0100386:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c010038a:	75 1a                	jne    c01003a6 <readline+0x8f>
c010038c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100390:	7e 14                	jle    c01003a6 <readline+0x8f>
            cputchar(c);
c0100392:	83 ec 0c             	sub    $0xc,%esp
c0100395:	ff 75 f0             	pushl  -0x10(%ebp)
c0100398:	e8 fc fe ff ff       	call   c0100299 <cputchar>
c010039d:	83 c4 10             	add    $0x10,%esp
            i --;
c01003a0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01003a4:	eb 2c                	jmp    c01003d2 <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
c01003a6:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003aa:	74 06                	je     c01003b2 <readline+0x9b>
c01003ac:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003b0:	75 8b                	jne    c010033d <readline+0x26>
            cputchar(c);
c01003b2:	83 ec 0c             	sub    $0xc,%esp
c01003b5:	ff 75 f0             	pushl  -0x10(%ebp)
c01003b8:	e8 dc fe ff ff       	call   c0100299 <cputchar>
c01003bd:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
c01003c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003c3:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c01003c8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003cb:	b8 20 a0 11 c0       	mov    $0xc011a020,%eax
c01003d0:	eb 05                	jmp    c01003d7 <readline+0xc0>
        c = getchar();
c01003d2:	e9 66 ff ff ff       	jmp    c010033d <readline+0x26>
        }
    }
}
c01003d7:	c9                   	leave  
c01003d8:	c3                   	ret    

c01003d9 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003d9:	55                   	push   %ebp
c01003da:	89 e5                	mov    %esp,%ebp
c01003dc:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
c01003df:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
c01003e4:	85 c0                	test   %eax,%eax
c01003e6:	75 5f                	jne    c0100447 <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
c01003e8:	c7 05 20 a4 11 c0 01 	movl   $0x1,0xc011a420
c01003ef:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c01003f2:	8d 45 14             	lea    0x14(%ebp),%eax
c01003f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c01003f8:	83 ec 04             	sub    $0x4,%esp
c01003fb:	ff 75 0c             	pushl  0xc(%ebp)
c01003fe:	ff 75 08             	pushl  0x8(%ebp)
c0100401:	68 4a 5b 10 c0       	push   $0xc0105b4a
c0100406:	e8 68 fe ff ff       	call   c0100273 <cprintf>
c010040b:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c010040e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100411:	83 ec 08             	sub    $0x8,%esp
c0100414:	50                   	push   %eax
c0100415:	ff 75 10             	pushl  0x10(%ebp)
c0100418:	e8 2d fe ff ff       	call   c010024a <vcprintf>
c010041d:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100420:	83 ec 0c             	sub    $0xc,%esp
c0100423:	68 66 5b 10 c0       	push   $0xc0105b66
c0100428:	e8 46 fe ff ff       	call   c0100273 <cprintf>
c010042d:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
c0100430:	83 ec 0c             	sub    $0xc,%esp
c0100433:	68 68 5b 10 c0       	push   $0xc0105b68
c0100438:	e8 36 fe ff ff       	call   c0100273 <cprintf>
c010043d:	83 c4 10             	add    $0x10,%esp
    print_stackframe();
c0100440:	e8 17 06 00 00       	call   c0100a5c <print_stackframe>
c0100445:	eb 01                	jmp    c0100448 <__panic+0x6f>
        goto panic_dead;
c0100447:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100448:	e8 3b 14 00 00       	call   c0101888 <intr_disable>
    while (1) {
        kmonitor(NULL);
c010044d:	83 ec 0c             	sub    $0xc,%esp
c0100450:	6a 00                	push   $0x0
c0100452:	e8 32 08 00 00       	call   c0100c89 <kmonitor>
c0100457:	83 c4 10             	add    $0x10,%esp
c010045a:	eb f1                	jmp    c010044d <__panic+0x74>

c010045c <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c010045c:	55                   	push   %ebp
c010045d:	89 e5                	mov    %esp,%ebp
c010045f:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
c0100462:	8d 45 14             	lea    0x14(%ebp),%eax
c0100465:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100468:	83 ec 04             	sub    $0x4,%esp
c010046b:	ff 75 0c             	pushl  0xc(%ebp)
c010046e:	ff 75 08             	pushl  0x8(%ebp)
c0100471:	68 7a 5b 10 c0       	push   $0xc0105b7a
c0100476:	e8 f8 fd ff ff       	call   c0100273 <cprintf>
c010047b:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c010047e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100481:	83 ec 08             	sub    $0x8,%esp
c0100484:	50                   	push   %eax
c0100485:	ff 75 10             	pushl  0x10(%ebp)
c0100488:	e8 bd fd ff ff       	call   c010024a <vcprintf>
c010048d:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100490:	83 ec 0c             	sub    $0xc,%esp
c0100493:	68 66 5b 10 c0       	push   $0xc0105b66
c0100498:	e8 d6 fd ff ff       	call   c0100273 <cprintf>
c010049d:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c01004a0:	90                   	nop
c01004a1:	c9                   	leave  
c01004a2:	c3                   	ret    

c01004a3 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01004a3:	55                   	push   %ebp
c01004a4:	89 e5                	mov    %esp,%ebp
    return is_panic;
c01004a6:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
}
c01004ab:	5d                   	pop    %ebp
c01004ac:	c3                   	ret    

c01004ad <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01004ad:	55                   	push   %ebp
c01004ae:	89 e5                	mov    %esp,%ebp
c01004b0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01004b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004b6:	8b 00                	mov    (%eax),%eax
c01004b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004bb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004be:	8b 00                	mov    (%eax),%eax
c01004c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004ca:	e9 d2 00 00 00       	jmp    c01005a1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01004cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004d5:	01 d0                	add    %edx,%eax
c01004d7:	89 c2                	mov    %eax,%edx
c01004d9:	c1 ea 1f             	shr    $0x1f,%edx
c01004dc:	01 d0                	add    %edx,%eax
c01004de:	d1 f8                	sar    %eax
c01004e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004e6:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004e9:	eb 04                	jmp    c01004ef <stab_binsearch+0x42>
            m --;
c01004eb:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c01004ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004f2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004f5:	7c 1f                	jl     c0100516 <stab_binsearch+0x69>
c01004f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004fa:	89 d0                	mov    %edx,%eax
c01004fc:	01 c0                	add    %eax,%eax
c01004fe:	01 d0                	add    %edx,%eax
c0100500:	c1 e0 02             	shl    $0x2,%eax
c0100503:	89 c2                	mov    %eax,%edx
c0100505:	8b 45 08             	mov    0x8(%ebp),%eax
c0100508:	01 d0                	add    %edx,%eax
c010050a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010050e:	0f b6 c0             	movzbl %al,%eax
c0100511:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100514:	75 d5                	jne    c01004eb <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c0100516:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100519:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010051c:	7d 0b                	jge    c0100529 <stab_binsearch+0x7c>
            l = true_m + 1;
c010051e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100521:	83 c0 01             	add    $0x1,%eax
c0100524:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100527:	eb 78                	jmp    c01005a1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100529:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100530:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100533:	89 d0                	mov    %edx,%eax
c0100535:	01 c0                	add    %eax,%eax
c0100537:	01 d0                	add    %edx,%eax
c0100539:	c1 e0 02             	shl    $0x2,%eax
c010053c:	89 c2                	mov    %eax,%edx
c010053e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100541:	01 d0                	add    %edx,%eax
c0100543:	8b 40 08             	mov    0x8(%eax),%eax
c0100546:	39 45 18             	cmp    %eax,0x18(%ebp)
c0100549:	76 13                	jbe    c010055e <stab_binsearch+0xb1>
            *region_left = m;
c010054b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100551:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100553:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100556:	83 c0 01             	add    $0x1,%eax
c0100559:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010055c:	eb 43                	jmp    c01005a1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010055e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100561:	89 d0                	mov    %edx,%eax
c0100563:	01 c0                	add    %eax,%eax
c0100565:	01 d0                	add    %edx,%eax
c0100567:	c1 e0 02             	shl    $0x2,%eax
c010056a:	89 c2                	mov    %eax,%edx
c010056c:	8b 45 08             	mov    0x8(%ebp),%eax
c010056f:	01 d0                	add    %edx,%eax
c0100571:	8b 40 08             	mov    0x8(%eax),%eax
c0100574:	39 45 18             	cmp    %eax,0x18(%ebp)
c0100577:	73 16                	jae    c010058f <stab_binsearch+0xe2>
            *region_right = m - 1;
c0100579:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010057c:	8d 50 ff             	lea    -0x1(%eax),%edx
c010057f:	8b 45 10             	mov    0x10(%ebp),%eax
c0100582:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c0100584:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100587:	83 e8 01             	sub    $0x1,%eax
c010058a:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010058d:	eb 12                	jmp    c01005a1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c010058f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100592:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100595:	89 10                	mov    %edx,(%eax)
            l = m;
c0100597:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010059a:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c010059d:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
c01005a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01005a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01005a7:	0f 8e 22 ff ff ff    	jle    c01004cf <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c01005ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01005b1:	75 0f                	jne    c01005c2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01005b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005b6:	8b 00                	mov    (%eax),%eax
c01005b8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005bb:	8b 45 10             	mov    0x10(%ebp),%eax
c01005be:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01005c0:	eb 3f                	jmp    c0100601 <stab_binsearch+0x154>
        l = *region_right;
c01005c2:	8b 45 10             	mov    0x10(%ebp),%eax
c01005c5:	8b 00                	mov    (%eax),%eax
c01005c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005ca:	eb 04                	jmp    c01005d0 <stab_binsearch+0x123>
c01005cc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c01005d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005d3:	8b 00                	mov    (%eax),%eax
c01005d5:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c01005d8:	7e 1f                	jle    c01005f9 <stab_binsearch+0x14c>
c01005da:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005dd:	89 d0                	mov    %edx,%eax
c01005df:	01 c0                	add    %eax,%eax
c01005e1:	01 d0                	add    %edx,%eax
c01005e3:	c1 e0 02             	shl    $0x2,%eax
c01005e6:	89 c2                	mov    %eax,%edx
c01005e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01005eb:	01 d0                	add    %edx,%eax
c01005ed:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01005f1:	0f b6 c0             	movzbl %al,%eax
c01005f4:	39 45 14             	cmp    %eax,0x14(%ebp)
c01005f7:	75 d3                	jne    c01005cc <stab_binsearch+0x11f>
        *region_left = l;
c01005f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005ff:	89 10                	mov    %edx,(%eax)
}
c0100601:	90                   	nop
c0100602:	c9                   	leave  
c0100603:	c3                   	ret    

c0100604 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100604:	55                   	push   %ebp
c0100605:	89 e5                	mov    %esp,%ebp
c0100607:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c010060a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010060d:	c7 00 98 5b 10 c0    	movl   $0xc0105b98,(%eax)
    info->eip_line = 0;
c0100613:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100616:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010061d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100620:	c7 40 08 98 5b 10 c0 	movl   $0xc0105b98,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100627:	8b 45 0c             	mov    0xc(%ebp),%eax
c010062a:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100631:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100634:	8b 55 08             	mov    0x8(%ebp),%edx
c0100637:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c010063a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010063d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100644:	c7 45 f4 e0 6d 10 c0 	movl   $0xc0106de0,-0xc(%ebp)
    stab_end = __STAB_END__;
c010064b:	c7 45 f0 ac 1f 11 c0 	movl   $0xc0111fac,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100652:	c7 45 ec ad 1f 11 c0 	movl   $0xc0111fad,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100659:	c7 45 e8 ab 4a 11 c0 	movl   $0xc0114aab,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100660:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100663:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100666:	76 0d                	jbe    c0100675 <debuginfo_eip+0x71>
c0100668:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010066b:	83 e8 01             	sub    $0x1,%eax
c010066e:	0f b6 00             	movzbl (%eax),%eax
c0100671:	84 c0                	test   %al,%al
c0100673:	74 0a                	je     c010067f <debuginfo_eip+0x7b>
        return -1;
c0100675:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010067a:	e9 91 02 00 00       	jmp    c0100910 <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c010067f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0100686:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100689:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010068c:	29 c2                	sub    %eax,%edx
c010068e:	89 d0                	mov    %edx,%eax
c0100690:	c1 f8 02             	sar    $0x2,%eax
c0100693:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c0100699:	83 e8 01             	sub    $0x1,%eax
c010069c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c010069f:	ff 75 08             	pushl  0x8(%ebp)
c01006a2:	6a 64                	push   $0x64
c01006a4:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01006a7:	50                   	push   %eax
c01006a8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01006ab:	50                   	push   %eax
c01006ac:	ff 75 f4             	pushl  -0xc(%ebp)
c01006af:	e8 f9 fd ff ff       	call   c01004ad <stab_binsearch>
c01006b4:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
c01006b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006ba:	85 c0                	test   %eax,%eax
c01006bc:	75 0a                	jne    c01006c8 <debuginfo_eip+0xc4>
        return -1;
c01006be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006c3:	e9 48 02 00 00       	jmp    c0100910 <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006d4:	ff 75 08             	pushl  0x8(%ebp)
c01006d7:	6a 24                	push   $0x24
c01006d9:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006dc:	50                   	push   %eax
c01006dd:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006e0:	50                   	push   %eax
c01006e1:	ff 75 f4             	pushl  -0xc(%ebp)
c01006e4:	e8 c4 fd ff ff       	call   c01004ad <stab_binsearch>
c01006e9:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
c01006ec:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01006ef:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006f2:	39 c2                	cmp    %eax,%edx
c01006f4:	7f 7c                	jg     c0100772 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c01006f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006f9:	89 c2                	mov    %eax,%edx
c01006fb:	89 d0                	mov    %edx,%eax
c01006fd:	01 c0                	add    %eax,%eax
c01006ff:	01 d0                	add    %edx,%eax
c0100701:	c1 e0 02             	shl    $0x2,%eax
c0100704:	89 c2                	mov    %eax,%edx
c0100706:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100709:	01 d0                	add    %edx,%eax
c010070b:	8b 00                	mov    (%eax),%eax
c010070d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100710:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0100713:	29 d1                	sub    %edx,%ecx
c0100715:	89 ca                	mov    %ecx,%edx
c0100717:	39 d0                	cmp    %edx,%eax
c0100719:	73 22                	jae    c010073d <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010071b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010071e:	89 c2                	mov    %eax,%edx
c0100720:	89 d0                	mov    %edx,%eax
c0100722:	01 c0                	add    %eax,%eax
c0100724:	01 d0                	add    %edx,%eax
c0100726:	c1 e0 02             	shl    $0x2,%eax
c0100729:	89 c2                	mov    %eax,%edx
c010072b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010072e:	01 d0                	add    %edx,%eax
c0100730:	8b 10                	mov    (%eax),%edx
c0100732:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100735:	01 c2                	add    %eax,%edx
c0100737:	8b 45 0c             	mov    0xc(%ebp),%eax
c010073a:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010073d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100740:	89 c2                	mov    %eax,%edx
c0100742:	89 d0                	mov    %edx,%eax
c0100744:	01 c0                	add    %eax,%eax
c0100746:	01 d0                	add    %edx,%eax
c0100748:	c1 e0 02             	shl    $0x2,%eax
c010074b:	89 c2                	mov    %eax,%edx
c010074d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100750:	01 d0                	add    %edx,%eax
c0100752:	8b 50 08             	mov    0x8(%eax),%edx
c0100755:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100758:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c010075b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010075e:	8b 40 10             	mov    0x10(%eax),%eax
c0100761:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100764:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100767:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c010076a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010076d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0100770:	eb 15                	jmp    c0100787 <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c0100772:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100775:	8b 55 08             	mov    0x8(%ebp),%edx
c0100778:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c010077b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010077e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c0100781:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100784:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c0100787:	8b 45 0c             	mov    0xc(%ebp),%eax
c010078a:	8b 40 08             	mov    0x8(%eax),%eax
c010078d:	83 ec 08             	sub    $0x8,%esp
c0100790:	6a 3a                	push   $0x3a
c0100792:	50                   	push   %eax
c0100793:	e8 db 49 00 00       	call   c0105173 <strfind>
c0100798:	83 c4 10             	add    $0x10,%esp
c010079b:	89 c2                	mov    %eax,%edx
c010079d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007a0:	8b 40 08             	mov    0x8(%eax),%eax
c01007a3:	29 c2                	sub    %eax,%edx
c01007a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007a8:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01007ab:	83 ec 0c             	sub    $0xc,%esp
c01007ae:	ff 75 08             	pushl  0x8(%ebp)
c01007b1:	6a 44                	push   $0x44
c01007b3:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01007b6:	50                   	push   %eax
c01007b7:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01007ba:	50                   	push   %eax
c01007bb:	ff 75 f4             	pushl  -0xc(%ebp)
c01007be:	e8 ea fc ff ff       	call   c01004ad <stab_binsearch>
c01007c3:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
c01007c6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007cc:	39 c2                	cmp    %eax,%edx
c01007ce:	7f 24                	jg     c01007f4 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
c01007d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007d3:	89 c2                	mov    %eax,%edx
c01007d5:	89 d0                	mov    %edx,%eax
c01007d7:	01 c0                	add    %eax,%eax
c01007d9:	01 d0                	add    %edx,%eax
c01007db:	c1 e0 02             	shl    $0x2,%eax
c01007de:	89 c2                	mov    %eax,%edx
c01007e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e3:	01 d0                	add    %edx,%eax
c01007e5:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c01007e9:	0f b7 d0             	movzwl %ax,%edx
c01007ec:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007ef:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c01007f2:	eb 13                	jmp    c0100807 <debuginfo_eip+0x203>
        return -1;
c01007f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01007f9:	e9 12 01 00 00       	jmp    c0100910 <debuginfo_eip+0x30c>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c01007fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100801:	83 e8 01             	sub    $0x1,%eax
c0100804:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100807:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010080a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010080d:	39 c2                	cmp    %eax,%edx
c010080f:	7c 56                	jl     c0100867 <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
c0100811:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100814:	89 c2                	mov    %eax,%edx
c0100816:	89 d0                	mov    %edx,%eax
c0100818:	01 c0                	add    %eax,%eax
c010081a:	01 d0                	add    %edx,%eax
c010081c:	c1 e0 02             	shl    $0x2,%eax
c010081f:	89 c2                	mov    %eax,%edx
c0100821:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100824:	01 d0                	add    %edx,%eax
c0100826:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010082a:	3c 84                	cmp    $0x84,%al
c010082c:	74 39                	je     c0100867 <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010082e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100831:	89 c2                	mov    %eax,%edx
c0100833:	89 d0                	mov    %edx,%eax
c0100835:	01 c0                	add    %eax,%eax
c0100837:	01 d0                	add    %edx,%eax
c0100839:	c1 e0 02             	shl    $0x2,%eax
c010083c:	89 c2                	mov    %eax,%edx
c010083e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100841:	01 d0                	add    %edx,%eax
c0100843:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100847:	3c 64                	cmp    $0x64,%al
c0100849:	75 b3                	jne    c01007fe <debuginfo_eip+0x1fa>
c010084b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084e:	89 c2                	mov    %eax,%edx
c0100850:	89 d0                	mov    %edx,%eax
c0100852:	01 c0                	add    %eax,%eax
c0100854:	01 d0                	add    %edx,%eax
c0100856:	c1 e0 02             	shl    $0x2,%eax
c0100859:	89 c2                	mov    %eax,%edx
c010085b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085e:	01 d0                	add    %edx,%eax
c0100860:	8b 40 08             	mov    0x8(%eax),%eax
c0100863:	85 c0                	test   %eax,%eax
c0100865:	74 97                	je     c01007fe <debuginfo_eip+0x1fa>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c0100867:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010086a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010086d:	39 c2                	cmp    %eax,%edx
c010086f:	7c 46                	jl     c01008b7 <debuginfo_eip+0x2b3>
c0100871:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100874:	89 c2                	mov    %eax,%edx
c0100876:	89 d0                	mov    %edx,%eax
c0100878:	01 c0                	add    %eax,%eax
c010087a:	01 d0                	add    %edx,%eax
c010087c:	c1 e0 02             	shl    $0x2,%eax
c010087f:	89 c2                	mov    %eax,%edx
c0100881:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100884:	01 d0                	add    %edx,%eax
c0100886:	8b 00                	mov    (%eax),%eax
c0100888:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010088b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010088e:	29 d1                	sub    %edx,%ecx
c0100890:	89 ca                	mov    %ecx,%edx
c0100892:	39 d0                	cmp    %edx,%eax
c0100894:	73 21                	jae    c01008b7 <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100896:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100899:	89 c2                	mov    %eax,%edx
c010089b:	89 d0                	mov    %edx,%eax
c010089d:	01 c0                	add    %eax,%eax
c010089f:	01 d0                	add    %edx,%eax
c01008a1:	c1 e0 02             	shl    $0x2,%eax
c01008a4:	89 c2                	mov    %eax,%edx
c01008a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008a9:	01 d0                	add    %edx,%eax
c01008ab:	8b 10                	mov    (%eax),%edx
c01008ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008b0:	01 c2                	add    %eax,%edx
c01008b2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008b5:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01008b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01008ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01008bd:	39 c2                	cmp    %eax,%edx
c01008bf:	7d 4a                	jge    c010090b <debuginfo_eip+0x307>
        for (lline = lfun + 1;
c01008c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008c4:	83 c0 01             	add    $0x1,%eax
c01008c7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01008ca:	eb 18                	jmp    c01008e4 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01008cc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008cf:	8b 40 14             	mov    0x14(%eax),%eax
c01008d2:	8d 50 01             	lea    0x1(%eax),%edx
c01008d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008d8:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c01008db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008de:	83 c0 01             	add    $0x1,%eax
c01008e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c01008ea:	39 c2                	cmp    %eax,%edx
c01008ec:	7d 1d                	jge    c010090b <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008f1:	89 c2                	mov    %eax,%edx
c01008f3:	89 d0                	mov    %edx,%eax
c01008f5:	01 c0                	add    %eax,%eax
c01008f7:	01 d0                	add    %edx,%eax
c01008f9:	c1 e0 02             	shl    $0x2,%eax
c01008fc:	89 c2                	mov    %eax,%edx
c01008fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100901:	01 d0                	add    %edx,%eax
c0100903:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100907:	3c a0                	cmp    $0xa0,%al
c0100909:	74 c1                	je     c01008cc <debuginfo_eip+0x2c8>
        }
    }
    return 0;
c010090b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100910:	c9                   	leave  
c0100911:	c3                   	ret    

c0100912 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100912:	55                   	push   %ebp
c0100913:	89 e5                	mov    %esp,%ebp
c0100915:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100918:	83 ec 0c             	sub    $0xc,%esp
c010091b:	68 a2 5b 10 c0       	push   $0xc0105ba2
c0100920:	e8 4e f9 ff ff       	call   c0100273 <cprintf>
c0100925:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100928:	83 ec 08             	sub    $0x8,%esp
c010092b:	68 36 00 10 c0       	push   $0xc0100036
c0100930:	68 bb 5b 10 c0       	push   $0xc0105bbb
c0100935:	e8 39 f9 ff ff       	call   c0100273 <cprintf>
c010093a:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c010093d:	83 ec 08             	sub    $0x8,%esp
c0100940:	68 96 5a 10 c0       	push   $0xc0105a96
c0100945:	68 d3 5b 10 c0       	push   $0xc0105bd3
c010094a:	e8 24 f9 ff ff       	call   c0100273 <cprintf>
c010094f:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100952:	83 ec 08             	sub    $0x8,%esp
c0100955:	68 00 a0 11 c0       	push   $0xc011a000
c010095a:	68 eb 5b 10 c0       	push   $0xc0105beb
c010095f:	e8 0f f9 ff ff       	call   c0100273 <cprintf>
c0100964:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c0100967:	83 ec 08             	sub    $0x8,%esp
c010096a:	68 28 af 11 c0       	push   $0xc011af28
c010096f:	68 03 5c 10 c0       	push   $0xc0105c03
c0100974:	e8 fa f8 ff ff       	call   c0100273 <cprintf>
c0100979:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c010097c:	b8 28 af 11 c0       	mov    $0xc011af28,%eax
c0100981:	05 ff 03 00 00       	add    $0x3ff,%eax
c0100986:	ba 36 00 10 c0       	mov    $0xc0100036,%edx
c010098b:	29 d0                	sub    %edx,%eax
c010098d:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100993:	85 c0                	test   %eax,%eax
c0100995:	0f 48 c2             	cmovs  %edx,%eax
c0100998:	c1 f8 0a             	sar    $0xa,%eax
c010099b:	83 ec 08             	sub    $0x8,%esp
c010099e:	50                   	push   %eax
c010099f:	68 1c 5c 10 c0       	push   $0xc0105c1c
c01009a4:	e8 ca f8 ff ff       	call   c0100273 <cprintf>
c01009a9:	83 c4 10             	add    $0x10,%esp
}
c01009ac:	90                   	nop
c01009ad:	c9                   	leave  
c01009ae:	c3                   	ret    

c01009af <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01009af:	55                   	push   %ebp
c01009b0:	89 e5                	mov    %esp,%ebp
c01009b2:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01009b8:	83 ec 08             	sub    $0x8,%esp
c01009bb:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009be:	50                   	push   %eax
c01009bf:	ff 75 08             	pushl  0x8(%ebp)
c01009c2:	e8 3d fc ff ff       	call   c0100604 <debuginfo_eip>
c01009c7:	83 c4 10             	add    $0x10,%esp
c01009ca:	85 c0                	test   %eax,%eax
c01009cc:	74 15                	je     c01009e3 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01009ce:	83 ec 08             	sub    $0x8,%esp
c01009d1:	ff 75 08             	pushl  0x8(%ebp)
c01009d4:	68 46 5c 10 c0       	push   $0xc0105c46
c01009d9:	e8 95 f8 ff ff       	call   c0100273 <cprintf>
c01009de:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c01009e1:	eb 65                	jmp    c0100a48 <print_debuginfo+0x99>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01009ea:	eb 1c                	jmp    c0100a08 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c01009ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01009ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f2:	01 d0                	add    %edx,%eax
c01009f4:	0f b6 00             	movzbl (%eax),%eax
c01009f7:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a00:	01 ca                	add    %ecx,%edx
c0100a02:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a04:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100a08:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a0b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100a0e:	7c dc                	jl     c01009ec <print_debuginfo+0x3d>
        fnname[j] = '\0';
c0100a10:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a19:	01 d0                	add    %edx,%eax
c0100a1b:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100a1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a21:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a24:	89 d1                	mov    %edx,%ecx
c0100a26:	29 c1                	sub    %eax,%ecx
c0100a28:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a2e:	83 ec 0c             	sub    $0xc,%esp
c0100a31:	51                   	push   %ecx
c0100a32:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a38:	51                   	push   %ecx
c0100a39:	52                   	push   %edx
c0100a3a:	50                   	push   %eax
c0100a3b:	68 62 5c 10 c0       	push   $0xc0105c62
c0100a40:	e8 2e f8 ff ff       	call   c0100273 <cprintf>
c0100a45:	83 c4 20             	add    $0x20,%esp
}
c0100a48:	90                   	nop
c0100a49:	c9                   	leave  
c0100a4a:	c3                   	ret    

c0100a4b <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a4b:	55                   	push   %ebp
c0100a4c:	89 e5                	mov    %esp,%ebp
c0100a4e:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a51:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a54:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a57:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a5a:	c9                   	leave  
c0100a5b:	c3                   	ret    

c0100a5c <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a5c:	55                   	push   %ebp
c0100a5d:	89 e5                	mov    %esp,%ebp
c0100a5f:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100a62:	89 e8                	mov    %ebp,%eax
c0100a64:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100a67:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c0100a6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100a6d:	e8 d9 ff ff ff       	call   c0100a4b <read_eip>
c0100a72:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100a75:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100a7c:	e9 8d 00 00 00       	jmp    c0100b0e <print_stackframe+0xb2>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c0100a81:	83 ec 04             	sub    $0x4,%esp
c0100a84:	ff 75 f0             	pushl  -0x10(%ebp)
c0100a87:	ff 75 f4             	pushl  -0xc(%ebp)
c0100a8a:	68 74 5c 10 c0       	push   $0xc0105c74
c0100a8f:	e8 df f7 ff ff       	call   c0100273 <cprintf>
c0100a94:	83 c4 10             	add    $0x10,%esp
        uint32_t *args = (uint32_t *)ebp + 2;
c0100a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a9a:	83 c0 08             	add    $0x8,%eax
c0100a9d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100aa0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100aa7:	eb 26                	jmp    c0100acf <print_stackframe+0x73>
            cprintf("0x%08x ", args[j]);
c0100aa9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100aac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100ab3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100ab6:	01 d0                	add    %edx,%eax
c0100ab8:	8b 00                	mov    (%eax),%eax
c0100aba:	83 ec 08             	sub    $0x8,%esp
c0100abd:	50                   	push   %eax
c0100abe:	68 90 5c 10 c0       	push   $0xc0105c90
c0100ac3:	e8 ab f7 ff ff       	call   c0100273 <cprintf>
c0100ac8:	83 c4 10             	add    $0x10,%esp
        for (j = 0; j < 4; j ++) {
c0100acb:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100acf:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100ad3:	7e d4                	jle    c0100aa9 <print_stackframe+0x4d>
        }
        cprintf("\n");
c0100ad5:	83 ec 0c             	sub    $0xc,%esp
c0100ad8:	68 98 5c 10 c0       	push   $0xc0105c98
c0100add:	e8 91 f7 ff ff       	call   c0100273 <cprintf>
c0100ae2:	83 c4 10             	add    $0x10,%esp
        print_debuginfo(eip - 1);
c0100ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100ae8:	83 e8 01             	sub    $0x1,%eax
c0100aeb:	83 ec 0c             	sub    $0xc,%esp
c0100aee:	50                   	push   %eax
c0100aef:	e8 bb fe ff ff       	call   c01009af <print_debuginfo>
c0100af4:	83 c4 10             	add    $0x10,%esp
        eip = ((uint32_t *)ebp)[1];
c0100af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100afa:	83 c0 04             	add    $0x4,%eax
c0100afd:	8b 00                	mov    (%eax),%eax
c0100aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b05:	8b 00                	mov    (%eax),%eax
c0100b07:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100b0a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100b0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b12:	74 0a                	je     c0100b1e <print_stackframe+0xc2>
c0100b14:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b18:	0f 8e 63 ff ff ff    	jle    c0100a81 <print_stackframe+0x25>
    }
}
c0100b1e:	90                   	nop
c0100b1f:	c9                   	leave  
c0100b20:	c3                   	ret    

c0100b21 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b21:	55                   	push   %ebp
c0100b22:	89 e5                	mov    %esp,%ebp
c0100b24:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
c0100b27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b2e:	eb 0c                	jmp    c0100b3c <parse+0x1b>
            *buf ++ = '\0';
c0100b30:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b33:	8d 50 01             	lea    0x1(%eax),%edx
c0100b36:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b39:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b3f:	0f b6 00             	movzbl (%eax),%eax
c0100b42:	84 c0                	test   %al,%al
c0100b44:	74 1e                	je     c0100b64 <parse+0x43>
c0100b46:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b49:	0f b6 00             	movzbl (%eax),%eax
c0100b4c:	0f be c0             	movsbl %al,%eax
c0100b4f:	83 ec 08             	sub    $0x8,%esp
c0100b52:	50                   	push   %eax
c0100b53:	68 1c 5d 10 c0       	push   $0xc0105d1c
c0100b58:	e8 e3 45 00 00       	call   c0105140 <strchr>
c0100b5d:	83 c4 10             	add    $0x10,%esp
c0100b60:	85 c0                	test   %eax,%eax
c0100b62:	75 cc                	jne    c0100b30 <parse+0xf>
        }
        if (*buf == '\0') {
c0100b64:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b67:	0f b6 00             	movzbl (%eax),%eax
c0100b6a:	84 c0                	test   %al,%al
c0100b6c:	74 65                	je     c0100bd3 <parse+0xb2>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100b6e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100b72:	75 12                	jne    c0100b86 <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100b74:	83 ec 08             	sub    $0x8,%esp
c0100b77:	6a 10                	push   $0x10
c0100b79:	68 21 5d 10 c0       	push   $0xc0105d21
c0100b7e:	e8 f0 f6 ff ff       	call   c0100273 <cprintf>
c0100b83:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
c0100b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b89:	8d 50 01             	lea    0x1(%eax),%edx
c0100b8c:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b8f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b96:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b99:	01 c2                	add    %eax,%edx
c0100b9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b9e:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100ba0:	eb 04                	jmp    c0100ba6 <parse+0x85>
            buf ++;
c0100ba2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100ba6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ba9:	0f b6 00             	movzbl (%eax),%eax
c0100bac:	84 c0                	test   %al,%al
c0100bae:	74 8c                	je     c0100b3c <parse+0x1b>
c0100bb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bb3:	0f b6 00             	movzbl (%eax),%eax
c0100bb6:	0f be c0             	movsbl %al,%eax
c0100bb9:	83 ec 08             	sub    $0x8,%esp
c0100bbc:	50                   	push   %eax
c0100bbd:	68 1c 5d 10 c0       	push   $0xc0105d1c
c0100bc2:	e8 79 45 00 00       	call   c0105140 <strchr>
c0100bc7:	83 c4 10             	add    $0x10,%esp
c0100bca:	85 c0                	test   %eax,%eax
c0100bcc:	74 d4                	je     c0100ba2 <parse+0x81>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100bce:	e9 69 ff ff ff       	jmp    c0100b3c <parse+0x1b>
            break;
c0100bd3:	90                   	nop
        }
    }
    return argc;
c0100bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100bd7:	c9                   	leave  
c0100bd8:	c3                   	ret    

c0100bd9 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100bd9:	55                   	push   %ebp
c0100bda:	89 e5                	mov    %esp,%ebp
c0100bdc:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100bdf:	83 ec 08             	sub    $0x8,%esp
c0100be2:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100be5:	50                   	push   %eax
c0100be6:	ff 75 08             	pushl  0x8(%ebp)
c0100be9:	e8 33 ff ff ff       	call   c0100b21 <parse>
c0100bee:	83 c4 10             	add    $0x10,%esp
c0100bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100bf4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100bf8:	75 0a                	jne    c0100c04 <runcmd+0x2b>
        return 0;
c0100bfa:	b8 00 00 00 00       	mov    $0x0,%eax
c0100bff:	e9 83 00 00 00       	jmp    c0100c87 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c0b:	eb 59                	jmp    c0100c66 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c0d:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c10:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c13:	89 d0                	mov    %edx,%eax
c0100c15:	01 c0                	add    %eax,%eax
c0100c17:	01 d0                	add    %edx,%eax
c0100c19:	c1 e0 02             	shl    $0x2,%eax
c0100c1c:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100c21:	8b 00                	mov    (%eax),%eax
c0100c23:	83 ec 08             	sub    $0x8,%esp
c0100c26:	51                   	push   %ecx
c0100c27:	50                   	push   %eax
c0100c28:	e8 73 44 00 00       	call   c01050a0 <strcmp>
c0100c2d:	83 c4 10             	add    $0x10,%esp
c0100c30:	85 c0                	test   %eax,%eax
c0100c32:	75 2e                	jne    c0100c62 <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c34:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c37:	89 d0                	mov    %edx,%eax
c0100c39:	01 c0                	add    %eax,%eax
c0100c3b:	01 d0                	add    %edx,%eax
c0100c3d:	c1 e0 02             	shl    $0x2,%eax
c0100c40:	05 08 70 11 c0       	add    $0xc0117008,%eax
c0100c45:	8b 10                	mov    (%eax),%edx
c0100c47:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c4a:	83 c0 04             	add    $0x4,%eax
c0100c4d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100c50:	83 e9 01             	sub    $0x1,%ecx
c0100c53:	83 ec 04             	sub    $0x4,%esp
c0100c56:	ff 75 0c             	pushl  0xc(%ebp)
c0100c59:	50                   	push   %eax
c0100c5a:	51                   	push   %ecx
c0100c5b:	ff d2                	call   *%edx
c0100c5d:	83 c4 10             	add    $0x10,%esp
c0100c60:	eb 25                	jmp    c0100c87 <runcmd+0xae>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c62:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c69:	83 f8 02             	cmp    $0x2,%eax
c0100c6c:	76 9f                	jbe    c0100c0d <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100c6e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100c71:	83 ec 08             	sub    $0x8,%esp
c0100c74:	50                   	push   %eax
c0100c75:	68 3f 5d 10 c0       	push   $0xc0105d3f
c0100c7a:	e8 f4 f5 ff ff       	call   c0100273 <cprintf>
c0100c7f:	83 c4 10             	add    $0x10,%esp
    return 0;
c0100c82:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c87:	c9                   	leave  
c0100c88:	c3                   	ret    

c0100c89 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c89:	55                   	push   %ebp
c0100c8a:	89 e5                	mov    %esp,%ebp
c0100c8c:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c8f:	83 ec 0c             	sub    $0xc,%esp
c0100c92:	68 58 5d 10 c0       	push   $0xc0105d58
c0100c97:	e8 d7 f5 ff ff       	call   c0100273 <cprintf>
c0100c9c:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100c9f:	83 ec 0c             	sub    $0xc,%esp
c0100ca2:	68 80 5d 10 c0       	push   $0xc0105d80
c0100ca7:	e8 c7 f5 ff ff       	call   c0100273 <cprintf>
c0100cac:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100caf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100cb3:	74 0e                	je     c0100cc3 <kmonitor+0x3a>
        print_trapframe(tf);
c0100cb5:	83 ec 0c             	sub    $0xc,%esp
c0100cb8:	ff 75 08             	pushl  0x8(%ebp)
c0100cbb:	e8 45 0d 00 00       	call   c0101a05 <print_trapframe>
c0100cc0:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100cc3:	83 ec 0c             	sub    $0xc,%esp
c0100cc6:	68 a5 5d 10 c0       	push   $0xc0105da5
c0100ccb:	e8 47 f6 ff ff       	call   c0100317 <readline>
c0100cd0:	83 c4 10             	add    $0x10,%esp
c0100cd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100cd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100cda:	74 e7                	je     c0100cc3 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
c0100cdc:	83 ec 08             	sub    $0x8,%esp
c0100cdf:	ff 75 08             	pushl  0x8(%ebp)
c0100ce2:	ff 75 f4             	pushl  -0xc(%ebp)
c0100ce5:	e8 ef fe ff ff       	call   c0100bd9 <runcmd>
c0100cea:	83 c4 10             	add    $0x10,%esp
c0100ced:	85 c0                	test   %eax,%eax
c0100cef:	78 02                	js     c0100cf3 <kmonitor+0x6a>
        if ((buf = readline("K> ")) != NULL) {
c0100cf1:	eb d0                	jmp    c0100cc3 <kmonitor+0x3a>
                break;
c0100cf3:	90                   	nop
            }
        }
    }
}
c0100cf4:	90                   	nop
c0100cf5:	c9                   	leave  
c0100cf6:	c3                   	ret    

c0100cf7 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100cf7:	55                   	push   %ebp
c0100cf8:	89 e5                	mov    %esp,%ebp
c0100cfa:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cfd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d04:	eb 3c                	jmp    c0100d42 <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d06:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d09:	89 d0                	mov    %edx,%eax
c0100d0b:	01 c0                	add    %eax,%eax
c0100d0d:	01 d0                	add    %edx,%eax
c0100d0f:	c1 e0 02             	shl    $0x2,%eax
c0100d12:	05 04 70 11 c0       	add    $0xc0117004,%eax
c0100d17:	8b 08                	mov    (%eax),%ecx
c0100d19:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d1c:	89 d0                	mov    %edx,%eax
c0100d1e:	01 c0                	add    %eax,%eax
c0100d20:	01 d0                	add    %edx,%eax
c0100d22:	c1 e0 02             	shl    $0x2,%eax
c0100d25:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100d2a:	8b 00                	mov    (%eax),%eax
c0100d2c:	83 ec 04             	sub    $0x4,%esp
c0100d2f:	51                   	push   %ecx
c0100d30:	50                   	push   %eax
c0100d31:	68 a9 5d 10 c0       	push   $0xc0105da9
c0100d36:	e8 38 f5 ff ff       	call   c0100273 <cprintf>
c0100d3b:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d3e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d45:	83 f8 02             	cmp    $0x2,%eax
c0100d48:	76 bc                	jbe    c0100d06 <mon_help+0xf>
    }
    return 0;
c0100d4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d4f:	c9                   	leave  
c0100d50:	c3                   	ret    

c0100d51 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d51:	55                   	push   %ebp
c0100d52:	89 e5                	mov    %esp,%ebp
c0100d54:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d57:	e8 b6 fb ff ff       	call   c0100912 <print_kerninfo>
    return 0;
c0100d5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d61:	c9                   	leave  
c0100d62:	c3                   	ret    

c0100d63 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d63:	55                   	push   %ebp
c0100d64:	89 e5                	mov    %esp,%ebp
c0100d66:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100d69:	e8 ee fc ff ff       	call   c0100a5c <print_stackframe>
    return 0;
c0100d6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d73:	c9                   	leave  
c0100d74:	c3                   	ret    

c0100d75 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d75:	55                   	push   %ebp
c0100d76:	89 e5                	mov    %esp,%ebp
c0100d78:	83 ec 18             	sub    $0x18,%esp
c0100d7b:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100d81:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d85:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100d89:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100d8d:	ee                   	out    %al,(%dx)
c0100d8e:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d94:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100d98:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100d9c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100da0:	ee                   	out    %al,(%dx)
c0100da1:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100da7:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
c0100dab:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100daf:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100db3:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100db4:	c7 05 0c af 11 c0 00 	movl   $0x0,0xc011af0c
c0100dbb:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dbe:	83 ec 0c             	sub    $0xc,%esp
c0100dc1:	68 b2 5d 10 c0       	push   $0xc0105db2
c0100dc6:	e8 a8 f4 ff ff       	call   c0100273 <cprintf>
c0100dcb:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
c0100dce:	83 ec 0c             	sub    $0xc,%esp
c0100dd1:	6a 00                	push   $0x0
c0100dd3:	e8 3f 09 00 00       	call   c0101717 <pic_enable>
c0100dd8:	83 c4 10             	add    $0x10,%esp
}
c0100ddb:	90                   	nop
c0100ddc:	c9                   	leave  
c0100ddd:	c3                   	ret    

c0100dde <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dde:	55                   	push   %ebp
c0100ddf:	89 e5                	mov    %esp,%ebp
c0100de1:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100de4:	9c                   	pushf  
c0100de5:	58                   	pop    %eax
c0100de6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100dec:	25 00 02 00 00       	and    $0x200,%eax
c0100df1:	85 c0                	test   %eax,%eax
c0100df3:	74 0c                	je     c0100e01 <__intr_save+0x23>
        intr_disable();
c0100df5:	e8 8e 0a 00 00       	call   c0101888 <intr_disable>
        return 1;
c0100dfa:	b8 01 00 00 00       	mov    $0x1,%eax
c0100dff:	eb 05                	jmp    c0100e06 <__intr_save+0x28>
    }
    return 0;
c0100e01:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e06:	c9                   	leave  
c0100e07:	c3                   	ret    

c0100e08 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e08:	55                   	push   %ebp
c0100e09:	89 e5                	mov    %esp,%ebp
c0100e0b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e12:	74 05                	je     c0100e19 <__intr_restore+0x11>
        intr_enable();
c0100e14:	e8 68 0a 00 00       	call   c0101881 <intr_enable>
    }
}
c0100e19:	90                   	nop
c0100e1a:	c9                   	leave  
c0100e1b:	c3                   	ret    

c0100e1c <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e1c:	55                   	push   %ebp
c0100e1d:	89 e5                	mov    %esp,%ebp
c0100e1f:	83 ec 10             	sub    $0x10,%esp
c0100e22:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e28:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e2c:	89 c2                	mov    %eax,%edx
c0100e2e:	ec                   	in     (%dx),%al
c0100e2f:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100e32:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e38:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e3c:	89 c2                	mov    %eax,%edx
c0100e3e:	ec                   	in     (%dx),%al
c0100e3f:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e42:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e48:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e4c:	89 c2                	mov    %eax,%edx
c0100e4e:	ec                   	in     (%dx),%al
c0100e4f:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e52:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100e58:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e5c:	89 c2                	mov    %eax,%edx
c0100e5e:	ec                   	in     (%dx),%al
c0100e5f:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e62:	90                   	nop
c0100e63:	c9                   	leave  
c0100e64:	c3                   	ret    

c0100e65 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e65:	55                   	push   %ebp
c0100e66:	89 e5                	mov    %esp,%ebp
c0100e68:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e6b:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e75:	0f b7 00             	movzwl (%eax),%eax
c0100e78:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e7f:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e87:	0f b7 00             	movzwl (%eax),%eax
c0100e8a:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e8e:	74 12                	je     c0100ea2 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e90:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e97:	66 c7 05 46 a4 11 c0 	movw   $0x3b4,0xc011a446
c0100e9e:	b4 03 
c0100ea0:	eb 13                	jmp    c0100eb5 <cga_init+0x50>
    } else {
        *cp = was;
c0100ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ea9:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eac:	66 c7 05 46 a4 11 c0 	movw   $0x3d4,0xc011a446
c0100eb3:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100eb5:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100ebc:	0f b7 c0             	movzwl %ax,%eax
c0100ebf:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100ec3:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ec7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100ecb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100ecf:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ed0:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100ed7:	83 c0 01             	add    $0x1,%eax
c0100eda:	0f b7 c0             	movzwl %ax,%eax
c0100edd:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ee1:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ee5:	89 c2                	mov    %eax,%edx
c0100ee7:	ec                   	in     (%dx),%al
c0100ee8:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100eeb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100eef:	0f b6 c0             	movzbl %al,%eax
c0100ef2:	c1 e0 08             	shl    $0x8,%eax
c0100ef5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100ef8:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100eff:	0f b7 c0             	movzwl %ax,%eax
c0100f02:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f06:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f0a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f0e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f12:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f13:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f1a:	83 c0 01             	add    $0x1,%eax
c0100f1d:	0f b7 c0             	movzwl %ax,%eax
c0100f20:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f24:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f28:	89 c2                	mov    %eax,%edx
c0100f2a:	ec                   	in     (%dx),%al
c0100f2b:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100f2e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f32:	0f b6 c0             	movzbl %al,%eax
c0100f35:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f38:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f3b:	a3 40 a4 11 c0       	mov    %eax,0xc011a440
    crt_pos = pos;
c0100f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f43:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
}
c0100f49:	90                   	nop
c0100f4a:	c9                   	leave  
c0100f4b:	c3                   	ret    

c0100f4c <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f4c:	55                   	push   %ebp
c0100f4d:	89 e5                	mov    %esp,%ebp
c0100f4f:	83 ec 38             	sub    $0x38,%esp
c0100f52:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100f58:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f5c:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100f60:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100f64:	ee                   	out    %al,(%dx)
c0100f65:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100f6b:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
c0100f6f:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100f73:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0100f77:	ee                   	out    %al,(%dx)
c0100f78:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0100f7e:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
c0100f82:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0100f86:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100f8a:	ee                   	out    %al,(%dx)
c0100f8b:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100f91:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c0100f95:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100f99:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100f9d:	ee                   	out    %al,(%dx)
c0100f9e:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0100fa4:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
c0100fa8:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fac:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fb0:	ee                   	out    %al,(%dx)
c0100fb1:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0100fb7:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
c0100fbb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fbf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fc3:	ee                   	out    %al,(%dx)
c0100fc4:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fca:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
c0100fce:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fd2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fd6:	ee                   	out    %al,(%dx)
c0100fd7:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fdd:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100fe1:	89 c2                	mov    %eax,%edx
c0100fe3:	ec                   	in     (%dx),%al
c0100fe4:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100fe7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100feb:	3c ff                	cmp    $0xff,%al
c0100fed:	0f 95 c0             	setne  %al
c0100ff0:	0f b6 c0             	movzbl %al,%eax
c0100ff3:	a3 48 a4 11 c0       	mov    %eax,0xc011a448
c0100ff8:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ffe:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101002:	89 c2                	mov    %eax,%edx
c0101004:	ec                   	in     (%dx),%al
c0101005:	88 45 f1             	mov    %al,-0xf(%ebp)
c0101008:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010100e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101012:	89 c2                	mov    %eax,%edx
c0101014:	ec                   	in     (%dx),%al
c0101015:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101018:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c010101d:	85 c0                	test   %eax,%eax
c010101f:	74 0d                	je     c010102e <serial_init+0xe2>
        pic_enable(IRQ_COM1);
c0101021:	83 ec 0c             	sub    $0xc,%esp
c0101024:	6a 04                	push   $0x4
c0101026:	e8 ec 06 00 00       	call   c0101717 <pic_enable>
c010102b:	83 c4 10             	add    $0x10,%esp
    }
}
c010102e:	90                   	nop
c010102f:	c9                   	leave  
c0101030:	c3                   	ret    

c0101031 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101031:	55                   	push   %ebp
c0101032:	89 e5                	mov    %esp,%ebp
c0101034:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101037:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010103e:	eb 09                	jmp    c0101049 <lpt_putc_sub+0x18>
        delay();
c0101040:	e8 d7 fd ff ff       	call   c0100e1c <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101045:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101049:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c010104f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101053:	89 c2                	mov    %eax,%edx
c0101055:	ec                   	in     (%dx),%al
c0101056:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101059:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010105d:	84 c0                	test   %al,%al
c010105f:	78 09                	js     c010106a <lpt_putc_sub+0x39>
c0101061:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101068:	7e d6                	jle    c0101040 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c010106a:	8b 45 08             	mov    0x8(%ebp),%eax
c010106d:	0f b6 c0             	movzbl %al,%eax
c0101070:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c0101076:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101079:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010107d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101081:	ee                   	out    %al,(%dx)
c0101082:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101088:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010108c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101090:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101094:	ee                   	out    %al,(%dx)
c0101095:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c010109b:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
c010109f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010a3:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010a7:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010a8:	90                   	nop
c01010a9:	c9                   	leave  
c01010aa:	c3                   	ret    

c01010ab <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010ab:	55                   	push   %ebp
c01010ac:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c01010ae:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010b2:	74 0d                	je     c01010c1 <lpt_putc+0x16>
        lpt_putc_sub(c);
c01010b4:	ff 75 08             	pushl  0x8(%ebp)
c01010b7:	e8 75 ff ff ff       	call   c0101031 <lpt_putc_sub>
c01010bc:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c01010bf:	eb 1e                	jmp    c01010df <lpt_putc+0x34>
        lpt_putc_sub('\b');
c01010c1:	6a 08                	push   $0x8
c01010c3:	e8 69 ff ff ff       	call   c0101031 <lpt_putc_sub>
c01010c8:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
c01010cb:	6a 20                	push   $0x20
c01010cd:	e8 5f ff ff ff       	call   c0101031 <lpt_putc_sub>
c01010d2:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
c01010d5:	6a 08                	push   $0x8
c01010d7:	e8 55 ff ff ff       	call   c0101031 <lpt_putc_sub>
c01010dc:	83 c4 04             	add    $0x4,%esp
}
c01010df:	90                   	nop
c01010e0:	c9                   	leave  
c01010e1:	c3                   	ret    

c01010e2 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010e2:	55                   	push   %ebp
c01010e3:	89 e5                	mov    %esp,%ebp
c01010e5:	53                   	push   %ebx
c01010e6:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01010ec:	b0 00                	mov    $0x0,%al
c01010ee:	85 c0                	test   %eax,%eax
c01010f0:	75 07                	jne    c01010f9 <cga_putc+0x17>
        c |= 0x0700;
c01010f2:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01010f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01010fc:	0f b6 c0             	movzbl %al,%eax
c01010ff:	83 f8 0a             	cmp    $0xa,%eax
c0101102:	74 52                	je     c0101156 <cga_putc+0x74>
c0101104:	83 f8 0d             	cmp    $0xd,%eax
c0101107:	74 5d                	je     c0101166 <cga_putc+0x84>
c0101109:	83 f8 08             	cmp    $0x8,%eax
c010110c:	0f 85 8e 00 00 00    	jne    c01011a0 <cga_putc+0xbe>
    case '\b':
        if (crt_pos > 0) {
c0101112:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101119:	66 85 c0             	test   %ax,%ax
c010111c:	0f 84 a4 00 00 00    	je     c01011c6 <cga_putc+0xe4>
            crt_pos --;
c0101122:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101129:	83 e8 01             	sub    $0x1,%eax
c010112c:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101132:	8b 45 08             	mov    0x8(%ebp),%eax
c0101135:	b0 00                	mov    $0x0,%al
c0101137:	83 c8 20             	or     $0x20,%eax
c010113a:	89 c1                	mov    %eax,%ecx
c010113c:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101141:	0f b7 15 44 a4 11 c0 	movzwl 0xc011a444,%edx
c0101148:	0f b7 d2             	movzwl %dx,%edx
c010114b:	01 d2                	add    %edx,%edx
c010114d:	01 d0                	add    %edx,%eax
c010114f:	89 ca                	mov    %ecx,%edx
c0101151:	66 89 10             	mov    %dx,(%eax)
        }
        break;
c0101154:	eb 70                	jmp    c01011c6 <cga_putc+0xe4>
    case '\n':
        crt_pos += CRT_COLS;
c0101156:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010115d:	83 c0 50             	add    $0x50,%eax
c0101160:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101166:	0f b7 1d 44 a4 11 c0 	movzwl 0xc011a444,%ebx
c010116d:	0f b7 0d 44 a4 11 c0 	movzwl 0xc011a444,%ecx
c0101174:	0f b7 c1             	movzwl %cx,%eax
c0101177:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010117d:	c1 e8 10             	shr    $0x10,%eax
c0101180:	89 c2                	mov    %eax,%edx
c0101182:	66 c1 ea 06          	shr    $0x6,%dx
c0101186:	89 d0                	mov    %edx,%eax
c0101188:	c1 e0 02             	shl    $0x2,%eax
c010118b:	01 d0                	add    %edx,%eax
c010118d:	c1 e0 04             	shl    $0x4,%eax
c0101190:	29 c1                	sub    %eax,%ecx
c0101192:	89 ca                	mov    %ecx,%edx
c0101194:	89 d8                	mov    %ebx,%eax
c0101196:	29 d0                	sub    %edx,%eax
c0101198:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
        break;
c010119e:	eb 27                	jmp    c01011c7 <cga_putc+0xe5>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011a0:	8b 0d 40 a4 11 c0    	mov    0xc011a440,%ecx
c01011a6:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01011ad:	8d 50 01             	lea    0x1(%eax),%edx
c01011b0:	66 89 15 44 a4 11 c0 	mov    %dx,0xc011a444
c01011b7:	0f b7 c0             	movzwl %ax,%eax
c01011ba:	01 c0                	add    %eax,%eax
c01011bc:	01 c8                	add    %ecx,%eax
c01011be:	8b 55 08             	mov    0x8(%ebp),%edx
c01011c1:	66 89 10             	mov    %dx,(%eax)
        break;
c01011c4:	eb 01                	jmp    c01011c7 <cga_putc+0xe5>
        break;
c01011c6:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011c7:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01011ce:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011d2:	76 59                	jbe    c010122d <cga_putc+0x14b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011d4:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c01011d9:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011df:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c01011e4:	83 ec 04             	sub    $0x4,%esp
c01011e7:	68 00 0f 00 00       	push   $0xf00
c01011ec:	52                   	push   %edx
c01011ed:	50                   	push   %eax
c01011ee:	e8 4c 41 00 00       	call   c010533f <memmove>
c01011f3:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011f6:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01011fd:	eb 15                	jmp    c0101214 <cga_putc+0x132>
            crt_buf[i] = 0x0700 | ' ';
c01011ff:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101204:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101207:	01 d2                	add    %edx,%edx
c0101209:	01 d0                	add    %edx,%eax
c010120b:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101210:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101214:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010121b:	7e e2                	jle    c01011ff <cga_putc+0x11d>
        }
        crt_pos -= CRT_COLS;
c010121d:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101224:	83 e8 50             	sub    $0x50,%eax
c0101227:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010122d:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0101234:	0f b7 c0             	movzwl %ax,%eax
c0101237:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c010123b:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
c010123f:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101243:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101247:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101248:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010124f:	66 c1 e8 08          	shr    $0x8,%ax
c0101253:	0f b6 c0             	movzbl %al,%eax
c0101256:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c010125d:	83 c2 01             	add    $0x1,%edx
c0101260:	0f b7 d2             	movzwl %dx,%edx
c0101263:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101267:	88 45 e9             	mov    %al,-0x17(%ebp)
c010126a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010126e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101272:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101273:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c010127a:	0f b7 c0             	movzwl %ax,%eax
c010127d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101281:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
c0101285:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101289:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010128d:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c010128e:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101295:	0f b6 c0             	movzbl %al,%eax
c0101298:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c010129f:	83 c2 01             	add    $0x1,%edx
c01012a2:	0f b7 d2             	movzwl %dx,%edx
c01012a5:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c01012a9:	88 45 f1             	mov    %al,-0xf(%ebp)
c01012ac:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01012b0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012b4:	ee                   	out    %al,(%dx)
}
c01012b5:	90                   	nop
c01012b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01012b9:	c9                   	leave  
c01012ba:	c3                   	ret    

c01012bb <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012bb:	55                   	push   %ebp
c01012bc:	89 e5                	mov    %esp,%ebp
c01012be:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012c8:	eb 09                	jmp    c01012d3 <serial_putc_sub+0x18>
        delay();
c01012ca:	e8 4d fb ff ff       	call   c0100e1c <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012cf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012d3:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012d9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012dd:	89 c2                	mov    %eax,%edx
c01012df:	ec                   	in     (%dx),%al
c01012e0:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012e3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012e7:	0f b6 c0             	movzbl %al,%eax
c01012ea:	83 e0 20             	and    $0x20,%eax
c01012ed:	85 c0                	test   %eax,%eax
c01012ef:	75 09                	jne    c01012fa <serial_putc_sub+0x3f>
c01012f1:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012f8:	7e d0                	jle    c01012ca <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c01012fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01012fd:	0f b6 c0             	movzbl %al,%eax
c0101300:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101306:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101309:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010130d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101311:	ee                   	out    %al,(%dx)
}
c0101312:	90                   	nop
c0101313:	c9                   	leave  
c0101314:	c3                   	ret    

c0101315 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101315:	55                   	push   %ebp
c0101316:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c0101318:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010131c:	74 0d                	je     c010132b <serial_putc+0x16>
        serial_putc_sub(c);
c010131e:	ff 75 08             	pushl  0x8(%ebp)
c0101321:	e8 95 ff ff ff       	call   c01012bb <serial_putc_sub>
c0101326:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c0101329:	eb 1e                	jmp    c0101349 <serial_putc+0x34>
        serial_putc_sub('\b');
c010132b:	6a 08                	push   $0x8
c010132d:	e8 89 ff ff ff       	call   c01012bb <serial_putc_sub>
c0101332:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
c0101335:	6a 20                	push   $0x20
c0101337:	e8 7f ff ff ff       	call   c01012bb <serial_putc_sub>
c010133c:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
c010133f:	6a 08                	push   $0x8
c0101341:	e8 75 ff ff ff       	call   c01012bb <serial_putc_sub>
c0101346:	83 c4 04             	add    $0x4,%esp
}
c0101349:	90                   	nop
c010134a:	c9                   	leave  
c010134b:	c3                   	ret    

c010134c <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010134c:	55                   	push   %ebp
c010134d:	89 e5                	mov    %esp,%ebp
c010134f:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101352:	eb 33                	jmp    c0101387 <cons_intr+0x3b>
        if (c != 0) {
c0101354:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101358:	74 2d                	je     c0101387 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010135a:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c010135f:	8d 50 01             	lea    0x1(%eax),%edx
c0101362:	89 15 64 a6 11 c0    	mov    %edx,0xc011a664
c0101368:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010136b:	88 90 60 a4 11 c0    	mov    %dl,-0x3fee5ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101371:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c0101376:	3d 00 02 00 00       	cmp    $0x200,%eax
c010137b:	75 0a                	jne    c0101387 <cons_intr+0x3b>
                cons.wpos = 0;
c010137d:	c7 05 64 a6 11 c0 00 	movl   $0x0,0xc011a664
c0101384:	00 00 00 
    while ((c = (*proc)()) != -1) {
c0101387:	8b 45 08             	mov    0x8(%ebp),%eax
c010138a:	ff d0                	call   *%eax
c010138c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010138f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101393:	75 bf                	jne    c0101354 <cons_intr+0x8>
            }
        }
    }
}
c0101395:	90                   	nop
c0101396:	c9                   	leave  
c0101397:	c3                   	ret    

c0101398 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101398:	55                   	push   %ebp
c0101399:	89 e5                	mov    %esp,%ebp
c010139b:	83 ec 10             	sub    $0x10,%esp
c010139e:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013a4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013a8:	89 c2                	mov    %eax,%edx
c01013aa:	ec                   	in     (%dx),%al
c01013ab:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013ae:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013b2:	0f b6 c0             	movzbl %al,%eax
c01013b5:	83 e0 01             	and    $0x1,%eax
c01013b8:	85 c0                	test   %eax,%eax
c01013ba:	75 07                	jne    c01013c3 <serial_proc_data+0x2b>
        return -1;
c01013bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013c1:	eb 2a                	jmp    c01013ed <serial_proc_data+0x55>
c01013c3:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013c9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013cd:	89 c2                	mov    %eax,%edx
c01013cf:	ec                   	in     (%dx),%al
c01013d0:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013d3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013d7:	0f b6 c0             	movzbl %al,%eax
c01013da:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013dd:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013e1:	75 07                	jne    c01013ea <serial_proc_data+0x52>
        c = '\b';
c01013e3:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013ed:	c9                   	leave  
c01013ee:	c3                   	ret    

c01013ef <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013ef:	55                   	push   %ebp
c01013f0:	89 e5                	mov    %esp,%ebp
c01013f2:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
c01013f5:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c01013fa:	85 c0                	test   %eax,%eax
c01013fc:	74 10                	je     c010140e <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c01013fe:	83 ec 0c             	sub    $0xc,%esp
c0101401:	68 98 13 10 c0       	push   $0xc0101398
c0101406:	e8 41 ff ff ff       	call   c010134c <cons_intr>
c010140b:	83 c4 10             	add    $0x10,%esp
    }
}
c010140e:	90                   	nop
c010140f:	c9                   	leave  
c0101410:	c3                   	ret    

c0101411 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101411:	55                   	push   %ebp
c0101412:	89 e5                	mov    %esp,%ebp
c0101414:	83 ec 28             	sub    $0x28,%esp
c0101417:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010141d:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101421:	89 c2                	mov    %eax,%edx
c0101423:	ec                   	in     (%dx),%al
c0101424:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101427:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010142b:	0f b6 c0             	movzbl %al,%eax
c010142e:	83 e0 01             	and    $0x1,%eax
c0101431:	85 c0                	test   %eax,%eax
c0101433:	75 0a                	jne    c010143f <kbd_proc_data+0x2e>
        return -1;
c0101435:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010143a:	e9 5d 01 00 00       	jmp    c010159c <kbd_proc_data+0x18b>
c010143f:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101445:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101449:	89 c2                	mov    %eax,%edx
c010144b:	ec                   	in     (%dx),%al
c010144c:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010144f:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101453:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101456:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010145a:	75 17                	jne    c0101473 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010145c:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101461:	83 c8 40             	or     $0x40,%eax
c0101464:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c0101469:	b8 00 00 00 00       	mov    $0x0,%eax
c010146e:	e9 29 01 00 00       	jmp    c010159c <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
c0101473:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101477:	84 c0                	test   %al,%al
c0101479:	79 47                	jns    c01014c2 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010147b:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101480:	83 e0 40             	and    $0x40,%eax
c0101483:	85 c0                	test   %eax,%eax
c0101485:	75 09                	jne    c0101490 <kbd_proc_data+0x7f>
c0101487:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010148b:	83 e0 7f             	and    $0x7f,%eax
c010148e:	eb 04                	jmp    c0101494 <kbd_proc_data+0x83>
c0101490:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101494:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101497:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010149b:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c01014a2:	83 c8 40             	or     $0x40,%eax
c01014a5:	0f b6 c0             	movzbl %al,%eax
c01014a8:	f7 d0                	not    %eax
c01014aa:	89 c2                	mov    %eax,%edx
c01014ac:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014b1:	21 d0                	and    %edx,%eax
c01014b3:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c01014b8:	b8 00 00 00 00       	mov    $0x0,%eax
c01014bd:	e9 da 00 00 00       	jmp    c010159c <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
c01014c2:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014c7:	83 e0 40             	and    $0x40,%eax
c01014ca:	85 c0                	test   %eax,%eax
c01014cc:	74 11                	je     c01014df <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014ce:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014d2:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014d7:	83 e0 bf             	and    $0xffffffbf,%eax
c01014da:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    }

    shift |= shiftcode[data];
c01014df:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014e3:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c01014ea:	0f b6 d0             	movzbl %al,%edx
c01014ed:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014f2:	09 d0                	or     %edx,%eax
c01014f4:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    shift ^= togglecode[data];
c01014f9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014fd:	0f b6 80 40 71 11 c0 	movzbl -0x3fee8ec0(%eax),%eax
c0101504:	0f b6 d0             	movzbl %al,%edx
c0101507:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010150c:	31 d0                	xor    %edx,%eax
c010150e:	a3 68 a6 11 c0       	mov    %eax,0xc011a668

    c = charcode[shift & (CTL | SHIFT)][data];
c0101513:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101518:	83 e0 03             	and    $0x3,%eax
c010151b:	8b 14 85 40 75 11 c0 	mov    -0x3fee8ac0(,%eax,4),%edx
c0101522:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101526:	01 d0                	add    %edx,%eax
c0101528:	0f b6 00             	movzbl (%eax),%eax
c010152b:	0f b6 c0             	movzbl %al,%eax
c010152e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101531:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101536:	83 e0 08             	and    $0x8,%eax
c0101539:	85 c0                	test   %eax,%eax
c010153b:	74 22                	je     c010155f <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010153d:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101541:	7e 0c                	jle    c010154f <kbd_proc_data+0x13e>
c0101543:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101547:	7f 06                	jg     c010154f <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101549:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010154d:	eb 10                	jmp    c010155f <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010154f:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101553:	7e 0a                	jle    c010155f <kbd_proc_data+0x14e>
c0101555:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101559:	7f 04                	jg     c010155f <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010155b:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010155f:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101564:	f7 d0                	not    %eax
c0101566:	83 e0 06             	and    $0x6,%eax
c0101569:	85 c0                	test   %eax,%eax
c010156b:	75 2c                	jne    c0101599 <kbd_proc_data+0x188>
c010156d:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101574:	75 23                	jne    c0101599 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
c0101576:	83 ec 0c             	sub    $0xc,%esp
c0101579:	68 cd 5d 10 c0       	push   $0xc0105dcd
c010157e:	e8 f0 ec ff ff       	call   c0100273 <cprintf>
c0101583:	83 c4 10             	add    $0x10,%esp
c0101586:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010158c:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101590:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101594:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101598:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101599:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010159c:	c9                   	leave  
c010159d:	c3                   	ret    

c010159e <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010159e:	55                   	push   %ebp
c010159f:	89 e5                	mov    %esp,%ebp
c01015a1:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
c01015a4:	83 ec 0c             	sub    $0xc,%esp
c01015a7:	68 11 14 10 c0       	push   $0xc0101411
c01015ac:	e8 9b fd ff ff       	call   c010134c <cons_intr>
c01015b1:	83 c4 10             	add    $0x10,%esp
}
c01015b4:	90                   	nop
c01015b5:	c9                   	leave  
c01015b6:	c3                   	ret    

c01015b7 <kbd_init>:

static void
kbd_init(void) {
c01015b7:	55                   	push   %ebp
c01015b8:	89 e5                	mov    %esp,%ebp
c01015ba:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
c01015bd:	e8 dc ff ff ff       	call   c010159e <kbd_intr>
    pic_enable(IRQ_KBD);
c01015c2:	83 ec 0c             	sub    $0xc,%esp
c01015c5:	6a 01                	push   $0x1
c01015c7:	e8 4b 01 00 00       	call   c0101717 <pic_enable>
c01015cc:	83 c4 10             	add    $0x10,%esp
}
c01015cf:	90                   	nop
c01015d0:	c9                   	leave  
c01015d1:	c3                   	ret    

c01015d2 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015d2:	55                   	push   %ebp
c01015d3:	89 e5                	mov    %esp,%ebp
c01015d5:	83 ec 08             	sub    $0x8,%esp
    cga_init();
c01015d8:	e8 88 f8 ff ff       	call   c0100e65 <cga_init>
    serial_init();
c01015dd:	e8 6a f9 ff ff       	call   c0100f4c <serial_init>
    kbd_init();
c01015e2:	e8 d0 ff ff ff       	call   c01015b7 <kbd_init>
    if (!serial_exists) {
c01015e7:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c01015ec:	85 c0                	test   %eax,%eax
c01015ee:	75 10                	jne    c0101600 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c01015f0:	83 ec 0c             	sub    $0xc,%esp
c01015f3:	68 d9 5d 10 c0       	push   $0xc0105dd9
c01015f8:	e8 76 ec ff ff       	call   c0100273 <cprintf>
c01015fd:	83 c4 10             	add    $0x10,%esp
    }
}
c0101600:	90                   	nop
c0101601:	c9                   	leave  
c0101602:	c3                   	ret    

c0101603 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101603:	55                   	push   %ebp
c0101604:	89 e5                	mov    %esp,%ebp
c0101606:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101609:	e8 d0 f7 ff ff       	call   c0100dde <__intr_save>
c010160e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101611:	83 ec 0c             	sub    $0xc,%esp
c0101614:	ff 75 08             	pushl  0x8(%ebp)
c0101617:	e8 8f fa ff ff       	call   c01010ab <lpt_putc>
c010161c:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
c010161f:	83 ec 0c             	sub    $0xc,%esp
c0101622:	ff 75 08             	pushl  0x8(%ebp)
c0101625:	e8 b8 fa ff ff       	call   c01010e2 <cga_putc>
c010162a:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
c010162d:	83 ec 0c             	sub    $0xc,%esp
c0101630:	ff 75 08             	pushl  0x8(%ebp)
c0101633:	e8 dd fc ff ff       	call   c0101315 <serial_putc>
c0101638:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c010163b:	83 ec 0c             	sub    $0xc,%esp
c010163e:	ff 75 f4             	pushl  -0xc(%ebp)
c0101641:	e8 c2 f7 ff ff       	call   c0100e08 <__intr_restore>
c0101646:	83 c4 10             	add    $0x10,%esp
}
c0101649:	90                   	nop
c010164a:	c9                   	leave  
c010164b:	c3                   	ret    

c010164c <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010164c:	55                   	push   %ebp
c010164d:	89 e5                	mov    %esp,%ebp
c010164f:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
c0101652:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101659:	e8 80 f7 ff ff       	call   c0100dde <__intr_save>
c010165e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101661:	e8 89 fd ff ff       	call   c01013ef <serial_intr>
        kbd_intr();
c0101666:	e8 33 ff ff ff       	call   c010159e <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010166b:	8b 15 60 a6 11 c0    	mov    0xc011a660,%edx
c0101671:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c0101676:	39 c2                	cmp    %eax,%edx
c0101678:	74 31                	je     c01016ab <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c010167a:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c010167f:	8d 50 01             	lea    0x1(%eax),%edx
c0101682:	89 15 60 a6 11 c0    	mov    %edx,0xc011a660
c0101688:	0f b6 80 60 a4 11 c0 	movzbl -0x3fee5ba0(%eax),%eax
c010168f:	0f b6 c0             	movzbl %al,%eax
c0101692:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101695:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c010169a:	3d 00 02 00 00       	cmp    $0x200,%eax
c010169f:	75 0a                	jne    c01016ab <cons_getc+0x5f>
                cons.rpos = 0;
c01016a1:	c7 05 60 a6 11 c0 00 	movl   $0x0,0xc011a660
c01016a8:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016ab:	83 ec 0c             	sub    $0xc,%esp
c01016ae:	ff 75 f0             	pushl  -0x10(%ebp)
c01016b1:	e8 52 f7 ff ff       	call   c0100e08 <__intr_restore>
c01016b6:	83 c4 10             	add    $0x10,%esp
    return c;
c01016b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016bc:	c9                   	leave  
c01016bd:	c3                   	ret    

c01016be <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016be:	55                   	push   %ebp
c01016bf:	89 e5                	mov    %esp,%ebp
c01016c1:	83 ec 14             	sub    $0x14,%esp
c01016c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01016c7:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016cb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016cf:	66 a3 50 75 11 c0    	mov    %ax,0xc0117550
    if (did_init) {
c01016d5:	a1 6c a6 11 c0       	mov    0xc011a66c,%eax
c01016da:	85 c0                	test   %eax,%eax
c01016dc:	74 36                	je     c0101714 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016de:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016e2:	0f b6 c0             	movzbl %al,%eax
c01016e5:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c01016eb:	88 45 f9             	mov    %al,-0x7(%ebp)
c01016ee:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016f2:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01016f6:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016f7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016fb:	66 c1 e8 08          	shr    $0x8,%ax
c01016ff:	0f b6 c0             	movzbl %al,%eax
c0101702:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c0101708:	88 45 fd             	mov    %al,-0x3(%ebp)
c010170b:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010170f:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101713:	ee                   	out    %al,(%dx)
    }
}
c0101714:	90                   	nop
c0101715:	c9                   	leave  
c0101716:	c3                   	ret    

c0101717 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101717:	55                   	push   %ebp
c0101718:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
c010171a:	8b 45 08             	mov    0x8(%ebp),%eax
c010171d:	ba 01 00 00 00       	mov    $0x1,%edx
c0101722:	89 c1                	mov    %eax,%ecx
c0101724:	d3 e2                	shl    %cl,%edx
c0101726:	89 d0                	mov    %edx,%eax
c0101728:	f7 d0                	not    %eax
c010172a:	89 c2                	mov    %eax,%edx
c010172c:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101733:	21 d0                	and    %edx,%eax
c0101735:	0f b7 c0             	movzwl %ax,%eax
c0101738:	50                   	push   %eax
c0101739:	e8 80 ff ff ff       	call   c01016be <pic_setmask>
c010173e:	83 c4 04             	add    $0x4,%esp
}
c0101741:	90                   	nop
c0101742:	c9                   	leave  
c0101743:	c3                   	ret    

c0101744 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101744:	55                   	push   %ebp
c0101745:	89 e5                	mov    %esp,%ebp
c0101747:	83 ec 40             	sub    $0x40,%esp
    did_init = 1;
c010174a:	c7 05 6c a6 11 c0 01 	movl   $0x1,0xc011a66c
c0101751:	00 00 00 
c0101754:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c010175a:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
c010175e:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101762:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101766:	ee                   	out    %al,(%dx)
c0101767:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c010176d:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
c0101771:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101775:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101779:	ee                   	out    %al,(%dx)
c010177a:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101780:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
c0101784:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101788:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010178c:	ee                   	out    %al,(%dx)
c010178d:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c0101793:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101797:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010179b:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010179f:	ee                   	out    %al,(%dx)
c01017a0:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c01017a6:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
c01017aa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01017ae:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01017b2:	ee                   	out    %al,(%dx)
c01017b3:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c01017b9:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
c01017bd:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017c1:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017c5:	ee                   	out    %al,(%dx)
c01017c6:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c01017cc:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
c01017d0:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017d4:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017d8:	ee                   	out    %al,(%dx)
c01017d9:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c01017df:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
c01017e3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017e7:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017eb:	ee                   	out    %al,(%dx)
c01017ec:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c01017f2:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
c01017f6:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017fa:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017fe:	ee                   	out    %al,(%dx)
c01017ff:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c0101805:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
c0101809:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010180d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101811:	ee                   	out    %al,(%dx)
c0101812:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c0101818:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
c010181c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101820:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101824:	ee                   	out    %al,(%dx)
c0101825:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c010182b:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
c010182f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101833:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101837:	ee                   	out    %al,(%dx)
c0101838:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c010183e:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
c0101842:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101846:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010184a:	ee                   	out    %al,(%dx)
c010184b:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c0101851:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
c0101855:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101859:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010185d:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010185e:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101865:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101869:	74 13                	je     c010187e <pic_init+0x13a>
        pic_setmask(irq_mask);
c010186b:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101872:	0f b7 c0             	movzwl %ax,%eax
c0101875:	50                   	push   %eax
c0101876:	e8 43 fe ff ff       	call   c01016be <pic_setmask>
c010187b:	83 c4 04             	add    $0x4,%esp
    }
}
c010187e:	90                   	nop
c010187f:	c9                   	leave  
c0101880:	c3                   	ret    

c0101881 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101881:	55                   	push   %ebp
c0101882:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0101884:	fb                   	sti    
    sti();
}
c0101885:	90                   	nop
c0101886:	5d                   	pop    %ebp
c0101887:	c3                   	ret    

c0101888 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101888:	55                   	push   %ebp
c0101889:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c010188b:	fa                   	cli    
    cli();
}
c010188c:	90                   	nop
c010188d:	5d                   	pop    %ebp
c010188e:	c3                   	ret    

c010188f <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c010188f:	55                   	push   %ebp
c0101890:	89 e5                	mov    %esp,%ebp
c0101892:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101895:	83 ec 08             	sub    $0x8,%esp
c0101898:	6a 64                	push   $0x64
c010189a:	68 00 5e 10 c0       	push   $0xc0105e00
c010189f:	e8 cf e9 ff ff       	call   c0100273 <cprintf>
c01018a4:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01018a7:	83 ec 0c             	sub    $0xc,%esp
c01018aa:	68 0a 5e 10 c0       	push   $0xc0105e0a
c01018af:	e8 bf e9 ff ff       	call   c0100273 <cprintf>
c01018b4:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
c01018b7:	83 ec 04             	sub    $0x4,%esp
c01018ba:	68 18 5e 10 c0       	push   $0xc0105e18
c01018bf:	6a 12                	push   $0x12
c01018c1:	68 2e 5e 10 c0       	push   $0xc0105e2e
c01018c6:	e8 0e eb ff ff       	call   c01003d9 <__panic>

c01018cb <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018cb:	55                   	push   %ebp
c01018cc:	89 e5                	mov    %esp,%ebp
c01018ce:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01018d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018d8:	e9 c3 00 00 00       	jmp    c01019a0 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e0:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c01018e7:	89 c2                	mov    %eax,%edx
c01018e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ec:	66 89 14 c5 80 a6 11 	mov    %dx,-0x3fee5980(,%eax,8)
c01018f3:	c0 
c01018f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f7:	66 c7 04 c5 82 a6 11 	movw   $0x8,-0x3fee597e(,%eax,8)
c01018fe:	c0 08 00 
c0101901:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101904:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c010190b:	c0 
c010190c:	83 e2 e0             	and    $0xffffffe0,%edx
c010190f:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c0101916:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101919:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c0101920:	c0 
c0101921:	83 e2 1f             	and    $0x1f,%edx
c0101924:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c010192b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010192e:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101935:	c0 
c0101936:	83 e2 f0             	and    $0xfffffff0,%edx
c0101939:	83 ca 0e             	or     $0xe,%edx
c010193c:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101943:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101946:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c010194d:	c0 
c010194e:	83 e2 ef             	and    $0xffffffef,%edx
c0101951:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101958:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010195b:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101962:	c0 
c0101963:	83 e2 9f             	and    $0xffffff9f,%edx
c0101966:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c010196d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101970:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101977:	c0 
c0101978:	83 ca 80             	or     $0xffffff80,%edx
c010197b:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101982:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101985:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c010198c:	c1 e8 10             	shr    $0x10,%eax
c010198f:	89 c2                	mov    %eax,%edx
c0101991:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101994:	66 89 14 c5 86 a6 11 	mov    %dx,-0x3fee597a(,%eax,8)
c010199b:	c0 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c010199c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01019a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019a3:	3d ff 00 00 00       	cmp    $0xff,%eax
c01019a8:	0f 86 2f ff ff ff    	jbe    c01018dd <idt_init+0x12>
c01019ae:	c7 45 f8 60 75 11 c0 	movl   $0xc0117560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01019b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019b8:	0f 01 18             	lidtl  (%eax)
    }
    lidt(&idt_pd);
}
c01019bb:	90                   	nop
c01019bc:	c9                   	leave  
c01019bd:	c3                   	ret    

c01019be <trapname>:

static const char *
trapname(int trapno) {
c01019be:	55                   	push   %ebp
c01019bf:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01019c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01019c4:	83 f8 13             	cmp    $0x13,%eax
c01019c7:	77 0c                	ja     c01019d5 <trapname+0x17>
        return excnames[trapno];
c01019c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01019cc:	8b 04 85 80 61 10 c0 	mov    -0x3fef9e80(,%eax,4),%eax
c01019d3:	eb 18                	jmp    c01019ed <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01019d5:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01019d9:	7e 0d                	jle    c01019e8 <trapname+0x2a>
c01019db:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01019df:	7f 07                	jg     c01019e8 <trapname+0x2a>
        return "Hardware Interrupt";
c01019e1:	b8 3f 5e 10 c0       	mov    $0xc0105e3f,%eax
c01019e6:	eb 05                	jmp    c01019ed <trapname+0x2f>
    }
    return "(unknown trap)";
c01019e8:	b8 52 5e 10 c0       	mov    $0xc0105e52,%eax
}
c01019ed:	5d                   	pop    %ebp
c01019ee:	c3                   	ret    

c01019ef <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01019ef:	55                   	push   %ebp
c01019f0:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01019f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01019f5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01019f9:	66 83 f8 08          	cmp    $0x8,%ax
c01019fd:	0f 94 c0             	sete   %al
c0101a00:	0f b6 c0             	movzbl %al,%eax
}
c0101a03:	5d                   	pop    %ebp
c0101a04:	c3                   	ret    

c0101a05 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a05:	55                   	push   %ebp
c0101a06:	89 e5                	mov    %esp,%ebp
c0101a08:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
c0101a0b:	83 ec 08             	sub    $0x8,%esp
c0101a0e:	ff 75 08             	pushl  0x8(%ebp)
c0101a11:	68 93 5e 10 c0       	push   $0xc0105e93
c0101a16:	e8 58 e8 ff ff       	call   c0100273 <cprintf>
c0101a1b:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c0101a1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a21:	83 ec 0c             	sub    $0xc,%esp
c0101a24:	50                   	push   %eax
c0101a25:	e8 b6 01 00 00       	call   c0101be0 <print_regs>
c0101a2a:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a30:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a34:	0f b7 c0             	movzwl %ax,%eax
c0101a37:	83 ec 08             	sub    $0x8,%esp
c0101a3a:	50                   	push   %eax
c0101a3b:	68 a4 5e 10 c0       	push   $0xc0105ea4
c0101a40:	e8 2e e8 ff ff       	call   c0100273 <cprintf>
c0101a45:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a48:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a4b:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a4f:	0f b7 c0             	movzwl %ax,%eax
c0101a52:	83 ec 08             	sub    $0x8,%esp
c0101a55:	50                   	push   %eax
c0101a56:	68 b7 5e 10 c0       	push   $0xc0105eb7
c0101a5b:	e8 13 e8 ff ff       	call   c0100273 <cprintf>
c0101a60:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101a63:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a66:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101a6a:	0f b7 c0             	movzwl %ax,%eax
c0101a6d:	83 ec 08             	sub    $0x8,%esp
c0101a70:	50                   	push   %eax
c0101a71:	68 ca 5e 10 c0       	push   $0xc0105eca
c0101a76:	e8 f8 e7 ff ff       	call   c0100273 <cprintf>
c0101a7b:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101a7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a81:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101a85:	0f b7 c0             	movzwl %ax,%eax
c0101a88:	83 ec 08             	sub    $0x8,%esp
c0101a8b:	50                   	push   %eax
c0101a8c:	68 dd 5e 10 c0       	push   $0xc0105edd
c0101a91:	e8 dd e7 ff ff       	call   c0100273 <cprintf>
c0101a96:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101a99:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a9c:	8b 40 30             	mov    0x30(%eax),%eax
c0101a9f:	83 ec 0c             	sub    $0xc,%esp
c0101aa2:	50                   	push   %eax
c0101aa3:	e8 16 ff ff ff       	call   c01019be <trapname>
c0101aa8:	83 c4 10             	add    $0x10,%esp
c0101aab:	89 c2                	mov    %eax,%edx
c0101aad:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab0:	8b 40 30             	mov    0x30(%eax),%eax
c0101ab3:	83 ec 04             	sub    $0x4,%esp
c0101ab6:	52                   	push   %edx
c0101ab7:	50                   	push   %eax
c0101ab8:	68 f0 5e 10 c0       	push   $0xc0105ef0
c0101abd:	e8 b1 e7 ff ff       	call   c0100273 <cprintf>
c0101ac2:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101ac5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac8:	8b 40 34             	mov    0x34(%eax),%eax
c0101acb:	83 ec 08             	sub    $0x8,%esp
c0101ace:	50                   	push   %eax
c0101acf:	68 02 5f 10 c0       	push   $0xc0105f02
c0101ad4:	e8 9a e7 ff ff       	call   c0100273 <cprintf>
c0101ad9:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101adc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101adf:	8b 40 38             	mov    0x38(%eax),%eax
c0101ae2:	83 ec 08             	sub    $0x8,%esp
c0101ae5:	50                   	push   %eax
c0101ae6:	68 11 5f 10 c0       	push   $0xc0105f11
c0101aeb:	e8 83 e7 ff ff       	call   c0100273 <cprintf>
c0101af0:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101af3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101af6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101afa:	0f b7 c0             	movzwl %ax,%eax
c0101afd:	83 ec 08             	sub    $0x8,%esp
c0101b00:	50                   	push   %eax
c0101b01:	68 20 5f 10 c0       	push   $0xc0105f20
c0101b06:	e8 68 e7 ff ff       	call   c0100273 <cprintf>
c0101b0b:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b11:	8b 40 40             	mov    0x40(%eax),%eax
c0101b14:	83 ec 08             	sub    $0x8,%esp
c0101b17:	50                   	push   %eax
c0101b18:	68 33 5f 10 c0       	push   $0xc0105f33
c0101b1d:	e8 51 e7 ff ff       	call   c0100273 <cprintf>
c0101b22:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b2c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b33:	eb 3f                	jmp    c0101b74 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b35:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b38:	8b 50 40             	mov    0x40(%eax),%edx
c0101b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b3e:	21 d0                	and    %edx,%eax
c0101b40:	85 c0                	test   %eax,%eax
c0101b42:	74 29                	je     c0101b6d <print_trapframe+0x168>
c0101b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b47:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101b4e:	85 c0                	test   %eax,%eax
c0101b50:	74 1b                	je     c0101b6d <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
c0101b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b55:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101b5c:	83 ec 08             	sub    $0x8,%esp
c0101b5f:	50                   	push   %eax
c0101b60:	68 42 5f 10 c0       	push   $0xc0105f42
c0101b65:	e8 09 e7 ff ff       	call   c0100273 <cprintf>
c0101b6a:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b6d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101b71:	d1 65 f0             	shll   -0x10(%ebp)
c0101b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b77:	83 f8 17             	cmp    $0x17,%eax
c0101b7a:	76 b9                	jbe    c0101b35 <print_trapframe+0x130>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101b7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b7f:	8b 40 40             	mov    0x40(%eax),%eax
c0101b82:	c1 e8 0c             	shr    $0xc,%eax
c0101b85:	83 e0 03             	and    $0x3,%eax
c0101b88:	83 ec 08             	sub    $0x8,%esp
c0101b8b:	50                   	push   %eax
c0101b8c:	68 46 5f 10 c0       	push   $0xc0105f46
c0101b91:	e8 dd e6 ff ff       	call   c0100273 <cprintf>
c0101b96:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c0101b99:	83 ec 0c             	sub    $0xc,%esp
c0101b9c:	ff 75 08             	pushl  0x8(%ebp)
c0101b9f:	e8 4b fe ff ff       	call   c01019ef <trap_in_kernel>
c0101ba4:	83 c4 10             	add    $0x10,%esp
c0101ba7:	85 c0                	test   %eax,%eax
c0101ba9:	75 32                	jne    c0101bdd <print_trapframe+0x1d8>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101bab:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bae:	8b 40 44             	mov    0x44(%eax),%eax
c0101bb1:	83 ec 08             	sub    $0x8,%esp
c0101bb4:	50                   	push   %eax
c0101bb5:	68 4f 5f 10 c0       	push   $0xc0105f4f
c0101bba:	e8 b4 e6 ff ff       	call   c0100273 <cprintf>
c0101bbf:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101bc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc5:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101bc9:	0f b7 c0             	movzwl %ax,%eax
c0101bcc:	83 ec 08             	sub    $0x8,%esp
c0101bcf:	50                   	push   %eax
c0101bd0:	68 5e 5f 10 c0       	push   $0xc0105f5e
c0101bd5:	e8 99 e6 ff ff       	call   c0100273 <cprintf>
c0101bda:	83 c4 10             	add    $0x10,%esp
    }
}
c0101bdd:	90                   	nop
c0101bde:	c9                   	leave  
c0101bdf:	c3                   	ret    

c0101be0 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101be0:	55                   	push   %ebp
c0101be1:	89 e5                	mov    %esp,%ebp
c0101be3:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101be6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be9:	8b 00                	mov    (%eax),%eax
c0101beb:	83 ec 08             	sub    $0x8,%esp
c0101bee:	50                   	push   %eax
c0101bef:	68 71 5f 10 c0       	push   $0xc0105f71
c0101bf4:	e8 7a e6 ff ff       	call   c0100273 <cprintf>
c0101bf9:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101bfc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bff:	8b 40 04             	mov    0x4(%eax),%eax
c0101c02:	83 ec 08             	sub    $0x8,%esp
c0101c05:	50                   	push   %eax
c0101c06:	68 80 5f 10 c0       	push   $0xc0105f80
c0101c0b:	e8 63 e6 ff ff       	call   c0100273 <cprintf>
c0101c10:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c13:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c16:	8b 40 08             	mov    0x8(%eax),%eax
c0101c19:	83 ec 08             	sub    $0x8,%esp
c0101c1c:	50                   	push   %eax
c0101c1d:	68 8f 5f 10 c0       	push   $0xc0105f8f
c0101c22:	e8 4c e6 ff ff       	call   c0100273 <cprintf>
c0101c27:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c2d:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c30:	83 ec 08             	sub    $0x8,%esp
c0101c33:	50                   	push   %eax
c0101c34:	68 9e 5f 10 c0       	push   $0xc0105f9e
c0101c39:	e8 35 e6 ff ff       	call   c0100273 <cprintf>
c0101c3e:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c41:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c44:	8b 40 10             	mov    0x10(%eax),%eax
c0101c47:	83 ec 08             	sub    $0x8,%esp
c0101c4a:	50                   	push   %eax
c0101c4b:	68 ad 5f 10 c0       	push   $0xc0105fad
c0101c50:	e8 1e e6 ff ff       	call   c0100273 <cprintf>
c0101c55:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c58:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c5b:	8b 40 14             	mov    0x14(%eax),%eax
c0101c5e:	83 ec 08             	sub    $0x8,%esp
c0101c61:	50                   	push   %eax
c0101c62:	68 bc 5f 10 c0       	push   $0xc0105fbc
c0101c67:	e8 07 e6 ff ff       	call   c0100273 <cprintf>
c0101c6c:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101c6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c72:	8b 40 18             	mov    0x18(%eax),%eax
c0101c75:	83 ec 08             	sub    $0x8,%esp
c0101c78:	50                   	push   %eax
c0101c79:	68 cb 5f 10 c0       	push   $0xc0105fcb
c0101c7e:	e8 f0 e5 ff ff       	call   c0100273 <cprintf>
c0101c83:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101c86:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c89:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101c8c:	83 ec 08             	sub    $0x8,%esp
c0101c8f:	50                   	push   %eax
c0101c90:	68 da 5f 10 c0       	push   $0xc0105fda
c0101c95:	e8 d9 e5 ff ff       	call   c0100273 <cprintf>
c0101c9a:	83 c4 10             	add    $0x10,%esp
}
c0101c9d:	90                   	nop
c0101c9e:	c9                   	leave  
c0101c9f:	c3                   	ret    

c0101ca0 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101ca0:	55                   	push   %ebp
c0101ca1:	89 e5                	mov    %esp,%ebp
c0101ca3:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
c0101ca6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca9:	8b 40 30             	mov    0x30(%eax),%eax
c0101cac:	83 f8 2f             	cmp    $0x2f,%eax
c0101caf:	77 1d                	ja     c0101cce <trap_dispatch+0x2e>
c0101cb1:	83 f8 2e             	cmp    $0x2e,%eax
c0101cb4:	0f 83 f4 00 00 00    	jae    c0101dae <trap_dispatch+0x10e>
c0101cba:	83 f8 21             	cmp    $0x21,%eax
c0101cbd:	74 7e                	je     c0101d3d <trap_dispatch+0x9d>
c0101cbf:	83 f8 24             	cmp    $0x24,%eax
c0101cc2:	74 55                	je     c0101d19 <trap_dispatch+0x79>
c0101cc4:	83 f8 20             	cmp    $0x20,%eax
c0101cc7:	74 16                	je     c0101cdf <trap_dispatch+0x3f>
c0101cc9:	e9 aa 00 00 00       	jmp    c0101d78 <trap_dispatch+0xd8>
c0101cce:	83 e8 78             	sub    $0x78,%eax
c0101cd1:	83 f8 01             	cmp    $0x1,%eax
c0101cd4:	0f 87 9e 00 00 00    	ja     c0101d78 <trap_dispatch+0xd8>
c0101cda:	e9 82 00 00 00       	jmp    c0101d61 <trap_dispatch+0xc1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101cdf:	a1 0c af 11 c0       	mov    0xc011af0c,%eax
c0101ce4:	83 c0 01             	add    $0x1,%eax
c0101ce7:	a3 0c af 11 c0       	mov    %eax,0xc011af0c
        if (ticks % TICK_NUM == 0) {
c0101cec:	8b 0d 0c af 11 c0    	mov    0xc011af0c,%ecx
c0101cf2:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101cf7:	89 c8                	mov    %ecx,%eax
c0101cf9:	f7 e2                	mul    %edx
c0101cfb:	89 d0                	mov    %edx,%eax
c0101cfd:	c1 e8 05             	shr    $0x5,%eax
c0101d00:	6b c0 64             	imul   $0x64,%eax,%eax
c0101d03:	29 c1                	sub    %eax,%ecx
c0101d05:	89 c8                	mov    %ecx,%eax
c0101d07:	85 c0                	test   %eax,%eax
c0101d09:	0f 85 a2 00 00 00    	jne    c0101db1 <trap_dispatch+0x111>
            print_ticks();
c0101d0f:	e8 7b fb ff ff       	call   c010188f <print_ticks>
        }
        break;
c0101d14:	e9 98 00 00 00       	jmp    c0101db1 <trap_dispatch+0x111>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d19:	e8 2e f9 ff ff       	call   c010164c <cons_getc>
c0101d1e:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d21:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d25:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d29:	83 ec 04             	sub    $0x4,%esp
c0101d2c:	52                   	push   %edx
c0101d2d:	50                   	push   %eax
c0101d2e:	68 e9 5f 10 c0       	push   $0xc0105fe9
c0101d33:	e8 3b e5 ff ff       	call   c0100273 <cprintf>
c0101d38:	83 c4 10             	add    $0x10,%esp
        break;
c0101d3b:	eb 75                	jmp    c0101db2 <trap_dispatch+0x112>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d3d:	e8 0a f9 ff ff       	call   c010164c <cons_getc>
c0101d42:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d45:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d49:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d4d:	83 ec 04             	sub    $0x4,%esp
c0101d50:	52                   	push   %edx
c0101d51:	50                   	push   %eax
c0101d52:	68 fb 5f 10 c0       	push   $0xc0105ffb
c0101d57:	e8 17 e5 ff ff       	call   c0100273 <cprintf>
c0101d5c:	83 c4 10             	add    $0x10,%esp
        break;
c0101d5f:	eb 51                	jmp    c0101db2 <trap_dispatch+0x112>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101d61:	83 ec 04             	sub    $0x4,%esp
c0101d64:	68 0a 60 10 c0       	push   $0xc010600a
c0101d69:	68 ac 00 00 00       	push   $0xac
c0101d6e:	68 2e 5e 10 c0       	push   $0xc0105e2e
c0101d73:	e8 61 e6 ff ff       	call   c01003d9 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101d78:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d7b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101d7f:	0f b7 c0             	movzwl %ax,%eax
c0101d82:	83 e0 03             	and    $0x3,%eax
c0101d85:	85 c0                	test   %eax,%eax
c0101d87:	75 29                	jne    c0101db2 <trap_dispatch+0x112>
            print_trapframe(tf);
c0101d89:	83 ec 0c             	sub    $0xc,%esp
c0101d8c:	ff 75 08             	pushl  0x8(%ebp)
c0101d8f:	e8 71 fc ff ff       	call   c0101a05 <print_trapframe>
c0101d94:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c0101d97:	83 ec 04             	sub    $0x4,%esp
c0101d9a:	68 1a 60 10 c0       	push   $0xc010601a
c0101d9f:	68 b6 00 00 00       	push   $0xb6
c0101da4:	68 2e 5e 10 c0       	push   $0xc0105e2e
c0101da9:	e8 2b e6 ff ff       	call   c01003d9 <__panic>
        break;
c0101dae:	90                   	nop
c0101daf:	eb 01                	jmp    c0101db2 <trap_dispatch+0x112>
        break;
c0101db1:	90                   	nop
        }
    }
}
c0101db2:	90                   	nop
c0101db3:	c9                   	leave  
c0101db4:	c3                   	ret    

c0101db5 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101db5:	55                   	push   %ebp
c0101db6:	89 e5                	mov    %esp,%ebp
c0101db8:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101dbb:	83 ec 0c             	sub    $0xc,%esp
c0101dbe:	ff 75 08             	pushl  0x8(%ebp)
c0101dc1:	e8 da fe ff ff       	call   c0101ca0 <trap_dispatch>
c0101dc6:	83 c4 10             	add    $0x10,%esp
}
c0101dc9:	90                   	nop
c0101dca:	c9                   	leave  
c0101dcb:	c3                   	ret    

c0101dcc <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101dcc:	6a 00                	push   $0x0
  pushl $0
c0101dce:	6a 00                	push   $0x0
  jmp __alltraps
c0101dd0:	e9 67 0a 00 00       	jmp    c010283c <__alltraps>

c0101dd5 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101dd5:	6a 00                	push   $0x0
  pushl $1
c0101dd7:	6a 01                	push   $0x1
  jmp __alltraps
c0101dd9:	e9 5e 0a 00 00       	jmp    c010283c <__alltraps>

c0101dde <vector2>:
.globl vector2
vector2:
  pushl $0
c0101dde:	6a 00                	push   $0x0
  pushl $2
c0101de0:	6a 02                	push   $0x2
  jmp __alltraps
c0101de2:	e9 55 0a 00 00       	jmp    c010283c <__alltraps>

c0101de7 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101de7:	6a 00                	push   $0x0
  pushl $3
c0101de9:	6a 03                	push   $0x3
  jmp __alltraps
c0101deb:	e9 4c 0a 00 00       	jmp    c010283c <__alltraps>

c0101df0 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101df0:	6a 00                	push   $0x0
  pushl $4
c0101df2:	6a 04                	push   $0x4
  jmp __alltraps
c0101df4:	e9 43 0a 00 00       	jmp    c010283c <__alltraps>

c0101df9 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101df9:	6a 00                	push   $0x0
  pushl $5
c0101dfb:	6a 05                	push   $0x5
  jmp __alltraps
c0101dfd:	e9 3a 0a 00 00       	jmp    c010283c <__alltraps>

c0101e02 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101e02:	6a 00                	push   $0x0
  pushl $6
c0101e04:	6a 06                	push   $0x6
  jmp __alltraps
c0101e06:	e9 31 0a 00 00       	jmp    c010283c <__alltraps>

c0101e0b <vector7>:
.globl vector7
vector7:
  pushl $0
c0101e0b:	6a 00                	push   $0x0
  pushl $7
c0101e0d:	6a 07                	push   $0x7
  jmp __alltraps
c0101e0f:	e9 28 0a 00 00       	jmp    c010283c <__alltraps>

c0101e14 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101e14:	6a 08                	push   $0x8
  jmp __alltraps
c0101e16:	e9 21 0a 00 00       	jmp    c010283c <__alltraps>

c0101e1b <vector9>:
.globl vector9
vector9:
  pushl $9
c0101e1b:	6a 09                	push   $0x9
  jmp __alltraps
c0101e1d:	e9 1a 0a 00 00       	jmp    c010283c <__alltraps>

c0101e22 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101e22:	6a 0a                	push   $0xa
  jmp __alltraps
c0101e24:	e9 13 0a 00 00       	jmp    c010283c <__alltraps>

c0101e29 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101e29:	6a 0b                	push   $0xb
  jmp __alltraps
c0101e2b:	e9 0c 0a 00 00       	jmp    c010283c <__alltraps>

c0101e30 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101e30:	6a 0c                	push   $0xc
  jmp __alltraps
c0101e32:	e9 05 0a 00 00       	jmp    c010283c <__alltraps>

c0101e37 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101e37:	6a 0d                	push   $0xd
  jmp __alltraps
c0101e39:	e9 fe 09 00 00       	jmp    c010283c <__alltraps>

c0101e3e <vector14>:
.globl vector14
vector14:
  pushl $14
c0101e3e:	6a 0e                	push   $0xe
  jmp __alltraps
c0101e40:	e9 f7 09 00 00       	jmp    c010283c <__alltraps>

c0101e45 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101e45:	6a 00                	push   $0x0
  pushl $15
c0101e47:	6a 0f                	push   $0xf
  jmp __alltraps
c0101e49:	e9 ee 09 00 00       	jmp    c010283c <__alltraps>

c0101e4e <vector16>:
.globl vector16
vector16:
  pushl $0
c0101e4e:	6a 00                	push   $0x0
  pushl $16
c0101e50:	6a 10                	push   $0x10
  jmp __alltraps
c0101e52:	e9 e5 09 00 00       	jmp    c010283c <__alltraps>

c0101e57 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101e57:	6a 11                	push   $0x11
  jmp __alltraps
c0101e59:	e9 de 09 00 00       	jmp    c010283c <__alltraps>

c0101e5e <vector18>:
.globl vector18
vector18:
  pushl $0
c0101e5e:	6a 00                	push   $0x0
  pushl $18
c0101e60:	6a 12                	push   $0x12
  jmp __alltraps
c0101e62:	e9 d5 09 00 00       	jmp    c010283c <__alltraps>

c0101e67 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101e67:	6a 00                	push   $0x0
  pushl $19
c0101e69:	6a 13                	push   $0x13
  jmp __alltraps
c0101e6b:	e9 cc 09 00 00       	jmp    c010283c <__alltraps>

c0101e70 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101e70:	6a 00                	push   $0x0
  pushl $20
c0101e72:	6a 14                	push   $0x14
  jmp __alltraps
c0101e74:	e9 c3 09 00 00       	jmp    c010283c <__alltraps>

c0101e79 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101e79:	6a 00                	push   $0x0
  pushl $21
c0101e7b:	6a 15                	push   $0x15
  jmp __alltraps
c0101e7d:	e9 ba 09 00 00       	jmp    c010283c <__alltraps>

c0101e82 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101e82:	6a 00                	push   $0x0
  pushl $22
c0101e84:	6a 16                	push   $0x16
  jmp __alltraps
c0101e86:	e9 b1 09 00 00       	jmp    c010283c <__alltraps>

c0101e8b <vector23>:
.globl vector23
vector23:
  pushl $0
c0101e8b:	6a 00                	push   $0x0
  pushl $23
c0101e8d:	6a 17                	push   $0x17
  jmp __alltraps
c0101e8f:	e9 a8 09 00 00       	jmp    c010283c <__alltraps>

c0101e94 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101e94:	6a 00                	push   $0x0
  pushl $24
c0101e96:	6a 18                	push   $0x18
  jmp __alltraps
c0101e98:	e9 9f 09 00 00       	jmp    c010283c <__alltraps>

c0101e9d <vector25>:
.globl vector25
vector25:
  pushl $0
c0101e9d:	6a 00                	push   $0x0
  pushl $25
c0101e9f:	6a 19                	push   $0x19
  jmp __alltraps
c0101ea1:	e9 96 09 00 00       	jmp    c010283c <__alltraps>

c0101ea6 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101ea6:	6a 00                	push   $0x0
  pushl $26
c0101ea8:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101eaa:	e9 8d 09 00 00       	jmp    c010283c <__alltraps>

c0101eaf <vector27>:
.globl vector27
vector27:
  pushl $0
c0101eaf:	6a 00                	push   $0x0
  pushl $27
c0101eb1:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101eb3:	e9 84 09 00 00       	jmp    c010283c <__alltraps>

c0101eb8 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101eb8:	6a 00                	push   $0x0
  pushl $28
c0101eba:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101ebc:	e9 7b 09 00 00       	jmp    c010283c <__alltraps>

c0101ec1 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101ec1:	6a 00                	push   $0x0
  pushl $29
c0101ec3:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101ec5:	e9 72 09 00 00       	jmp    c010283c <__alltraps>

c0101eca <vector30>:
.globl vector30
vector30:
  pushl $0
c0101eca:	6a 00                	push   $0x0
  pushl $30
c0101ecc:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101ece:	e9 69 09 00 00       	jmp    c010283c <__alltraps>

c0101ed3 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101ed3:	6a 00                	push   $0x0
  pushl $31
c0101ed5:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101ed7:	e9 60 09 00 00       	jmp    c010283c <__alltraps>

c0101edc <vector32>:
.globl vector32
vector32:
  pushl $0
c0101edc:	6a 00                	push   $0x0
  pushl $32
c0101ede:	6a 20                	push   $0x20
  jmp __alltraps
c0101ee0:	e9 57 09 00 00       	jmp    c010283c <__alltraps>

c0101ee5 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101ee5:	6a 00                	push   $0x0
  pushl $33
c0101ee7:	6a 21                	push   $0x21
  jmp __alltraps
c0101ee9:	e9 4e 09 00 00       	jmp    c010283c <__alltraps>

c0101eee <vector34>:
.globl vector34
vector34:
  pushl $0
c0101eee:	6a 00                	push   $0x0
  pushl $34
c0101ef0:	6a 22                	push   $0x22
  jmp __alltraps
c0101ef2:	e9 45 09 00 00       	jmp    c010283c <__alltraps>

c0101ef7 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101ef7:	6a 00                	push   $0x0
  pushl $35
c0101ef9:	6a 23                	push   $0x23
  jmp __alltraps
c0101efb:	e9 3c 09 00 00       	jmp    c010283c <__alltraps>

c0101f00 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101f00:	6a 00                	push   $0x0
  pushl $36
c0101f02:	6a 24                	push   $0x24
  jmp __alltraps
c0101f04:	e9 33 09 00 00       	jmp    c010283c <__alltraps>

c0101f09 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101f09:	6a 00                	push   $0x0
  pushl $37
c0101f0b:	6a 25                	push   $0x25
  jmp __alltraps
c0101f0d:	e9 2a 09 00 00       	jmp    c010283c <__alltraps>

c0101f12 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101f12:	6a 00                	push   $0x0
  pushl $38
c0101f14:	6a 26                	push   $0x26
  jmp __alltraps
c0101f16:	e9 21 09 00 00       	jmp    c010283c <__alltraps>

c0101f1b <vector39>:
.globl vector39
vector39:
  pushl $0
c0101f1b:	6a 00                	push   $0x0
  pushl $39
c0101f1d:	6a 27                	push   $0x27
  jmp __alltraps
c0101f1f:	e9 18 09 00 00       	jmp    c010283c <__alltraps>

c0101f24 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101f24:	6a 00                	push   $0x0
  pushl $40
c0101f26:	6a 28                	push   $0x28
  jmp __alltraps
c0101f28:	e9 0f 09 00 00       	jmp    c010283c <__alltraps>

c0101f2d <vector41>:
.globl vector41
vector41:
  pushl $0
c0101f2d:	6a 00                	push   $0x0
  pushl $41
c0101f2f:	6a 29                	push   $0x29
  jmp __alltraps
c0101f31:	e9 06 09 00 00       	jmp    c010283c <__alltraps>

c0101f36 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101f36:	6a 00                	push   $0x0
  pushl $42
c0101f38:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101f3a:	e9 fd 08 00 00       	jmp    c010283c <__alltraps>

c0101f3f <vector43>:
.globl vector43
vector43:
  pushl $0
c0101f3f:	6a 00                	push   $0x0
  pushl $43
c0101f41:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101f43:	e9 f4 08 00 00       	jmp    c010283c <__alltraps>

c0101f48 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101f48:	6a 00                	push   $0x0
  pushl $44
c0101f4a:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101f4c:	e9 eb 08 00 00       	jmp    c010283c <__alltraps>

c0101f51 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101f51:	6a 00                	push   $0x0
  pushl $45
c0101f53:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101f55:	e9 e2 08 00 00       	jmp    c010283c <__alltraps>

c0101f5a <vector46>:
.globl vector46
vector46:
  pushl $0
c0101f5a:	6a 00                	push   $0x0
  pushl $46
c0101f5c:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101f5e:	e9 d9 08 00 00       	jmp    c010283c <__alltraps>

c0101f63 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101f63:	6a 00                	push   $0x0
  pushl $47
c0101f65:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101f67:	e9 d0 08 00 00       	jmp    c010283c <__alltraps>

c0101f6c <vector48>:
.globl vector48
vector48:
  pushl $0
c0101f6c:	6a 00                	push   $0x0
  pushl $48
c0101f6e:	6a 30                	push   $0x30
  jmp __alltraps
c0101f70:	e9 c7 08 00 00       	jmp    c010283c <__alltraps>

c0101f75 <vector49>:
.globl vector49
vector49:
  pushl $0
c0101f75:	6a 00                	push   $0x0
  pushl $49
c0101f77:	6a 31                	push   $0x31
  jmp __alltraps
c0101f79:	e9 be 08 00 00       	jmp    c010283c <__alltraps>

c0101f7e <vector50>:
.globl vector50
vector50:
  pushl $0
c0101f7e:	6a 00                	push   $0x0
  pushl $50
c0101f80:	6a 32                	push   $0x32
  jmp __alltraps
c0101f82:	e9 b5 08 00 00       	jmp    c010283c <__alltraps>

c0101f87 <vector51>:
.globl vector51
vector51:
  pushl $0
c0101f87:	6a 00                	push   $0x0
  pushl $51
c0101f89:	6a 33                	push   $0x33
  jmp __alltraps
c0101f8b:	e9 ac 08 00 00       	jmp    c010283c <__alltraps>

c0101f90 <vector52>:
.globl vector52
vector52:
  pushl $0
c0101f90:	6a 00                	push   $0x0
  pushl $52
c0101f92:	6a 34                	push   $0x34
  jmp __alltraps
c0101f94:	e9 a3 08 00 00       	jmp    c010283c <__alltraps>

c0101f99 <vector53>:
.globl vector53
vector53:
  pushl $0
c0101f99:	6a 00                	push   $0x0
  pushl $53
c0101f9b:	6a 35                	push   $0x35
  jmp __alltraps
c0101f9d:	e9 9a 08 00 00       	jmp    c010283c <__alltraps>

c0101fa2 <vector54>:
.globl vector54
vector54:
  pushl $0
c0101fa2:	6a 00                	push   $0x0
  pushl $54
c0101fa4:	6a 36                	push   $0x36
  jmp __alltraps
c0101fa6:	e9 91 08 00 00       	jmp    c010283c <__alltraps>

c0101fab <vector55>:
.globl vector55
vector55:
  pushl $0
c0101fab:	6a 00                	push   $0x0
  pushl $55
c0101fad:	6a 37                	push   $0x37
  jmp __alltraps
c0101faf:	e9 88 08 00 00       	jmp    c010283c <__alltraps>

c0101fb4 <vector56>:
.globl vector56
vector56:
  pushl $0
c0101fb4:	6a 00                	push   $0x0
  pushl $56
c0101fb6:	6a 38                	push   $0x38
  jmp __alltraps
c0101fb8:	e9 7f 08 00 00       	jmp    c010283c <__alltraps>

c0101fbd <vector57>:
.globl vector57
vector57:
  pushl $0
c0101fbd:	6a 00                	push   $0x0
  pushl $57
c0101fbf:	6a 39                	push   $0x39
  jmp __alltraps
c0101fc1:	e9 76 08 00 00       	jmp    c010283c <__alltraps>

c0101fc6 <vector58>:
.globl vector58
vector58:
  pushl $0
c0101fc6:	6a 00                	push   $0x0
  pushl $58
c0101fc8:	6a 3a                	push   $0x3a
  jmp __alltraps
c0101fca:	e9 6d 08 00 00       	jmp    c010283c <__alltraps>

c0101fcf <vector59>:
.globl vector59
vector59:
  pushl $0
c0101fcf:	6a 00                	push   $0x0
  pushl $59
c0101fd1:	6a 3b                	push   $0x3b
  jmp __alltraps
c0101fd3:	e9 64 08 00 00       	jmp    c010283c <__alltraps>

c0101fd8 <vector60>:
.globl vector60
vector60:
  pushl $0
c0101fd8:	6a 00                	push   $0x0
  pushl $60
c0101fda:	6a 3c                	push   $0x3c
  jmp __alltraps
c0101fdc:	e9 5b 08 00 00       	jmp    c010283c <__alltraps>

c0101fe1 <vector61>:
.globl vector61
vector61:
  pushl $0
c0101fe1:	6a 00                	push   $0x0
  pushl $61
c0101fe3:	6a 3d                	push   $0x3d
  jmp __alltraps
c0101fe5:	e9 52 08 00 00       	jmp    c010283c <__alltraps>

c0101fea <vector62>:
.globl vector62
vector62:
  pushl $0
c0101fea:	6a 00                	push   $0x0
  pushl $62
c0101fec:	6a 3e                	push   $0x3e
  jmp __alltraps
c0101fee:	e9 49 08 00 00       	jmp    c010283c <__alltraps>

c0101ff3 <vector63>:
.globl vector63
vector63:
  pushl $0
c0101ff3:	6a 00                	push   $0x0
  pushl $63
c0101ff5:	6a 3f                	push   $0x3f
  jmp __alltraps
c0101ff7:	e9 40 08 00 00       	jmp    c010283c <__alltraps>

c0101ffc <vector64>:
.globl vector64
vector64:
  pushl $0
c0101ffc:	6a 00                	push   $0x0
  pushl $64
c0101ffe:	6a 40                	push   $0x40
  jmp __alltraps
c0102000:	e9 37 08 00 00       	jmp    c010283c <__alltraps>

c0102005 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102005:	6a 00                	push   $0x0
  pushl $65
c0102007:	6a 41                	push   $0x41
  jmp __alltraps
c0102009:	e9 2e 08 00 00       	jmp    c010283c <__alltraps>

c010200e <vector66>:
.globl vector66
vector66:
  pushl $0
c010200e:	6a 00                	push   $0x0
  pushl $66
c0102010:	6a 42                	push   $0x42
  jmp __alltraps
c0102012:	e9 25 08 00 00       	jmp    c010283c <__alltraps>

c0102017 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102017:	6a 00                	push   $0x0
  pushl $67
c0102019:	6a 43                	push   $0x43
  jmp __alltraps
c010201b:	e9 1c 08 00 00       	jmp    c010283c <__alltraps>

c0102020 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102020:	6a 00                	push   $0x0
  pushl $68
c0102022:	6a 44                	push   $0x44
  jmp __alltraps
c0102024:	e9 13 08 00 00       	jmp    c010283c <__alltraps>

c0102029 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102029:	6a 00                	push   $0x0
  pushl $69
c010202b:	6a 45                	push   $0x45
  jmp __alltraps
c010202d:	e9 0a 08 00 00       	jmp    c010283c <__alltraps>

c0102032 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102032:	6a 00                	push   $0x0
  pushl $70
c0102034:	6a 46                	push   $0x46
  jmp __alltraps
c0102036:	e9 01 08 00 00       	jmp    c010283c <__alltraps>

c010203b <vector71>:
.globl vector71
vector71:
  pushl $0
c010203b:	6a 00                	push   $0x0
  pushl $71
c010203d:	6a 47                	push   $0x47
  jmp __alltraps
c010203f:	e9 f8 07 00 00       	jmp    c010283c <__alltraps>

c0102044 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102044:	6a 00                	push   $0x0
  pushl $72
c0102046:	6a 48                	push   $0x48
  jmp __alltraps
c0102048:	e9 ef 07 00 00       	jmp    c010283c <__alltraps>

c010204d <vector73>:
.globl vector73
vector73:
  pushl $0
c010204d:	6a 00                	push   $0x0
  pushl $73
c010204f:	6a 49                	push   $0x49
  jmp __alltraps
c0102051:	e9 e6 07 00 00       	jmp    c010283c <__alltraps>

c0102056 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102056:	6a 00                	push   $0x0
  pushl $74
c0102058:	6a 4a                	push   $0x4a
  jmp __alltraps
c010205a:	e9 dd 07 00 00       	jmp    c010283c <__alltraps>

c010205f <vector75>:
.globl vector75
vector75:
  pushl $0
c010205f:	6a 00                	push   $0x0
  pushl $75
c0102061:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102063:	e9 d4 07 00 00       	jmp    c010283c <__alltraps>

c0102068 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102068:	6a 00                	push   $0x0
  pushl $76
c010206a:	6a 4c                	push   $0x4c
  jmp __alltraps
c010206c:	e9 cb 07 00 00       	jmp    c010283c <__alltraps>

c0102071 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102071:	6a 00                	push   $0x0
  pushl $77
c0102073:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102075:	e9 c2 07 00 00       	jmp    c010283c <__alltraps>

c010207a <vector78>:
.globl vector78
vector78:
  pushl $0
c010207a:	6a 00                	push   $0x0
  pushl $78
c010207c:	6a 4e                	push   $0x4e
  jmp __alltraps
c010207e:	e9 b9 07 00 00       	jmp    c010283c <__alltraps>

c0102083 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102083:	6a 00                	push   $0x0
  pushl $79
c0102085:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102087:	e9 b0 07 00 00       	jmp    c010283c <__alltraps>

c010208c <vector80>:
.globl vector80
vector80:
  pushl $0
c010208c:	6a 00                	push   $0x0
  pushl $80
c010208e:	6a 50                	push   $0x50
  jmp __alltraps
c0102090:	e9 a7 07 00 00       	jmp    c010283c <__alltraps>

c0102095 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102095:	6a 00                	push   $0x0
  pushl $81
c0102097:	6a 51                	push   $0x51
  jmp __alltraps
c0102099:	e9 9e 07 00 00       	jmp    c010283c <__alltraps>

c010209e <vector82>:
.globl vector82
vector82:
  pushl $0
c010209e:	6a 00                	push   $0x0
  pushl $82
c01020a0:	6a 52                	push   $0x52
  jmp __alltraps
c01020a2:	e9 95 07 00 00       	jmp    c010283c <__alltraps>

c01020a7 <vector83>:
.globl vector83
vector83:
  pushl $0
c01020a7:	6a 00                	push   $0x0
  pushl $83
c01020a9:	6a 53                	push   $0x53
  jmp __alltraps
c01020ab:	e9 8c 07 00 00       	jmp    c010283c <__alltraps>

c01020b0 <vector84>:
.globl vector84
vector84:
  pushl $0
c01020b0:	6a 00                	push   $0x0
  pushl $84
c01020b2:	6a 54                	push   $0x54
  jmp __alltraps
c01020b4:	e9 83 07 00 00       	jmp    c010283c <__alltraps>

c01020b9 <vector85>:
.globl vector85
vector85:
  pushl $0
c01020b9:	6a 00                	push   $0x0
  pushl $85
c01020bb:	6a 55                	push   $0x55
  jmp __alltraps
c01020bd:	e9 7a 07 00 00       	jmp    c010283c <__alltraps>

c01020c2 <vector86>:
.globl vector86
vector86:
  pushl $0
c01020c2:	6a 00                	push   $0x0
  pushl $86
c01020c4:	6a 56                	push   $0x56
  jmp __alltraps
c01020c6:	e9 71 07 00 00       	jmp    c010283c <__alltraps>

c01020cb <vector87>:
.globl vector87
vector87:
  pushl $0
c01020cb:	6a 00                	push   $0x0
  pushl $87
c01020cd:	6a 57                	push   $0x57
  jmp __alltraps
c01020cf:	e9 68 07 00 00       	jmp    c010283c <__alltraps>

c01020d4 <vector88>:
.globl vector88
vector88:
  pushl $0
c01020d4:	6a 00                	push   $0x0
  pushl $88
c01020d6:	6a 58                	push   $0x58
  jmp __alltraps
c01020d8:	e9 5f 07 00 00       	jmp    c010283c <__alltraps>

c01020dd <vector89>:
.globl vector89
vector89:
  pushl $0
c01020dd:	6a 00                	push   $0x0
  pushl $89
c01020df:	6a 59                	push   $0x59
  jmp __alltraps
c01020e1:	e9 56 07 00 00       	jmp    c010283c <__alltraps>

c01020e6 <vector90>:
.globl vector90
vector90:
  pushl $0
c01020e6:	6a 00                	push   $0x0
  pushl $90
c01020e8:	6a 5a                	push   $0x5a
  jmp __alltraps
c01020ea:	e9 4d 07 00 00       	jmp    c010283c <__alltraps>

c01020ef <vector91>:
.globl vector91
vector91:
  pushl $0
c01020ef:	6a 00                	push   $0x0
  pushl $91
c01020f1:	6a 5b                	push   $0x5b
  jmp __alltraps
c01020f3:	e9 44 07 00 00       	jmp    c010283c <__alltraps>

c01020f8 <vector92>:
.globl vector92
vector92:
  pushl $0
c01020f8:	6a 00                	push   $0x0
  pushl $92
c01020fa:	6a 5c                	push   $0x5c
  jmp __alltraps
c01020fc:	e9 3b 07 00 00       	jmp    c010283c <__alltraps>

c0102101 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102101:	6a 00                	push   $0x0
  pushl $93
c0102103:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102105:	e9 32 07 00 00       	jmp    c010283c <__alltraps>

c010210a <vector94>:
.globl vector94
vector94:
  pushl $0
c010210a:	6a 00                	push   $0x0
  pushl $94
c010210c:	6a 5e                	push   $0x5e
  jmp __alltraps
c010210e:	e9 29 07 00 00       	jmp    c010283c <__alltraps>

c0102113 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102113:	6a 00                	push   $0x0
  pushl $95
c0102115:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102117:	e9 20 07 00 00       	jmp    c010283c <__alltraps>

c010211c <vector96>:
.globl vector96
vector96:
  pushl $0
c010211c:	6a 00                	push   $0x0
  pushl $96
c010211e:	6a 60                	push   $0x60
  jmp __alltraps
c0102120:	e9 17 07 00 00       	jmp    c010283c <__alltraps>

c0102125 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102125:	6a 00                	push   $0x0
  pushl $97
c0102127:	6a 61                	push   $0x61
  jmp __alltraps
c0102129:	e9 0e 07 00 00       	jmp    c010283c <__alltraps>

c010212e <vector98>:
.globl vector98
vector98:
  pushl $0
c010212e:	6a 00                	push   $0x0
  pushl $98
c0102130:	6a 62                	push   $0x62
  jmp __alltraps
c0102132:	e9 05 07 00 00       	jmp    c010283c <__alltraps>

c0102137 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102137:	6a 00                	push   $0x0
  pushl $99
c0102139:	6a 63                	push   $0x63
  jmp __alltraps
c010213b:	e9 fc 06 00 00       	jmp    c010283c <__alltraps>

c0102140 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102140:	6a 00                	push   $0x0
  pushl $100
c0102142:	6a 64                	push   $0x64
  jmp __alltraps
c0102144:	e9 f3 06 00 00       	jmp    c010283c <__alltraps>

c0102149 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102149:	6a 00                	push   $0x0
  pushl $101
c010214b:	6a 65                	push   $0x65
  jmp __alltraps
c010214d:	e9 ea 06 00 00       	jmp    c010283c <__alltraps>

c0102152 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102152:	6a 00                	push   $0x0
  pushl $102
c0102154:	6a 66                	push   $0x66
  jmp __alltraps
c0102156:	e9 e1 06 00 00       	jmp    c010283c <__alltraps>

c010215b <vector103>:
.globl vector103
vector103:
  pushl $0
c010215b:	6a 00                	push   $0x0
  pushl $103
c010215d:	6a 67                	push   $0x67
  jmp __alltraps
c010215f:	e9 d8 06 00 00       	jmp    c010283c <__alltraps>

c0102164 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102164:	6a 00                	push   $0x0
  pushl $104
c0102166:	6a 68                	push   $0x68
  jmp __alltraps
c0102168:	e9 cf 06 00 00       	jmp    c010283c <__alltraps>

c010216d <vector105>:
.globl vector105
vector105:
  pushl $0
c010216d:	6a 00                	push   $0x0
  pushl $105
c010216f:	6a 69                	push   $0x69
  jmp __alltraps
c0102171:	e9 c6 06 00 00       	jmp    c010283c <__alltraps>

c0102176 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102176:	6a 00                	push   $0x0
  pushl $106
c0102178:	6a 6a                	push   $0x6a
  jmp __alltraps
c010217a:	e9 bd 06 00 00       	jmp    c010283c <__alltraps>

c010217f <vector107>:
.globl vector107
vector107:
  pushl $0
c010217f:	6a 00                	push   $0x0
  pushl $107
c0102181:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102183:	e9 b4 06 00 00       	jmp    c010283c <__alltraps>

c0102188 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102188:	6a 00                	push   $0x0
  pushl $108
c010218a:	6a 6c                	push   $0x6c
  jmp __alltraps
c010218c:	e9 ab 06 00 00       	jmp    c010283c <__alltraps>

c0102191 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102191:	6a 00                	push   $0x0
  pushl $109
c0102193:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102195:	e9 a2 06 00 00       	jmp    c010283c <__alltraps>

c010219a <vector110>:
.globl vector110
vector110:
  pushl $0
c010219a:	6a 00                	push   $0x0
  pushl $110
c010219c:	6a 6e                	push   $0x6e
  jmp __alltraps
c010219e:	e9 99 06 00 00       	jmp    c010283c <__alltraps>

c01021a3 <vector111>:
.globl vector111
vector111:
  pushl $0
c01021a3:	6a 00                	push   $0x0
  pushl $111
c01021a5:	6a 6f                	push   $0x6f
  jmp __alltraps
c01021a7:	e9 90 06 00 00       	jmp    c010283c <__alltraps>

c01021ac <vector112>:
.globl vector112
vector112:
  pushl $0
c01021ac:	6a 00                	push   $0x0
  pushl $112
c01021ae:	6a 70                	push   $0x70
  jmp __alltraps
c01021b0:	e9 87 06 00 00       	jmp    c010283c <__alltraps>

c01021b5 <vector113>:
.globl vector113
vector113:
  pushl $0
c01021b5:	6a 00                	push   $0x0
  pushl $113
c01021b7:	6a 71                	push   $0x71
  jmp __alltraps
c01021b9:	e9 7e 06 00 00       	jmp    c010283c <__alltraps>

c01021be <vector114>:
.globl vector114
vector114:
  pushl $0
c01021be:	6a 00                	push   $0x0
  pushl $114
c01021c0:	6a 72                	push   $0x72
  jmp __alltraps
c01021c2:	e9 75 06 00 00       	jmp    c010283c <__alltraps>

c01021c7 <vector115>:
.globl vector115
vector115:
  pushl $0
c01021c7:	6a 00                	push   $0x0
  pushl $115
c01021c9:	6a 73                	push   $0x73
  jmp __alltraps
c01021cb:	e9 6c 06 00 00       	jmp    c010283c <__alltraps>

c01021d0 <vector116>:
.globl vector116
vector116:
  pushl $0
c01021d0:	6a 00                	push   $0x0
  pushl $116
c01021d2:	6a 74                	push   $0x74
  jmp __alltraps
c01021d4:	e9 63 06 00 00       	jmp    c010283c <__alltraps>

c01021d9 <vector117>:
.globl vector117
vector117:
  pushl $0
c01021d9:	6a 00                	push   $0x0
  pushl $117
c01021db:	6a 75                	push   $0x75
  jmp __alltraps
c01021dd:	e9 5a 06 00 00       	jmp    c010283c <__alltraps>

c01021e2 <vector118>:
.globl vector118
vector118:
  pushl $0
c01021e2:	6a 00                	push   $0x0
  pushl $118
c01021e4:	6a 76                	push   $0x76
  jmp __alltraps
c01021e6:	e9 51 06 00 00       	jmp    c010283c <__alltraps>

c01021eb <vector119>:
.globl vector119
vector119:
  pushl $0
c01021eb:	6a 00                	push   $0x0
  pushl $119
c01021ed:	6a 77                	push   $0x77
  jmp __alltraps
c01021ef:	e9 48 06 00 00       	jmp    c010283c <__alltraps>

c01021f4 <vector120>:
.globl vector120
vector120:
  pushl $0
c01021f4:	6a 00                	push   $0x0
  pushl $120
c01021f6:	6a 78                	push   $0x78
  jmp __alltraps
c01021f8:	e9 3f 06 00 00       	jmp    c010283c <__alltraps>

c01021fd <vector121>:
.globl vector121
vector121:
  pushl $0
c01021fd:	6a 00                	push   $0x0
  pushl $121
c01021ff:	6a 79                	push   $0x79
  jmp __alltraps
c0102201:	e9 36 06 00 00       	jmp    c010283c <__alltraps>

c0102206 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102206:	6a 00                	push   $0x0
  pushl $122
c0102208:	6a 7a                	push   $0x7a
  jmp __alltraps
c010220a:	e9 2d 06 00 00       	jmp    c010283c <__alltraps>

c010220f <vector123>:
.globl vector123
vector123:
  pushl $0
c010220f:	6a 00                	push   $0x0
  pushl $123
c0102211:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102213:	e9 24 06 00 00       	jmp    c010283c <__alltraps>

c0102218 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102218:	6a 00                	push   $0x0
  pushl $124
c010221a:	6a 7c                	push   $0x7c
  jmp __alltraps
c010221c:	e9 1b 06 00 00       	jmp    c010283c <__alltraps>

c0102221 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102221:	6a 00                	push   $0x0
  pushl $125
c0102223:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102225:	e9 12 06 00 00       	jmp    c010283c <__alltraps>

c010222a <vector126>:
.globl vector126
vector126:
  pushl $0
c010222a:	6a 00                	push   $0x0
  pushl $126
c010222c:	6a 7e                	push   $0x7e
  jmp __alltraps
c010222e:	e9 09 06 00 00       	jmp    c010283c <__alltraps>

c0102233 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102233:	6a 00                	push   $0x0
  pushl $127
c0102235:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102237:	e9 00 06 00 00       	jmp    c010283c <__alltraps>

c010223c <vector128>:
.globl vector128
vector128:
  pushl $0
c010223c:	6a 00                	push   $0x0
  pushl $128
c010223e:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102243:	e9 f4 05 00 00       	jmp    c010283c <__alltraps>

c0102248 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102248:	6a 00                	push   $0x0
  pushl $129
c010224a:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c010224f:	e9 e8 05 00 00       	jmp    c010283c <__alltraps>

c0102254 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102254:	6a 00                	push   $0x0
  pushl $130
c0102256:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c010225b:	e9 dc 05 00 00       	jmp    c010283c <__alltraps>

c0102260 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102260:	6a 00                	push   $0x0
  pushl $131
c0102262:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102267:	e9 d0 05 00 00       	jmp    c010283c <__alltraps>

c010226c <vector132>:
.globl vector132
vector132:
  pushl $0
c010226c:	6a 00                	push   $0x0
  pushl $132
c010226e:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102273:	e9 c4 05 00 00       	jmp    c010283c <__alltraps>

c0102278 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102278:	6a 00                	push   $0x0
  pushl $133
c010227a:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c010227f:	e9 b8 05 00 00       	jmp    c010283c <__alltraps>

c0102284 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102284:	6a 00                	push   $0x0
  pushl $134
c0102286:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c010228b:	e9 ac 05 00 00       	jmp    c010283c <__alltraps>

c0102290 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102290:	6a 00                	push   $0x0
  pushl $135
c0102292:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102297:	e9 a0 05 00 00       	jmp    c010283c <__alltraps>

c010229c <vector136>:
.globl vector136
vector136:
  pushl $0
c010229c:	6a 00                	push   $0x0
  pushl $136
c010229e:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01022a3:	e9 94 05 00 00       	jmp    c010283c <__alltraps>

c01022a8 <vector137>:
.globl vector137
vector137:
  pushl $0
c01022a8:	6a 00                	push   $0x0
  pushl $137
c01022aa:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01022af:	e9 88 05 00 00       	jmp    c010283c <__alltraps>

c01022b4 <vector138>:
.globl vector138
vector138:
  pushl $0
c01022b4:	6a 00                	push   $0x0
  pushl $138
c01022b6:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01022bb:	e9 7c 05 00 00       	jmp    c010283c <__alltraps>

c01022c0 <vector139>:
.globl vector139
vector139:
  pushl $0
c01022c0:	6a 00                	push   $0x0
  pushl $139
c01022c2:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01022c7:	e9 70 05 00 00       	jmp    c010283c <__alltraps>

c01022cc <vector140>:
.globl vector140
vector140:
  pushl $0
c01022cc:	6a 00                	push   $0x0
  pushl $140
c01022ce:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01022d3:	e9 64 05 00 00       	jmp    c010283c <__alltraps>

c01022d8 <vector141>:
.globl vector141
vector141:
  pushl $0
c01022d8:	6a 00                	push   $0x0
  pushl $141
c01022da:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01022df:	e9 58 05 00 00       	jmp    c010283c <__alltraps>

c01022e4 <vector142>:
.globl vector142
vector142:
  pushl $0
c01022e4:	6a 00                	push   $0x0
  pushl $142
c01022e6:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01022eb:	e9 4c 05 00 00       	jmp    c010283c <__alltraps>

c01022f0 <vector143>:
.globl vector143
vector143:
  pushl $0
c01022f0:	6a 00                	push   $0x0
  pushl $143
c01022f2:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01022f7:	e9 40 05 00 00       	jmp    c010283c <__alltraps>

c01022fc <vector144>:
.globl vector144
vector144:
  pushl $0
c01022fc:	6a 00                	push   $0x0
  pushl $144
c01022fe:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102303:	e9 34 05 00 00       	jmp    c010283c <__alltraps>

c0102308 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102308:	6a 00                	push   $0x0
  pushl $145
c010230a:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c010230f:	e9 28 05 00 00       	jmp    c010283c <__alltraps>

c0102314 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102314:	6a 00                	push   $0x0
  pushl $146
c0102316:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c010231b:	e9 1c 05 00 00       	jmp    c010283c <__alltraps>

c0102320 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102320:	6a 00                	push   $0x0
  pushl $147
c0102322:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102327:	e9 10 05 00 00       	jmp    c010283c <__alltraps>

c010232c <vector148>:
.globl vector148
vector148:
  pushl $0
c010232c:	6a 00                	push   $0x0
  pushl $148
c010232e:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102333:	e9 04 05 00 00       	jmp    c010283c <__alltraps>

c0102338 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102338:	6a 00                	push   $0x0
  pushl $149
c010233a:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c010233f:	e9 f8 04 00 00       	jmp    c010283c <__alltraps>

c0102344 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102344:	6a 00                	push   $0x0
  pushl $150
c0102346:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c010234b:	e9 ec 04 00 00       	jmp    c010283c <__alltraps>

c0102350 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102350:	6a 00                	push   $0x0
  pushl $151
c0102352:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102357:	e9 e0 04 00 00       	jmp    c010283c <__alltraps>

c010235c <vector152>:
.globl vector152
vector152:
  pushl $0
c010235c:	6a 00                	push   $0x0
  pushl $152
c010235e:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102363:	e9 d4 04 00 00       	jmp    c010283c <__alltraps>

c0102368 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102368:	6a 00                	push   $0x0
  pushl $153
c010236a:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c010236f:	e9 c8 04 00 00       	jmp    c010283c <__alltraps>

c0102374 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102374:	6a 00                	push   $0x0
  pushl $154
c0102376:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c010237b:	e9 bc 04 00 00       	jmp    c010283c <__alltraps>

c0102380 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102380:	6a 00                	push   $0x0
  pushl $155
c0102382:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102387:	e9 b0 04 00 00       	jmp    c010283c <__alltraps>

c010238c <vector156>:
.globl vector156
vector156:
  pushl $0
c010238c:	6a 00                	push   $0x0
  pushl $156
c010238e:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102393:	e9 a4 04 00 00       	jmp    c010283c <__alltraps>

c0102398 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102398:	6a 00                	push   $0x0
  pushl $157
c010239a:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c010239f:	e9 98 04 00 00       	jmp    c010283c <__alltraps>

c01023a4 <vector158>:
.globl vector158
vector158:
  pushl $0
c01023a4:	6a 00                	push   $0x0
  pushl $158
c01023a6:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01023ab:	e9 8c 04 00 00       	jmp    c010283c <__alltraps>

c01023b0 <vector159>:
.globl vector159
vector159:
  pushl $0
c01023b0:	6a 00                	push   $0x0
  pushl $159
c01023b2:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01023b7:	e9 80 04 00 00       	jmp    c010283c <__alltraps>

c01023bc <vector160>:
.globl vector160
vector160:
  pushl $0
c01023bc:	6a 00                	push   $0x0
  pushl $160
c01023be:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01023c3:	e9 74 04 00 00       	jmp    c010283c <__alltraps>

c01023c8 <vector161>:
.globl vector161
vector161:
  pushl $0
c01023c8:	6a 00                	push   $0x0
  pushl $161
c01023ca:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01023cf:	e9 68 04 00 00       	jmp    c010283c <__alltraps>

c01023d4 <vector162>:
.globl vector162
vector162:
  pushl $0
c01023d4:	6a 00                	push   $0x0
  pushl $162
c01023d6:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01023db:	e9 5c 04 00 00       	jmp    c010283c <__alltraps>

c01023e0 <vector163>:
.globl vector163
vector163:
  pushl $0
c01023e0:	6a 00                	push   $0x0
  pushl $163
c01023e2:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01023e7:	e9 50 04 00 00       	jmp    c010283c <__alltraps>

c01023ec <vector164>:
.globl vector164
vector164:
  pushl $0
c01023ec:	6a 00                	push   $0x0
  pushl $164
c01023ee:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01023f3:	e9 44 04 00 00       	jmp    c010283c <__alltraps>

c01023f8 <vector165>:
.globl vector165
vector165:
  pushl $0
c01023f8:	6a 00                	push   $0x0
  pushl $165
c01023fa:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01023ff:	e9 38 04 00 00       	jmp    c010283c <__alltraps>

c0102404 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102404:	6a 00                	push   $0x0
  pushl $166
c0102406:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c010240b:	e9 2c 04 00 00       	jmp    c010283c <__alltraps>

c0102410 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102410:	6a 00                	push   $0x0
  pushl $167
c0102412:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102417:	e9 20 04 00 00       	jmp    c010283c <__alltraps>

c010241c <vector168>:
.globl vector168
vector168:
  pushl $0
c010241c:	6a 00                	push   $0x0
  pushl $168
c010241e:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102423:	e9 14 04 00 00       	jmp    c010283c <__alltraps>

c0102428 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102428:	6a 00                	push   $0x0
  pushl $169
c010242a:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c010242f:	e9 08 04 00 00       	jmp    c010283c <__alltraps>

c0102434 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102434:	6a 00                	push   $0x0
  pushl $170
c0102436:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c010243b:	e9 fc 03 00 00       	jmp    c010283c <__alltraps>

c0102440 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102440:	6a 00                	push   $0x0
  pushl $171
c0102442:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102447:	e9 f0 03 00 00       	jmp    c010283c <__alltraps>

c010244c <vector172>:
.globl vector172
vector172:
  pushl $0
c010244c:	6a 00                	push   $0x0
  pushl $172
c010244e:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102453:	e9 e4 03 00 00       	jmp    c010283c <__alltraps>

c0102458 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102458:	6a 00                	push   $0x0
  pushl $173
c010245a:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c010245f:	e9 d8 03 00 00       	jmp    c010283c <__alltraps>

c0102464 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102464:	6a 00                	push   $0x0
  pushl $174
c0102466:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c010246b:	e9 cc 03 00 00       	jmp    c010283c <__alltraps>

c0102470 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102470:	6a 00                	push   $0x0
  pushl $175
c0102472:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102477:	e9 c0 03 00 00       	jmp    c010283c <__alltraps>

c010247c <vector176>:
.globl vector176
vector176:
  pushl $0
c010247c:	6a 00                	push   $0x0
  pushl $176
c010247e:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102483:	e9 b4 03 00 00       	jmp    c010283c <__alltraps>

c0102488 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102488:	6a 00                	push   $0x0
  pushl $177
c010248a:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c010248f:	e9 a8 03 00 00       	jmp    c010283c <__alltraps>

c0102494 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102494:	6a 00                	push   $0x0
  pushl $178
c0102496:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010249b:	e9 9c 03 00 00       	jmp    c010283c <__alltraps>

c01024a0 <vector179>:
.globl vector179
vector179:
  pushl $0
c01024a0:	6a 00                	push   $0x0
  pushl $179
c01024a2:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01024a7:	e9 90 03 00 00       	jmp    c010283c <__alltraps>

c01024ac <vector180>:
.globl vector180
vector180:
  pushl $0
c01024ac:	6a 00                	push   $0x0
  pushl $180
c01024ae:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01024b3:	e9 84 03 00 00       	jmp    c010283c <__alltraps>

c01024b8 <vector181>:
.globl vector181
vector181:
  pushl $0
c01024b8:	6a 00                	push   $0x0
  pushl $181
c01024ba:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01024bf:	e9 78 03 00 00       	jmp    c010283c <__alltraps>

c01024c4 <vector182>:
.globl vector182
vector182:
  pushl $0
c01024c4:	6a 00                	push   $0x0
  pushl $182
c01024c6:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01024cb:	e9 6c 03 00 00       	jmp    c010283c <__alltraps>

c01024d0 <vector183>:
.globl vector183
vector183:
  pushl $0
c01024d0:	6a 00                	push   $0x0
  pushl $183
c01024d2:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01024d7:	e9 60 03 00 00       	jmp    c010283c <__alltraps>

c01024dc <vector184>:
.globl vector184
vector184:
  pushl $0
c01024dc:	6a 00                	push   $0x0
  pushl $184
c01024de:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01024e3:	e9 54 03 00 00       	jmp    c010283c <__alltraps>

c01024e8 <vector185>:
.globl vector185
vector185:
  pushl $0
c01024e8:	6a 00                	push   $0x0
  pushl $185
c01024ea:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01024ef:	e9 48 03 00 00       	jmp    c010283c <__alltraps>

c01024f4 <vector186>:
.globl vector186
vector186:
  pushl $0
c01024f4:	6a 00                	push   $0x0
  pushl $186
c01024f6:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01024fb:	e9 3c 03 00 00       	jmp    c010283c <__alltraps>

c0102500 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102500:	6a 00                	push   $0x0
  pushl $187
c0102502:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102507:	e9 30 03 00 00       	jmp    c010283c <__alltraps>

c010250c <vector188>:
.globl vector188
vector188:
  pushl $0
c010250c:	6a 00                	push   $0x0
  pushl $188
c010250e:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102513:	e9 24 03 00 00       	jmp    c010283c <__alltraps>

c0102518 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102518:	6a 00                	push   $0x0
  pushl $189
c010251a:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c010251f:	e9 18 03 00 00       	jmp    c010283c <__alltraps>

c0102524 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102524:	6a 00                	push   $0x0
  pushl $190
c0102526:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c010252b:	e9 0c 03 00 00       	jmp    c010283c <__alltraps>

c0102530 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102530:	6a 00                	push   $0x0
  pushl $191
c0102532:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102537:	e9 00 03 00 00       	jmp    c010283c <__alltraps>

c010253c <vector192>:
.globl vector192
vector192:
  pushl $0
c010253c:	6a 00                	push   $0x0
  pushl $192
c010253e:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102543:	e9 f4 02 00 00       	jmp    c010283c <__alltraps>

c0102548 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102548:	6a 00                	push   $0x0
  pushl $193
c010254a:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c010254f:	e9 e8 02 00 00       	jmp    c010283c <__alltraps>

c0102554 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102554:	6a 00                	push   $0x0
  pushl $194
c0102556:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c010255b:	e9 dc 02 00 00       	jmp    c010283c <__alltraps>

c0102560 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102560:	6a 00                	push   $0x0
  pushl $195
c0102562:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102567:	e9 d0 02 00 00       	jmp    c010283c <__alltraps>

c010256c <vector196>:
.globl vector196
vector196:
  pushl $0
c010256c:	6a 00                	push   $0x0
  pushl $196
c010256e:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102573:	e9 c4 02 00 00       	jmp    c010283c <__alltraps>

c0102578 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102578:	6a 00                	push   $0x0
  pushl $197
c010257a:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c010257f:	e9 b8 02 00 00       	jmp    c010283c <__alltraps>

c0102584 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102584:	6a 00                	push   $0x0
  pushl $198
c0102586:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c010258b:	e9 ac 02 00 00       	jmp    c010283c <__alltraps>

c0102590 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102590:	6a 00                	push   $0x0
  pushl $199
c0102592:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102597:	e9 a0 02 00 00       	jmp    c010283c <__alltraps>

c010259c <vector200>:
.globl vector200
vector200:
  pushl $0
c010259c:	6a 00                	push   $0x0
  pushl $200
c010259e:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01025a3:	e9 94 02 00 00       	jmp    c010283c <__alltraps>

c01025a8 <vector201>:
.globl vector201
vector201:
  pushl $0
c01025a8:	6a 00                	push   $0x0
  pushl $201
c01025aa:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01025af:	e9 88 02 00 00       	jmp    c010283c <__alltraps>

c01025b4 <vector202>:
.globl vector202
vector202:
  pushl $0
c01025b4:	6a 00                	push   $0x0
  pushl $202
c01025b6:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01025bb:	e9 7c 02 00 00       	jmp    c010283c <__alltraps>

c01025c0 <vector203>:
.globl vector203
vector203:
  pushl $0
c01025c0:	6a 00                	push   $0x0
  pushl $203
c01025c2:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01025c7:	e9 70 02 00 00       	jmp    c010283c <__alltraps>

c01025cc <vector204>:
.globl vector204
vector204:
  pushl $0
c01025cc:	6a 00                	push   $0x0
  pushl $204
c01025ce:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01025d3:	e9 64 02 00 00       	jmp    c010283c <__alltraps>

c01025d8 <vector205>:
.globl vector205
vector205:
  pushl $0
c01025d8:	6a 00                	push   $0x0
  pushl $205
c01025da:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01025df:	e9 58 02 00 00       	jmp    c010283c <__alltraps>

c01025e4 <vector206>:
.globl vector206
vector206:
  pushl $0
c01025e4:	6a 00                	push   $0x0
  pushl $206
c01025e6:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01025eb:	e9 4c 02 00 00       	jmp    c010283c <__alltraps>

c01025f0 <vector207>:
.globl vector207
vector207:
  pushl $0
c01025f0:	6a 00                	push   $0x0
  pushl $207
c01025f2:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01025f7:	e9 40 02 00 00       	jmp    c010283c <__alltraps>

c01025fc <vector208>:
.globl vector208
vector208:
  pushl $0
c01025fc:	6a 00                	push   $0x0
  pushl $208
c01025fe:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102603:	e9 34 02 00 00       	jmp    c010283c <__alltraps>

c0102608 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102608:	6a 00                	push   $0x0
  pushl $209
c010260a:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c010260f:	e9 28 02 00 00       	jmp    c010283c <__alltraps>

c0102614 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102614:	6a 00                	push   $0x0
  pushl $210
c0102616:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010261b:	e9 1c 02 00 00       	jmp    c010283c <__alltraps>

c0102620 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102620:	6a 00                	push   $0x0
  pushl $211
c0102622:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102627:	e9 10 02 00 00       	jmp    c010283c <__alltraps>

c010262c <vector212>:
.globl vector212
vector212:
  pushl $0
c010262c:	6a 00                	push   $0x0
  pushl $212
c010262e:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102633:	e9 04 02 00 00       	jmp    c010283c <__alltraps>

c0102638 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102638:	6a 00                	push   $0x0
  pushl $213
c010263a:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c010263f:	e9 f8 01 00 00       	jmp    c010283c <__alltraps>

c0102644 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102644:	6a 00                	push   $0x0
  pushl $214
c0102646:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010264b:	e9 ec 01 00 00       	jmp    c010283c <__alltraps>

c0102650 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102650:	6a 00                	push   $0x0
  pushl $215
c0102652:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102657:	e9 e0 01 00 00       	jmp    c010283c <__alltraps>

c010265c <vector216>:
.globl vector216
vector216:
  pushl $0
c010265c:	6a 00                	push   $0x0
  pushl $216
c010265e:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102663:	e9 d4 01 00 00       	jmp    c010283c <__alltraps>

c0102668 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102668:	6a 00                	push   $0x0
  pushl $217
c010266a:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c010266f:	e9 c8 01 00 00       	jmp    c010283c <__alltraps>

c0102674 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102674:	6a 00                	push   $0x0
  pushl $218
c0102676:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010267b:	e9 bc 01 00 00       	jmp    c010283c <__alltraps>

c0102680 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102680:	6a 00                	push   $0x0
  pushl $219
c0102682:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102687:	e9 b0 01 00 00       	jmp    c010283c <__alltraps>

c010268c <vector220>:
.globl vector220
vector220:
  pushl $0
c010268c:	6a 00                	push   $0x0
  pushl $220
c010268e:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102693:	e9 a4 01 00 00       	jmp    c010283c <__alltraps>

c0102698 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102698:	6a 00                	push   $0x0
  pushl $221
c010269a:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c010269f:	e9 98 01 00 00       	jmp    c010283c <__alltraps>

c01026a4 <vector222>:
.globl vector222
vector222:
  pushl $0
c01026a4:	6a 00                	push   $0x0
  pushl $222
c01026a6:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01026ab:	e9 8c 01 00 00       	jmp    c010283c <__alltraps>

c01026b0 <vector223>:
.globl vector223
vector223:
  pushl $0
c01026b0:	6a 00                	push   $0x0
  pushl $223
c01026b2:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01026b7:	e9 80 01 00 00       	jmp    c010283c <__alltraps>

c01026bc <vector224>:
.globl vector224
vector224:
  pushl $0
c01026bc:	6a 00                	push   $0x0
  pushl $224
c01026be:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01026c3:	e9 74 01 00 00       	jmp    c010283c <__alltraps>

c01026c8 <vector225>:
.globl vector225
vector225:
  pushl $0
c01026c8:	6a 00                	push   $0x0
  pushl $225
c01026ca:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01026cf:	e9 68 01 00 00       	jmp    c010283c <__alltraps>

c01026d4 <vector226>:
.globl vector226
vector226:
  pushl $0
c01026d4:	6a 00                	push   $0x0
  pushl $226
c01026d6:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01026db:	e9 5c 01 00 00       	jmp    c010283c <__alltraps>

c01026e0 <vector227>:
.globl vector227
vector227:
  pushl $0
c01026e0:	6a 00                	push   $0x0
  pushl $227
c01026e2:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01026e7:	e9 50 01 00 00       	jmp    c010283c <__alltraps>

c01026ec <vector228>:
.globl vector228
vector228:
  pushl $0
c01026ec:	6a 00                	push   $0x0
  pushl $228
c01026ee:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01026f3:	e9 44 01 00 00       	jmp    c010283c <__alltraps>

c01026f8 <vector229>:
.globl vector229
vector229:
  pushl $0
c01026f8:	6a 00                	push   $0x0
  pushl $229
c01026fa:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01026ff:	e9 38 01 00 00       	jmp    c010283c <__alltraps>

c0102704 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102704:	6a 00                	push   $0x0
  pushl $230
c0102706:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010270b:	e9 2c 01 00 00       	jmp    c010283c <__alltraps>

c0102710 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102710:	6a 00                	push   $0x0
  pushl $231
c0102712:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102717:	e9 20 01 00 00       	jmp    c010283c <__alltraps>

c010271c <vector232>:
.globl vector232
vector232:
  pushl $0
c010271c:	6a 00                	push   $0x0
  pushl $232
c010271e:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102723:	e9 14 01 00 00       	jmp    c010283c <__alltraps>

c0102728 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102728:	6a 00                	push   $0x0
  pushl $233
c010272a:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c010272f:	e9 08 01 00 00       	jmp    c010283c <__alltraps>

c0102734 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102734:	6a 00                	push   $0x0
  pushl $234
c0102736:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010273b:	e9 fc 00 00 00       	jmp    c010283c <__alltraps>

c0102740 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102740:	6a 00                	push   $0x0
  pushl $235
c0102742:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102747:	e9 f0 00 00 00       	jmp    c010283c <__alltraps>

c010274c <vector236>:
.globl vector236
vector236:
  pushl $0
c010274c:	6a 00                	push   $0x0
  pushl $236
c010274e:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102753:	e9 e4 00 00 00       	jmp    c010283c <__alltraps>

c0102758 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102758:	6a 00                	push   $0x0
  pushl $237
c010275a:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c010275f:	e9 d8 00 00 00       	jmp    c010283c <__alltraps>

c0102764 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102764:	6a 00                	push   $0x0
  pushl $238
c0102766:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010276b:	e9 cc 00 00 00       	jmp    c010283c <__alltraps>

c0102770 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102770:	6a 00                	push   $0x0
  pushl $239
c0102772:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102777:	e9 c0 00 00 00       	jmp    c010283c <__alltraps>

c010277c <vector240>:
.globl vector240
vector240:
  pushl $0
c010277c:	6a 00                	push   $0x0
  pushl $240
c010277e:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102783:	e9 b4 00 00 00       	jmp    c010283c <__alltraps>

c0102788 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102788:	6a 00                	push   $0x0
  pushl $241
c010278a:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c010278f:	e9 a8 00 00 00       	jmp    c010283c <__alltraps>

c0102794 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102794:	6a 00                	push   $0x0
  pushl $242
c0102796:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010279b:	e9 9c 00 00 00       	jmp    c010283c <__alltraps>

c01027a0 <vector243>:
.globl vector243
vector243:
  pushl $0
c01027a0:	6a 00                	push   $0x0
  pushl $243
c01027a2:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01027a7:	e9 90 00 00 00       	jmp    c010283c <__alltraps>

c01027ac <vector244>:
.globl vector244
vector244:
  pushl $0
c01027ac:	6a 00                	push   $0x0
  pushl $244
c01027ae:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01027b3:	e9 84 00 00 00       	jmp    c010283c <__alltraps>

c01027b8 <vector245>:
.globl vector245
vector245:
  pushl $0
c01027b8:	6a 00                	push   $0x0
  pushl $245
c01027ba:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01027bf:	e9 78 00 00 00       	jmp    c010283c <__alltraps>

c01027c4 <vector246>:
.globl vector246
vector246:
  pushl $0
c01027c4:	6a 00                	push   $0x0
  pushl $246
c01027c6:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01027cb:	e9 6c 00 00 00       	jmp    c010283c <__alltraps>

c01027d0 <vector247>:
.globl vector247
vector247:
  pushl $0
c01027d0:	6a 00                	push   $0x0
  pushl $247
c01027d2:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01027d7:	e9 60 00 00 00       	jmp    c010283c <__alltraps>

c01027dc <vector248>:
.globl vector248
vector248:
  pushl $0
c01027dc:	6a 00                	push   $0x0
  pushl $248
c01027de:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01027e3:	e9 54 00 00 00       	jmp    c010283c <__alltraps>

c01027e8 <vector249>:
.globl vector249
vector249:
  pushl $0
c01027e8:	6a 00                	push   $0x0
  pushl $249
c01027ea:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01027ef:	e9 48 00 00 00       	jmp    c010283c <__alltraps>

c01027f4 <vector250>:
.globl vector250
vector250:
  pushl $0
c01027f4:	6a 00                	push   $0x0
  pushl $250
c01027f6:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01027fb:	e9 3c 00 00 00       	jmp    c010283c <__alltraps>

c0102800 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102800:	6a 00                	push   $0x0
  pushl $251
c0102802:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102807:	e9 30 00 00 00       	jmp    c010283c <__alltraps>

c010280c <vector252>:
.globl vector252
vector252:
  pushl $0
c010280c:	6a 00                	push   $0x0
  pushl $252
c010280e:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102813:	e9 24 00 00 00       	jmp    c010283c <__alltraps>

c0102818 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102818:	6a 00                	push   $0x0
  pushl $253
c010281a:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c010281f:	e9 18 00 00 00       	jmp    c010283c <__alltraps>

c0102824 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102824:	6a 00                	push   $0x0
  pushl $254
c0102826:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010282b:	e9 0c 00 00 00       	jmp    c010283c <__alltraps>

c0102830 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102830:	6a 00                	push   $0x0
  pushl $255
c0102832:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102837:	e9 00 00 00 00       	jmp    c010283c <__alltraps>

c010283c <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c010283c:	1e                   	push   %ds
    pushl %es
c010283d:	06                   	push   %es
    pushl %fs
c010283e:	0f a0                	push   %fs
    pushl %gs
c0102840:	0f a8                	push   %gs
    pushal
c0102842:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102843:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102848:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010284a:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c010284c:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c010284d:	e8 63 f5 ff ff       	call   c0101db5 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102852:	5c                   	pop    %esp

c0102853 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102853:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102854:	0f a9                	pop    %gs
    popl %fs
c0102856:	0f a1                	pop    %fs
    popl %es
c0102858:	07                   	pop    %es
    popl %ds
c0102859:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c010285a:	83 c4 08             	add    $0x8,%esp
    iret
c010285d:	cf                   	iret   

c010285e <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010285e:	55                   	push   %ebp
c010285f:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102861:	8b 45 08             	mov    0x8(%ebp),%eax
c0102864:	8b 15 18 af 11 c0    	mov    0xc011af18,%edx
c010286a:	29 d0                	sub    %edx,%eax
c010286c:	c1 f8 02             	sar    $0x2,%eax
c010286f:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102875:	5d                   	pop    %ebp
c0102876:	c3                   	ret    

c0102877 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102877:	55                   	push   %ebp
c0102878:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c010287a:	ff 75 08             	pushl  0x8(%ebp)
c010287d:	e8 dc ff ff ff       	call   c010285e <page2ppn>
c0102882:	83 c4 04             	add    $0x4,%esp
c0102885:	c1 e0 0c             	shl    $0xc,%eax
}
c0102888:	c9                   	leave  
c0102889:	c3                   	ret    

c010288a <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c010288a:	55                   	push   %ebp
c010288b:	89 e5                	mov    %esp,%ebp
c010288d:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c0102890:	8b 45 08             	mov    0x8(%ebp),%eax
c0102893:	c1 e8 0c             	shr    $0xc,%eax
c0102896:	89 c2                	mov    %eax,%edx
c0102898:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c010289d:	39 c2                	cmp    %eax,%edx
c010289f:	72 14                	jb     c01028b5 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c01028a1:	83 ec 04             	sub    $0x4,%esp
c01028a4:	68 d0 61 10 c0       	push   $0xc01061d0
c01028a9:	6a 5a                	push   $0x5a
c01028ab:	68 ef 61 10 c0       	push   $0xc01061ef
c01028b0:	e8 24 db ff ff       	call   c01003d9 <__panic>
    }
    return &pages[PPN(pa)];
c01028b5:	8b 0d 18 af 11 c0    	mov    0xc011af18,%ecx
c01028bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01028be:	c1 e8 0c             	shr    $0xc,%eax
c01028c1:	89 c2                	mov    %eax,%edx
c01028c3:	89 d0                	mov    %edx,%eax
c01028c5:	c1 e0 02             	shl    $0x2,%eax
c01028c8:	01 d0                	add    %edx,%eax
c01028ca:	c1 e0 02             	shl    $0x2,%eax
c01028cd:	01 c8                	add    %ecx,%eax
}
c01028cf:	c9                   	leave  
c01028d0:	c3                   	ret    

c01028d1 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01028d1:	55                   	push   %ebp
c01028d2:	89 e5                	mov    %esp,%ebp
c01028d4:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c01028d7:	ff 75 08             	pushl  0x8(%ebp)
c01028da:	e8 98 ff ff ff       	call   c0102877 <page2pa>
c01028df:	83 c4 04             	add    $0x4,%esp
c01028e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028e8:	c1 e8 0c             	shr    $0xc,%eax
c01028eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01028ee:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c01028f3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01028f6:	72 14                	jb     c010290c <page2kva+0x3b>
c01028f8:	ff 75 f4             	pushl  -0xc(%ebp)
c01028fb:	68 00 62 10 c0       	push   $0xc0106200
c0102900:	6a 61                	push   $0x61
c0102902:	68 ef 61 10 c0       	push   $0xc01061ef
c0102907:	e8 cd da ff ff       	call   c01003d9 <__panic>
c010290c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010290f:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102914:	c9                   	leave  
c0102915:	c3                   	ret    

c0102916 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102916:	55                   	push   %ebp
c0102917:	89 e5                	mov    %esp,%ebp
c0102919:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c010291c:	8b 45 08             	mov    0x8(%ebp),%eax
c010291f:	83 e0 01             	and    $0x1,%eax
c0102922:	85 c0                	test   %eax,%eax
c0102924:	75 14                	jne    c010293a <pte2page+0x24>
        panic("pte2page called with invalid pte");
c0102926:	83 ec 04             	sub    $0x4,%esp
c0102929:	68 24 62 10 c0       	push   $0xc0106224
c010292e:	6a 6c                	push   $0x6c
c0102930:	68 ef 61 10 c0       	push   $0xc01061ef
c0102935:	e8 9f da ff ff       	call   c01003d9 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c010293a:	8b 45 08             	mov    0x8(%ebp),%eax
c010293d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102942:	83 ec 0c             	sub    $0xc,%esp
c0102945:	50                   	push   %eax
c0102946:	e8 3f ff ff ff       	call   c010288a <pa2page>
c010294b:	83 c4 10             	add    $0x10,%esp
}
c010294e:	c9                   	leave  
c010294f:	c3                   	ret    

c0102950 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102950:	55                   	push   %ebp
c0102951:	89 e5                	mov    %esp,%ebp
c0102953:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c0102956:	8b 45 08             	mov    0x8(%ebp),%eax
c0102959:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010295e:	83 ec 0c             	sub    $0xc,%esp
c0102961:	50                   	push   %eax
c0102962:	e8 23 ff ff ff       	call   c010288a <pa2page>
c0102967:	83 c4 10             	add    $0x10,%esp
}
c010296a:	c9                   	leave  
c010296b:	c3                   	ret    

c010296c <page_ref>:

static inline int
page_ref(struct Page *page) {
c010296c:	55                   	push   %ebp
c010296d:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010296f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102972:	8b 00                	mov    (%eax),%eax
}
c0102974:	5d                   	pop    %ebp
c0102975:	c3                   	ret    

c0102976 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102976:	55                   	push   %ebp
c0102977:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102979:	8b 45 08             	mov    0x8(%ebp),%eax
c010297c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010297f:	89 10                	mov    %edx,(%eax)
}
c0102981:	90                   	nop
c0102982:	5d                   	pop    %ebp
c0102983:	c3                   	ret    

c0102984 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0102984:	55                   	push   %ebp
c0102985:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102987:	8b 45 08             	mov    0x8(%ebp),%eax
c010298a:	8b 00                	mov    (%eax),%eax
c010298c:	8d 50 01             	lea    0x1(%eax),%edx
c010298f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102992:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102994:	8b 45 08             	mov    0x8(%ebp),%eax
c0102997:	8b 00                	mov    (%eax),%eax
}
c0102999:	5d                   	pop    %ebp
c010299a:	c3                   	ret    

c010299b <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c010299b:	55                   	push   %ebp
c010299c:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c010299e:	8b 45 08             	mov    0x8(%ebp),%eax
c01029a1:	8b 00                	mov    (%eax),%eax
c01029a3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01029a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01029a9:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01029ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01029ae:	8b 00                	mov    (%eax),%eax
}
c01029b0:	5d                   	pop    %ebp
c01029b1:	c3                   	ret    

c01029b2 <__intr_save>:
__intr_save(void) {
c01029b2:	55                   	push   %ebp
c01029b3:	89 e5                	mov    %esp,%ebp
c01029b5:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01029b8:	9c                   	pushf  
c01029b9:	58                   	pop    %eax
c01029ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01029bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01029c0:	25 00 02 00 00       	and    $0x200,%eax
c01029c5:	85 c0                	test   %eax,%eax
c01029c7:	74 0c                	je     c01029d5 <__intr_save+0x23>
        intr_disable();
c01029c9:	e8 ba ee ff ff       	call   c0101888 <intr_disable>
        return 1;
c01029ce:	b8 01 00 00 00       	mov    $0x1,%eax
c01029d3:	eb 05                	jmp    c01029da <__intr_save+0x28>
    return 0;
c01029d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01029da:	c9                   	leave  
c01029db:	c3                   	ret    

c01029dc <__intr_restore>:
__intr_restore(bool flag) {
c01029dc:	55                   	push   %ebp
c01029dd:	89 e5                	mov    %esp,%ebp
c01029df:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01029e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01029e6:	74 05                	je     c01029ed <__intr_restore+0x11>
        intr_enable();
c01029e8:	e8 94 ee ff ff       	call   c0101881 <intr_enable>
}
c01029ed:	90                   	nop
c01029ee:	c9                   	leave  
c01029ef:	c3                   	ret    

c01029f0 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c01029f0:	55                   	push   %ebp
c01029f1:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c01029f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01029f6:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c01029f9:	b8 23 00 00 00       	mov    $0x23,%eax
c01029fe:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102a00:	b8 23 00 00 00       	mov    $0x23,%eax
c0102a05:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102a07:	b8 10 00 00 00       	mov    $0x10,%eax
c0102a0c:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102a0e:	b8 10 00 00 00       	mov    $0x10,%eax
c0102a13:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102a15:	b8 10 00 00 00       	mov    $0x10,%eax
c0102a1a:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102a1c:	ea 23 2a 10 c0 08 00 	ljmp   $0x8,$0xc0102a23
}
c0102a23:	90                   	nop
c0102a24:	5d                   	pop    %ebp
c0102a25:	c3                   	ret    

c0102a26 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102a26:	55                   	push   %ebp
c0102a27:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102a29:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a2c:	a3 a4 ae 11 c0       	mov    %eax,0xc011aea4
}
c0102a31:	90                   	nop
c0102a32:	5d                   	pop    %ebp
c0102a33:	c3                   	ret    

c0102a34 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102a34:	55                   	push   %ebp
c0102a35:	89 e5                	mov    %esp,%ebp
c0102a37:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102a3a:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0102a3f:	50                   	push   %eax
c0102a40:	e8 e1 ff ff ff       	call   c0102a26 <load_esp0>
c0102a45:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c0102a48:	66 c7 05 a8 ae 11 c0 	movw   $0x10,0xc011aea8
c0102a4f:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102a51:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0102a58:	68 00 
c0102a5a:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0102a5f:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0102a65:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0102a6a:	c1 e8 10             	shr    $0x10,%eax
c0102a6d:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0102a72:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102a79:	83 e0 f0             	and    $0xfffffff0,%eax
c0102a7c:	83 c8 09             	or     $0x9,%eax
c0102a7f:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102a84:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102a8b:	83 e0 ef             	and    $0xffffffef,%eax
c0102a8e:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102a93:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102a9a:	83 e0 9f             	and    $0xffffff9f,%eax
c0102a9d:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102aa2:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102aa9:	83 c8 80             	or     $0xffffff80,%eax
c0102aac:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102ab1:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102ab8:	83 e0 f0             	and    $0xfffffff0,%eax
c0102abb:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102ac0:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102ac7:	83 e0 ef             	and    $0xffffffef,%eax
c0102aca:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102acf:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102ad6:	83 e0 df             	and    $0xffffffdf,%eax
c0102ad9:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102ade:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102ae5:	83 c8 40             	or     $0x40,%eax
c0102ae8:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102aed:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102af4:	83 e0 7f             	and    $0x7f,%eax
c0102af7:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102afc:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0102b01:	c1 e8 18             	shr    $0x18,%eax
c0102b04:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102b09:	68 30 7a 11 c0       	push   $0xc0117a30
c0102b0e:	e8 dd fe ff ff       	call   c01029f0 <lgdt>
c0102b13:	83 c4 04             	add    $0x4,%esp
c0102b16:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102b1c:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102b20:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0102b23:	90                   	nop
c0102b24:	c9                   	leave  
c0102b25:	c3                   	ret    

c0102b26 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102b26:	55                   	push   %ebp
c0102b27:	89 e5                	mov    %esp,%ebp
c0102b29:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c0102b2c:	c7 05 10 af 11 c0 c8 	movl   $0xc0106bc8,0xc011af10
c0102b33:	6b 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102b36:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c0102b3b:	8b 00                	mov    (%eax),%eax
c0102b3d:	83 ec 08             	sub    $0x8,%esp
c0102b40:	50                   	push   %eax
c0102b41:	68 50 62 10 c0       	push   $0xc0106250
c0102b46:	e8 28 d7 ff ff       	call   c0100273 <cprintf>
c0102b4b:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c0102b4e:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c0102b53:	8b 40 04             	mov    0x4(%eax),%eax
c0102b56:	ff d0                	call   *%eax
}
c0102b58:	90                   	nop
c0102b59:	c9                   	leave  
c0102b5a:	c3                   	ret    

c0102b5b <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102b5b:	55                   	push   %ebp
c0102b5c:	89 e5                	mov    %esp,%ebp
c0102b5e:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c0102b61:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c0102b66:	8b 40 08             	mov    0x8(%eax),%eax
c0102b69:	83 ec 08             	sub    $0x8,%esp
c0102b6c:	ff 75 0c             	pushl  0xc(%ebp)
c0102b6f:	ff 75 08             	pushl  0x8(%ebp)
c0102b72:	ff d0                	call   *%eax
c0102b74:	83 c4 10             	add    $0x10,%esp
}
c0102b77:	90                   	nop
c0102b78:	c9                   	leave  
c0102b79:	c3                   	ret    

c0102b7a <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102b7a:	55                   	push   %ebp
c0102b7b:	89 e5                	mov    %esp,%ebp
c0102b7d:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c0102b80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102b87:	e8 26 fe ff ff       	call   c01029b2 <__intr_save>
c0102b8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102b8f:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c0102b94:	8b 40 0c             	mov    0xc(%eax),%eax
c0102b97:	83 ec 0c             	sub    $0xc,%esp
c0102b9a:	ff 75 08             	pushl  0x8(%ebp)
c0102b9d:	ff d0                	call   *%eax
c0102b9f:	83 c4 10             	add    $0x10,%esp
c0102ba2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102ba5:	83 ec 0c             	sub    $0xc,%esp
c0102ba8:	ff 75 f0             	pushl  -0x10(%ebp)
c0102bab:	e8 2c fe ff ff       	call   c01029dc <__intr_restore>
c0102bb0:	83 c4 10             	add    $0x10,%esp
    return page;
c0102bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102bb6:	c9                   	leave  
c0102bb7:	c3                   	ret    

c0102bb8 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102bb8:	55                   	push   %ebp
c0102bb9:	89 e5                	mov    %esp,%ebp
c0102bbb:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102bbe:	e8 ef fd ff ff       	call   c01029b2 <__intr_save>
c0102bc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102bc6:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c0102bcb:	8b 40 10             	mov    0x10(%eax),%eax
c0102bce:	83 ec 08             	sub    $0x8,%esp
c0102bd1:	ff 75 0c             	pushl  0xc(%ebp)
c0102bd4:	ff 75 08             	pushl  0x8(%ebp)
c0102bd7:	ff d0                	call   *%eax
c0102bd9:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0102bdc:	83 ec 0c             	sub    $0xc,%esp
c0102bdf:	ff 75 f4             	pushl  -0xc(%ebp)
c0102be2:	e8 f5 fd ff ff       	call   c01029dc <__intr_restore>
c0102be7:	83 c4 10             	add    $0x10,%esp
}
c0102bea:	90                   	nop
c0102beb:	c9                   	leave  
c0102bec:	c3                   	ret    

c0102bed <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102bed:	55                   	push   %ebp
c0102bee:	89 e5                	mov    %esp,%ebp
c0102bf0:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102bf3:	e8 ba fd ff ff       	call   c01029b2 <__intr_save>
c0102bf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102bfb:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c0102c00:	8b 40 14             	mov    0x14(%eax),%eax
c0102c03:	ff d0                	call   *%eax
c0102c05:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102c08:	83 ec 0c             	sub    $0xc,%esp
c0102c0b:	ff 75 f4             	pushl  -0xc(%ebp)
c0102c0e:	e8 c9 fd ff ff       	call   c01029dc <__intr_restore>
c0102c13:	83 c4 10             	add    $0x10,%esp
    return ret;
c0102c16:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102c19:	c9                   	leave  
c0102c1a:	c3                   	ret    

c0102c1b <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102c1b:	55                   	push   %ebp
c0102c1c:	89 e5                	mov    %esp,%ebp
c0102c1e:	57                   	push   %edi
c0102c1f:	56                   	push   %esi
c0102c20:	53                   	push   %ebx
c0102c21:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102c24:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102c2b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102c32:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102c39:	83 ec 0c             	sub    $0xc,%esp
c0102c3c:	68 67 62 10 c0       	push   $0xc0106267
c0102c41:	e8 2d d6 ff ff       	call   c0100273 <cprintf>
c0102c46:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102c49:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102c50:	e9 fc 00 00 00       	jmp    c0102d51 <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102c55:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102c58:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c5b:	89 d0                	mov    %edx,%eax
c0102c5d:	c1 e0 02             	shl    $0x2,%eax
c0102c60:	01 d0                	add    %edx,%eax
c0102c62:	c1 e0 02             	shl    $0x2,%eax
c0102c65:	01 c8                	add    %ecx,%eax
c0102c67:	8b 50 08             	mov    0x8(%eax),%edx
c0102c6a:	8b 40 04             	mov    0x4(%eax),%eax
c0102c6d:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0102c70:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102c73:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102c76:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c79:	89 d0                	mov    %edx,%eax
c0102c7b:	c1 e0 02             	shl    $0x2,%eax
c0102c7e:	01 d0                	add    %edx,%eax
c0102c80:	c1 e0 02             	shl    $0x2,%eax
c0102c83:	01 c8                	add    %ecx,%eax
c0102c85:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102c88:	8b 58 10             	mov    0x10(%eax),%ebx
c0102c8b:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102c8e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102c91:	01 c8                	add    %ecx,%eax
c0102c93:	11 da                	adc    %ebx,%edx
c0102c95:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102c98:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102c9b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102c9e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ca1:	89 d0                	mov    %edx,%eax
c0102ca3:	c1 e0 02             	shl    $0x2,%eax
c0102ca6:	01 d0                	add    %edx,%eax
c0102ca8:	c1 e0 02             	shl    $0x2,%eax
c0102cab:	01 c8                	add    %ecx,%eax
c0102cad:	83 c0 14             	add    $0x14,%eax
c0102cb0:	8b 00                	mov    (%eax),%eax
c0102cb2:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102cb5:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102cb8:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102cbb:	83 c0 ff             	add    $0xffffffff,%eax
c0102cbe:	83 d2 ff             	adc    $0xffffffff,%edx
c0102cc1:	89 c1                	mov    %eax,%ecx
c0102cc3:	89 d3                	mov    %edx,%ebx
c0102cc5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102cc8:	89 55 80             	mov    %edx,-0x80(%ebp)
c0102ccb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102cce:	89 d0                	mov    %edx,%eax
c0102cd0:	c1 e0 02             	shl    $0x2,%eax
c0102cd3:	01 d0                	add    %edx,%eax
c0102cd5:	c1 e0 02             	shl    $0x2,%eax
c0102cd8:	03 45 80             	add    -0x80(%ebp),%eax
c0102cdb:	8b 50 10             	mov    0x10(%eax),%edx
c0102cde:	8b 40 0c             	mov    0xc(%eax),%eax
c0102ce1:	ff 75 84             	pushl  -0x7c(%ebp)
c0102ce4:	53                   	push   %ebx
c0102ce5:	51                   	push   %ecx
c0102ce6:	ff 75 a4             	pushl  -0x5c(%ebp)
c0102ce9:	ff 75 a0             	pushl  -0x60(%ebp)
c0102cec:	52                   	push   %edx
c0102ced:	50                   	push   %eax
c0102cee:	68 74 62 10 c0       	push   $0xc0106274
c0102cf3:	e8 7b d5 ff ff       	call   c0100273 <cprintf>
c0102cf8:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102cfb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102cfe:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d01:	89 d0                	mov    %edx,%eax
c0102d03:	c1 e0 02             	shl    $0x2,%eax
c0102d06:	01 d0                	add    %edx,%eax
c0102d08:	c1 e0 02             	shl    $0x2,%eax
c0102d0b:	01 c8                	add    %ecx,%eax
c0102d0d:	83 c0 14             	add    $0x14,%eax
c0102d10:	8b 00                	mov    (%eax),%eax
c0102d12:	83 f8 01             	cmp    $0x1,%eax
c0102d15:	75 36                	jne    c0102d4d <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
c0102d17:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102d1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102d1d:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c0102d20:	77 2b                	ja     c0102d4d <page_init+0x132>
c0102d22:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c0102d25:	72 05                	jb     c0102d2c <page_init+0x111>
c0102d27:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0102d2a:	73 21                	jae    c0102d4d <page_init+0x132>
c0102d2c:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0102d30:	77 1b                	ja     c0102d4d <page_init+0x132>
c0102d32:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0102d36:	72 09                	jb     c0102d41 <page_init+0x126>
c0102d38:	81 7d a0 ff ff ff 37 	cmpl   $0x37ffffff,-0x60(%ebp)
c0102d3f:	77 0c                	ja     c0102d4d <page_init+0x132>
                maxpa = end;
c0102d41:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102d44:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102d47:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102d4a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0102d4d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102d51:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d54:	8b 00                	mov    (%eax),%eax
c0102d56:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0102d59:	0f 8c f6 fe ff ff    	jl     c0102c55 <page_init+0x3a>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102d5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102d63:	72 1d                	jb     c0102d82 <page_init+0x167>
c0102d65:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102d69:	77 09                	ja     c0102d74 <page_init+0x159>
c0102d6b:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0102d72:	76 0e                	jbe    c0102d82 <page_init+0x167>
        maxpa = KMEMSIZE;
c0102d74:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102d7b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0102d82:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102d85:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102d88:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102d8c:	c1 ea 0c             	shr    $0xc,%edx
c0102d8f:	89 c1                	mov    %eax,%ecx
c0102d91:	89 d3                	mov    %edx,%ebx
c0102d93:	89 c8                	mov    %ecx,%eax
c0102d95:	a3 80 ae 11 c0       	mov    %eax,0xc011ae80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102d9a:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0102da1:	b8 28 af 11 c0       	mov    $0xc011af28,%eax
c0102da6:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102da9:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102dac:	01 d0                	add    %edx,%eax
c0102dae:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0102db1:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102db4:	ba 00 00 00 00       	mov    $0x0,%edx
c0102db9:	f7 75 c0             	divl   -0x40(%ebp)
c0102dbc:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102dbf:	29 d0                	sub    %edx,%eax
c0102dc1:	a3 18 af 11 c0       	mov    %eax,0xc011af18

    for (i = 0; i < npage; i ++) {
c0102dc6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102dcd:	eb 2f                	jmp    c0102dfe <page_init+0x1e3>
        SetPageReserved(pages + i);
c0102dcf:	8b 0d 18 af 11 c0    	mov    0xc011af18,%ecx
c0102dd5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102dd8:	89 d0                	mov    %edx,%eax
c0102dda:	c1 e0 02             	shl    $0x2,%eax
c0102ddd:	01 d0                	add    %edx,%eax
c0102ddf:	c1 e0 02             	shl    $0x2,%eax
c0102de2:	01 c8                	add    %ecx,%eax
c0102de4:	83 c0 04             	add    $0x4,%eax
c0102de7:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0102dee:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102df1:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102df4:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102df7:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
c0102dfa:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102dfe:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e01:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0102e06:	39 c2                	cmp    %eax,%edx
c0102e08:	72 c5                	jb     c0102dcf <page_init+0x1b4>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0102e0a:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0102e10:	89 d0                	mov    %edx,%eax
c0102e12:	c1 e0 02             	shl    $0x2,%eax
c0102e15:	01 d0                	add    %edx,%eax
c0102e17:	c1 e0 02             	shl    $0x2,%eax
c0102e1a:	89 c2                	mov    %eax,%edx
c0102e1c:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0102e21:	01 d0                	add    %edx,%eax
c0102e23:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102e26:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0102e2d:	77 17                	ja     c0102e46 <page_init+0x22b>
c0102e2f:	ff 75 b8             	pushl  -0x48(%ebp)
c0102e32:	68 a4 62 10 c0       	push   $0xc01062a4
c0102e37:	68 dc 00 00 00       	push   $0xdc
c0102e3c:	68 c8 62 10 c0       	push   $0xc01062c8
c0102e41:	e8 93 d5 ff ff       	call   c01003d9 <__panic>
c0102e46:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102e49:	05 00 00 00 40       	add    $0x40000000,%eax
c0102e4e:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0102e51:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102e58:	e9 71 01 00 00       	jmp    c0102fce <page_init+0x3b3>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102e5d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e60:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e63:	89 d0                	mov    %edx,%eax
c0102e65:	c1 e0 02             	shl    $0x2,%eax
c0102e68:	01 d0                	add    %edx,%eax
c0102e6a:	c1 e0 02             	shl    $0x2,%eax
c0102e6d:	01 c8                	add    %ecx,%eax
c0102e6f:	8b 50 08             	mov    0x8(%eax),%edx
c0102e72:	8b 40 04             	mov    0x4(%eax),%eax
c0102e75:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102e78:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102e7b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e7e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e81:	89 d0                	mov    %edx,%eax
c0102e83:	c1 e0 02             	shl    $0x2,%eax
c0102e86:	01 d0                	add    %edx,%eax
c0102e88:	c1 e0 02             	shl    $0x2,%eax
c0102e8b:	01 c8                	add    %ecx,%eax
c0102e8d:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102e90:	8b 58 10             	mov    0x10(%eax),%ebx
c0102e93:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102e96:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102e99:	01 c8                	add    %ecx,%eax
c0102e9b:	11 da                	adc    %ebx,%edx
c0102e9d:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102ea0:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0102ea3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102ea6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ea9:	89 d0                	mov    %edx,%eax
c0102eab:	c1 e0 02             	shl    $0x2,%eax
c0102eae:	01 d0                	add    %edx,%eax
c0102eb0:	c1 e0 02             	shl    $0x2,%eax
c0102eb3:	01 c8                	add    %ecx,%eax
c0102eb5:	83 c0 14             	add    $0x14,%eax
c0102eb8:	8b 00                	mov    (%eax),%eax
c0102eba:	83 f8 01             	cmp    $0x1,%eax
c0102ebd:	0f 85 07 01 00 00    	jne    c0102fca <page_init+0x3af>
            if (begin < freemem) {
c0102ec3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102ec6:	ba 00 00 00 00       	mov    $0x0,%edx
c0102ecb:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0102ece:	77 17                	ja     c0102ee7 <page_init+0x2cc>
c0102ed0:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0102ed3:	72 05                	jb     c0102eda <page_init+0x2bf>
c0102ed5:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0102ed8:	73 0d                	jae    c0102ee7 <page_init+0x2cc>
                begin = freemem;
c0102eda:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102edd:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102ee0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0102ee7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102eeb:	72 1d                	jb     c0102f0a <page_init+0x2ef>
c0102eed:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102ef1:	77 09                	ja     c0102efc <page_init+0x2e1>
c0102ef3:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0102efa:	76 0e                	jbe    c0102f0a <page_init+0x2ef>
                end = KMEMSIZE;
c0102efc:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0102f03:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0102f0a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102f0d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102f10:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f13:	0f 87 b1 00 00 00    	ja     c0102fca <page_init+0x3af>
c0102f19:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f1c:	72 09                	jb     c0102f27 <page_init+0x30c>
c0102f1e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0102f21:	0f 83 a3 00 00 00    	jae    c0102fca <page_init+0x3af>
                begin = ROUNDUP(begin, PGSIZE);
c0102f27:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c0102f2e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102f31:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102f34:	01 d0                	add    %edx,%eax
c0102f36:	83 e8 01             	sub    $0x1,%eax
c0102f39:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0102f3c:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102f3f:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f44:	f7 75 b0             	divl   -0x50(%ebp)
c0102f47:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102f4a:	29 d0                	sub    %edx,%eax
c0102f4c:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f51:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102f54:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0102f57:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102f5a:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0102f5d:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102f60:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f65:	89 c3                	mov    %eax,%ebx
c0102f67:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0102f6d:	89 de                	mov    %ebx,%esi
c0102f6f:	89 d0                	mov    %edx,%eax
c0102f71:	83 e0 00             	and    $0x0,%eax
c0102f74:	89 c7                	mov    %eax,%edi
c0102f76:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0102f79:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0102f7c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102f7f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102f82:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f85:	77 43                	ja     c0102fca <page_init+0x3af>
c0102f87:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f8a:	72 05                	jb     c0102f91 <page_init+0x376>
c0102f8c:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0102f8f:	73 39                	jae    c0102fca <page_init+0x3af>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0102f91:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102f94:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102f97:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0102f9a:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0102f9d:	89 c1                	mov    %eax,%ecx
c0102f9f:	89 d3                	mov    %edx,%ebx
c0102fa1:	89 c8                	mov    %ecx,%eax
c0102fa3:	89 da                	mov    %ebx,%edx
c0102fa5:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102fa9:	c1 ea 0c             	shr    $0xc,%edx
c0102fac:	89 c3                	mov    %eax,%ebx
c0102fae:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102fb1:	83 ec 0c             	sub    $0xc,%esp
c0102fb4:	50                   	push   %eax
c0102fb5:	e8 d0 f8 ff ff       	call   c010288a <pa2page>
c0102fba:	83 c4 10             	add    $0x10,%esp
c0102fbd:	83 ec 08             	sub    $0x8,%esp
c0102fc0:	53                   	push   %ebx
c0102fc1:	50                   	push   %eax
c0102fc2:	e8 94 fb ff ff       	call   c0102b5b <init_memmap>
c0102fc7:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < memmap->nr_map; i ++) {
c0102fca:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102fce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102fd1:	8b 00                	mov    (%eax),%eax
c0102fd3:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0102fd6:	0f 8c 81 fe ff ff    	jl     c0102e5d <page_init+0x242>
                }
            }
        }
    }
}
c0102fdc:	90                   	nop
c0102fdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0102fe0:	5b                   	pop    %ebx
c0102fe1:	5e                   	pop    %esi
c0102fe2:	5f                   	pop    %edi
c0102fe3:	5d                   	pop    %ebp
c0102fe4:	c3                   	ret    

c0102fe5 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0102fe5:	55                   	push   %ebp
c0102fe6:	89 e5                	mov    %esp,%ebp
c0102fe8:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0102feb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102fee:	33 45 14             	xor    0x14(%ebp),%eax
c0102ff1:	25 ff 0f 00 00       	and    $0xfff,%eax
c0102ff6:	85 c0                	test   %eax,%eax
c0102ff8:	74 19                	je     c0103013 <boot_map_segment+0x2e>
c0102ffa:	68 d6 62 10 c0       	push   $0xc01062d6
c0102fff:	68 ed 62 10 c0       	push   $0xc01062ed
c0103004:	68 fa 00 00 00       	push   $0xfa
c0103009:	68 c8 62 10 c0       	push   $0xc01062c8
c010300e:	e8 c6 d3 ff ff       	call   c01003d9 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0103013:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c010301a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010301d:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103022:	89 c2                	mov    %eax,%edx
c0103024:	8b 45 10             	mov    0x10(%ebp),%eax
c0103027:	01 c2                	add    %eax,%edx
c0103029:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010302c:	01 d0                	add    %edx,%eax
c010302e:	83 e8 01             	sub    $0x1,%eax
c0103031:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103034:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103037:	ba 00 00 00 00       	mov    $0x0,%edx
c010303c:	f7 75 f0             	divl   -0x10(%ebp)
c010303f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103042:	29 d0                	sub    %edx,%eax
c0103044:	c1 e8 0c             	shr    $0xc,%eax
c0103047:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c010304a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010304d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103050:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103053:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103058:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c010305b:	8b 45 14             	mov    0x14(%ebp),%eax
c010305e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103061:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103064:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103069:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010306c:	eb 57                	jmp    c01030c5 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010306e:	83 ec 04             	sub    $0x4,%esp
c0103071:	6a 01                	push   $0x1
c0103073:	ff 75 0c             	pushl  0xc(%ebp)
c0103076:	ff 75 08             	pushl  0x8(%ebp)
c0103079:	e8 53 01 00 00       	call   c01031d1 <get_pte>
c010307e:	83 c4 10             	add    $0x10,%esp
c0103081:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0103084:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103088:	75 19                	jne    c01030a3 <boot_map_segment+0xbe>
c010308a:	68 02 63 10 c0       	push   $0xc0106302
c010308f:	68 ed 62 10 c0       	push   $0xc01062ed
c0103094:	68 00 01 00 00       	push   $0x100
c0103099:	68 c8 62 10 c0       	push   $0xc01062c8
c010309e:	e8 36 d3 ff ff       	call   c01003d9 <__panic>
        *ptep = pa | PTE_P | perm;
c01030a3:	8b 45 14             	mov    0x14(%ebp),%eax
c01030a6:	0b 45 18             	or     0x18(%ebp),%eax
c01030a9:	83 c8 01             	or     $0x1,%eax
c01030ac:	89 c2                	mov    %eax,%edx
c01030ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030b1:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01030b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01030b7:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01030be:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01030c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01030c9:	75 a3                	jne    c010306e <boot_map_segment+0x89>
    }
}
c01030cb:	90                   	nop
c01030cc:	c9                   	leave  
c01030cd:	c3                   	ret    

c01030ce <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01030ce:	55                   	push   %ebp
c01030cf:	89 e5                	mov    %esp,%ebp
c01030d1:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c01030d4:	83 ec 0c             	sub    $0xc,%esp
c01030d7:	6a 01                	push   $0x1
c01030d9:	e8 9c fa ff ff       	call   c0102b7a <alloc_pages>
c01030de:	83 c4 10             	add    $0x10,%esp
c01030e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01030e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01030e8:	75 17                	jne    c0103101 <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
c01030ea:	83 ec 04             	sub    $0x4,%esp
c01030ed:	68 0f 63 10 c0       	push   $0xc010630f
c01030f2:	68 0c 01 00 00       	push   $0x10c
c01030f7:	68 c8 62 10 c0       	push   $0xc01062c8
c01030fc:	e8 d8 d2 ff ff       	call   c01003d9 <__panic>
    }
    return page2kva(p);
c0103101:	83 ec 0c             	sub    $0xc,%esp
c0103104:	ff 75 f4             	pushl  -0xc(%ebp)
c0103107:	e8 c5 f7 ff ff       	call   c01028d1 <page2kva>
c010310c:	83 c4 10             	add    $0x10,%esp
}
c010310f:	c9                   	leave  
c0103110:	c3                   	ret    

c0103111 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0103111:	55                   	push   %ebp
c0103112:	89 e5                	mov    %esp,%ebp
c0103114:	83 ec 18             	sub    $0x18,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0103117:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010311c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010311f:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103126:	77 17                	ja     c010313f <pmm_init+0x2e>
c0103128:	ff 75 f4             	pushl  -0xc(%ebp)
c010312b:	68 a4 62 10 c0       	push   $0xc01062a4
c0103130:	68 16 01 00 00       	push   $0x116
c0103135:	68 c8 62 10 c0       	push   $0xc01062c8
c010313a:	e8 9a d2 ff ff       	call   c01003d9 <__panic>
c010313f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103142:	05 00 00 00 40       	add    $0x40000000,%eax
c0103147:	a3 14 af 11 c0       	mov    %eax,0xc011af14
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c010314c:	e8 d5 f9 ff ff       	call   c0102b26 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0103151:	e8 c5 fa ff ff       	call   c0102c1b <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0103156:	e8 90 03 00 00       	call   c01034eb <check_alloc_page>

    check_pgdir();
c010315b:	e8 ae 03 00 00       	call   c010350e <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0103160:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103165:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103168:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010316f:	77 17                	ja     c0103188 <pmm_init+0x77>
c0103171:	ff 75 f0             	pushl  -0x10(%ebp)
c0103174:	68 a4 62 10 c0       	push   $0xc01062a4
c0103179:	68 2c 01 00 00       	push   $0x12c
c010317e:	68 c8 62 10 c0       	push   $0xc01062c8
c0103183:	e8 51 d2 ff ff       	call   c01003d9 <__panic>
c0103188:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010318b:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c0103191:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103196:	05 ac 0f 00 00       	add    $0xfac,%eax
c010319b:	83 ca 03             	or     $0x3,%edx
c010319e:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01031a0:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01031a5:	83 ec 0c             	sub    $0xc,%esp
c01031a8:	6a 02                	push   $0x2
c01031aa:	6a 00                	push   $0x0
c01031ac:	68 00 00 00 38       	push   $0x38000000
c01031b1:	68 00 00 00 c0       	push   $0xc0000000
c01031b6:	50                   	push   %eax
c01031b7:	e8 29 fe ff ff       	call   c0102fe5 <boot_map_segment>
c01031bc:	83 c4 20             	add    $0x20,%esp

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01031bf:	e8 70 f8 ff ff       	call   c0102a34 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01031c4:	e8 ab 08 00 00       	call   c0103a74 <check_boot_pgdir>

    print_pgdir();
c01031c9:	e8 a1 0c 00 00       	call   c0103e6f <print_pgdir>

}
c01031ce:	90                   	nop
c01031cf:	c9                   	leave  
c01031d0:	c3                   	ret    

c01031d1 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01031d1:	55                   	push   %ebp
c01031d2:	89 e5                	mov    %esp,%ebp
c01031d4:	83 ec 28             	sub    $0x28,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c01031d7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01031da:	c1 e8 16             	shr    $0x16,%eax
c01031dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01031e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01031e7:	01 d0                	add    %edx,%eax
c01031e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c01031ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031ef:	8b 00                	mov    (%eax),%eax
c01031f1:	83 e0 01             	and    $0x1,%eax
c01031f4:	85 c0                	test   %eax,%eax
c01031f6:	0f 85 9f 00 00 00    	jne    c010329b <get_pte+0xca>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c01031fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0103200:	74 16                	je     c0103218 <get_pte+0x47>
c0103202:	83 ec 0c             	sub    $0xc,%esp
c0103205:	6a 01                	push   $0x1
c0103207:	e8 6e f9 ff ff       	call   c0102b7a <alloc_pages>
c010320c:	83 c4 10             	add    $0x10,%esp
c010320f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103212:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103216:	75 0a                	jne    c0103222 <get_pte+0x51>
            return NULL;
c0103218:	b8 00 00 00 00       	mov    $0x0,%eax
c010321d:	e9 ca 00 00 00       	jmp    c01032ec <get_pte+0x11b>
        }
        set_page_ref(page, 1);
c0103222:	83 ec 08             	sub    $0x8,%esp
c0103225:	6a 01                	push   $0x1
c0103227:	ff 75 f0             	pushl  -0x10(%ebp)
c010322a:	e8 47 f7 ff ff       	call   c0102976 <set_page_ref>
c010322f:	83 c4 10             	add    $0x10,%esp
        uintptr_t pa = page2pa(page);
c0103232:	83 ec 0c             	sub    $0xc,%esp
c0103235:	ff 75 f0             	pushl  -0x10(%ebp)
c0103238:	e8 3a f6 ff ff       	call   c0102877 <page2pa>
c010323d:	83 c4 10             	add    $0x10,%esp
c0103240:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c0103243:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103246:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103249:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010324c:	c1 e8 0c             	shr    $0xc,%eax
c010324f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103252:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103257:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010325a:	72 17                	jb     c0103273 <get_pte+0xa2>
c010325c:	ff 75 e8             	pushl  -0x18(%ebp)
c010325f:	68 00 62 10 c0       	push   $0xc0106200
c0103264:	68 72 01 00 00       	push   $0x172
c0103269:	68 c8 62 10 c0       	push   $0xc01062c8
c010326e:	e8 66 d1 ff ff       	call   c01003d9 <__panic>
c0103273:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103276:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010327b:	83 ec 04             	sub    $0x4,%esp
c010327e:	68 00 10 00 00       	push   $0x1000
c0103283:	6a 00                	push   $0x0
c0103285:	50                   	push   %eax
c0103286:	e8 74 20 00 00       	call   c01052ff <memset>
c010328b:	83 c4 10             	add    $0x10,%esp
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c010328e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103291:	83 c8 07             	or     $0x7,%eax
c0103294:	89 c2                	mov    %eax,%edx
c0103296:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103299:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c010329b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010329e:	8b 00                	mov    (%eax),%eax
c01032a0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01032a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01032a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01032ab:	c1 e8 0c             	shr    $0xc,%eax
c01032ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01032b1:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c01032b6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01032b9:	72 17                	jb     c01032d2 <get_pte+0x101>
c01032bb:	ff 75 e0             	pushl  -0x20(%ebp)
c01032be:	68 00 62 10 c0       	push   $0xc0106200
c01032c3:	68 75 01 00 00       	push   $0x175
c01032c8:	68 c8 62 10 c0       	push   $0xc01062c8
c01032cd:	e8 07 d1 ff ff       	call   c01003d9 <__panic>
c01032d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01032d5:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01032da:	89 c2                	mov    %eax,%edx
c01032dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01032df:	c1 e8 0c             	shr    $0xc,%eax
c01032e2:	25 ff 03 00 00       	and    $0x3ff,%eax
c01032e7:	c1 e0 02             	shl    $0x2,%eax
c01032ea:	01 d0                	add    %edx,%eax
}
c01032ec:	c9                   	leave  
c01032ed:	c3                   	ret    

c01032ee <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01032ee:	55                   	push   %ebp
c01032ef:	89 e5                	mov    %esp,%ebp
c01032f1:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01032f4:	83 ec 04             	sub    $0x4,%esp
c01032f7:	6a 00                	push   $0x0
c01032f9:	ff 75 0c             	pushl  0xc(%ebp)
c01032fc:	ff 75 08             	pushl  0x8(%ebp)
c01032ff:	e8 cd fe ff ff       	call   c01031d1 <get_pte>
c0103304:	83 c4 10             	add    $0x10,%esp
c0103307:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010330a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010330e:	74 08                	je     c0103318 <get_page+0x2a>
        *ptep_store = ptep;
c0103310:	8b 45 10             	mov    0x10(%ebp),%eax
c0103313:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103316:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0103318:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010331c:	74 1f                	je     c010333d <get_page+0x4f>
c010331e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103321:	8b 00                	mov    (%eax),%eax
c0103323:	83 e0 01             	and    $0x1,%eax
c0103326:	85 c0                	test   %eax,%eax
c0103328:	74 13                	je     c010333d <get_page+0x4f>
        return pte2page(*ptep);
c010332a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010332d:	8b 00                	mov    (%eax),%eax
c010332f:	83 ec 0c             	sub    $0xc,%esp
c0103332:	50                   	push   %eax
c0103333:	e8 de f5 ff ff       	call   c0102916 <pte2page>
c0103338:	83 c4 10             	add    $0x10,%esp
c010333b:	eb 05                	jmp    c0103342 <get_page+0x54>
    }
    return NULL;
c010333d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103342:	c9                   	leave  
c0103343:	c3                   	ret    

c0103344 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0103344:	55                   	push   %ebp
c0103345:	89 e5                	mov    %esp,%ebp
c0103347:	83 ec 18             	sub    $0x18,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c010334a:	8b 45 10             	mov    0x10(%ebp),%eax
c010334d:	8b 00                	mov    (%eax),%eax
c010334f:	83 e0 01             	and    $0x1,%eax
c0103352:	85 c0                	test   %eax,%eax
c0103354:	74 50                	je     c01033a6 <page_remove_pte+0x62>
        struct Page *page = pte2page(*ptep);
c0103356:	8b 45 10             	mov    0x10(%ebp),%eax
c0103359:	8b 00                	mov    (%eax),%eax
c010335b:	83 ec 0c             	sub    $0xc,%esp
c010335e:	50                   	push   %eax
c010335f:	e8 b2 f5 ff ff       	call   c0102916 <pte2page>
c0103364:	83 c4 10             	add    $0x10,%esp
c0103367:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c010336a:	83 ec 0c             	sub    $0xc,%esp
c010336d:	ff 75 f4             	pushl  -0xc(%ebp)
c0103370:	e8 26 f6 ff ff       	call   c010299b <page_ref_dec>
c0103375:	83 c4 10             	add    $0x10,%esp
c0103378:	85 c0                	test   %eax,%eax
c010337a:	75 10                	jne    c010338c <page_remove_pte+0x48>
            free_page(page);
c010337c:	83 ec 08             	sub    $0x8,%esp
c010337f:	6a 01                	push   $0x1
c0103381:	ff 75 f4             	pushl  -0xc(%ebp)
c0103384:	e8 2f f8 ff ff       	call   c0102bb8 <free_pages>
c0103389:	83 c4 10             	add    $0x10,%esp
        }
        *ptep = 0;
c010338c:	8b 45 10             	mov    0x10(%ebp),%eax
c010338f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c0103395:	83 ec 08             	sub    $0x8,%esp
c0103398:	ff 75 0c             	pushl  0xc(%ebp)
c010339b:	ff 75 08             	pushl  0x8(%ebp)
c010339e:	e8 f8 00 00 00       	call   c010349b <tlb_invalidate>
c01033a3:	83 c4 10             	add    $0x10,%esp
    }
}
c01033a6:	90                   	nop
c01033a7:	c9                   	leave  
c01033a8:	c3                   	ret    

c01033a9 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01033a9:	55                   	push   %ebp
c01033aa:	89 e5                	mov    %esp,%ebp
c01033ac:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01033af:	83 ec 04             	sub    $0x4,%esp
c01033b2:	6a 00                	push   $0x0
c01033b4:	ff 75 0c             	pushl  0xc(%ebp)
c01033b7:	ff 75 08             	pushl  0x8(%ebp)
c01033ba:	e8 12 fe ff ff       	call   c01031d1 <get_pte>
c01033bf:	83 c4 10             	add    $0x10,%esp
c01033c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01033c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01033c9:	74 14                	je     c01033df <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
c01033cb:	83 ec 04             	sub    $0x4,%esp
c01033ce:	ff 75 f4             	pushl  -0xc(%ebp)
c01033d1:	ff 75 0c             	pushl  0xc(%ebp)
c01033d4:	ff 75 08             	pushl  0x8(%ebp)
c01033d7:	e8 68 ff ff ff       	call   c0103344 <page_remove_pte>
c01033dc:	83 c4 10             	add    $0x10,%esp
    }
}
c01033df:	90                   	nop
c01033e0:	c9                   	leave  
c01033e1:	c3                   	ret    

c01033e2 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01033e2:	55                   	push   %ebp
c01033e3:	89 e5                	mov    %esp,%ebp
c01033e5:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01033e8:	83 ec 04             	sub    $0x4,%esp
c01033eb:	6a 01                	push   $0x1
c01033ed:	ff 75 10             	pushl  0x10(%ebp)
c01033f0:	ff 75 08             	pushl  0x8(%ebp)
c01033f3:	e8 d9 fd ff ff       	call   c01031d1 <get_pte>
c01033f8:	83 c4 10             	add    $0x10,%esp
c01033fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01033fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103402:	75 0a                	jne    c010340e <page_insert+0x2c>
        return -E_NO_MEM;
c0103404:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0103409:	e9 8b 00 00 00       	jmp    c0103499 <page_insert+0xb7>
    }
    page_ref_inc(page);
c010340e:	83 ec 0c             	sub    $0xc,%esp
c0103411:	ff 75 0c             	pushl  0xc(%ebp)
c0103414:	e8 6b f5 ff ff       	call   c0102984 <page_ref_inc>
c0103419:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
c010341c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010341f:	8b 00                	mov    (%eax),%eax
c0103421:	83 e0 01             	and    $0x1,%eax
c0103424:	85 c0                	test   %eax,%eax
c0103426:	74 40                	je     c0103468 <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
c0103428:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010342b:	8b 00                	mov    (%eax),%eax
c010342d:	83 ec 0c             	sub    $0xc,%esp
c0103430:	50                   	push   %eax
c0103431:	e8 e0 f4 ff ff       	call   c0102916 <pte2page>
c0103436:	83 c4 10             	add    $0x10,%esp
c0103439:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010343c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010343f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103442:	75 10                	jne    c0103454 <page_insert+0x72>
            page_ref_dec(page);
c0103444:	83 ec 0c             	sub    $0xc,%esp
c0103447:	ff 75 0c             	pushl  0xc(%ebp)
c010344a:	e8 4c f5 ff ff       	call   c010299b <page_ref_dec>
c010344f:	83 c4 10             	add    $0x10,%esp
c0103452:	eb 14                	jmp    c0103468 <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0103454:	83 ec 04             	sub    $0x4,%esp
c0103457:	ff 75 f4             	pushl  -0xc(%ebp)
c010345a:	ff 75 10             	pushl  0x10(%ebp)
c010345d:	ff 75 08             	pushl  0x8(%ebp)
c0103460:	e8 df fe ff ff       	call   c0103344 <page_remove_pte>
c0103465:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0103468:	83 ec 0c             	sub    $0xc,%esp
c010346b:	ff 75 0c             	pushl  0xc(%ebp)
c010346e:	e8 04 f4 ff ff       	call   c0102877 <page2pa>
c0103473:	83 c4 10             	add    $0x10,%esp
c0103476:	0b 45 14             	or     0x14(%ebp),%eax
c0103479:	83 c8 01             	or     $0x1,%eax
c010347c:	89 c2                	mov    %eax,%edx
c010347e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103481:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0103483:	83 ec 08             	sub    $0x8,%esp
c0103486:	ff 75 10             	pushl  0x10(%ebp)
c0103489:	ff 75 08             	pushl  0x8(%ebp)
c010348c:	e8 0a 00 00 00       	call   c010349b <tlb_invalidate>
c0103491:	83 c4 10             	add    $0x10,%esp
    return 0;
c0103494:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103499:	c9                   	leave  
c010349a:	c3                   	ret    

c010349b <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010349b:	55                   	push   %ebp
c010349c:	89 e5                	mov    %esp,%ebp
c010349e:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01034a1:	0f 20 d8             	mov    %cr3,%eax
c01034a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01034a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c01034aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01034ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01034b0:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01034b7:	77 17                	ja     c01034d0 <tlb_invalidate+0x35>
c01034b9:	ff 75 f4             	pushl  -0xc(%ebp)
c01034bc:	68 a4 62 10 c0       	push   $0xc01062a4
c01034c1:	68 d7 01 00 00       	push   $0x1d7
c01034c6:	68 c8 62 10 c0       	push   $0xc01062c8
c01034cb:	e8 09 cf ff ff       	call   c01003d9 <__panic>
c01034d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034d3:	05 00 00 00 40       	add    $0x40000000,%eax
c01034d8:	39 d0                	cmp    %edx,%eax
c01034da:	75 0c                	jne    c01034e8 <tlb_invalidate+0x4d>
        invlpg((void *)la);
c01034dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034df:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01034e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034e5:	0f 01 38             	invlpg (%eax)
    }
}
c01034e8:	90                   	nop
c01034e9:	c9                   	leave  
c01034ea:	c3                   	ret    

c01034eb <check_alloc_page>:

static void
check_alloc_page(void) {
c01034eb:	55                   	push   %ebp
c01034ec:	89 e5                	mov    %esp,%ebp
c01034ee:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c01034f1:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c01034f6:	8b 40 18             	mov    0x18(%eax),%eax
c01034f9:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01034fb:	83 ec 0c             	sub    $0xc,%esp
c01034fe:	68 28 63 10 c0       	push   $0xc0106328
c0103503:	e8 6b cd ff ff       	call   c0100273 <cprintf>
c0103508:	83 c4 10             	add    $0x10,%esp
}
c010350b:	90                   	nop
c010350c:	c9                   	leave  
c010350d:	c3                   	ret    

c010350e <check_pgdir>:

static void
check_pgdir(void) {
c010350e:	55                   	push   %ebp
c010350f:	89 e5                	mov    %esp,%ebp
c0103511:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0103514:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103519:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010351e:	76 19                	jbe    c0103539 <check_pgdir+0x2b>
c0103520:	68 47 63 10 c0       	push   $0xc0106347
c0103525:	68 ed 62 10 c0       	push   $0xc01062ed
c010352a:	68 e4 01 00 00       	push   $0x1e4
c010352f:	68 c8 62 10 c0       	push   $0xc01062c8
c0103534:	e8 a0 ce ff ff       	call   c01003d9 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0103539:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010353e:	85 c0                	test   %eax,%eax
c0103540:	74 0e                	je     c0103550 <check_pgdir+0x42>
c0103542:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103547:	25 ff 0f 00 00       	and    $0xfff,%eax
c010354c:	85 c0                	test   %eax,%eax
c010354e:	74 19                	je     c0103569 <check_pgdir+0x5b>
c0103550:	68 64 63 10 c0       	push   $0xc0106364
c0103555:	68 ed 62 10 c0       	push   $0xc01062ed
c010355a:	68 e5 01 00 00       	push   $0x1e5
c010355f:	68 c8 62 10 c0       	push   $0xc01062c8
c0103564:	e8 70 ce ff ff       	call   c01003d9 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0103569:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010356e:	83 ec 04             	sub    $0x4,%esp
c0103571:	6a 00                	push   $0x0
c0103573:	6a 00                	push   $0x0
c0103575:	50                   	push   %eax
c0103576:	e8 73 fd ff ff       	call   c01032ee <get_page>
c010357b:	83 c4 10             	add    $0x10,%esp
c010357e:	85 c0                	test   %eax,%eax
c0103580:	74 19                	je     c010359b <check_pgdir+0x8d>
c0103582:	68 9c 63 10 c0       	push   $0xc010639c
c0103587:	68 ed 62 10 c0       	push   $0xc01062ed
c010358c:	68 e6 01 00 00       	push   $0x1e6
c0103591:	68 c8 62 10 c0       	push   $0xc01062c8
c0103596:	e8 3e ce ff ff       	call   c01003d9 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010359b:	83 ec 0c             	sub    $0xc,%esp
c010359e:	6a 01                	push   $0x1
c01035a0:	e8 d5 f5 ff ff       	call   c0102b7a <alloc_pages>
c01035a5:	83 c4 10             	add    $0x10,%esp
c01035a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01035ab:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01035b0:	6a 00                	push   $0x0
c01035b2:	6a 00                	push   $0x0
c01035b4:	ff 75 f4             	pushl  -0xc(%ebp)
c01035b7:	50                   	push   %eax
c01035b8:	e8 25 fe ff ff       	call   c01033e2 <page_insert>
c01035bd:	83 c4 10             	add    $0x10,%esp
c01035c0:	85 c0                	test   %eax,%eax
c01035c2:	74 19                	je     c01035dd <check_pgdir+0xcf>
c01035c4:	68 c4 63 10 c0       	push   $0xc01063c4
c01035c9:	68 ed 62 10 c0       	push   $0xc01062ed
c01035ce:	68 ea 01 00 00       	push   $0x1ea
c01035d3:	68 c8 62 10 c0       	push   $0xc01062c8
c01035d8:	e8 fc cd ff ff       	call   c01003d9 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01035dd:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01035e2:	83 ec 04             	sub    $0x4,%esp
c01035e5:	6a 00                	push   $0x0
c01035e7:	6a 00                	push   $0x0
c01035e9:	50                   	push   %eax
c01035ea:	e8 e2 fb ff ff       	call   c01031d1 <get_pte>
c01035ef:	83 c4 10             	add    $0x10,%esp
c01035f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01035f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01035f9:	75 19                	jne    c0103614 <check_pgdir+0x106>
c01035fb:	68 f0 63 10 c0       	push   $0xc01063f0
c0103600:	68 ed 62 10 c0       	push   $0xc01062ed
c0103605:	68 ed 01 00 00       	push   $0x1ed
c010360a:	68 c8 62 10 c0       	push   $0xc01062c8
c010360f:	e8 c5 cd ff ff       	call   c01003d9 <__panic>
    assert(pte2page(*ptep) == p1);
c0103614:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103617:	8b 00                	mov    (%eax),%eax
c0103619:	83 ec 0c             	sub    $0xc,%esp
c010361c:	50                   	push   %eax
c010361d:	e8 f4 f2 ff ff       	call   c0102916 <pte2page>
c0103622:	83 c4 10             	add    $0x10,%esp
c0103625:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103628:	74 19                	je     c0103643 <check_pgdir+0x135>
c010362a:	68 1d 64 10 c0       	push   $0xc010641d
c010362f:	68 ed 62 10 c0       	push   $0xc01062ed
c0103634:	68 ee 01 00 00       	push   $0x1ee
c0103639:	68 c8 62 10 c0       	push   $0xc01062c8
c010363e:	e8 96 cd ff ff       	call   c01003d9 <__panic>
    assert(page_ref(p1) == 1);
c0103643:	83 ec 0c             	sub    $0xc,%esp
c0103646:	ff 75 f4             	pushl  -0xc(%ebp)
c0103649:	e8 1e f3 ff ff       	call   c010296c <page_ref>
c010364e:	83 c4 10             	add    $0x10,%esp
c0103651:	83 f8 01             	cmp    $0x1,%eax
c0103654:	74 19                	je     c010366f <check_pgdir+0x161>
c0103656:	68 33 64 10 c0       	push   $0xc0106433
c010365b:	68 ed 62 10 c0       	push   $0xc01062ed
c0103660:	68 ef 01 00 00       	push   $0x1ef
c0103665:	68 c8 62 10 c0       	push   $0xc01062c8
c010366a:	e8 6a cd ff ff       	call   c01003d9 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c010366f:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103674:	8b 00                	mov    (%eax),%eax
c0103676:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010367b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010367e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103681:	c1 e8 0c             	shr    $0xc,%eax
c0103684:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103687:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c010368c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010368f:	72 17                	jb     c01036a8 <check_pgdir+0x19a>
c0103691:	ff 75 ec             	pushl  -0x14(%ebp)
c0103694:	68 00 62 10 c0       	push   $0xc0106200
c0103699:	68 f1 01 00 00       	push   $0x1f1
c010369e:	68 c8 62 10 c0       	push   $0xc01062c8
c01036a3:	e8 31 cd ff ff       	call   c01003d9 <__panic>
c01036a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01036ab:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01036b0:	83 c0 04             	add    $0x4,%eax
c01036b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01036b6:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01036bb:	83 ec 04             	sub    $0x4,%esp
c01036be:	6a 00                	push   $0x0
c01036c0:	68 00 10 00 00       	push   $0x1000
c01036c5:	50                   	push   %eax
c01036c6:	e8 06 fb ff ff       	call   c01031d1 <get_pte>
c01036cb:	83 c4 10             	add    $0x10,%esp
c01036ce:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01036d1:	74 19                	je     c01036ec <check_pgdir+0x1de>
c01036d3:	68 48 64 10 c0       	push   $0xc0106448
c01036d8:	68 ed 62 10 c0       	push   $0xc01062ed
c01036dd:	68 f2 01 00 00       	push   $0x1f2
c01036e2:	68 c8 62 10 c0       	push   $0xc01062c8
c01036e7:	e8 ed cc ff ff       	call   c01003d9 <__panic>

    p2 = alloc_page();
c01036ec:	83 ec 0c             	sub    $0xc,%esp
c01036ef:	6a 01                	push   $0x1
c01036f1:	e8 84 f4 ff ff       	call   c0102b7a <alloc_pages>
c01036f6:	83 c4 10             	add    $0x10,%esp
c01036f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01036fc:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103701:	6a 06                	push   $0x6
c0103703:	68 00 10 00 00       	push   $0x1000
c0103708:	ff 75 e4             	pushl  -0x1c(%ebp)
c010370b:	50                   	push   %eax
c010370c:	e8 d1 fc ff ff       	call   c01033e2 <page_insert>
c0103711:	83 c4 10             	add    $0x10,%esp
c0103714:	85 c0                	test   %eax,%eax
c0103716:	74 19                	je     c0103731 <check_pgdir+0x223>
c0103718:	68 70 64 10 c0       	push   $0xc0106470
c010371d:	68 ed 62 10 c0       	push   $0xc01062ed
c0103722:	68 f5 01 00 00       	push   $0x1f5
c0103727:	68 c8 62 10 c0       	push   $0xc01062c8
c010372c:	e8 a8 cc ff ff       	call   c01003d9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103731:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103736:	83 ec 04             	sub    $0x4,%esp
c0103739:	6a 00                	push   $0x0
c010373b:	68 00 10 00 00       	push   $0x1000
c0103740:	50                   	push   %eax
c0103741:	e8 8b fa ff ff       	call   c01031d1 <get_pte>
c0103746:	83 c4 10             	add    $0x10,%esp
c0103749:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010374c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103750:	75 19                	jne    c010376b <check_pgdir+0x25d>
c0103752:	68 a8 64 10 c0       	push   $0xc01064a8
c0103757:	68 ed 62 10 c0       	push   $0xc01062ed
c010375c:	68 f6 01 00 00       	push   $0x1f6
c0103761:	68 c8 62 10 c0       	push   $0xc01062c8
c0103766:	e8 6e cc ff ff       	call   c01003d9 <__panic>
    assert(*ptep & PTE_U);
c010376b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010376e:	8b 00                	mov    (%eax),%eax
c0103770:	83 e0 04             	and    $0x4,%eax
c0103773:	85 c0                	test   %eax,%eax
c0103775:	75 19                	jne    c0103790 <check_pgdir+0x282>
c0103777:	68 d8 64 10 c0       	push   $0xc01064d8
c010377c:	68 ed 62 10 c0       	push   $0xc01062ed
c0103781:	68 f7 01 00 00       	push   $0x1f7
c0103786:	68 c8 62 10 c0       	push   $0xc01062c8
c010378b:	e8 49 cc ff ff       	call   c01003d9 <__panic>
    assert(*ptep & PTE_W);
c0103790:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103793:	8b 00                	mov    (%eax),%eax
c0103795:	83 e0 02             	and    $0x2,%eax
c0103798:	85 c0                	test   %eax,%eax
c010379a:	75 19                	jne    c01037b5 <check_pgdir+0x2a7>
c010379c:	68 e6 64 10 c0       	push   $0xc01064e6
c01037a1:	68 ed 62 10 c0       	push   $0xc01062ed
c01037a6:	68 f8 01 00 00       	push   $0x1f8
c01037ab:	68 c8 62 10 c0       	push   $0xc01062c8
c01037b0:	e8 24 cc ff ff       	call   c01003d9 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c01037b5:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01037ba:	8b 00                	mov    (%eax),%eax
c01037bc:	83 e0 04             	and    $0x4,%eax
c01037bf:	85 c0                	test   %eax,%eax
c01037c1:	75 19                	jne    c01037dc <check_pgdir+0x2ce>
c01037c3:	68 f4 64 10 c0       	push   $0xc01064f4
c01037c8:	68 ed 62 10 c0       	push   $0xc01062ed
c01037cd:	68 f9 01 00 00       	push   $0x1f9
c01037d2:	68 c8 62 10 c0       	push   $0xc01062c8
c01037d7:	e8 fd cb ff ff       	call   c01003d9 <__panic>
    assert(page_ref(p2) == 1);
c01037dc:	83 ec 0c             	sub    $0xc,%esp
c01037df:	ff 75 e4             	pushl  -0x1c(%ebp)
c01037e2:	e8 85 f1 ff ff       	call   c010296c <page_ref>
c01037e7:	83 c4 10             	add    $0x10,%esp
c01037ea:	83 f8 01             	cmp    $0x1,%eax
c01037ed:	74 19                	je     c0103808 <check_pgdir+0x2fa>
c01037ef:	68 0a 65 10 c0       	push   $0xc010650a
c01037f4:	68 ed 62 10 c0       	push   $0xc01062ed
c01037f9:	68 fa 01 00 00       	push   $0x1fa
c01037fe:	68 c8 62 10 c0       	push   $0xc01062c8
c0103803:	e8 d1 cb ff ff       	call   c01003d9 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0103808:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010380d:	6a 00                	push   $0x0
c010380f:	68 00 10 00 00       	push   $0x1000
c0103814:	ff 75 f4             	pushl  -0xc(%ebp)
c0103817:	50                   	push   %eax
c0103818:	e8 c5 fb ff ff       	call   c01033e2 <page_insert>
c010381d:	83 c4 10             	add    $0x10,%esp
c0103820:	85 c0                	test   %eax,%eax
c0103822:	74 19                	je     c010383d <check_pgdir+0x32f>
c0103824:	68 1c 65 10 c0       	push   $0xc010651c
c0103829:	68 ed 62 10 c0       	push   $0xc01062ed
c010382e:	68 fc 01 00 00       	push   $0x1fc
c0103833:	68 c8 62 10 c0       	push   $0xc01062c8
c0103838:	e8 9c cb ff ff       	call   c01003d9 <__panic>
    assert(page_ref(p1) == 2);
c010383d:	83 ec 0c             	sub    $0xc,%esp
c0103840:	ff 75 f4             	pushl  -0xc(%ebp)
c0103843:	e8 24 f1 ff ff       	call   c010296c <page_ref>
c0103848:	83 c4 10             	add    $0x10,%esp
c010384b:	83 f8 02             	cmp    $0x2,%eax
c010384e:	74 19                	je     c0103869 <check_pgdir+0x35b>
c0103850:	68 48 65 10 c0       	push   $0xc0106548
c0103855:	68 ed 62 10 c0       	push   $0xc01062ed
c010385a:	68 fd 01 00 00       	push   $0x1fd
c010385f:	68 c8 62 10 c0       	push   $0xc01062c8
c0103864:	e8 70 cb ff ff       	call   c01003d9 <__panic>
    assert(page_ref(p2) == 0);
c0103869:	83 ec 0c             	sub    $0xc,%esp
c010386c:	ff 75 e4             	pushl  -0x1c(%ebp)
c010386f:	e8 f8 f0 ff ff       	call   c010296c <page_ref>
c0103874:	83 c4 10             	add    $0x10,%esp
c0103877:	85 c0                	test   %eax,%eax
c0103879:	74 19                	je     c0103894 <check_pgdir+0x386>
c010387b:	68 5a 65 10 c0       	push   $0xc010655a
c0103880:	68 ed 62 10 c0       	push   $0xc01062ed
c0103885:	68 fe 01 00 00       	push   $0x1fe
c010388a:	68 c8 62 10 c0       	push   $0xc01062c8
c010388f:	e8 45 cb ff ff       	call   c01003d9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103894:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103899:	83 ec 04             	sub    $0x4,%esp
c010389c:	6a 00                	push   $0x0
c010389e:	68 00 10 00 00       	push   $0x1000
c01038a3:	50                   	push   %eax
c01038a4:	e8 28 f9 ff ff       	call   c01031d1 <get_pte>
c01038a9:	83 c4 10             	add    $0x10,%esp
c01038ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01038af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01038b3:	75 19                	jne    c01038ce <check_pgdir+0x3c0>
c01038b5:	68 a8 64 10 c0       	push   $0xc01064a8
c01038ba:	68 ed 62 10 c0       	push   $0xc01062ed
c01038bf:	68 ff 01 00 00       	push   $0x1ff
c01038c4:	68 c8 62 10 c0       	push   $0xc01062c8
c01038c9:	e8 0b cb ff ff       	call   c01003d9 <__panic>
    assert(pte2page(*ptep) == p1);
c01038ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038d1:	8b 00                	mov    (%eax),%eax
c01038d3:	83 ec 0c             	sub    $0xc,%esp
c01038d6:	50                   	push   %eax
c01038d7:	e8 3a f0 ff ff       	call   c0102916 <pte2page>
c01038dc:	83 c4 10             	add    $0x10,%esp
c01038df:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01038e2:	74 19                	je     c01038fd <check_pgdir+0x3ef>
c01038e4:	68 1d 64 10 c0       	push   $0xc010641d
c01038e9:	68 ed 62 10 c0       	push   $0xc01062ed
c01038ee:	68 00 02 00 00       	push   $0x200
c01038f3:	68 c8 62 10 c0       	push   $0xc01062c8
c01038f8:	e8 dc ca ff ff       	call   c01003d9 <__panic>
    assert((*ptep & PTE_U) == 0);
c01038fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103900:	8b 00                	mov    (%eax),%eax
c0103902:	83 e0 04             	and    $0x4,%eax
c0103905:	85 c0                	test   %eax,%eax
c0103907:	74 19                	je     c0103922 <check_pgdir+0x414>
c0103909:	68 6c 65 10 c0       	push   $0xc010656c
c010390e:	68 ed 62 10 c0       	push   $0xc01062ed
c0103913:	68 01 02 00 00       	push   $0x201
c0103918:	68 c8 62 10 c0       	push   $0xc01062c8
c010391d:	e8 b7 ca ff ff       	call   c01003d9 <__panic>

    page_remove(boot_pgdir, 0x0);
c0103922:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103927:	83 ec 08             	sub    $0x8,%esp
c010392a:	6a 00                	push   $0x0
c010392c:	50                   	push   %eax
c010392d:	e8 77 fa ff ff       	call   c01033a9 <page_remove>
c0103932:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c0103935:	83 ec 0c             	sub    $0xc,%esp
c0103938:	ff 75 f4             	pushl  -0xc(%ebp)
c010393b:	e8 2c f0 ff ff       	call   c010296c <page_ref>
c0103940:	83 c4 10             	add    $0x10,%esp
c0103943:	83 f8 01             	cmp    $0x1,%eax
c0103946:	74 19                	je     c0103961 <check_pgdir+0x453>
c0103948:	68 33 64 10 c0       	push   $0xc0106433
c010394d:	68 ed 62 10 c0       	push   $0xc01062ed
c0103952:	68 04 02 00 00       	push   $0x204
c0103957:	68 c8 62 10 c0       	push   $0xc01062c8
c010395c:	e8 78 ca ff ff       	call   c01003d9 <__panic>
    assert(page_ref(p2) == 0);
c0103961:	83 ec 0c             	sub    $0xc,%esp
c0103964:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103967:	e8 00 f0 ff ff       	call   c010296c <page_ref>
c010396c:	83 c4 10             	add    $0x10,%esp
c010396f:	85 c0                	test   %eax,%eax
c0103971:	74 19                	je     c010398c <check_pgdir+0x47e>
c0103973:	68 5a 65 10 c0       	push   $0xc010655a
c0103978:	68 ed 62 10 c0       	push   $0xc01062ed
c010397d:	68 05 02 00 00       	push   $0x205
c0103982:	68 c8 62 10 c0       	push   $0xc01062c8
c0103987:	e8 4d ca ff ff       	call   c01003d9 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c010398c:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103991:	83 ec 08             	sub    $0x8,%esp
c0103994:	68 00 10 00 00       	push   $0x1000
c0103999:	50                   	push   %eax
c010399a:	e8 0a fa ff ff       	call   c01033a9 <page_remove>
c010399f:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c01039a2:	83 ec 0c             	sub    $0xc,%esp
c01039a5:	ff 75 f4             	pushl  -0xc(%ebp)
c01039a8:	e8 bf ef ff ff       	call   c010296c <page_ref>
c01039ad:	83 c4 10             	add    $0x10,%esp
c01039b0:	85 c0                	test   %eax,%eax
c01039b2:	74 19                	je     c01039cd <check_pgdir+0x4bf>
c01039b4:	68 81 65 10 c0       	push   $0xc0106581
c01039b9:	68 ed 62 10 c0       	push   $0xc01062ed
c01039be:	68 08 02 00 00       	push   $0x208
c01039c3:	68 c8 62 10 c0       	push   $0xc01062c8
c01039c8:	e8 0c ca ff ff       	call   c01003d9 <__panic>
    assert(page_ref(p2) == 0);
c01039cd:	83 ec 0c             	sub    $0xc,%esp
c01039d0:	ff 75 e4             	pushl  -0x1c(%ebp)
c01039d3:	e8 94 ef ff ff       	call   c010296c <page_ref>
c01039d8:	83 c4 10             	add    $0x10,%esp
c01039db:	85 c0                	test   %eax,%eax
c01039dd:	74 19                	je     c01039f8 <check_pgdir+0x4ea>
c01039df:	68 5a 65 10 c0       	push   $0xc010655a
c01039e4:	68 ed 62 10 c0       	push   $0xc01062ed
c01039e9:	68 09 02 00 00       	push   $0x209
c01039ee:	68 c8 62 10 c0       	push   $0xc01062c8
c01039f3:	e8 e1 c9 ff ff       	call   c01003d9 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c01039f8:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01039fd:	8b 00                	mov    (%eax),%eax
c01039ff:	83 ec 0c             	sub    $0xc,%esp
c0103a02:	50                   	push   %eax
c0103a03:	e8 48 ef ff ff       	call   c0102950 <pde2page>
c0103a08:	83 c4 10             	add    $0x10,%esp
c0103a0b:	83 ec 0c             	sub    $0xc,%esp
c0103a0e:	50                   	push   %eax
c0103a0f:	e8 58 ef ff ff       	call   c010296c <page_ref>
c0103a14:	83 c4 10             	add    $0x10,%esp
c0103a17:	83 f8 01             	cmp    $0x1,%eax
c0103a1a:	74 19                	je     c0103a35 <check_pgdir+0x527>
c0103a1c:	68 94 65 10 c0       	push   $0xc0106594
c0103a21:	68 ed 62 10 c0       	push   $0xc01062ed
c0103a26:	68 0b 02 00 00       	push   $0x20b
c0103a2b:	68 c8 62 10 c0       	push   $0xc01062c8
c0103a30:	e8 a4 c9 ff ff       	call   c01003d9 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103a35:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103a3a:	8b 00                	mov    (%eax),%eax
c0103a3c:	83 ec 0c             	sub    $0xc,%esp
c0103a3f:	50                   	push   %eax
c0103a40:	e8 0b ef ff ff       	call   c0102950 <pde2page>
c0103a45:	83 c4 10             	add    $0x10,%esp
c0103a48:	83 ec 08             	sub    $0x8,%esp
c0103a4b:	6a 01                	push   $0x1
c0103a4d:	50                   	push   %eax
c0103a4e:	e8 65 f1 ff ff       	call   c0102bb8 <free_pages>
c0103a53:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103a56:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103a5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103a61:	83 ec 0c             	sub    $0xc,%esp
c0103a64:	68 bb 65 10 c0       	push   $0xc01065bb
c0103a69:	e8 05 c8 ff ff       	call   c0100273 <cprintf>
c0103a6e:	83 c4 10             	add    $0x10,%esp
}
c0103a71:	90                   	nop
c0103a72:	c9                   	leave  
c0103a73:	c3                   	ret    

c0103a74 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103a74:	55                   	push   %ebp
c0103a75:	89 e5                	mov    %esp,%ebp
c0103a77:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103a7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103a81:	e9 a3 00 00 00       	jmp    c0103b29 <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103a8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a8f:	c1 e8 0c             	shr    $0xc,%eax
c0103a92:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103a95:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103a9a:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103a9d:	72 17                	jb     c0103ab6 <check_boot_pgdir+0x42>
c0103a9f:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103aa2:	68 00 62 10 c0       	push   $0xc0106200
c0103aa7:	68 17 02 00 00       	push   $0x217
c0103aac:	68 c8 62 10 c0       	push   $0xc01062c8
c0103ab1:	e8 23 c9 ff ff       	call   c01003d9 <__panic>
c0103ab6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ab9:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103abe:	89 c2                	mov    %eax,%edx
c0103ac0:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103ac5:	83 ec 04             	sub    $0x4,%esp
c0103ac8:	6a 00                	push   $0x0
c0103aca:	52                   	push   %edx
c0103acb:	50                   	push   %eax
c0103acc:	e8 00 f7 ff ff       	call   c01031d1 <get_pte>
c0103ad1:	83 c4 10             	add    $0x10,%esp
c0103ad4:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103ad7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103adb:	75 19                	jne    c0103af6 <check_boot_pgdir+0x82>
c0103add:	68 d8 65 10 c0       	push   $0xc01065d8
c0103ae2:	68 ed 62 10 c0       	push   $0xc01062ed
c0103ae7:	68 17 02 00 00       	push   $0x217
c0103aec:	68 c8 62 10 c0       	push   $0xc01062c8
c0103af1:	e8 e3 c8 ff ff       	call   c01003d9 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103af6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103af9:	8b 00                	mov    (%eax),%eax
c0103afb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b00:	89 c2                	mov    %eax,%edx
c0103b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b05:	39 c2                	cmp    %eax,%edx
c0103b07:	74 19                	je     c0103b22 <check_boot_pgdir+0xae>
c0103b09:	68 15 66 10 c0       	push   $0xc0106615
c0103b0e:	68 ed 62 10 c0       	push   $0xc01062ed
c0103b13:	68 18 02 00 00       	push   $0x218
c0103b18:	68 c8 62 10 c0       	push   $0xc01062c8
c0103b1d:	e8 b7 c8 ff ff       	call   c01003d9 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0103b22:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103b29:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103b2c:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103b31:	39 c2                	cmp    %eax,%edx
c0103b33:	0f 82 4d ff ff ff    	jb     c0103a86 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103b39:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103b3e:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103b43:	8b 00                	mov    (%eax),%eax
c0103b45:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b4a:	89 c2                	mov    %eax,%edx
c0103b4c:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103b51:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b54:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103b5b:	77 17                	ja     c0103b74 <check_boot_pgdir+0x100>
c0103b5d:	ff 75 f0             	pushl  -0x10(%ebp)
c0103b60:	68 a4 62 10 c0       	push   $0xc01062a4
c0103b65:	68 1b 02 00 00       	push   $0x21b
c0103b6a:	68 c8 62 10 c0       	push   $0xc01062c8
c0103b6f:	e8 65 c8 ff ff       	call   c01003d9 <__panic>
c0103b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b77:	05 00 00 00 40       	add    $0x40000000,%eax
c0103b7c:	39 d0                	cmp    %edx,%eax
c0103b7e:	74 19                	je     c0103b99 <check_boot_pgdir+0x125>
c0103b80:	68 2c 66 10 c0       	push   $0xc010662c
c0103b85:	68 ed 62 10 c0       	push   $0xc01062ed
c0103b8a:	68 1b 02 00 00       	push   $0x21b
c0103b8f:	68 c8 62 10 c0       	push   $0xc01062c8
c0103b94:	e8 40 c8 ff ff       	call   c01003d9 <__panic>

    assert(boot_pgdir[0] == 0);
c0103b99:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103b9e:	8b 00                	mov    (%eax),%eax
c0103ba0:	85 c0                	test   %eax,%eax
c0103ba2:	74 19                	je     c0103bbd <check_boot_pgdir+0x149>
c0103ba4:	68 60 66 10 c0       	push   $0xc0106660
c0103ba9:	68 ed 62 10 c0       	push   $0xc01062ed
c0103bae:	68 1d 02 00 00       	push   $0x21d
c0103bb3:	68 c8 62 10 c0       	push   $0xc01062c8
c0103bb8:	e8 1c c8 ff ff       	call   c01003d9 <__panic>

    struct Page *p;
    p = alloc_page();
c0103bbd:	83 ec 0c             	sub    $0xc,%esp
c0103bc0:	6a 01                	push   $0x1
c0103bc2:	e8 b3 ef ff ff       	call   c0102b7a <alloc_pages>
c0103bc7:	83 c4 10             	add    $0x10,%esp
c0103bca:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103bcd:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103bd2:	6a 02                	push   $0x2
c0103bd4:	68 00 01 00 00       	push   $0x100
c0103bd9:	ff 75 ec             	pushl  -0x14(%ebp)
c0103bdc:	50                   	push   %eax
c0103bdd:	e8 00 f8 ff ff       	call   c01033e2 <page_insert>
c0103be2:	83 c4 10             	add    $0x10,%esp
c0103be5:	85 c0                	test   %eax,%eax
c0103be7:	74 19                	je     c0103c02 <check_boot_pgdir+0x18e>
c0103be9:	68 74 66 10 c0       	push   $0xc0106674
c0103bee:	68 ed 62 10 c0       	push   $0xc01062ed
c0103bf3:	68 21 02 00 00       	push   $0x221
c0103bf8:	68 c8 62 10 c0       	push   $0xc01062c8
c0103bfd:	e8 d7 c7 ff ff       	call   c01003d9 <__panic>
    assert(page_ref(p) == 1);
c0103c02:	83 ec 0c             	sub    $0xc,%esp
c0103c05:	ff 75 ec             	pushl  -0x14(%ebp)
c0103c08:	e8 5f ed ff ff       	call   c010296c <page_ref>
c0103c0d:	83 c4 10             	add    $0x10,%esp
c0103c10:	83 f8 01             	cmp    $0x1,%eax
c0103c13:	74 19                	je     c0103c2e <check_boot_pgdir+0x1ba>
c0103c15:	68 a2 66 10 c0       	push   $0xc01066a2
c0103c1a:	68 ed 62 10 c0       	push   $0xc01062ed
c0103c1f:	68 22 02 00 00       	push   $0x222
c0103c24:	68 c8 62 10 c0       	push   $0xc01062c8
c0103c29:	e8 ab c7 ff ff       	call   c01003d9 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0103c2e:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103c33:	6a 02                	push   $0x2
c0103c35:	68 00 11 00 00       	push   $0x1100
c0103c3a:	ff 75 ec             	pushl  -0x14(%ebp)
c0103c3d:	50                   	push   %eax
c0103c3e:	e8 9f f7 ff ff       	call   c01033e2 <page_insert>
c0103c43:	83 c4 10             	add    $0x10,%esp
c0103c46:	85 c0                	test   %eax,%eax
c0103c48:	74 19                	je     c0103c63 <check_boot_pgdir+0x1ef>
c0103c4a:	68 b4 66 10 c0       	push   $0xc01066b4
c0103c4f:	68 ed 62 10 c0       	push   $0xc01062ed
c0103c54:	68 23 02 00 00       	push   $0x223
c0103c59:	68 c8 62 10 c0       	push   $0xc01062c8
c0103c5e:	e8 76 c7 ff ff       	call   c01003d9 <__panic>
    assert(page_ref(p) == 2);
c0103c63:	83 ec 0c             	sub    $0xc,%esp
c0103c66:	ff 75 ec             	pushl  -0x14(%ebp)
c0103c69:	e8 fe ec ff ff       	call   c010296c <page_ref>
c0103c6e:	83 c4 10             	add    $0x10,%esp
c0103c71:	83 f8 02             	cmp    $0x2,%eax
c0103c74:	74 19                	je     c0103c8f <check_boot_pgdir+0x21b>
c0103c76:	68 eb 66 10 c0       	push   $0xc01066eb
c0103c7b:	68 ed 62 10 c0       	push   $0xc01062ed
c0103c80:	68 24 02 00 00       	push   $0x224
c0103c85:	68 c8 62 10 c0       	push   $0xc01062c8
c0103c8a:	e8 4a c7 ff ff       	call   c01003d9 <__panic>

    const char *str = "ucore: Hello world!!";
c0103c8f:	c7 45 e8 fc 66 10 c0 	movl   $0xc01066fc,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0103c96:	83 ec 08             	sub    $0x8,%esp
c0103c99:	ff 75 e8             	pushl  -0x18(%ebp)
c0103c9c:	68 00 01 00 00       	push   $0x100
c0103ca1:	e8 80 13 00 00       	call   c0105026 <strcpy>
c0103ca6:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0103ca9:	83 ec 08             	sub    $0x8,%esp
c0103cac:	68 00 11 00 00       	push   $0x1100
c0103cb1:	68 00 01 00 00       	push   $0x100
c0103cb6:	e8 e5 13 00 00       	call   c01050a0 <strcmp>
c0103cbb:	83 c4 10             	add    $0x10,%esp
c0103cbe:	85 c0                	test   %eax,%eax
c0103cc0:	74 19                	je     c0103cdb <check_boot_pgdir+0x267>
c0103cc2:	68 14 67 10 c0       	push   $0xc0106714
c0103cc7:	68 ed 62 10 c0       	push   $0xc01062ed
c0103ccc:	68 28 02 00 00       	push   $0x228
c0103cd1:	68 c8 62 10 c0       	push   $0xc01062c8
c0103cd6:	e8 fe c6 ff ff       	call   c01003d9 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0103cdb:	83 ec 0c             	sub    $0xc,%esp
c0103cde:	ff 75 ec             	pushl  -0x14(%ebp)
c0103ce1:	e8 eb eb ff ff       	call   c01028d1 <page2kva>
c0103ce6:	83 c4 10             	add    $0x10,%esp
c0103ce9:	05 00 01 00 00       	add    $0x100,%eax
c0103cee:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0103cf1:	83 ec 0c             	sub    $0xc,%esp
c0103cf4:	68 00 01 00 00       	push   $0x100
c0103cf9:	e8 d0 12 00 00       	call   c0104fce <strlen>
c0103cfe:	83 c4 10             	add    $0x10,%esp
c0103d01:	85 c0                	test   %eax,%eax
c0103d03:	74 19                	je     c0103d1e <check_boot_pgdir+0x2aa>
c0103d05:	68 4c 67 10 c0       	push   $0xc010674c
c0103d0a:	68 ed 62 10 c0       	push   $0xc01062ed
c0103d0f:	68 2b 02 00 00       	push   $0x22b
c0103d14:	68 c8 62 10 c0       	push   $0xc01062c8
c0103d19:	e8 bb c6 ff ff       	call   c01003d9 <__panic>

    free_page(p);
c0103d1e:	83 ec 08             	sub    $0x8,%esp
c0103d21:	6a 01                	push   $0x1
c0103d23:	ff 75 ec             	pushl  -0x14(%ebp)
c0103d26:	e8 8d ee ff ff       	call   c0102bb8 <free_pages>
c0103d2b:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c0103d2e:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103d33:	8b 00                	mov    (%eax),%eax
c0103d35:	83 ec 0c             	sub    $0xc,%esp
c0103d38:	50                   	push   %eax
c0103d39:	e8 12 ec ff ff       	call   c0102950 <pde2page>
c0103d3e:	83 c4 10             	add    $0x10,%esp
c0103d41:	83 ec 08             	sub    $0x8,%esp
c0103d44:	6a 01                	push   $0x1
c0103d46:	50                   	push   %eax
c0103d47:	e8 6c ee ff ff       	call   c0102bb8 <free_pages>
c0103d4c:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103d4f:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103d54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0103d5a:	83 ec 0c             	sub    $0xc,%esp
c0103d5d:	68 70 67 10 c0       	push   $0xc0106770
c0103d62:	e8 0c c5 ff ff       	call   c0100273 <cprintf>
c0103d67:	83 c4 10             	add    $0x10,%esp
}
c0103d6a:	90                   	nop
c0103d6b:	c9                   	leave  
c0103d6c:	c3                   	ret    

c0103d6d <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0103d6d:	55                   	push   %ebp
c0103d6e:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0103d70:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d73:	83 e0 04             	and    $0x4,%eax
c0103d76:	85 c0                	test   %eax,%eax
c0103d78:	74 07                	je     c0103d81 <perm2str+0x14>
c0103d7a:	b8 75 00 00 00       	mov    $0x75,%eax
c0103d7f:	eb 05                	jmp    c0103d86 <perm2str+0x19>
c0103d81:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103d86:	a2 08 af 11 c0       	mov    %al,0xc011af08
    str[1] = 'r';
c0103d8b:	c6 05 09 af 11 c0 72 	movb   $0x72,0xc011af09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0103d92:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d95:	83 e0 02             	and    $0x2,%eax
c0103d98:	85 c0                	test   %eax,%eax
c0103d9a:	74 07                	je     c0103da3 <perm2str+0x36>
c0103d9c:	b8 77 00 00 00       	mov    $0x77,%eax
c0103da1:	eb 05                	jmp    c0103da8 <perm2str+0x3b>
c0103da3:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103da8:	a2 0a af 11 c0       	mov    %al,0xc011af0a
    str[3] = '\0';
c0103dad:	c6 05 0b af 11 c0 00 	movb   $0x0,0xc011af0b
    return str;
c0103db4:	b8 08 af 11 c0       	mov    $0xc011af08,%eax
}
c0103db9:	5d                   	pop    %ebp
c0103dba:	c3                   	ret    

c0103dbb <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0103dbb:	55                   	push   %ebp
c0103dbc:	89 e5                	mov    %esp,%ebp
c0103dbe:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0103dc1:	8b 45 10             	mov    0x10(%ebp),%eax
c0103dc4:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103dc7:	72 0e                	jb     c0103dd7 <get_pgtable_items+0x1c>
        return 0;
c0103dc9:	b8 00 00 00 00       	mov    $0x0,%eax
c0103dce:	e9 9a 00 00 00       	jmp    c0103e6d <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0103dd3:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0103dd7:	8b 45 10             	mov    0x10(%ebp),%eax
c0103dda:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103ddd:	73 18                	jae    c0103df7 <get_pgtable_items+0x3c>
c0103ddf:	8b 45 10             	mov    0x10(%ebp),%eax
c0103de2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103de9:	8b 45 14             	mov    0x14(%ebp),%eax
c0103dec:	01 d0                	add    %edx,%eax
c0103dee:	8b 00                	mov    (%eax),%eax
c0103df0:	83 e0 01             	and    $0x1,%eax
c0103df3:	85 c0                	test   %eax,%eax
c0103df5:	74 dc                	je     c0103dd3 <get_pgtable_items+0x18>
    }
    if (start < right) {
c0103df7:	8b 45 10             	mov    0x10(%ebp),%eax
c0103dfa:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103dfd:	73 69                	jae    c0103e68 <get_pgtable_items+0xad>
        if (left_store != NULL) {
c0103dff:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0103e03:	74 08                	je     c0103e0d <get_pgtable_items+0x52>
            *left_store = start;
c0103e05:	8b 45 18             	mov    0x18(%ebp),%eax
c0103e08:	8b 55 10             	mov    0x10(%ebp),%edx
c0103e0b:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0103e0d:	8b 45 10             	mov    0x10(%ebp),%eax
c0103e10:	8d 50 01             	lea    0x1(%eax),%edx
c0103e13:	89 55 10             	mov    %edx,0x10(%ebp)
c0103e16:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103e1d:	8b 45 14             	mov    0x14(%ebp),%eax
c0103e20:	01 d0                	add    %edx,%eax
c0103e22:	8b 00                	mov    (%eax),%eax
c0103e24:	83 e0 07             	and    $0x7,%eax
c0103e27:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103e2a:	eb 04                	jmp    c0103e30 <get_pgtable_items+0x75>
            start ++;
c0103e2c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103e30:	8b 45 10             	mov    0x10(%ebp),%eax
c0103e33:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103e36:	73 1d                	jae    c0103e55 <get_pgtable_items+0x9a>
c0103e38:	8b 45 10             	mov    0x10(%ebp),%eax
c0103e3b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103e42:	8b 45 14             	mov    0x14(%ebp),%eax
c0103e45:	01 d0                	add    %edx,%eax
c0103e47:	8b 00                	mov    (%eax),%eax
c0103e49:	83 e0 07             	and    $0x7,%eax
c0103e4c:	89 c2                	mov    %eax,%edx
c0103e4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103e51:	39 c2                	cmp    %eax,%edx
c0103e53:	74 d7                	je     c0103e2c <get_pgtable_items+0x71>
        }
        if (right_store != NULL) {
c0103e55:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0103e59:	74 08                	je     c0103e63 <get_pgtable_items+0xa8>
            *right_store = start;
c0103e5b:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0103e5e:	8b 55 10             	mov    0x10(%ebp),%edx
c0103e61:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0103e63:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103e66:	eb 05                	jmp    c0103e6d <get_pgtable_items+0xb2>
    }
    return 0;
c0103e68:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103e6d:	c9                   	leave  
c0103e6e:	c3                   	ret    

c0103e6f <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0103e6f:	55                   	push   %ebp
c0103e70:	89 e5                	mov    %esp,%ebp
c0103e72:	57                   	push   %edi
c0103e73:	56                   	push   %esi
c0103e74:	53                   	push   %ebx
c0103e75:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0103e78:	83 ec 0c             	sub    $0xc,%esp
c0103e7b:	68 90 67 10 c0       	push   $0xc0106790
c0103e80:	e8 ee c3 ff ff       	call   c0100273 <cprintf>
c0103e85:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c0103e88:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0103e8f:	e9 e5 00 00 00       	jmp    c0103f79 <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0103e94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e97:	83 ec 0c             	sub    $0xc,%esp
c0103e9a:	50                   	push   %eax
c0103e9b:	e8 cd fe ff ff       	call   c0103d6d <perm2str>
c0103ea0:	83 c4 10             	add    $0x10,%esp
c0103ea3:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0103ea5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ea8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103eab:	29 c2                	sub    %eax,%edx
c0103ead:	89 d0                	mov    %edx,%eax
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0103eaf:	c1 e0 16             	shl    $0x16,%eax
c0103eb2:	89 c3                	mov    %eax,%ebx
c0103eb4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103eb7:	c1 e0 16             	shl    $0x16,%eax
c0103eba:	89 c1                	mov    %eax,%ecx
c0103ebc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ebf:	c1 e0 16             	shl    $0x16,%eax
c0103ec2:	89 c2                	mov    %eax,%edx
c0103ec4:	8b 75 dc             	mov    -0x24(%ebp),%esi
c0103ec7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103eca:	29 c6                	sub    %eax,%esi
c0103ecc:	89 f0                	mov    %esi,%eax
c0103ece:	83 ec 08             	sub    $0x8,%esp
c0103ed1:	57                   	push   %edi
c0103ed2:	53                   	push   %ebx
c0103ed3:	51                   	push   %ecx
c0103ed4:	52                   	push   %edx
c0103ed5:	50                   	push   %eax
c0103ed6:	68 c1 67 10 c0       	push   $0xc01067c1
c0103edb:	e8 93 c3 ff ff       	call   c0100273 <cprintf>
c0103ee0:	83 c4 20             	add    $0x20,%esp
        size_t l, r = left * NPTEENTRY;
c0103ee3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ee6:	c1 e0 0a             	shl    $0xa,%eax
c0103ee9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0103eec:	eb 4f                	jmp    c0103f3d <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0103eee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ef1:	83 ec 0c             	sub    $0xc,%esp
c0103ef4:	50                   	push   %eax
c0103ef5:	e8 73 fe ff ff       	call   c0103d6d <perm2str>
c0103efa:	83 c4 10             	add    $0x10,%esp
c0103efd:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0103eff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103f02:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103f05:	29 c2                	sub    %eax,%edx
c0103f07:	89 d0                	mov    %edx,%eax
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0103f09:	c1 e0 0c             	shl    $0xc,%eax
c0103f0c:	89 c3                	mov    %eax,%ebx
c0103f0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103f11:	c1 e0 0c             	shl    $0xc,%eax
c0103f14:	89 c1                	mov    %eax,%ecx
c0103f16:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103f19:	c1 e0 0c             	shl    $0xc,%eax
c0103f1c:	89 c2                	mov    %eax,%edx
c0103f1e:	8b 75 d4             	mov    -0x2c(%ebp),%esi
c0103f21:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103f24:	29 c6                	sub    %eax,%esi
c0103f26:	89 f0                	mov    %esi,%eax
c0103f28:	83 ec 08             	sub    $0x8,%esp
c0103f2b:	57                   	push   %edi
c0103f2c:	53                   	push   %ebx
c0103f2d:	51                   	push   %ecx
c0103f2e:	52                   	push   %edx
c0103f2f:	50                   	push   %eax
c0103f30:	68 e0 67 10 c0       	push   $0xc01067e0
c0103f35:	e8 39 c3 ff ff       	call   c0100273 <cprintf>
c0103f3a:	83 c4 20             	add    $0x20,%esp
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0103f3d:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0103f42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103f45:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f48:	89 d3                	mov    %edx,%ebx
c0103f4a:	c1 e3 0a             	shl    $0xa,%ebx
c0103f4d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103f50:	89 d1                	mov    %edx,%ecx
c0103f52:	c1 e1 0a             	shl    $0xa,%ecx
c0103f55:	83 ec 08             	sub    $0x8,%esp
c0103f58:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0103f5b:	52                   	push   %edx
c0103f5c:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0103f5f:	52                   	push   %edx
c0103f60:	56                   	push   %esi
c0103f61:	50                   	push   %eax
c0103f62:	53                   	push   %ebx
c0103f63:	51                   	push   %ecx
c0103f64:	e8 52 fe ff ff       	call   c0103dbb <get_pgtable_items>
c0103f69:	83 c4 20             	add    $0x20,%esp
c0103f6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103f6f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f73:	0f 85 75 ff ff ff    	jne    c0103eee <print_pgdir+0x7f>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0103f79:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0103f7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103f81:	83 ec 08             	sub    $0x8,%esp
c0103f84:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0103f87:	52                   	push   %edx
c0103f88:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0103f8b:	52                   	push   %edx
c0103f8c:	51                   	push   %ecx
c0103f8d:	50                   	push   %eax
c0103f8e:	68 00 04 00 00       	push   $0x400
c0103f93:	6a 00                	push   $0x0
c0103f95:	e8 21 fe ff ff       	call   c0103dbb <get_pgtable_items>
c0103f9a:	83 c4 20             	add    $0x20,%esp
c0103f9d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103fa0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103fa4:	0f 85 ea fe ff ff    	jne    c0103e94 <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0103faa:	83 ec 0c             	sub    $0xc,%esp
c0103fad:	68 04 68 10 c0       	push   $0xc0106804
c0103fb2:	e8 bc c2 ff ff       	call   c0100273 <cprintf>
c0103fb7:	83 c4 10             	add    $0x10,%esp
}
c0103fba:	90                   	nop
c0103fbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0103fbe:	5b                   	pop    %ebx
c0103fbf:	5e                   	pop    %esi
c0103fc0:	5f                   	pop    %edi
c0103fc1:	5d                   	pop    %ebp
c0103fc2:	c3                   	ret    

c0103fc3 <page2ppn>:
page2ppn(struct Page *page) {
c0103fc3:	55                   	push   %ebp
c0103fc4:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103fc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0103fc9:	8b 15 18 af 11 c0    	mov    0xc011af18,%edx
c0103fcf:	29 d0                	sub    %edx,%eax
c0103fd1:	c1 f8 02             	sar    $0x2,%eax
c0103fd4:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103fda:	5d                   	pop    %ebp
c0103fdb:	c3                   	ret    

c0103fdc <page2pa>:
page2pa(struct Page *page) {
c0103fdc:	55                   	push   %ebp
c0103fdd:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0103fdf:	ff 75 08             	pushl  0x8(%ebp)
c0103fe2:	e8 dc ff ff ff       	call   c0103fc3 <page2ppn>
c0103fe7:	83 c4 04             	add    $0x4,%esp
c0103fea:	c1 e0 0c             	shl    $0xc,%eax
}
c0103fed:	c9                   	leave  
c0103fee:	c3                   	ret    

c0103fef <page_ref>:
page_ref(struct Page *page) {
c0103fef:	55                   	push   %ebp
c0103ff0:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103ff2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ff5:	8b 00                	mov    (%eax),%eax
}
c0103ff7:	5d                   	pop    %ebp
c0103ff8:	c3                   	ret    

c0103ff9 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c0103ff9:	55                   	push   %ebp
c0103ffa:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103ffc:	8b 45 08             	mov    0x8(%ebp),%eax
c0103fff:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104002:	89 10                	mov    %edx,(%eax)
}
c0104004:	90                   	nop
c0104005:	5d                   	pop    %ebp
c0104006:	c3                   	ret    

c0104007 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0104007:	55                   	push   %ebp
c0104008:	89 e5                	mov    %esp,%ebp
c010400a:	83 ec 10             	sub    $0x10,%esp
c010400d:	c7 45 fc 1c af 11 c0 	movl   $0xc011af1c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104014:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104017:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010401a:	89 50 04             	mov    %edx,0x4(%eax)
c010401d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104020:	8b 50 04             	mov    0x4(%eax),%edx
c0104023:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104026:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0104028:	c7 05 24 af 11 c0 00 	movl   $0x0,0xc011af24
c010402f:	00 00 00 
}
c0104032:	90                   	nop
c0104033:	c9                   	leave  
c0104034:	c3                   	ret    

c0104035 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0104035:	55                   	push   %ebp
c0104036:	89 e5                	mov    %esp,%ebp
c0104038:	83 ec 38             	sub    $0x38,%esp
    assert(n > 0);
c010403b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010403f:	75 16                	jne    c0104057 <default_init_memmap+0x22>
c0104041:	68 38 68 10 c0       	push   $0xc0106838
c0104046:	68 3e 68 10 c0       	push   $0xc010683e
c010404b:	6a 6d                	push   $0x6d
c010404d:	68 53 68 10 c0       	push   $0xc0106853
c0104052:	e8 82 c3 ff ff       	call   c01003d9 <__panic>
    struct Page *p = base;
c0104057:	8b 45 08             	mov    0x8(%ebp),%eax
c010405a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c010405d:	eb 6c                	jmp    c01040cb <default_init_memmap+0x96>
        assert(PageReserved(p));
c010405f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104062:	83 c0 04             	add    $0x4,%eax
c0104065:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c010406c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010406f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104072:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104075:	0f a3 10             	bt     %edx,(%eax)
c0104078:	19 c0                	sbb    %eax,%eax
c010407a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c010407d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104081:	0f 95 c0             	setne  %al
c0104084:	0f b6 c0             	movzbl %al,%eax
c0104087:	85 c0                	test   %eax,%eax
c0104089:	75 16                	jne    c01040a1 <default_init_memmap+0x6c>
c010408b:	68 69 68 10 c0       	push   $0xc0106869
c0104090:	68 3e 68 10 c0       	push   $0xc010683e
c0104095:	6a 70                	push   $0x70
c0104097:	68 53 68 10 c0       	push   $0xc0106853
c010409c:	e8 38 c3 ff ff       	call   c01003d9 <__panic>
        p->flags = p->property = 0;
c01040a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040a4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01040ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040ae:	8b 50 08             	mov    0x8(%eax),%edx
c01040b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040b4:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01040b7:	83 ec 08             	sub    $0x8,%esp
c01040ba:	6a 00                	push   $0x0
c01040bc:	ff 75 f4             	pushl  -0xc(%ebp)
c01040bf:	e8 35 ff ff ff       	call   c0103ff9 <set_page_ref>
c01040c4:	83 c4 10             	add    $0x10,%esp
    for (; p != base + n; p ++) {
c01040c7:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01040cb:	8b 55 0c             	mov    0xc(%ebp),%edx
c01040ce:	89 d0                	mov    %edx,%eax
c01040d0:	c1 e0 02             	shl    $0x2,%eax
c01040d3:	01 d0                	add    %edx,%eax
c01040d5:	c1 e0 02             	shl    $0x2,%eax
c01040d8:	89 c2                	mov    %eax,%edx
c01040da:	8b 45 08             	mov    0x8(%ebp),%eax
c01040dd:	01 d0                	add    %edx,%eax
c01040df:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01040e2:	0f 85 77 ff ff ff    	jne    c010405f <default_init_memmap+0x2a>
    }
    base->property = n;
c01040e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01040eb:	8b 55 0c             	mov    0xc(%ebp),%edx
c01040ee:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01040f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01040f4:	83 c0 04             	add    $0x4,%eax
c01040f7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01040fe:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104101:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104104:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104107:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c010410a:	8b 15 24 af 11 c0    	mov    0xc011af24,%edx
c0104110:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104113:	01 d0                	add    %edx,%eax
c0104115:	a3 24 af 11 c0       	mov    %eax,0xc011af24
    list_add_before(&free_list, &(base->page_link));
c010411a:	8b 45 08             	mov    0x8(%ebp),%eax
c010411d:	83 c0 0c             	add    $0xc,%eax
c0104120:	c7 45 e4 1c af 11 c0 	movl   $0xc011af1c,-0x1c(%ebp)
c0104127:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010412a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010412d:	8b 00                	mov    (%eax),%eax
c010412f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104132:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0104135:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104138:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010413b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010413e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104141:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104144:	89 10                	mov    %edx,(%eax)
c0104146:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104149:	8b 10                	mov    (%eax),%edx
c010414b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010414e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104151:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104154:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104157:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010415a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010415d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104160:	89 10                	mov    %edx,(%eax)
}
c0104162:	90                   	nop
c0104163:	c9                   	leave  
c0104164:	c3                   	ret    

c0104165 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0104165:	55                   	push   %ebp
c0104166:	89 e5                	mov    %esp,%ebp
c0104168:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c010416b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010416f:	75 16                	jne    c0104187 <default_alloc_pages+0x22>
c0104171:	68 38 68 10 c0       	push   $0xc0106838
c0104176:	68 3e 68 10 c0       	push   $0xc010683e
c010417b:	6a 7c                	push   $0x7c
c010417d:	68 53 68 10 c0       	push   $0xc0106853
c0104182:	e8 52 c2 ff ff       	call   c01003d9 <__panic>
    if (n > nr_free) {
c0104187:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c010418c:	39 45 08             	cmp    %eax,0x8(%ebp)
c010418f:	76 0a                	jbe    c010419b <default_alloc_pages+0x36>
        return NULL;
c0104191:	b8 00 00 00 00       	mov    $0x0,%eax
c0104196:	e9 3d 01 00 00       	jmp    c01042d8 <default_alloc_pages+0x173>
    }
    struct Page *page = NULL;
c010419b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c01041a2:	c7 45 f0 1c af 11 c0 	movl   $0xc011af1c,-0x10(%ebp)
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
c01041a9:	eb 1c                	jmp    c01041c7 <default_alloc_pages+0x62>
        struct Page *p = le2page(le, page_link);
c01041ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041ae:	83 e8 0c             	sub    $0xc,%eax
c01041b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c01041b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01041b7:	8b 40 08             	mov    0x8(%eax),%eax
c01041ba:	39 45 08             	cmp    %eax,0x8(%ebp)
c01041bd:	77 08                	ja     c01041c7 <default_alloc_pages+0x62>
            page = p;
c01041bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01041c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c01041c5:	eb 18                	jmp    c01041df <default_alloc_pages+0x7a>
c01041c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c01041cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01041d0:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01041d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01041d6:	81 7d f0 1c af 11 c0 	cmpl   $0xc011af1c,-0x10(%ebp)
c01041dd:	75 cc                	jne    c01041ab <default_alloc_pages+0x46>
        }
    }
    if (page != NULL) {
c01041df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01041e3:	0f 84 ec 00 00 00    	je     c01042d5 <default_alloc_pages+0x170>
        if (page->property > n) {
c01041e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041ec:	8b 40 08             	mov    0x8(%eax),%eax
c01041ef:	39 45 08             	cmp    %eax,0x8(%ebp)
c01041f2:	0f 83 8c 00 00 00    	jae    c0104284 <default_alloc_pages+0x11f>
            struct Page *p = page + n;
c01041f8:	8b 55 08             	mov    0x8(%ebp),%edx
c01041fb:	89 d0                	mov    %edx,%eax
c01041fd:	c1 e0 02             	shl    $0x2,%eax
c0104200:	01 d0                	add    %edx,%eax
c0104202:	c1 e0 02             	shl    $0x2,%eax
c0104205:	89 c2                	mov    %eax,%edx
c0104207:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010420a:	01 d0                	add    %edx,%eax
c010420c:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c010420f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104212:	8b 40 08             	mov    0x8(%eax),%eax
c0104215:	2b 45 08             	sub    0x8(%ebp),%eax
c0104218:	89 c2                	mov    %eax,%edx
c010421a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010421d:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c0104220:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104223:	83 c0 04             	add    $0x4,%eax
c0104226:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c010422d:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104230:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104233:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104236:	0f ab 10             	bts    %edx,(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
c0104239:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010423c:	83 c0 0c             	add    $0xc,%eax
c010423f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104242:	83 c2 0c             	add    $0xc,%edx
c0104245:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0104248:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
c010424b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010424e:	8b 40 04             	mov    0x4(%eax),%eax
c0104251:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104254:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0104257:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010425a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010425d:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
c0104260:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104263:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104266:	89 10                	mov    %edx,(%eax)
c0104268:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010426b:	8b 10                	mov    (%eax),%edx
c010426d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104270:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104273:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104276:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104279:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010427c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010427f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104282:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
c0104284:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104287:	83 c0 0c             	add    $0xc,%eax
c010428a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c010428d:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104290:	8b 40 04             	mov    0x4(%eax),%eax
c0104293:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104296:	8b 12                	mov    (%edx),%edx
c0104298:	89 55 b8             	mov    %edx,-0x48(%ebp)
c010429b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010429e:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01042a1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01042a4:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01042a7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01042aa:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01042ad:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c01042af:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c01042b4:	2b 45 08             	sub    0x8(%ebp),%eax
c01042b7:	a3 24 af 11 c0       	mov    %eax,0xc011af24
        ClearPageProperty(page);
c01042bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042bf:	83 c0 04             	add    $0x4,%eax
c01042c2:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c01042c9:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01042cc:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01042cf:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01042d2:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c01042d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01042d8:	c9                   	leave  
c01042d9:	c3                   	ret    

c01042da <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c01042da:	55                   	push   %ebp
c01042db:	89 e5                	mov    %esp,%ebp
c01042dd:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c01042e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01042e7:	75 19                	jne    c0104302 <default_free_pages+0x28>
c01042e9:	68 38 68 10 c0       	push   $0xc0106838
c01042ee:	68 3e 68 10 c0       	push   $0xc010683e
c01042f3:	68 9a 00 00 00       	push   $0x9a
c01042f8:	68 53 68 10 c0       	push   $0xc0106853
c01042fd:	e8 d7 c0 ff ff       	call   c01003d9 <__panic>
    struct Page *p = base;
c0104302:	8b 45 08             	mov    0x8(%ebp),%eax
c0104305:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0104308:	e9 8f 00 00 00       	jmp    c010439c <default_free_pages+0xc2>
        assert(!PageReserved(p) && !PageProperty(p));
c010430d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104310:	83 c0 04             	add    $0x4,%eax
c0104313:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010431a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010431d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104320:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104323:	0f a3 10             	bt     %edx,(%eax)
c0104326:	19 c0                	sbb    %eax,%eax
c0104328:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c010432b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010432f:	0f 95 c0             	setne  %al
c0104332:	0f b6 c0             	movzbl %al,%eax
c0104335:	85 c0                	test   %eax,%eax
c0104337:	75 2c                	jne    c0104365 <default_free_pages+0x8b>
c0104339:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010433c:	83 c0 04             	add    $0x4,%eax
c010433f:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0104346:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104349:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010434c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010434f:	0f a3 10             	bt     %edx,(%eax)
c0104352:	19 c0                	sbb    %eax,%eax
c0104354:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0104357:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c010435b:	0f 95 c0             	setne  %al
c010435e:	0f b6 c0             	movzbl %al,%eax
c0104361:	85 c0                	test   %eax,%eax
c0104363:	74 19                	je     c010437e <default_free_pages+0xa4>
c0104365:	68 7c 68 10 c0       	push   $0xc010687c
c010436a:	68 3e 68 10 c0       	push   $0xc010683e
c010436f:	68 9d 00 00 00       	push   $0x9d
c0104374:	68 53 68 10 c0       	push   $0xc0106853
c0104379:	e8 5b c0 ff ff       	call   c01003d9 <__panic>
        p->flags = 0;
c010437e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104381:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0104388:	83 ec 08             	sub    $0x8,%esp
c010438b:	6a 00                	push   $0x0
c010438d:	ff 75 f4             	pushl  -0xc(%ebp)
c0104390:	e8 64 fc ff ff       	call   c0103ff9 <set_page_ref>
c0104395:	83 c4 10             	add    $0x10,%esp
    for (; p != base + n; p ++) {
c0104398:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c010439c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010439f:	89 d0                	mov    %edx,%eax
c01043a1:	c1 e0 02             	shl    $0x2,%eax
c01043a4:	01 d0                	add    %edx,%eax
c01043a6:	c1 e0 02             	shl    $0x2,%eax
c01043a9:	89 c2                	mov    %eax,%edx
c01043ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01043ae:	01 d0                	add    %edx,%eax
c01043b0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01043b3:	0f 85 54 ff ff ff    	jne    c010430d <default_free_pages+0x33>
    }
    base->property = n;
c01043b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01043bc:	8b 55 0c             	mov    0xc(%ebp),%edx
c01043bf:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01043c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01043c5:	83 c0 04             	add    $0x4,%eax
c01043c8:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01043cf:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01043d2:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01043d5:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01043d8:	0f ab 10             	bts    %edx,(%eax)
c01043db:	c7 45 d4 1c af 11 c0 	movl   $0xc011af1c,-0x2c(%ebp)
    return listelm->next;
c01043e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01043e5:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c01043e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c01043eb:	e9 08 01 00 00       	jmp    c01044f8 <default_free_pages+0x21e>
        p = le2page(le, page_link);
c01043f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043f3:	83 e8 0c             	sub    $0xc,%eax
c01043f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01043f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043fc:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01043ff:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104402:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0104405:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // TODO: optimize
        if (base + base->property == p) {
c0104408:	8b 45 08             	mov    0x8(%ebp),%eax
c010440b:	8b 50 08             	mov    0x8(%eax),%edx
c010440e:	89 d0                	mov    %edx,%eax
c0104410:	c1 e0 02             	shl    $0x2,%eax
c0104413:	01 d0                	add    %edx,%eax
c0104415:	c1 e0 02             	shl    $0x2,%eax
c0104418:	89 c2                	mov    %eax,%edx
c010441a:	8b 45 08             	mov    0x8(%ebp),%eax
c010441d:	01 d0                	add    %edx,%eax
c010441f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104422:	75 5a                	jne    c010447e <default_free_pages+0x1a4>
            base->property += p->property;
c0104424:	8b 45 08             	mov    0x8(%ebp),%eax
c0104427:	8b 50 08             	mov    0x8(%eax),%edx
c010442a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010442d:	8b 40 08             	mov    0x8(%eax),%eax
c0104430:	01 c2                	add    %eax,%edx
c0104432:	8b 45 08             	mov    0x8(%ebp),%eax
c0104435:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0104438:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010443b:	83 c0 04             	add    $0x4,%eax
c010443e:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0104445:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104448:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010444b:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010444e:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0104451:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104454:	83 c0 0c             	add    $0xc,%eax
c0104457:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c010445a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010445d:	8b 40 04             	mov    0x4(%eax),%eax
c0104460:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104463:	8b 12                	mov    (%edx),%edx
c0104465:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0104468:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c010446b:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010446e:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104471:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104474:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104477:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010447a:	89 10                	mov    %edx,(%eax)
c010447c:	eb 7a                	jmp    c01044f8 <default_free_pages+0x21e>
        }
        else if (p + p->property == base) {
c010447e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104481:	8b 50 08             	mov    0x8(%eax),%edx
c0104484:	89 d0                	mov    %edx,%eax
c0104486:	c1 e0 02             	shl    $0x2,%eax
c0104489:	01 d0                	add    %edx,%eax
c010448b:	c1 e0 02             	shl    $0x2,%eax
c010448e:	89 c2                	mov    %eax,%edx
c0104490:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104493:	01 d0                	add    %edx,%eax
c0104495:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104498:	75 5e                	jne    c01044f8 <default_free_pages+0x21e>
            p->property += base->property;
c010449a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010449d:	8b 50 08             	mov    0x8(%eax),%edx
c01044a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01044a3:	8b 40 08             	mov    0x8(%eax),%eax
c01044a6:	01 c2                	add    %eax,%edx
c01044a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044ab:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c01044ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01044b1:	83 c0 04             	add    $0x4,%eax
c01044b4:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c01044bb:	89 45 a0             	mov    %eax,-0x60(%ebp)
c01044be:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01044c1:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01044c4:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c01044c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044ca:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c01044cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044d0:	83 c0 0c             	add    $0xc,%eax
c01044d3:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c01044d6:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01044d9:	8b 40 04             	mov    0x4(%eax),%eax
c01044dc:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01044df:	8b 12                	mov    (%edx),%edx
c01044e1:	89 55 ac             	mov    %edx,-0x54(%ebp)
c01044e4:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c01044e7:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01044ea:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01044ed:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01044f0:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01044f3:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01044f6:	89 10                	mov    %edx,(%eax)
    while (le != &free_list) {
c01044f8:	81 7d f0 1c af 11 c0 	cmpl   $0xc011af1c,-0x10(%ebp)
c01044ff:	0f 85 eb fe ff ff    	jne    c01043f0 <default_free_pages+0x116>
        }
    }
    nr_free += n;
c0104505:	8b 15 24 af 11 c0    	mov    0xc011af24,%edx
c010450b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010450e:	01 d0                	add    %edx,%eax
c0104510:	a3 24 af 11 c0       	mov    %eax,0xc011af24
c0104515:	c7 45 9c 1c af 11 c0 	movl   $0xc011af1c,-0x64(%ebp)
    return listelm->next;
c010451c:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010451f:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c0104522:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104525:	eb 69                	jmp    c0104590 <default_free_pages+0x2b6>
        p = le2page(le, page_link);
c0104527:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010452a:	83 e8 0c             	sub    $0xc,%eax
c010452d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c0104530:	8b 45 08             	mov    0x8(%ebp),%eax
c0104533:	8b 50 08             	mov    0x8(%eax),%edx
c0104536:	89 d0                	mov    %edx,%eax
c0104538:	c1 e0 02             	shl    $0x2,%eax
c010453b:	01 d0                	add    %edx,%eax
c010453d:	c1 e0 02             	shl    $0x2,%eax
c0104540:	89 c2                	mov    %eax,%edx
c0104542:	8b 45 08             	mov    0x8(%ebp),%eax
c0104545:	01 d0                	add    %edx,%eax
c0104547:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010454a:	72 35                	jb     c0104581 <default_free_pages+0x2a7>
            assert(base + base->property != p);
c010454c:	8b 45 08             	mov    0x8(%ebp),%eax
c010454f:	8b 50 08             	mov    0x8(%eax),%edx
c0104552:	89 d0                	mov    %edx,%eax
c0104554:	c1 e0 02             	shl    $0x2,%eax
c0104557:	01 d0                	add    %edx,%eax
c0104559:	c1 e0 02             	shl    $0x2,%eax
c010455c:	89 c2                	mov    %eax,%edx
c010455e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104561:	01 d0                	add    %edx,%eax
c0104563:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104566:	75 33                	jne    c010459b <default_free_pages+0x2c1>
c0104568:	68 a1 68 10 c0       	push   $0xc01068a1
c010456d:	68 3e 68 10 c0       	push   $0xc010683e
c0104572:	68 b9 00 00 00       	push   $0xb9
c0104577:	68 53 68 10 c0       	push   $0xc0106853
c010457c:	e8 58 be ff ff       	call   c01003d9 <__panic>
c0104581:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104584:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104587:	8b 45 98             	mov    -0x68(%ebp),%eax
c010458a:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c010458d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104590:	81 7d f0 1c af 11 c0 	cmpl   $0xc011af1c,-0x10(%ebp)
c0104597:	75 8e                	jne    c0104527 <default_free_pages+0x24d>
c0104599:	eb 01                	jmp    c010459c <default_free_pages+0x2c2>
            break;
c010459b:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
c010459c:	8b 45 08             	mov    0x8(%ebp),%eax
c010459f:	8d 50 0c             	lea    0xc(%eax),%edx
c01045a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045a5:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01045a8:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c01045ab:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01045ae:	8b 00                	mov    (%eax),%eax
c01045b0:	8b 55 90             	mov    -0x70(%ebp),%edx
c01045b3:	89 55 8c             	mov    %edx,-0x74(%ebp)
c01045b6:	89 45 88             	mov    %eax,-0x78(%ebp)
c01045b9:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01045bc:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c01045bf:	8b 45 84             	mov    -0x7c(%ebp),%eax
c01045c2:	8b 55 8c             	mov    -0x74(%ebp),%edx
c01045c5:	89 10                	mov    %edx,(%eax)
c01045c7:	8b 45 84             	mov    -0x7c(%ebp),%eax
c01045ca:	8b 10                	mov    (%eax),%edx
c01045cc:	8b 45 88             	mov    -0x78(%ebp),%eax
c01045cf:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01045d2:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01045d5:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01045d8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01045db:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01045de:	8b 55 88             	mov    -0x78(%ebp),%edx
c01045e1:	89 10                	mov    %edx,(%eax)
}
c01045e3:	90                   	nop
c01045e4:	c9                   	leave  
c01045e5:	c3                   	ret    

c01045e6 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c01045e6:	55                   	push   %ebp
c01045e7:	89 e5                	mov    %esp,%ebp
    return nr_free;
c01045e9:	a1 24 af 11 c0       	mov    0xc011af24,%eax
}
c01045ee:	5d                   	pop    %ebp
c01045ef:	c3                   	ret    

c01045f0 <basic_check>:

static void
basic_check(void) {
c01045f0:	55                   	push   %ebp
c01045f1:	89 e5                	mov    %esp,%ebp
c01045f3:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c01045f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01045fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104600:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104603:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104606:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0104609:	83 ec 0c             	sub    $0xc,%esp
c010460c:	6a 01                	push   $0x1
c010460e:	e8 67 e5 ff ff       	call   c0102b7a <alloc_pages>
c0104613:	83 c4 10             	add    $0x10,%esp
c0104616:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104619:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010461d:	75 19                	jne    c0104638 <basic_check+0x48>
c010461f:	68 bc 68 10 c0       	push   $0xc01068bc
c0104624:	68 3e 68 10 c0       	push   $0xc010683e
c0104629:	68 ca 00 00 00       	push   $0xca
c010462e:	68 53 68 10 c0       	push   $0xc0106853
c0104633:	e8 a1 bd ff ff       	call   c01003d9 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104638:	83 ec 0c             	sub    $0xc,%esp
c010463b:	6a 01                	push   $0x1
c010463d:	e8 38 e5 ff ff       	call   c0102b7a <alloc_pages>
c0104642:	83 c4 10             	add    $0x10,%esp
c0104645:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104648:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010464c:	75 19                	jne    c0104667 <basic_check+0x77>
c010464e:	68 d8 68 10 c0       	push   $0xc01068d8
c0104653:	68 3e 68 10 c0       	push   $0xc010683e
c0104658:	68 cb 00 00 00       	push   $0xcb
c010465d:	68 53 68 10 c0       	push   $0xc0106853
c0104662:	e8 72 bd ff ff       	call   c01003d9 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104667:	83 ec 0c             	sub    $0xc,%esp
c010466a:	6a 01                	push   $0x1
c010466c:	e8 09 e5 ff ff       	call   c0102b7a <alloc_pages>
c0104671:	83 c4 10             	add    $0x10,%esp
c0104674:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104677:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010467b:	75 19                	jne    c0104696 <basic_check+0xa6>
c010467d:	68 f4 68 10 c0       	push   $0xc01068f4
c0104682:	68 3e 68 10 c0       	push   $0xc010683e
c0104687:	68 cc 00 00 00       	push   $0xcc
c010468c:	68 53 68 10 c0       	push   $0xc0106853
c0104691:	e8 43 bd ff ff       	call   c01003d9 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0104696:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104699:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010469c:	74 10                	je     c01046ae <basic_check+0xbe>
c010469e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046a1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01046a4:	74 08                	je     c01046ae <basic_check+0xbe>
c01046a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046a9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01046ac:	75 19                	jne    c01046c7 <basic_check+0xd7>
c01046ae:	68 10 69 10 c0       	push   $0xc0106910
c01046b3:	68 3e 68 10 c0       	push   $0xc010683e
c01046b8:	68 ce 00 00 00       	push   $0xce
c01046bd:	68 53 68 10 c0       	push   $0xc0106853
c01046c2:	e8 12 bd ff ff       	call   c01003d9 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c01046c7:	83 ec 0c             	sub    $0xc,%esp
c01046ca:	ff 75 ec             	pushl  -0x14(%ebp)
c01046cd:	e8 1d f9 ff ff       	call   c0103fef <page_ref>
c01046d2:	83 c4 10             	add    $0x10,%esp
c01046d5:	85 c0                	test   %eax,%eax
c01046d7:	75 24                	jne    c01046fd <basic_check+0x10d>
c01046d9:	83 ec 0c             	sub    $0xc,%esp
c01046dc:	ff 75 f0             	pushl  -0x10(%ebp)
c01046df:	e8 0b f9 ff ff       	call   c0103fef <page_ref>
c01046e4:	83 c4 10             	add    $0x10,%esp
c01046e7:	85 c0                	test   %eax,%eax
c01046e9:	75 12                	jne    c01046fd <basic_check+0x10d>
c01046eb:	83 ec 0c             	sub    $0xc,%esp
c01046ee:	ff 75 f4             	pushl  -0xc(%ebp)
c01046f1:	e8 f9 f8 ff ff       	call   c0103fef <page_ref>
c01046f6:	83 c4 10             	add    $0x10,%esp
c01046f9:	85 c0                	test   %eax,%eax
c01046fb:	74 19                	je     c0104716 <basic_check+0x126>
c01046fd:	68 34 69 10 c0       	push   $0xc0106934
c0104702:	68 3e 68 10 c0       	push   $0xc010683e
c0104707:	68 cf 00 00 00       	push   $0xcf
c010470c:	68 53 68 10 c0       	push   $0xc0106853
c0104711:	e8 c3 bc ff ff       	call   c01003d9 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0104716:	83 ec 0c             	sub    $0xc,%esp
c0104719:	ff 75 ec             	pushl  -0x14(%ebp)
c010471c:	e8 bb f8 ff ff       	call   c0103fdc <page2pa>
c0104721:	83 c4 10             	add    $0x10,%esp
c0104724:	89 c2                	mov    %eax,%edx
c0104726:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c010472b:	c1 e0 0c             	shl    $0xc,%eax
c010472e:	39 c2                	cmp    %eax,%edx
c0104730:	72 19                	jb     c010474b <basic_check+0x15b>
c0104732:	68 70 69 10 c0       	push   $0xc0106970
c0104737:	68 3e 68 10 c0       	push   $0xc010683e
c010473c:	68 d1 00 00 00       	push   $0xd1
c0104741:	68 53 68 10 c0       	push   $0xc0106853
c0104746:	e8 8e bc ff ff       	call   c01003d9 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c010474b:	83 ec 0c             	sub    $0xc,%esp
c010474e:	ff 75 f0             	pushl  -0x10(%ebp)
c0104751:	e8 86 f8 ff ff       	call   c0103fdc <page2pa>
c0104756:	83 c4 10             	add    $0x10,%esp
c0104759:	89 c2                	mov    %eax,%edx
c010475b:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104760:	c1 e0 0c             	shl    $0xc,%eax
c0104763:	39 c2                	cmp    %eax,%edx
c0104765:	72 19                	jb     c0104780 <basic_check+0x190>
c0104767:	68 8d 69 10 c0       	push   $0xc010698d
c010476c:	68 3e 68 10 c0       	push   $0xc010683e
c0104771:	68 d2 00 00 00       	push   $0xd2
c0104776:	68 53 68 10 c0       	push   $0xc0106853
c010477b:	e8 59 bc ff ff       	call   c01003d9 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0104780:	83 ec 0c             	sub    $0xc,%esp
c0104783:	ff 75 f4             	pushl  -0xc(%ebp)
c0104786:	e8 51 f8 ff ff       	call   c0103fdc <page2pa>
c010478b:	83 c4 10             	add    $0x10,%esp
c010478e:	89 c2                	mov    %eax,%edx
c0104790:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104795:	c1 e0 0c             	shl    $0xc,%eax
c0104798:	39 c2                	cmp    %eax,%edx
c010479a:	72 19                	jb     c01047b5 <basic_check+0x1c5>
c010479c:	68 aa 69 10 c0       	push   $0xc01069aa
c01047a1:	68 3e 68 10 c0       	push   $0xc010683e
c01047a6:	68 d3 00 00 00       	push   $0xd3
c01047ab:	68 53 68 10 c0       	push   $0xc0106853
c01047b0:	e8 24 bc ff ff       	call   c01003d9 <__panic>

    list_entry_t free_list_store = free_list;
c01047b5:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c01047ba:	8b 15 20 af 11 c0    	mov    0xc011af20,%edx
c01047c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01047c3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01047c6:	c7 45 dc 1c af 11 c0 	movl   $0xc011af1c,-0x24(%ebp)
    elm->prev = elm->next = elm;
c01047cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01047d0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01047d3:	89 50 04             	mov    %edx,0x4(%eax)
c01047d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01047d9:	8b 50 04             	mov    0x4(%eax),%edx
c01047dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01047df:	89 10                	mov    %edx,(%eax)
c01047e1:	c7 45 e0 1c af 11 c0 	movl   $0xc011af1c,-0x20(%ebp)
    return list->next == list;
c01047e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01047eb:	8b 40 04             	mov    0x4(%eax),%eax
c01047ee:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01047f1:	0f 94 c0             	sete   %al
c01047f4:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01047f7:	85 c0                	test   %eax,%eax
c01047f9:	75 19                	jne    c0104814 <basic_check+0x224>
c01047fb:	68 c7 69 10 c0       	push   $0xc01069c7
c0104800:	68 3e 68 10 c0       	push   $0xc010683e
c0104805:	68 d7 00 00 00       	push   $0xd7
c010480a:	68 53 68 10 c0       	push   $0xc0106853
c010480f:	e8 c5 bb ff ff       	call   c01003d9 <__panic>

    unsigned int nr_free_store = nr_free;
c0104814:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c0104819:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c010481c:	c7 05 24 af 11 c0 00 	movl   $0x0,0xc011af24
c0104823:	00 00 00 

    assert(alloc_page() == NULL);
c0104826:	83 ec 0c             	sub    $0xc,%esp
c0104829:	6a 01                	push   $0x1
c010482b:	e8 4a e3 ff ff       	call   c0102b7a <alloc_pages>
c0104830:	83 c4 10             	add    $0x10,%esp
c0104833:	85 c0                	test   %eax,%eax
c0104835:	74 19                	je     c0104850 <basic_check+0x260>
c0104837:	68 de 69 10 c0       	push   $0xc01069de
c010483c:	68 3e 68 10 c0       	push   $0xc010683e
c0104841:	68 dc 00 00 00       	push   $0xdc
c0104846:	68 53 68 10 c0       	push   $0xc0106853
c010484b:	e8 89 bb ff ff       	call   c01003d9 <__panic>

    free_page(p0);
c0104850:	83 ec 08             	sub    $0x8,%esp
c0104853:	6a 01                	push   $0x1
c0104855:	ff 75 ec             	pushl  -0x14(%ebp)
c0104858:	e8 5b e3 ff ff       	call   c0102bb8 <free_pages>
c010485d:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0104860:	83 ec 08             	sub    $0x8,%esp
c0104863:	6a 01                	push   $0x1
c0104865:	ff 75 f0             	pushl  -0x10(%ebp)
c0104868:	e8 4b e3 ff ff       	call   c0102bb8 <free_pages>
c010486d:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104870:	83 ec 08             	sub    $0x8,%esp
c0104873:	6a 01                	push   $0x1
c0104875:	ff 75 f4             	pushl  -0xc(%ebp)
c0104878:	e8 3b e3 ff ff       	call   c0102bb8 <free_pages>
c010487d:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c0104880:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c0104885:	83 f8 03             	cmp    $0x3,%eax
c0104888:	74 19                	je     c01048a3 <basic_check+0x2b3>
c010488a:	68 f3 69 10 c0       	push   $0xc01069f3
c010488f:	68 3e 68 10 c0       	push   $0xc010683e
c0104894:	68 e1 00 00 00       	push   $0xe1
c0104899:	68 53 68 10 c0       	push   $0xc0106853
c010489e:	e8 36 bb ff ff       	call   c01003d9 <__panic>

    assert((p0 = alloc_page()) != NULL);
c01048a3:	83 ec 0c             	sub    $0xc,%esp
c01048a6:	6a 01                	push   $0x1
c01048a8:	e8 cd e2 ff ff       	call   c0102b7a <alloc_pages>
c01048ad:	83 c4 10             	add    $0x10,%esp
c01048b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01048b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01048b7:	75 19                	jne    c01048d2 <basic_check+0x2e2>
c01048b9:	68 bc 68 10 c0       	push   $0xc01068bc
c01048be:	68 3e 68 10 c0       	push   $0xc010683e
c01048c3:	68 e3 00 00 00       	push   $0xe3
c01048c8:	68 53 68 10 c0       	push   $0xc0106853
c01048cd:	e8 07 bb ff ff       	call   c01003d9 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01048d2:	83 ec 0c             	sub    $0xc,%esp
c01048d5:	6a 01                	push   $0x1
c01048d7:	e8 9e e2 ff ff       	call   c0102b7a <alloc_pages>
c01048dc:	83 c4 10             	add    $0x10,%esp
c01048df:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01048e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01048e6:	75 19                	jne    c0104901 <basic_check+0x311>
c01048e8:	68 d8 68 10 c0       	push   $0xc01068d8
c01048ed:	68 3e 68 10 c0       	push   $0xc010683e
c01048f2:	68 e4 00 00 00       	push   $0xe4
c01048f7:	68 53 68 10 c0       	push   $0xc0106853
c01048fc:	e8 d8 ba ff ff       	call   c01003d9 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104901:	83 ec 0c             	sub    $0xc,%esp
c0104904:	6a 01                	push   $0x1
c0104906:	e8 6f e2 ff ff       	call   c0102b7a <alloc_pages>
c010490b:	83 c4 10             	add    $0x10,%esp
c010490e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104911:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104915:	75 19                	jne    c0104930 <basic_check+0x340>
c0104917:	68 f4 68 10 c0       	push   $0xc01068f4
c010491c:	68 3e 68 10 c0       	push   $0xc010683e
c0104921:	68 e5 00 00 00       	push   $0xe5
c0104926:	68 53 68 10 c0       	push   $0xc0106853
c010492b:	e8 a9 ba ff ff       	call   c01003d9 <__panic>

    assert(alloc_page() == NULL);
c0104930:	83 ec 0c             	sub    $0xc,%esp
c0104933:	6a 01                	push   $0x1
c0104935:	e8 40 e2 ff ff       	call   c0102b7a <alloc_pages>
c010493a:	83 c4 10             	add    $0x10,%esp
c010493d:	85 c0                	test   %eax,%eax
c010493f:	74 19                	je     c010495a <basic_check+0x36a>
c0104941:	68 de 69 10 c0       	push   $0xc01069de
c0104946:	68 3e 68 10 c0       	push   $0xc010683e
c010494b:	68 e7 00 00 00       	push   $0xe7
c0104950:	68 53 68 10 c0       	push   $0xc0106853
c0104955:	e8 7f ba ff ff       	call   c01003d9 <__panic>

    free_page(p0);
c010495a:	83 ec 08             	sub    $0x8,%esp
c010495d:	6a 01                	push   $0x1
c010495f:	ff 75 ec             	pushl  -0x14(%ebp)
c0104962:	e8 51 e2 ff ff       	call   c0102bb8 <free_pages>
c0104967:	83 c4 10             	add    $0x10,%esp
c010496a:	c7 45 d8 1c af 11 c0 	movl   $0xc011af1c,-0x28(%ebp)
c0104971:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104974:	8b 40 04             	mov    0x4(%eax),%eax
c0104977:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010497a:	0f 94 c0             	sete   %al
c010497d:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0104980:	85 c0                	test   %eax,%eax
c0104982:	74 19                	je     c010499d <basic_check+0x3ad>
c0104984:	68 00 6a 10 c0       	push   $0xc0106a00
c0104989:	68 3e 68 10 c0       	push   $0xc010683e
c010498e:	68 ea 00 00 00       	push   $0xea
c0104993:	68 53 68 10 c0       	push   $0xc0106853
c0104998:	e8 3c ba ff ff       	call   c01003d9 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010499d:	83 ec 0c             	sub    $0xc,%esp
c01049a0:	6a 01                	push   $0x1
c01049a2:	e8 d3 e1 ff ff       	call   c0102b7a <alloc_pages>
c01049a7:	83 c4 10             	add    $0x10,%esp
c01049aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01049ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01049b0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01049b3:	74 19                	je     c01049ce <basic_check+0x3de>
c01049b5:	68 18 6a 10 c0       	push   $0xc0106a18
c01049ba:	68 3e 68 10 c0       	push   $0xc010683e
c01049bf:	68 ed 00 00 00       	push   $0xed
c01049c4:	68 53 68 10 c0       	push   $0xc0106853
c01049c9:	e8 0b ba ff ff       	call   c01003d9 <__panic>
    assert(alloc_page() == NULL);
c01049ce:	83 ec 0c             	sub    $0xc,%esp
c01049d1:	6a 01                	push   $0x1
c01049d3:	e8 a2 e1 ff ff       	call   c0102b7a <alloc_pages>
c01049d8:	83 c4 10             	add    $0x10,%esp
c01049db:	85 c0                	test   %eax,%eax
c01049dd:	74 19                	je     c01049f8 <basic_check+0x408>
c01049df:	68 de 69 10 c0       	push   $0xc01069de
c01049e4:	68 3e 68 10 c0       	push   $0xc010683e
c01049e9:	68 ee 00 00 00       	push   $0xee
c01049ee:	68 53 68 10 c0       	push   $0xc0106853
c01049f3:	e8 e1 b9 ff ff       	call   c01003d9 <__panic>

    assert(nr_free == 0);
c01049f8:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c01049fd:	85 c0                	test   %eax,%eax
c01049ff:	74 19                	je     c0104a1a <basic_check+0x42a>
c0104a01:	68 31 6a 10 c0       	push   $0xc0106a31
c0104a06:	68 3e 68 10 c0       	push   $0xc010683e
c0104a0b:	68 f0 00 00 00       	push   $0xf0
c0104a10:	68 53 68 10 c0       	push   $0xc0106853
c0104a15:	e8 bf b9 ff ff       	call   c01003d9 <__panic>
    free_list = free_list_store;
c0104a1a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104a1d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104a20:	a3 1c af 11 c0       	mov    %eax,0xc011af1c
c0104a25:	89 15 20 af 11 c0    	mov    %edx,0xc011af20
    nr_free = nr_free_store;
c0104a2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104a2e:	a3 24 af 11 c0       	mov    %eax,0xc011af24

    free_page(p);
c0104a33:	83 ec 08             	sub    $0x8,%esp
c0104a36:	6a 01                	push   $0x1
c0104a38:	ff 75 e4             	pushl  -0x1c(%ebp)
c0104a3b:	e8 78 e1 ff ff       	call   c0102bb8 <free_pages>
c0104a40:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0104a43:	83 ec 08             	sub    $0x8,%esp
c0104a46:	6a 01                	push   $0x1
c0104a48:	ff 75 f0             	pushl  -0x10(%ebp)
c0104a4b:	e8 68 e1 ff ff       	call   c0102bb8 <free_pages>
c0104a50:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104a53:	83 ec 08             	sub    $0x8,%esp
c0104a56:	6a 01                	push   $0x1
c0104a58:	ff 75 f4             	pushl  -0xc(%ebp)
c0104a5b:	e8 58 e1 ff ff       	call   c0102bb8 <free_pages>
c0104a60:	83 c4 10             	add    $0x10,%esp
}
c0104a63:	90                   	nop
c0104a64:	c9                   	leave  
c0104a65:	c3                   	ret    

c0104a66 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104a66:	55                   	push   %ebp
c0104a67:	89 e5                	mov    %esp,%ebp
c0104a69:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
c0104a6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104a76:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104a7d:	c7 45 ec 1c af 11 c0 	movl   $0xc011af1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104a84:	eb 60                	jmp    c0104ae6 <default_check+0x80>
        struct Page *p = le2page(le, page_link);
c0104a86:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a89:	83 e8 0c             	sub    $0xc,%eax
c0104a8c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0104a8f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104a92:	83 c0 04             	add    $0x4,%eax
c0104a95:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104a9c:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104a9f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104aa2:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104aa5:	0f a3 10             	bt     %edx,(%eax)
c0104aa8:	19 c0                	sbb    %eax,%eax
c0104aaa:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0104aad:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0104ab1:	0f 95 c0             	setne  %al
c0104ab4:	0f b6 c0             	movzbl %al,%eax
c0104ab7:	85 c0                	test   %eax,%eax
c0104ab9:	75 19                	jne    c0104ad4 <default_check+0x6e>
c0104abb:	68 3e 6a 10 c0       	push   $0xc0106a3e
c0104ac0:	68 3e 68 10 c0       	push   $0xc010683e
c0104ac5:	68 01 01 00 00       	push   $0x101
c0104aca:	68 53 68 10 c0       	push   $0xc0106853
c0104acf:	e8 05 b9 ff ff       	call   c01003d9 <__panic>
        count ++, total += p->property;
c0104ad4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104ad8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104adb:	8b 50 08             	mov    0x8(%eax),%edx
c0104ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ae1:	01 d0                	add    %edx,%eax
c0104ae3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ae6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ae9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0104aec:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104aef:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0104af2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104af5:	81 7d ec 1c af 11 c0 	cmpl   $0xc011af1c,-0x14(%ebp)
c0104afc:	75 88                	jne    c0104a86 <default_check+0x20>
    }
    assert(total == nr_free_pages());
c0104afe:	e8 ea e0 ff ff       	call   c0102bed <nr_free_pages>
c0104b03:	89 c2                	mov    %eax,%edx
c0104b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b08:	39 c2                	cmp    %eax,%edx
c0104b0a:	74 19                	je     c0104b25 <default_check+0xbf>
c0104b0c:	68 4e 6a 10 c0       	push   $0xc0106a4e
c0104b11:	68 3e 68 10 c0       	push   $0xc010683e
c0104b16:	68 04 01 00 00       	push   $0x104
c0104b1b:	68 53 68 10 c0       	push   $0xc0106853
c0104b20:	e8 b4 b8 ff ff       	call   c01003d9 <__panic>

    basic_check();
c0104b25:	e8 c6 fa ff ff       	call   c01045f0 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0104b2a:	83 ec 0c             	sub    $0xc,%esp
c0104b2d:	6a 05                	push   $0x5
c0104b2f:	e8 46 e0 ff ff       	call   c0102b7a <alloc_pages>
c0104b34:	83 c4 10             	add    $0x10,%esp
c0104b37:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0104b3a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104b3e:	75 19                	jne    c0104b59 <default_check+0xf3>
c0104b40:	68 67 6a 10 c0       	push   $0xc0106a67
c0104b45:	68 3e 68 10 c0       	push   $0xc010683e
c0104b4a:	68 09 01 00 00       	push   $0x109
c0104b4f:	68 53 68 10 c0       	push   $0xc0106853
c0104b54:	e8 80 b8 ff ff       	call   c01003d9 <__panic>
    assert(!PageProperty(p0));
c0104b59:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104b5c:	83 c0 04             	add    $0x4,%eax
c0104b5f:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0104b66:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104b69:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104b6c:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104b6f:	0f a3 10             	bt     %edx,(%eax)
c0104b72:	19 c0                	sbb    %eax,%eax
c0104b74:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0104b77:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0104b7b:	0f 95 c0             	setne  %al
c0104b7e:	0f b6 c0             	movzbl %al,%eax
c0104b81:	85 c0                	test   %eax,%eax
c0104b83:	74 19                	je     c0104b9e <default_check+0x138>
c0104b85:	68 72 6a 10 c0       	push   $0xc0106a72
c0104b8a:	68 3e 68 10 c0       	push   $0xc010683e
c0104b8f:	68 0a 01 00 00       	push   $0x10a
c0104b94:	68 53 68 10 c0       	push   $0xc0106853
c0104b99:	e8 3b b8 ff ff       	call   c01003d9 <__panic>

    list_entry_t free_list_store = free_list;
c0104b9e:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0104ba3:	8b 15 20 af 11 c0    	mov    0xc011af20,%edx
c0104ba9:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104bac:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104baf:	c7 45 b0 1c af 11 c0 	movl   $0xc011af1c,-0x50(%ebp)
    elm->prev = elm->next = elm;
c0104bb6:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104bb9:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104bbc:	89 50 04             	mov    %edx,0x4(%eax)
c0104bbf:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104bc2:	8b 50 04             	mov    0x4(%eax),%edx
c0104bc5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104bc8:	89 10                	mov    %edx,(%eax)
c0104bca:	c7 45 b4 1c af 11 c0 	movl   $0xc011af1c,-0x4c(%ebp)
    return list->next == list;
c0104bd1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104bd4:	8b 40 04             	mov    0x4(%eax),%eax
c0104bd7:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0104bda:	0f 94 c0             	sete   %al
c0104bdd:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104be0:	85 c0                	test   %eax,%eax
c0104be2:	75 19                	jne    c0104bfd <default_check+0x197>
c0104be4:	68 c7 69 10 c0       	push   $0xc01069c7
c0104be9:	68 3e 68 10 c0       	push   $0xc010683e
c0104bee:	68 0e 01 00 00       	push   $0x10e
c0104bf3:	68 53 68 10 c0       	push   $0xc0106853
c0104bf8:	e8 dc b7 ff ff       	call   c01003d9 <__panic>
    assert(alloc_page() == NULL);
c0104bfd:	83 ec 0c             	sub    $0xc,%esp
c0104c00:	6a 01                	push   $0x1
c0104c02:	e8 73 df ff ff       	call   c0102b7a <alloc_pages>
c0104c07:	83 c4 10             	add    $0x10,%esp
c0104c0a:	85 c0                	test   %eax,%eax
c0104c0c:	74 19                	je     c0104c27 <default_check+0x1c1>
c0104c0e:	68 de 69 10 c0       	push   $0xc01069de
c0104c13:	68 3e 68 10 c0       	push   $0xc010683e
c0104c18:	68 0f 01 00 00       	push   $0x10f
c0104c1d:	68 53 68 10 c0       	push   $0xc0106853
c0104c22:	e8 b2 b7 ff ff       	call   c01003d9 <__panic>

    unsigned int nr_free_store = nr_free;
c0104c27:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c0104c2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0104c2f:	c7 05 24 af 11 c0 00 	movl   $0x0,0xc011af24
c0104c36:	00 00 00 

    free_pages(p0 + 2, 3);
c0104c39:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104c3c:	83 c0 28             	add    $0x28,%eax
c0104c3f:	83 ec 08             	sub    $0x8,%esp
c0104c42:	6a 03                	push   $0x3
c0104c44:	50                   	push   %eax
c0104c45:	e8 6e df ff ff       	call   c0102bb8 <free_pages>
c0104c4a:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c0104c4d:	83 ec 0c             	sub    $0xc,%esp
c0104c50:	6a 04                	push   $0x4
c0104c52:	e8 23 df ff ff       	call   c0102b7a <alloc_pages>
c0104c57:	83 c4 10             	add    $0x10,%esp
c0104c5a:	85 c0                	test   %eax,%eax
c0104c5c:	74 19                	je     c0104c77 <default_check+0x211>
c0104c5e:	68 84 6a 10 c0       	push   $0xc0106a84
c0104c63:	68 3e 68 10 c0       	push   $0xc010683e
c0104c68:	68 15 01 00 00       	push   $0x115
c0104c6d:	68 53 68 10 c0       	push   $0xc0106853
c0104c72:	e8 62 b7 ff ff       	call   c01003d9 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104c77:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104c7a:	83 c0 28             	add    $0x28,%eax
c0104c7d:	83 c0 04             	add    $0x4,%eax
c0104c80:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0104c87:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104c8a:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104c8d:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104c90:	0f a3 10             	bt     %edx,(%eax)
c0104c93:	19 c0                	sbb    %eax,%eax
c0104c95:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0104c98:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0104c9c:	0f 95 c0             	setne  %al
c0104c9f:	0f b6 c0             	movzbl %al,%eax
c0104ca2:	85 c0                	test   %eax,%eax
c0104ca4:	74 0e                	je     c0104cb4 <default_check+0x24e>
c0104ca6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ca9:	83 c0 28             	add    $0x28,%eax
c0104cac:	8b 40 08             	mov    0x8(%eax),%eax
c0104caf:	83 f8 03             	cmp    $0x3,%eax
c0104cb2:	74 19                	je     c0104ccd <default_check+0x267>
c0104cb4:	68 9c 6a 10 c0       	push   $0xc0106a9c
c0104cb9:	68 3e 68 10 c0       	push   $0xc010683e
c0104cbe:	68 16 01 00 00       	push   $0x116
c0104cc3:	68 53 68 10 c0       	push   $0xc0106853
c0104cc8:	e8 0c b7 ff ff       	call   c01003d9 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104ccd:	83 ec 0c             	sub    $0xc,%esp
c0104cd0:	6a 03                	push   $0x3
c0104cd2:	e8 a3 de ff ff       	call   c0102b7a <alloc_pages>
c0104cd7:	83 c4 10             	add    $0x10,%esp
c0104cda:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104cdd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104ce1:	75 19                	jne    c0104cfc <default_check+0x296>
c0104ce3:	68 c8 6a 10 c0       	push   $0xc0106ac8
c0104ce8:	68 3e 68 10 c0       	push   $0xc010683e
c0104ced:	68 17 01 00 00       	push   $0x117
c0104cf2:	68 53 68 10 c0       	push   $0xc0106853
c0104cf7:	e8 dd b6 ff ff       	call   c01003d9 <__panic>
    assert(alloc_page() == NULL);
c0104cfc:	83 ec 0c             	sub    $0xc,%esp
c0104cff:	6a 01                	push   $0x1
c0104d01:	e8 74 de ff ff       	call   c0102b7a <alloc_pages>
c0104d06:	83 c4 10             	add    $0x10,%esp
c0104d09:	85 c0                	test   %eax,%eax
c0104d0b:	74 19                	je     c0104d26 <default_check+0x2c0>
c0104d0d:	68 de 69 10 c0       	push   $0xc01069de
c0104d12:	68 3e 68 10 c0       	push   $0xc010683e
c0104d17:	68 18 01 00 00       	push   $0x118
c0104d1c:	68 53 68 10 c0       	push   $0xc0106853
c0104d21:	e8 b3 b6 ff ff       	call   c01003d9 <__panic>
    assert(p0 + 2 == p1);
c0104d26:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104d29:	83 c0 28             	add    $0x28,%eax
c0104d2c:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104d2f:	74 19                	je     c0104d4a <default_check+0x2e4>
c0104d31:	68 e6 6a 10 c0       	push   $0xc0106ae6
c0104d36:	68 3e 68 10 c0       	push   $0xc010683e
c0104d3b:	68 19 01 00 00       	push   $0x119
c0104d40:	68 53 68 10 c0       	push   $0xc0106853
c0104d45:	e8 8f b6 ff ff       	call   c01003d9 <__panic>

    p2 = p0 + 1;
c0104d4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104d4d:	83 c0 14             	add    $0x14,%eax
c0104d50:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c0104d53:	83 ec 08             	sub    $0x8,%esp
c0104d56:	6a 01                	push   $0x1
c0104d58:	ff 75 e8             	pushl  -0x18(%ebp)
c0104d5b:	e8 58 de ff ff       	call   c0102bb8 <free_pages>
c0104d60:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c0104d63:	83 ec 08             	sub    $0x8,%esp
c0104d66:	6a 03                	push   $0x3
c0104d68:	ff 75 e0             	pushl  -0x20(%ebp)
c0104d6b:	e8 48 de ff ff       	call   c0102bb8 <free_pages>
c0104d70:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c0104d73:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104d76:	83 c0 04             	add    $0x4,%eax
c0104d79:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0104d80:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104d83:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104d86:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104d89:	0f a3 10             	bt     %edx,(%eax)
c0104d8c:	19 c0                	sbb    %eax,%eax
c0104d8e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0104d91:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104d95:	0f 95 c0             	setne  %al
c0104d98:	0f b6 c0             	movzbl %al,%eax
c0104d9b:	85 c0                	test   %eax,%eax
c0104d9d:	74 0b                	je     c0104daa <default_check+0x344>
c0104d9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104da2:	8b 40 08             	mov    0x8(%eax),%eax
c0104da5:	83 f8 01             	cmp    $0x1,%eax
c0104da8:	74 19                	je     c0104dc3 <default_check+0x35d>
c0104daa:	68 f4 6a 10 c0       	push   $0xc0106af4
c0104daf:	68 3e 68 10 c0       	push   $0xc010683e
c0104db4:	68 1e 01 00 00       	push   $0x11e
c0104db9:	68 53 68 10 c0       	push   $0xc0106853
c0104dbe:	e8 16 b6 ff ff       	call   c01003d9 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104dc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104dc6:	83 c0 04             	add    $0x4,%eax
c0104dc9:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0104dd0:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104dd3:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104dd6:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104dd9:	0f a3 10             	bt     %edx,(%eax)
c0104ddc:	19 c0                	sbb    %eax,%eax
c0104dde:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0104de1:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0104de5:	0f 95 c0             	setne  %al
c0104de8:	0f b6 c0             	movzbl %al,%eax
c0104deb:	85 c0                	test   %eax,%eax
c0104ded:	74 0b                	je     c0104dfa <default_check+0x394>
c0104def:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104df2:	8b 40 08             	mov    0x8(%eax),%eax
c0104df5:	83 f8 03             	cmp    $0x3,%eax
c0104df8:	74 19                	je     c0104e13 <default_check+0x3ad>
c0104dfa:	68 1c 6b 10 c0       	push   $0xc0106b1c
c0104dff:	68 3e 68 10 c0       	push   $0xc010683e
c0104e04:	68 1f 01 00 00       	push   $0x11f
c0104e09:	68 53 68 10 c0       	push   $0xc0106853
c0104e0e:	e8 c6 b5 ff ff       	call   c01003d9 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104e13:	83 ec 0c             	sub    $0xc,%esp
c0104e16:	6a 01                	push   $0x1
c0104e18:	e8 5d dd ff ff       	call   c0102b7a <alloc_pages>
c0104e1d:	83 c4 10             	add    $0x10,%esp
c0104e20:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104e23:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104e26:	83 e8 14             	sub    $0x14,%eax
c0104e29:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104e2c:	74 19                	je     c0104e47 <default_check+0x3e1>
c0104e2e:	68 42 6b 10 c0       	push   $0xc0106b42
c0104e33:	68 3e 68 10 c0       	push   $0xc010683e
c0104e38:	68 21 01 00 00       	push   $0x121
c0104e3d:	68 53 68 10 c0       	push   $0xc0106853
c0104e42:	e8 92 b5 ff ff       	call   c01003d9 <__panic>
    free_page(p0);
c0104e47:	83 ec 08             	sub    $0x8,%esp
c0104e4a:	6a 01                	push   $0x1
c0104e4c:	ff 75 e8             	pushl  -0x18(%ebp)
c0104e4f:	e8 64 dd ff ff       	call   c0102bb8 <free_pages>
c0104e54:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104e57:	83 ec 0c             	sub    $0xc,%esp
c0104e5a:	6a 02                	push   $0x2
c0104e5c:	e8 19 dd ff ff       	call   c0102b7a <alloc_pages>
c0104e61:	83 c4 10             	add    $0x10,%esp
c0104e64:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104e67:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104e6a:	83 c0 14             	add    $0x14,%eax
c0104e6d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104e70:	74 19                	je     c0104e8b <default_check+0x425>
c0104e72:	68 60 6b 10 c0       	push   $0xc0106b60
c0104e77:	68 3e 68 10 c0       	push   $0xc010683e
c0104e7c:	68 23 01 00 00       	push   $0x123
c0104e81:	68 53 68 10 c0       	push   $0xc0106853
c0104e86:	e8 4e b5 ff ff       	call   c01003d9 <__panic>

    free_pages(p0, 2);
c0104e8b:	83 ec 08             	sub    $0x8,%esp
c0104e8e:	6a 02                	push   $0x2
c0104e90:	ff 75 e8             	pushl  -0x18(%ebp)
c0104e93:	e8 20 dd ff ff       	call   c0102bb8 <free_pages>
c0104e98:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104e9b:	83 ec 08             	sub    $0x8,%esp
c0104e9e:	6a 01                	push   $0x1
c0104ea0:	ff 75 dc             	pushl  -0x24(%ebp)
c0104ea3:	e8 10 dd ff ff       	call   c0102bb8 <free_pages>
c0104ea8:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c0104eab:	83 ec 0c             	sub    $0xc,%esp
c0104eae:	6a 05                	push   $0x5
c0104eb0:	e8 c5 dc ff ff       	call   c0102b7a <alloc_pages>
c0104eb5:	83 c4 10             	add    $0x10,%esp
c0104eb8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104ebb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104ebf:	75 19                	jne    c0104eda <default_check+0x474>
c0104ec1:	68 80 6b 10 c0       	push   $0xc0106b80
c0104ec6:	68 3e 68 10 c0       	push   $0xc010683e
c0104ecb:	68 28 01 00 00       	push   $0x128
c0104ed0:	68 53 68 10 c0       	push   $0xc0106853
c0104ed5:	e8 ff b4 ff ff       	call   c01003d9 <__panic>
    assert(alloc_page() == NULL);
c0104eda:	83 ec 0c             	sub    $0xc,%esp
c0104edd:	6a 01                	push   $0x1
c0104edf:	e8 96 dc ff ff       	call   c0102b7a <alloc_pages>
c0104ee4:	83 c4 10             	add    $0x10,%esp
c0104ee7:	85 c0                	test   %eax,%eax
c0104ee9:	74 19                	je     c0104f04 <default_check+0x49e>
c0104eeb:	68 de 69 10 c0       	push   $0xc01069de
c0104ef0:	68 3e 68 10 c0       	push   $0xc010683e
c0104ef5:	68 29 01 00 00       	push   $0x129
c0104efa:	68 53 68 10 c0       	push   $0xc0106853
c0104eff:	e8 d5 b4 ff ff       	call   c01003d9 <__panic>

    assert(nr_free == 0);
c0104f04:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c0104f09:	85 c0                	test   %eax,%eax
c0104f0b:	74 19                	je     c0104f26 <default_check+0x4c0>
c0104f0d:	68 31 6a 10 c0       	push   $0xc0106a31
c0104f12:	68 3e 68 10 c0       	push   $0xc010683e
c0104f17:	68 2b 01 00 00       	push   $0x12b
c0104f1c:	68 53 68 10 c0       	push   $0xc0106853
c0104f21:	e8 b3 b4 ff ff       	call   c01003d9 <__panic>
    nr_free = nr_free_store;
c0104f26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f29:	a3 24 af 11 c0       	mov    %eax,0xc011af24

    free_list = free_list_store;
c0104f2e:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104f31:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104f34:	a3 1c af 11 c0       	mov    %eax,0xc011af1c
c0104f39:	89 15 20 af 11 c0    	mov    %edx,0xc011af20
    free_pages(p0, 5);
c0104f3f:	83 ec 08             	sub    $0x8,%esp
c0104f42:	6a 05                	push   $0x5
c0104f44:	ff 75 e8             	pushl  -0x18(%ebp)
c0104f47:	e8 6c dc ff ff       	call   c0102bb8 <free_pages>
c0104f4c:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c0104f4f:	c7 45 ec 1c af 11 c0 	movl   $0xc011af1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104f56:	eb 1d                	jmp    c0104f75 <default_check+0x50f>
        struct Page *p = le2page(le, page_link);
c0104f58:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f5b:	83 e8 0c             	sub    $0xc,%eax
c0104f5e:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c0104f61:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104f65:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104f68:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104f6b:	8b 40 08             	mov    0x8(%eax),%eax
c0104f6e:	29 c2                	sub    %eax,%edx
c0104f70:	89 d0                	mov    %edx,%eax
c0104f72:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104f75:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f78:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0104f7b:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104f7e:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0104f81:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104f84:	81 7d ec 1c af 11 c0 	cmpl   $0xc011af1c,-0x14(%ebp)
c0104f8b:	75 cb                	jne    c0104f58 <default_check+0x4f2>
    }
    assert(count == 0);
c0104f8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104f91:	74 19                	je     c0104fac <default_check+0x546>
c0104f93:	68 9e 6b 10 c0       	push   $0xc0106b9e
c0104f98:	68 3e 68 10 c0       	push   $0xc010683e
c0104f9d:	68 36 01 00 00       	push   $0x136
c0104fa2:	68 53 68 10 c0       	push   $0xc0106853
c0104fa7:	e8 2d b4 ff ff       	call   c01003d9 <__panic>
    assert(total == 0);
c0104fac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104fb0:	74 19                	je     c0104fcb <default_check+0x565>
c0104fb2:	68 a9 6b 10 c0       	push   $0xc0106ba9
c0104fb7:	68 3e 68 10 c0       	push   $0xc010683e
c0104fbc:	68 37 01 00 00       	push   $0x137
c0104fc1:	68 53 68 10 c0       	push   $0xc0106853
c0104fc6:	e8 0e b4 ff ff       	call   c01003d9 <__panic>
}
c0104fcb:	90                   	nop
c0104fcc:	c9                   	leave  
c0104fcd:	c3                   	ret    

c0104fce <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0104fce:	55                   	push   %ebp
c0104fcf:	89 e5                	mov    %esp,%ebp
c0104fd1:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0104fd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0104fdb:	eb 04                	jmp    c0104fe1 <strlen+0x13>
        cnt ++;
c0104fdd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
c0104fe1:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fe4:	8d 50 01             	lea    0x1(%eax),%edx
c0104fe7:	89 55 08             	mov    %edx,0x8(%ebp)
c0104fea:	0f b6 00             	movzbl (%eax),%eax
c0104fed:	84 c0                	test   %al,%al
c0104fef:	75 ec                	jne    c0104fdd <strlen+0xf>
    }
    return cnt;
c0104ff1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0104ff4:	c9                   	leave  
c0104ff5:	c3                   	ret    

c0104ff6 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0104ff6:	55                   	push   %ebp
c0104ff7:	89 e5                	mov    %esp,%ebp
c0104ff9:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0104ffc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105003:	eb 04                	jmp    c0105009 <strnlen+0x13>
        cnt ++;
c0105005:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105009:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010500c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010500f:	73 10                	jae    c0105021 <strnlen+0x2b>
c0105011:	8b 45 08             	mov    0x8(%ebp),%eax
c0105014:	8d 50 01             	lea    0x1(%eax),%edx
c0105017:	89 55 08             	mov    %edx,0x8(%ebp)
c010501a:	0f b6 00             	movzbl (%eax),%eax
c010501d:	84 c0                	test   %al,%al
c010501f:	75 e4                	jne    c0105005 <strnlen+0xf>
    }
    return cnt;
c0105021:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105024:	c9                   	leave  
c0105025:	c3                   	ret    

c0105026 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105026:	55                   	push   %ebp
c0105027:	89 e5                	mov    %esp,%ebp
c0105029:	57                   	push   %edi
c010502a:	56                   	push   %esi
c010502b:	83 ec 20             	sub    $0x20,%esp
c010502e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105031:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105034:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105037:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010503a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010503d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105040:	89 d1                	mov    %edx,%ecx
c0105042:	89 c2                	mov    %eax,%edx
c0105044:	89 ce                	mov    %ecx,%esi
c0105046:	89 d7                	mov    %edx,%edi
c0105048:	ac                   	lods   %ds:(%esi),%al
c0105049:	aa                   	stos   %al,%es:(%edi)
c010504a:	84 c0                	test   %al,%al
c010504c:	75 fa                	jne    c0105048 <strcpy+0x22>
c010504e:	89 fa                	mov    %edi,%edx
c0105050:	89 f1                	mov    %esi,%ecx
c0105052:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105055:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105058:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010505b:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c010505e:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c010505f:	83 c4 20             	add    $0x20,%esp
c0105062:	5e                   	pop    %esi
c0105063:	5f                   	pop    %edi
c0105064:	5d                   	pop    %ebp
c0105065:	c3                   	ret    

c0105066 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105066:	55                   	push   %ebp
c0105067:	89 e5                	mov    %esp,%ebp
c0105069:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c010506c:	8b 45 08             	mov    0x8(%ebp),%eax
c010506f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105072:	eb 21                	jmp    c0105095 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105074:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105077:	0f b6 10             	movzbl (%eax),%edx
c010507a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010507d:	88 10                	mov    %dl,(%eax)
c010507f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105082:	0f b6 00             	movzbl (%eax),%eax
c0105085:	84 c0                	test   %al,%al
c0105087:	74 04                	je     c010508d <strncpy+0x27>
            src ++;
c0105089:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c010508d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105091:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
c0105095:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105099:	75 d9                	jne    c0105074 <strncpy+0xe>
    }
    return dst;
c010509b:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010509e:	c9                   	leave  
c010509f:	c3                   	ret    

c01050a0 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01050a0:	55                   	push   %ebp
c01050a1:	89 e5                	mov    %esp,%ebp
c01050a3:	57                   	push   %edi
c01050a4:	56                   	push   %esi
c01050a5:	83 ec 20             	sub    $0x20,%esp
c01050a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01050ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01050ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c01050b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01050b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050ba:	89 d1                	mov    %edx,%ecx
c01050bc:	89 c2                	mov    %eax,%edx
c01050be:	89 ce                	mov    %ecx,%esi
c01050c0:	89 d7                	mov    %edx,%edi
c01050c2:	ac                   	lods   %ds:(%esi),%al
c01050c3:	ae                   	scas   %es:(%edi),%al
c01050c4:	75 08                	jne    c01050ce <strcmp+0x2e>
c01050c6:	84 c0                	test   %al,%al
c01050c8:	75 f8                	jne    c01050c2 <strcmp+0x22>
c01050ca:	31 c0                	xor    %eax,%eax
c01050cc:	eb 04                	jmp    c01050d2 <strcmp+0x32>
c01050ce:	19 c0                	sbb    %eax,%eax
c01050d0:	0c 01                	or     $0x1,%al
c01050d2:	89 fa                	mov    %edi,%edx
c01050d4:	89 f1                	mov    %esi,%ecx
c01050d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01050d9:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01050dc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c01050df:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c01050e2:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01050e3:	83 c4 20             	add    $0x20,%esp
c01050e6:	5e                   	pop    %esi
c01050e7:	5f                   	pop    %edi
c01050e8:	5d                   	pop    %ebp
c01050e9:	c3                   	ret    

c01050ea <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01050ea:	55                   	push   %ebp
c01050eb:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01050ed:	eb 0c                	jmp    c01050fb <strncmp+0x11>
        n --, s1 ++, s2 ++;
c01050ef:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01050f3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01050f7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01050fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01050ff:	74 1a                	je     c010511b <strncmp+0x31>
c0105101:	8b 45 08             	mov    0x8(%ebp),%eax
c0105104:	0f b6 00             	movzbl (%eax),%eax
c0105107:	84 c0                	test   %al,%al
c0105109:	74 10                	je     c010511b <strncmp+0x31>
c010510b:	8b 45 08             	mov    0x8(%ebp),%eax
c010510e:	0f b6 10             	movzbl (%eax),%edx
c0105111:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105114:	0f b6 00             	movzbl (%eax),%eax
c0105117:	38 c2                	cmp    %al,%dl
c0105119:	74 d4                	je     c01050ef <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010511b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010511f:	74 18                	je     c0105139 <strncmp+0x4f>
c0105121:	8b 45 08             	mov    0x8(%ebp),%eax
c0105124:	0f b6 00             	movzbl (%eax),%eax
c0105127:	0f b6 d0             	movzbl %al,%edx
c010512a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010512d:	0f b6 00             	movzbl (%eax),%eax
c0105130:	0f b6 c0             	movzbl %al,%eax
c0105133:	29 c2                	sub    %eax,%edx
c0105135:	89 d0                	mov    %edx,%eax
c0105137:	eb 05                	jmp    c010513e <strncmp+0x54>
c0105139:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010513e:	5d                   	pop    %ebp
c010513f:	c3                   	ret    

c0105140 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105140:	55                   	push   %ebp
c0105141:	89 e5                	mov    %esp,%ebp
c0105143:	83 ec 04             	sub    $0x4,%esp
c0105146:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105149:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010514c:	eb 14                	jmp    c0105162 <strchr+0x22>
        if (*s == c) {
c010514e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105151:	0f b6 00             	movzbl (%eax),%eax
c0105154:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105157:	75 05                	jne    c010515e <strchr+0x1e>
            return (char *)s;
c0105159:	8b 45 08             	mov    0x8(%ebp),%eax
c010515c:	eb 13                	jmp    c0105171 <strchr+0x31>
        }
        s ++;
c010515e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c0105162:	8b 45 08             	mov    0x8(%ebp),%eax
c0105165:	0f b6 00             	movzbl (%eax),%eax
c0105168:	84 c0                	test   %al,%al
c010516a:	75 e2                	jne    c010514e <strchr+0xe>
    }
    return NULL;
c010516c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105171:	c9                   	leave  
c0105172:	c3                   	ret    

c0105173 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105173:	55                   	push   %ebp
c0105174:	89 e5                	mov    %esp,%ebp
c0105176:	83 ec 04             	sub    $0x4,%esp
c0105179:	8b 45 0c             	mov    0xc(%ebp),%eax
c010517c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010517f:	eb 0f                	jmp    c0105190 <strfind+0x1d>
        if (*s == c) {
c0105181:	8b 45 08             	mov    0x8(%ebp),%eax
c0105184:	0f b6 00             	movzbl (%eax),%eax
c0105187:	38 45 fc             	cmp    %al,-0x4(%ebp)
c010518a:	74 10                	je     c010519c <strfind+0x29>
            break;
        }
        s ++;
c010518c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c0105190:	8b 45 08             	mov    0x8(%ebp),%eax
c0105193:	0f b6 00             	movzbl (%eax),%eax
c0105196:	84 c0                	test   %al,%al
c0105198:	75 e7                	jne    c0105181 <strfind+0xe>
c010519a:	eb 01                	jmp    c010519d <strfind+0x2a>
            break;
c010519c:	90                   	nop
    }
    return (char *)s;
c010519d:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01051a0:	c9                   	leave  
c01051a1:	c3                   	ret    

c01051a2 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01051a2:	55                   	push   %ebp
c01051a3:	89 e5                	mov    %esp,%ebp
c01051a5:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01051a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01051af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01051b6:	eb 04                	jmp    c01051bc <strtol+0x1a>
        s ++;
c01051b8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c01051bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01051bf:	0f b6 00             	movzbl (%eax),%eax
c01051c2:	3c 20                	cmp    $0x20,%al
c01051c4:	74 f2                	je     c01051b8 <strtol+0x16>
c01051c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01051c9:	0f b6 00             	movzbl (%eax),%eax
c01051cc:	3c 09                	cmp    $0x9,%al
c01051ce:	74 e8                	je     c01051b8 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c01051d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01051d3:	0f b6 00             	movzbl (%eax),%eax
c01051d6:	3c 2b                	cmp    $0x2b,%al
c01051d8:	75 06                	jne    c01051e0 <strtol+0x3e>
        s ++;
c01051da:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01051de:	eb 15                	jmp    c01051f5 <strtol+0x53>
    }
    else if (*s == '-') {
c01051e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01051e3:	0f b6 00             	movzbl (%eax),%eax
c01051e6:	3c 2d                	cmp    $0x2d,%al
c01051e8:	75 0b                	jne    c01051f5 <strtol+0x53>
        s ++, neg = 1;
c01051ea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01051ee:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c01051f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01051f9:	74 06                	je     c0105201 <strtol+0x5f>
c01051fb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c01051ff:	75 24                	jne    c0105225 <strtol+0x83>
c0105201:	8b 45 08             	mov    0x8(%ebp),%eax
c0105204:	0f b6 00             	movzbl (%eax),%eax
c0105207:	3c 30                	cmp    $0x30,%al
c0105209:	75 1a                	jne    c0105225 <strtol+0x83>
c010520b:	8b 45 08             	mov    0x8(%ebp),%eax
c010520e:	83 c0 01             	add    $0x1,%eax
c0105211:	0f b6 00             	movzbl (%eax),%eax
c0105214:	3c 78                	cmp    $0x78,%al
c0105216:	75 0d                	jne    c0105225 <strtol+0x83>
        s += 2, base = 16;
c0105218:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c010521c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105223:	eb 2a                	jmp    c010524f <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105225:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105229:	75 17                	jne    c0105242 <strtol+0xa0>
c010522b:	8b 45 08             	mov    0x8(%ebp),%eax
c010522e:	0f b6 00             	movzbl (%eax),%eax
c0105231:	3c 30                	cmp    $0x30,%al
c0105233:	75 0d                	jne    c0105242 <strtol+0xa0>
        s ++, base = 8;
c0105235:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105239:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105240:	eb 0d                	jmp    c010524f <strtol+0xad>
    }
    else if (base == 0) {
c0105242:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105246:	75 07                	jne    c010524f <strtol+0xad>
        base = 10;
c0105248:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c010524f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105252:	0f b6 00             	movzbl (%eax),%eax
c0105255:	3c 2f                	cmp    $0x2f,%al
c0105257:	7e 1b                	jle    c0105274 <strtol+0xd2>
c0105259:	8b 45 08             	mov    0x8(%ebp),%eax
c010525c:	0f b6 00             	movzbl (%eax),%eax
c010525f:	3c 39                	cmp    $0x39,%al
c0105261:	7f 11                	jg     c0105274 <strtol+0xd2>
            dig = *s - '0';
c0105263:	8b 45 08             	mov    0x8(%ebp),%eax
c0105266:	0f b6 00             	movzbl (%eax),%eax
c0105269:	0f be c0             	movsbl %al,%eax
c010526c:	83 e8 30             	sub    $0x30,%eax
c010526f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105272:	eb 48                	jmp    c01052bc <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105274:	8b 45 08             	mov    0x8(%ebp),%eax
c0105277:	0f b6 00             	movzbl (%eax),%eax
c010527a:	3c 60                	cmp    $0x60,%al
c010527c:	7e 1b                	jle    c0105299 <strtol+0xf7>
c010527e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105281:	0f b6 00             	movzbl (%eax),%eax
c0105284:	3c 7a                	cmp    $0x7a,%al
c0105286:	7f 11                	jg     c0105299 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105288:	8b 45 08             	mov    0x8(%ebp),%eax
c010528b:	0f b6 00             	movzbl (%eax),%eax
c010528e:	0f be c0             	movsbl %al,%eax
c0105291:	83 e8 57             	sub    $0x57,%eax
c0105294:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105297:	eb 23                	jmp    c01052bc <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105299:	8b 45 08             	mov    0x8(%ebp),%eax
c010529c:	0f b6 00             	movzbl (%eax),%eax
c010529f:	3c 40                	cmp    $0x40,%al
c01052a1:	7e 3c                	jle    c01052df <strtol+0x13d>
c01052a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01052a6:	0f b6 00             	movzbl (%eax),%eax
c01052a9:	3c 5a                	cmp    $0x5a,%al
c01052ab:	7f 32                	jg     c01052df <strtol+0x13d>
            dig = *s - 'A' + 10;
c01052ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01052b0:	0f b6 00             	movzbl (%eax),%eax
c01052b3:	0f be c0             	movsbl %al,%eax
c01052b6:	83 e8 37             	sub    $0x37,%eax
c01052b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01052bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052bf:	3b 45 10             	cmp    0x10(%ebp),%eax
c01052c2:	7d 1a                	jge    c01052de <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
c01052c4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01052c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01052cb:	0f af 45 10          	imul   0x10(%ebp),%eax
c01052cf:	89 c2                	mov    %eax,%edx
c01052d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052d4:	01 d0                	add    %edx,%eax
c01052d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c01052d9:	e9 71 ff ff ff       	jmp    c010524f <strtol+0xad>
            break;
c01052de:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c01052df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01052e3:	74 08                	je     c01052ed <strtol+0x14b>
        *endptr = (char *) s;
c01052e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052e8:	8b 55 08             	mov    0x8(%ebp),%edx
c01052eb:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c01052ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01052f1:	74 07                	je     c01052fa <strtol+0x158>
c01052f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01052f6:	f7 d8                	neg    %eax
c01052f8:	eb 03                	jmp    c01052fd <strtol+0x15b>
c01052fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c01052fd:	c9                   	leave  
c01052fe:	c3                   	ret    

c01052ff <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c01052ff:	55                   	push   %ebp
c0105300:	89 e5                	mov    %esp,%ebp
c0105302:	57                   	push   %edi
c0105303:	83 ec 24             	sub    $0x24,%esp
c0105306:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105309:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c010530c:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105310:	8b 55 08             	mov    0x8(%ebp),%edx
c0105313:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105316:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105319:	8b 45 10             	mov    0x10(%ebp),%eax
c010531c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c010531f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105322:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105326:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105329:	89 d7                	mov    %edx,%edi
c010532b:	f3 aa                	rep stos %al,%es:(%edi)
c010532d:	89 fa                	mov    %edi,%edx
c010532f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105332:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105335:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105338:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105339:	83 c4 24             	add    $0x24,%esp
c010533c:	5f                   	pop    %edi
c010533d:	5d                   	pop    %ebp
c010533e:	c3                   	ret    

c010533f <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c010533f:	55                   	push   %ebp
c0105340:	89 e5                	mov    %esp,%ebp
c0105342:	57                   	push   %edi
c0105343:	56                   	push   %esi
c0105344:	53                   	push   %ebx
c0105345:	83 ec 30             	sub    $0x30,%esp
c0105348:	8b 45 08             	mov    0x8(%ebp),%eax
c010534b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010534e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105351:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105354:	8b 45 10             	mov    0x10(%ebp),%eax
c0105357:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c010535a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010535d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105360:	73 42                	jae    c01053a4 <memmove+0x65>
c0105362:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105365:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105368:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010536b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010536e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105371:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105374:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105377:	c1 e8 02             	shr    $0x2,%eax
c010537a:	89 c1                	mov    %eax,%ecx
    asm volatile (
c010537c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010537f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105382:	89 d7                	mov    %edx,%edi
c0105384:	89 c6                	mov    %eax,%esi
c0105386:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105388:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010538b:	83 e1 03             	and    $0x3,%ecx
c010538e:	74 02                	je     c0105392 <memmove+0x53>
c0105390:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105392:	89 f0                	mov    %esi,%eax
c0105394:	89 fa                	mov    %edi,%edx
c0105396:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105399:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010539c:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c010539f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c01053a2:	eb 36                	jmp    c01053da <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01053a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01053a7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01053aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053ad:	01 c2                	add    %eax,%edx
c01053af:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01053b2:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01053b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053b8:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c01053bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01053be:	89 c1                	mov    %eax,%ecx
c01053c0:	89 d8                	mov    %ebx,%eax
c01053c2:	89 d6                	mov    %edx,%esi
c01053c4:	89 c7                	mov    %eax,%edi
c01053c6:	fd                   	std    
c01053c7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01053c9:	fc                   	cld    
c01053ca:	89 f8                	mov    %edi,%eax
c01053cc:	89 f2                	mov    %esi,%edx
c01053ce:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c01053d1:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01053d4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c01053d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c01053da:	83 c4 30             	add    $0x30,%esp
c01053dd:	5b                   	pop    %ebx
c01053de:	5e                   	pop    %esi
c01053df:	5f                   	pop    %edi
c01053e0:	5d                   	pop    %ebp
c01053e1:	c3                   	ret    

c01053e2 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c01053e2:	55                   	push   %ebp
c01053e3:	89 e5                	mov    %esp,%ebp
c01053e5:	57                   	push   %edi
c01053e6:	56                   	push   %esi
c01053e7:	83 ec 20             	sub    $0x20,%esp
c01053ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01053ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01053f0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01053f6:	8b 45 10             	mov    0x10(%ebp),%eax
c01053f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01053fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053ff:	c1 e8 02             	shr    $0x2,%eax
c0105402:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105404:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105407:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010540a:	89 d7                	mov    %edx,%edi
c010540c:	89 c6                	mov    %eax,%esi
c010540e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105410:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105413:	83 e1 03             	and    $0x3,%ecx
c0105416:	74 02                	je     c010541a <memcpy+0x38>
c0105418:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010541a:	89 f0                	mov    %esi,%eax
c010541c:	89 fa                	mov    %edi,%edx
c010541e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105421:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105424:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105427:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c010542a:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010542b:	83 c4 20             	add    $0x20,%esp
c010542e:	5e                   	pop    %esi
c010542f:	5f                   	pop    %edi
c0105430:	5d                   	pop    %ebp
c0105431:	c3                   	ret    

c0105432 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105432:	55                   	push   %ebp
c0105433:	89 e5                	mov    %esp,%ebp
c0105435:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105438:	8b 45 08             	mov    0x8(%ebp),%eax
c010543b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c010543e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105441:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105444:	eb 30                	jmp    c0105476 <memcmp+0x44>
        if (*s1 != *s2) {
c0105446:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105449:	0f b6 10             	movzbl (%eax),%edx
c010544c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010544f:	0f b6 00             	movzbl (%eax),%eax
c0105452:	38 c2                	cmp    %al,%dl
c0105454:	74 18                	je     c010546e <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105456:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105459:	0f b6 00             	movzbl (%eax),%eax
c010545c:	0f b6 d0             	movzbl %al,%edx
c010545f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105462:	0f b6 00             	movzbl (%eax),%eax
c0105465:	0f b6 c0             	movzbl %al,%eax
c0105468:	29 c2                	sub    %eax,%edx
c010546a:	89 d0                	mov    %edx,%eax
c010546c:	eb 1a                	jmp    c0105488 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c010546e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105472:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
c0105476:	8b 45 10             	mov    0x10(%ebp),%eax
c0105479:	8d 50 ff             	lea    -0x1(%eax),%edx
c010547c:	89 55 10             	mov    %edx,0x10(%ebp)
c010547f:	85 c0                	test   %eax,%eax
c0105481:	75 c3                	jne    c0105446 <memcmp+0x14>
    }
    return 0;
c0105483:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105488:	c9                   	leave  
c0105489:	c3                   	ret    

c010548a <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010548a:	55                   	push   %ebp
c010548b:	89 e5                	mov    %esp,%ebp
c010548d:	83 ec 38             	sub    $0x38,%esp
c0105490:	8b 45 10             	mov    0x10(%ebp),%eax
c0105493:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105496:	8b 45 14             	mov    0x14(%ebp),%eax
c0105499:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010549c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010549f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01054a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01054a5:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01054a8:	8b 45 18             	mov    0x18(%ebp),%eax
c01054ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01054ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01054b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01054b7:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01054ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01054c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01054c4:	74 1c                	je     c01054e2 <printnum+0x58>
c01054c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054c9:	ba 00 00 00 00       	mov    $0x0,%edx
c01054ce:	f7 75 e4             	divl   -0x1c(%ebp)
c01054d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01054d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054d7:	ba 00 00 00 00       	mov    $0x0,%edx
c01054dc:	f7 75 e4             	divl   -0x1c(%ebp)
c01054df:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01054e8:	f7 75 e4             	divl   -0x1c(%ebp)
c01054eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01054ee:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01054f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01054f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01054fa:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01054fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105500:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105503:	8b 45 18             	mov    0x18(%ebp),%eax
c0105506:	ba 00 00 00 00       	mov    $0x0,%edx
c010550b:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c010550e:	72 41                	jb     c0105551 <printnum+0xc7>
c0105510:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0105513:	77 05                	ja     c010551a <printnum+0x90>
c0105515:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0105518:	72 37                	jb     c0105551 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
c010551a:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010551d:	83 e8 01             	sub    $0x1,%eax
c0105520:	83 ec 04             	sub    $0x4,%esp
c0105523:	ff 75 20             	pushl  0x20(%ebp)
c0105526:	50                   	push   %eax
c0105527:	ff 75 18             	pushl  0x18(%ebp)
c010552a:	ff 75 ec             	pushl  -0x14(%ebp)
c010552d:	ff 75 e8             	pushl  -0x18(%ebp)
c0105530:	ff 75 0c             	pushl  0xc(%ebp)
c0105533:	ff 75 08             	pushl  0x8(%ebp)
c0105536:	e8 4f ff ff ff       	call   c010548a <printnum>
c010553b:	83 c4 20             	add    $0x20,%esp
c010553e:	eb 1b                	jmp    c010555b <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105540:	83 ec 08             	sub    $0x8,%esp
c0105543:	ff 75 0c             	pushl  0xc(%ebp)
c0105546:	ff 75 20             	pushl  0x20(%ebp)
c0105549:	8b 45 08             	mov    0x8(%ebp),%eax
c010554c:	ff d0                	call   *%eax
c010554e:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
c0105551:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105555:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105559:	7f e5                	jg     c0105540 <printnum+0xb6>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010555b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010555e:	05 64 6c 10 c0       	add    $0xc0106c64,%eax
c0105563:	0f b6 00             	movzbl (%eax),%eax
c0105566:	0f be c0             	movsbl %al,%eax
c0105569:	83 ec 08             	sub    $0x8,%esp
c010556c:	ff 75 0c             	pushl  0xc(%ebp)
c010556f:	50                   	push   %eax
c0105570:	8b 45 08             	mov    0x8(%ebp),%eax
c0105573:	ff d0                	call   *%eax
c0105575:	83 c4 10             	add    $0x10,%esp
}
c0105578:	90                   	nop
c0105579:	c9                   	leave  
c010557a:	c3                   	ret    

c010557b <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010557b:	55                   	push   %ebp
c010557c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010557e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105582:	7e 14                	jle    c0105598 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105584:	8b 45 08             	mov    0x8(%ebp),%eax
c0105587:	8b 00                	mov    (%eax),%eax
c0105589:	8d 48 08             	lea    0x8(%eax),%ecx
c010558c:	8b 55 08             	mov    0x8(%ebp),%edx
c010558f:	89 0a                	mov    %ecx,(%edx)
c0105591:	8b 50 04             	mov    0x4(%eax),%edx
c0105594:	8b 00                	mov    (%eax),%eax
c0105596:	eb 30                	jmp    c01055c8 <getuint+0x4d>
    }
    else if (lflag) {
c0105598:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010559c:	74 16                	je     c01055b4 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010559e:	8b 45 08             	mov    0x8(%ebp),%eax
c01055a1:	8b 00                	mov    (%eax),%eax
c01055a3:	8d 48 04             	lea    0x4(%eax),%ecx
c01055a6:	8b 55 08             	mov    0x8(%ebp),%edx
c01055a9:	89 0a                	mov    %ecx,(%edx)
c01055ab:	8b 00                	mov    (%eax),%eax
c01055ad:	ba 00 00 00 00       	mov    $0x0,%edx
c01055b2:	eb 14                	jmp    c01055c8 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01055b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01055b7:	8b 00                	mov    (%eax),%eax
c01055b9:	8d 48 04             	lea    0x4(%eax),%ecx
c01055bc:	8b 55 08             	mov    0x8(%ebp),%edx
c01055bf:	89 0a                	mov    %ecx,(%edx)
c01055c1:	8b 00                	mov    (%eax),%eax
c01055c3:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01055c8:	5d                   	pop    %ebp
c01055c9:	c3                   	ret    

c01055ca <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01055ca:	55                   	push   %ebp
c01055cb:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01055cd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01055d1:	7e 14                	jle    c01055e7 <getint+0x1d>
        return va_arg(*ap, long long);
c01055d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01055d6:	8b 00                	mov    (%eax),%eax
c01055d8:	8d 48 08             	lea    0x8(%eax),%ecx
c01055db:	8b 55 08             	mov    0x8(%ebp),%edx
c01055de:	89 0a                	mov    %ecx,(%edx)
c01055e0:	8b 50 04             	mov    0x4(%eax),%edx
c01055e3:	8b 00                	mov    (%eax),%eax
c01055e5:	eb 28                	jmp    c010560f <getint+0x45>
    }
    else if (lflag) {
c01055e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01055eb:	74 12                	je     c01055ff <getint+0x35>
        return va_arg(*ap, long);
c01055ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01055f0:	8b 00                	mov    (%eax),%eax
c01055f2:	8d 48 04             	lea    0x4(%eax),%ecx
c01055f5:	8b 55 08             	mov    0x8(%ebp),%edx
c01055f8:	89 0a                	mov    %ecx,(%edx)
c01055fa:	8b 00                	mov    (%eax),%eax
c01055fc:	99                   	cltd   
c01055fd:	eb 10                	jmp    c010560f <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01055ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0105602:	8b 00                	mov    (%eax),%eax
c0105604:	8d 48 04             	lea    0x4(%eax),%ecx
c0105607:	8b 55 08             	mov    0x8(%ebp),%edx
c010560a:	89 0a                	mov    %ecx,(%edx)
c010560c:	8b 00                	mov    (%eax),%eax
c010560e:	99                   	cltd   
    }
}
c010560f:	5d                   	pop    %ebp
c0105610:	c3                   	ret    

c0105611 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105611:	55                   	push   %ebp
c0105612:	89 e5                	mov    %esp,%ebp
c0105614:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c0105617:	8d 45 14             	lea    0x14(%ebp),%eax
c010561a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010561d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105620:	50                   	push   %eax
c0105621:	ff 75 10             	pushl  0x10(%ebp)
c0105624:	ff 75 0c             	pushl  0xc(%ebp)
c0105627:	ff 75 08             	pushl  0x8(%ebp)
c010562a:	e8 06 00 00 00       	call   c0105635 <vprintfmt>
c010562f:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c0105632:	90                   	nop
c0105633:	c9                   	leave  
c0105634:	c3                   	ret    

c0105635 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105635:	55                   	push   %ebp
c0105636:	89 e5                	mov    %esp,%ebp
c0105638:	56                   	push   %esi
c0105639:	53                   	push   %ebx
c010563a:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010563d:	eb 17                	jmp    c0105656 <vprintfmt+0x21>
            if (ch == '\0') {
c010563f:	85 db                	test   %ebx,%ebx
c0105641:	0f 84 8e 03 00 00    	je     c01059d5 <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
c0105647:	83 ec 08             	sub    $0x8,%esp
c010564a:	ff 75 0c             	pushl  0xc(%ebp)
c010564d:	53                   	push   %ebx
c010564e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105651:	ff d0                	call   *%eax
c0105653:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105656:	8b 45 10             	mov    0x10(%ebp),%eax
c0105659:	8d 50 01             	lea    0x1(%eax),%edx
c010565c:	89 55 10             	mov    %edx,0x10(%ebp)
c010565f:	0f b6 00             	movzbl (%eax),%eax
c0105662:	0f b6 d8             	movzbl %al,%ebx
c0105665:	83 fb 25             	cmp    $0x25,%ebx
c0105668:	75 d5                	jne    c010563f <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c010566a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010566e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105675:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105678:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010567b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105682:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105685:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105688:	8b 45 10             	mov    0x10(%ebp),%eax
c010568b:	8d 50 01             	lea    0x1(%eax),%edx
c010568e:	89 55 10             	mov    %edx,0x10(%ebp)
c0105691:	0f b6 00             	movzbl (%eax),%eax
c0105694:	0f b6 d8             	movzbl %al,%ebx
c0105697:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010569a:	83 f8 55             	cmp    $0x55,%eax
c010569d:	0f 87 05 03 00 00    	ja     c01059a8 <vprintfmt+0x373>
c01056a3:	8b 04 85 88 6c 10 c0 	mov    -0x3fef9378(,%eax,4),%eax
c01056aa:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01056ac:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01056b0:	eb d6                	jmp    c0105688 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01056b2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01056b6:	eb d0                	jmp    c0105688 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01056b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01056bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01056c2:	89 d0                	mov    %edx,%eax
c01056c4:	c1 e0 02             	shl    $0x2,%eax
c01056c7:	01 d0                	add    %edx,%eax
c01056c9:	01 c0                	add    %eax,%eax
c01056cb:	01 d8                	add    %ebx,%eax
c01056cd:	83 e8 30             	sub    $0x30,%eax
c01056d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01056d3:	8b 45 10             	mov    0x10(%ebp),%eax
c01056d6:	0f b6 00             	movzbl (%eax),%eax
c01056d9:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01056dc:	83 fb 2f             	cmp    $0x2f,%ebx
c01056df:	7e 39                	jle    c010571a <vprintfmt+0xe5>
c01056e1:	83 fb 39             	cmp    $0x39,%ebx
c01056e4:	7f 34                	jg     c010571a <vprintfmt+0xe5>
            for (precision = 0; ; ++ fmt) {
c01056e6:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
c01056ea:	eb d3                	jmp    c01056bf <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c01056ec:	8b 45 14             	mov    0x14(%ebp),%eax
c01056ef:	8d 50 04             	lea    0x4(%eax),%edx
c01056f2:	89 55 14             	mov    %edx,0x14(%ebp)
c01056f5:	8b 00                	mov    (%eax),%eax
c01056f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01056fa:	eb 1f                	jmp    c010571b <vprintfmt+0xe6>

        case '.':
            if (width < 0)
c01056fc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105700:	79 86                	jns    c0105688 <vprintfmt+0x53>
                width = 0;
c0105702:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105709:	e9 7a ff ff ff       	jmp    c0105688 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c010570e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105715:	e9 6e ff ff ff       	jmp    c0105688 <vprintfmt+0x53>
            goto process_precision;
c010571a:	90                   	nop

        process_precision:
            if (width < 0)
c010571b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010571f:	0f 89 63 ff ff ff    	jns    c0105688 <vprintfmt+0x53>
                width = precision, precision = -1;
c0105725:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105728:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010572b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105732:	e9 51 ff ff ff       	jmp    c0105688 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105737:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010573b:	e9 48 ff ff ff       	jmp    c0105688 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105740:	8b 45 14             	mov    0x14(%ebp),%eax
c0105743:	8d 50 04             	lea    0x4(%eax),%edx
c0105746:	89 55 14             	mov    %edx,0x14(%ebp)
c0105749:	8b 00                	mov    (%eax),%eax
c010574b:	83 ec 08             	sub    $0x8,%esp
c010574e:	ff 75 0c             	pushl  0xc(%ebp)
c0105751:	50                   	push   %eax
c0105752:	8b 45 08             	mov    0x8(%ebp),%eax
c0105755:	ff d0                	call   *%eax
c0105757:	83 c4 10             	add    $0x10,%esp
            break;
c010575a:	e9 71 02 00 00       	jmp    c01059d0 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010575f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105762:	8d 50 04             	lea    0x4(%eax),%edx
c0105765:	89 55 14             	mov    %edx,0x14(%ebp)
c0105768:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010576a:	85 db                	test   %ebx,%ebx
c010576c:	79 02                	jns    c0105770 <vprintfmt+0x13b>
                err = -err;
c010576e:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105770:	83 fb 06             	cmp    $0x6,%ebx
c0105773:	7f 0b                	jg     c0105780 <vprintfmt+0x14b>
c0105775:	8b 34 9d 48 6c 10 c0 	mov    -0x3fef93b8(,%ebx,4),%esi
c010577c:	85 f6                	test   %esi,%esi
c010577e:	75 19                	jne    c0105799 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
c0105780:	53                   	push   %ebx
c0105781:	68 75 6c 10 c0       	push   $0xc0106c75
c0105786:	ff 75 0c             	pushl  0xc(%ebp)
c0105789:	ff 75 08             	pushl  0x8(%ebp)
c010578c:	e8 80 fe ff ff       	call   c0105611 <printfmt>
c0105791:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105794:	e9 37 02 00 00       	jmp    c01059d0 <vprintfmt+0x39b>
                printfmt(putch, putdat, "%s", p);
c0105799:	56                   	push   %esi
c010579a:	68 7e 6c 10 c0       	push   $0xc0106c7e
c010579f:	ff 75 0c             	pushl  0xc(%ebp)
c01057a2:	ff 75 08             	pushl  0x8(%ebp)
c01057a5:	e8 67 fe ff ff       	call   c0105611 <printfmt>
c01057aa:	83 c4 10             	add    $0x10,%esp
            break;
c01057ad:	e9 1e 02 00 00       	jmp    c01059d0 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01057b2:	8b 45 14             	mov    0x14(%ebp),%eax
c01057b5:	8d 50 04             	lea    0x4(%eax),%edx
c01057b8:	89 55 14             	mov    %edx,0x14(%ebp)
c01057bb:	8b 30                	mov    (%eax),%esi
c01057bd:	85 f6                	test   %esi,%esi
c01057bf:	75 05                	jne    c01057c6 <vprintfmt+0x191>
                p = "(null)";
c01057c1:	be 81 6c 10 c0       	mov    $0xc0106c81,%esi
            }
            if (width > 0 && padc != '-') {
c01057c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057ca:	7e 76                	jle    c0105842 <vprintfmt+0x20d>
c01057cc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01057d0:	74 70                	je     c0105842 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01057d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057d5:	83 ec 08             	sub    $0x8,%esp
c01057d8:	50                   	push   %eax
c01057d9:	56                   	push   %esi
c01057da:	e8 17 f8 ff ff       	call   c0104ff6 <strnlen>
c01057df:	83 c4 10             	add    $0x10,%esp
c01057e2:	89 c2                	mov    %eax,%edx
c01057e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057e7:	29 d0                	sub    %edx,%eax
c01057e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057ec:	eb 17                	jmp    c0105805 <vprintfmt+0x1d0>
                    putch(padc, putdat);
c01057ee:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01057f2:	83 ec 08             	sub    $0x8,%esp
c01057f5:	ff 75 0c             	pushl  0xc(%ebp)
c01057f8:	50                   	push   %eax
c01057f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01057fc:	ff d0                	call   *%eax
c01057fe:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105801:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105805:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105809:	7f e3                	jg     c01057ee <vprintfmt+0x1b9>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010580b:	eb 35                	jmp    c0105842 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
c010580d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105811:	74 1c                	je     c010582f <vprintfmt+0x1fa>
c0105813:	83 fb 1f             	cmp    $0x1f,%ebx
c0105816:	7e 05                	jle    c010581d <vprintfmt+0x1e8>
c0105818:	83 fb 7e             	cmp    $0x7e,%ebx
c010581b:	7e 12                	jle    c010582f <vprintfmt+0x1fa>
                    putch('?', putdat);
c010581d:	83 ec 08             	sub    $0x8,%esp
c0105820:	ff 75 0c             	pushl  0xc(%ebp)
c0105823:	6a 3f                	push   $0x3f
c0105825:	8b 45 08             	mov    0x8(%ebp),%eax
c0105828:	ff d0                	call   *%eax
c010582a:	83 c4 10             	add    $0x10,%esp
c010582d:	eb 0f                	jmp    c010583e <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
c010582f:	83 ec 08             	sub    $0x8,%esp
c0105832:	ff 75 0c             	pushl  0xc(%ebp)
c0105835:	53                   	push   %ebx
c0105836:	8b 45 08             	mov    0x8(%ebp),%eax
c0105839:	ff d0                	call   *%eax
c010583b:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010583e:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105842:	89 f0                	mov    %esi,%eax
c0105844:	8d 70 01             	lea    0x1(%eax),%esi
c0105847:	0f b6 00             	movzbl (%eax),%eax
c010584a:	0f be d8             	movsbl %al,%ebx
c010584d:	85 db                	test   %ebx,%ebx
c010584f:	74 26                	je     c0105877 <vprintfmt+0x242>
c0105851:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105855:	78 b6                	js     c010580d <vprintfmt+0x1d8>
c0105857:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c010585b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010585f:	79 ac                	jns    c010580d <vprintfmt+0x1d8>
                }
            }
            for (; width > 0; width --) {
c0105861:	eb 14                	jmp    c0105877 <vprintfmt+0x242>
                putch(' ', putdat);
c0105863:	83 ec 08             	sub    $0x8,%esp
c0105866:	ff 75 0c             	pushl  0xc(%ebp)
c0105869:	6a 20                	push   $0x20
c010586b:	8b 45 08             	mov    0x8(%ebp),%eax
c010586e:	ff d0                	call   *%eax
c0105870:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
c0105873:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105877:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010587b:	7f e6                	jg     c0105863 <vprintfmt+0x22e>
            }
            break;
c010587d:	e9 4e 01 00 00       	jmp    c01059d0 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105882:	83 ec 08             	sub    $0x8,%esp
c0105885:	ff 75 e0             	pushl  -0x20(%ebp)
c0105888:	8d 45 14             	lea    0x14(%ebp),%eax
c010588b:	50                   	push   %eax
c010588c:	e8 39 fd ff ff       	call   c01055ca <getint>
c0105891:	83 c4 10             	add    $0x10,%esp
c0105894:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105897:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010589a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010589d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01058a0:	85 d2                	test   %edx,%edx
c01058a2:	79 23                	jns    c01058c7 <vprintfmt+0x292>
                putch('-', putdat);
c01058a4:	83 ec 08             	sub    $0x8,%esp
c01058a7:	ff 75 0c             	pushl  0xc(%ebp)
c01058aa:	6a 2d                	push   $0x2d
c01058ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01058af:	ff d0                	call   *%eax
c01058b1:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c01058b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01058ba:	f7 d8                	neg    %eax
c01058bc:	83 d2 00             	adc    $0x0,%edx
c01058bf:	f7 da                	neg    %edx
c01058c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058c4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01058c7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058ce:	e9 9f 00 00 00       	jmp    c0105972 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01058d3:	83 ec 08             	sub    $0x8,%esp
c01058d6:	ff 75 e0             	pushl  -0x20(%ebp)
c01058d9:	8d 45 14             	lea    0x14(%ebp),%eax
c01058dc:	50                   	push   %eax
c01058dd:	e8 99 fc ff ff       	call   c010557b <getuint>
c01058e2:	83 c4 10             	add    $0x10,%esp
c01058e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01058eb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058f2:	eb 7e                	jmp    c0105972 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01058f4:	83 ec 08             	sub    $0x8,%esp
c01058f7:	ff 75 e0             	pushl  -0x20(%ebp)
c01058fa:	8d 45 14             	lea    0x14(%ebp),%eax
c01058fd:	50                   	push   %eax
c01058fe:	e8 78 fc ff ff       	call   c010557b <getuint>
c0105903:	83 c4 10             	add    $0x10,%esp
c0105906:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105909:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010590c:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105913:	eb 5d                	jmp    c0105972 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
c0105915:	83 ec 08             	sub    $0x8,%esp
c0105918:	ff 75 0c             	pushl  0xc(%ebp)
c010591b:	6a 30                	push   $0x30
c010591d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105920:	ff d0                	call   *%eax
c0105922:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c0105925:	83 ec 08             	sub    $0x8,%esp
c0105928:	ff 75 0c             	pushl  0xc(%ebp)
c010592b:	6a 78                	push   $0x78
c010592d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105930:	ff d0                	call   *%eax
c0105932:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105935:	8b 45 14             	mov    0x14(%ebp),%eax
c0105938:	8d 50 04             	lea    0x4(%eax),%edx
c010593b:	89 55 14             	mov    %edx,0x14(%ebp)
c010593e:	8b 00                	mov    (%eax),%eax
c0105940:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105943:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010594a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105951:	eb 1f                	jmp    c0105972 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105953:	83 ec 08             	sub    $0x8,%esp
c0105956:	ff 75 e0             	pushl  -0x20(%ebp)
c0105959:	8d 45 14             	lea    0x14(%ebp),%eax
c010595c:	50                   	push   %eax
c010595d:	e8 19 fc ff ff       	call   c010557b <getuint>
c0105962:	83 c4 10             	add    $0x10,%esp
c0105965:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105968:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010596b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105972:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105976:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105979:	83 ec 04             	sub    $0x4,%esp
c010597c:	52                   	push   %edx
c010597d:	ff 75 e8             	pushl  -0x18(%ebp)
c0105980:	50                   	push   %eax
c0105981:	ff 75 f4             	pushl  -0xc(%ebp)
c0105984:	ff 75 f0             	pushl  -0x10(%ebp)
c0105987:	ff 75 0c             	pushl  0xc(%ebp)
c010598a:	ff 75 08             	pushl  0x8(%ebp)
c010598d:	e8 f8 fa ff ff       	call   c010548a <printnum>
c0105992:	83 c4 20             	add    $0x20,%esp
            break;
c0105995:	eb 39                	jmp    c01059d0 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105997:	83 ec 08             	sub    $0x8,%esp
c010599a:	ff 75 0c             	pushl  0xc(%ebp)
c010599d:	53                   	push   %ebx
c010599e:	8b 45 08             	mov    0x8(%ebp),%eax
c01059a1:	ff d0                	call   *%eax
c01059a3:	83 c4 10             	add    $0x10,%esp
            break;
c01059a6:	eb 28                	jmp    c01059d0 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01059a8:	83 ec 08             	sub    $0x8,%esp
c01059ab:	ff 75 0c             	pushl  0xc(%ebp)
c01059ae:	6a 25                	push   $0x25
c01059b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b3:	ff d0                	call   *%eax
c01059b5:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c01059b8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01059bc:	eb 04                	jmp    c01059c2 <vprintfmt+0x38d>
c01059be:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01059c2:	8b 45 10             	mov    0x10(%ebp),%eax
c01059c5:	83 e8 01             	sub    $0x1,%eax
c01059c8:	0f b6 00             	movzbl (%eax),%eax
c01059cb:	3c 25                	cmp    $0x25,%al
c01059cd:	75 ef                	jne    c01059be <vprintfmt+0x389>
                /* do nothing */;
            break;
c01059cf:	90                   	nop
    while (1) {
c01059d0:	e9 68 fc ff ff       	jmp    c010563d <vprintfmt+0x8>
                return;
c01059d5:	90                   	nop
        }
    }
}
c01059d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01059d9:	5b                   	pop    %ebx
c01059da:	5e                   	pop    %esi
c01059db:	5d                   	pop    %ebp
c01059dc:	c3                   	ret    

c01059dd <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01059dd:	55                   	push   %ebp
c01059de:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01059e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059e3:	8b 40 08             	mov    0x8(%eax),%eax
c01059e6:	8d 50 01             	lea    0x1(%eax),%edx
c01059e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059ec:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01059ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059f2:	8b 10                	mov    (%eax),%edx
c01059f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059f7:	8b 40 04             	mov    0x4(%eax),%eax
c01059fa:	39 c2                	cmp    %eax,%edx
c01059fc:	73 12                	jae    c0105a10 <sprintputch+0x33>
        *b->buf ++ = ch;
c01059fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a01:	8b 00                	mov    (%eax),%eax
c0105a03:	8d 48 01             	lea    0x1(%eax),%ecx
c0105a06:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105a09:	89 0a                	mov    %ecx,(%edx)
c0105a0b:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a0e:	88 10                	mov    %dl,(%eax)
    }
}
c0105a10:	90                   	nop
c0105a11:	5d                   	pop    %ebp
c0105a12:	c3                   	ret    

c0105a13 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105a13:	55                   	push   %ebp
c0105a14:	89 e5                	mov    %esp,%ebp
c0105a16:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105a19:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a22:	50                   	push   %eax
c0105a23:	ff 75 10             	pushl  0x10(%ebp)
c0105a26:	ff 75 0c             	pushl  0xc(%ebp)
c0105a29:	ff 75 08             	pushl  0x8(%ebp)
c0105a2c:	e8 0b 00 00 00       	call   c0105a3c <vsnprintf>
c0105a31:	83 c4 10             	add    $0x10,%esp
c0105a34:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a3a:	c9                   	leave  
c0105a3b:	c3                   	ret    

c0105a3c <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105a3c:	55                   	push   %ebp
c0105a3d:	89 e5                	mov    %esp,%ebp
c0105a3f:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105a42:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a45:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a48:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a4b:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a51:	01 d0                	add    %edx,%eax
c0105a53:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105a5d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105a61:	74 0a                	je     c0105a6d <vsnprintf+0x31>
c0105a63:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a69:	39 c2                	cmp    %eax,%edx
c0105a6b:	76 07                	jbe    c0105a74 <vsnprintf+0x38>
        return -E_INVAL;
c0105a6d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105a72:	eb 20                	jmp    c0105a94 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105a74:	ff 75 14             	pushl  0x14(%ebp)
c0105a77:	ff 75 10             	pushl  0x10(%ebp)
c0105a7a:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105a7d:	50                   	push   %eax
c0105a7e:	68 dd 59 10 c0       	push   $0xc01059dd
c0105a83:	e8 ad fb ff ff       	call   c0105635 <vprintfmt>
c0105a88:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c0105a8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a8e:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a94:	c9                   	leave  
c0105a95:	c3                   	ret    
