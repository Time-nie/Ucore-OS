
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int kern_init(void)
{
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 80 fd 10 00       	mov    $0x10fd80,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 ad 2d 00 00       	call   102dd9 <memset>

    cons_init(); // init the console
  10002c:	e8 52 15 00 00       	call   101583 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 e0 35 10 00 	movl   $0x1035e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 fc 35 10 00 	movl   $0x1035fc,(%esp)
  100046:	e8 21 02 00 00       	call   10026c <cprintf>

    print_kerninfo();
  10004b:	e8 c2 08 00 00       	call   100912 <print_kerninfo>

    grade_backtrace();
  100050:	e8 8e 00 00 00       	call   1000e3 <grade_backtrace>

    pmm_init(); // init physical memory management
  100055:	e8 54 2a 00 00       	call   102aae <pmm_init>

    pic_init(); // init interrupt controller
  10005a:	e8 63 16 00 00       	call   1016c2 <pic_init>
    idt_init(); // init interrupt descriptor table
  10005f:	e8 c3 17 00 00       	call   101827 <idt_init>

    clock_init();  // init clock interrupt
  100064:	e8 fb 0c 00 00       	call   100d64 <clock_init>
    intr_enable(); // enable irq interrupt
  100069:	e8 8e 17 00 00       	call   1017fc <intr_enable>

    // LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    //  user/kernel mode switch test
    lab1_switch_test();
  10006e:	e8 6b 01 00 00       	call   1001de <lab1_switch_test>

    /* do nothing */
    while (1)
  100073:	eb fe                	jmp    100073 <kern_init+0x73>

00100075 <grade_backtrace2>:
        ;
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3)
{
  100075:	55                   	push   %ebp
  100076:	89 e5                	mov    %esp,%ebp
  100078:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100082:	00 
  100083:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10008a:	00 
  10008b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100092:	e8 bb 0c 00 00       	call   100d52 <mon_backtrace>
}
  100097:	90                   	nop
  100098:	c9                   	leave  
  100099:	c3                   	ret    

0010009a <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1)
{
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	53                   	push   %ebx
  10009e:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a1:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000a7:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1000ad:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000b1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000b5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000b9:	89 04 24             	mov    %eax,(%esp)
  1000bc:	e8 b4 ff ff ff       	call   100075 <grade_backtrace2>
}
  1000c1:	90                   	nop
  1000c2:	83 c4 14             	add    $0x14,%esp
  1000c5:	5b                   	pop    %ebx
  1000c6:	5d                   	pop    %ebp
  1000c7:	c3                   	ret    

001000c8 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2)
{
  1000c8:	55                   	push   %ebp
  1000c9:	89 e5                	mov    %esp,%ebp
  1000cb:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1000d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d8:	89 04 24             	mov    %eax,(%esp)
  1000db:	e8 ba ff ff ff       	call   10009a <grade_backtrace1>
}
  1000e0:	90                   	nop
  1000e1:	c9                   	leave  
  1000e2:	c3                   	ret    

001000e3 <grade_backtrace>:

void grade_backtrace(void)
{
  1000e3:	55                   	push   %ebp
  1000e4:	89 e5                	mov    %esp,%ebp
  1000e6:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e9:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000ee:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f5:	ff 
  1000f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100101:	e8 c2 ff ff ff       	call   1000c8 <grade_backtrace0>
}
  100106:	90                   	nop
  100107:	c9                   	leave  
  100108:	c3                   	ret    

00100109 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void)
{
  100109:	55                   	push   %ebp
  10010a:	89 e5                	mov    %esp,%ebp
  10010c:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile(
  10010f:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100112:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100115:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100118:	8c 55 f0             	mov    %ss,-0x10(%ebp)
        "mov %%cs, %0;"
        "mov %%ds, %1;"
        "mov %%es, %2;"
        "mov %%ss, %3;"
        : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10011b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011f:	83 e0 03             	and    $0x3,%eax
  100122:	89 c2                	mov    %eax,%edx
  100124:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100129:	89 54 24 08          	mov    %edx,0x8(%esp)
  10012d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100131:	c7 04 24 01 36 10 00 	movl   $0x103601,(%esp)
  100138:	e8 2f 01 00 00       	call   10026c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10013d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100141:	89 c2                	mov    %eax,%edx
  100143:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100148:	89 54 24 08          	mov    %edx,0x8(%esp)
  10014c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100150:	c7 04 24 0f 36 10 00 	movl   $0x10360f,(%esp)
  100157:	e8 10 01 00 00       	call   10026c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10015c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100160:	89 c2                	mov    %eax,%edx
  100162:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100167:	89 54 24 08          	mov    %edx,0x8(%esp)
  10016b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016f:	c7 04 24 1d 36 10 00 	movl   $0x10361d,(%esp)
  100176:	e8 f1 00 00 00       	call   10026c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10017b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017f:	89 c2                	mov    %eax,%edx
  100181:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100186:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018e:	c7 04 24 2b 36 10 00 	movl   $0x10362b,(%esp)
  100195:	e8 d2 00 00 00       	call   10026c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019a:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019e:	89 c2                	mov    %eax,%edx
  1001a0:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a5:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ad:	c7 04 24 39 36 10 00 	movl   $0x103639,(%esp)
  1001b4:	e8 b3 00 00 00       	call   10026c <cprintf>
    round++;
  1001b9:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001be:	40                   	inc    %eax
  1001bf:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c4:	90                   	nop
  1001c5:	c9                   	leave  
  1001c6:	c3                   	ret    

001001c7 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void)
{
  1001c7:	55                   	push   %ebp
  1001c8:	89 e5                	mov    %esp,%ebp
    // LAB1 CHALLENGE 1 : TODO
    asm volatile(
  1001ca:	83 ec 08             	sub    $0x8,%esp
  1001cd:	cd 78                	int    $0x78
  1001cf:	89 ec                	mov    %ebp,%esp
        "sub $0x8, %%esp \n"
        "int %0 \n"
        "movl %%ebp, %%esp"
        :
        : "i"(T_SWITCH_TOU));
}
  1001d1:	90                   	nop
  1001d2:	5d                   	pop    %ebp
  1001d3:	c3                   	ret    

001001d4 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void)
{
  1001d4:	55                   	push   %ebp
  1001d5:	89 e5                	mov    %esp,%ebp
    // LAB1 CHALLENGE 1 :  TODO
    asm volatile(
  1001d7:	cd 79                	int    $0x79
  1001d9:	89 ec                	mov    %ebp,%esp
        "int %0 \n"
        "movl %%ebp, %%esp \n"
        :
        : "i"(T_SWITCH_TOK));
}
  1001db:	90                   	nop
  1001dc:	5d                   	pop    %ebp
  1001dd:	c3                   	ret    

001001de <lab1_switch_test>:

static void
lab1_switch_test(void)
{
  1001de:	55                   	push   %ebp
  1001df:	89 e5                	mov    %esp,%ebp
  1001e1:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001e4:	e8 20 ff ff ff       	call   100109 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001e9:	c7 04 24 48 36 10 00 	movl   $0x103648,(%esp)
  1001f0:	e8 77 00 00 00       	call   10026c <cprintf>
    lab1_switch_to_user();
  1001f5:	e8 cd ff ff ff       	call   1001c7 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001fa:	e8 0a ff ff ff       	call   100109 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001ff:	c7 04 24 68 36 10 00 	movl   $0x103668,(%esp)
  100206:	e8 61 00 00 00       	call   10026c <cprintf>
    lab1_switch_to_kernel();
  10020b:	e8 c4 ff ff ff       	call   1001d4 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100210:	e8 f4 fe ff ff       	call   100109 <lab1_print_cur_status>
}
  100215:	90                   	nop
  100216:	c9                   	leave  
  100217:	c3                   	ret    

00100218 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100218:	55                   	push   %ebp
  100219:	89 e5                	mov    %esp,%ebp
  10021b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10021e:	8b 45 08             	mov    0x8(%ebp),%eax
  100221:	89 04 24             	mov    %eax,(%esp)
  100224:	e8 87 13 00 00       	call   1015b0 <cons_putc>
    (*cnt) ++;
  100229:	8b 45 0c             	mov    0xc(%ebp),%eax
  10022c:	8b 00                	mov    (%eax),%eax
  10022e:	8d 50 01             	lea    0x1(%eax),%edx
  100231:	8b 45 0c             	mov    0xc(%ebp),%eax
  100234:	89 10                	mov    %edx,(%eax)
}
  100236:	90                   	nop
  100237:	c9                   	leave  
  100238:	c3                   	ret    

00100239 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100239:	55                   	push   %ebp
  10023a:	89 e5                	mov    %esp,%ebp
  10023c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10023f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100246:	8b 45 0c             	mov    0xc(%ebp),%eax
  100249:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10024d:	8b 45 08             	mov    0x8(%ebp),%eax
  100250:	89 44 24 08          	mov    %eax,0x8(%esp)
  100254:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100257:	89 44 24 04          	mov    %eax,0x4(%esp)
  10025b:	c7 04 24 18 02 10 00 	movl   $0x100218,(%esp)
  100262:	e8 c5 2e 00 00       	call   10312c <vprintfmt>
    return cnt;
  100267:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10026a:	c9                   	leave  
  10026b:	c3                   	ret    

0010026c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10026c:	55                   	push   %ebp
  10026d:	89 e5                	mov    %esp,%ebp
  10026f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100272:	8d 45 0c             	lea    0xc(%ebp),%eax
  100275:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10027b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10027f:	8b 45 08             	mov    0x8(%ebp),%eax
  100282:	89 04 24             	mov    %eax,(%esp)
  100285:	e8 af ff ff ff       	call   100239 <vcprintf>
  10028a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10028d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100290:	c9                   	leave  
  100291:	c3                   	ret    

00100292 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100292:	55                   	push   %ebp
  100293:	89 e5                	mov    %esp,%ebp
  100295:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100298:	8b 45 08             	mov    0x8(%ebp),%eax
  10029b:	89 04 24             	mov    %eax,(%esp)
  10029e:	e8 0d 13 00 00       	call   1015b0 <cons_putc>
}
  1002a3:	90                   	nop
  1002a4:	c9                   	leave  
  1002a5:	c3                   	ret    

001002a6 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002a6:	55                   	push   %ebp
  1002a7:	89 e5                	mov    %esp,%ebp
  1002a9:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002b3:	eb 13                	jmp    1002c8 <cputs+0x22>
        cputch(c, &cnt);
  1002b5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002b9:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002bc:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002c0:	89 04 24             	mov    %eax,(%esp)
  1002c3:	e8 50 ff ff ff       	call   100218 <cputch>
    while ((c = *str ++) != '\0') {
  1002c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1002cb:	8d 50 01             	lea    0x1(%eax),%edx
  1002ce:	89 55 08             	mov    %edx,0x8(%ebp)
  1002d1:	0f b6 00             	movzbl (%eax),%eax
  1002d4:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002d7:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002db:	75 d8                	jne    1002b5 <cputs+0xf>
    }
    cputch('\n', &cnt);
  1002dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002e4:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1002eb:	e8 28 ff ff ff       	call   100218 <cputch>
    return cnt;
  1002f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002f3:	c9                   	leave  
  1002f4:	c3                   	ret    

001002f5 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002f5:	55                   	push   %ebp
  1002f6:	89 e5                	mov    %esp,%ebp
  1002f8:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002fb:	e8 da 12 00 00       	call   1015da <cons_getc>
  100300:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100303:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100307:	74 f2                	je     1002fb <getchar+0x6>
        /* do nothing */;
    return c;
  100309:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10030c:	c9                   	leave  
  10030d:	c3                   	ret    

0010030e <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10030e:	55                   	push   %ebp
  10030f:	89 e5                	mov    %esp,%ebp
  100311:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100314:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100318:	74 13                	je     10032d <readline+0x1f>
        cprintf("%s", prompt);
  10031a:	8b 45 08             	mov    0x8(%ebp),%eax
  10031d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100321:	c7 04 24 87 36 10 00 	movl   $0x103687,(%esp)
  100328:	e8 3f ff ff ff       	call   10026c <cprintf>
    }
    int i = 0, c;
  10032d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100334:	e8 bc ff ff ff       	call   1002f5 <getchar>
  100339:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10033c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100340:	79 07                	jns    100349 <readline+0x3b>
            return NULL;
  100342:	b8 00 00 00 00       	mov    $0x0,%eax
  100347:	eb 78                	jmp    1003c1 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100349:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10034d:	7e 28                	jle    100377 <readline+0x69>
  10034f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100356:	7f 1f                	jg     100377 <readline+0x69>
            cputchar(c);
  100358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10035b:	89 04 24             	mov    %eax,(%esp)
  10035e:	e8 2f ff ff ff       	call   100292 <cputchar>
            buf[i ++] = c;
  100363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100366:	8d 50 01             	lea    0x1(%eax),%edx
  100369:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10036c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10036f:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100375:	eb 45                	jmp    1003bc <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  100377:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10037b:	75 16                	jne    100393 <readline+0x85>
  10037d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100381:	7e 10                	jle    100393 <readline+0x85>
            cputchar(c);
  100383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100386:	89 04 24             	mov    %eax,(%esp)
  100389:	e8 04 ff ff ff       	call   100292 <cputchar>
            i --;
  10038e:	ff 4d f4             	decl   -0xc(%ebp)
  100391:	eb 29                	jmp    1003bc <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  100393:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100397:	74 06                	je     10039f <readline+0x91>
  100399:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10039d:	75 95                	jne    100334 <readline+0x26>
            cputchar(c);
  10039f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003a2:	89 04 24             	mov    %eax,(%esp)
  1003a5:	e8 e8 fe ff ff       	call   100292 <cputchar>
            buf[i] = '\0';
  1003aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003ad:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1003b2:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003b5:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1003ba:	eb 05                	jmp    1003c1 <readline+0xb3>
        c = getchar();
  1003bc:	e9 73 ff ff ff       	jmp    100334 <readline+0x26>
        }
    }
}
  1003c1:	c9                   	leave  
  1003c2:	c3                   	ret    

001003c3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003c3:	55                   	push   %ebp
  1003c4:	89 e5                	mov    %esp,%ebp
  1003c6:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003c9:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003ce:	85 c0                	test   %eax,%eax
  1003d0:	75 5b                	jne    10042d <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  1003d2:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003d9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003dc:	8d 45 14             	lea    0x14(%ebp),%eax
  1003df:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1003e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1003ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003f0:	c7 04 24 8a 36 10 00 	movl   $0x10368a,(%esp)
  1003f7:	e8 70 fe ff ff       	call   10026c <cprintf>
    vcprintf(fmt, ap);
  1003fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  100403:	8b 45 10             	mov    0x10(%ebp),%eax
  100406:	89 04 24             	mov    %eax,(%esp)
  100409:	e8 2b fe ff ff       	call   100239 <vcprintf>
    cprintf("\n");
  10040e:	c7 04 24 a6 36 10 00 	movl   $0x1036a6,(%esp)
  100415:	e8 52 fe ff ff       	call   10026c <cprintf>
    
    cprintf("stack trackback:\n");
  10041a:	c7 04 24 a8 36 10 00 	movl   $0x1036a8,(%esp)
  100421:	e8 46 fe ff ff       	call   10026c <cprintf>
    print_stackframe();
  100426:	e8 32 06 00 00       	call   100a5d <print_stackframe>
  10042b:	eb 01                	jmp    10042e <__panic+0x6b>
        goto panic_dead;
  10042d:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  10042e:	e8 d0 13 00 00       	call   101803 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100433:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10043a:	e8 46 08 00 00       	call   100c85 <kmonitor>
  10043f:	eb f2                	jmp    100433 <__panic+0x70>

00100441 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100441:	55                   	push   %ebp
  100442:	89 e5                	mov    %esp,%ebp
  100444:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100447:	8d 45 14             	lea    0x14(%ebp),%eax
  10044a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10044d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100450:	89 44 24 08          	mov    %eax,0x8(%esp)
  100454:	8b 45 08             	mov    0x8(%ebp),%eax
  100457:	89 44 24 04          	mov    %eax,0x4(%esp)
  10045b:	c7 04 24 ba 36 10 00 	movl   $0x1036ba,(%esp)
  100462:	e8 05 fe ff ff       	call   10026c <cprintf>
    vcprintf(fmt, ap);
  100467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10046a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10046e:	8b 45 10             	mov    0x10(%ebp),%eax
  100471:	89 04 24             	mov    %eax,(%esp)
  100474:	e8 c0 fd ff ff       	call   100239 <vcprintf>
    cprintf("\n");
  100479:	c7 04 24 a6 36 10 00 	movl   $0x1036a6,(%esp)
  100480:	e8 e7 fd ff ff       	call   10026c <cprintf>
    va_end(ap);
}
  100485:	90                   	nop
  100486:	c9                   	leave  
  100487:	c3                   	ret    

00100488 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100488:	55                   	push   %ebp
  100489:	89 e5                	mov    %esp,%ebp
    return is_panic;
  10048b:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100490:	5d                   	pop    %ebp
  100491:	c3                   	ret    

00100492 <stab_binsearch>:
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
               int type, uintptr_t addr)
{
  100492:	55                   	push   %ebp
  100493:	89 e5                	mov    %esp,%ebp
  100495:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100498:	8b 45 0c             	mov    0xc(%ebp),%eax
  10049b:	8b 00                	mov    (%eax),%eax
  10049d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004a0:	8b 45 10             	mov    0x10(%ebp),%eax
  1004a3:	8b 00                	mov    (%eax),%eax
  1004a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r)
  1004af:	e9 ca 00 00 00       	jmp    10057e <stab_binsearch+0xec>
    {
        int true_m = (l + r) / 2, m = true_m;
  1004b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004ba:	01 d0                	add    %edx,%eax
  1004bc:	89 c2                	mov    %eax,%edx
  1004be:	c1 ea 1f             	shr    $0x1f,%edx
  1004c1:	01 d0                	add    %edx,%eax
  1004c3:	d1 f8                	sar    %eax
  1004c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004cb:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type)
  1004ce:	eb 03                	jmp    1004d3 <stab_binsearch+0x41>
        {
            m--;
  1004d0:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type)
  1004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004d9:	7c 1f                	jl     1004fa <stab_binsearch+0x68>
  1004db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004de:	89 d0                	mov    %edx,%eax
  1004e0:	01 c0                	add    %eax,%eax
  1004e2:	01 d0                	add    %edx,%eax
  1004e4:	c1 e0 02             	shl    $0x2,%eax
  1004e7:	89 c2                	mov    %eax,%edx
  1004e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ec:	01 d0                	add    %edx,%eax
  1004ee:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f2:	0f b6 c0             	movzbl %al,%eax
  1004f5:	39 45 14             	cmp    %eax,0x14(%ebp)
  1004f8:	75 d6                	jne    1004d0 <stab_binsearch+0x3e>
        }
        if (m < l)
  1004fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004fd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100500:	7d 09                	jge    10050b <stab_binsearch+0x79>
        { // no match in [l, m]
            l = true_m + 1;
  100502:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100505:	40                   	inc    %eax
  100506:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100509:	eb 73                	jmp    10057e <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  10050b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr)
  100512:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100515:	89 d0                	mov    %edx,%eax
  100517:	01 c0                	add    %eax,%eax
  100519:	01 d0                	add    %edx,%eax
  10051b:	c1 e0 02             	shl    $0x2,%eax
  10051e:	89 c2                	mov    %eax,%edx
  100520:	8b 45 08             	mov    0x8(%ebp),%eax
  100523:	01 d0                	add    %edx,%eax
  100525:	8b 40 08             	mov    0x8(%eax),%eax
  100528:	39 45 18             	cmp    %eax,0x18(%ebp)
  10052b:	76 11                	jbe    10053e <stab_binsearch+0xac>
        {
            *region_left = m;
  10052d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100530:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100533:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100535:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100538:	40                   	inc    %eax
  100539:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10053c:	eb 40                	jmp    10057e <stab_binsearch+0xec>
        }
        else if (stabs[m].n_value > addr)
  10053e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100541:	89 d0                	mov    %edx,%eax
  100543:	01 c0                	add    %eax,%eax
  100545:	01 d0                	add    %edx,%eax
  100547:	c1 e0 02             	shl    $0x2,%eax
  10054a:	89 c2                	mov    %eax,%edx
  10054c:	8b 45 08             	mov    0x8(%ebp),%eax
  10054f:	01 d0                	add    %edx,%eax
  100551:	8b 40 08             	mov    0x8(%eax),%eax
  100554:	39 45 18             	cmp    %eax,0x18(%ebp)
  100557:	73 14                	jae    10056d <stab_binsearch+0xdb>
        {
            *region_right = m - 1;
  100559:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10055c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10055f:	8b 45 10             	mov    0x10(%ebp),%eax
  100562:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100567:	48                   	dec    %eax
  100568:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10056b:	eb 11                	jmp    10057e <stab_binsearch+0xec>
        }
        else
        {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10056d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100570:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100573:	89 10                	mov    %edx,(%eax)
            l = m;
  100575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100578:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr++;
  10057b:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r)
  10057e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100581:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100584:	0f 8e 2a ff ff ff    	jle    1004b4 <stab_binsearch+0x22>
        }
    }

    if (!any_matches)
  10058a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10058e:	75 0f                	jne    10059f <stab_binsearch+0x10d>
    {
        *region_right = *region_left - 1;
  100590:	8b 45 0c             	mov    0xc(%ebp),%eax
  100593:	8b 00                	mov    (%eax),%eax
  100595:	8d 50 ff             	lea    -0x1(%eax),%edx
  100598:	8b 45 10             	mov    0x10(%ebp),%eax
  10059b:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l--)
            /* do nothing */;
        *region_left = l;
    }
}
  10059d:	eb 3e                	jmp    1005dd <stab_binsearch+0x14b>
        l = *region_right;
  10059f:	8b 45 10             	mov    0x10(%ebp),%eax
  1005a2:	8b 00                	mov    (%eax),%eax
  1005a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l--)
  1005a7:	eb 03                	jmp    1005ac <stab_binsearch+0x11a>
  1005a9:	ff 4d fc             	decl   -0x4(%ebp)
  1005ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005af:	8b 00                	mov    (%eax),%eax
  1005b1:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1005b4:	7e 1f                	jle    1005d5 <stab_binsearch+0x143>
  1005b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005b9:	89 d0                	mov    %edx,%eax
  1005bb:	01 c0                	add    %eax,%eax
  1005bd:	01 d0                	add    %edx,%eax
  1005bf:	c1 e0 02             	shl    $0x2,%eax
  1005c2:	89 c2                	mov    %eax,%edx
  1005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005c7:	01 d0                	add    %edx,%eax
  1005c9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005cd:	0f b6 c0             	movzbl %al,%eax
  1005d0:	39 45 14             	cmp    %eax,0x14(%ebp)
  1005d3:	75 d4                	jne    1005a9 <stab_binsearch+0x117>
        *region_left = l;
  1005d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005db:	89 10                	mov    %edx,(%eax)
}
  1005dd:	90                   	nop
  1005de:	c9                   	leave  
  1005df:	c3                   	ret    

001005e0 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info)
{
  1005e0:	55                   	push   %ebp
  1005e1:	89 e5                	mov    %esp,%ebp
  1005e3:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e9:	c7 00 d8 36 10 00    	movl   $0x1036d8,(%eax)
    info->eip_line = 0;
  1005ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fc:	c7 40 08 d8 36 10 00 	movl   $0x1036d8,0x8(%eax)
    info->eip_fn_namelen = 9;
  100603:	8b 45 0c             	mov    0xc(%ebp),%eax
  100606:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10060d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100610:	8b 55 08             	mov    0x8(%ebp),%edx
  100613:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100616:	8b 45 0c             	mov    0xc(%ebp),%eax
  100619:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100620:	c7 45 f4 ec 3e 10 00 	movl   $0x103eec,-0xc(%ebp)
    stab_end = __STAB_END__;
  100627:	c7 45 f0 b0 bc 10 00 	movl   $0x10bcb0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10062e:	c7 45 ec b1 bc 10 00 	movl   $0x10bcb1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100635:	c7 45 e8 a3 dd 10 00 	movl   $0x10dda3,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
  10063c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10063f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100642:	76 0b                	jbe    10064f <debuginfo_eip+0x6f>
  100644:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100647:	48                   	dec    %eax
  100648:	0f b6 00             	movzbl (%eax),%eax
  10064b:	84 c0                	test   %al,%al
  10064d:	74 0a                	je     100659 <debuginfo_eip+0x79>
    {
        return -1;
  10064f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100654:	e9 b7 02 00 00       	jmp    100910 <debuginfo_eip+0x330>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100659:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100660:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100666:	29 c2                	sub    %eax,%edx
  100668:	89 d0                	mov    %edx,%eax
  10066a:	c1 f8 02             	sar    $0x2,%eax
  10066d:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100673:	48                   	dec    %eax
  100674:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100677:	8b 45 08             	mov    0x8(%ebp),%eax
  10067a:	89 44 24 10          	mov    %eax,0x10(%esp)
  10067e:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  100685:	00 
  100686:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100689:	89 44 24 08          	mov    %eax,0x8(%esp)
  10068d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100690:	89 44 24 04          	mov    %eax,0x4(%esp)
  100694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100697:	89 04 24             	mov    %eax,(%esp)
  10069a:	e8 f3 fd ff ff       	call   100492 <stab_binsearch>
    if (lfile == 0)
  10069f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a2:	85 c0                	test   %eax,%eax
  1006a4:	75 0a                	jne    1006b0 <debuginfo_eip+0xd0>
        return -1;
  1006a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006ab:	e9 60 02 00 00       	jmp    100910 <debuginfo_eip+0x330>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006bf:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006c3:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1006ca:	00 
  1006cb:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006d2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006dc:	89 04 24             	mov    %eax,(%esp)
  1006df:	e8 ae fd ff ff       	call   100492 <stab_binsearch>

    if (lfun <= rfun)
  1006e4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006ea:	39 c2                	cmp    %eax,%edx
  1006ec:	7f 7c                	jg     10076a <debuginfo_eip+0x18a>
    {
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr)
  1006ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006f1:	89 c2                	mov    %eax,%edx
  1006f3:	89 d0                	mov    %edx,%eax
  1006f5:	01 c0                	add    %eax,%eax
  1006f7:	01 d0                	add    %edx,%eax
  1006f9:	c1 e0 02             	shl    $0x2,%eax
  1006fc:	89 c2                	mov    %eax,%edx
  1006fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100701:	01 d0                	add    %edx,%eax
  100703:	8b 00                	mov    (%eax),%eax
  100705:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100708:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10070b:	29 d1                	sub    %edx,%ecx
  10070d:	89 ca                	mov    %ecx,%edx
  10070f:	39 d0                	cmp    %edx,%eax
  100711:	73 22                	jae    100735 <debuginfo_eip+0x155>
        {
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100713:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100716:	89 c2                	mov    %eax,%edx
  100718:	89 d0                	mov    %edx,%eax
  10071a:	01 c0                	add    %eax,%eax
  10071c:	01 d0                	add    %edx,%eax
  10071e:	c1 e0 02             	shl    $0x2,%eax
  100721:	89 c2                	mov    %eax,%edx
  100723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100726:	01 d0                	add    %edx,%eax
  100728:	8b 10                	mov    (%eax),%edx
  10072a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10072d:	01 c2                	add    %eax,%edx
  10072f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100732:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100735:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100738:	89 c2                	mov    %eax,%edx
  10073a:	89 d0                	mov    %edx,%eax
  10073c:	01 c0                	add    %eax,%eax
  10073e:	01 d0                	add    %edx,%eax
  100740:	c1 e0 02             	shl    $0x2,%eax
  100743:	89 c2                	mov    %eax,%edx
  100745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100748:	01 d0                	add    %edx,%eax
  10074a:	8b 50 08             	mov    0x8(%eax),%edx
  10074d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100750:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100753:	8b 45 0c             	mov    0xc(%ebp),%eax
  100756:	8b 40 10             	mov    0x10(%eax),%eax
  100759:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10075c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10075f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100762:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100765:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100768:	eb 15                	jmp    10077f <debuginfo_eip+0x19f>
    }
    else
    {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  10076a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076d:	8b 55 08             	mov    0x8(%ebp),%edx
  100770:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100773:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100776:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100779:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10077c:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10077f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100782:	8b 40 08             	mov    0x8(%eax),%eax
  100785:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  10078c:	00 
  10078d:	89 04 24             	mov    %eax,(%esp)
  100790:	e8 c0 24 00 00       	call   102c55 <strfind>
  100795:	89 c2                	mov    %eax,%edx
  100797:	8b 45 0c             	mov    0xc(%ebp),%eax
  10079a:	8b 40 08             	mov    0x8(%eax),%eax
  10079d:	29 c2                	sub    %eax,%edx
  10079f:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a2:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1007a8:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007ac:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007b3:	00 
  1007b4:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007b7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007bb:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007be:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c5:	89 04 24             	mov    %eax,(%esp)
  1007c8:	e8 c5 fc ff ff       	call   100492 <stab_binsearch>
    if (lline <= rline)
  1007cd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007d3:	39 c2                	cmp    %eax,%edx
  1007d5:	7f 23                	jg     1007fa <debuginfo_eip+0x21a>
    {
        info->eip_line = stabs[rline].n_desc;
  1007d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007da:	89 c2                	mov    %eax,%edx
  1007dc:	89 d0                	mov    %edx,%eax
  1007de:	01 c0                	add    %eax,%eax
  1007e0:	01 d0                	add    %edx,%eax
  1007e2:	c1 e0 02             	shl    $0x2,%eax
  1007e5:	89 c2                	mov    %eax,%edx
  1007e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ea:	01 d0                	add    %edx,%eax
  1007ec:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007f0:	89 c2                	mov    %eax,%edx
  1007f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007f5:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile && stabs[lline].n_type != N_SOL && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
  1007f8:	eb 11                	jmp    10080b <debuginfo_eip+0x22b>
        return -1;
  1007fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007ff:	e9 0c 01 00 00       	jmp    100910 <debuginfo_eip+0x330>
    {
        lline--;
  100804:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100807:	48                   	dec    %eax
  100808:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile && stabs[lline].n_type != N_SOL && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
  10080b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10080e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100811:	39 c2                	cmp    %eax,%edx
  100813:	7c 56                	jl     10086b <debuginfo_eip+0x28b>
  100815:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100818:	89 c2                	mov    %eax,%edx
  10081a:	89 d0                	mov    %edx,%eax
  10081c:	01 c0                	add    %eax,%eax
  10081e:	01 d0                	add    %edx,%eax
  100820:	c1 e0 02             	shl    $0x2,%eax
  100823:	89 c2                	mov    %eax,%edx
  100825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100828:	01 d0                	add    %edx,%eax
  10082a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10082e:	3c 84                	cmp    $0x84,%al
  100830:	74 39                	je     10086b <debuginfo_eip+0x28b>
  100832:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100835:	89 c2                	mov    %eax,%edx
  100837:	89 d0                	mov    %edx,%eax
  100839:	01 c0                	add    %eax,%eax
  10083b:	01 d0                	add    %edx,%eax
  10083d:	c1 e0 02             	shl    $0x2,%eax
  100840:	89 c2                	mov    %eax,%edx
  100842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100845:	01 d0                	add    %edx,%eax
  100847:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10084b:	3c 64                	cmp    $0x64,%al
  10084d:	75 b5                	jne    100804 <debuginfo_eip+0x224>
  10084f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100852:	89 c2                	mov    %eax,%edx
  100854:	89 d0                	mov    %edx,%eax
  100856:	01 c0                	add    %eax,%eax
  100858:	01 d0                	add    %edx,%eax
  10085a:	c1 e0 02             	shl    $0x2,%eax
  10085d:	89 c2                	mov    %eax,%edx
  10085f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100862:	01 d0                	add    %edx,%eax
  100864:	8b 40 08             	mov    0x8(%eax),%eax
  100867:	85 c0                	test   %eax,%eax
  100869:	74 99                	je     100804 <debuginfo_eip+0x224>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
  10086b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10086e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100871:	39 c2                	cmp    %eax,%edx
  100873:	7c 46                	jl     1008bb <debuginfo_eip+0x2db>
  100875:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100878:	89 c2                	mov    %eax,%edx
  10087a:	89 d0                	mov    %edx,%eax
  10087c:	01 c0                	add    %eax,%eax
  10087e:	01 d0                	add    %edx,%eax
  100880:	c1 e0 02             	shl    $0x2,%eax
  100883:	89 c2                	mov    %eax,%edx
  100885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100888:	01 d0                	add    %edx,%eax
  10088a:	8b 00                	mov    (%eax),%eax
  10088c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10088f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100892:	29 d1                	sub    %edx,%ecx
  100894:	89 ca                	mov    %ecx,%edx
  100896:	39 d0                	cmp    %edx,%eax
  100898:	73 21                	jae    1008bb <debuginfo_eip+0x2db>
    {
        info->eip_file = stabstr + stabs[lline].n_strx;
  10089a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10089d:	89 c2                	mov    %eax,%edx
  10089f:	89 d0                	mov    %edx,%eax
  1008a1:	01 c0                	add    %eax,%eax
  1008a3:	01 d0                	add    %edx,%eax
  1008a5:	c1 e0 02             	shl    $0x2,%eax
  1008a8:	89 c2                	mov    %eax,%edx
  1008aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008ad:	01 d0                	add    %edx,%eax
  1008af:	8b 10                	mov    (%eax),%edx
  1008b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008b4:	01 c2                	add    %eax,%edx
  1008b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008b9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun)
  1008bb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008c1:	39 c2                	cmp    %eax,%edx
  1008c3:	7d 46                	jge    10090b <debuginfo_eip+0x32b>
    {
        for (lline = lfun + 1;
  1008c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008c8:	40                   	inc    %eax
  1008c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008cc:	eb 16                	jmp    1008e4 <debuginfo_eip+0x304>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline++)
        {
            info->eip_fn_narg++;
  1008ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008d1:	8b 40 14             	mov    0x14(%eax),%eax
  1008d4:	8d 50 01             	lea    0x1(%eax),%edx
  1008d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008da:	89 50 14             	mov    %edx,0x14(%eax)
             lline++)
  1008dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008e0:	40                   	inc    %eax
  1008e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  1008ea:	39 c2                	cmp    %eax,%edx
  1008ec:	7d 1d                	jge    10090b <debuginfo_eip+0x32b>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008f1:	89 c2                	mov    %eax,%edx
  1008f3:	89 d0                	mov    %edx,%eax
  1008f5:	01 c0                	add    %eax,%eax
  1008f7:	01 d0                	add    %edx,%eax
  1008f9:	c1 e0 02             	shl    $0x2,%eax
  1008fc:	89 c2                	mov    %eax,%edx
  1008fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100901:	01 d0                	add    %edx,%eax
  100903:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100907:	3c a0                	cmp    $0xa0,%al
  100909:	74 c3                	je     1008ce <debuginfo_eip+0x2ee>
        }
    }
    return 0;
  10090b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100910:	c9                   	leave  
  100911:	c3                   	ret    

00100912 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
  100912:	55                   	push   %ebp
  100913:	89 e5                	mov    %esp,%ebp
  100915:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100918:	c7 04 24 e2 36 10 00 	movl   $0x1036e2,(%esp)
  10091f:	e8 48 f9 ff ff       	call   10026c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100924:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10092b:	00 
  10092c:	c7 04 24 fb 36 10 00 	movl   $0x1036fb,(%esp)
  100933:	e8 34 f9 ff ff       	call   10026c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100938:	c7 44 24 04 d3 35 10 	movl   $0x1035d3,0x4(%esp)
  10093f:	00 
  100940:	c7 04 24 13 37 10 00 	movl   $0x103713,(%esp)
  100947:	e8 20 f9 ff ff       	call   10026c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10094c:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100953:	00 
  100954:	c7 04 24 2b 37 10 00 	movl   $0x10372b,(%esp)
  10095b:	e8 0c f9 ff ff       	call   10026c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100960:	c7 44 24 04 80 fd 10 	movl   $0x10fd80,0x4(%esp)
  100967:	00 
  100968:	c7 04 24 43 37 10 00 	movl   $0x103743,(%esp)
  10096f:	e8 f8 f8 ff ff       	call   10026c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023) / 1024);
  100974:	b8 80 fd 10 00       	mov    $0x10fd80,%eax
  100979:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  10097f:	b8 00 00 10 00       	mov    $0x100000,%eax
  100984:	29 c2                	sub    %eax,%edx
  100986:	89 d0                	mov    %edx,%eax
  100988:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  10098e:	85 c0                	test   %eax,%eax
  100990:	0f 48 c2             	cmovs  %edx,%eax
  100993:	c1 f8 0a             	sar    $0xa,%eax
  100996:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099a:	c7 04 24 5c 37 10 00 	movl   $0x10375c,(%esp)
  1009a1:	e8 c6 f8 ff ff       	call   10026c <cprintf>
}
  1009a6:	90                   	nop
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void print_debuginfo(uintptr_t eip)
{
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0)
  1009b2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1009bc:	89 04 24             	mov    %eax,(%esp)
  1009bf:	e8 1c fc ff ff       	call   1005e0 <debuginfo_eip>
  1009c4:	85 c0                	test   %eax,%eax
  1009c6:	74 15                	je     1009dd <print_debuginfo+0x34>
    {
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1009cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009cf:	c7 04 24 86 37 10 00 	movl   $0x103786,(%esp)
  1009d6:	e8 91 f8 ff ff       	call   10026c <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009db:	eb 6c                	jmp    100a49 <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j++)
  1009dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009e4:	eb 1b                	jmp    100a01 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  1009e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ec:	01 d0                	add    %edx,%eax
  1009ee:	0f b6 00             	movzbl (%eax),%eax
  1009f1:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009fa:	01 ca                	add    %ecx,%edx
  1009fc:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j++)
  1009fe:	ff 45 f4             	incl   -0xc(%ebp)
  100a01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a04:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a07:	7c dd                	jl     1009e6 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  100a09:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a12:	01 d0                	add    %edx,%eax
  100a14:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a17:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a1a:	8b 55 08             	mov    0x8(%ebp),%edx
  100a1d:	89 d1                	mov    %edx,%ecx
  100a1f:	29 c1                	sub    %eax,%ecx
  100a21:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a24:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a27:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a2b:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a31:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a35:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a39:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a3d:	c7 04 24 a2 37 10 00 	movl   $0x1037a2,(%esp)
  100a44:	e8 23 f8 ff ff       	call   10026c <cprintf>
}
  100a49:	90                   	nop
  100a4a:	c9                   	leave  
  100a4b:	c3                   	ret    

00100a4c <read_eip>:

static __noinline uint32_t
read_eip(void)
{
  100a4c:	55                   	push   %ebp
  100a4d:	89 e5                	mov    %esp,%ebp
  100a4f:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0"
  100a52:	8b 45 04             	mov    0x4(%ebp),%eax
  100a55:	89 45 fc             	mov    %eax,-0x4(%ebp)
                 : "=r"(eip));
    return eip;
  100a58:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a5b:	c9                   	leave  
  100a5c:	c3                   	ret    

00100a5d <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void print_stackframe(void)
{
  100a5d:	55                   	push   %ebp
  100a5e:	89 e5                	mov    %esp,%ebp
  100a60:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a63:	89 e8                	mov    %ebp,%eax
  100a65:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a68:	8b 45 e0             	mov    -0x20(%ebp),%eax
     *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
     *    (3.5) popup a calling stackframe
     *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
     *                   the calling funciton's ebp = ss:[ebp]
     */
    uint32_t ebp = read_ebp(), eip = read_eip();
  100a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100a6e:	e8 d9 ff ff ff       	call   100a4c <read_eip>
  100a73:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
  100a76:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a7d:	e9 84 00 00 00       	jmp    100b06 <print_stackframe+0xa9>
    {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a85:	89 44 24 08          	mov    %eax,0x8(%esp)
  100a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a90:	c7 04 24 b4 37 10 00 	movl   $0x1037b4,(%esp)
  100a97:	e8 d0 f7 ff ff       	call   10026c <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
  100a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a9f:	83 c0 08             	add    $0x8,%eax
  100aa2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j++)
  100aa5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100aac:	eb 24                	jmp    100ad2 <print_stackframe+0x75>
        {
            cprintf("0x%08x ", args[j]);
  100aae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100ab1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ab8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100abb:	01 d0                	add    %edx,%eax
  100abd:	8b 00                	mov    (%eax),%eax
  100abf:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ac3:	c7 04 24 d0 37 10 00 	movl   $0x1037d0,(%esp)
  100aca:	e8 9d f7 ff ff       	call   10026c <cprintf>
        for (j = 0; j < 4; j++)
  100acf:	ff 45 e8             	incl   -0x18(%ebp)
  100ad2:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100ad6:	7e d6                	jle    100aae <print_stackframe+0x51>
        }
        cprintf("\n");
  100ad8:	c7 04 24 d8 37 10 00 	movl   $0x1037d8,(%esp)
  100adf:	e8 88 f7 ff ff       	call   10026c <cprintf>
        print_debuginfo(eip - 1);
  100ae4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ae7:	48                   	dec    %eax
  100ae8:	89 04 24             	mov    %eax,(%esp)
  100aeb:	e8 b9 fe ff ff       	call   1009a9 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100af3:	83 c0 04             	add    $0x4,%eax
  100af6:	8b 00                	mov    (%eax),%eax
  100af8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100afe:	8b 00                	mov    (%eax),%eax
  100b00:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
  100b03:	ff 45 ec             	incl   -0x14(%ebp)
  100b06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b0a:	74 0a                	je     100b16 <print_stackframe+0xb9>
  100b0c:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b10:	0f 8e 6c ff ff ff    	jle    100a82 <print_stackframe+0x25>
    }
}
  100b16:	90                   	nop
  100b17:	c9                   	leave  
  100b18:	c3                   	ret    

00100b19 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b19:	55                   	push   %ebp
  100b1a:	89 e5                	mov    %esp,%ebp
  100b1c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b26:	eb 0c                	jmp    100b34 <parse+0x1b>
            *buf ++ = '\0';
  100b28:	8b 45 08             	mov    0x8(%ebp),%eax
  100b2b:	8d 50 01             	lea    0x1(%eax),%edx
  100b2e:	89 55 08             	mov    %edx,0x8(%ebp)
  100b31:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b34:	8b 45 08             	mov    0x8(%ebp),%eax
  100b37:	0f b6 00             	movzbl (%eax),%eax
  100b3a:	84 c0                	test   %al,%al
  100b3c:	74 1d                	je     100b5b <parse+0x42>
  100b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b41:	0f b6 00             	movzbl (%eax),%eax
  100b44:	0f be c0             	movsbl %al,%eax
  100b47:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b4b:	c7 04 24 5c 38 10 00 	movl   $0x10385c,(%esp)
  100b52:	e8 cc 20 00 00       	call   102c23 <strchr>
  100b57:	85 c0                	test   %eax,%eax
  100b59:	75 cd                	jne    100b28 <parse+0xf>
        }
        if (*buf == '\0') {
  100b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b5e:	0f b6 00             	movzbl (%eax),%eax
  100b61:	84 c0                	test   %al,%al
  100b63:	74 65                	je     100bca <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b65:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b69:	75 14                	jne    100b7f <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b6b:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100b72:	00 
  100b73:	c7 04 24 61 38 10 00 	movl   $0x103861,(%esp)
  100b7a:	e8 ed f6 ff ff       	call   10026c <cprintf>
        }
        argv[argc ++] = buf;
  100b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b82:	8d 50 01             	lea    0x1(%eax),%edx
  100b85:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b88:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b92:	01 c2                	add    %eax,%edx
  100b94:	8b 45 08             	mov    0x8(%ebp),%eax
  100b97:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b99:	eb 03                	jmp    100b9e <parse+0x85>
            buf ++;
  100b9b:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  100ba1:	0f b6 00             	movzbl (%eax),%eax
  100ba4:	84 c0                	test   %al,%al
  100ba6:	74 8c                	je     100b34 <parse+0x1b>
  100ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  100bab:	0f b6 00             	movzbl (%eax),%eax
  100bae:	0f be c0             	movsbl %al,%eax
  100bb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bb5:	c7 04 24 5c 38 10 00 	movl   $0x10385c,(%esp)
  100bbc:	e8 62 20 00 00       	call   102c23 <strchr>
  100bc1:	85 c0                	test   %eax,%eax
  100bc3:	74 d6                	je     100b9b <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bc5:	e9 6a ff ff ff       	jmp    100b34 <parse+0x1b>
            break;
  100bca:	90                   	nop
        }
    }
    return argc;
  100bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bce:	c9                   	leave  
  100bcf:	c3                   	ret    

00100bd0 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100bd0:	55                   	push   %ebp
  100bd1:	89 e5                	mov    %esp,%ebp
  100bd3:	53                   	push   %ebx
  100bd4:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100bd7:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bda:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bde:	8b 45 08             	mov    0x8(%ebp),%eax
  100be1:	89 04 24             	mov    %eax,(%esp)
  100be4:	e8 30 ff ff ff       	call   100b19 <parse>
  100be9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bf0:	75 0a                	jne    100bfc <runcmd+0x2c>
        return 0;
  100bf2:	b8 00 00 00 00       	mov    $0x0,%eax
  100bf7:	e9 83 00 00 00       	jmp    100c7f <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bfc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c03:	eb 5a                	jmp    100c5f <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c05:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c0b:	89 d0                	mov    %edx,%eax
  100c0d:	01 c0                	add    %eax,%eax
  100c0f:	01 d0                	add    %edx,%eax
  100c11:	c1 e0 02             	shl    $0x2,%eax
  100c14:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c19:	8b 00                	mov    (%eax),%eax
  100c1b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c1f:	89 04 24             	mov    %eax,(%esp)
  100c22:	e8 5f 1f 00 00       	call   102b86 <strcmp>
  100c27:	85 c0                	test   %eax,%eax
  100c29:	75 31                	jne    100c5c <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c2e:	89 d0                	mov    %edx,%eax
  100c30:	01 c0                	add    %eax,%eax
  100c32:	01 d0                	add    %edx,%eax
  100c34:	c1 e0 02             	shl    $0x2,%eax
  100c37:	05 08 e0 10 00       	add    $0x10e008,%eax
  100c3c:	8b 10                	mov    (%eax),%edx
  100c3e:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c41:	83 c0 04             	add    $0x4,%eax
  100c44:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c47:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100c4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100c4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c51:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c55:	89 1c 24             	mov    %ebx,(%esp)
  100c58:	ff d2                	call   *%edx
  100c5a:	eb 23                	jmp    100c7f <runcmd+0xaf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c5c:	ff 45 f4             	incl   -0xc(%ebp)
  100c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c62:	83 f8 02             	cmp    $0x2,%eax
  100c65:	76 9e                	jbe    100c05 <runcmd+0x35>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c67:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c6e:	c7 04 24 7f 38 10 00 	movl   $0x10387f,(%esp)
  100c75:	e8 f2 f5 ff ff       	call   10026c <cprintf>
    return 0;
  100c7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c7f:	83 c4 64             	add    $0x64,%esp
  100c82:	5b                   	pop    %ebx
  100c83:	5d                   	pop    %ebp
  100c84:	c3                   	ret    

00100c85 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c85:	55                   	push   %ebp
  100c86:	89 e5                	mov    %esp,%ebp
  100c88:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c8b:	c7 04 24 98 38 10 00 	movl   $0x103898,(%esp)
  100c92:	e8 d5 f5 ff ff       	call   10026c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c97:	c7 04 24 c0 38 10 00 	movl   $0x1038c0,(%esp)
  100c9e:	e8 c9 f5 ff ff       	call   10026c <cprintf>

    if (tf != NULL) {
  100ca3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100ca7:	74 0b                	je     100cb4 <kmonitor+0x2f>
        print_trapframe(tf);
  100ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  100cac:	89 04 24             	mov    %eax,(%esp)
  100caf:	e8 2b 0d 00 00       	call   1019df <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cb4:	c7 04 24 e5 38 10 00 	movl   $0x1038e5,(%esp)
  100cbb:	e8 4e f6 ff ff       	call   10030e <readline>
  100cc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cc7:	74 eb                	je     100cb4 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  100ccc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cd3:	89 04 24             	mov    %eax,(%esp)
  100cd6:	e8 f5 fe ff ff       	call   100bd0 <runcmd>
  100cdb:	85 c0                	test   %eax,%eax
  100cdd:	78 02                	js     100ce1 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100cdf:	eb d3                	jmp    100cb4 <kmonitor+0x2f>
                break;
  100ce1:	90                   	nop
            }
        }
    }
}
  100ce2:	90                   	nop
  100ce3:	c9                   	leave  
  100ce4:	c3                   	ret    

00100ce5 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100ce5:	55                   	push   %ebp
  100ce6:	89 e5                	mov    %esp,%ebp
  100ce8:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100ceb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100cf2:	eb 3d                	jmp    100d31 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100cf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cf7:	89 d0                	mov    %edx,%eax
  100cf9:	01 c0                	add    %eax,%eax
  100cfb:	01 d0                	add    %edx,%eax
  100cfd:	c1 e0 02             	shl    $0x2,%eax
  100d00:	05 04 e0 10 00       	add    $0x10e004,%eax
  100d05:	8b 08                	mov    (%eax),%ecx
  100d07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d0a:	89 d0                	mov    %edx,%eax
  100d0c:	01 c0                	add    %eax,%eax
  100d0e:	01 d0                	add    %edx,%eax
  100d10:	c1 e0 02             	shl    $0x2,%eax
  100d13:	05 00 e0 10 00       	add    $0x10e000,%eax
  100d18:	8b 00                	mov    (%eax),%eax
  100d1a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d22:	c7 04 24 e9 38 10 00 	movl   $0x1038e9,(%esp)
  100d29:	e8 3e f5 ff ff       	call   10026c <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d2e:	ff 45 f4             	incl   -0xc(%ebp)
  100d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d34:	83 f8 02             	cmp    $0x2,%eax
  100d37:	76 bb                	jbe    100cf4 <mon_help+0xf>
    }
    return 0;
  100d39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d3e:	c9                   	leave  
  100d3f:	c3                   	ret    

00100d40 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d40:	55                   	push   %ebp
  100d41:	89 e5                	mov    %esp,%ebp
  100d43:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d46:	e8 c7 fb ff ff       	call   100912 <print_kerninfo>
    return 0;
  100d4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d50:	c9                   	leave  
  100d51:	c3                   	ret    

00100d52 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d52:	55                   	push   %ebp
  100d53:	89 e5                	mov    %esp,%ebp
  100d55:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d58:	e8 00 fd ff ff       	call   100a5d <print_stackframe>
    return 0;
  100d5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d62:	c9                   	leave  
  100d63:	c3                   	ret    

00100d64 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d64:	55                   	push   %ebp
  100d65:	89 e5                	mov    %esp,%ebp
  100d67:	83 ec 28             	sub    $0x28,%esp
  100d6a:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d70:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d74:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d78:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d7c:	ee                   	out    %al,(%dx)
  100d7d:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d83:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d87:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d8b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d8f:	ee                   	out    %al,(%dx)
  100d90:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100d96:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100d9a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d9e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100da2:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100da3:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100daa:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dad:	c7 04 24 f2 38 10 00 	movl   $0x1038f2,(%esp)
  100db4:	e8 b3 f4 ff ff       	call   10026c <cprintf>
    pic_enable(IRQ_TIMER);
  100db9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dc0:	e8 ca 08 00 00       	call   10168f <pic_enable>
}
  100dc5:	90                   	nop
  100dc6:	c9                   	leave  
  100dc7:	c3                   	ret    

00100dc8 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dc8:	55                   	push   %ebp
  100dc9:	89 e5                	mov    %esp,%ebp
  100dcb:	83 ec 10             	sub    $0x10,%esp
  100dce:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dd4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100dd8:	89 c2                	mov    %eax,%edx
  100dda:	ec                   	in     (%dx),%al
  100ddb:	88 45 f1             	mov    %al,-0xf(%ebp)
  100dde:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100de4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100de8:	89 c2                	mov    %eax,%edx
  100dea:	ec                   	in     (%dx),%al
  100deb:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dee:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100df4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100df8:	89 c2                	mov    %eax,%edx
  100dfa:	ec                   	in     (%dx),%al
  100dfb:	88 45 f9             	mov    %al,-0x7(%ebp)
  100dfe:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e04:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e08:	89 c2                	mov    %eax,%edx
  100e0a:	ec                   	in     (%dx),%al
  100e0b:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e0e:	90                   	nop
  100e0f:	c9                   	leave  
  100e10:	c3                   	ret    

00100e11 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e11:	55                   	push   %ebp
  100e12:	89 e5                	mov    %esp,%ebp
  100e14:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e17:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e21:	0f b7 00             	movzwl (%eax),%eax
  100e24:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e2b:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e33:	0f b7 00             	movzwl (%eax),%eax
  100e36:	0f b7 c0             	movzwl %ax,%eax
  100e39:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100e3e:	74 12                	je     100e52 <cga_init+0x41>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e40:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e47:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e4e:	b4 03 
  100e50:	eb 13                	jmp    100e65 <cga_init+0x54>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e55:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e59:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e5c:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e63:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e65:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e6c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100e70:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e74:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100e78:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100e7c:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e7d:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e84:	40                   	inc    %eax
  100e85:	0f b7 c0             	movzwl %ax,%eax
  100e88:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e8c:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100e90:	89 c2                	mov    %eax,%edx
  100e92:	ec                   	in     (%dx),%al
  100e93:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100e96:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100e9a:	0f b6 c0             	movzbl %al,%eax
  100e9d:	c1 e0 08             	shl    $0x8,%eax
  100ea0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ea3:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eaa:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100eae:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eb2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100eb6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100eba:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ebb:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ec2:	40                   	inc    %eax
  100ec3:	0f b7 c0             	movzwl %ax,%eax
  100ec6:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eca:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ece:	89 c2                	mov    %eax,%edx
  100ed0:	ec                   	in     (%dx),%al
  100ed1:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100ed4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ed8:	0f b6 c0             	movzbl %al,%eax
  100edb:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ede:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ee1:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ee9:	0f b7 c0             	movzwl %ax,%eax
  100eec:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ef2:	90                   	nop
  100ef3:	c9                   	leave  
  100ef4:	c3                   	ret    

00100ef5 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ef5:	55                   	push   %ebp
  100ef6:	89 e5                	mov    %esp,%ebp
  100ef8:	83 ec 48             	sub    $0x48,%esp
  100efb:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f01:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f05:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f09:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f0d:	ee                   	out    %al,(%dx)
  100f0e:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f14:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  100f18:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f1c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f20:	ee                   	out    %al,(%dx)
  100f21:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f27:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  100f2b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f2f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f33:	ee                   	out    %al,(%dx)
  100f34:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f3a:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f3e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f42:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f46:	ee                   	out    %al,(%dx)
  100f47:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f4d:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  100f51:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f55:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f59:	ee                   	out    %al,(%dx)
  100f5a:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100f60:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100f64:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f68:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f6c:	ee                   	out    %al,(%dx)
  100f6d:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f73:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  100f77:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f7b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f7f:	ee                   	out    %al,(%dx)
  100f80:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f86:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f8a:	89 c2                	mov    %eax,%edx
  100f8c:	ec                   	in     (%dx),%al
  100f8d:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f90:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f94:	3c ff                	cmp    $0xff,%al
  100f96:	0f 95 c0             	setne  %al
  100f99:	0f b6 c0             	movzbl %al,%eax
  100f9c:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100fa1:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fa7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100fab:	89 c2                	mov    %eax,%edx
  100fad:	ec                   	in     (%dx),%al
  100fae:	88 45 f1             	mov    %al,-0xf(%ebp)
  100fb1:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100fb7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100fbb:	89 c2                	mov    %eax,%edx
  100fbd:	ec                   	in     (%dx),%al
  100fbe:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fc1:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fc6:	85 c0                	test   %eax,%eax
  100fc8:	74 0c                	je     100fd6 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fca:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fd1:	e8 b9 06 00 00       	call   10168f <pic_enable>
    }
}
  100fd6:	90                   	nop
  100fd7:	c9                   	leave  
  100fd8:	c3                   	ret    

00100fd9 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fd9:	55                   	push   %ebp
  100fda:	89 e5                	mov    %esp,%ebp
  100fdc:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fdf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fe6:	eb 08                	jmp    100ff0 <lpt_putc_sub+0x17>
        delay();
  100fe8:	e8 db fd ff ff       	call   100dc8 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fed:	ff 45 fc             	incl   -0x4(%ebp)
  100ff0:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100ff6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100ffa:	89 c2                	mov    %eax,%edx
  100ffc:	ec                   	in     (%dx),%al
  100ffd:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101000:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101004:	84 c0                	test   %al,%al
  101006:	78 09                	js     101011 <lpt_putc_sub+0x38>
  101008:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10100f:	7e d7                	jle    100fe8 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  101011:	8b 45 08             	mov    0x8(%ebp),%eax
  101014:	0f b6 c0             	movzbl %al,%eax
  101017:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  10101d:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101020:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101024:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101028:	ee                   	out    %al,(%dx)
  101029:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10102f:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101033:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101037:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10103b:	ee                   	out    %al,(%dx)
  10103c:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101042:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  101046:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10104a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10104e:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10104f:	90                   	nop
  101050:	c9                   	leave  
  101051:	c3                   	ret    

00101052 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101052:	55                   	push   %ebp
  101053:	89 e5                	mov    %esp,%ebp
  101055:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101058:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10105c:	74 0d                	je     10106b <lpt_putc+0x19>
        lpt_putc_sub(c);
  10105e:	8b 45 08             	mov    0x8(%ebp),%eax
  101061:	89 04 24             	mov    %eax,(%esp)
  101064:	e8 70 ff ff ff       	call   100fd9 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101069:	eb 24                	jmp    10108f <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  10106b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101072:	e8 62 ff ff ff       	call   100fd9 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101077:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10107e:	e8 56 ff ff ff       	call   100fd9 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101083:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10108a:	e8 4a ff ff ff       	call   100fd9 <lpt_putc_sub>
}
  10108f:	90                   	nop
  101090:	c9                   	leave  
  101091:	c3                   	ret    

00101092 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101092:	55                   	push   %ebp
  101093:	89 e5                	mov    %esp,%ebp
  101095:	53                   	push   %ebx
  101096:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101099:	8b 45 08             	mov    0x8(%ebp),%eax
  10109c:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1010a1:	85 c0                	test   %eax,%eax
  1010a3:	75 07                	jne    1010ac <cga_putc+0x1a>
        c |= 0x0700;
  1010a5:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1010af:	0f b6 c0             	movzbl %al,%eax
  1010b2:	83 f8 0a             	cmp    $0xa,%eax
  1010b5:	74 55                	je     10110c <cga_putc+0x7a>
  1010b7:	83 f8 0d             	cmp    $0xd,%eax
  1010ba:	74 63                	je     10111f <cga_putc+0x8d>
  1010bc:	83 f8 08             	cmp    $0x8,%eax
  1010bf:	0f 85 94 00 00 00    	jne    101159 <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
  1010c5:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010cc:	85 c0                	test   %eax,%eax
  1010ce:	0f 84 af 00 00 00    	je     101183 <cga_putc+0xf1>
            crt_pos --;
  1010d4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010db:	48                   	dec    %eax
  1010dc:	0f b7 c0             	movzwl %ax,%eax
  1010df:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1010e8:	98                   	cwtl   
  1010e9:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1010ee:	98                   	cwtl   
  1010ef:	83 c8 20             	or     $0x20,%eax
  1010f2:	98                   	cwtl   
  1010f3:	8b 15 60 ee 10 00    	mov    0x10ee60,%edx
  1010f9:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101100:	01 c9                	add    %ecx,%ecx
  101102:	01 ca                	add    %ecx,%edx
  101104:	0f b7 c0             	movzwl %ax,%eax
  101107:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10110a:	eb 77                	jmp    101183 <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
  10110c:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101113:	83 c0 50             	add    $0x50,%eax
  101116:	0f b7 c0             	movzwl %ax,%eax
  101119:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10111f:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101126:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  10112d:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  101132:	89 c8                	mov    %ecx,%eax
  101134:	f7 e2                	mul    %edx
  101136:	c1 ea 06             	shr    $0x6,%edx
  101139:	89 d0                	mov    %edx,%eax
  10113b:	c1 e0 02             	shl    $0x2,%eax
  10113e:	01 d0                	add    %edx,%eax
  101140:	c1 e0 04             	shl    $0x4,%eax
  101143:	29 c1                	sub    %eax,%ecx
  101145:	89 c8                	mov    %ecx,%eax
  101147:	0f b7 c0             	movzwl %ax,%eax
  10114a:	29 c3                	sub    %eax,%ebx
  10114c:	89 d8                	mov    %ebx,%eax
  10114e:	0f b7 c0             	movzwl %ax,%eax
  101151:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101157:	eb 2b                	jmp    101184 <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101159:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  10115f:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101166:	8d 50 01             	lea    0x1(%eax),%edx
  101169:	0f b7 d2             	movzwl %dx,%edx
  10116c:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101173:	01 c0                	add    %eax,%eax
  101175:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101178:	8b 45 08             	mov    0x8(%ebp),%eax
  10117b:	0f b7 c0             	movzwl %ax,%eax
  10117e:	66 89 02             	mov    %ax,(%edx)
        break;
  101181:	eb 01                	jmp    101184 <cga_putc+0xf2>
        break;
  101183:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101184:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10118b:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101190:	76 5d                	jbe    1011ef <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101192:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101197:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10119d:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011a2:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011a9:	00 
  1011aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011ae:	89 04 24             	mov    %eax,(%esp)
  1011b1:	e8 63 1c 00 00       	call   102e19 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011b6:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011bd:	eb 14                	jmp    1011d3 <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
  1011bf:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011c7:	01 d2                	add    %edx,%edx
  1011c9:	01 d0                	add    %edx,%eax
  1011cb:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011d0:	ff 45 f4             	incl   -0xc(%ebp)
  1011d3:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011da:	7e e3                	jle    1011bf <cga_putc+0x12d>
        }
        crt_pos -= CRT_COLS;
  1011dc:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011e3:	83 e8 50             	sub    $0x50,%eax
  1011e6:	0f b7 c0             	movzwl %ax,%eax
  1011e9:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011ef:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011f6:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1011fa:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  1011fe:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101202:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101206:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101207:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10120e:	c1 e8 08             	shr    $0x8,%eax
  101211:	0f b7 c0             	movzwl %ax,%eax
  101214:	0f b6 c0             	movzbl %al,%eax
  101217:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10121e:	42                   	inc    %edx
  10121f:	0f b7 d2             	movzwl %dx,%edx
  101222:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101226:	88 45 e9             	mov    %al,-0x17(%ebp)
  101229:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10122d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101231:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101232:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101239:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10123d:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  101241:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101245:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101249:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10124a:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101251:	0f b6 c0             	movzbl %al,%eax
  101254:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10125b:	42                   	inc    %edx
  10125c:	0f b7 d2             	movzwl %dx,%edx
  10125f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101263:	88 45 f1             	mov    %al,-0xf(%ebp)
  101266:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10126a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10126e:	ee                   	out    %al,(%dx)
}
  10126f:	90                   	nop
  101270:	83 c4 34             	add    $0x34,%esp
  101273:	5b                   	pop    %ebx
  101274:	5d                   	pop    %ebp
  101275:	c3                   	ret    

00101276 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101276:	55                   	push   %ebp
  101277:	89 e5                	mov    %esp,%ebp
  101279:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10127c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101283:	eb 08                	jmp    10128d <serial_putc_sub+0x17>
        delay();
  101285:	e8 3e fb ff ff       	call   100dc8 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10128a:	ff 45 fc             	incl   -0x4(%ebp)
  10128d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101293:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101297:	89 c2                	mov    %eax,%edx
  101299:	ec                   	in     (%dx),%al
  10129a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10129d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012a1:	0f b6 c0             	movzbl %al,%eax
  1012a4:	83 e0 20             	and    $0x20,%eax
  1012a7:	85 c0                	test   %eax,%eax
  1012a9:	75 09                	jne    1012b4 <serial_putc_sub+0x3e>
  1012ab:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012b2:	7e d1                	jle    101285 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  1012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1012b7:	0f b6 c0             	movzbl %al,%eax
  1012ba:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012c0:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012c3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012c7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012cb:	ee                   	out    %al,(%dx)
}
  1012cc:	90                   	nop
  1012cd:	c9                   	leave  
  1012ce:	c3                   	ret    

001012cf <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012cf:	55                   	push   %ebp
  1012d0:	89 e5                	mov    %esp,%ebp
  1012d2:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012d5:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012d9:	74 0d                	je     1012e8 <serial_putc+0x19>
        serial_putc_sub(c);
  1012db:	8b 45 08             	mov    0x8(%ebp),%eax
  1012de:	89 04 24             	mov    %eax,(%esp)
  1012e1:	e8 90 ff ff ff       	call   101276 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1012e6:	eb 24                	jmp    10130c <serial_putc+0x3d>
        serial_putc_sub('\b');
  1012e8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012ef:	e8 82 ff ff ff       	call   101276 <serial_putc_sub>
        serial_putc_sub(' ');
  1012f4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012fb:	e8 76 ff ff ff       	call   101276 <serial_putc_sub>
        serial_putc_sub('\b');
  101300:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101307:	e8 6a ff ff ff       	call   101276 <serial_putc_sub>
}
  10130c:	90                   	nop
  10130d:	c9                   	leave  
  10130e:	c3                   	ret    

0010130f <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10130f:	55                   	push   %ebp
  101310:	89 e5                	mov    %esp,%ebp
  101312:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101315:	eb 33                	jmp    10134a <cons_intr+0x3b>
        if (c != 0) {
  101317:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10131b:	74 2d                	je     10134a <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10131d:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101322:	8d 50 01             	lea    0x1(%eax),%edx
  101325:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  10132b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10132e:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101334:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101339:	3d 00 02 00 00       	cmp    $0x200,%eax
  10133e:	75 0a                	jne    10134a <cons_intr+0x3b>
                cons.wpos = 0;
  101340:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101347:	00 00 00 
    while ((c = (*proc)()) != -1) {
  10134a:	8b 45 08             	mov    0x8(%ebp),%eax
  10134d:	ff d0                	call   *%eax
  10134f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101352:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101356:	75 bf                	jne    101317 <cons_intr+0x8>
            }
        }
    }
}
  101358:	90                   	nop
  101359:	c9                   	leave  
  10135a:	c3                   	ret    

0010135b <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10135b:	55                   	push   %ebp
  10135c:	89 e5                	mov    %esp,%ebp
  10135e:	83 ec 10             	sub    $0x10,%esp
  101361:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101367:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10136b:	89 c2                	mov    %eax,%edx
  10136d:	ec                   	in     (%dx),%al
  10136e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101371:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101375:	0f b6 c0             	movzbl %al,%eax
  101378:	83 e0 01             	and    $0x1,%eax
  10137b:	85 c0                	test   %eax,%eax
  10137d:	75 07                	jne    101386 <serial_proc_data+0x2b>
        return -1;
  10137f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101384:	eb 2a                	jmp    1013b0 <serial_proc_data+0x55>
  101386:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10138c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101390:	89 c2                	mov    %eax,%edx
  101392:	ec                   	in     (%dx),%al
  101393:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101396:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10139a:	0f b6 c0             	movzbl %al,%eax
  10139d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013a0:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013a4:	75 07                	jne    1013ad <serial_proc_data+0x52>
        c = '\b';
  1013a6:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013b0:	c9                   	leave  
  1013b1:	c3                   	ret    

001013b2 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013b2:	55                   	push   %ebp
  1013b3:	89 e5                	mov    %esp,%ebp
  1013b5:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013b8:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1013bd:	85 c0                	test   %eax,%eax
  1013bf:	74 0c                	je     1013cd <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013c1:	c7 04 24 5b 13 10 00 	movl   $0x10135b,(%esp)
  1013c8:	e8 42 ff ff ff       	call   10130f <cons_intr>
    }
}
  1013cd:	90                   	nop
  1013ce:	c9                   	leave  
  1013cf:	c3                   	ret    

001013d0 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013d0:	55                   	push   %ebp
  1013d1:	89 e5                	mov    %esp,%ebp
  1013d3:	83 ec 38             	sub    $0x38,%esp
  1013d6:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1013df:	89 c2                	mov    %eax,%edx
  1013e1:	ec                   	in     (%dx),%al
  1013e2:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013e5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013e9:	0f b6 c0             	movzbl %al,%eax
  1013ec:	83 e0 01             	and    $0x1,%eax
  1013ef:	85 c0                	test   %eax,%eax
  1013f1:	75 0a                	jne    1013fd <kbd_proc_data+0x2d>
        return -1;
  1013f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013f8:	e9 55 01 00 00       	jmp    101552 <kbd_proc_data+0x182>
  1013fd:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101403:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101406:	89 c2                	mov    %eax,%edx
  101408:	ec                   	in     (%dx),%al
  101409:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10140c:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101410:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101413:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101417:	75 17                	jne    101430 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  101419:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10141e:	83 c8 40             	or     $0x40,%eax
  101421:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101426:	b8 00 00 00 00       	mov    $0x0,%eax
  10142b:	e9 22 01 00 00       	jmp    101552 <kbd_proc_data+0x182>
    } else if (data & 0x80) {
  101430:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101434:	84 c0                	test   %al,%al
  101436:	79 45                	jns    10147d <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101438:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10143d:	83 e0 40             	and    $0x40,%eax
  101440:	85 c0                	test   %eax,%eax
  101442:	75 08                	jne    10144c <kbd_proc_data+0x7c>
  101444:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101448:	24 7f                	and    $0x7f,%al
  10144a:	eb 04                	jmp    101450 <kbd_proc_data+0x80>
  10144c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101450:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101453:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101457:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10145e:	0c 40                	or     $0x40,%al
  101460:	0f b6 c0             	movzbl %al,%eax
  101463:	f7 d0                	not    %eax
  101465:	89 c2                	mov    %eax,%edx
  101467:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10146c:	21 d0                	and    %edx,%eax
  10146e:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101473:	b8 00 00 00 00       	mov    $0x0,%eax
  101478:	e9 d5 00 00 00       	jmp    101552 <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
  10147d:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101482:	83 e0 40             	and    $0x40,%eax
  101485:	85 c0                	test   %eax,%eax
  101487:	74 11                	je     10149a <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101489:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10148d:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101492:	83 e0 bf             	and    $0xffffffbf,%eax
  101495:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10149a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149e:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  1014a5:	0f b6 d0             	movzbl %al,%edx
  1014a8:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014ad:	09 d0                	or     %edx,%eax
  1014af:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  1014b4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b8:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014bf:	0f b6 d0             	movzbl %al,%edx
  1014c2:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c7:	31 d0                	xor    %edx,%eax
  1014c9:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014ce:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014d3:	83 e0 03             	and    $0x3,%eax
  1014d6:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014dd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014e1:	01 d0                	add    %edx,%eax
  1014e3:	0f b6 00             	movzbl (%eax),%eax
  1014e6:	0f b6 c0             	movzbl %al,%eax
  1014e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014ec:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014f1:	83 e0 08             	and    $0x8,%eax
  1014f4:	85 c0                	test   %eax,%eax
  1014f6:	74 22                	je     10151a <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  1014f8:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014fc:	7e 0c                	jle    10150a <kbd_proc_data+0x13a>
  1014fe:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101502:	7f 06                	jg     10150a <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  101504:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101508:	eb 10                	jmp    10151a <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  10150a:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10150e:	7e 0a                	jle    10151a <kbd_proc_data+0x14a>
  101510:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101514:	7f 04                	jg     10151a <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  101516:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10151a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10151f:	f7 d0                	not    %eax
  101521:	83 e0 06             	and    $0x6,%eax
  101524:	85 c0                	test   %eax,%eax
  101526:	75 27                	jne    10154f <kbd_proc_data+0x17f>
  101528:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10152f:	75 1e                	jne    10154f <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
  101531:	c7 04 24 0d 39 10 00 	movl   $0x10390d,(%esp)
  101538:	e8 2f ed ff ff       	call   10026c <cprintf>
  10153d:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101543:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101547:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10154b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10154e:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10154f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101552:	c9                   	leave  
  101553:	c3                   	ret    

00101554 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101554:	55                   	push   %ebp
  101555:	89 e5                	mov    %esp,%ebp
  101557:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10155a:	c7 04 24 d0 13 10 00 	movl   $0x1013d0,(%esp)
  101561:	e8 a9 fd ff ff       	call   10130f <cons_intr>
}
  101566:	90                   	nop
  101567:	c9                   	leave  
  101568:	c3                   	ret    

00101569 <kbd_init>:

static void
kbd_init(void) {
  101569:	55                   	push   %ebp
  10156a:	89 e5                	mov    %esp,%ebp
  10156c:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10156f:	e8 e0 ff ff ff       	call   101554 <kbd_intr>
    pic_enable(IRQ_KBD);
  101574:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10157b:	e8 0f 01 00 00       	call   10168f <pic_enable>
}
  101580:	90                   	nop
  101581:	c9                   	leave  
  101582:	c3                   	ret    

00101583 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101583:	55                   	push   %ebp
  101584:	89 e5                	mov    %esp,%ebp
  101586:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101589:	e8 83 f8 ff ff       	call   100e11 <cga_init>
    serial_init();
  10158e:	e8 62 f9 ff ff       	call   100ef5 <serial_init>
    kbd_init();
  101593:	e8 d1 ff ff ff       	call   101569 <kbd_init>
    if (!serial_exists) {
  101598:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10159d:	85 c0                	test   %eax,%eax
  10159f:	75 0c                	jne    1015ad <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015a1:	c7 04 24 19 39 10 00 	movl   $0x103919,(%esp)
  1015a8:	e8 bf ec ff ff       	call   10026c <cprintf>
    }
}
  1015ad:	90                   	nop
  1015ae:	c9                   	leave  
  1015af:	c3                   	ret    

001015b0 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015b0:	55                   	push   %ebp
  1015b1:	89 e5                	mov    %esp,%ebp
  1015b3:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1015b9:	89 04 24             	mov    %eax,(%esp)
  1015bc:	e8 91 fa ff ff       	call   101052 <lpt_putc>
    cga_putc(c);
  1015c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1015c4:	89 04 24             	mov    %eax,(%esp)
  1015c7:	e8 c6 fa ff ff       	call   101092 <cga_putc>
    serial_putc(c);
  1015cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1015cf:	89 04 24             	mov    %eax,(%esp)
  1015d2:	e8 f8 fc ff ff       	call   1012cf <serial_putc>
}
  1015d7:	90                   	nop
  1015d8:	c9                   	leave  
  1015d9:	c3                   	ret    

001015da <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015da:	55                   	push   %ebp
  1015db:	89 e5                	mov    %esp,%ebp
  1015dd:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015e0:	e8 cd fd ff ff       	call   1013b2 <serial_intr>
    kbd_intr();
  1015e5:	e8 6a ff ff ff       	call   101554 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015ea:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015f0:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015f5:	39 c2                	cmp    %eax,%edx
  1015f7:	74 36                	je     10162f <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015f9:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015fe:	8d 50 01             	lea    0x1(%eax),%edx
  101601:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  101607:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  10160e:	0f b6 c0             	movzbl %al,%eax
  101611:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101614:	a1 80 f0 10 00       	mov    0x10f080,%eax
  101619:	3d 00 02 00 00       	cmp    $0x200,%eax
  10161e:	75 0a                	jne    10162a <cons_getc+0x50>
            cons.rpos = 0;
  101620:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101627:	00 00 00 
        }
        return c;
  10162a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10162d:	eb 05                	jmp    101634 <cons_getc+0x5a>
    }
    return 0;
  10162f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101634:	c9                   	leave  
  101635:	c3                   	ret    

00101636 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101636:	55                   	push   %ebp
  101637:	89 e5                	mov    %esp,%ebp
  101639:	83 ec 14             	sub    $0x14,%esp
  10163c:	8b 45 08             	mov    0x8(%ebp),%eax
  10163f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101643:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101646:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10164c:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101651:	85 c0                	test   %eax,%eax
  101653:	74 37                	je     10168c <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101655:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101658:	0f b6 c0             	movzbl %al,%eax
  10165b:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101661:	88 45 f9             	mov    %al,-0x7(%ebp)
  101664:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101668:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10166c:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10166d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101671:	c1 e8 08             	shr    $0x8,%eax
  101674:	0f b7 c0             	movzwl %ax,%eax
  101677:	0f b6 c0             	movzbl %al,%eax
  10167a:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101680:	88 45 fd             	mov    %al,-0x3(%ebp)
  101683:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101687:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10168b:	ee                   	out    %al,(%dx)
    }
}
  10168c:	90                   	nop
  10168d:	c9                   	leave  
  10168e:	c3                   	ret    

0010168f <pic_enable>:

void
pic_enable(unsigned int irq) {
  10168f:	55                   	push   %ebp
  101690:	89 e5                	mov    %esp,%ebp
  101692:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101695:	8b 45 08             	mov    0x8(%ebp),%eax
  101698:	ba 01 00 00 00       	mov    $0x1,%edx
  10169d:	88 c1                	mov    %al,%cl
  10169f:	d3 e2                	shl    %cl,%edx
  1016a1:	89 d0                	mov    %edx,%eax
  1016a3:	98                   	cwtl   
  1016a4:	f7 d0                	not    %eax
  1016a6:	0f bf d0             	movswl %ax,%edx
  1016a9:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016b0:	98                   	cwtl   
  1016b1:	21 d0                	and    %edx,%eax
  1016b3:	98                   	cwtl   
  1016b4:	0f b7 c0             	movzwl %ax,%eax
  1016b7:	89 04 24             	mov    %eax,(%esp)
  1016ba:	e8 77 ff ff ff       	call   101636 <pic_setmask>
}
  1016bf:	90                   	nop
  1016c0:	c9                   	leave  
  1016c1:	c3                   	ret    

001016c2 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016c2:	55                   	push   %ebp
  1016c3:	89 e5                	mov    %esp,%ebp
  1016c5:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016c8:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016cf:	00 00 00 
  1016d2:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1016d8:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  1016dc:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1016e0:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1016e4:	ee                   	out    %al,(%dx)
  1016e5:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1016eb:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  1016ef:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1016f3:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1016f7:	ee                   	out    %al,(%dx)
  1016f8:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1016fe:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  101702:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101706:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10170a:	ee                   	out    %al,(%dx)
  10170b:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101711:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  101715:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101719:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10171d:	ee                   	out    %al,(%dx)
  10171e:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101724:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  101728:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10172c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101730:	ee                   	out    %al,(%dx)
  101731:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101737:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  10173b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10173f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101743:	ee                   	out    %al,(%dx)
  101744:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  10174a:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  10174e:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101752:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101756:	ee                   	out    %al,(%dx)
  101757:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  10175d:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  101761:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101765:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101769:	ee                   	out    %al,(%dx)
  10176a:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101770:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  101774:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101778:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10177c:	ee                   	out    %al,(%dx)
  10177d:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101783:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  101787:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10178b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10178f:	ee                   	out    %al,(%dx)
  101790:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101796:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  10179a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10179e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017a2:	ee                   	out    %al,(%dx)
  1017a3:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1017a9:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  1017ad:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1017b1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1017b5:	ee                   	out    %al,(%dx)
  1017b6:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1017bc:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  1017c0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017c4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017c8:	ee                   	out    %al,(%dx)
  1017c9:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1017cf:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  1017d3:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017d7:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017db:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017dc:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017e3:	3d ff ff 00 00       	cmp    $0xffff,%eax
  1017e8:	74 0f                	je     1017f9 <pic_init+0x137>
        pic_setmask(irq_mask);
  1017ea:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017f1:	89 04 24             	mov    %eax,(%esp)
  1017f4:	e8 3d fe ff ff       	call   101636 <pic_setmask>
    }
}
  1017f9:	90                   	nop
  1017fa:	c9                   	leave  
  1017fb:	c3                   	ret    

001017fc <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017fc:	55                   	push   %ebp
  1017fd:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1017ff:	fb                   	sti    
    sti();
}
  101800:	90                   	nop
  101801:	5d                   	pop    %ebp
  101802:	c3                   	ret    

00101803 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101803:	55                   	push   %ebp
  101804:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101806:	fa                   	cli    
    cli();
}
  101807:	90                   	nop
  101808:	5d                   	pop    %ebp
  101809:	c3                   	ret    

0010180a <print_ticks>:
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks()
{
  10180a:	55                   	push   %ebp
  10180b:	89 e5                	mov    %esp,%ebp
  10180d:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n", TICK_NUM);
  101810:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101817:	00 
  101818:	c7 04 24 40 39 10 00 	movl   $0x103940,(%esp)
  10181f:	e8 48 ea ff ff       	call   10026c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101824:	90                   	nop
  101825:	c9                   	leave  
  101826:	c3                   	ret    

00101827 <idt_init>:
static struct pseudodesc idt_pd = {
    sizeof(idt) - 1, (uintptr_t)idt};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void idt_init(void)
{
  101827:	55                   	push   %ebp
  101828:	89 e5                	mov    %esp,%ebp
  10182a:	83 ec 10             	sub    $0x10,%esp
     *     Notice: the argument of lidt is idt_pd. try to find it!
     */

    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i++)
  10182d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101834:	e9 c4 00 00 00       	jmp    1018fd <idt_init+0xd6>
    {
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101839:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10183c:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101843:	0f b7 d0             	movzwl %ax,%edx
  101846:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101849:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101850:	00 
  101851:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101854:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  10185b:	00 08 00 
  10185e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101861:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101868:	00 
  101869:	80 e2 e0             	and    $0xe0,%dl
  10186c:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101873:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101876:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10187d:	00 
  10187e:	80 e2 1f             	and    $0x1f,%dl
  101881:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101888:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10188b:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101892:	00 
  101893:	80 e2 f0             	and    $0xf0,%dl
  101896:	80 ca 0e             	or     $0xe,%dl
  101899:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a3:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018aa:	00 
  1018ab:	80 e2 ef             	and    $0xef,%dl
  1018ae:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b8:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018bf:	00 
  1018c0:	80 e2 9f             	and    $0x9f,%dl
  1018c3:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018cd:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018d4:	00 
  1018d5:	80 ca 80             	or     $0x80,%dl
  1018d8:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e2:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018e9:	c1 e8 10             	shr    $0x10,%eax
  1018ec:	0f b7 d0             	movzwl %ax,%edx
  1018ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f2:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018f9:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i++)
  1018fa:	ff 45 fc             	incl   -0x4(%ebp)
  1018fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101900:	3d ff 00 00 00       	cmp    $0xff,%eax
  101905:	0f 86 2e ff ff ff    	jbe    101839 <idt_init+0x12>
    }
    // set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  10190b:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101910:	0f b7 c0             	movzwl %ax,%eax
  101913:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  101919:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  101920:	08 00 
  101922:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101929:	24 e0                	and    $0xe0,%al
  10192b:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101930:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101937:	24 1f                	and    $0x1f,%al
  101939:	a2 6c f4 10 00       	mov    %al,0x10f46c
  10193e:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101945:	24 f0                	and    $0xf0,%al
  101947:	0c 0e                	or     $0xe,%al
  101949:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10194e:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101955:	24 ef                	and    $0xef,%al
  101957:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10195c:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101963:	0c 60                	or     $0x60,%al
  101965:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10196a:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101971:	0c 80                	or     $0x80,%al
  101973:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101978:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  10197d:	c1 e8 10             	shr    $0x10,%eax
  101980:	0f b7 c0             	movzwl %ax,%eax
  101983:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  101989:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101990:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101993:	0f 01 18             	lidtl  (%eax)
    // load the IDT
    lidt(&idt_pd);
}
  101996:	90                   	nop
  101997:	c9                   	leave  
  101998:	c3                   	ret    

00101999 <trapname>:

static const char *
trapname(int trapno)
{
  101999:	55                   	push   %ebp
  10199a:	89 e5                	mov    %esp,%ebp
        "x87 FPU Floating-Point Error",
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"};

    if (trapno < sizeof(excnames) / sizeof(const char *const))
  10199c:	8b 45 08             	mov    0x8(%ebp),%eax
  10199f:	83 f8 13             	cmp    $0x13,%eax
  1019a2:	77 0c                	ja     1019b0 <trapname+0x17>
    {
        return excnames[trapno];
  1019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1019a7:	8b 04 85 a0 3c 10 00 	mov    0x103ca0(,%eax,4),%eax
  1019ae:	eb 18                	jmp    1019c8 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
  1019b0:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019b4:	7e 0d                	jle    1019c3 <trapname+0x2a>
  1019b6:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019ba:	7f 07                	jg     1019c3 <trapname+0x2a>
    {
        return "Hardware Interrupt";
  1019bc:	b8 4a 39 10 00       	mov    $0x10394a,%eax
  1019c1:	eb 05                	jmp    1019c8 <trapname+0x2f>
    }
    return "(unknown trap)";
  1019c3:	b8 5d 39 10 00       	mov    $0x10395d,%eax
}
  1019c8:	5d                   	pop    %ebp
  1019c9:	c3                   	ret    

001019ca <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool trap_in_kernel(struct trapframe *tf)
{
  1019ca:	55                   	push   %ebp
  1019cb:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019d4:	83 f8 08             	cmp    $0x8,%eax
  1019d7:	0f 94 c0             	sete   %al
  1019da:	0f b6 c0             	movzbl %al,%eax
}
  1019dd:	5d                   	pop    %ebp
  1019de:	c3                   	ret    

001019df <print_trapframe>:
    NULL,
    NULL,
};

void print_trapframe(struct trapframe *tf)
{
  1019df:	55                   	push   %ebp
  1019e0:	89 e5                	mov    %esp,%ebp
  1019e2:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019ec:	c7 04 24 9e 39 10 00 	movl   $0x10399e,(%esp)
  1019f3:	e8 74 e8 ff ff       	call   10026c <cprintf>
    print_regs(&tf->tf_regs);
  1019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1019fb:	89 04 24             	mov    %eax,(%esp)
  1019fe:	e8 8f 01 00 00       	call   101b92 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a03:	8b 45 08             	mov    0x8(%ebp),%eax
  101a06:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a0e:	c7 04 24 af 39 10 00 	movl   $0x1039af,(%esp)
  101a15:	e8 52 e8 ff ff       	call   10026c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a1d:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a21:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a25:	c7 04 24 c2 39 10 00 	movl   $0x1039c2,(%esp)
  101a2c:	e8 3b e8 ff ff       	call   10026c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a31:	8b 45 08             	mov    0x8(%ebp),%eax
  101a34:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a38:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a3c:	c7 04 24 d5 39 10 00 	movl   $0x1039d5,(%esp)
  101a43:	e8 24 e8 ff ff       	call   10026c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a48:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4b:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a53:	c7 04 24 e8 39 10 00 	movl   $0x1039e8,(%esp)
  101a5a:	e8 0d e8 ff ff       	call   10026c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a62:	8b 40 30             	mov    0x30(%eax),%eax
  101a65:	89 04 24             	mov    %eax,(%esp)
  101a68:	e8 2c ff ff ff       	call   101999 <trapname>
  101a6d:	89 c2                	mov    %eax,%edx
  101a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a72:	8b 40 30             	mov    0x30(%eax),%eax
  101a75:	89 54 24 08          	mov    %edx,0x8(%esp)
  101a79:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a7d:	c7 04 24 fb 39 10 00 	movl   $0x1039fb,(%esp)
  101a84:	e8 e3 e7 ff ff       	call   10026c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a89:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8c:	8b 40 34             	mov    0x34(%eax),%eax
  101a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a93:	c7 04 24 0d 3a 10 00 	movl   $0x103a0d,(%esp)
  101a9a:	e8 cd e7 ff ff       	call   10026c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa2:	8b 40 38             	mov    0x38(%eax),%eax
  101aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa9:	c7 04 24 1c 3a 10 00 	movl   $0x103a1c,(%esp)
  101ab0:	e8 b7 e7 ff ff       	call   10026c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101abc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac0:	c7 04 24 2b 3a 10 00 	movl   $0x103a2b,(%esp)
  101ac7:	e8 a0 e7 ff ff       	call   10026c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101acc:	8b 45 08             	mov    0x8(%ebp),%eax
  101acf:	8b 40 40             	mov    0x40(%eax),%eax
  101ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad6:	c7 04 24 3e 3a 10 00 	movl   $0x103a3e,(%esp)
  101add:	e8 8a e7 ff ff       	call   10026c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i++, j <<= 1)
  101ae2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101ae9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101af0:	eb 3d                	jmp    101b2f <print_trapframe+0x150>
    {
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL)
  101af2:	8b 45 08             	mov    0x8(%ebp),%eax
  101af5:	8b 50 40             	mov    0x40(%eax),%edx
  101af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101afb:	21 d0                	and    %edx,%eax
  101afd:	85 c0                	test   %eax,%eax
  101aff:	74 28                	je     101b29 <print_trapframe+0x14a>
  101b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b04:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b0b:	85 c0                	test   %eax,%eax
  101b0d:	74 1a                	je     101b29 <print_trapframe+0x14a>
        {
            cprintf("%s,", IA32flags[i]);
  101b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b12:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b19:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b1d:	c7 04 24 4d 3a 10 00 	movl   $0x103a4d,(%esp)
  101b24:	e8 43 e7 ff ff       	call   10026c <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i++, j <<= 1)
  101b29:	ff 45 f4             	incl   -0xc(%ebp)
  101b2c:	d1 65 f0             	shll   -0x10(%ebp)
  101b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b32:	83 f8 17             	cmp    $0x17,%eax
  101b35:	76 bb                	jbe    101af2 <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b37:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3a:	8b 40 40             	mov    0x40(%eax),%eax
  101b3d:	c1 e8 0c             	shr    $0xc,%eax
  101b40:	83 e0 03             	and    $0x3,%eax
  101b43:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b47:	c7 04 24 51 3a 10 00 	movl   $0x103a51,(%esp)
  101b4e:	e8 19 e7 ff ff       	call   10026c <cprintf>

    if (!trap_in_kernel(tf))
  101b53:	8b 45 08             	mov    0x8(%ebp),%eax
  101b56:	89 04 24             	mov    %eax,(%esp)
  101b59:	e8 6c fe ff ff       	call   1019ca <trap_in_kernel>
  101b5e:	85 c0                	test   %eax,%eax
  101b60:	75 2d                	jne    101b8f <print_trapframe+0x1b0>
    {
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b62:	8b 45 08             	mov    0x8(%ebp),%eax
  101b65:	8b 40 44             	mov    0x44(%eax),%eax
  101b68:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b6c:	c7 04 24 5a 3a 10 00 	movl   $0x103a5a,(%esp)
  101b73:	e8 f4 e6 ff ff       	call   10026c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b78:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7b:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b83:	c7 04 24 69 3a 10 00 	movl   $0x103a69,(%esp)
  101b8a:	e8 dd e6 ff ff       	call   10026c <cprintf>
    }
}
  101b8f:	90                   	nop
  101b90:	c9                   	leave  
  101b91:	c3                   	ret    

00101b92 <print_regs>:

void print_regs(struct pushregs *regs)
{
  101b92:	55                   	push   %ebp
  101b93:	89 e5                	mov    %esp,%ebp
  101b95:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101b98:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9b:	8b 00                	mov    (%eax),%eax
  101b9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba1:	c7 04 24 7c 3a 10 00 	movl   $0x103a7c,(%esp)
  101ba8:	e8 bf e6 ff ff       	call   10026c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bad:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb0:	8b 40 04             	mov    0x4(%eax),%eax
  101bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb7:	c7 04 24 8b 3a 10 00 	movl   $0x103a8b,(%esp)
  101bbe:	e8 a9 e6 ff ff       	call   10026c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc6:	8b 40 08             	mov    0x8(%eax),%eax
  101bc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bcd:	c7 04 24 9a 3a 10 00 	movl   $0x103a9a,(%esp)
  101bd4:	e8 93 e6 ff ff       	call   10026c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bdc:	8b 40 0c             	mov    0xc(%eax),%eax
  101bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be3:	c7 04 24 a9 3a 10 00 	movl   $0x103aa9,(%esp)
  101bea:	e8 7d e6 ff ff       	call   10026c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101bef:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf2:	8b 40 10             	mov    0x10(%eax),%eax
  101bf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf9:	c7 04 24 b8 3a 10 00 	movl   $0x103ab8,(%esp)
  101c00:	e8 67 e6 ff ff       	call   10026c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c05:	8b 45 08             	mov    0x8(%ebp),%eax
  101c08:	8b 40 14             	mov    0x14(%eax),%eax
  101c0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0f:	c7 04 24 c7 3a 10 00 	movl   $0x103ac7,(%esp)
  101c16:	e8 51 e6 ff ff       	call   10026c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1e:	8b 40 18             	mov    0x18(%eax),%eax
  101c21:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c25:	c7 04 24 d6 3a 10 00 	movl   $0x103ad6,(%esp)
  101c2c:	e8 3b e6 ff ff       	call   10026c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c31:	8b 45 08             	mov    0x8(%ebp),%eax
  101c34:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c37:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3b:	c7 04 24 e5 3a 10 00 	movl   $0x103ae5,(%esp)
  101c42:	e8 25 e6 ff ff       	call   10026c <cprintf>
}
  101c47:	90                   	nop
  101c48:	c9                   	leave  
  101c49:	c3                   	ret    

00101c4a <trap_dispatch>:
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf)
{
  101c4a:	55                   	push   %ebp
  101c4b:	89 e5                	mov    %esp,%ebp
  101c4d:	57                   	push   %edi
  101c4e:	56                   	push   %esi
  101c4f:	53                   	push   %ebx
  101c50:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno)
  101c53:	8b 45 08             	mov    0x8(%ebp),%eax
  101c56:	8b 40 30             	mov    0x30(%eax),%eax
  101c59:	83 f8 2f             	cmp    $0x2f,%eax
  101c5c:	77 21                	ja     101c7f <trap_dispatch+0x35>
  101c5e:	83 f8 2e             	cmp    $0x2e,%eax
  101c61:	0f 83 5d 02 00 00    	jae    101ec4 <trap_dispatch+0x27a>
  101c67:	83 f8 21             	cmp    $0x21,%eax
  101c6a:	0f 84 95 00 00 00    	je     101d05 <trap_dispatch+0xbb>
  101c70:	83 f8 24             	cmp    $0x24,%eax
  101c73:	74 67                	je     101cdc <trap_dispatch+0x92>
  101c75:	83 f8 20             	cmp    $0x20,%eax
  101c78:	74 1c                	je     101c96 <trap_dispatch+0x4c>
  101c7a:	e9 10 02 00 00       	jmp    101e8f <trap_dispatch+0x245>
  101c7f:	83 f8 78             	cmp    $0x78,%eax
  101c82:	0f 84 a6 00 00 00    	je     101d2e <trap_dispatch+0xe4>
  101c88:	83 f8 79             	cmp    $0x79,%eax
  101c8b:	0f 84 81 01 00 00    	je     101e12 <trap_dispatch+0x1c8>
  101c91:	e9 f9 01 00 00       	jmp    101e8f <trap_dispatch+0x245>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
  101c96:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101c9b:	40                   	inc    %eax
  101c9c:	a3 08 f9 10 00       	mov    %eax,0x10f908
        if (ticks % TICK_NUM == 0)
  101ca1:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101ca7:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101cac:	89 c8                	mov    %ecx,%eax
  101cae:	f7 e2                	mul    %edx
  101cb0:	c1 ea 05             	shr    $0x5,%edx
  101cb3:	89 d0                	mov    %edx,%eax
  101cb5:	c1 e0 02             	shl    $0x2,%eax
  101cb8:	01 d0                	add    %edx,%eax
  101cba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101cc1:	01 d0                	add    %edx,%eax
  101cc3:	c1 e0 02             	shl    $0x2,%eax
  101cc6:	29 c1                	sub    %eax,%ecx
  101cc8:	89 ca                	mov    %ecx,%edx
  101cca:	85 d2                	test   %edx,%edx
  101ccc:	0f 85 f5 01 00 00    	jne    101ec7 <trap_dispatch+0x27d>
        {
            print_ticks();
  101cd2:	e8 33 fb ff ff       	call   10180a <print_ticks>
        }
        break;
  101cd7:	e9 eb 01 00 00       	jmp    101ec7 <trap_dispatch+0x27d>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101cdc:	e8 f9 f8 ff ff       	call   1015da <cons_getc>
  101ce1:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101ce4:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101ce8:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101cec:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cf0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf4:	c7 04 24 f4 3a 10 00 	movl   $0x103af4,(%esp)
  101cfb:	e8 6c e5 ff ff       	call   10026c <cprintf>
        break;
  101d00:	e9 c9 01 00 00       	jmp    101ece <trap_dispatch+0x284>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d05:	e8 d0 f8 ff ff       	call   1015da <cons_getc>
  101d0a:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d0d:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d11:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d15:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d19:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d1d:	c7 04 24 06 3b 10 00 	movl   $0x103b06,(%esp)
  101d24:	e8 43 e5 ff ff       	call   10026c <cprintf>
        break;
  101d29:	e9 a0 01 00 00       	jmp    101ece <trap_dispatch+0x284>
    // LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS)
  101d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d31:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d35:	83 f8 1b             	cmp    $0x1b,%eax
  101d38:	0f 84 8c 01 00 00    	je     101eca <trap_dispatch+0x280>
        {
            switchk2u = *tf;
  101d3e:	8b 55 08             	mov    0x8(%ebp),%edx
  101d41:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  101d46:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  101d4b:	89 c1                	mov    %eax,%ecx
  101d4d:	83 e1 01             	and    $0x1,%ecx
  101d50:	85 c9                	test   %ecx,%ecx
  101d52:	74 0c                	je     101d60 <trap_dispatch+0x116>
  101d54:	0f b6 0a             	movzbl (%edx),%ecx
  101d57:	88 08                	mov    %cl,(%eax)
  101d59:	8d 40 01             	lea    0x1(%eax),%eax
  101d5c:	8d 52 01             	lea    0x1(%edx),%edx
  101d5f:	4b                   	dec    %ebx
  101d60:	89 c1                	mov    %eax,%ecx
  101d62:	83 e1 02             	and    $0x2,%ecx
  101d65:	85 c9                	test   %ecx,%ecx
  101d67:	74 0f                	je     101d78 <trap_dispatch+0x12e>
  101d69:	0f b7 0a             	movzwl (%edx),%ecx
  101d6c:	66 89 08             	mov    %cx,(%eax)
  101d6f:	8d 40 02             	lea    0x2(%eax),%eax
  101d72:	8d 52 02             	lea    0x2(%edx),%edx
  101d75:	83 eb 02             	sub    $0x2,%ebx
  101d78:	89 df                	mov    %ebx,%edi
  101d7a:	83 e7 fc             	and    $0xfffffffc,%edi
  101d7d:	b9 00 00 00 00       	mov    $0x0,%ecx
  101d82:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  101d85:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  101d88:	83 c1 04             	add    $0x4,%ecx
  101d8b:	39 f9                	cmp    %edi,%ecx
  101d8d:	72 f3                	jb     101d82 <trap_dispatch+0x138>
  101d8f:	01 c8                	add    %ecx,%eax
  101d91:	01 ca                	add    %ecx,%edx
  101d93:	b9 00 00 00 00       	mov    $0x0,%ecx
  101d98:	89 de                	mov    %ebx,%esi
  101d9a:	83 e6 02             	and    $0x2,%esi
  101d9d:	85 f6                	test   %esi,%esi
  101d9f:	74 0b                	je     101dac <trap_dispatch+0x162>
  101da1:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  101da5:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  101da9:	83 c1 02             	add    $0x2,%ecx
  101dac:	83 e3 01             	and    $0x1,%ebx
  101daf:	85 db                	test   %ebx,%ebx
  101db1:	74 07                	je     101dba <trap_dispatch+0x170>
  101db3:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  101db7:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
  101dba:	66 c7 05 5c f9 10 00 	movw   $0x1b,0x10f95c
  101dc1:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101dc3:	66 c7 05 68 f9 10 00 	movw   $0x23,0x10f968
  101dca:	23 00 
  101dcc:	0f b7 05 68 f9 10 00 	movzwl 0x10f968,%eax
  101dd3:	66 a3 48 f9 10 00    	mov    %ax,0x10f948
  101dd9:	0f b7 05 48 f9 10 00 	movzwl 0x10f948,%eax
  101de0:	66 a3 4c f9 10 00    	mov    %ax,0x10f94c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101de6:	8b 45 08             	mov    0x8(%ebp),%eax
  101de9:	83 c0 44             	add    $0x44,%eax
  101dec:	a3 64 f9 10 00       	mov    %eax,0x10f964

            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101df1:	a1 60 f9 10 00       	mov    0x10f960,%eax
  101df6:	0d 00 30 00 00       	or     $0x3000,%eax
  101dfb:	a3 60 f9 10 00       	mov    %eax,0x10f960

            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101e00:	8b 45 08             	mov    0x8(%ebp),%eax
  101e03:	83 e8 04             	sub    $0x4,%eax
  101e06:	ba 20 f9 10 00       	mov    $0x10f920,%edx
  101e0b:	89 10                	mov    %edx,(%eax)
        }
        break;
  101e0d:	e9 b8 00 00 00       	jmp    101eca <trap_dispatch+0x280>

    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS)
  101e12:	8b 45 08             	mov    0x8(%ebp),%eax
  101e15:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e19:	83 f8 08             	cmp    $0x8,%eax
  101e1c:	0f 84 ab 00 00 00    	je     101ecd <trap_dispatch+0x283>
        {
            tf->tf_cs = KERNEL_CS;
  101e22:	8b 45 08             	mov    0x8(%ebp),%eax
  101e25:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e2e:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101e34:	8b 45 08             	mov    0x8(%ebp),%eax
  101e37:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e3e:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101e42:	8b 45 08             	mov    0x8(%ebp),%eax
  101e45:	8b 40 40             	mov    0x40(%eax),%eax
  101e48:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101e4d:	89 c2                	mov    %eax,%edx
  101e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e52:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101e55:	8b 45 08             	mov    0x8(%ebp),%eax
  101e58:	8b 40 44             	mov    0x44(%eax),%eax
  101e5b:	83 e8 44             	sub    $0x44,%eax
  101e5e:	a3 6c f9 10 00       	mov    %eax,0x10f96c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101e63:	a1 6c f9 10 00       	mov    0x10f96c,%eax
  101e68:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101e6f:	00 
  101e70:	8b 55 08             	mov    0x8(%ebp),%edx
  101e73:	89 54 24 04          	mov    %edx,0x4(%esp)
  101e77:	89 04 24             	mov    %eax,(%esp)
  101e7a:	e8 9a 0f 00 00       	call   102e19 <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101e7f:	8b 15 6c f9 10 00    	mov    0x10f96c,%edx
  101e85:	8b 45 08             	mov    0x8(%ebp),%eax
  101e88:	83 e8 04             	sub    $0x4,%eax
  101e8b:	89 10                	mov    %edx,(%eax)
        }
        break;
  101e8d:	eb 3e                	jmp    101ecd <trap_dispatch+0x283>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0)
  101e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e92:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e96:	83 e0 03             	and    $0x3,%eax
  101e99:	85 c0                	test   %eax,%eax
  101e9b:	75 31                	jne    101ece <trap_dispatch+0x284>
        {
            print_trapframe(tf);
  101e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea0:	89 04 24             	mov    %eax,(%esp)
  101ea3:	e8 37 fb ff ff       	call   1019df <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101ea8:	c7 44 24 08 15 3b 10 	movl   $0x103b15,0x8(%esp)
  101eaf:	00 
  101eb0:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
  101eb7:	00 
  101eb8:	c7 04 24 31 3b 10 00 	movl   $0x103b31,(%esp)
  101ebf:	e8 ff e4 ff ff       	call   1003c3 <__panic>
        break;
  101ec4:	90                   	nop
  101ec5:	eb 07                	jmp    101ece <trap_dispatch+0x284>
        break;
  101ec7:	90                   	nop
  101ec8:	eb 04                	jmp    101ece <trap_dispatch+0x284>
        break;
  101eca:	90                   	nop
  101ecb:	eb 01                	jmp    101ece <trap_dispatch+0x284>
        break;
  101ecd:	90                   	nop
        }
    }
}
  101ece:	90                   	nop
  101ecf:	83 c4 2c             	add    $0x2c,%esp
  101ed2:	5b                   	pop    %ebx
  101ed3:	5e                   	pop    %esi
  101ed4:	5f                   	pop    %edi
  101ed5:	5d                   	pop    %ebp
  101ed6:	c3                   	ret    

00101ed7 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
  101ed7:	55                   	push   %ebp
  101ed8:	89 e5                	mov    %esp,%ebp
  101eda:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101edd:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee0:	89 04 24             	mov    %eax,(%esp)
  101ee3:	e8 62 fd ff ff       	call   101c4a <trap_dispatch>
}
  101ee8:	90                   	nop
  101ee9:	c9                   	leave  
  101eea:	c3                   	ret    

00101eeb <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101eeb:	6a 00                	push   $0x0
  pushl $0
  101eed:	6a 00                	push   $0x0
  jmp __alltraps
  101eef:	e9 69 0a 00 00       	jmp    10295d <__alltraps>

00101ef4 <vector1>:
.globl vector1
vector1:
  pushl $0
  101ef4:	6a 00                	push   $0x0
  pushl $1
  101ef6:	6a 01                	push   $0x1
  jmp __alltraps
  101ef8:	e9 60 0a 00 00       	jmp    10295d <__alltraps>

00101efd <vector2>:
.globl vector2
vector2:
  pushl $0
  101efd:	6a 00                	push   $0x0
  pushl $2
  101eff:	6a 02                	push   $0x2
  jmp __alltraps
  101f01:	e9 57 0a 00 00       	jmp    10295d <__alltraps>

00101f06 <vector3>:
.globl vector3
vector3:
  pushl $0
  101f06:	6a 00                	push   $0x0
  pushl $3
  101f08:	6a 03                	push   $0x3
  jmp __alltraps
  101f0a:	e9 4e 0a 00 00       	jmp    10295d <__alltraps>

00101f0f <vector4>:
.globl vector4
vector4:
  pushl $0
  101f0f:	6a 00                	push   $0x0
  pushl $4
  101f11:	6a 04                	push   $0x4
  jmp __alltraps
  101f13:	e9 45 0a 00 00       	jmp    10295d <__alltraps>

00101f18 <vector5>:
.globl vector5
vector5:
  pushl $0
  101f18:	6a 00                	push   $0x0
  pushl $5
  101f1a:	6a 05                	push   $0x5
  jmp __alltraps
  101f1c:	e9 3c 0a 00 00       	jmp    10295d <__alltraps>

00101f21 <vector6>:
.globl vector6
vector6:
  pushl $0
  101f21:	6a 00                	push   $0x0
  pushl $6
  101f23:	6a 06                	push   $0x6
  jmp __alltraps
  101f25:	e9 33 0a 00 00       	jmp    10295d <__alltraps>

00101f2a <vector7>:
.globl vector7
vector7:
  pushl $0
  101f2a:	6a 00                	push   $0x0
  pushl $7
  101f2c:	6a 07                	push   $0x7
  jmp __alltraps
  101f2e:	e9 2a 0a 00 00       	jmp    10295d <__alltraps>

00101f33 <vector8>:
.globl vector8
vector8:
  pushl $8
  101f33:	6a 08                	push   $0x8
  jmp __alltraps
  101f35:	e9 23 0a 00 00       	jmp    10295d <__alltraps>

00101f3a <vector9>:
.globl vector9
vector9:
  pushl $0
  101f3a:	6a 00                	push   $0x0
  pushl $9
  101f3c:	6a 09                	push   $0x9
  jmp __alltraps
  101f3e:	e9 1a 0a 00 00       	jmp    10295d <__alltraps>

00101f43 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f43:	6a 0a                	push   $0xa
  jmp __alltraps
  101f45:	e9 13 0a 00 00       	jmp    10295d <__alltraps>

00101f4a <vector11>:
.globl vector11
vector11:
  pushl $11
  101f4a:	6a 0b                	push   $0xb
  jmp __alltraps
  101f4c:	e9 0c 0a 00 00       	jmp    10295d <__alltraps>

00101f51 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f51:	6a 0c                	push   $0xc
  jmp __alltraps
  101f53:	e9 05 0a 00 00       	jmp    10295d <__alltraps>

00101f58 <vector13>:
.globl vector13
vector13:
  pushl $13
  101f58:	6a 0d                	push   $0xd
  jmp __alltraps
  101f5a:	e9 fe 09 00 00       	jmp    10295d <__alltraps>

00101f5f <vector14>:
.globl vector14
vector14:
  pushl $14
  101f5f:	6a 0e                	push   $0xe
  jmp __alltraps
  101f61:	e9 f7 09 00 00       	jmp    10295d <__alltraps>

00101f66 <vector15>:
.globl vector15
vector15:
  pushl $0
  101f66:	6a 00                	push   $0x0
  pushl $15
  101f68:	6a 0f                	push   $0xf
  jmp __alltraps
  101f6a:	e9 ee 09 00 00       	jmp    10295d <__alltraps>

00101f6f <vector16>:
.globl vector16
vector16:
  pushl $0
  101f6f:	6a 00                	push   $0x0
  pushl $16
  101f71:	6a 10                	push   $0x10
  jmp __alltraps
  101f73:	e9 e5 09 00 00       	jmp    10295d <__alltraps>

00101f78 <vector17>:
.globl vector17
vector17:
  pushl $17
  101f78:	6a 11                	push   $0x11
  jmp __alltraps
  101f7a:	e9 de 09 00 00       	jmp    10295d <__alltraps>

00101f7f <vector18>:
.globl vector18
vector18:
  pushl $0
  101f7f:	6a 00                	push   $0x0
  pushl $18
  101f81:	6a 12                	push   $0x12
  jmp __alltraps
  101f83:	e9 d5 09 00 00       	jmp    10295d <__alltraps>

00101f88 <vector19>:
.globl vector19
vector19:
  pushl $0
  101f88:	6a 00                	push   $0x0
  pushl $19
  101f8a:	6a 13                	push   $0x13
  jmp __alltraps
  101f8c:	e9 cc 09 00 00       	jmp    10295d <__alltraps>

00101f91 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f91:	6a 00                	push   $0x0
  pushl $20
  101f93:	6a 14                	push   $0x14
  jmp __alltraps
  101f95:	e9 c3 09 00 00       	jmp    10295d <__alltraps>

00101f9a <vector21>:
.globl vector21
vector21:
  pushl $0
  101f9a:	6a 00                	push   $0x0
  pushl $21
  101f9c:	6a 15                	push   $0x15
  jmp __alltraps
  101f9e:	e9 ba 09 00 00       	jmp    10295d <__alltraps>

00101fa3 <vector22>:
.globl vector22
vector22:
  pushl $0
  101fa3:	6a 00                	push   $0x0
  pushl $22
  101fa5:	6a 16                	push   $0x16
  jmp __alltraps
  101fa7:	e9 b1 09 00 00       	jmp    10295d <__alltraps>

00101fac <vector23>:
.globl vector23
vector23:
  pushl $0
  101fac:	6a 00                	push   $0x0
  pushl $23
  101fae:	6a 17                	push   $0x17
  jmp __alltraps
  101fb0:	e9 a8 09 00 00       	jmp    10295d <__alltraps>

00101fb5 <vector24>:
.globl vector24
vector24:
  pushl $0
  101fb5:	6a 00                	push   $0x0
  pushl $24
  101fb7:	6a 18                	push   $0x18
  jmp __alltraps
  101fb9:	e9 9f 09 00 00       	jmp    10295d <__alltraps>

00101fbe <vector25>:
.globl vector25
vector25:
  pushl $0
  101fbe:	6a 00                	push   $0x0
  pushl $25
  101fc0:	6a 19                	push   $0x19
  jmp __alltraps
  101fc2:	e9 96 09 00 00       	jmp    10295d <__alltraps>

00101fc7 <vector26>:
.globl vector26
vector26:
  pushl $0
  101fc7:	6a 00                	push   $0x0
  pushl $26
  101fc9:	6a 1a                	push   $0x1a
  jmp __alltraps
  101fcb:	e9 8d 09 00 00       	jmp    10295d <__alltraps>

00101fd0 <vector27>:
.globl vector27
vector27:
  pushl $0
  101fd0:	6a 00                	push   $0x0
  pushl $27
  101fd2:	6a 1b                	push   $0x1b
  jmp __alltraps
  101fd4:	e9 84 09 00 00       	jmp    10295d <__alltraps>

00101fd9 <vector28>:
.globl vector28
vector28:
  pushl $0
  101fd9:	6a 00                	push   $0x0
  pushl $28
  101fdb:	6a 1c                	push   $0x1c
  jmp __alltraps
  101fdd:	e9 7b 09 00 00       	jmp    10295d <__alltraps>

00101fe2 <vector29>:
.globl vector29
vector29:
  pushl $0
  101fe2:	6a 00                	push   $0x0
  pushl $29
  101fe4:	6a 1d                	push   $0x1d
  jmp __alltraps
  101fe6:	e9 72 09 00 00       	jmp    10295d <__alltraps>

00101feb <vector30>:
.globl vector30
vector30:
  pushl $0
  101feb:	6a 00                	push   $0x0
  pushl $30
  101fed:	6a 1e                	push   $0x1e
  jmp __alltraps
  101fef:	e9 69 09 00 00       	jmp    10295d <__alltraps>

00101ff4 <vector31>:
.globl vector31
vector31:
  pushl $0
  101ff4:	6a 00                	push   $0x0
  pushl $31
  101ff6:	6a 1f                	push   $0x1f
  jmp __alltraps
  101ff8:	e9 60 09 00 00       	jmp    10295d <__alltraps>

00101ffd <vector32>:
.globl vector32
vector32:
  pushl $0
  101ffd:	6a 00                	push   $0x0
  pushl $32
  101fff:	6a 20                	push   $0x20
  jmp __alltraps
  102001:	e9 57 09 00 00       	jmp    10295d <__alltraps>

00102006 <vector33>:
.globl vector33
vector33:
  pushl $0
  102006:	6a 00                	push   $0x0
  pushl $33
  102008:	6a 21                	push   $0x21
  jmp __alltraps
  10200a:	e9 4e 09 00 00       	jmp    10295d <__alltraps>

0010200f <vector34>:
.globl vector34
vector34:
  pushl $0
  10200f:	6a 00                	push   $0x0
  pushl $34
  102011:	6a 22                	push   $0x22
  jmp __alltraps
  102013:	e9 45 09 00 00       	jmp    10295d <__alltraps>

00102018 <vector35>:
.globl vector35
vector35:
  pushl $0
  102018:	6a 00                	push   $0x0
  pushl $35
  10201a:	6a 23                	push   $0x23
  jmp __alltraps
  10201c:	e9 3c 09 00 00       	jmp    10295d <__alltraps>

00102021 <vector36>:
.globl vector36
vector36:
  pushl $0
  102021:	6a 00                	push   $0x0
  pushl $36
  102023:	6a 24                	push   $0x24
  jmp __alltraps
  102025:	e9 33 09 00 00       	jmp    10295d <__alltraps>

0010202a <vector37>:
.globl vector37
vector37:
  pushl $0
  10202a:	6a 00                	push   $0x0
  pushl $37
  10202c:	6a 25                	push   $0x25
  jmp __alltraps
  10202e:	e9 2a 09 00 00       	jmp    10295d <__alltraps>

00102033 <vector38>:
.globl vector38
vector38:
  pushl $0
  102033:	6a 00                	push   $0x0
  pushl $38
  102035:	6a 26                	push   $0x26
  jmp __alltraps
  102037:	e9 21 09 00 00       	jmp    10295d <__alltraps>

0010203c <vector39>:
.globl vector39
vector39:
  pushl $0
  10203c:	6a 00                	push   $0x0
  pushl $39
  10203e:	6a 27                	push   $0x27
  jmp __alltraps
  102040:	e9 18 09 00 00       	jmp    10295d <__alltraps>

00102045 <vector40>:
.globl vector40
vector40:
  pushl $0
  102045:	6a 00                	push   $0x0
  pushl $40
  102047:	6a 28                	push   $0x28
  jmp __alltraps
  102049:	e9 0f 09 00 00       	jmp    10295d <__alltraps>

0010204e <vector41>:
.globl vector41
vector41:
  pushl $0
  10204e:	6a 00                	push   $0x0
  pushl $41
  102050:	6a 29                	push   $0x29
  jmp __alltraps
  102052:	e9 06 09 00 00       	jmp    10295d <__alltraps>

00102057 <vector42>:
.globl vector42
vector42:
  pushl $0
  102057:	6a 00                	push   $0x0
  pushl $42
  102059:	6a 2a                	push   $0x2a
  jmp __alltraps
  10205b:	e9 fd 08 00 00       	jmp    10295d <__alltraps>

00102060 <vector43>:
.globl vector43
vector43:
  pushl $0
  102060:	6a 00                	push   $0x0
  pushl $43
  102062:	6a 2b                	push   $0x2b
  jmp __alltraps
  102064:	e9 f4 08 00 00       	jmp    10295d <__alltraps>

00102069 <vector44>:
.globl vector44
vector44:
  pushl $0
  102069:	6a 00                	push   $0x0
  pushl $44
  10206b:	6a 2c                	push   $0x2c
  jmp __alltraps
  10206d:	e9 eb 08 00 00       	jmp    10295d <__alltraps>

00102072 <vector45>:
.globl vector45
vector45:
  pushl $0
  102072:	6a 00                	push   $0x0
  pushl $45
  102074:	6a 2d                	push   $0x2d
  jmp __alltraps
  102076:	e9 e2 08 00 00       	jmp    10295d <__alltraps>

0010207b <vector46>:
.globl vector46
vector46:
  pushl $0
  10207b:	6a 00                	push   $0x0
  pushl $46
  10207d:	6a 2e                	push   $0x2e
  jmp __alltraps
  10207f:	e9 d9 08 00 00       	jmp    10295d <__alltraps>

00102084 <vector47>:
.globl vector47
vector47:
  pushl $0
  102084:	6a 00                	push   $0x0
  pushl $47
  102086:	6a 2f                	push   $0x2f
  jmp __alltraps
  102088:	e9 d0 08 00 00       	jmp    10295d <__alltraps>

0010208d <vector48>:
.globl vector48
vector48:
  pushl $0
  10208d:	6a 00                	push   $0x0
  pushl $48
  10208f:	6a 30                	push   $0x30
  jmp __alltraps
  102091:	e9 c7 08 00 00       	jmp    10295d <__alltraps>

00102096 <vector49>:
.globl vector49
vector49:
  pushl $0
  102096:	6a 00                	push   $0x0
  pushl $49
  102098:	6a 31                	push   $0x31
  jmp __alltraps
  10209a:	e9 be 08 00 00       	jmp    10295d <__alltraps>

0010209f <vector50>:
.globl vector50
vector50:
  pushl $0
  10209f:	6a 00                	push   $0x0
  pushl $50
  1020a1:	6a 32                	push   $0x32
  jmp __alltraps
  1020a3:	e9 b5 08 00 00       	jmp    10295d <__alltraps>

001020a8 <vector51>:
.globl vector51
vector51:
  pushl $0
  1020a8:	6a 00                	push   $0x0
  pushl $51
  1020aa:	6a 33                	push   $0x33
  jmp __alltraps
  1020ac:	e9 ac 08 00 00       	jmp    10295d <__alltraps>

001020b1 <vector52>:
.globl vector52
vector52:
  pushl $0
  1020b1:	6a 00                	push   $0x0
  pushl $52
  1020b3:	6a 34                	push   $0x34
  jmp __alltraps
  1020b5:	e9 a3 08 00 00       	jmp    10295d <__alltraps>

001020ba <vector53>:
.globl vector53
vector53:
  pushl $0
  1020ba:	6a 00                	push   $0x0
  pushl $53
  1020bc:	6a 35                	push   $0x35
  jmp __alltraps
  1020be:	e9 9a 08 00 00       	jmp    10295d <__alltraps>

001020c3 <vector54>:
.globl vector54
vector54:
  pushl $0
  1020c3:	6a 00                	push   $0x0
  pushl $54
  1020c5:	6a 36                	push   $0x36
  jmp __alltraps
  1020c7:	e9 91 08 00 00       	jmp    10295d <__alltraps>

001020cc <vector55>:
.globl vector55
vector55:
  pushl $0
  1020cc:	6a 00                	push   $0x0
  pushl $55
  1020ce:	6a 37                	push   $0x37
  jmp __alltraps
  1020d0:	e9 88 08 00 00       	jmp    10295d <__alltraps>

001020d5 <vector56>:
.globl vector56
vector56:
  pushl $0
  1020d5:	6a 00                	push   $0x0
  pushl $56
  1020d7:	6a 38                	push   $0x38
  jmp __alltraps
  1020d9:	e9 7f 08 00 00       	jmp    10295d <__alltraps>

001020de <vector57>:
.globl vector57
vector57:
  pushl $0
  1020de:	6a 00                	push   $0x0
  pushl $57
  1020e0:	6a 39                	push   $0x39
  jmp __alltraps
  1020e2:	e9 76 08 00 00       	jmp    10295d <__alltraps>

001020e7 <vector58>:
.globl vector58
vector58:
  pushl $0
  1020e7:	6a 00                	push   $0x0
  pushl $58
  1020e9:	6a 3a                	push   $0x3a
  jmp __alltraps
  1020eb:	e9 6d 08 00 00       	jmp    10295d <__alltraps>

001020f0 <vector59>:
.globl vector59
vector59:
  pushl $0
  1020f0:	6a 00                	push   $0x0
  pushl $59
  1020f2:	6a 3b                	push   $0x3b
  jmp __alltraps
  1020f4:	e9 64 08 00 00       	jmp    10295d <__alltraps>

001020f9 <vector60>:
.globl vector60
vector60:
  pushl $0
  1020f9:	6a 00                	push   $0x0
  pushl $60
  1020fb:	6a 3c                	push   $0x3c
  jmp __alltraps
  1020fd:	e9 5b 08 00 00       	jmp    10295d <__alltraps>

00102102 <vector61>:
.globl vector61
vector61:
  pushl $0
  102102:	6a 00                	push   $0x0
  pushl $61
  102104:	6a 3d                	push   $0x3d
  jmp __alltraps
  102106:	e9 52 08 00 00       	jmp    10295d <__alltraps>

0010210b <vector62>:
.globl vector62
vector62:
  pushl $0
  10210b:	6a 00                	push   $0x0
  pushl $62
  10210d:	6a 3e                	push   $0x3e
  jmp __alltraps
  10210f:	e9 49 08 00 00       	jmp    10295d <__alltraps>

00102114 <vector63>:
.globl vector63
vector63:
  pushl $0
  102114:	6a 00                	push   $0x0
  pushl $63
  102116:	6a 3f                	push   $0x3f
  jmp __alltraps
  102118:	e9 40 08 00 00       	jmp    10295d <__alltraps>

0010211d <vector64>:
.globl vector64
vector64:
  pushl $0
  10211d:	6a 00                	push   $0x0
  pushl $64
  10211f:	6a 40                	push   $0x40
  jmp __alltraps
  102121:	e9 37 08 00 00       	jmp    10295d <__alltraps>

00102126 <vector65>:
.globl vector65
vector65:
  pushl $0
  102126:	6a 00                	push   $0x0
  pushl $65
  102128:	6a 41                	push   $0x41
  jmp __alltraps
  10212a:	e9 2e 08 00 00       	jmp    10295d <__alltraps>

0010212f <vector66>:
.globl vector66
vector66:
  pushl $0
  10212f:	6a 00                	push   $0x0
  pushl $66
  102131:	6a 42                	push   $0x42
  jmp __alltraps
  102133:	e9 25 08 00 00       	jmp    10295d <__alltraps>

00102138 <vector67>:
.globl vector67
vector67:
  pushl $0
  102138:	6a 00                	push   $0x0
  pushl $67
  10213a:	6a 43                	push   $0x43
  jmp __alltraps
  10213c:	e9 1c 08 00 00       	jmp    10295d <__alltraps>

00102141 <vector68>:
.globl vector68
vector68:
  pushl $0
  102141:	6a 00                	push   $0x0
  pushl $68
  102143:	6a 44                	push   $0x44
  jmp __alltraps
  102145:	e9 13 08 00 00       	jmp    10295d <__alltraps>

0010214a <vector69>:
.globl vector69
vector69:
  pushl $0
  10214a:	6a 00                	push   $0x0
  pushl $69
  10214c:	6a 45                	push   $0x45
  jmp __alltraps
  10214e:	e9 0a 08 00 00       	jmp    10295d <__alltraps>

00102153 <vector70>:
.globl vector70
vector70:
  pushl $0
  102153:	6a 00                	push   $0x0
  pushl $70
  102155:	6a 46                	push   $0x46
  jmp __alltraps
  102157:	e9 01 08 00 00       	jmp    10295d <__alltraps>

0010215c <vector71>:
.globl vector71
vector71:
  pushl $0
  10215c:	6a 00                	push   $0x0
  pushl $71
  10215e:	6a 47                	push   $0x47
  jmp __alltraps
  102160:	e9 f8 07 00 00       	jmp    10295d <__alltraps>

00102165 <vector72>:
.globl vector72
vector72:
  pushl $0
  102165:	6a 00                	push   $0x0
  pushl $72
  102167:	6a 48                	push   $0x48
  jmp __alltraps
  102169:	e9 ef 07 00 00       	jmp    10295d <__alltraps>

0010216e <vector73>:
.globl vector73
vector73:
  pushl $0
  10216e:	6a 00                	push   $0x0
  pushl $73
  102170:	6a 49                	push   $0x49
  jmp __alltraps
  102172:	e9 e6 07 00 00       	jmp    10295d <__alltraps>

00102177 <vector74>:
.globl vector74
vector74:
  pushl $0
  102177:	6a 00                	push   $0x0
  pushl $74
  102179:	6a 4a                	push   $0x4a
  jmp __alltraps
  10217b:	e9 dd 07 00 00       	jmp    10295d <__alltraps>

00102180 <vector75>:
.globl vector75
vector75:
  pushl $0
  102180:	6a 00                	push   $0x0
  pushl $75
  102182:	6a 4b                	push   $0x4b
  jmp __alltraps
  102184:	e9 d4 07 00 00       	jmp    10295d <__alltraps>

00102189 <vector76>:
.globl vector76
vector76:
  pushl $0
  102189:	6a 00                	push   $0x0
  pushl $76
  10218b:	6a 4c                	push   $0x4c
  jmp __alltraps
  10218d:	e9 cb 07 00 00       	jmp    10295d <__alltraps>

00102192 <vector77>:
.globl vector77
vector77:
  pushl $0
  102192:	6a 00                	push   $0x0
  pushl $77
  102194:	6a 4d                	push   $0x4d
  jmp __alltraps
  102196:	e9 c2 07 00 00       	jmp    10295d <__alltraps>

0010219b <vector78>:
.globl vector78
vector78:
  pushl $0
  10219b:	6a 00                	push   $0x0
  pushl $78
  10219d:	6a 4e                	push   $0x4e
  jmp __alltraps
  10219f:	e9 b9 07 00 00       	jmp    10295d <__alltraps>

001021a4 <vector79>:
.globl vector79
vector79:
  pushl $0
  1021a4:	6a 00                	push   $0x0
  pushl $79
  1021a6:	6a 4f                	push   $0x4f
  jmp __alltraps
  1021a8:	e9 b0 07 00 00       	jmp    10295d <__alltraps>

001021ad <vector80>:
.globl vector80
vector80:
  pushl $0
  1021ad:	6a 00                	push   $0x0
  pushl $80
  1021af:	6a 50                	push   $0x50
  jmp __alltraps
  1021b1:	e9 a7 07 00 00       	jmp    10295d <__alltraps>

001021b6 <vector81>:
.globl vector81
vector81:
  pushl $0
  1021b6:	6a 00                	push   $0x0
  pushl $81
  1021b8:	6a 51                	push   $0x51
  jmp __alltraps
  1021ba:	e9 9e 07 00 00       	jmp    10295d <__alltraps>

001021bf <vector82>:
.globl vector82
vector82:
  pushl $0
  1021bf:	6a 00                	push   $0x0
  pushl $82
  1021c1:	6a 52                	push   $0x52
  jmp __alltraps
  1021c3:	e9 95 07 00 00       	jmp    10295d <__alltraps>

001021c8 <vector83>:
.globl vector83
vector83:
  pushl $0
  1021c8:	6a 00                	push   $0x0
  pushl $83
  1021ca:	6a 53                	push   $0x53
  jmp __alltraps
  1021cc:	e9 8c 07 00 00       	jmp    10295d <__alltraps>

001021d1 <vector84>:
.globl vector84
vector84:
  pushl $0
  1021d1:	6a 00                	push   $0x0
  pushl $84
  1021d3:	6a 54                	push   $0x54
  jmp __alltraps
  1021d5:	e9 83 07 00 00       	jmp    10295d <__alltraps>

001021da <vector85>:
.globl vector85
vector85:
  pushl $0
  1021da:	6a 00                	push   $0x0
  pushl $85
  1021dc:	6a 55                	push   $0x55
  jmp __alltraps
  1021de:	e9 7a 07 00 00       	jmp    10295d <__alltraps>

001021e3 <vector86>:
.globl vector86
vector86:
  pushl $0
  1021e3:	6a 00                	push   $0x0
  pushl $86
  1021e5:	6a 56                	push   $0x56
  jmp __alltraps
  1021e7:	e9 71 07 00 00       	jmp    10295d <__alltraps>

001021ec <vector87>:
.globl vector87
vector87:
  pushl $0
  1021ec:	6a 00                	push   $0x0
  pushl $87
  1021ee:	6a 57                	push   $0x57
  jmp __alltraps
  1021f0:	e9 68 07 00 00       	jmp    10295d <__alltraps>

001021f5 <vector88>:
.globl vector88
vector88:
  pushl $0
  1021f5:	6a 00                	push   $0x0
  pushl $88
  1021f7:	6a 58                	push   $0x58
  jmp __alltraps
  1021f9:	e9 5f 07 00 00       	jmp    10295d <__alltraps>

001021fe <vector89>:
.globl vector89
vector89:
  pushl $0
  1021fe:	6a 00                	push   $0x0
  pushl $89
  102200:	6a 59                	push   $0x59
  jmp __alltraps
  102202:	e9 56 07 00 00       	jmp    10295d <__alltraps>

00102207 <vector90>:
.globl vector90
vector90:
  pushl $0
  102207:	6a 00                	push   $0x0
  pushl $90
  102209:	6a 5a                	push   $0x5a
  jmp __alltraps
  10220b:	e9 4d 07 00 00       	jmp    10295d <__alltraps>

00102210 <vector91>:
.globl vector91
vector91:
  pushl $0
  102210:	6a 00                	push   $0x0
  pushl $91
  102212:	6a 5b                	push   $0x5b
  jmp __alltraps
  102214:	e9 44 07 00 00       	jmp    10295d <__alltraps>

00102219 <vector92>:
.globl vector92
vector92:
  pushl $0
  102219:	6a 00                	push   $0x0
  pushl $92
  10221b:	6a 5c                	push   $0x5c
  jmp __alltraps
  10221d:	e9 3b 07 00 00       	jmp    10295d <__alltraps>

00102222 <vector93>:
.globl vector93
vector93:
  pushl $0
  102222:	6a 00                	push   $0x0
  pushl $93
  102224:	6a 5d                	push   $0x5d
  jmp __alltraps
  102226:	e9 32 07 00 00       	jmp    10295d <__alltraps>

0010222b <vector94>:
.globl vector94
vector94:
  pushl $0
  10222b:	6a 00                	push   $0x0
  pushl $94
  10222d:	6a 5e                	push   $0x5e
  jmp __alltraps
  10222f:	e9 29 07 00 00       	jmp    10295d <__alltraps>

00102234 <vector95>:
.globl vector95
vector95:
  pushl $0
  102234:	6a 00                	push   $0x0
  pushl $95
  102236:	6a 5f                	push   $0x5f
  jmp __alltraps
  102238:	e9 20 07 00 00       	jmp    10295d <__alltraps>

0010223d <vector96>:
.globl vector96
vector96:
  pushl $0
  10223d:	6a 00                	push   $0x0
  pushl $96
  10223f:	6a 60                	push   $0x60
  jmp __alltraps
  102241:	e9 17 07 00 00       	jmp    10295d <__alltraps>

00102246 <vector97>:
.globl vector97
vector97:
  pushl $0
  102246:	6a 00                	push   $0x0
  pushl $97
  102248:	6a 61                	push   $0x61
  jmp __alltraps
  10224a:	e9 0e 07 00 00       	jmp    10295d <__alltraps>

0010224f <vector98>:
.globl vector98
vector98:
  pushl $0
  10224f:	6a 00                	push   $0x0
  pushl $98
  102251:	6a 62                	push   $0x62
  jmp __alltraps
  102253:	e9 05 07 00 00       	jmp    10295d <__alltraps>

00102258 <vector99>:
.globl vector99
vector99:
  pushl $0
  102258:	6a 00                	push   $0x0
  pushl $99
  10225a:	6a 63                	push   $0x63
  jmp __alltraps
  10225c:	e9 fc 06 00 00       	jmp    10295d <__alltraps>

00102261 <vector100>:
.globl vector100
vector100:
  pushl $0
  102261:	6a 00                	push   $0x0
  pushl $100
  102263:	6a 64                	push   $0x64
  jmp __alltraps
  102265:	e9 f3 06 00 00       	jmp    10295d <__alltraps>

0010226a <vector101>:
.globl vector101
vector101:
  pushl $0
  10226a:	6a 00                	push   $0x0
  pushl $101
  10226c:	6a 65                	push   $0x65
  jmp __alltraps
  10226e:	e9 ea 06 00 00       	jmp    10295d <__alltraps>

00102273 <vector102>:
.globl vector102
vector102:
  pushl $0
  102273:	6a 00                	push   $0x0
  pushl $102
  102275:	6a 66                	push   $0x66
  jmp __alltraps
  102277:	e9 e1 06 00 00       	jmp    10295d <__alltraps>

0010227c <vector103>:
.globl vector103
vector103:
  pushl $0
  10227c:	6a 00                	push   $0x0
  pushl $103
  10227e:	6a 67                	push   $0x67
  jmp __alltraps
  102280:	e9 d8 06 00 00       	jmp    10295d <__alltraps>

00102285 <vector104>:
.globl vector104
vector104:
  pushl $0
  102285:	6a 00                	push   $0x0
  pushl $104
  102287:	6a 68                	push   $0x68
  jmp __alltraps
  102289:	e9 cf 06 00 00       	jmp    10295d <__alltraps>

0010228e <vector105>:
.globl vector105
vector105:
  pushl $0
  10228e:	6a 00                	push   $0x0
  pushl $105
  102290:	6a 69                	push   $0x69
  jmp __alltraps
  102292:	e9 c6 06 00 00       	jmp    10295d <__alltraps>

00102297 <vector106>:
.globl vector106
vector106:
  pushl $0
  102297:	6a 00                	push   $0x0
  pushl $106
  102299:	6a 6a                	push   $0x6a
  jmp __alltraps
  10229b:	e9 bd 06 00 00       	jmp    10295d <__alltraps>

001022a0 <vector107>:
.globl vector107
vector107:
  pushl $0
  1022a0:	6a 00                	push   $0x0
  pushl $107
  1022a2:	6a 6b                	push   $0x6b
  jmp __alltraps
  1022a4:	e9 b4 06 00 00       	jmp    10295d <__alltraps>

001022a9 <vector108>:
.globl vector108
vector108:
  pushl $0
  1022a9:	6a 00                	push   $0x0
  pushl $108
  1022ab:	6a 6c                	push   $0x6c
  jmp __alltraps
  1022ad:	e9 ab 06 00 00       	jmp    10295d <__alltraps>

001022b2 <vector109>:
.globl vector109
vector109:
  pushl $0
  1022b2:	6a 00                	push   $0x0
  pushl $109
  1022b4:	6a 6d                	push   $0x6d
  jmp __alltraps
  1022b6:	e9 a2 06 00 00       	jmp    10295d <__alltraps>

001022bb <vector110>:
.globl vector110
vector110:
  pushl $0
  1022bb:	6a 00                	push   $0x0
  pushl $110
  1022bd:	6a 6e                	push   $0x6e
  jmp __alltraps
  1022bf:	e9 99 06 00 00       	jmp    10295d <__alltraps>

001022c4 <vector111>:
.globl vector111
vector111:
  pushl $0
  1022c4:	6a 00                	push   $0x0
  pushl $111
  1022c6:	6a 6f                	push   $0x6f
  jmp __alltraps
  1022c8:	e9 90 06 00 00       	jmp    10295d <__alltraps>

001022cd <vector112>:
.globl vector112
vector112:
  pushl $0
  1022cd:	6a 00                	push   $0x0
  pushl $112
  1022cf:	6a 70                	push   $0x70
  jmp __alltraps
  1022d1:	e9 87 06 00 00       	jmp    10295d <__alltraps>

001022d6 <vector113>:
.globl vector113
vector113:
  pushl $0
  1022d6:	6a 00                	push   $0x0
  pushl $113
  1022d8:	6a 71                	push   $0x71
  jmp __alltraps
  1022da:	e9 7e 06 00 00       	jmp    10295d <__alltraps>

001022df <vector114>:
.globl vector114
vector114:
  pushl $0
  1022df:	6a 00                	push   $0x0
  pushl $114
  1022e1:	6a 72                	push   $0x72
  jmp __alltraps
  1022e3:	e9 75 06 00 00       	jmp    10295d <__alltraps>

001022e8 <vector115>:
.globl vector115
vector115:
  pushl $0
  1022e8:	6a 00                	push   $0x0
  pushl $115
  1022ea:	6a 73                	push   $0x73
  jmp __alltraps
  1022ec:	e9 6c 06 00 00       	jmp    10295d <__alltraps>

001022f1 <vector116>:
.globl vector116
vector116:
  pushl $0
  1022f1:	6a 00                	push   $0x0
  pushl $116
  1022f3:	6a 74                	push   $0x74
  jmp __alltraps
  1022f5:	e9 63 06 00 00       	jmp    10295d <__alltraps>

001022fa <vector117>:
.globl vector117
vector117:
  pushl $0
  1022fa:	6a 00                	push   $0x0
  pushl $117
  1022fc:	6a 75                	push   $0x75
  jmp __alltraps
  1022fe:	e9 5a 06 00 00       	jmp    10295d <__alltraps>

00102303 <vector118>:
.globl vector118
vector118:
  pushl $0
  102303:	6a 00                	push   $0x0
  pushl $118
  102305:	6a 76                	push   $0x76
  jmp __alltraps
  102307:	e9 51 06 00 00       	jmp    10295d <__alltraps>

0010230c <vector119>:
.globl vector119
vector119:
  pushl $0
  10230c:	6a 00                	push   $0x0
  pushl $119
  10230e:	6a 77                	push   $0x77
  jmp __alltraps
  102310:	e9 48 06 00 00       	jmp    10295d <__alltraps>

00102315 <vector120>:
.globl vector120
vector120:
  pushl $0
  102315:	6a 00                	push   $0x0
  pushl $120
  102317:	6a 78                	push   $0x78
  jmp __alltraps
  102319:	e9 3f 06 00 00       	jmp    10295d <__alltraps>

0010231e <vector121>:
.globl vector121
vector121:
  pushl $0
  10231e:	6a 00                	push   $0x0
  pushl $121
  102320:	6a 79                	push   $0x79
  jmp __alltraps
  102322:	e9 36 06 00 00       	jmp    10295d <__alltraps>

00102327 <vector122>:
.globl vector122
vector122:
  pushl $0
  102327:	6a 00                	push   $0x0
  pushl $122
  102329:	6a 7a                	push   $0x7a
  jmp __alltraps
  10232b:	e9 2d 06 00 00       	jmp    10295d <__alltraps>

00102330 <vector123>:
.globl vector123
vector123:
  pushl $0
  102330:	6a 00                	push   $0x0
  pushl $123
  102332:	6a 7b                	push   $0x7b
  jmp __alltraps
  102334:	e9 24 06 00 00       	jmp    10295d <__alltraps>

00102339 <vector124>:
.globl vector124
vector124:
  pushl $0
  102339:	6a 00                	push   $0x0
  pushl $124
  10233b:	6a 7c                	push   $0x7c
  jmp __alltraps
  10233d:	e9 1b 06 00 00       	jmp    10295d <__alltraps>

00102342 <vector125>:
.globl vector125
vector125:
  pushl $0
  102342:	6a 00                	push   $0x0
  pushl $125
  102344:	6a 7d                	push   $0x7d
  jmp __alltraps
  102346:	e9 12 06 00 00       	jmp    10295d <__alltraps>

0010234b <vector126>:
.globl vector126
vector126:
  pushl $0
  10234b:	6a 00                	push   $0x0
  pushl $126
  10234d:	6a 7e                	push   $0x7e
  jmp __alltraps
  10234f:	e9 09 06 00 00       	jmp    10295d <__alltraps>

00102354 <vector127>:
.globl vector127
vector127:
  pushl $0
  102354:	6a 00                	push   $0x0
  pushl $127
  102356:	6a 7f                	push   $0x7f
  jmp __alltraps
  102358:	e9 00 06 00 00       	jmp    10295d <__alltraps>

0010235d <vector128>:
.globl vector128
vector128:
  pushl $0
  10235d:	6a 00                	push   $0x0
  pushl $128
  10235f:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102364:	e9 f4 05 00 00       	jmp    10295d <__alltraps>

00102369 <vector129>:
.globl vector129
vector129:
  pushl $0
  102369:	6a 00                	push   $0x0
  pushl $129
  10236b:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102370:	e9 e8 05 00 00       	jmp    10295d <__alltraps>

00102375 <vector130>:
.globl vector130
vector130:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $130
  102377:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10237c:	e9 dc 05 00 00       	jmp    10295d <__alltraps>

00102381 <vector131>:
.globl vector131
vector131:
  pushl $0
  102381:	6a 00                	push   $0x0
  pushl $131
  102383:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102388:	e9 d0 05 00 00       	jmp    10295d <__alltraps>

0010238d <vector132>:
.globl vector132
vector132:
  pushl $0
  10238d:	6a 00                	push   $0x0
  pushl $132
  10238f:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102394:	e9 c4 05 00 00       	jmp    10295d <__alltraps>

00102399 <vector133>:
.globl vector133
vector133:
  pushl $0
  102399:	6a 00                	push   $0x0
  pushl $133
  10239b:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1023a0:	e9 b8 05 00 00       	jmp    10295d <__alltraps>

001023a5 <vector134>:
.globl vector134
vector134:
  pushl $0
  1023a5:	6a 00                	push   $0x0
  pushl $134
  1023a7:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1023ac:	e9 ac 05 00 00       	jmp    10295d <__alltraps>

001023b1 <vector135>:
.globl vector135
vector135:
  pushl $0
  1023b1:	6a 00                	push   $0x0
  pushl $135
  1023b3:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1023b8:	e9 a0 05 00 00       	jmp    10295d <__alltraps>

001023bd <vector136>:
.globl vector136
vector136:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $136
  1023bf:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1023c4:	e9 94 05 00 00       	jmp    10295d <__alltraps>

001023c9 <vector137>:
.globl vector137
vector137:
  pushl $0
  1023c9:	6a 00                	push   $0x0
  pushl $137
  1023cb:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1023d0:	e9 88 05 00 00       	jmp    10295d <__alltraps>

001023d5 <vector138>:
.globl vector138
vector138:
  pushl $0
  1023d5:	6a 00                	push   $0x0
  pushl $138
  1023d7:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1023dc:	e9 7c 05 00 00       	jmp    10295d <__alltraps>

001023e1 <vector139>:
.globl vector139
vector139:
  pushl $0
  1023e1:	6a 00                	push   $0x0
  pushl $139
  1023e3:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1023e8:	e9 70 05 00 00       	jmp    10295d <__alltraps>

001023ed <vector140>:
.globl vector140
vector140:
  pushl $0
  1023ed:	6a 00                	push   $0x0
  pushl $140
  1023ef:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1023f4:	e9 64 05 00 00       	jmp    10295d <__alltraps>

001023f9 <vector141>:
.globl vector141
vector141:
  pushl $0
  1023f9:	6a 00                	push   $0x0
  pushl $141
  1023fb:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102400:	e9 58 05 00 00       	jmp    10295d <__alltraps>

00102405 <vector142>:
.globl vector142
vector142:
  pushl $0
  102405:	6a 00                	push   $0x0
  pushl $142
  102407:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10240c:	e9 4c 05 00 00       	jmp    10295d <__alltraps>

00102411 <vector143>:
.globl vector143
vector143:
  pushl $0
  102411:	6a 00                	push   $0x0
  pushl $143
  102413:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102418:	e9 40 05 00 00       	jmp    10295d <__alltraps>

0010241d <vector144>:
.globl vector144
vector144:
  pushl $0
  10241d:	6a 00                	push   $0x0
  pushl $144
  10241f:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102424:	e9 34 05 00 00       	jmp    10295d <__alltraps>

00102429 <vector145>:
.globl vector145
vector145:
  pushl $0
  102429:	6a 00                	push   $0x0
  pushl $145
  10242b:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102430:	e9 28 05 00 00       	jmp    10295d <__alltraps>

00102435 <vector146>:
.globl vector146
vector146:
  pushl $0
  102435:	6a 00                	push   $0x0
  pushl $146
  102437:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10243c:	e9 1c 05 00 00       	jmp    10295d <__alltraps>

00102441 <vector147>:
.globl vector147
vector147:
  pushl $0
  102441:	6a 00                	push   $0x0
  pushl $147
  102443:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102448:	e9 10 05 00 00       	jmp    10295d <__alltraps>

0010244d <vector148>:
.globl vector148
vector148:
  pushl $0
  10244d:	6a 00                	push   $0x0
  pushl $148
  10244f:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102454:	e9 04 05 00 00       	jmp    10295d <__alltraps>

00102459 <vector149>:
.globl vector149
vector149:
  pushl $0
  102459:	6a 00                	push   $0x0
  pushl $149
  10245b:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102460:	e9 f8 04 00 00       	jmp    10295d <__alltraps>

00102465 <vector150>:
.globl vector150
vector150:
  pushl $0
  102465:	6a 00                	push   $0x0
  pushl $150
  102467:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10246c:	e9 ec 04 00 00       	jmp    10295d <__alltraps>

00102471 <vector151>:
.globl vector151
vector151:
  pushl $0
  102471:	6a 00                	push   $0x0
  pushl $151
  102473:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102478:	e9 e0 04 00 00       	jmp    10295d <__alltraps>

0010247d <vector152>:
.globl vector152
vector152:
  pushl $0
  10247d:	6a 00                	push   $0x0
  pushl $152
  10247f:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102484:	e9 d4 04 00 00       	jmp    10295d <__alltraps>

00102489 <vector153>:
.globl vector153
vector153:
  pushl $0
  102489:	6a 00                	push   $0x0
  pushl $153
  10248b:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102490:	e9 c8 04 00 00       	jmp    10295d <__alltraps>

00102495 <vector154>:
.globl vector154
vector154:
  pushl $0
  102495:	6a 00                	push   $0x0
  pushl $154
  102497:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10249c:	e9 bc 04 00 00       	jmp    10295d <__alltraps>

001024a1 <vector155>:
.globl vector155
vector155:
  pushl $0
  1024a1:	6a 00                	push   $0x0
  pushl $155
  1024a3:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1024a8:	e9 b0 04 00 00       	jmp    10295d <__alltraps>

001024ad <vector156>:
.globl vector156
vector156:
  pushl $0
  1024ad:	6a 00                	push   $0x0
  pushl $156
  1024af:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1024b4:	e9 a4 04 00 00       	jmp    10295d <__alltraps>

001024b9 <vector157>:
.globl vector157
vector157:
  pushl $0
  1024b9:	6a 00                	push   $0x0
  pushl $157
  1024bb:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1024c0:	e9 98 04 00 00       	jmp    10295d <__alltraps>

001024c5 <vector158>:
.globl vector158
vector158:
  pushl $0
  1024c5:	6a 00                	push   $0x0
  pushl $158
  1024c7:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1024cc:	e9 8c 04 00 00       	jmp    10295d <__alltraps>

001024d1 <vector159>:
.globl vector159
vector159:
  pushl $0
  1024d1:	6a 00                	push   $0x0
  pushl $159
  1024d3:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1024d8:	e9 80 04 00 00       	jmp    10295d <__alltraps>

001024dd <vector160>:
.globl vector160
vector160:
  pushl $0
  1024dd:	6a 00                	push   $0x0
  pushl $160
  1024df:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1024e4:	e9 74 04 00 00       	jmp    10295d <__alltraps>

001024e9 <vector161>:
.globl vector161
vector161:
  pushl $0
  1024e9:	6a 00                	push   $0x0
  pushl $161
  1024eb:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1024f0:	e9 68 04 00 00       	jmp    10295d <__alltraps>

001024f5 <vector162>:
.globl vector162
vector162:
  pushl $0
  1024f5:	6a 00                	push   $0x0
  pushl $162
  1024f7:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1024fc:	e9 5c 04 00 00       	jmp    10295d <__alltraps>

00102501 <vector163>:
.globl vector163
vector163:
  pushl $0
  102501:	6a 00                	push   $0x0
  pushl $163
  102503:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102508:	e9 50 04 00 00       	jmp    10295d <__alltraps>

0010250d <vector164>:
.globl vector164
vector164:
  pushl $0
  10250d:	6a 00                	push   $0x0
  pushl $164
  10250f:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102514:	e9 44 04 00 00       	jmp    10295d <__alltraps>

00102519 <vector165>:
.globl vector165
vector165:
  pushl $0
  102519:	6a 00                	push   $0x0
  pushl $165
  10251b:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102520:	e9 38 04 00 00       	jmp    10295d <__alltraps>

00102525 <vector166>:
.globl vector166
vector166:
  pushl $0
  102525:	6a 00                	push   $0x0
  pushl $166
  102527:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10252c:	e9 2c 04 00 00       	jmp    10295d <__alltraps>

00102531 <vector167>:
.globl vector167
vector167:
  pushl $0
  102531:	6a 00                	push   $0x0
  pushl $167
  102533:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102538:	e9 20 04 00 00       	jmp    10295d <__alltraps>

0010253d <vector168>:
.globl vector168
vector168:
  pushl $0
  10253d:	6a 00                	push   $0x0
  pushl $168
  10253f:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102544:	e9 14 04 00 00       	jmp    10295d <__alltraps>

00102549 <vector169>:
.globl vector169
vector169:
  pushl $0
  102549:	6a 00                	push   $0x0
  pushl $169
  10254b:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102550:	e9 08 04 00 00       	jmp    10295d <__alltraps>

00102555 <vector170>:
.globl vector170
vector170:
  pushl $0
  102555:	6a 00                	push   $0x0
  pushl $170
  102557:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10255c:	e9 fc 03 00 00       	jmp    10295d <__alltraps>

00102561 <vector171>:
.globl vector171
vector171:
  pushl $0
  102561:	6a 00                	push   $0x0
  pushl $171
  102563:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102568:	e9 f0 03 00 00       	jmp    10295d <__alltraps>

0010256d <vector172>:
.globl vector172
vector172:
  pushl $0
  10256d:	6a 00                	push   $0x0
  pushl $172
  10256f:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102574:	e9 e4 03 00 00       	jmp    10295d <__alltraps>

00102579 <vector173>:
.globl vector173
vector173:
  pushl $0
  102579:	6a 00                	push   $0x0
  pushl $173
  10257b:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102580:	e9 d8 03 00 00       	jmp    10295d <__alltraps>

00102585 <vector174>:
.globl vector174
vector174:
  pushl $0
  102585:	6a 00                	push   $0x0
  pushl $174
  102587:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10258c:	e9 cc 03 00 00       	jmp    10295d <__alltraps>

00102591 <vector175>:
.globl vector175
vector175:
  pushl $0
  102591:	6a 00                	push   $0x0
  pushl $175
  102593:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102598:	e9 c0 03 00 00       	jmp    10295d <__alltraps>

0010259d <vector176>:
.globl vector176
vector176:
  pushl $0
  10259d:	6a 00                	push   $0x0
  pushl $176
  10259f:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1025a4:	e9 b4 03 00 00       	jmp    10295d <__alltraps>

001025a9 <vector177>:
.globl vector177
vector177:
  pushl $0
  1025a9:	6a 00                	push   $0x0
  pushl $177
  1025ab:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1025b0:	e9 a8 03 00 00       	jmp    10295d <__alltraps>

001025b5 <vector178>:
.globl vector178
vector178:
  pushl $0
  1025b5:	6a 00                	push   $0x0
  pushl $178
  1025b7:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1025bc:	e9 9c 03 00 00       	jmp    10295d <__alltraps>

001025c1 <vector179>:
.globl vector179
vector179:
  pushl $0
  1025c1:	6a 00                	push   $0x0
  pushl $179
  1025c3:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1025c8:	e9 90 03 00 00       	jmp    10295d <__alltraps>

001025cd <vector180>:
.globl vector180
vector180:
  pushl $0
  1025cd:	6a 00                	push   $0x0
  pushl $180
  1025cf:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1025d4:	e9 84 03 00 00       	jmp    10295d <__alltraps>

001025d9 <vector181>:
.globl vector181
vector181:
  pushl $0
  1025d9:	6a 00                	push   $0x0
  pushl $181
  1025db:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1025e0:	e9 78 03 00 00       	jmp    10295d <__alltraps>

001025e5 <vector182>:
.globl vector182
vector182:
  pushl $0
  1025e5:	6a 00                	push   $0x0
  pushl $182
  1025e7:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1025ec:	e9 6c 03 00 00       	jmp    10295d <__alltraps>

001025f1 <vector183>:
.globl vector183
vector183:
  pushl $0
  1025f1:	6a 00                	push   $0x0
  pushl $183
  1025f3:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1025f8:	e9 60 03 00 00       	jmp    10295d <__alltraps>

001025fd <vector184>:
.globl vector184
vector184:
  pushl $0
  1025fd:	6a 00                	push   $0x0
  pushl $184
  1025ff:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102604:	e9 54 03 00 00       	jmp    10295d <__alltraps>

00102609 <vector185>:
.globl vector185
vector185:
  pushl $0
  102609:	6a 00                	push   $0x0
  pushl $185
  10260b:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102610:	e9 48 03 00 00       	jmp    10295d <__alltraps>

00102615 <vector186>:
.globl vector186
vector186:
  pushl $0
  102615:	6a 00                	push   $0x0
  pushl $186
  102617:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10261c:	e9 3c 03 00 00       	jmp    10295d <__alltraps>

00102621 <vector187>:
.globl vector187
vector187:
  pushl $0
  102621:	6a 00                	push   $0x0
  pushl $187
  102623:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102628:	e9 30 03 00 00       	jmp    10295d <__alltraps>

0010262d <vector188>:
.globl vector188
vector188:
  pushl $0
  10262d:	6a 00                	push   $0x0
  pushl $188
  10262f:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102634:	e9 24 03 00 00       	jmp    10295d <__alltraps>

00102639 <vector189>:
.globl vector189
vector189:
  pushl $0
  102639:	6a 00                	push   $0x0
  pushl $189
  10263b:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102640:	e9 18 03 00 00       	jmp    10295d <__alltraps>

00102645 <vector190>:
.globl vector190
vector190:
  pushl $0
  102645:	6a 00                	push   $0x0
  pushl $190
  102647:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10264c:	e9 0c 03 00 00       	jmp    10295d <__alltraps>

00102651 <vector191>:
.globl vector191
vector191:
  pushl $0
  102651:	6a 00                	push   $0x0
  pushl $191
  102653:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102658:	e9 00 03 00 00       	jmp    10295d <__alltraps>

0010265d <vector192>:
.globl vector192
vector192:
  pushl $0
  10265d:	6a 00                	push   $0x0
  pushl $192
  10265f:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102664:	e9 f4 02 00 00       	jmp    10295d <__alltraps>

00102669 <vector193>:
.globl vector193
vector193:
  pushl $0
  102669:	6a 00                	push   $0x0
  pushl $193
  10266b:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102670:	e9 e8 02 00 00       	jmp    10295d <__alltraps>

00102675 <vector194>:
.globl vector194
vector194:
  pushl $0
  102675:	6a 00                	push   $0x0
  pushl $194
  102677:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10267c:	e9 dc 02 00 00       	jmp    10295d <__alltraps>

00102681 <vector195>:
.globl vector195
vector195:
  pushl $0
  102681:	6a 00                	push   $0x0
  pushl $195
  102683:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102688:	e9 d0 02 00 00       	jmp    10295d <__alltraps>

0010268d <vector196>:
.globl vector196
vector196:
  pushl $0
  10268d:	6a 00                	push   $0x0
  pushl $196
  10268f:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102694:	e9 c4 02 00 00       	jmp    10295d <__alltraps>

00102699 <vector197>:
.globl vector197
vector197:
  pushl $0
  102699:	6a 00                	push   $0x0
  pushl $197
  10269b:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1026a0:	e9 b8 02 00 00       	jmp    10295d <__alltraps>

001026a5 <vector198>:
.globl vector198
vector198:
  pushl $0
  1026a5:	6a 00                	push   $0x0
  pushl $198
  1026a7:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1026ac:	e9 ac 02 00 00       	jmp    10295d <__alltraps>

001026b1 <vector199>:
.globl vector199
vector199:
  pushl $0
  1026b1:	6a 00                	push   $0x0
  pushl $199
  1026b3:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1026b8:	e9 a0 02 00 00       	jmp    10295d <__alltraps>

001026bd <vector200>:
.globl vector200
vector200:
  pushl $0
  1026bd:	6a 00                	push   $0x0
  pushl $200
  1026bf:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1026c4:	e9 94 02 00 00       	jmp    10295d <__alltraps>

001026c9 <vector201>:
.globl vector201
vector201:
  pushl $0
  1026c9:	6a 00                	push   $0x0
  pushl $201
  1026cb:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1026d0:	e9 88 02 00 00       	jmp    10295d <__alltraps>

001026d5 <vector202>:
.globl vector202
vector202:
  pushl $0
  1026d5:	6a 00                	push   $0x0
  pushl $202
  1026d7:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1026dc:	e9 7c 02 00 00       	jmp    10295d <__alltraps>

001026e1 <vector203>:
.globl vector203
vector203:
  pushl $0
  1026e1:	6a 00                	push   $0x0
  pushl $203
  1026e3:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1026e8:	e9 70 02 00 00       	jmp    10295d <__alltraps>

001026ed <vector204>:
.globl vector204
vector204:
  pushl $0
  1026ed:	6a 00                	push   $0x0
  pushl $204
  1026ef:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1026f4:	e9 64 02 00 00       	jmp    10295d <__alltraps>

001026f9 <vector205>:
.globl vector205
vector205:
  pushl $0
  1026f9:	6a 00                	push   $0x0
  pushl $205
  1026fb:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102700:	e9 58 02 00 00       	jmp    10295d <__alltraps>

00102705 <vector206>:
.globl vector206
vector206:
  pushl $0
  102705:	6a 00                	push   $0x0
  pushl $206
  102707:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10270c:	e9 4c 02 00 00       	jmp    10295d <__alltraps>

00102711 <vector207>:
.globl vector207
vector207:
  pushl $0
  102711:	6a 00                	push   $0x0
  pushl $207
  102713:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102718:	e9 40 02 00 00       	jmp    10295d <__alltraps>

0010271d <vector208>:
.globl vector208
vector208:
  pushl $0
  10271d:	6a 00                	push   $0x0
  pushl $208
  10271f:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102724:	e9 34 02 00 00       	jmp    10295d <__alltraps>

00102729 <vector209>:
.globl vector209
vector209:
  pushl $0
  102729:	6a 00                	push   $0x0
  pushl $209
  10272b:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102730:	e9 28 02 00 00       	jmp    10295d <__alltraps>

00102735 <vector210>:
.globl vector210
vector210:
  pushl $0
  102735:	6a 00                	push   $0x0
  pushl $210
  102737:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10273c:	e9 1c 02 00 00       	jmp    10295d <__alltraps>

00102741 <vector211>:
.globl vector211
vector211:
  pushl $0
  102741:	6a 00                	push   $0x0
  pushl $211
  102743:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102748:	e9 10 02 00 00       	jmp    10295d <__alltraps>

0010274d <vector212>:
.globl vector212
vector212:
  pushl $0
  10274d:	6a 00                	push   $0x0
  pushl $212
  10274f:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102754:	e9 04 02 00 00       	jmp    10295d <__alltraps>

00102759 <vector213>:
.globl vector213
vector213:
  pushl $0
  102759:	6a 00                	push   $0x0
  pushl $213
  10275b:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102760:	e9 f8 01 00 00       	jmp    10295d <__alltraps>

00102765 <vector214>:
.globl vector214
vector214:
  pushl $0
  102765:	6a 00                	push   $0x0
  pushl $214
  102767:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10276c:	e9 ec 01 00 00       	jmp    10295d <__alltraps>

00102771 <vector215>:
.globl vector215
vector215:
  pushl $0
  102771:	6a 00                	push   $0x0
  pushl $215
  102773:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102778:	e9 e0 01 00 00       	jmp    10295d <__alltraps>

0010277d <vector216>:
.globl vector216
vector216:
  pushl $0
  10277d:	6a 00                	push   $0x0
  pushl $216
  10277f:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102784:	e9 d4 01 00 00       	jmp    10295d <__alltraps>

00102789 <vector217>:
.globl vector217
vector217:
  pushl $0
  102789:	6a 00                	push   $0x0
  pushl $217
  10278b:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102790:	e9 c8 01 00 00       	jmp    10295d <__alltraps>

00102795 <vector218>:
.globl vector218
vector218:
  pushl $0
  102795:	6a 00                	push   $0x0
  pushl $218
  102797:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10279c:	e9 bc 01 00 00       	jmp    10295d <__alltraps>

001027a1 <vector219>:
.globl vector219
vector219:
  pushl $0
  1027a1:	6a 00                	push   $0x0
  pushl $219
  1027a3:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1027a8:	e9 b0 01 00 00       	jmp    10295d <__alltraps>

001027ad <vector220>:
.globl vector220
vector220:
  pushl $0
  1027ad:	6a 00                	push   $0x0
  pushl $220
  1027af:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1027b4:	e9 a4 01 00 00       	jmp    10295d <__alltraps>

001027b9 <vector221>:
.globl vector221
vector221:
  pushl $0
  1027b9:	6a 00                	push   $0x0
  pushl $221
  1027bb:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1027c0:	e9 98 01 00 00       	jmp    10295d <__alltraps>

001027c5 <vector222>:
.globl vector222
vector222:
  pushl $0
  1027c5:	6a 00                	push   $0x0
  pushl $222
  1027c7:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1027cc:	e9 8c 01 00 00       	jmp    10295d <__alltraps>

001027d1 <vector223>:
.globl vector223
vector223:
  pushl $0
  1027d1:	6a 00                	push   $0x0
  pushl $223
  1027d3:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1027d8:	e9 80 01 00 00       	jmp    10295d <__alltraps>

001027dd <vector224>:
.globl vector224
vector224:
  pushl $0
  1027dd:	6a 00                	push   $0x0
  pushl $224
  1027df:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1027e4:	e9 74 01 00 00       	jmp    10295d <__alltraps>

001027e9 <vector225>:
.globl vector225
vector225:
  pushl $0
  1027e9:	6a 00                	push   $0x0
  pushl $225
  1027eb:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1027f0:	e9 68 01 00 00       	jmp    10295d <__alltraps>

001027f5 <vector226>:
.globl vector226
vector226:
  pushl $0
  1027f5:	6a 00                	push   $0x0
  pushl $226
  1027f7:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1027fc:	e9 5c 01 00 00       	jmp    10295d <__alltraps>

00102801 <vector227>:
.globl vector227
vector227:
  pushl $0
  102801:	6a 00                	push   $0x0
  pushl $227
  102803:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102808:	e9 50 01 00 00       	jmp    10295d <__alltraps>

0010280d <vector228>:
.globl vector228
vector228:
  pushl $0
  10280d:	6a 00                	push   $0x0
  pushl $228
  10280f:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102814:	e9 44 01 00 00       	jmp    10295d <__alltraps>

00102819 <vector229>:
.globl vector229
vector229:
  pushl $0
  102819:	6a 00                	push   $0x0
  pushl $229
  10281b:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102820:	e9 38 01 00 00       	jmp    10295d <__alltraps>

00102825 <vector230>:
.globl vector230
vector230:
  pushl $0
  102825:	6a 00                	push   $0x0
  pushl $230
  102827:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10282c:	e9 2c 01 00 00       	jmp    10295d <__alltraps>

00102831 <vector231>:
.globl vector231
vector231:
  pushl $0
  102831:	6a 00                	push   $0x0
  pushl $231
  102833:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102838:	e9 20 01 00 00       	jmp    10295d <__alltraps>

0010283d <vector232>:
.globl vector232
vector232:
  pushl $0
  10283d:	6a 00                	push   $0x0
  pushl $232
  10283f:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102844:	e9 14 01 00 00       	jmp    10295d <__alltraps>

00102849 <vector233>:
.globl vector233
vector233:
  pushl $0
  102849:	6a 00                	push   $0x0
  pushl $233
  10284b:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102850:	e9 08 01 00 00       	jmp    10295d <__alltraps>

00102855 <vector234>:
.globl vector234
vector234:
  pushl $0
  102855:	6a 00                	push   $0x0
  pushl $234
  102857:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10285c:	e9 fc 00 00 00       	jmp    10295d <__alltraps>

00102861 <vector235>:
.globl vector235
vector235:
  pushl $0
  102861:	6a 00                	push   $0x0
  pushl $235
  102863:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102868:	e9 f0 00 00 00       	jmp    10295d <__alltraps>

0010286d <vector236>:
.globl vector236
vector236:
  pushl $0
  10286d:	6a 00                	push   $0x0
  pushl $236
  10286f:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102874:	e9 e4 00 00 00       	jmp    10295d <__alltraps>

00102879 <vector237>:
.globl vector237
vector237:
  pushl $0
  102879:	6a 00                	push   $0x0
  pushl $237
  10287b:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102880:	e9 d8 00 00 00       	jmp    10295d <__alltraps>

00102885 <vector238>:
.globl vector238
vector238:
  pushl $0
  102885:	6a 00                	push   $0x0
  pushl $238
  102887:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10288c:	e9 cc 00 00 00       	jmp    10295d <__alltraps>

00102891 <vector239>:
.globl vector239
vector239:
  pushl $0
  102891:	6a 00                	push   $0x0
  pushl $239
  102893:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102898:	e9 c0 00 00 00       	jmp    10295d <__alltraps>

0010289d <vector240>:
.globl vector240
vector240:
  pushl $0
  10289d:	6a 00                	push   $0x0
  pushl $240
  10289f:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1028a4:	e9 b4 00 00 00       	jmp    10295d <__alltraps>

001028a9 <vector241>:
.globl vector241
vector241:
  pushl $0
  1028a9:	6a 00                	push   $0x0
  pushl $241
  1028ab:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1028b0:	e9 a8 00 00 00       	jmp    10295d <__alltraps>

001028b5 <vector242>:
.globl vector242
vector242:
  pushl $0
  1028b5:	6a 00                	push   $0x0
  pushl $242
  1028b7:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1028bc:	e9 9c 00 00 00       	jmp    10295d <__alltraps>

001028c1 <vector243>:
.globl vector243
vector243:
  pushl $0
  1028c1:	6a 00                	push   $0x0
  pushl $243
  1028c3:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1028c8:	e9 90 00 00 00       	jmp    10295d <__alltraps>

001028cd <vector244>:
.globl vector244
vector244:
  pushl $0
  1028cd:	6a 00                	push   $0x0
  pushl $244
  1028cf:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1028d4:	e9 84 00 00 00       	jmp    10295d <__alltraps>

001028d9 <vector245>:
.globl vector245
vector245:
  pushl $0
  1028d9:	6a 00                	push   $0x0
  pushl $245
  1028db:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1028e0:	e9 78 00 00 00       	jmp    10295d <__alltraps>

001028e5 <vector246>:
.globl vector246
vector246:
  pushl $0
  1028e5:	6a 00                	push   $0x0
  pushl $246
  1028e7:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1028ec:	e9 6c 00 00 00       	jmp    10295d <__alltraps>

001028f1 <vector247>:
.globl vector247
vector247:
  pushl $0
  1028f1:	6a 00                	push   $0x0
  pushl $247
  1028f3:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1028f8:	e9 60 00 00 00       	jmp    10295d <__alltraps>

001028fd <vector248>:
.globl vector248
vector248:
  pushl $0
  1028fd:	6a 00                	push   $0x0
  pushl $248
  1028ff:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102904:	e9 54 00 00 00       	jmp    10295d <__alltraps>

00102909 <vector249>:
.globl vector249
vector249:
  pushl $0
  102909:	6a 00                	push   $0x0
  pushl $249
  10290b:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102910:	e9 48 00 00 00       	jmp    10295d <__alltraps>

00102915 <vector250>:
.globl vector250
vector250:
  pushl $0
  102915:	6a 00                	push   $0x0
  pushl $250
  102917:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10291c:	e9 3c 00 00 00       	jmp    10295d <__alltraps>

00102921 <vector251>:
.globl vector251
vector251:
  pushl $0
  102921:	6a 00                	push   $0x0
  pushl $251
  102923:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102928:	e9 30 00 00 00       	jmp    10295d <__alltraps>

0010292d <vector252>:
.globl vector252
vector252:
  pushl $0
  10292d:	6a 00                	push   $0x0
  pushl $252
  10292f:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102934:	e9 24 00 00 00       	jmp    10295d <__alltraps>

00102939 <vector253>:
.globl vector253
vector253:
  pushl $0
  102939:	6a 00                	push   $0x0
  pushl $253
  10293b:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102940:	e9 18 00 00 00       	jmp    10295d <__alltraps>

00102945 <vector254>:
.globl vector254
vector254:
  pushl $0
  102945:	6a 00                	push   $0x0
  pushl $254
  102947:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10294c:	e9 0c 00 00 00       	jmp    10295d <__alltraps>

00102951 <vector255>:
.globl vector255
vector255:
  pushl $0
  102951:	6a 00                	push   $0x0
  pushl $255
  102953:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102958:	e9 00 00 00 00       	jmp    10295d <__alltraps>

0010295d <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  10295d:	1e                   	push   %ds
    pushl %es
  10295e:	06                   	push   %es
    pushl %fs
  10295f:	0f a0                	push   %fs
    pushl %gs
  102961:	0f a8                	push   %gs
    pushal
  102963:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102964:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102969:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10296b:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  10296d:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  10296e:	e8 64 f5 ff ff       	call   101ed7 <trap>

    # pop the pushed stack pointer
    popl %esp
  102973:	5c                   	pop    %esp

00102974 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102974:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102975:	0f a9                	pop    %gs
    popl %fs
  102977:	0f a1                	pop    %fs
    popl %es
  102979:	07                   	pop    %es
    popl %ds
  10297a:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  10297b:	83 c4 08             	add    $0x8,%esp
    iret
  10297e:	cf                   	iret   

0010297f <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  10297f:	55                   	push   %ebp
  102980:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102982:	8b 45 08             	mov    0x8(%ebp),%eax
  102985:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102988:	b8 23 00 00 00       	mov    $0x23,%eax
  10298d:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  10298f:	b8 23 00 00 00       	mov    $0x23,%eax
  102994:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102996:	b8 10 00 00 00       	mov    $0x10,%eax
  10299b:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  10299d:	b8 10 00 00 00       	mov    $0x10,%eax
  1029a2:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  1029a4:	b8 10 00 00 00       	mov    $0x10,%eax
  1029a9:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1029ab:	ea b2 29 10 00 08 00 	ljmp   $0x8,$0x1029b2
}
  1029b2:	90                   	nop
  1029b3:	5d                   	pop    %ebp
  1029b4:	c3                   	ret    

001029b5 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1029b5:	55                   	push   %ebp
  1029b6:	89 e5                	mov    %esp,%ebp
  1029b8:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  1029bb:	b8 80 f9 10 00       	mov    $0x10f980,%eax
  1029c0:	05 00 04 00 00       	add    $0x400,%eax
  1029c5:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  1029ca:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  1029d1:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1029d3:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  1029da:	68 00 
  1029dc:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029e1:	0f b7 c0             	movzwl %ax,%eax
  1029e4:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  1029ea:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029ef:	c1 e8 10             	shr    $0x10,%eax
  1029f2:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1029f7:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029fe:	24 f0                	and    $0xf0,%al
  102a00:	0c 09                	or     $0x9,%al
  102a02:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a07:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a0e:	0c 10                	or     $0x10,%al
  102a10:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a15:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a1c:	24 9f                	and    $0x9f,%al
  102a1e:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a23:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a2a:	0c 80                	or     $0x80,%al
  102a2c:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a31:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a38:	24 f0                	and    $0xf0,%al
  102a3a:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a3f:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a46:	24 ef                	and    $0xef,%al
  102a48:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a4d:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a54:	24 df                	and    $0xdf,%al
  102a56:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a5b:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a62:	0c 40                	or     $0x40,%al
  102a64:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a69:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a70:	24 7f                	and    $0x7f,%al
  102a72:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a77:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102a7c:	c1 e8 18             	shr    $0x18,%eax
  102a7f:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102a84:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a8b:	24 ef                	and    $0xef,%al
  102a8d:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102a92:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  102a99:	e8 e1 fe ff ff       	call   10297f <lgdt>
  102a9e:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102aa4:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102aa8:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102aab:	90                   	nop
  102aac:	c9                   	leave  
  102aad:	c3                   	ret    

00102aae <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102aae:	55                   	push   %ebp
  102aaf:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102ab1:	e8 ff fe ff ff       	call   1029b5 <gdt_init>
}
  102ab6:	90                   	nop
  102ab7:	5d                   	pop    %ebp
  102ab8:	c3                   	ret    

00102ab9 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102ab9:	55                   	push   %ebp
  102aba:	89 e5                	mov    %esp,%ebp
  102abc:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102abf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102ac6:	eb 03                	jmp    102acb <strlen+0x12>
        cnt ++;
  102ac8:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  102acb:	8b 45 08             	mov    0x8(%ebp),%eax
  102ace:	8d 50 01             	lea    0x1(%eax),%edx
  102ad1:	89 55 08             	mov    %edx,0x8(%ebp)
  102ad4:	0f b6 00             	movzbl (%eax),%eax
  102ad7:	84 c0                	test   %al,%al
  102ad9:	75 ed                	jne    102ac8 <strlen+0xf>
    }
    return cnt;
  102adb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102ade:	c9                   	leave  
  102adf:	c3                   	ret    

00102ae0 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102ae0:	55                   	push   %ebp
  102ae1:	89 e5                	mov    %esp,%ebp
  102ae3:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102ae6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102aed:	eb 03                	jmp    102af2 <strnlen+0x12>
        cnt ++;
  102aef:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102af2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102af5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102af8:	73 10                	jae    102b0a <strnlen+0x2a>
  102afa:	8b 45 08             	mov    0x8(%ebp),%eax
  102afd:	8d 50 01             	lea    0x1(%eax),%edx
  102b00:	89 55 08             	mov    %edx,0x8(%ebp)
  102b03:	0f b6 00             	movzbl (%eax),%eax
  102b06:	84 c0                	test   %al,%al
  102b08:	75 e5                	jne    102aef <strnlen+0xf>
    }
    return cnt;
  102b0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102b0d:	c9                   	leave  
  102b0e:	c3                   	ret    

00102b0f <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102b0f:	55                   	push   %ebp
  102b10:	89 e5                	mov    %esp,%ebp
  102b12:	57                   	push   %edi
  102b13:	56                   	push   %esi
  102b14:	83 ec 20             	sub    $0x20,%esp
  102b17:	8b 45 08             	mov    0x8(%ebp),%eax
  102b1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b20:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102b23:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b29:	89 d1                	mov    %edx,%ecx
  102b2b:	89 c2                	mov    %eax,%edx
  102b2d:	89 ce                	mov    %ecx,%esi
  102b2f:	89 d7                	mov    %edx,%edi
  102b31:	ac                   	lods   %ds:(%esi),%al
  102b32:	aa                   	stos   %al,%es:(%edi)
  102b33:	84 c0                	test   %al,%al
  102b35:	75 fa                	jne    102b31 <strcpy+0x22>
  102b37:	89 fa                	mov    %edi,%edx
  102b39:	89 f1                	mov    %esi,%ecx
  102b3b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102b3e:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102b41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102b47:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102b48:	83 c4 20             	add    $0x20,%esp
  102b4b:	5e                   	pop    %esi
  102b4c:	5f                   	pop    %edi
  102b4d:	5d                   	pop    %ebp
  102b4e:	c3                   	ret    

00102b4f <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102b4f:	55                   	push   %ebp
  102b50:	89 e5                	mov    %esp,%ebp
  102b52:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102b55:	8b 45 08             	mov    0x8(%ebp),%eax
  102b58:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102b5b:	eb 1e                	jmp    102b7b <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  102b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b60:	0f b6 10             	movzbl (%eax),%edx
  102b63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b66:	88 10                	mov    %dl,(%eax)
  102b68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b6b:	0f b6 00             	movzbl (%eax),%eax
  102b6e:	84 c0                	test   %al,%al
  102b70:	74 03                	je     102b75 <strncpy+0x26>
            src ++;
  102b72:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  102b75:	ff 45 fc             	incl   -0x4(%ebp)
  102b78:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  102b7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b7f:	75 dc                	jne    102b5d <strncpy+0xe>
    }
    return dst;
  102b81:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102b84:	c9                   	leave  
  102b85:	c3                   	ret    

00102b86 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102b86:	55                   	push   %ebp
  102b87:	89 e5                	mov    %esp,%ebp
  102b89:	57                   	push   %edi
  102b8a:	56                   	push   %esi
  102b8b:	83 ec 20             	sub    $0x20,%esp
  102b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b97:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102b9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ba0:	89 d1                	mov    %edx,%ecx
  102ba2:	89 c2                	mov    %eax,%edx
  102ba4:	89 ce                	mov    %ecx,%esi
  102ba6:	89 d7                	mov    %edx,%edi
  102ba8:	ac                   	lods   %ds:(%esi),%al
  102ba9:	ae                   	scas   %es:(%edi),%al
  102baa:	75 08                	jne    102bb4 <strcmp+0x2e>
  102bac:	84 c0                	test   %al,%al
  102bae:	75 f8                	jne    102ba8 <strcmp+0x22>
  102bb0:	31 c0                	xor    %eax,%eax
  102bb2:	eb 04                	jmp    102bb8 <strcmp+0x32>
  102bb4:	19 c0                	sbb    %eax,%eax
  102bb6:	0c 01                	or     $0x1,%al
  102bb8:	89 fa                	mov    %edi,%edx
  102bba:	89 f1                	mov    %esi,%ecx
  102bbc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102bbf:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102bc2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102bc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  102bc8:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102bc9:	83 c4 20             	add    $0x20,%esp
  102bcc:	5e                   	pop    %esi
  102bcd:	5f                   	pop    %edi
  102bce:	5d                   	pop    %ebp
  102bcf:	c3                   	ret    

00102bd0 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102bd0:	55                   	push   %ebp
  102bd1:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102bd3:	eb 09                	jmp    102bde <strncmp+0xe>
        n --, s1 ++, s2 ++;
  102bd5:	ff 4d 10             	decl   0x10(%ebp)
  102bd8:	ff 45 08             	incl   0x8(%ebp)
  102bdb:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102bde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102be2:	74 1a                	je     102bfe <strncmp+0x2e>
  102be4:	8b 45 08             	mov    0x8(%ebp),%eax
  102be7:	0f b6 00             	movzbl (%eax),%eax
  102bea:	84 c0                	test   %al,%al
  102bec:	74 10                	je     102bfe <strncmp+0x2e>
  102bee:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf1:	0f b6 10             	movzbl (%eax),%edx
  102bf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bf7:	0f b6 00             	movzbl (%eax),%eax
  102bfa:	38 c2                	cmp    %al,%dl
  102bfc:	74 d7                	je     102bd5 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102bfe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c02:	74 18                	je     102c1c <strncmp+0x4c>
  102c04:	8b 45 08             	mov    0x8(%ebp),%eax
  102c07:	0f b6 00             	movzbl (%eax),%eax
  102c0a:	0f b6 d0             	movzbl %al,%edx
  102c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c10:	0f b6 00             	movzbl (%eax),%eax
  102c13:	0f b6 c0             	movzbl %al,%eax
  102c16:	29 c2                	sub    %eax,%edx
  102c18:	89 d0                	mov    %edx,%eax
  102c1a:	eb 05                	jmp    102c21 <strncmp+0x51>
  102c1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102c21:	5d                   	pop    %ebp
  102c22:	c3                   	ret    

00102c23 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102c23:	55                   	push   %ebp
  102c24:	89 e5                	mov    %esp,%ebp
  102c26:	83 ec 04             	sub    $0x4,%esp
  102c29:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c2c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102c2f:	eb 13                	jmp    102c44 <strchr+0x21>
        if (*s == c) {
  102c31:	8b 45 08             	mov    0x8(%ebp),%eax
  102c34:	0f b6 00             	movzbl (%eax),%eax
  102c37:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102c3a:	75 05                	jne    102c41 <strchr+0x1e>
            return (char *)s;
  102c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102c3f:	eb 12                	jmp    102c53 <strchr+0x30>
        }
        s ++;
  102c41:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102c44:	8b 45 08             	mov    0x8(%ebp),%eax
  102c47:	0f b6 00             	movzbl (%eax),%eax
  102c4a:	84 c0                	test   %al,%al
  102c4c:	75 e3                	jne    102c31 <strchr+0xe>
    }
    return NULL;
  102c4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102c53:	c9                   	leave  
  102c54:	c3                   	ret    

00102c55 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102c55:	55                   	push   %ebp
  102c56:	89 e5                	mov    %esp,%ebp
  102c58:	83 ec 04             	sub    $0x4,%esp
  102c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c5e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102c61:	eb 0e                	jmp    102c71 <strfind+0x1c>
        if (*s == c) {
  102c63:	8b 45 08             	mov    0x8(%ebp),%eax
  102c66:	0f b6 00             	movzbl (%eax),%eax
  102c69:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102c6c:	74 0f                	je     102c7d <strfind+0x28>
            break;
        }
        s ++;
  102c6e:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102c71:	8b 45 08             	mov    0x8(%ebp),%eax
  102c74:	0f b6 00             	movzbl (%eax),%eax
  102c77:	84 c0                	test   %al,%al
  102c79:	75 e8                	jne    102c63 <strfind+0xe>
  102c7b:	eb 01                	jmp    102c7e <strfind+0x29>
            break;
  102c7d:	90                   	nop
    }
    return (char *)s;
  102c7e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102c81:	c9                   	leave  
  102c82:	c3                   	ret    

00102c83 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102c83:	55                   	push   %ebp
  102c84:	89 e5                	mov    %esp,%ebp
  102c86:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102c89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102c90:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102c97:	eb 03                	jmp    102c9c <strtol+0x19>
        s ++;
  102c99:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9f:	0f b6 00             	movzbl (%eax),%eax
  102ca2:	3c 20                	cmp    $0x20,%al
  102ca4:	74 f3                	je     102c99 <strtol+0x16>
  102ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca9:	0f b6 00             	movzbl (%eax),%eax
  102cac:	3c 09                	cmp    $0x9,%al
  102cae:	74 e9                	je     102c99 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  102cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  102cb3:	0f b6 00             	movzbl (%eax),%eax
  102cb6:	3c 2b                	cmp    $0x2b,%al
  102cb8:	75 05                	jne    102cbf <strtol+0x3c>
        s ++;
  102cba:	ff 45 08             	incl   0x8(%ebp)
  102cbd:	eb 14                	jmp    102cd3 <strtol+0x50>
    }
    else if (*s == '-') {
  102cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc2:	0f b6 00             	movzbl (%eax),%eax
  102cc5:	3c 2d                	cmp    $0x2d,%al
  102cc7:	75 0a                	jne    102cd3 <strtol+0x50>
        s ++, neg = 1;
  102cc9:	ff 45 08             	incl   0x8(%ebp)
  102ccc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102cd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102cd7:	74 06                	je     102cdf <strtol+0x5c>
  102cd9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102cdd:	75 22                	jne    102d01 <strtol+0x7e>
  102cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce2:	0f b6 00             	movzbl (%eax),%eax
  102ce5:	3c 30                	cmp    $0x30,%al
  102ce7:	75 18                	jne    102d01 <strtol+0x7e>
  102ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  102cec:	40                   	inc    %eax
  102ced:	0f b6 00             	movzbl (%eax),%eax
  102cf0:	3c 78                	cmp    $0x78,%al
  102cf2:	75 0d                	jne    102d01 <strtol+0x7e>
        s += 2, base = 16;
  102cf4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102cf8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102cff:	eb 29                	jmp    102d2a <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  102d01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d05:	75 16                	jne    102d1d <strtol+0x9a>
  102d07:	8b 45 08             	mov    0x8(%ebp),%eax
  102d0a:	0f b6 00             	movzbl (%eax),%eax
  102d0d:	3c 30                	cmp    $0x30,%al
  102d0f:	75 0c                	jne    102d1d <strtol+0x9a>
        s ++, base = 8;
  102d11:	ff 45 08             	incl   0x8(%ebp)
  102d14:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102d1b:	eb 0d                	jmp    102d2a <strtol+0xa7>
    }
    else if (base == 0) {
  102d1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d21:	75 07                	jne    102d2a <strtol+0xa7>
        base = 10;
  102d23:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  102d2d:	0f b6 00             	movzbl (%eax),%eax
  102d30:	3c 2f                	cmp    $0x2f,%al
  102d32:	7e 1b                	jle    102d4f <strtol+0xcc>
  102d34:	8b 45 08             	mov    0x8(%ebp),%eax
  102d37:	0f b6 00             	movzbl (%eax),%eax
  102d3a:	3c 39                	cmp    $0x39,%al
  102d3c:	7f 11                	jg     102d4f <strtol+0xcc>
            dig = *s - '0';
  102d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d41:	0f b6 00             	movzbl (%eax),%eax
  102d44:	0f be c0             	movsbl %al,%eax
  102d47:	83 e8 30             	sub    $0x30,%eax
  102d4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d4d:	eb 48                	jmp    102d97 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  102d52:	0f b6 00             	movzbl (%eax),%eax
  102d55:	3c 60                	cmp    $0x60,%al
  102d57:	7e 1b                	jle    102d74 <strtol+0xf1>
  102d59:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5c:	0f b6 00             	movzbl (%eax),%eax
  102d5f:	3c 7a                	cmp    $0x7a,%al
  102d61:	7f 11                	jg     102d74 <strtol+0xf1>
            dig = *s - 'a' + 10;
  102d63:	8b 45 08             	mov    0x8(%ebp),%eax
  102d66:	0f b6 00             	movzbl (%eax),%eax
  102d69:	0f be c0             	movsbl %al,%eax
  102d6c:	83 e8 57             	sub    $0x57,%eax
  102d6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d72:	eb 23                	jmp    102d97 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102d74:	8b 45 08             	mov    0x8(%ebp),%eax
  102d77:	0f b6 00             	movzbl (%eax),%eax
  102d7a:	3c 40                	cmp    $0x40,%al
  102d7c:	7e 3b                	jle    102db9 <strtol+0x136>
  102d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d81:	0f b6 00             	movzbl (%eax),%eax
  102d84:	3c 5a                	cmp    $0x5a,%al
  102d86:	7f 31                	jg     102db9 <strtol+0x136>
            dig = *s - 'A' + 10;
  102d88:	8b 45 08             	mov    0x8(%ebp),%eax
  102d8b:	0f b6 00             	movzbl (%eax),%eax
  102d8e:	0f be c0             	movsbl %al,%eax
  102d91:	83 e8 37             	sub    $0x37,%eax
  102d94:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d9a:	3b 45 10             	cmp    0x10(%ebp),%eax
  102d9d:	7d 19                	jge    102db8 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  102d9f:	ff 45 08             	incl   0x8(%ebp)
  102da2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102da5:	0f af 45 10          	imul   0x10(%ebp),%eax
  102da9:	89 c2                	mov    %eax,%edx
  102dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dae:	01 d0                	add    %edx,%eax
  102db0:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102db3:	e9 72 ff ff ff       	jmp    102d2a <strtol+0xa7>
            break;
  102db8:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102db9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102dbd:	74 08                	je     102dc7 <strtol+0x144>
        *endptr = (char *) s;
  102dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dc2:	8b 55 08             	mov    0x8(%ebp),%edx
  102dc5:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102dc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102dcb:	74 07                	je     102dd4 <strtol+0x151>
  102dcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102dd0:	f7 d8                	neg    %eax
  102dd2:	eb 03                	jmp    102dd7 <strtol+0x154>
  102dd4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102dd7:	c9                   	leave  
  102dd8:	c3                   	ret    

00102dd9 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102dd9:	55                   	push   %ebp
  102dda:	89 e5                	mov    %esp,%ebp
  102ddc:	57                   	push   %edi
  102ddd:	83 ec 24             	sub    $0x24,%esp
  102de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102de3:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102de6:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102dea:	8b 55 08             	mov    0x8(%ebp),%edx
  102ded:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102df0:	88 45 f7             	mov    %al,-0x9(%ebp)
  102df3:	8b 45 10             	mov    0x10(%ebp),%eax
  102df6:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102df9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102dfc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102e00:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102e03:	89 d7                	mov    %edx,%edi
  102e05:	f3 aa                	rep stos %al,%es:(%edi)
  102e07:	89 fa                	mov    %edi,%edx
  102e09:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102e0c:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102e0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102e12:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102e13:	83 c4 24             	add    $0x24,%esp
  102e16:	5f                   	pop    %edi
  102e17:	5d                   	pop    %ebp
  102e18:	c3                   	ret    

00102e19 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102e19:	55                   	push   %ebp
  102e1a:	89 e5                	mov    %esp,%ebp
  102e1c:	57                   	push   %edi
  102e1d:	56                   	push   %esi
  102e1e:	53                   	push   %ebx
  102e1f:	83 ec 30             	sub    $0x30,%esp
  102e22:	8b 45 08             	mov    0x8(%ebp),%eax
  102e25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  102e31:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e37:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102e3a:	73 42                	jae    102e7e <memmove+0x65>
  102e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e3f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102e42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e45:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102e48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e4b:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102e4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102e51:	c1 e8 02             	shr    $0x2,%eax
  102e54:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102e56:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102e59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e5c:	89 d7                	mov    %edx,%edi
  102e5e:	89 c6                	mov    %eax,%esi
  102e60:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102e62:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102e65:	83 e1 03             	and    $0x3,%ecx
  102e68:	74 02                	je     102e6c <memmove+0x53>
  102e6a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102e6c:	89 f0                	mov    %esi,%eax
  102e6e:	89 fa                	mov    %edi,%edx
  102e70:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102e73:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102e76:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  102e79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  102e7c:	eb 36                	jmp    102eb4 <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102e7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e81:	8d 50 ff             	lea    -0x1(%eax),%edx
  102e84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e87:	01 c2                	add    %eax,%edx
  102e89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e8c:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e92:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  102e95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e98:	89 c1                	mov    %eax,%ecx
  102e9a:	89 d8                	mov    %ebx,%eax
  102e9c:	89 d6                	mov    %edx,%esi
  102e9e:	89 c7                	mov    %eax,%edi
  102ea0:	fd                   	std    
  102ea1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102ea3:	fc                   	cld    
  102ea4:	89 f8                	mov    %edi,%eax
  102ea6:	89 f2                	mov    %esi,%edx
  102ea8:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102eab:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102eae:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  102eb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102eb4:	83 c4 30             	add    $0x30,%esp
  102eb7:	5b                   	pop    %ebx
  102eb8:	5e                   	pop    %esi
  102eb9:	5f                   	pop    %edi
  102eba:	5d                   	pop    %ebp
  102ebb:	c3                   	ret    

00102ebc <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102ebc:	55                   	push   %ebp
  102ebd:	89 e5                	mov    %esp,%ebp
  102ebf:	57                   	push   %edi
  102ec0:	56                   	push   %esi
  102ec1:	83 ec 20             	sub    $0x20,%esp
  102ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ecd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ed0:	8b 45 10             	mov    0x10(%ebp),%eax
  102ed3:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ed9:	c1 e8 02             	shr    $0x2,%eax
  102edc:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102ede:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ee4:	89 d7                	mov    %edx,%edi
  102ee6:	89 c6                	mov    %eax,%esi
  102ee8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102eea:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102eed:	83 e1 03             	and    $0x3,%ecx
  102ef0:	74 02                	je     102ef4 <memcpy+0x38>
  102ef2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102ef4:	89 f0                	mov    %esi,%eax
  102ef6:	89 fa                	mov    %edi,%edx
  102ef8:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102efb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102efe:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  102f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  102f04:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102f05:	83 c4 20             	add    $0x20,%esp
  102f08:	5e                   	pop    %esi
  102f09:	5f                   	pop    %edi
  102f0a:	5d                   	pop    %ebp
  102f0b:	c3                   	ret    

00102f0c <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102f0c:	55                   	push   %ebp
  102f0d:	89 e5                	mov    %esp,%ebp
  102f0f:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102f12:	8b 45 08             	mov    0x8(%ebp),%eax
  102f15:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102f18:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102f1e:	eb 2e                	jmp    102f4e <memcmp+0x42>
        if (*s1 != *s2) {
  102f20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102f23:	0f b6 10             	movzbl (%eax),%edx
  102f26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f29:	0f b6 00             	movzbl (%eax),%eax
  102f2c:	38 c2                	cmp    %al,%dl
  102f2e:	74 18                	je     102f48 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102f30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102f33:	0f b6 00             	movzbl (%eax),%eax
  102f36:	0f b6 d0             	movzbl %al,%edx
  102f39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f3c:	0f b6 00             	movzbl (%eax),%eax
  102f3f:	0f b6 c0             	movzbl %al,%eax
  102f42:	29 c2                	sub    %eax,%edx
  102f44:	89 d0                	mov    %edx,%eax
  102f46:	eb 18                	jmp    102f60 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  102f48:	ff 45 fc             	incl   -0x4(%ebp)
  102f4b:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  102f4e:	8b 45 10             	mov    0x10(%ebp),%eax
  102f51:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f54:	89 55 10             	mov    %edx,0x10(%ebp)
  102f57:	85 c0                	test   %eax,%eax
  102f59:	75 c5                	jne    102f20 <memcmp+0x14>
    }
    return 0;
  102f5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102f60:	c9                   	leave  
  102f61:	c3                   	ret    

00102f62 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102f62:	55                   	push   %ebp
  102f63:	89 e5                	mov    %esp,%ebp
  102f65:	83 ec 58             	sub    $0x58,%esp
  102f68:	8b 45 10             	mov    0x10(%ebp),%eax
  102f6b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102f6e:	8b 45 14             	mov    0x14(%ebp),%eax
  102f71:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102f74:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102f77:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102f7a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102f7d:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102f80:	8b 45 18             	mov    0x18(%ebp),%eax
  102f83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102f86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f89:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102f8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102f8f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f98:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102f9c:	74 1c                	je     102fba <printnum+0x58>
  102f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fa1:	ba 00 00 00 00       	mov    $0x0,%edx
  102fa6:	f7 75 e4             	divl   -0x1c(%ebp)
  102fa9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102fac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102faf:	ba 00 00 00 00       	mov    $0x0,%edx
  102fb4:	f7 75 e4             	divl   -0x1c(%ebp)
  102fb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102fc0:	f7 75 e4             	divl   -0x1c(%ebp)
  102fc3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102fc6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102fc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fcc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102fcf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102fd2:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102fd5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102fd8:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102fdb:	8b 45 18             	mov    0x18(%ebp),%eax
  102fde:	ba 00 00 00 00       	mov    $0x0,%edx
  102fe3:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  102fe6:	72 56                	jb     10303e <printnum+0xdc>
  102fe8:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  102feb:	77 05                	ja     102ff2 <printnum+0x90>
  102fed:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  102ff0:	72 4c                	jb     10303e <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102ff2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102ff5:	8d 50 ff             	lea    -0x1(%eax),%edx
  102ff8:	8b 45 20             	mov    0x20(%ebp),%eax
  102ffb:	89 44 24 18          	mov    %eax,0x18(%esp)
  102fff:	89 54 24 14          	mov    %edx,0x14(%esp)
  103003:	8b 45 18             	mov    0x18(%ebp),%eax
  103006:	89 44 24 10          	mov    %eax,0x10(%esp)
  10300a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10300d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103010:	89 44 24 08          	mov    %eax,0x8(%esp)
  103014:	89 54 24 0c          	mov    %edx,0xc(%esp)
  103018:	8b 45 0c             	mov    0xc(%ebp),%eax
  10301b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10301f:	8b 45 08             	mov    0x8(%ebp),%eax
  103022:	89 04 24             	mov    %eax,(%esp)
  103025:	e8 38 ff ff ff       	call   102f62 <printnum>
  10302a:	eb 1b                	jmp    103047 <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  10302c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10302f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103033:	8b 45 20             	mov    0x20(%ebp),%eax
  103036:	89 04 24             	mov    %eax,(%esp)
  103039:	8b 45 08             	mov    0x8(%ebp),%eax
  10303c:	ff d0                	call   *%eax
        while (-- width > 0)
  10303e:	ff 4d 1c             	decl   0x1c(%ebp)
  103041:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  103045:	7f e5                	jg     10302c <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  103047:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10304a:	05 70 3d 10 00       	add    $0x103d70,%eax
  10304f:	0f b6 00             	movzbl (%eax),%eax
  103052:	0f be c0             	movsbl %al,%eax
  103055:	8b 55 0c             	mov    0xc(%ebp),%edx
  103058:	89 54 24 04          	mov    %edx,0x4(%esp)
  10305c:	89 04 24             	mov    %eax,(%esp)
  10305f:	8b 45 08             	mov    0x8(%ebp),%eax
  103062:	ff d0                	call   *%eax
}
  103064:	90                   	nop
  103065:	c9                   	leave  
  103066:	c3                   	ret    

00103067 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  103067:	55                   	push   %ebp
  103068:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10306a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10306e:	7e 14                	jle    103084 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  103070:	8b 45 08             	mov    0x8(%ebp),%eax
  103073:	8b 00                	mov    (%eax),%eax
  103075:	8d 48 08             	lea    0x8(%eax),%ecx
  103078:	8b 55 08             	mov    0x8(%ebp),%edx
  10307b:	89 0a                	mov    %ecx,(%edx)
  10307d:	8b 50 04             	mov    0x4(%eax),%edx
  103080:	8b 00                	mov    (%eax),%eax
  103082:	eb 30                	jmp    1030b4 <getuint+0x4d>
    }
    else if (lflag) {
  103084:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103088:	74 16                	je     1030a0 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  10308a:	8b 45 08             	mov    0x8(%ebp),%eax
  10308d:	8b 00                	mov    (%eax),%eax
  10308f:	8d 48 04             	lea    0x4(%eax),%ecx
  103092:	8b 55 08             	mov    0x8(%ebp),%edx
  103095:	89 0a                	mov    %ecx,(%edx)
  103097:	8b 00                	mov    (%eax),%eax
  103099:	ba 00 00 00 00       	mov    $0x0,%edx
  10309e:	eb 14                	jmp    1030b4 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1030a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1030a3:	8b 00                	mov    (%eax),%eax
  1030a5:	8d 48 04             	lea    0x4(%eax),%ecx
  1030a8:	8b 55 08             	mov    0x8(%ebp),%edx
  1030ab:	89 0a                	mov    %ecx,(%edx)
  1030ad:	8b 00                	mov    (%eax),%eax
  1030af:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1030b4:	5d                   	pop    %ebp
  1030b5:	c3                   	ret    

001030b6 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1030b6:	55                   	push   %ebp
  1030b7:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1030b9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1030bd:	7e 14                	jle    1030d3 <getint+0x1d>
        return va_arg(*ap, long long);
  1030bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c2:	8b 00                	mov    (%eax),%eax
  1030c4:	8d 48 08             	lea    0x8(%eax),%ecx
  1030c7:	8b 55 08             	mov    0x8(%ebp),%edx
  1030ca:	89 0a                	mov    %ecx,(%edx)
  1030cc:	8b 50 04             	mov    0x4(%eax),%edx
  1030cf:	8b 00                	mov    (%eax),%eax
  1030d1:	eb 28                	jmp    1030fb <getint+0x45>
    }
    else if (lflag) {
  1030d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1030d7:	74 12                	je     1030eb <getint+0x35>
        return va_arg(*ap, long);
  1030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1030dc:	8b 00                	mov    (%eax),%eax
  1030de:	8d 48 04             	lea    0x4(%eax),%ecx
  1030e1:	8b 55 08             	mov    0x8(%ebp),%edx
  1030e4:	89 0a                	mov    %ecx,(%edx)
  1030e6:	8b 00                	mov    (%eax),%eax
  1030e8:	99                   	cltd   
  1030e9:	eb 10                	jmp    1030fb <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ee:	8b 00                	mov    (%eax),%eax
  1030f0:	8d 48 04             	lea    0x4(%eax),%ecx
  1030f3:	8b 55 08             	mov    0x8(%ebp),%edx
  1030f6:	89 0a                	mov    %ecx,(%edx)
  1030f8:	8b 00                	mov    (%eax),%eax
  1030fa:	99                   	cltd   
    }
}
  1030fb:	5d                   	pop    %ebp
  1030fc:	c3                   	ret    

001030fd <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1030fd:	55                   	push   %ebp
  1030fe:	89 e5                	mov    %esp,%ebp
  103100:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  103103:	8d 45 14             	lea    0x14(%ebp),%eax
  103106:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  103109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10310c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103110:	8b 45 10             	mov    0x10(%ebp),%eax
  103113:	89 44 24 08          	mov    %eax,0x8(%esp)
  103117:	8b 45 0c             	mov    0xc(%ebp),%eax
  10311a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10311e:	8b 45 08             	mov    0x8(%ebp),%eax
  103121:	89 04 24             	mov    %eax,(%esp)
  103124:	e8 03 00 00 00       	call   10312c <vprintfmt>
    va_end(ap);
}
  103129:	90                   	nop
  10312a:	c9                   	leave  
  10312b:	c3                   	ret    

0010312c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10312c:	55                   	push   %ebp
  10312d:	89 e5                	mov    %esp,%ebp
  10312f:	56                   	push   %esi
  103130:	53                   	push   %ebx
  103131:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103134:	eb 17                	jmp    10314d <vprintfmt+0x21>
            if (ch == '\0') {
  103136:	85 db                	test   %ebx,%ebx
  103138:	0f 84 bf 03 00 00    	je     1034fd <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  10313e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103141:	89 44 24 04          	mov    %eax,0x4(%esp)
  103145:	89 1c 24             	mov    %ebx,(%esp)
  103148:	8b 45 08             	mov    0x8(%ebp),%eax
  10314b:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10314d:	8b 45 10             	mov    0x10(%ebp),%eax
  103150:	8d 50 01             	lea    0x1(%eax),%edx
  103153:	89 55 10             	mov    %edx,0x10(%ebp)
  103156:	0f b6 00             	movzbl (%eax),%eax
  103159:	0f b6 d8             	movzbl %al,%ebx
  10315c:	83 fb 25             	cmp    $0x25,%ebx
  10315f:	75 d5                	jne    103136 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  103161:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  103165:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10316c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10316f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  103172:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103179:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10317c:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10317f:	8b 45 10             	mov    0x10(%ebp),%eax
  103182:	8d 50 01             	lea    0x1(%eax),%edx
  103185:	89 55 10             	mov    %edx,0x10(%ebp)
  103188:	0f b6 00             	movzbl (%eax),%eax
  10318b:	0f b6 d8             	movzbl %al,%ebx
  10318e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103191:	83 f8 55             	cmp    $0x55,%eax
  103194:	0f 87 37 03 00 00    	ja     1034d1 <vprintfmt+0x3a5>
  10319a:	8b 04 85 94 3d 10 00 	mov    0x103d94(,%eax,4),%eax
  1031a1:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1031a3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1031a7:	eb d6                	jmp    10317f <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1031a9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1031ad:	eb d0                	jmp    10317f <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1031af:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1031b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1031b9:	89 d0                	mov    %edx,%eax
  1031bb:	c1 e0 02             	shl    $0x2,%eax
  1031be:	01 d0                	add    %edx,%eax
  1031c0:	01 c0                	add    %eax,%eax
  1031c2:	01 d8                	add    %ebx,%eax
  1031c4:	83 e8 30             	sub    $0x30,%eax
  1031c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1031ca:	8b 45 10             	mov    0x10(%ebp),%eax
  1031cd:	0f b6 00             	movzbl (%eax),%eax
  1031d0:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1031d3:	83 fb 2f             	cmp    $0x2f,%ebx
  1031d6:	7e 38                	jle    103210 <vprintfmt+0xe4>
  1031d8:	83 fb 39             	cmp    $0x39,%ebx
  1031db:	7f 33                	jg     103210 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  1031dd:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  1031e0:	eb d4                	jmp    1031b6 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1031e2:	8b 45 14             	mov    0x14(%ebp),%eax
  1031e5:	8d 50 04             	lea    0x4(%eax),%edx
  1031e8:	89 55 14             	mov    %edx,0x14(%ebp)
  1031eb:	8b 00                	mov    (%eax),%eax
  1031ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1031f0:	eb 1f                	jmp    103211 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  1031f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1031f6:	79 87                	jns    10317f <vprintfmt+0x53>
                width = 0;
  1031f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1031ff:	e9 7b ff ff ff       	jmp    10317f <vprintfmt+0x53>

        case '#':
            altflag = 1;
  103204:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10320b:	e9 6f ff ff ff       	jmp    10317f <vprintfmt+0x53>
            goto process_precision;
  103210:	90                   	nop

        process_precision:
            if (width < 0)
  103211:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103215:	0f 89 64 ff ff ff    	jns    10317f <vprintfmt+0x53>
                width = precision, precision = -1;
  10321b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10321e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103221:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  103228:	e9 52 ff ff ff       	jmp    10317f <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10322d:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  103230:	e9 4a ff ff ff       	jmp    10317f <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  103235:	8b 45 14             	mov    0x14(%ebp),%eax
  103238:	8d 50 04             	lea    0x4(%eax),%edx
  10323b:	89 55 14             	mov    %edx,0x14(%ebp)
  10323e:	8b 00                	mov    (%eax),%eax
  103240:	8b 55 0c             	mov    0xc(%ebp),%edx
  103243:	89 54 24 04          	mov    %edx,0x4(%esp)
  103247:	89 04 24             	mov    %eax,(%esp)
  10324a:	8b 45 08             	mov    0x8(%ebp),%eax
  10324d:	ff d0                	call   *%eax
            break;
  10324f:	e9 a4 02 00 00       	jmp    1034f8 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  103254:	8b 45 14             	mov    0x14(%ebp),%eax
  103257:	8d 50 04             	lea    0x4(%eax),%edx
  10325a:	89 55 14             	mov    %edx,0x14(%ebp)
  10325d:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10325f:	85 db                	test   %ebx,%ebx
  103261:	79 02                	jns    103265 <vprintfmt+0x139>
                err = -err;
  103263:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  103265:	83 fb 06             	cmp    $0x6,%ebx
  103268:	7f 0b                	jg     103275 <vprintfmt+0x149>
  10326a:	8b 34 9d 54 3d 10 00 	mov    0x103d54(,%ebx,4),%esi
  103271:	85 f6                	test   %esi,%esi
  103273:	75 23                	jne    103298 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  103275:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  103279:	c7 44 24 08 81 3d 10 	movl   $0x103d81,0x8(%esp)
  103280:	00 
  103281:	8b 45 0c             	mov    0xc(%ebp),%eax
  103284:	89 44 24 04          	mov    %eax,0x4(%esp)
  103288:	8b 45 08             	mov    0x8(%ebp),%eax
  10328b:	89 04 24             	mov    %eax,(%esp)
  10328e:	e8 6a fe ff ff       	call   1030fd <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  103293:	e9 60 02 00 00       	jmp    1034f8 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  103298:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10329c:	c7 44 24 08 8a 3d 10 	movl   $0x103d8a,0x8(%esp)
  1032a3:	00 
  1032a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ae:	89 04 24             	mov    %eax,(%esp)
  1032b1:	e8 47 fe ff ff       	call   1030fd <printfmt>
            break;
  1032b6:	e9 3d 02 00 00       	jmp    1034f8 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1032bb:	8b 45 14             	mov    0x14(%ebp),%eax
  1032be:	8d 50 04             	lea    0x4(%eax),%edx
  1032c1:	89 55 14             	mov    %edx,0x14(%ebp)
  1032c4:	8b 30                	mov    (%eax),%esi
  1032c6:	85 f6                	test   %esi,%esi
  1032c8:	75 05                	jne    1032cf <vprintfmt+0x1a3>
                p = "(null)";
  1032ca:	be 8d 3d 10 00       	mov    $0x103d8d,%esi
            }
            if (width > 0 && padc != '-') {
  1032cf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1032d3:	7e 76                	jle    10334b <vprintfmt+0x21f>
  1032d5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1032d9:	74 70                	je     10334b <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1032db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032de:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032e2:	89 34 24             	mov    %esi,(%esp)
  1032e5:	e8 f6 f7 ff ff       	call   102ae0 <strnlen>
  1032ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1032ed:	29 c2                	sub    %eax,%edx
  1032ef:	89 d0                	mov    %edx,%eax
  1032f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1032f4:	eb 16                	jmp    10330c <vprintfmt+0x1e0>
                    putch(padc, putdat);
  1032f6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1032fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  1032fd:	89 54 24 04          	mov    %edx,0x4(%esp)
  103301:	89 04 24             	mov    %eax,(%esp)
  103304:	8b 45 08             	mov    0x8(%ebp),%eax
  103307:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  103309:	ff 4d e8             	decl   -0x18(%ebp)
  10330c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103310:	7f e4                	jg     1032f6 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103312:	eb 37                	jmp    10334b <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  103314:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103318:	74 1f                	je     103339 <vprintfmt+0x20d>
  10331a:	83 fb 1f             	cmp    $0x1f,%ebx
  10331d:	7e 05                	jle    103324 <vprintfmt+0x1f8>
  10331f:	83 fb 7e             	cmp    $0x7e,%ebx
  103322:	7e 15                	jle    103339 <vprintfmt+0x20d>
                    putch('?', putdat);
  103324:	8b 45 0c             	mov    0xc(%ebp),%eax
  103327:	89 44 24 04          	mov    %eax,0x4(%esp)
  10332b:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  103332:	8b 45 08             	mov    0x8(%ebp),%eax
  103335:	ff d0                	call   *%eax
  103337:	eb 0f                	jmp    103348 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  103339:	8b 45 0c             	mov    0xc(%ebp),%eax
  10333c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103340:	89 1c 24             	mov    %ebx,(%esp)
  103343:	8b 45 08             	mov    0x8(%ebp),%eax
  103346:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103348:	ff 4d e8             	decl   -0x18(%ebp)
  10334b:	89 f0                	mov    %esi,%eax
  10334d:	8d 70 01             	lea    0x1(%eax),%esi
  103350:	0f b6 00             	movzbl (%eax),%eax
  103353:	0f be d8             	movsbl %al,%ebx
  103356:	85 db                	test   %ebx,%ebx
  103358:	74 27                	je     103381 <vprintfmt+0x255>
  10335a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10335e:	78 b4                	js     103314 <vprintfmt+0x1e8>
  103360:	ff 4d e4             	decl   -0x1c(%ebp)
  103363:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103367:	79 ab                	jns    103314 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  103369:	eb 16                	jmp    103381 <vprintfmt+0x255>
                putch(' ', putdat);
  10336b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10336e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103372:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  103379:	8b 45 08             	mov    0x8(%ebp),%eax
  10337c:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  10337e:	ff 4d e8             	decl   -0x18(%ebp)
  103381:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103385:	7f e4                	jg     10336b <vprintfmt+0x23f>
            }
            break;
  103387:	e9 6c 01 00 00       	jmp    1034f8 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10338c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10338f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103393:	8d 45 14             	lea    0x14(%ebp),%eax
  103396:	89 04 24             	mov    %eax,(%esp)
  103399:	e8 18 fd ff ff       	call   1030b6 <getint>
  10339e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033a1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1033a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1033aa:	85 d2                	test   %edx,%edx
  1033ac:	79 26                	jns    1033d4 <vprintfmt+0x2a8>
                putch('-', putdat);
  1033ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033b5:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1033bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1033bf:	ff d0                	call   *%eax
                num = -(long long)num;
  1033c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1033c7:	f7 d8                	neg    %eax
  1033c9:	83 d2 00             	adc    $0x0,%edx
  1033cc:	f7 da                	neg    %edx
  1033ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1033d4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1033db:	e9 a8 00 00 00       	jmp    103488 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1033e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1033e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033e7:	8d 45 14             	lea    0x14(%ebp),%eax
  1033ea:	89 04 24             	mov    %eax,(%esp)
  1033ed:	e8 75 fc ff ff       	call   103067 <getuint>
  1033f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1033f8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1033ff:	e9 84 00 00 00       	jmp    103488 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  103404:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103407:	89 44 24 04          	mov    %eax,0x4(%esp)
  10340b:	8d 45 14             	lea    0x14(%ebp),%eax
  10340e:	89 04 24             	mov    %eax,(%esp)
  103411:	e8 51 fc ff ff       	call   103067 <getuint>
  103416:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103419:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  10341c:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  103423:	eb 63                	jmp    103488 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  103425:	8b 45 0c             	mov    0xc(%ebp),%eax
  103428:	89 44 24 04          	mov    %eax,0x4(%esp)
  10342c:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  103433:	8b 45 08             	mov    0x8(%ebp),%eax
  103436:	ff d0                	call   *%eax
            putch('x', putdat);
  103438:	8b 45 0c             	mov    0xc(%ebp),%eax
  10343b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10343f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  103446:	8b 45 08             	mov    0x8(%ebp),%eax
  103449:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10344b:	8b 45 14             	mov    0x14(%ebp),%eax
  10344e:	8d 50 04             	lea    0x4(%eax),%edx
  103451:	89 55 14             	mov    %edx,0x14(%ebp)
  103454:	8b 00                	mov    (%eax),%eax
  103456:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103459:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  103460:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  103467:	eb 1f                	jmp    103488 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103469:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10346c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103470:	8d 45 14             	lea    0x14(%ebp),%eax
  103473:	89 04 24             	mov    %eax,(%esp)
  103476:	e8 ec fb ff ff       	call   103067 <getuint>
  10347b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10347e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103481:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103488:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10348c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10348f:	89 54 24 18          	mov    %edx,0x18(%esp)
  103493:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103496:	89 54 24 14          	mov    %edx,0x14(%esp)
  10349a:	89 44 24 10          	mov    %eax,0x10(%esp)
  10349e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1034a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1034a8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1034ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1034b6:	89 04 24             	mov    %eax,(%esp)
  1034b9:	e8 a4 fa ff ff       	call   102f62 <printnum>
            break;
  1034be:	eb 38                	jmp    1034f8 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1034c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034c7:	89 1c 24             	mov    %ebx,(%esp)
  1034ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1034cd:	ff d0                	call   *%eax
            break;
  1034cf:	eb 27                	jmp    1034f8 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1034d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034d8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1034df:	8b 45 08             	mov    0x8(%ebp),%eax
  1034e2:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1034e4:	ff 4d 10             	decl   0x10(%ebp)
  1034e7:	eb 03                	jmp    1034ec <vprintfmt+0x3c0>
  1034e9:	ff 4d 10             	decl   0x10(%ebp)
  1034ec:	8b 45 10             	mov    0x10(%ebp),%eax
  1034ef:	48                   	dec    %eax
  1034f0:	0f b6 00             	movzbl (%eax),%eax
  1034f3:	3c 25                	cmp    $0x25,%al
  1034f5:	75 f2                	jne    1034e9 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  1034f7:	90                   	nop
    while (1) {
  1034f8:	e9 37 fc ff ff       	jmp    103134 <vprintfmt+0x8>
                return;
  1034fd:	90                   	nop
        }
    }
}
  1034fe:	83 c4 40             	add    $0x40,%esp
  103501:	5b                   	pop    %ebx
  103502:	5e                   	pop    %esi
  103503:	5d                   	pop    %ebp
  103504:	c3                   	ret    

00103505 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103505:	55                   	push   %ebp
  103506:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  103508:	8b 45 0c             	mov    0xc(%ebp),%eax
  10350b:	8b 40 08             	mov    0x8(%eax),%eax
  10350e:	8d 50 01             	lea    0x1(%eax),%edx
  103511:	8b 45 0c             	mov    0xc(%ebp),%eax
  103514:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103517:	8b 45 0c             	mov    0xc(%ebp),%eax
  10351a:	8b 10                	mov    (%eax),%edx
  10351c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10351f:	8b 40 04             	mov    0x4(%eax),%eax
  103522:	39 c2                	cmp    %eax,%edx
  103524:	73 12                	jae    103538 <sprintputch+0x33>
        *b->buf ++ = ch;
  103526:	8b 45 0c             	mov    0xc(%ebp),%eax
  103529:	8b 00                	mov    (%eax),%eax
  10352b:	8d 48 01             	lea    0x1(%eax),%ecx
  10352e:	8b 55 0c             	mov    0xc(%ebp),%edx
  103531:	89 0a                	mov    %ecx,(%edx)
  103533:	8b 55 08             	mov    0x8(%ebp),%edx
  103536:	88 10                	mov    %dl,(%eax)
    }
}
  103538:	90                   	nop
  103539:	5d                   	pop    %ebp
  10353a:	c3                   	ret    

0010353b <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10353b:	55                   	push   %ebp
  10353c:	89 e5                	mov    %esp,%ebp
  10353e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103541:	8d 45 14             	lea    0x14(%ebp),%eax
  103544:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10354a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10354e:	8b 45 10             	mov    0x10(%ebp),%eax
  103551:	89 44 24 08          	mov    %eax,0x8(%esp)
  103555:	8b 45 0c             	mov    0xc(%ebp),%eax
  103558:	89 44 24 04          	mov    %eax,0x4(%esp)
  10355c:	8b 45 08             	mov    0x8(%ebp),%eax
  10355f:	89 04 24             	mov    %eax,(%esp)
  103562:	e8 08 00 00 00       	call   10356f <vsnprintf>
  103567:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10356a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10356d:	c9                   	leave  
  10356e:	c3                   	ret    

0010356f <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10356f:	55                   	push   %ebp
  103570:	89 e5                	mov    %esp,%ebp
  103572:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103575:	8b 45 08             	mov    0x8(%ebp),%eax
  103578:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10357b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10357e:	8d 50 ff             	lea    -0x1(%eax),%edx
  103581:	8b 45 08             	mov    0x8(%ebp),%eax
  103584:	01 d0                	add    %edx,%eax
  103586:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103589:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103590:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103594:	74 0a                	je     1035a0 <vsnprintf+0x31>
  103596:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103599:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10359c:	39 c2                	cmp    %eax,%edx
  10359e:	76 07                	jbe    1035a7 <vsnprintf+0x38>
        return -E_INVAL;
  1035a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1035a5:	eb 2a                	jmp    1035d1 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1035a7:	8b 45 14             	mov    0x14(%ebp),%eax
  1035aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1035ae:	8b 45 10             	mov    0x10(%ebp),%eax
  1035b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1035b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1035b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035bc:	c7 04 24 05 35 10 00 	movl   $0x103505,(%esp)
  1035c3:	e8 64 fb ff ff       	call   10312c <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1035c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035cb:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1035ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1035d1:	c9                   	leave  
  1035d2:	c3                   	ret    
