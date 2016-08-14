
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	83 ec 04             	sub    $0x4,%esp
  100017:	50                   	push   %eax
  100018:	6a 00                	push   $0x0
  10001a:	68 16 ea 10 00       	push   $0x10ea16
  10001f:	e8 38 2c 00 00       	call   102c5c <memset>
  100024:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100027:	e8 1d 15 00 00       	call   101549 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002c:	c7 45 f4 80 34 10 00 	movl   $0x103480,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100033:	83 ec 08             	sub    $0x8,%esp
  100036:	ff 75 f4             	pushl  -0xc(%ebp)
  100039:	68 9c 34 10 00       	push   $0x10349c
  10003e:	e8 05 02 00 00       	call   100248 <cprintf>
  100043:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100046:	e8 a3 08 00 00       	call   1008ee <print_kerninfo>

    grade_backtrace();
  10004b:	e8 79 00 00 00       	call   1000c9 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100050:	e8 cd 28 00 00       	call   102922 <pmm_init>

    pic_init();                 // init interrupt controller
  100055:	e8 26 16 00 00       	call   101680 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005a:	e8 83 17 00 00       	call   1017e2 <idt_init>

    clock_init();               // init clock interrupt
  10005f:	e8 d8 0c 00 00       	call   100d3c <clock_init>
    intr_enable();              // enable irq interrupt
  100064:	e8 52 17 00 00       	call   1017bb <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  100069:	e8 45 01 00 00       	call   1001b3 <lab1_switch_test>

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	83 ec 04             	sub    $0x4,%esp
  100079:	6a 00                	push   $0x0
  10007b:	6a 00                	push   $0x0
  10007d:	6a 00                	push   $0x0
  10007f:	e8 a6 0c 00 00       	call   100d2a <mon_backtrace>
  100084:	83 c4 10             	add    $0x10,%esp
}
  100087:	90                   	nop
  100088:	c9                   	leave  
  100089:	c3                   	ret    

0010008a <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  10008a:	55                   	push   %ebp
  10008b:	89 e5                	mov    %esp,%ebp
  10008d:	53                   	push   %ebx
  10008e:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  100091:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  100094:	8b 55 0c             	mov    0xc(%ebp),%edx
  100097:	8d 5d 08             	lea    0x8(%ebp),%ebx
  10009a:	8b 45 08             	mov    0x8(%ebp),%eax
  10009d:	51                   	push   %ecx
  10009e:	52                   	push   %edx
  10009f:	53                   	push   %ebx
  1000a0:	50                   	push   %eax
  1000a1:	e8 ca ff ff ff       	call   100070 <grade_backtrace2>
  1000a6:	83 c4 10             	add    $0x10,%esp
}
  1000a9:	90                   	nop
  1000aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000ad:	c9                   	leave  
  1000ae:	c3                   	ret    

001000af <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000af:	55                   	push   %ebp
  1000b0:	89 e5                	mov    %esp,%ebp
  1000b2:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000b5:	83 ec 08             	sub    $0x8,%esp
  1000b8:	ff 75 10             	pushl  0x10(%ebp)
  1000bb:	ff 75 08             	pushl  0x8(%ebp)
  1000be:	e8 c7 ff ff ff       	call   10008a <grade_backtrace1>
  1000c3:	83 c4 10             	add    $0x10,%esp
}
  1000c6:	90                   	nop
  1000c7:	c9                   	leave  
  1000c8:	c3                   	ret    

001000c9 <grade_backtrace>:

void
grade_backtrace(void) {
  1000c9:	55                   	push   %ebp
  1000ca:	89 e5                	mov    %esp,%ebp
  1000cc:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000cf:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000d4:	83 ec 04             	sub    $0x4,%esp
  1000d7:	68 00 00 ff ff       	push   $0xffff0000
  1000dc:	50                   	push   %eax
  1000dd:	6a 00                	push   $0x0
  1000df:	e8 cb ff ff ff       	call   1000af <grade_backtrace0>
  1000e4:	83 c4 10             	add    $0x10,%esp
}
  1000e7:	90                   	nop
  1000e8:	c9                   	leave  
  1000e9:	c3                   	ret    

001000ea <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  1000ea:	55                   	push   %ebp
  1000eb:	89 e5                	mov    %esp,%ebp
  1000ed:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  1000f0:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  1000f3:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  1000f6:	8c 45 f2             	mov    %es,-0xe(%ebp)
  1000f9:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  1000fc:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100100:	0f b7 c0             	movzwl %ax,%eax
  100103:	83 e0 03             	and    $0x3,%eax
  100106:	89 c2                	mov    %eax,%edx
  100108:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10010d:	83 ec 04             	sub    $0x4,%esp
  100110:	52                   	push   %edx
  100111:	50                   	push   %eax
  100112:	68 a1 34 10 00       	push   $0x1034a1
  100117:	e8 2c 01 00 00       	call   100248 <cprintf>
  10011c:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  10011f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100123:	0f b7 d0             	movzwl %ax,%edx
  100126:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10012b:	83 ec 04             	sub    $0x4,%esp
  10012e:	52                   	push   %edx
  10012f:	50                   	push   %eax
  100130:	68 af 34 10 00       	push   $0x1034af
  100135:	e8 0e 01 00 00       	call   100248 <cprintf>
  10013a:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  10013d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100141:	0f b7 d0             	movzwl %ax,%edx
  100144:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100149:	83 ec 04             	sub    $0x4,%esp
  10014c:	52                   	push   %edx
  10014d:	50                   	push   %eax
  10014e:	68 bd 34 10 00       	push   $0x1034bd
  100153:	e8 f0 00 00 00       	call   100248 <cprintf>
  100158:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  10015b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10015f:	0f b7 d0             	movzwl %ax,%edx
  100162:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100167:	83 ec 04             	sub    $0x4,%esp
  10016a:	52                   	push   %edx
  10016b:	50                   	push   %eax
  10016c:	68 cb 34 10 00       	push   $0x1034cb
  100171:	e8 d2 00 00 00       	call   100248 <cprintf>
  100176:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  100179:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10017d:	0f b7 d0             	movzwl %ax,%edx
  100180:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100185:	83 ec 04             	sub    $0x4,%esp
  100188:	52                   	push   %edx
  100189:	50                   	push   %eax
  10018a:	68 d9 34 10 00       	push   $0x1034d9
  10018f:	e8 b4 00 00 00       	call   100248 <cprintf>
  100194:	83 c4 10             	add    $0x10,%esp
    round ++;
  100197:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10019c:	83 c0 01             	add    $0x1,%eax
  10019f:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001a4:	90                   	nop
  1001a5:	c9                   	leave  
  1001a6:	c3                   	ret    

001001a7 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001a7:	55                   	push   %ebp
  1001a8:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001aa:	90                   	nop
  1001ab:	5d                   	pop    %ebp
  1001ac:	c3                   	ret    

001001ad <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001ad:	55                   	push   %ebp
  1001ae:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001b0:	90                   	nop
  1001b1:	5d                   	pop    %ebp
  1001b2:	c3                   	ret    

001001b3 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001b3:	55                   	push   %ebp
  1001b4:	89 e5                	mov    %esp,%ebp
  1001b6:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001b9:	e8 2c ff ff ff       	call   1000ea <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001be:	83 ec 0c             	sub    $0xc,%esp
  1001c1:	68 e8 34 10 00       	push   $0x1034e8
  1001c6:	e8 7d 00 00 00       	call   100248 <cprintf>
  1001cb:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001ce:	e8 d4 ff ff ff       	call   1001a7 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001d3:	e8 12 ff ff ff       	call   1000ea <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001d8:	83 ec 0c             	sub    $0xc,%esp
  1001db:	68 08 35 10 00       	push   $0x103508
  1001e0:	e8 63 00 00 00       	call   100248 <cprintf>
  1001e5:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  1001e8:	e8 c0 ff ff ff       	call   1001ad <lab1_switch_to_kernel>
    lab1_print_cur_status();
  1001ed:	e8 f8 fe ff ff       	call   1000ea <lab1_print_cur_status>
}
  1001f2:	90                   	nop
  1001f3:	c9                   	leave  
  1001f4:	c3                   	ret    

001001f5 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
  1001f8:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1001fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1001fe:	89 04 24             	mov    %eax,(%esp)
  100201:	e8 6f 13 00 00       	call   101575 <cons_putc>
    (*cnt) ++;
  100206:	8b 45 0c             	mov    0xc(%ebp),%eax
  100209:	8b 00                	mov    (%eax),%eax
  10020b:	8d 50 01             	lea    0x1(%eax),%edx
  10020e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100211:	89 10                	mov    %edx,(%eax)
}
  100213:	c9                   	leave  
  100214:	c3                   	ret    

00100215 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100215:	55                   	push   %ebp
  100216:	89 e5                	mov    %esp,%ebp
  100218:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10021b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100222:	8b 45 0c             	mov    0xc(%ebp),%eax
  100225:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100229:	8b 45 08             	mov    0x8(%ebp),%eax
  10022c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100230:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100233:	89 44 24 04          	mov    %eax,0x4(%esp)
  100237:	c7 04 24 f5 01 10 00 	movl   $0x1001f5,(%esp)
  10023e:	e8 6b 2d 00 00       	call   102fae <vprintfmt>
    return cnt;
  100243:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100246:	c9                   	leave  
  100247:	c3                   	ret    

00100248 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100248:	55                   	push   %ebp
  100249:	89 e5                	mov    %esp,%ebp
  10024b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10024e:	8d 45 0c             	lea    0xc(%ebp),%eax
  100251:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100254:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100257:	89 44 24 04          	mov    %eax,0x4(%esp)
  10025b:	8b 45 08             	mov    0x8(%ebp),%eax
  10025e:	89 04 24             	mov    %eax,(%esp)
  100261:	e8 af ff ff ff       	call   100215 <vcprintf>
  100266:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100269:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10026c:	c9                   	leave  
  10026d:	c3                   	ret    

0010026e <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10026e:	55                   	push   %ebp
  10026f:	89 e5                	mov    %esp,%ebp
  100271:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100274:	8b 45 08             	mov    0x8(%ebp),%eax
  100277:	89 04 24             	mov    %eax,(%esp)
  10027a:	e8 f6 12 00 00       	call   101575 <cons_putc>
}
  10027f:	c9                   	leave  
  100280:	c3                   	ret    

00100281 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100281:	55                   	push   %ebp
  100282:	89 e5                	mov    %esp,%ebp
  100284:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100287:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10028e:	eb 13                	jmp    1002a3 <cputs+0x22>
        cputch(c, &cnt);
  100290:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100294:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100297:	89 54 24 04          	mov    %edx,0x4(%esp)
  10029b:	89 04 24             	mov    %eax,(%esp)
  10029e:	e8 52 ff ff ff       	call   1001f5 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1002a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1002a6:	8d 50 01             	lea    0x1(%eax),%edx
  1002a9:	89 55 08             	mov    %edx,0x8(%ebp)
  1002ac:	0f b6 00             	movzbl (%eax),%eax
  1002af:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002b2:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002b6:	75 d8                	jne    100290 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1002b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002bf:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1002c6:	e8 2a ff ff ff       	call   1001f5 <cputch>
    return cnt;
  1002cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002ce:	c9                   	leave  
  1002cf:	c3                   	ret    

001002d0 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002d0:	55                   	push   %ebp
  1002d1:	89 e5                	mov    %esp,%ebp
  1002d3:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002d6:	e8 c3 12 00 00       	call   10159e <cons_getc>
  1002db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1002de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002e2:	74 f2                	je     1002d6 <getchar+0x6>
        /* do nothing */;
    return c;
  1002e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002e7:	c9                   	leave  
  1002e8:	c3                   	ret    

001002e9 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1002e9:	55                   	push   %ebp
  1002ea:	89 e5                	mov    %esp,%ebp
  1002ec:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  1002ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1002f3:	74 13                	je     100308 <readline+0x1f>
        cprintf("%s", prompt);
  1002f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002fc:	c7 04 24 27 35 10 00 	movl   $0x103527,(%esp)
  100303:	e8 40 ff ff ff       	call   100248 <cprintf>
    }
    int i = 0, c;
  100308:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10030f:	e8 bc ff ff ff       	call   1002d0 <getchar>
  100314:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100317:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10031b:	79 07                	jns    100324 <readline+0x3b>
            return NULL;
  10031d:	b8 00 00 00 00       	mov    $0x0,%eax
  100322:	eb 79                	jmp    10039d <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100324:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100328:	7e 28                	jle    100352 <readline+0x69>
  10032a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100331:	7f 1f                	jg     100352 <readline+0x69>
            cputchar(c);
  100333:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100336:	89 04 24             	mov    %eax,(%esp)
  100339:	e8 30 ff ff ff       	call   10026e <cputchar>
            buf[i ++] = c;
  10033e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100341:	8d 50 01             	lea    0x1(%eax),%edx
  100344:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100347:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10034a:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100350:	eb 46                	jmp    100398 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100352:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100356:	75 17                	jne    10036f <readline+0x86>
  100358:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10035c:	7e 11                	jle    10036f <readline+0x86>
            cputchar(c);
  10035e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100361:	89 04 24             	mov    %eax,(%esp)
  100364:	e8 05 ff ff ff       	call   10026e <cputchar>
            i --;
  100369:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10036d:	eb 29                	jmp    100398 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  10036f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100373:	74 06                	je     10037b <readline+0x92>
  100375:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100379:	75 1d                	jne    100398 <readline+0xaf>
            cputchar(c);
  10037b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10037e:	89 04 24             	mov    %eax,(%esp)
  100381:	e8 e8 fe ff ff       	call   10026e <cputchar>
            buf[i] = '\0';
  100386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100389:	05 40 ea 10 00       	add    $0x10ea40,%eax
  10038e:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  100391:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  100396:	eb 05                	jmp    10039d <readline+0xb4>
        }
    }
  100398:	e9 72 ff ff ff       	jmp    10030f <readline+0x26>
}
  10039d:	c9                   	leave  
  10039e:	c3                   	ret    

0010039f <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  10039f:	55                   	push   %ebp
  1003a0:	89 e5                	mov    %esp,%ebp
  1003a2:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003a5:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003aa:	85 c0                	test   %eax,%eax
  1003ac:	74 02                	je     1003b0 <__panic+0x11>
        goto panic_dead;
  1003ae:	eb 48                	jmp    1003f8 <__panic+0x59>
    }
    is_panic = 1;
  1003b0:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003b7:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003ba:	8d 45 14             	lea    0x14(%ebp),%eax
  1003bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1003c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1003ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003ce:	c7 04 24 2a 35 10 00 	movl   $0x10352a,(%esp)
  1003d5:	e8 6e fe ff ff       	call   100248 <cprintf>
    vcprintf(fmt, ap);
  1003da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003e1:	8b 45 10             	mov    0x10(%ebp),%eax
  1003e4:	89 04 24             	mov    %eax,(%esp)
  1003e7:	e8 29 fe ff ff       	call   100215 <vcprintf>
    cprintf("\n");
  1003ec:	c7 04 24 46 35 10 00 	movl   $0x103546,(%esp)
  1003f3:	e8 50 fe ff ff       	call   100248 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  1003f8:	e8 c4 13 00 00       	call   1017c1 <intr_disable>
    while (1) {
        kmonitor(NULL);
  1003fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100404:	e8 52 08 00 00       	call   100c5b <kmonitor>
    }
  100409:	eb f2                	jmp    1003fd <__panic+0x5e>

0010040b <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  10040b:	55                   	push   %ebp
  10040c:	89 e5                	mov    %esp,%ebp
  10040e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100411:	8d 45 14             	lea    0x14(%ebp),%eax
  100414:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100417:	8b 45 0c             	mov    0xc(%ebp),%eax
  10041a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10041e:	8b 45 08             	mov    0x8(%ebp),%eax
  100421:	89 44 24 04          	mov    %eax,0x4(%esp)
  100425:	c7 04 24 48 35 10 00 	movl   $0x103548,(%esp)
  10042c:	e8 17 fe ff ff       	call   100248 <cprintf>
    vcprintf(fmt, ap);
  100431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100434:	89 44 24 04          	mov    %eax,0x4(%esp)
  100438:	8b 45 10             	mov    0x10(%ebp),%eax
  10043b:	89 04 24             	mov    %eax,(%esp)
  10043e:	e8 d2 fd ff ff       	call   100215 <vcprintf>
    cprintf("\n");
  100443:	c7 04 24 46 35 10 00 	movl   $0x103546,(%esp)
  10044a:	e8 f9 fd ff ff       	call   100248 <cprintf>
    va_end(ap);
}
  10044f:	c9                   	leave  
  100450:	c3                   	ret    

00100451 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100451:	55                   	push   %ebp
  100452:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100454:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100459:	5d                   	pop    %ebp
  10045a:	c3                   	ret    

0010045b <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  10045b:	55                   	push   %ebp
  10045c:	89 e5                	mov    %esp,%ebp
  10045e:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100461:	8b 45 0c             	mov    0xc(%ebp),%eax
  100464:	8b 00                	mov    (%eax),%eax
  100466:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100469:	8b 45 10             	mov    0x10(%ebp),%eax
  10046c:	8b 00                	mov    (%eax),%eax
  10046e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100471:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  100478:	e9 d2 00 00 00       	jmp    10054f <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  10047d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100480:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100483:	01 d0                	add    %edx,%eax
  100485:	89 c2                	mov    %eax,%edx
  100487:	c1 ea 1f             	shr    $0x1f,%edx
  10048a:	01 d0                	add    %edx,%eax
  10048c:	d1 f8                	sar    %eax
  10048e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100491:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100494:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100497:	eb 04                	jmp    10049d <stab_binsearch+0x42>
            m --;
  100499:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10049d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004a3:	7c 1f                	jl     1004c4 <stab_binsearch+0x69>
  1004a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004a8:	89 d0                	mov    %edx,%eax
  1004aa:	01 c0                	add    %eax,%eax
  1004ac:	01 d0                	add    %edx,%eax
  1004ae:	c1 e0 02             	shl    $0x2,%eax
  1004b1:	89 c2                	mov    %eax,%edx
  1004b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1004b6:	01 d0                	add    %edx,%eax
  1004b8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004bc:	0f b6 c0             	movzbl %al,%eax
  1004bf:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004c2:	75 d5                	jne    100499 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  1004c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004c7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004ca:	7d 0b                	jge    1004d7 <stab_binsearch+0x7c>
            l = true_m + 1;
  1004cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004cf:	83 c0 01             	add    $0x1,%eax
  1004d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  1004d5:	eb 78                	jmp    10054f <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  1004d7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  1004de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004e1:	89 d0                	mov    %edx,%eax
  1004e3:	01 c0                	add    %eax,%eax
  1004e5:	01 d0                	add    %edx,%eax
  1004e7:	c1 e0 02             	shl    $0x2,%eax
  1004ea:	89 c2                	mov    %eax,%edx
  1004ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ef:	01 d0                	add    %edx,%eax
  1004f1:	8b 40 08             	mov    0x8(%eax),%eax
  1004f4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004f7:	73 13                	jae    10050c <stab_binsearch+0xb1>
            *region_left = m;
  1004f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004ff:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100501:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100504:	83 c0 01             	add    $0x1,%eax
  100507:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10050a:	eb 43                	jmp    10054f <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10050c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10050f:	89 d0                	mov    %edx,%eax
  100511:	01 c0                	add    %eax,%eax
  100513:	01 d0                	add    %edx,%eax
  100515:	c1 e0 02             	shl    $0x2,%eax
  100518:	89 c2                	mov    %eax,%edx
  10051a:	8b 45 08             	mov    0x8(%ebp),%eax
  10051d:	01 d0                	add    %edx,%eax
  10051f:	8b 40 08             	mov    0x8(%eax),%eax
  100522:	3b 45 18             	cmp    0x18(%ebp),%eax
  100525:	76 16                	jbe    10053d <stab_binsearch+0xe2>
            *region_right = m - 1;
  100527:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10052a:	8d 50 ff             	lea    -0x1(%eax),%edx
  10052d:	8b 45 10             	mov    0x10(%ebp),%eax
  100530:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100532:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100535:	83 e8 01             	sub    $0x1,%eax
  100538:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10053b:	eb 12                	jmp    10054f <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10053d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100540:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100543:	89 10                	mov    %edx,(%eax)
            l = m;
  100545:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100548:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  10054b:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  10054f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100552:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100555:	0f 8e 22 ff ff ff    	jle    10047d <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  10055b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10055f:	75 0f                	jne    100570 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  100561:	8b 45 0c             	mov    0xc(%ebp),%eax
  100564:	8b 00                	mov    (%eax),%eax
  100566:	8d 50 ff             	lea    -0x1(%eax),%edx
  100569:	8b 45 10             	mov    0x10(%ebp),%eax
  10056c:	89 10                	mov    %edx,(%eax)
  10056e:	eb 3f                	jmp    1005af <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  100570:	8b 45 10             	mov    0x10(%ebp),%eax
  100573:	8b 00                	mov    (%eax),%eax
  100575:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100578:	eb 04                	jmp    10057e <stab_binsearch+0x123>
  10057a:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  10057e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100581:	8b 00                	mov    (%eax),%eax
  100583:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100586:	7d 1f                	jge    1005a7 <stab_binsearch+0x14c>
  100588:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10058b:	89 d0                	mov    %edx,%eax
  10058d:	01 c0                	add    %eax,%eax
  10058f:	01 d0                	add    %edx,%eax
  100591:	c1 e0 02             	shl    $0x2,%eax
  100594:	89 c2                	mov    %eax,%edx
  100596:	8b 45 08             	mov    0x8(%ebp),%eax
  100599:	01 d0                	add    %edx,%eax
  10059b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10059f:	0f b6 c0             	movzbl %al,%eax
  1005a2:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005a5:	75 d3                	jne    10057a <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005ad:	89 10                	mov    %edx,(%eax)
    }
}
  1005af:	c9                   	leave  
  1005b0:	c3                   	ret    

001005b1 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005b1:	55                   	push   %ebp
  1005b2:	89 e5                	mov    %esp,%ebp
  1005b4:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ba:	c7 00 68 35 10 00    	movl   $0x103568,(%eax)
    info->eip_line = 0;
  1005c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005cd:	c7 40 08 68 35 10 00 	movl   $0x103568,0x8(%eax)
    info->eip_fn_namelen = 9;
  1005d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d7:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  1005de:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e1:	8b 55 08             	mov    0x8(%ebp),%edx
  1005e4:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  1005e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ea:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  1005f1:	c7 45 f4 8c 3d 10 00 	movl   $0x103d8c,-0xc(%ebp)
    stab_end = __STAB_END__;
  1005f8:	c7 45 f0 98 b5 10 00 	movl   $0x10b598,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  1005ff:	c7 45 ec 99 b5 10 00 	movl   $0x10b599,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100606:	c7 45 e8 e7 d7 10 00 	movl   $0x10d7e7,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10060d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100610:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100613:	76 0d                	jbe    100622 <debuginfo_eip+0x71>
  100615:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100618:	83 e8 01             	sub    $0x1,%eax
  10061b:	0f b6 00             	movzbl (%eax),%eax
  10061e:	84 c0                	test   %al,%al
  100620:	74 0a                	je     10062c <debuginfo_eip+0x7b>
        return -1;
  100622:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100627:	e9 c0 02 00 00       	jmp    1008ec <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  10062c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100633:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100639:	29 c2                	sub    %eax,%edx
  10063b:	89 d0                	mov    %edx,%eax
  10063d:	c1 f8 02             	sar    $0x2,%eax
  100640:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100646:	83 e8 01             	sub    $0x1,%eax
  100649:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  10064c:	8b 45 08             	mov    0x8(%ebp),%eax
  10064f:	89 44 24 10          	mov    %eax,0x10(%esp)
  100653:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  10065a:	00 
  10065b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10065e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100662:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100665:	89 44 24 04          	mov    %eax,0x4(%esp)
  100669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10066c:	89 04 24             	mov    %eax,(%esp)
  10066f:	e8 e7 fd ff ff       	call   10045b <stab_binsearch>
    if (lfile == 0)
  100674:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100677:	85 c0                	test   %eax,%eax
  100679:	75 0a                	jne    100685 <debuginfo_eip+0xd4>
        return -1;
  10067b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100680:	e9 67 02 00 00       	jmp    1008ec <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100685:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100688:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10068b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10068e:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100691:	8b 45 08             	mov    0x8(%ebp),%eax
  100694:	89 44 24 10          	mov    %eax,0x10(%esp)
  100698:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  10069f:	00 
  1006a0:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006a7:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006b1:	89 04 24             	mov    %eax,(%esp)
  1006b4:	e8 a2 fd ff ff       	call   10045b <stab_binsearch>

    if (lfun <= rfun) {
  1006b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006bf:	39 c2                	cmp    %eax,%edx
  1006c1:	7f 7c                	jg     10073f <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006c6:	89 c2                	mov    %eax,%edx
  1006c8:	89 d0                	mov    %edx,%eax
  1006ca:	01 c0                	add    %eax,%eax
  1006cc:	01 d0                	add    %edx,%eax
  1006ce:	c1 e0 02             	shl    $0x2,%eax
  1006d1:	89 c2                	mov    %eax,%edx
  1006d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006d6:	01 d0                	add    %edx,%eax
  1006d8:	8b 10                	mov    (%eax),%edx
  1006da:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1006e0:	29 c1                	sub    %eax,%ecx
  1006e2:	89 c8                	mov    %ecx,%eax
  1006e4:	39 c2                	cmp    %eax,%edx
  1006e6:	73 22                	jae    10070a <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  1006e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006eb:	89 c2                	mov    %eax,%edx
  1006ed:	89 d0                	mov    %edx,%eax
  1006ef:	01 c0                	add    %eax,%eax
  1006f1:	01 d0                	add    %edx,%eax
  1006f3:	c1 e0 02             	shl    $0x2,%eax
  1006f6:	89 c2                	mov    %eax,%edx
  1006f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006fb:	01 d0                	add    %edx,%eax
  1006fd:	8b 10                	mov    (%eax),%edx
  1006ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100702:	01 c2                	add    %eax,%edx
  100704:	8b 45 0c             	mov    0xc(%ebp),%eax
  100707:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10070a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10070d:	89 c2                	mov    %eax,%edx
  10070f:	89 d0                	mov    %edx,%eax
  100711:	01 c0                	add    %eax,%eax
  100713:	01 d0                	add    %edx,%eax
  100715:	c1 e0 02             	shl    $0x2,%eax
  100718:	89 c2                	mov    %eax,%edx
  10071a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071d:	01 d0                	add    %edx,%eax
  10071f:	8b 50 08             	mov    0x8(%eax),%edx
  100722:	8b 45 0c             	mov    0xc(%ebp),%eax
  100725:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100728:	8b 45 0c             	mov    0xc(%ebp),%eax
  10072b:	8b 40 10             	mov    0x10(%eax),%eax
  10072e:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100731:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100734:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100737:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10073a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10073d:	eb 15                	jmp    100754 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  10073f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100742:	8b 55 08             	mov    0x8(%ebp),%edx
  100745:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10074b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  10074e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100751:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  100754:	8b 45 0c             	mov    0xc(%ebp),%eax
  100757:	8b 40 08             	mov    0x8(%eax),%eax
  10075a:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  100761:	00 
  100762:	89 04 24             	mov    %eax,(%esp)
  100765:	e8 66 23 00 00       	call   102ad0 <strfind>
  10076a:	89 c2                	mov    %eax,%edx
  10076c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076f:	8b 40 08             	mov    0x8(%eax),%eax
  100772:	29 c2                	sub    %eax,%edx
  100774:	8b 45 0c             	mov    0xc(%ebp),%eax
  100777:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10077a:	8b 45 08             	mov    0x8(%ebp),%eax
  10077d:	89 44 24 10          	mov    %eax,0x10(%esp)
  100781:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  100788:	00 
  100789:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10078c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100790:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100793:	89 44 24 04          	mov    %eax,0x4(%esp)
  100797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079a:	89 04 24             	mov    %eax,(%esp)
  10079d:	e8 b9 fc ff ff       	call   10045b <stab_binsearch>
    if (lline <= rline) {
  1007a2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007a5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007a8:	39 c2                	cmp    %eax,%edx
  1007aa:	7f 24                	jg     1007d0 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  1007ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007af:	89 c2                	mov    %eax,%edx
  1007b1:	89 d0                	mov    %edx,%eax
  1007b3:	01 c0                	add    %eax,%eax
  1007b5:	01 d0                	add    %edx,%eax
  1007b7:	c1 e0 02             	shl    $0x2,%eax
  1007ba:	89 c2                	mov    %eax,%edx
  1007bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bf:	01 d0                	add    %edx,%eax
  1007c1:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007c5:	0f b7 d0             	movzwl %ax,%edx
  1007c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007cb:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007ce:	eb 13                	jmp    1007e3 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  1007d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007d5:	e9 12 01 00 00       	jmp    1008ec <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007dd:	83 e8 01             	sub    $0x1,%eax
  1007e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007e3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007e9:	39 c2                	cmp    %eax,%edx
  1007eb:	7c 56                	jl     100843 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  1007ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f0:	89 c2                	mov    %eax,%edx
  1007f2:	89 d0                	mov    %edx,%eax
  1007f4:	01 c0                	add    %eax,%eax
  1007f6:	01 d0                	add    %edx,%eax
  1007f8:	c1 e0 02             	shl    $0x2,%eax
  1007fb:	89 c2                	mov    %eax,%edx
  1007fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100800:	01 d0                	add    %edx,%eax
  100802:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100806:	3c 84                	cmp    $0x84,%al
  100808:	74 39                	je     100843 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10080a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10080d:	89 c2                	mov    %eax,%edx
  10080f:	89 d0                	mov    %edx,%eax
  100811:	01 c0                	add    %eax,%eax
  100813:	01 d0                	add    %edx,%eax
  100815:	c1 e0 02             	shl    $0x2,%eax
  100818:	89 c2                	mov    %eax,%edx
  10081a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10081d:	01 d0                	add    %edx,%eax
  10081f:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100823:	3c 64                	cmp    $0x64,%al
  100825:	75 b3                	jne    1007da <debuginfo_eip+0x229>
  100827:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10082a:	89 c2                	mov    %eax,%edx
  10082c:	89 d0                	mov    %edx,%eax
  10082e:	01 c0                	add    %eax,%eax
  100830:	01 d0                	add    %edx,%eax
  100832:	c1 e0 02             	shl    $0x2,%eax
  100835:	89 c2                	mov    %eax,%edx
  100837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10083a:	01 d0                	add    %edx,%eax
  10083c:	8b 40 08             	mov    0x8(%eax),%eax
  10083f:	85 c0                	test   %eax,%eax
  100841:	74 97                	je     1007da <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100843:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100846:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100849:	39 c2                	cmp    %eax,%edx
  10084b:	7c 46                	jl     100893 <debuginfo_eip+0x2e2>
  10084d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100850:	89 c2                	mov    %eax,%edx
  100852:	89 d0                	mov    %edx,%eax
  100854:	01 c0                	add    %eax,%eax
  100856:	01 d0                	add    %edx,%eax
  100858:	c1 e0 02             	shl    $0x2,%eax
  10085b:	89 c2                	mov    %eax,%edx
  10085d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100860:	01 d0                	add    %edx,%eax
  100862:	8b 10                	mov    (%eax),%edx
  100864:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100867:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10086a:	29 c1                	sub    %eax,%ecx
  10086c:	89 c8                	mov    %ecx,%eax
  10086e:	39 c2                	cmp    %eax,%edx
  100870:	73 21                	jae    100893 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100872:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100875:	89 c2                	mov    %eax,%edx
  100877:	89 d0                	mov    %edx,%eax
  100879:	01 c0                	add    %eax,%eax
  10087b:	01 d0                	add    %edx,%eax
  10087d:	c1 e0 02             	shl    $0x2,%eax
  100880:	89 c2                	mov    %eax,%edx
  100882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100885:	01 d0                	add    %edx,%eax
  100887:	8b 10                	mov    (%eax),%edx
  100889:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10088c:	01 c2                	add    %eax,%edx
  10088e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100891:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100893:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100896:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100899:	39 c2                	cmp    %eax,%edx
  10089b:	7d 4a                	jge    1008e7 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10089d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008a0:	83 c0 01             	add    $0x1,%eax
  1008a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008a6:	eb 18                	jmp    1008c0 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008ab:	8b 40 14             	mov    0x14(%eax),%eax
  1008ae:	8d 50 01             	lea    0x1(%eax),%edx
  1008b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008b4:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  1008b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008ba:	83 c0 01             	add    $0x1,%eax
  1008bd:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008c0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  1008c6:	39 c2                	cmp    %eax,%edx
  1008c8:	7d 1d                	jge    1008e7 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008cd:	89 c2                	mov    %eax,%edx
  1008cf:	89 d0                	mov    %edx,%eax
  1008d1:	01 c0                	add    %eax,%eax
  1008d3:	01 d0                	add    %edx,%eax
  1008d5:	c1 e0 02             	shl    $0x2,%eax
  1008d8:	89 c2                	mov    %eax,%edx
  1008da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008dd:	01 d0                	add    %edx,%eax
  1008df:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008e3:	3c a0                	cmp    $0xa0,%al
  1008e5:	74 c1                	je     1008a8 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  1008e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1008ec:	c9                   	leave  
  1008ed:	c3                   	ret    

001008ee <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  1008ee:	55                   	push   %ebp
  1008ef:	89 e5                	mov    %esp,%ebp
  1008f1:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  1008f4:	c7 04 24 72 35 10 00 	movl   $0x103572,(%esp)
  1008fb:	e8 48 f9 ff ff       	call   100248 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100900:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  100907:	00 
  100908:	c7 04 24 8b 35 10 00 	movl   $0x10358b,(%esp)
  10090f:	e8 34 f9 ff ff       	call   100248 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100914:	c7 44 24 04 66 34 10 	movl   $0x103466,0x4(%esp)
  10091b:	00 
  10091c:	c7 04 24 a3 35 10 00 	movl   $0x1035a3,(%esp)
  100923:	e8 20 f9 ff ff       	call   100248 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100928:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  10092f:	00 
  100930:	c7 04 24 bb 35 10 00 	movl   $0x1035bb,(%esp)
  100937:	e8 0c f9 ff ff       	call   100248 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  10093c:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  100943:	00 
  100944:	c7 04 24 d3 35 10 00 	movl   $0x1035d3,(%esp)
  10094b:	e8 f8 f8 ff ff       	call   100248 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100950:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  100955:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  10095b:	b8 00 00 10 00       	mov    $0x100000,%eax
  100960:	29 c2                	sub    %eax,%edx
  100962:	89 d0                	mov    %edx,%eax
  100964:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  10096a:	85 c0                	test   %eax,%eax
  10096c:	0f 48 c2             	cmovs  %edx,%eax
  10096f:	c1 f8 0a             	sar    $0xa,%eax
  100972:	89 44 24 04          	mov    %eax,0x4(%esp)
  100976:	c7 04 24 ec 35 10 00 	movl   $0x1035ec,(%esp)
  10097d:	e8 c6 f8 ff ff       	call   100248 <cprintf>
}
  100982:	c9                   	leave  
  100983:	c3                   	ret    

00100984 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100984:	55                   	push   %ebp
  100985:	89 e5                	mov    %esp,%ebp
  100987:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10098d:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100990:	89 44 24 04          	mov    %eax,0x4(%esp)
  100994:	8b 45 08             	mov    0x8(%ebp),%eax
  100997:	89 04 24             	mov    %eax,(%esp)
  10099a:	e8 12 fc ff ff       	call   1005b1 <debuginfo_eip>
  10099f:	85 c0                	test   %eax,%eax
  1009a1:	74 15                	je     1009b8 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1009a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009aa:	c7 04 24 16 36 10 00 	movl   $0x103616,(%esp)
  1009b1:	e8 92 f8 ff ff       	call   100248 <cprintf>
  1009b6:	eb 6d                	jmp    100a25 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009bf:	eb 1c                	jmp    1009dd <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009c7:	01 d0                	add    %edx,%eax
  1009c9:	0f b6 00             	movzbl (%eax),%eax
  1009cc:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009d5:	01 ca                	add    %ecx,%edx
  1009d7:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009d9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009e0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1009e3:	7f dc                	jg     1009c1 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  1009e5:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ee:	01 d0                	add    %edx,%eax
  1009f0:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  1009f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  1009f6:	8b 55 08             	mov    0x8(%ebp),%edx
  1009f9:	89 d1                	mov    %edx,%ecx
  1009fb:	29 c1                	sub    %eax,%ecx
  1009fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a00:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a03:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a07:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a0d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a11:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a15:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a19:	c7 04 24 32 36 10 00 	movl   $0x103632,(%esp)
  100a20:	e8 23 f8 ff ff       	call   100248 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  100a25:	c9                   	leave  
  100a26:	c3                   	ret    

00100a27 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a27:	55                   	push   %ebp
  100a28:	89 e5                	mov    %esp,%ebp
  100a2a:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a2d:	8b 45 04             	mov    0x4(%ebp),%eax
  100a30:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a33:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a36:	c9                   	leave  
  100a37:	c3                   	ret    

00100a38 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a38:	55                   	push   %ebp
  100a39:	89 e5                	mov    %esp,%ebp
  100a3b:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a3e:	89 e8                	mov    %ebp,%eax
  100a40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  100a43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp, eip;
    int arg_n, stack_depth, i;
     
    ebp = read_ebp();
  100a46:	89 45 f4             	mov    %eax,-0xc(%ebp)
    eip = read_eip();
  100a49:	e8 d9 ff ff ff       	call   100a27 <read_eip>
  100a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
    for( stack_depth = 0; ebp != 0 && stack_depth < STACKFRAME_DEPTH; stack_depth++ ) 
  100a51:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a58:	e9 80 00 00 00       	jmp    100add <print_stackframe+0xa5>
    { 
        cprintf( "ebp = 0x%08x eip = 0x%08x args: ", ebp, eip );
  100a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a60:	89 44 24 08          	mov    %eax,0x8(%esp)
  100a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a67:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a6b:	c7 04 24 44 36 10 00 	movl   $0x103644,(%esp)
  100a72:	e8 d1 f7 ff ff       	call   100248 <cprintf>
        
        for( i = 0; i < 4; i++ ) 
  100a77:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a7e:	eb 26                	jmp    100aa6 <print_stackframe+0x6e>
            cprintf( "0x%08x ", *( ( uint32_t * )( ebp + 8 + 4 * i ) ) );
  100a80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a83:	c1 e0 02             	shl    $0x2,%eax
  100a86:	89 c2                	mov    %eax,%edx
  100a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a8b:	01 d0                	add    %edx,%eax
  100a8d:	83 c0 08             	add    $0x8,%eax
  100a90:	8b 00                	mov    (%eax),%eax
  100a92:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a96:	c7 04 24 65 36 10 00 	movl   $0x103665,(%esp)
  100a9d:	e8 a6 f7 ff ff       	call   100248 <cprintf>
    
    for( stack_depth = 0; ebp != 0 && stack_depth < STACKFRAME_DEPTH; stack_depth++ ) 
    { 
        cprintf( "ebp = 0x%08x eip = 0x%08x args: ", ebp, eip );
        
        for( i = 0; i < 4; i++ ) 
  100aa2:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100aa6:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100aaa:	7e d4                	jle    100a80 <print_stackframe+0x48>
            cprintf( "0x%08x ", *( ( uint32_t * )( ebp + 8 + 4 * i ) ) );
        
        cprintf( "\n" );
  100aac:	c7 04 24 6d 36 10 00 	movl   $0x10366d,(%esp)
  100ab3:	e8 90 f7 ff ff       	call   100248 <cprintf>
        print_debuginfo( eip - 1 );
  100ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100abb:	83 e8 01             	sub    $0x1,%eax
  100abe:	89 04 24             	mov    %eax,(%esp)
  100ac1:	e8 be fe ff ff       	call   100984 <print_debuginfo>
        eip = *( ( uint32_t * )( ebp + 4 ) );
  100ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac9:	83 c0 04             	add    $0x4,%eax
  100acc:	8b 00                	mov    (%eax),%eax
  100ace:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = *( ( uint32_t * )( ebp ) );
  100ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ad4:	8b 00                	mov    (%eax),%eax
  100ad6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int arg_n, stack_depth, i;
     
    ebp = read_ebp();
    eip = read_eip();
    
    for( stack_depth = 0; ebp != 0 && stack_depth < STACKFRAME_DEPTH; stack_depth++ ) 
  100ad9:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100add:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ae1:	74 0a                	je     100aed <print_stackframe+0xb5>
  100ae3:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100ae7:	0f 8e 70 ff ff ff    	jle    100a5d <print_stackframe+0x25>
        cprintf( "\n" );
        print_debuginfo( eip - 1 );
        eip = *( ( uint32_t * )( ebp + 4 ) );
        ebp = *( ( uint32_t * )( ebp ) );
    }        
}
  100aed:	c9                   	leave  
  100aee:	c3                   	ret    

00100aef <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100aef:	55                   	push   %ebp
  100af0:	89 e5                	mov    %esp,%ebp
  100af2:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100af5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100afc:	eb 0c                	jmp    100b0a <parse+0x1b>
            *buf ++ = '\0';
  100afe:	8b 45 08             	mov    0x8(%ebp),%eax
  100b01:	8d 50 01             	lea    0x1(%eax),%edx
  100b04:	89 55 08             	mov    %edx,0x8(%ebp)
  100b07:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0d:	0f b6 00             	movzbl (%eax),%eax
  100b10:	84 c0                	test   %al,%al
  100b12:	74 1d                	je     100b31 <parse+0x42>
  100b14:	8b 45 08             	mov    0x8(%ebp),%eax
  100b17:	0f b6 00             	movzbl (%eax),%eax
  100b1a:	0f be c0             	movsbl %al,%eax
  100b1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b21:	c7 04 24 f0 36 10 00 	movl   $0x1036f0,(%esp)
  100b28:	e8 70 1f 00 00       	call   102a9d <strchr>
  100b2d:	85 c0                	test   %eax,%eax
  100b2f:	75 cd                	jne    100afe <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100b31:	8b 45 08             	mov    0x8(%ebp),%eax
  100b34:	0f b6 00             	movzbl (%eax),%eax
  100b37:	84 c0                	test   %al,%al
  100b39:	75 02                	jne    100b3d <parse+0x4e>
            break;
  100b3b:	eb 67                	jmp    100ba4 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b3d:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b41:	75 14                	jne    100b57 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b43:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100b4a:	00 
  100b4b:	c7 04 24 f5 36 10 00 	movl   $0x1036f5,(%esp)
  100b52:	e8 f1 f6 ff ff       	call   100248 <cprintf>
        }
        argv[argc ++] = buf;
  100b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b5a:	8d 50 01             	lea    0x1(%eax),%edx
  100b5d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b60:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b67:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b6a:	01 c2                	add    %eax,%edx
  100b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  100b6f:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b71:	eb 04                	jmp    100b77 <parse+0x88>
            buf ++;
  100b73:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b77:	8b 45 08             	mov    0x8(%ebp),%eax
  100b7a:	0f b6 00             	movzbl (%eax),%eax
  100b7d:	84 c0                	test   %al,%al
  100b7f:	74 1d                	je     100b9e <parse+0xaf>
  100b81:	8b 45 08             	mov    0x8(%ebp),%eax
  100b84:	0f b6 00             	movzbl (%eax),%eax
  100b87:	0f be c0             	movsbl %al,%eax
  100b8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b8e:	c7 04 24 f0 36 10 00 	movl   $0x1036f0,(%esp)
  100b95:	e8 03 1f 00 00       	call   102a9d <strchr>
  100b9a:	85 c0                	test   %eax,%eax
  100b9c:	74 d5                	je     100b73 <parse+0x84>
            buf ++;
        }
    }
  100b9e:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b9f:	e9 66 ff ff ff       	jmp    100b0a <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100ba7:	c9                   	leave  
  100ba8:	c3                   	ret    

00100ba9 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100ba9:	55                   	push   %ebp
  100baa:	89 e5                	mov    %esp,%ebp
  100bac:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100baf:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bb2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb9:	89 04 24             	mov    %eax,(%esp)
  100bbc:	e8 2e ff ff ff       	call   100aef <parse>
  100bc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bc4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bc8:	75 0a                	jne    100bd4 <runcmd+0x2b>
        return 0;
  100bca:	b8 00 00 00 00       	mov    $0x0,%eax
  100bcf:	e9 85 00 00 00       	jmp    100c59 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bd4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bdb:	eb 5c                	jmp    100c39 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100bdd:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100be0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100be3:	89 d0                	mov    %edx,%eax
  100be5:	01 c0                	add    %eax,%eax
  100be7:	01 d0                	add    %edx,%eax
  100be9:	c1 e0 02             	shl    $0x2,%eax
  100bec:	05 00 e0 10 00       	add    $0x10e000,%eax
  100bf1:	8b 00                	mov    (%eax),%eax
  100bf3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100bf7:	89 04 24             	mov    %eax,(%esp)
  100bfa:	e8 ff 1d 00 00       	call   1029fe <strcmp>
  100bff:	85 c0                	test   %eax,%eax
  100c01:	75 32                	jne    100c35 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c06:	89 d0                	mov    %edx,%eax
  100c08:	01 c0                	add    %eax,%eax
  100c0a:	01 d0                	add    %edx,%eax
  100c0c:	c1 e0 02             	shl    $0x2,%eax
  100c0f:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c14:	8b 40 08             	mov    0x8(%eax),%eax
  100c17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100c1a:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100c1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  100c20:	89 54 24 08          	mov    %edx,0x8(%esp)
  100c24:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100c27:	83 c2 04             	add    $0x4,%edx
  100c2a:	89 54 24 04          	mov    %edx,0x4(%esp)
  100c2e:	89 0c 24             	mov    %ecx,(%esp)
  100c31:	ff d0                	call   *%eax
  100c33:	eb 24                	jmp    100c59 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c35:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c3c:	83 f8 02             	cmp    $0x2,%eax
  100c3f:	76 9c                	jbe    100bdd <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c41:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c44:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c48:	c7 04 24 13 37 10 00 	movl   $0x103713,(%esp)
  100c4f:	e8 f4 f5 ff ff       	call   100248 <cprintf>
    return 0;
  100c54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c59:	c9                   	leave  
  100c5a:	c3                   	ret    

00100c5b <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c5b:	55                   	push   %ebp
  100c5c:	89 e5                	mov    %esp,%ebp
  100c5e:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c61:	c7 04 24 2c 37 10 00 	movl   $0x10372c,(%esp)
  100c68:	e8 db f5 ff ff       	call   100248 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c6d:	c7 04 24 54 37 10 00 	movl   $0x103754,(%esp)
  100c74:	e8 cf f5 ff ff       	call   100248 <cprintf>

    if (tf != NULL) {
  100c79:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c7d:	74 0b                	je     100c8a <kmonitor+0x2f>
        print_trapframe(tf);
  100c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  100c82:	89 04 24             	mov    %eax,(%esp)
  100c85:	e8 10 0d 00 00       	call   10199a <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c8a:	c7 04 24 79 37 10 00 	movl   $0x103779,(%esp)
  100c91:	e8 53 f6 ff ff       	call   1002e9 <readline>
  100c96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c9d:	74 18                	je     100cb7 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  100ca2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ca9:	89 04 24             	mov    %eax,(%esp)
  100cac:	e8 f8 fe ff ff       	call   100ba9 <runcmd>
  100cb1:	85 c0                	test   %eax,%eax
  100cb3:	79 02                	jns    100cb7 <kmonitor+0x5c>
                break;
  100cb5:	eb 02                	jmp    100cb9 <kmonitor+0x5e>
            }
        }
    }
  100cb7:	eb d1                	jmp    100c8a <kmonitor+0x2f>
}
  100cb9:	c9                   	leave  
  100cba:	c3                   	ret    

00100cbb <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cbb:	55                   	push   %ebp
  100cbc:	89 e5                	mov    %esp,%ebp
  100cbe:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cc1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100cc8:	eb 3f                	jmp    100d09 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100cca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ccd:	89 d0                	mov    %edx,%eax
  100ccf:	01 c0                	add    %eax,%eax
  100cd1:	01 d0                	add    %edx,%eax
  100cd3:	c1 e0 02             	shl    $0x2,%eax
  100cd6:	05 00 e0 10 00       	add    $0x10e000,%eax
  100cdb:	8b 48 04             	mov    0x4(%eax),%ecx
  100cde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ce1:	89 d0                	mov    %edx,%eax
  100ce3:	01 c0                	add    %eax,%eax
  100ce5:	01 d0                	add    %edx,%eax
  100ce7:	c1 e0 02             	shl    $0x2,%eax
  100cea:	05 00 e0 10 00       	add    $0x10e000,%eax
  100cef:	8b 00                	mov    (%eax),%eax
  100cf1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100cf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf9:	c7 04 24 7d 37 10 00 	movl   $0x10377d,(%esp)
  100d00:	e8 43 f5 ff ff       	call   100248 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d05:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d0c:	83 f8 02             	cmp    $0x2,%eax
  100d0f:	76 b9                	jbe    100cca <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100d11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d16:	c9                   	leave  
  100d17:	c3                   	ret    

00100d18 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d18:	55                   	push   %ebp
  100d19:	89 e5                	mov    %esp,%ebp
  100d1b:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d1e:	e8 cb fb ff ff       	call   1008ee <print_kerninfo>
    return 0;
  100d23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d28:	c9                   	leave  
  100d29:	c3                   	ret    

00100d2a <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d2a:	55                   	push   %ebp
  100d2b:	89 e5                	mov    %esp,%ebp
  100d2d:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d30:	e8 03 fd ff ff       	call   100a38 <print_stackframe>
    return 0;
  100d35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d3a:	c9                   	leave  
  100d3b:	c3                   	ret    

00100d3c <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d3c:	55                   	push   %ebp
  100d3d:	89 e5                	mov    %esp,%ebp
  100d3f:	83 ec 28             	sub    $0x28,%esp
  100d42:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d48:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d4c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d50:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d54:	ee                   	out    %al,(%dx)
  100d55:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d5b:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d5f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d63:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d67:	ee                   	out    %al,(%dx)
  100d68:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d6e:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100d72:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d76:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d7a:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d7b:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100d82:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d85:	c7 04 24 86 37 10 00 	movl   $0x103786,(%esp)
  100d8c:	e8 b7 f4 ff ff       	call   100248 <cprintf>
    pic_enable(IRQ_TIMER);
  100d91:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d98:	e8 b5 08 00 00       	call   101652 <pic_enable>
}
  100d9d:	c9                   	leave  
  100d9e:	c3                   	ret    

00100d9f <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100d9f:	55                   	push   %ebp
  100da0:	89 e5                	mov    %esp,%ebp
  100da2:	83 ec 10             	sub    $0x10,%esp
  100da5:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dab:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100daf:	89 c2                	mov    %eax,%edx
  100db1:	ec                   	in     (%dx),%al
  100db2:	88 45 fd             	mov    %al,-0x3(%ebp)
  100db5:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dbb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dbf:	89 c2                	mov    %eax,%edx
  100dc1:	ec                   	in     (%dx),%al
  100dc2:	88 45 f9             	mov    %al,-0x7(%ebp)
  100dc5:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100dcb:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100dcf:	89 c2                	mov    %eax,%edx
  100dd1:	ec                   	in     (%dx),%al
  100dd2:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dd5:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100ddb:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ddf:	89 c2                	mov    %eax,%edx
  100de1:	ec                   	in     (%dx),%al
  100de2:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100de5:	c9                   	leave  
  100de6:	c3                   	ret    

00100de7 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100de7:	55                   	push   %ebp
  100de8:	89 e5                	mov    %esp,%ebp
  100dea:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100ded:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100df4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100df7:	0f b7 00             	movzwl (%eax),%eax
  100dfa:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100dfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e01:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e09:	0f b7 00             	movzwl (%eax),%eax
  100e0c:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e10:	74 12                	je     100e24 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e12:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e19:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e20:	b4 03 
  100e22:	eb 13                	jmp    100e37 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e27:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e2b:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e2e:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e35:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e37:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e3e:	0f b7 c0             	movzwl %ax,%eax
  100e41:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e45:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e49:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e4d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e51:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e52:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e59:	83 c0 01             	add    $0x1,%eax
  100e5c:	0f b7 c0             	movzwl %ax,%eax
  100e5f:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e63:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e67:	89 c2                	mov    %eax,%edx
  100e69:	ec                   	in     (%dx),%al
  100e6a:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e6d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e71:	0f b6 c0             	movzbl %al,%eax
  100e74:	c1 e0 08             	shl    $0x8,%eax
  100e77:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e7a:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e81:	0f b7 c0             	movzwl %ax,%eax
  100e84:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100e88:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e8c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100e90:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e94:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100e95:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e9c:	83 c0 01             	add    $0x1,%eax
  100e9f:	0f b7 c0             	movzwl %ax,%eax
  100ea2:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ea6:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100eaa:	89 c2                	mov    %eax,%edx
  100eac:	ec                   	in     (%dx),%al
  100ead:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100eb0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100eb4:	0f b6 c0             	movzbl %al,%eax
  100eb7:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100eba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ebd:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ec5:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ecb:	c9                   	leave  
  100ecc:	c3                   	ret    

00100ecd <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ecd:	55                   	push   %ebp
  100ece:	89 e5                	mov    %esp,%ebp
  100ed0:	83 ec 48             	sub    $0x48,%esp
  100ed3:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100ed9:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100edd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100ee1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100ee5:	ee                   	out    %al,(%dx)
  100ee6:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100eec:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100ef0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ef4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ef8:	ee                   	out    %al,(%dx)
  100ef9:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100eff:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f03:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f07:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f0b:	ee                   	out    %al,(%dx)
  100f0c:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f12:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f16:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f1a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f1e:	ee                   	out    %al,(%dx)
  100f1f:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f25:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f29:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f2d:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f31:	ee                   	out    %al,(%dx)
  100f32:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f38:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f3c:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f40:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f44:	ee                   	out    %al,(%dx)
  100f45:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f4b:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f4f:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f53:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f57:	ee                   	out    %al,(%dx)
  100f58:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f5e:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f62:	89 c2                	mov    %eax,%edx
  100f64:	ec                   	in     (%dx),%al
  100f65:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f68:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f6c:	3c ff                	cmp    $0xff,%al
  100f6e:	0f 95 c0             	setne  %al
  100f71:	0f b6 c0             	movzbl %al,%eax
  100f74:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f79:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f7f:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100f83:	89 c2                	mov    %eax,%edx
  100f85:	ec                   	in     (%dx),%al
  100f86:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100f89:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100f8f:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100f93:	89 c2                	mov    %eax,%edx
  100f95:	ec                   	in     (%dx),%al
  100f96:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100f99:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100f9e:	85 c0                	test   %eax,%eax
  100fa0:	74 0c                	je     100fae <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fa2:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fa9:	e8 a4 06 00 00       	call   101652 <pic_enable>
    }
}
  100fae:	c9                   	leave  
  100faf:	c3                   	ret    

00100fb0 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fb0:	55                   	push   %ebp
  100fb1:	89 e5                	mov    %esp,%ebp
  100fb3:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fbd:	eb 09                	jmp    100fc8 <lpt_putc_sub+0x18>
        delay();
  100fbf:	e8 db fd ff ff       	call   100d9f <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fc4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fc8:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fce:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fd2:	89 c2                	mov    %eax,%edx
  100fd4:	ec                   	in     (%dx),%al
  100fd5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100fd8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100fdc:	84 c0                	test   %al,%al
  100fde:	78 09                	js     100fe9 <lpt_putc_sub+0x39>
  100fe0:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100fe7:	7e d6                	jle    100fbf <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  100fec:	0f b6 c0             	movzbl %al,%eax
  100fef:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  100ff5:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ff8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100ffc:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101000:	ee                   	out    %al,(%dx)
  101001:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101007:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10100b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10100f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101013:	ee                   	out    %al,(%dx)
  101014:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  10101a:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  10101e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101022:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101026:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101027:	c9                   	leave  
  101028:	c3                   	ret    

00101029 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101029:	55                   	push   %ebp
  10102a:	89 e5                	mov    %esp,%ebp
  10102c:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10102f:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101033:	74 0d                	je     101042 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101035:	8b 45 08             	mov    0x8(%ebp),%eax
  101038:	89 04 24             	mov    %eax,(%esp)
  10103b:	e8 70 ff ff ff       	call   100fb0 <lpt_putc_sub>
  101040:	eb 24                	jmp    101066 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101042:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101049:	e8 62 ff ff ff       	call   100fb0 <lpt_putc_sub>
        lpt_putc_sub(' ');
  10104e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101055:	e8 56 ff ff ff       	call   100fb0 <lpt_putc_sub>
        lpt_putc_sub('\b');
  10105a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101061:	e8 4a ff ff ff       	call   100fb0 <lpt_putc_sub>
    }
}
  101066:	c9                   	leave  
  101067:	c3                   	ret    

00101068 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101068:	55                   	push   %ebp
  101069:	89 e5                	mov    %esp,%ebp
  10106b:	53                   	push   %ebx
  10106c:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10106f:	8b 45 08             	mov    0x8(%ebp),%eax
  101072:	b0 00                	mov    $0x0,%al
  101074:	85 c0                	test   %eax,%eax
  101076:	75 07                	jne    10107f <cga_putc+0x17>
        c |= 0x0700;
  101078:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10107f:	8b 45 08             	mov    0x8(%ebp),%eax
  101082:	0f b6 c0             	movzbl %al,%eax
  101085:	83 f8 0a             	cmp    $0xa,%eax
  101088:	74 4c                	je     1010d6 <cga_putc+0x6e>
  10108a:	83 f8 0d             	cmp    $0xd,%eax
  10108d:	74 57                	je     1010e6 <cga_putc+0x7e>
  10108f:	83 f8 08             	cmp    $0x8,%eax
  101092:	0f 85 88 00 00 00    	jne    101120 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101098:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10109f:	66 85 c0             	test   %ax,%ax
  1010a2:	74 30                	je     1010d4 <cga_putc+0x6c>
            crt_pos --;
  1010a4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010ab:	83 e8 01             	sub    $0x1,%eax
  1010ae:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010b4:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010b9:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010c0:	0f b7 d2             	movzwl %dx,%edx
  1010c3:	01 d2                	add    %edx,%edx
  1010c5:	01 c2                	add    %eax,%edx
  1010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1010ca:	b0 00                	mov    $0x0,%al
  1010cc:	83 c8 20             	or     $0x20,%eax
  1010cf:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010d2:	eb 72                	jmp    101146 <cga_putc+0xde>
  1010d4:	eb 70                	jmp    101146 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  1010d6:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010dd:	83 c0 50             	add    $0x50,%eax
  1010e0:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010e6:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  1010ed:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  1010f4:	0f b7 c1             	movzwl %cx,%eax
  1010f7:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  1010fd:	c1 e8 10             	shr    $0x10,%eax
  101100:	89 c2                	mov    %eax,%edx
  101102:	66 c1 ea 06          	shr    $0x6,%dx
  101106:	89 d0                	mov    %edx,%eax
  101108:	c1 e0 02             	shl    $0x2,%eax
  10110b:	01 d0                	add    %edx,%eax
  10110d:	c1 e0 04             	shl    $0x4,%eax
  101110:	29 c1                	sub    %eax,%ecx
  101112:	89 ca                	mov    %ecx,%edx
  101114:	89 d8                	mov    %ebx,%eax
  101116:	29 d0                	sub    %edx,%eax
  101118:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10111e:	eb 26                	jmp    101146 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101120:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101126:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10112d:	8d 50 01             	lea    0x1(%eax),%edx
  101130:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101137:	0f b7 c0             	movzwl %ax,%eax
  10113a:	01 c0                	add    %eax,%eax
  10113c:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  10113f:	8b 45 08             	mov    0x8(%ebp),%eax
  101142:	66 89 02             	mov    %ax,(%edx)
        break;
  101145:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101146:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10114d:	66 3d cf 07          	cmp    $0x7cf,%ax
  101151:	76 5b                	jbe    1011ae <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101153:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101158:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10115e:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101163:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10116a:	00 
  10116b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10116f:	89 04 24             	mov    %eax,(%esp)
  101172:	e8 24 1b 00 00       	call   102c9b <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101177:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10117e:	eb 15                	jmp    101195 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101180:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101185:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101188:	01 d2                	add    %edx,%edx
  10118a:	01 d0                	add    %edx,%eax
  10118c:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101191:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101195:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10119c:	7e e2                	jle    101180 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  10119e:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011a5:	83 e8 50             	sub    $0x50,%eax
  1011a8:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011ae:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011b5:	0f b7 c0             	movzwl %ax,%eax
  1011b8:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011bc:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011c0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011c4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011c8:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011c9:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011d0:	66 c1 e8 08          	shr    $0x8,%ax
  1011d4:	0f b6 c0             	movzbl %al,%eax
  1011d7:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011de:	83 c2 01             	add    $0x1,%edx
  1011e1:	0f b7 d2             	movzwl %dx,%edx
  1011e4:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  1011e8:	88 45 ed             	mov    %al,-0x13(%ebp)
  1011eb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1011ef:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1011f3:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1011f4:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011fb:	0f b7 c0             	movzwl %ax,%eax
  1011fe:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101202:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101206:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10120a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10120e:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10120f:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101216:	0f b6 c0             	movzbl %al,%eax
  101219:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101220:	83 c2 01             	add    $0x1,%edx
  101223:	0f b7 d2             	movzwl %dx,%edx
  101226:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  10122a:	88 45 e5             	mov    %al,-0x1b(%ebp)
  10122d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101231:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101235:	ee                   	out    %al,(%dx)
}
  101236:	83 c4 34             	add    $0x34,%esp
  101239:	5b                   	pop    %ebx
  10123a:	5d                   	pop    %ebp
  10123b:	c3                   	ret    

0010123c <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10123c:	55                   	push   %ebp
  10123d:	89 e5                	mov    %esp,%ebp
  10123f:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101242:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101249:	eb 09                	jmp    101254 <serial_putc_sub+0x18>
        delay();
  10124b:	e8 4f fb ff ff       	call   100d9f <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101250:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101254:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10125a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10125e:	89 c2                	mov    %eax,%edx
  101260:	ec                   	in     (%dx),%al
  101261:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101264:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101268:	0f b6 c0             	movzbl %al,%eax
  10126b:	83 e0 20             	and    $0x20,%eax
  10126e:	85 c0                	test   %eax,%eax
  101270:	75 09                	jne    10127b <serial_putc_sub+0x3f>
  101272:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101279:	7e d0                	jle    10124b <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  10127b:	8b 45 08             	mov    0x8(%ebp),%eax
  10127e:	0f b6 c0             	movzbl %al,%eax
  101281:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101287:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10128a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10128e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101292:	ee                   	out    %al,(%dx)
}
  101293:	c9                   	leave  
  101294:	c3                   	ret    

00101295 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101295:	55                   	push   %ebp
  101296:	89 e5                	mov    %esp,%ebp
  101298:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10129b:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10129f:	74 0d                	je     1012ae <serial_putc+0x19>
        serial_putc_sub(c);
  1012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1012a4:	89 04 24             	mov    %eax,(%esp)
  1012a7:	e8 90 ff ff ff       	call   10123c <serial_putc_sub>
  1012ac:	eb 24                	jmp    1012d2 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012ae:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012b5:	e8 82 ff ff ff       	call   10123c <serial_putc_sub>
        serial_putc_sub(' ');
  1012ba:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012c1:	e8 76 ff ff ff       	call   10123c <serial_putc_sub>
        serial_putc_sub('\b');
  1012c6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012cd:	e8 6a ff ff ff       	call   10123c <serial_putc_sub>
    }
}
  1012d2:	c9                   	leave  
  1012d3:	c3                   	ret    

001012d4 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012d4:	55                   	push   %ebp
  1012d5:	89 e5                	mov    %esp,%ebp
  1012d7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012da:	eb 33                	jmp    10130f <cons_intr+0x3b>
        if (c != 0) {
  1012dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012e0:	74 2d                	je     10130f <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012e2:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012e7:	8d 50 01             	lea    0x1(%eax),%edx
  1012ea:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  1012f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012f3:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1012f9:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012fe:	3d 00 02 00 00       	cmp    $0x200,%eax
  101303:	75 0a                	jne    10130f <cons_intr+0x3b>
                cons.wpos = 0;
  101305:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  10130c:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10130f:	8b 45 08             	mov    0x8(%ebp),%eax
  101312:	ff d0                	call   *%eax
  101314:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101317:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10131b:	75 bf                	jne    1012dc <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10131d:	c9                   	leave  
  10131e:	c3                   	ret    

0010131f <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10131f:	55                   	push   %ebp
  101320:	89 e5                	mov    %esp,%ebp
  101322:	83 ec 10             	sub    $0x10,%esp
  101325:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10132b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10132f:	89 c2                	mov    %eax,%edx
  101331:	ec                   	in     (%dx),%al
  101332:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101335:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101339:	0f b6 c0             	movzbl %al,%eax
  10133c:	83 e0 01             	and    $0x1,%eax
  10133f:	85 c0                	test   %eax,%eax
  101341:	75 07                	jne    10134a <serial_proc_data+0x2b>
        return -1;
  101343:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101348:	eb 2a                	jmp    101374 <serial_proc_data+0x55>
  10134a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101350:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101354:	89 c2                	mov    %eax,%edx
  101356:	ec                   	in     (%dx),%al
  101357:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10135a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10135e:	0f b6 c0             	movzbl %al,%eax
  101361:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101364:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101368:	75 07                	jne    101371 <serial_proc_data+0x52>
        c = '\b';
  10136a:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101371:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101374:	c9                   	leave  
  101375:	c3                   	ret    

00101376 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101376:	55                   	push   %ebp
  101377:	89 e5                	mov    %esp,%ebp
  101379:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10137c:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101381:	85 c0                	test   %eax,%eax
  101383:	74 0c                	je     101391 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101385:	c7 04 24 1f 13 10 00 	movl   $0x10131f,(%esp)
  10138c:	e8 43 ff ff ff       	call   1012d4 <cons_intr>
    }
}
  101391:	c9                   	leave  
  101392:	c3                   	ret    

00101393 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101393:	55                   	push   %ebp
  101394:	89 e5                	mov    %esp,%ebp
  101396:	83 ec 38             	sub    $0x38,%esp
  101399:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10139f:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013a3:	89 c2                	mov    %eax,%edx
  1013a5:	ec                   	in     (%dx),%al
  1013a6:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013a9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013ad:	0f b6 c0             	movzbl %al,%eax
  1013b0:	83 e0 01             	and    $0x1,%eax
  1013b3:	85 c0                	test   %eax,%eax
  1013b5:	75 0a                	jne    1013c1 <kbd_proc_data+0x2e>
        return -1;
  1013b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013bc:	e9 59 01 00 00       	jmp    10151a <kbd_proc_data+0x187>
  1013c1:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013c7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013cb:	89 c2                	mov    %eax,%edx
  1013cd:	ec                   	in     (%dx),%al
  1013ce:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013d1:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013d5:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013d8:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013dc:	75 17                	jne    1013f5 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013de:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013e3:	83 c8 40             	or     $0x40,%eax
  1013e6:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  1013eb:	b8 00 00 00 00       	mov    $0x0,%eax
  1013f0:	e9 25 01 00 00       	jmp    10151a <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  1013f5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013f9:	84 c0                	test   %al,%al
  1013fb:	79 47                	jns    101444 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1013fd:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101402:	83 e0 40             	and    $0x40,%eax
  101405:	85 c0                	test   %eax,%eax
  101407:	75 09                	jne    101412 <kbd_proc_data+0x7f>
  101409:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10140d:	83 e0 7f             	and    $0x7f,%eax
  101410:	eb 04                	jmp    101416 <kbd_proc_data+0x83>
  101412:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101416:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101419:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10141d:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101424:	83 c8 40             	or     $0x40,%eax
  101427:	0f b6 c0             	movzbl %al,%eax
  10142a:	f7 d0                	not    %eax
  10142c:	89 c2                	mov    %eax,%edx
  10142e:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101433:	21 d0                	and    %edx,%eax
  101435:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  10143a:	b8 00 00 00 00       	mov    $0x0,%eax
  10143f:	e9 d6 00 00 00       	jmp    10151a <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101444:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101449:	83 e0 40             	and    $0x40,%eax
  10144c:	85 c0                	test   %eax,%eax
  10144e:	74 11                	je     101461 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101450:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101454:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101459:	83 e0 bf             	and    $0xffffffbf,%eax
  10145c:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101461:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101465:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10146c:	0f b6 d0             	movzbl %al,%edx
  10146f:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101474:	09 d0                	or     %edx,%eax
  101476:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  10147b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147f:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  101486:	0f b6 d0             	movzbl %al,%edx
  101489:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10148e:	31 d0                	xor    %edx,%eax
  101490:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  101495:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10149a:	83 e0 03             	and    $0x3,%eax
  10149d:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014a4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a8:	01 d0                	add    %edx,%eax
  1014aa:	0f b6 00             	movzbl (%eax),%eax
  1014ad:	0f b6 c0             	movzbl %al,%eax
  1014b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014b3:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014b8:	83 e0 08             	and    $0x8,%eax
  1014bb:	85 c0                	test   %eax,%eax
  1014bd:	74 22                	je     1014e1 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014bf:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014c3:	7e 0c                	jle    1014d1 <kbd_proc_data+0x13e>
  1014c5:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014c9:	7f 06                	jg     1014d1 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014cb:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014cf:	eb 10                	jmp    1014e1 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014d1:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014d5:	7e 0a                	jle    1014e1 <kbd_proc_data+0x14e>
  1014d7:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014db:	7f 04                	jg     1014e1 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014dd:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014e1:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014e6:	f7 d0                	not    %eax
  1014e8:	83 e0 06             	and    $0x6,%eax
  1014eb:	85 c0                	test   %eax,%eax
  1014ed:	75 28                	jne    101517 <kbd_proc_data+0x184>
  1014ef:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1014f6:	75 1f                	jne    101517 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  1014f8:	c7 04 24 a1 37 10 00 	movl   $0x1037a1,(%esp)
  1014ff:	e8 44 ed ff ff       	call   100248 <cprintf>
  101504:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10150a:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10150e:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101512:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101516:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101517:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10151a:	c9                   	leave  
  10151b:	c3                   	ret    

0010151c <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10151c:	55                   	push   %ebp
  10151d:	89 e5                	mov    %esp,%ebp
  10151f:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101522:	c7 04 24 93 13 10 00 	movl   $0x101393,(%esp)
  101529:	e8 a6 fd ff ff       	call   1012d4 <cons_intr>
}
  10152e:	c9                   	leave  
  10152f:	c3                   	ret    

00101530 <kbd_init>:

static void
kbd_init(void) {
  101530:	55                   	push   %ebp
  101531:	89 e5                	mov    %esp,%ebp
  101533:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101536:	e8 e1 ff ff ff       	call   10151c <kbd_intr>
    pic_enable(IRQ_KBD);
  10153b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101542:	e8 0b 01 00 00       	call   101652 <pic_enable>
}
  101547:	c9                   	leave  
  101548:	c3                   	ret    

00101549 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101549:	55                   	push   %ebp
  10154a:	89 e5                	mov    %esp,%ebp
  10154c:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  10154f:	e8 93 f8 ff ff       	call   100de7 <cga_init>
    serial_init();
  101554:	e8 74 f9 ff ff       	call   100ecd <serial_init>
    kbd_init();
  101559:	e8 d2 ff ff ff       	call   101530 <kbd_init>
    if (!serial_exists) {
  10155e:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101563:	85 c0                	test   %eax,%eax
  101565:	75 0c                	jne    101573 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101567:	c7 04 24 ad 37 10 00 	movl   $0x1037ad,(%esp)
  10156e:	e8 d5 ec ff ff       	call   100248 <cprintf>
    }
}
  101573:	c9                   	leave  
  101574:	c3                   	ret    

00101575 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101575:	55                   	push   %ebp
  101576:	89 e5                	mov    %esp,%ebp
  101578:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  10157b:	8b 45 08             	mov    0x8(%ebp),%eax
  10157e:	89 04 24             	mov    %eax,(%esp)
  101581:	e8 a3 fa ff ff       	call   101029 <lpt_putc>
    cga_putc(c);
  101586:	8b 45 08             	mov    0x8(%ebp),%eax
  101589:	89 04 24             	mov    %eax,(%esp)
  10158c:	e8 d7 fa ff ff       	call   101068 <cga_putc>
    serial_putc(c);
  101591:	8b 45 08             	mov    0x8(%ebp),%eax
  101594:	89 04 24             	mov    %eax,(%esp)
  101597:	e8 f9 fc ff ff       	call   101295 <serial_putc>
}
  10159c:	c9                   	leave  
  10159d:	c3                   	ret    

0010159e <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10159e:	55                   	push   %ebp
  10159f:	89 e5                	mov    %esp,%ebp
  1015a1:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015a4:	e8 cd fd ff ff       	call   101376 <serial_intr>
    kbd_intr();
  1015a9:	e8 6e ff ff ff       	call   10151c <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015ae:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015b4:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015b9:	39 c2                	cmp    %eax,%edx
  1015bb:	74 36                	je     1015f3 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015bd:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015c2:	8d 50 01             	lea    0x1(%eax),%edx
  1015c5:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015cb:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015d2:	0f b6 c0             	movzbl %al,%eax
  1015d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015d8:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015dd:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015e2:	75 0a                	jne    1015ee <cons_getc+0x50>
            cons.rpos = 0;
  1015e4:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  1015eb:	00 00 00 
        }
        return c;
  1015ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1015f1:	eb 05                	jmp    1015f8 <cons_getc+0x5a>
    }
    return 0;
  1015f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1015f8:	c9                   	leave  
  1015f9:	c3                   	ret    

001015fa <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1015fa:	55                   	push   %ebp
  1015fb:	89 e5                	mov    %esp,%ebp
  1015fd:	83 ec 14             	sub    $0x14,%esp
  101600:	8b 45 08             	mov    0x8(%ebp),%eax
  101603:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101607:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10160b:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101611:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101616:	85 c0                	test   %eax,%eax
  101618:	74 36                	je     101650 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  10161a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10161e:	0f b6 c0             	movzbl %al,%eax
  101621:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101627:	88 45 fd             	mov    %al,-0x3(%ebp)
  10162a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10162e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101632:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101633:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101637:	66 c1 e8 08          	shr    $0x8,%ax
  10163b:	0f b6 c0             	movzbl %al,%eax
  10163e:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101644:	88 45 f9             	mov    %al,-0x7(%ebp)
  101647:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10164b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10164f:	ee                   	out    %al,(%dx)
    }
}
  101650:	c9                   	leave  
  101651:	c3                   	ret    

00101652 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101652:	55                   	push   %ebp
  101653:	89 e5                	mov    %esp,%ebp
  101655:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101658:	8b 45 08             	mov    0x8(%ebp),%eax
  10165b:	ba 01 00 00 00       	mov    $0x1,%edx
  101660:	89 c1                	mov    %eax,%ecx
  101662:	d3 e2                	shl    %cl,%edx
  101664:	89 d0                	mov    %edx,%eax
  101666:	f7 d0                	not    %eax
  101668:	89 c2                	mov    %eax,%edx
  10166a:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  101671:	21 d0                	and    %edx,%eax
  101673:	0f b7 c0             	movzwl %ax,%eax
  101676:	89 04 24             	mov    %eax,(%esp)
  101679:	e8 7c ff ff ff       	call   1015fa <pic_setmask>
}
  10167e:	c9                   	leave  
  10167f:	c3                   	ret    

00101680 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101680:	55                   	push   %ebp
  101681:	89 e5                	mov    %esp,%ebp
  101683:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101686:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  10168d:	00 00 00 
  101690:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101696:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  10169a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10169e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016a2:	ee                   	out    %al,(%dx)
  1016a3:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016a9:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016ad:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016b1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016b5:	ee                   	out    %al,(%dx)
  1016b6:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016bc:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016c0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1016c4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1016c8:	ee                   	out    %al,(%dx)
  1016c9:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1016cf:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  1016d3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1016d7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1016db:	ee                   	out    %al,(%dx)
  1016dc:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1016e2:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1016e6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1016ea:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1016ee:	ee                   	out    %al,(%dx)
  1016ef:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1016f5:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1016f9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1016fd:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101701:	ee                   	out    %al,(%dx)
  101702:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101708:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  10170c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101710:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101714:	ee                   	out    %al,(%dx)
  101715:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  10171b:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  10171f:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101723:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101727:	ee                   	out    %al,(%dx)
  101728:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  10172e:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  101732:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101736:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10173a:	ee                   	out    %al,(%dx)
  10173b:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101741:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101745:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101749:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10174d:	ee                   	out    %al,(%dx)
  10174e:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101754:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101758:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10175c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101760:	ee                   	out    %al,(%dx)
  101761:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101767:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  10176b:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10176f:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101773:	ee                   	out    %al,(%dx)
  101774:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  10177a:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  10177e:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101782:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101786:	ee                   	out    %al,(%dx)
  101787:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  10178d:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101791:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101795:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101799:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10179a:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017a1:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017a5:	74 12                	je     1017b9 <pic_init+0x139>
        pic_setmask(irq_mask);
  1017a7:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017ae:	0f b7 c0             	movzwl %ax,%eax
  1017b1:	89 04 24             	mov    %eax,(%esp)
  1017b4:	e8 41 fe ff ff       	call   1015fa <pic_setmask>
    }
}
  1017b9:	c9                   	leave  
  1017ba:	c3                   	ret    

001017bb <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017bb:	55                   	push   %ebp
  1017bc:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1017be:	fb                   	sti    
    sti();
}
  1017bf:	5d                   	pop    %ebp
  1017c0:	c3                   	ret    

001017c1 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1017c1:	55                   	push   %ebp
  1017c2:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1017c4:	fa                   	cli    
    cli();
}
  1017c5:	5d                   	pop    %ebp
  1017c6:	c3                   	ret    

001017c7 <print_ticks>:
#include <kdebug.h>

#define TICK_NUM 100
extern volatile size_t ticks;

static void print_ticks() {
  1017c7:	55                   	push   %ebp
  1017c8:	89 e5                	mov    %esp,%ebp
  1017ca:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017cd:	83 ec 08             	sub    $0x8,%esp
  1017d0:	6a 64                	push   $0x64
  1017d2:	68 e0 37 10 00       	push   $0x1037e0
  1017d7:	e8 6c ea ff ff       	call   100248 <cprintf>
  1017dc:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1017df:	90                   	nop
  1017e0:	c9                   	leave  
  1017e1:	c3                   	ret    

001017e2 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1017e2:	55                   	push   %ebp
  1017e3:	89 e5                	mov    %esp,%ebp
  1017e5:	83 ec 10             	sub    $0x10,%esp
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i; 
    
    for( i = 0; i < 256; i++ )
  1017e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1017ef:	e9 c3 00 00 00       	jmp    1018b7 <idt_init+0xd5>
    {
        SETGATE( idt[ i ], 0, GD_KTEXT, __vectors[ i ], DPL_KERNEL ); 
  1017f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1017f7:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1017fe:	89 c2                	mov    %eax,%edx
  101800:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101803:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  10180a:	00 
  10180b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10180e:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101815:	00 08 00 
  101818:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10181b:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101822:	00 
  101823:	83 e2 e0             	and    $0xffffffe0,%edx
  101826:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10182d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101830:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101837:	00 
  101838:	83 e2 1f             	and    $0x1f,%edx
  10183b:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101842:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101845:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10184c:	00 
  10184d:	83 e2 f0             	and    $0xfffffff0,%edx
  101850:	83 ca 0e             	or     $0xe,%edx
  101853:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10185a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10185d:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101864:	00 
  101865:	83 e2 ef             	and    $0xffffffef,%edx
  101868:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10186f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101872:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101879:	00 
  10187a:	83 e2 9f             	and    $0xffffff9f,%edx
  10187d:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101884:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101887:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10188e:	00 
  10188f:	83 ca 80             	or     $0xffffff80,%edx
  101892:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101899:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10189c:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018a3:	c1 e8 10             	shr    $0x10,%eax
  1018a6:	89 c2                	mov    %eax,%edx
  1018a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ab:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018b2:	00 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i; 
    
    for( i = 0; i < 256; i++ )
  1018b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1018b7:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1018be:	0f 8e 30 ff ff ff    	jle    1017f4 <idt_init+0x12>
    {
        SETGATE( idt[ i ], 0, GD_KTEXT, __vectors[ i ], DPL_KERNEL ); 
    }

    SETGATE( idt[ T_SWITCH_TOK ], 0, GD_KTEXT, __vectors[ T_SWITCH_TOK ], DPL_USER ); 
  1018c4:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  1018c9:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  1018cf:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  1018d6:	08 00 
  1018d8:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  1018df:	83 e0 e0             	and    $0xffffffe0,%eax
  1018e2:	a2 6c f4 10 00       	mov    %al,0x10f46c
  1018e7:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  1018ee:	83 e0 1f             	and    $0x1f,%eax
  1018f1:	a2 6c f4 10 00       	mov    %al,0x10f46c
  1018f6:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  1018fd:	83 e0 f0             	and    $0xfffffff0,%eax
  101900:	83 c8 0e             	or     $0xe,%eax
  101903:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101908:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10190f:	83 e0 ef             	and    $0xffffffef,%eax
  101912:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101917:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10191e:	83 c8 60             	or     $0x60,%eax
  101921:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101926:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10192d:	83 c8 80             	or     $0xffffff80,%eax
  101930:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101935:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  10193a:	c1 e8 10             	shr    $0x10,%eax
  10193d:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  101943:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  10194a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10194d:	0f 01 18             	lidtl  (%eax)
    lidt( &idt_pd );
}
  101950:	90                   	nop
  101951:	c9                   	leave  
  101952:	c3                   	ret    

00101953 <trapname>:

static const char *
trapname(int trapno) {
  101953:	55                   	push   %ebp
  101954:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101956:	8b 45 08             	mov    0x8(%ebp),%eax
  101959:	83 f8 13             	cmp    $0x13,%eax
  10195c:	77 0c                	ja     10196a <trapname+0x17>
        return excnames[trapno];
  10195e:	8b 45 08             	mov    0x8(%ebp),%eax
  101961:	8b 04 85 40 3b 10 00 	mov    0x103b40(,%eax,4),%eax
  101968:	eb 18                	jmp    101982 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  10196a:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  10196e:	7e 0d                	jle    10197d <trapname+0x2a>
  101970:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101974:	7f 07                	jg     10197d <trapname+0x2a>
        return "Hardware Interrupt";
  101976:	b8 ea 37 10 00       	mov    $0x1037ea,%eax
  10197b:	eb 05                	jmp    101982 <trapname+0x2f>
    }
    return "(unknown trap)";
  10197d:	b8 fd 37 10 00       	mov    $0x1037fd,%eax
}
  101982:	5d                   	pop    %ebp
  101983:	c3                   	ret    

00101984 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101984:	55                   	push   %ebp
  101985:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101987:	8b 45 08             	mov    0x8(%ebp),%eax
  10198a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10198e:	66 83 f8 08          	cmp    $0x8,%ax
  101992:	0f 94 c0             	sete   %al
  101995:	0f b6 c0             	movzbl %al,%eax
}
  101998:	5d                   	pop    %ebp
  101999:	c3                   	ret    

0010199a <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  10199a:	55                   	push   %ebp
  10199b:	89 e5                	mov    %esp,%ebp
  10199d:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  1019a0:	83 ec 08             	sub    $0x8,%esp
  1019a3:	ff 75 08             	pushl  0x8(%ebp)
  1019a6:	68 3e 38 10 00       	push   $0x10383e
  1019ab:	e8 98 e8 ff ff       	call   100248 <cprintf>
  1019b0:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  1019b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b6:	83 ec 0c             	sub    $0xc,%esp
  1019b9:	50                   	push   %eax
  1019ba:	e8 b8 01 00 00       	call   101b77 <print_regs>
  1019bf:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  1019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c5:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  1019c9:	0f b7 c0             	movzwl %ax,%eax
  1019cc:	83 ec 08             	sub    $0x8,%esp
  1019cf:	50                   	push   %eax
  1019d0:	68 4f 38 10 00       	push   $0x10384f
  1019d5:	e8 6e e8 ff ff       	call   100248 <cprintf>
  1019da:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  1019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e0:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  1019e4:	0f b7 c0             	movzwl %ax,%eax
  1019e7:	83 ec 08             	sub    $0x8,%esp
  1019ea:	50                   	push   %eax
  1019eb:	68 62 38 10 00       	push   $0x103862
  1019f0:	e8 53 e8 ff ff       	call   100248 <cprintf>
  1019f5:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  1019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1019fb:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  1019ff:	0f b7 c0             	movzwl %ax,%eax
  101a02:	83 ec 08             	sub    $0x8,%esp
  101a05:	50                   	push   %eax
  101a06:	68 75 38 10 00       	push   $0x103875
  101a0b:	e8 38 e8 ff ff       	call   100248 <cprintf>
  101a10:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a13:	8b 45 08             	mov    0x8(%ebp),%eax
  101a16:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a1a:	0f b7 c0             	movzwl %ax,%eax
  101a1d:	83 ec 08             	sub    $0x8,%esp
  101a20:	50                   	push   %eax
  101a21:	68 88 38 10 00       	push   $0x103888
  101a26:	e8 1d e8 ff ff       	call   100248 <cprintf>
  101a2b:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a31:	8b 40 30             	mov    0x30(%eax),%eax
  101a34:	83 ec 0c             	sub    $0xc,%esp
  101a37:	50                   	push   %eax
  101a38:	e8 16 ff ff ff       	call   101953 <trapname>
  101a3d:	83 c4 10             	add    $0x10,%esp
  101a40:	89 c2                	mov    %eax,%edx
  101a42:	8b 45 08             	mov    0x8(%ebp),%eax
  101a45:	8b 40 30             	mov    0x30(%eax),%eax
  101a48:	83 ec 04             	sub    $0x4,%esp
  101a4b:	52                   	push   %edx
  101a4c:	50                   	push   %eax
  101a4d:	68 9b 38 10 00       	push   $0x10389b
  101a52:	e8 f1 e7 ff ff       	call   100248 <cprintf>
  101a57:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a5d:	8b 40 34             	mov    0x34(%eax),%eax
  101a60:	83 ec 08             	sub    $0x8,%esp
  101a63:	50                   	push   %eax
  101a64:	68 ad 38 10 00       	push   $0x1038ad
  101a69:	e8 da e7 ff ff       	call   100248 <cprintf>
  101a6e:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101a71:	8b 45 08             	mov    0x8(%ebp),%eax
  101a74:	8b 40 38             	mov    0x38(%eax),%eax
  101a77:	83 ec 08             	sub    $0x8,%esp
  101a7a:	50                   	push   %eax
  101a7b:	68 bc 38 10 00       	push   $0x1038bc
  101a80:	e8 c3 e7 ff ff       	call   100248 <cprintf>
  101a85:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101a88:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a8f:	0f b7 c0             	movzwl %ax,%eax
  101a92:	83 ec 08             	sub    $0x8,%esp
  101a95:	50                   	push   %eax
  101a96:	68 cb 38 10 00       	push   $0x1038cb
  101a9b:	e8 a8 e7 ff ff       	call   100248 <cprintf>
  101aa0:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa6:	8b 40 40             	mov    0x40(%eax),%eax
  101aa9:	83 ec 08             	sub    $0x8,%esp
  101aac:	50                   	push   %eax
  101aad:	68 de 38 10 00       	push   $0x1038de
  101ab2:	e8 91 e7 ff ff       	call   100248 <cprintf>
  101ab7:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101aba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101ac1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ac8:	eb 3f                	jmp    101b09 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101aca:	8b 45 08             	mov    0x8(%ebp),%eax
  101acd:	8b 50 40             	mov    0x40(%eax),%edx
  101ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ad3:	21 d0                	and    %edx,%eax
  101ad5:	85 c0                	test   %eax,%eax
  101ad7:	74 29                	je     101b02 <print_trapframe+0x168>
  101ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101adc:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101ae3:	85 c0                	test   %eax,%eax
  101ae5:	74 1b                	je     101b02 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101aea:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101af1:	83 ec 08             	sub    $0x8,%esp
  101af4:	50                   	push   %eax
  101af5:	68 ed 38 10 00       	push   $0x1038ed
  101afa:	e8 49 e7 ff ff       	call   100248 <cprintf>
  101aff:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b02:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b06:	d1 65 f0             	shll   -0x10(%ebp)
  101b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b0c:	83 f8 17             	cmp    $0x17,%eax
  101b0f:	76 b9                	jbe    101aca <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b11:	8b 45 08             	mov    0x8(%ebp),%eax
  101b14:	8b 40 40             	mov    0x40(%eax),%eax
  101b17:	25 00 30 00 00       	and    $0x3000,%eax
  101b1c:	c1 e8 0c             	shr    $0xc,%eax
  101b1f:	83 ec 08             	sub    $0x8,%esp
  101b22:	50                   	push   %eax
  101b23:	68 f1 38 10 00       	push   $0x1038f1
  101b28:	e8 1b e7 ff ff       	call   100248 <cprintf>
  101b2d:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101b30:	83 ec 0c             	sub    $0xc,%esp
  101b33:	ff 75 08             	pushl  0x8(%ebp)
  101b36:	e8 49 fe ff ff       	call   101984 <trap_in_kernel>
  101b3b:	83 c4 10             	add    $0x10,%esp
  101b3e:	85 c0                	test   %eax,%eax
  101b40:	75 32                	jne    101b74 <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b42:	8b 45 08             	mov    0x8(%ebp),%eax
  101b45:	8b 40 44             	mov    0x44(%eax),%eax
  101b48:	83 ec 08             	sub    $0x8,%esp
  101b4b:	50                   	push   %eax
  101b4c:	68 fa 38 10 00       	push   $0x1038fa
  101b51:	e8 f2 e6 ff ff       	call   100248 <cprintf>
  101b56:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b59:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5c:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b60:	0f b7 c0             	movzwl %ax,%eax
  101b63:	83 ec 08             	sub    $0x8,%esp
  101b66:	50                   	push   %eax
  101b67:	68 09 39 10 00       	push   $0x103909
  101b6c:	e8 d7 e6 ff ff       	call   100248 <cprintf>
  101b71:	83 c4 10             	add    $0x10,%esp
    }
}
  101b74:	90                   	nop
  101b75:	c9                   	leave  
  101b76:	c3                   	ret    

00101b77 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101b77:	55                   	push   %ebp
  101b78:	89 e5                	mov    %esp,%ebp
  101b7a:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b80:	8b 00                	mov    (%eax),%eax
  101b82:	83 ec 08             	sub    $0x8,%esp
  101b85:	50                   	push   %eax
  101b86:	68 1c 39 10 00       	push   $0x10391c
  101b8b:	e8 b8 e6 ff ff       	call   100248 <cprintf>
  101b90:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101b93:	8b 45 08             	mov    0x8(%ebp),%eax
  101b96:	8b 40 04             	mov    0x4(%eax),%eax
  101b99:	83 ec 08             	sub    $0x8,%esp
  101b9c:	50                   	push   %eax
  101b9d:	68 2b 39 10 00       	push   $0x10392b
  101ba2:	e8 a1 e6 ff ff       	call   100248 <cprintf>
  101ba7:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101baa:	8b 45 08             	mov    0x8(%ebp),%eax
  101bad:	8b 40 08             	mov    0x8(%eax),%eax
  101bb0:	83 ec 08             	sub    $0x8,%esp
  101bb3:	50                   	push   %eax
  101bb4:	68 3a 39 10 00       	push   $0x10393a
  101bb9:	e8 8a e6 ff ff       	call   100248 <cprintf>
  101bbe:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc4:	8b 40 0c             	mov    0xc(%eax),%eax
  101bc7:	83 ec 08             	sub    $0x8,%esp
  101bca:	50                   	push   %eax
  101bcb:	68 49 39 10 00       	push   $0x103949
  101bd0:	e8 73 e6 ff ff       	call   100248 <cprintf>
  101bd5:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bdb:	8b 40 10             	mov    0x10(%eax),%eax
  101bde:	83 ec 08             	sub    $0x8,%esp
  101be1:	50                   	push   %eax
  101be2:	68 58 39 10 00       	push   $0x103958
  101be7:	e8 5c e6 ff ff       	call   100248 <cprintf>
  101bec:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101bef:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf2:	8b 40 14             	mov    0x14(%eax),%eax
  101bf5:	83 ec 08             	sub    $0x8,%esp
  101bf8:	50                   	push   %eax
  101bf9:	68 67 39 10 00       	push   $0x103967
  101bfe:	e8 45 e6 ff ff       	call   100248 <cprintf>
  101c03:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c06:	8b 45 08             	mov    0x8(%ebp),%eax
  101c09:	8b 40 18             	mov    0x18(%eax),%eax
  101c0c:	83 ec 08             	sub    $0x8,%esp
  101c0f:	50                   	push   %eax
  101c10:	68 76 39 10 00       	push   $0x103976
  101c15:	e8 2e e6 ff ff       	call   100248 <cprintf>
  101c1a:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c20:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c23:	83 ec 08             	sub    $0x8,%esp
  101c26:	50                   	push   %eax
  101c27:	68 85 39 10 00       	push   $0x103985
  101c2c:	e8 17 e6 ff ff       	call   100248 <cprintf>
  101c31:	83 c4 10             	add    $0x10,%esp
}
  101c34:	90                   	nop
  101c35:	c9                   	leave  
  101c36:	c3                   	ret    

00101c37 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c37:	55                   	push   %ebp
  101c38:	89 e5                	mov    %esp,%ebp
  101c3a:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
  101c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c40:	8b 40 30             	mov    0x30(%eax),%eax
  101c43:	83 f8 2f             	cmp    $0x2f,%eax
  101c46:	77 1d                	ja     101c65 <trap_dispatch+0x2e>
  101c48:	83 f8 2e             	cmp    $0x2e,%eax
  101c4b:	0f 83 ec 00 00 00    	jae    101d3d <trap_dispatch+0x106>
  101c51:	83 f8 21             	cmp    $0x21,%eax
  101c54:	74 76                	je     101ccc <trap_dispatch+0x95>
  101c56:	83 f8 24             	cmp    $0x24,%eax
  101c59:	74 4d                	je     101ca8 <trap_dispatch+0x71>
  101c5b:	83 f8 20             	cmp    $0x20,%eax
  101c5e:	74 39                	je     101c99 <trap_dispatch+0x62>
  101c60:	e9 a2 00 00 00       	jmp    101d07 <trap_dispatch+0xd0>
  101c65:	83 e8 78             	sub    $0x78,%eax
  101c68:	83 f8 01             	cmp    $0x1,%eax
  101c6b:	0f 87 96 00 00 00    	ja     101d07 <trap_dispatch+0xd0>
  101c71:	eb 7d                	jmp    101cf0 <trap_dispatch+0xb9>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        while( ticks < TICK_NUM )
        {
            ticks++;
  101c73:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101c78:	83 c0 01             	add    $0x1,%eax
  101c7b:	a3 08 f9 10 00       	mov    %eax,0x10f908
            if( ticks == TICK_NUM )
  101c80:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101c85:	83 f8 64             	cmp    $0x64,%eax
  101c88:	75 0a                	jne    101c94 <trap_dispatch+0x5d>
                ticks = 0;
  101c8a:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  101c91:	00 00 00 
            print_ticks(); 
  101c94:	e8 2e fb ff ff       	call   1017c7 <print_ticks>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        while( ticks < TICK_NUM )
  101c99:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101c9e:	83 f8 63             	cmp    $0x63,%eax
  101ca1:	76 d0                	jbe    101c73 <trap_dispatch+0x3c>
            ticks++;
            if( ticks == TICK_NUM )
                ticks = 0;
            print_ticks(); 
        }
        break;
  101ca3:	e9 96 00 00 00       	jmp    101d3e <trap_dispatch+0x107>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101ca8:	e8 f1 f8 ff ff       	call   10159e <cons_getc>
  101cad:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101cb0:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cb4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cb8:	83 ec 04             	sub    $0x4,%esp
  101cbb:	52                   	push   %edx
  101cbc:	50                   	push   %eax
  101cbd:	68 94 39 10 00       	push   $0x103994
  101cc2:	e8 81 e5 ff ff       	call   100248 <cprintf>
  101cc7:	83 c4 10             	add    $0x10,%esp
        break;
  101cca:	eb 72                	jmp    101d3e <trap_dispatch+0x107>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101ccc:	e8 cd f8 ff ff       	call   10159e <cons_getc>
  101cd1:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101cd4:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cd8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cdc:	83 ec 04             	sub    $0x4,%esp
  101cdf:	52                   	push   %edx
  101ce0:	50                   	push   %eax
  101ce1:	68 a6 39 10 00       	push   $0x1039a6
  101ce6:	e8 5d e5 ff ff       	call   100248 <cprintf>
  101ceb:	83 c4 10             	add    $0x10,%esp
        break;
  101cee:	eb 4e                	jmp    101d3e <trap_dispatch+0x107>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101cf0:	83 ec 04             	sub    $0x4,%esp
  101cf3:	68 b5 39 10 00       	push   $0x1039b5
  101cf8:	68 b4 00 00 00       	push   $0xb4
  101cfd:	68 c5 39 10 00       	push   $0x1039c5
  101d02:	e8 98 e6 ff ff       	call   10039f <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d07:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d0e:	0f b7 c0             	movzwl %ax,%eax
  101d11:	83 e0 03             	and    $0x3,%eax
  101d14:	85 c0                	test   %eax,%eax
  101d16:	75 26                	jne    101d3e <trap_dispatch+0x107>
            print_trapframe(tf);
  101d18:	83 ec 0c             	sub    $0xc,%esp
  101d1b:	ff 75 08             	pushl  0x8(%ebp)
  101d1e:	e8 77 fc ff ff       	call   10199a <print_trapframe>
  101d23:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101d26:	83 ec 04             	sub    $0x4,%esp
  101d29:	68 d6 39 10 00       	push   $0x1039d6
  101d2e:	68 be 00 00 00       	push   $0xbe
  101d33:	68 c5 39 10 00       	push   $0x1039c5
  101d38:	e8 62 e6 ff ff       	call   10039f <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101d3d:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101d3e:	90                   	nop
  101d3f:	c9                   	leave  
  101d40:	c3                   	ret    

00101d41 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d41:	55                   	push   %ebp
  101d42:	89 e5                	mov    %esp,%ebp
  101d44:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101d47:	83 ec 0c             	sub    $0xc,%esp
  101d4a:	ff 75 08             	pushl  0x8(%ebp)
  101d4d:	e8 e5 fe ff ff       	call   101c37 <trap_dispatch>
  101d52:	83 c4 10             	add    $0x10,%esp
}
  101d55:	90                   	nop
  101d56:	c9                   	leave  
  101d57:	c3                   	ret    

00101d58 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101d58:	6a 00                	push   $0x0
  pushl $0
  101d5a:	6a 00                	push   $0x0
  jmp __alltraps
  101d5c:	e9 67 0a 00 00       	jmp    1027c8 <__alltraps>

00101d61 <vector1>:
.globl vector1
vector1:
  pushl $0
  101d61:	6a 00                	push   $0x0
  pushl $1
  101d63:	6a 01                	push   $0x1
  jmp __alltraps
  101d65:	e9 5e 0a 00 00       	jmp    1027c8 <__alltraps>

00101d6a <vector2>:
.globl vector2
vector2:
  pushl $0
  101d6a:	6a 00                	push   $0x0
  pushl $2
  101d6c:	6a 02                	push   $0x2
  jmp __alltraps
  101d6e:	e9 55 0a 00 00       	jmp    1027c8 <__alltraps>

00101d73 <vector3>:
.globl vector3
vector3:
  pushl $0
  101d73:	6a 00                	push   $0x0
  pushl $3
  101d75:	6a 03                	push   $0x3
  jmp __alltraps
  101d77:	e9 4c 0a 00 00       	jmp    1027c8 <__alltraps>

00101d7c <vector4>:
.globl vector4
vector4:
  pushl $0
  101d7c:	6a 00                	push   $0x0
  pushl $4
  101d7e:	6a 04                	push   $0x4
  jmp __alltraps
  101d80:	e9 43 0a 00 00       	jmp    1027c8 <__alltraps>

00101d85 <vector5>:
.globl vector5
vector5:
  pushl $0
  101d85:	6a 00                	push   $0x0
  pushl $5
  101d87:	6a 05                	push   $0x5
  jmp __alltraps
  101d89:	e9 3a 0a 00 00       	jmp    1027c8 <__alltraps>

00101d8e <vector6>:
.globl vector6
vector6:
  pushl $0
  101d8e:	6a 00                	push   $0x0
  pushl $6
  101d90:	6a 06                	push   $0x6
  jmp __alltraps
  101d92:	e9 31 0a 00 00       	jmp    1027c8 <__alltraps>

00101d97 <vector7>:
.globl vector7
vector7:
  pushl $0
  101d97:	6a 00                	push   $0x0
  pushl $7
  101d99:	6a 07                	push   $0x7
  jmp __alltraps
  101d9b:	e9 28 0a 00 00       	jmp    1027c8 <__alltraps>

00101da0 <vector8>:
.globl vector8
vector8:
  pushl $8
  101da0:	6a 08                	push   $0x8
  jmp __alltraps
  101da2:	e9 21 0a 00 00       	jmp    1027c8 <__alltraps>

00101da7 <vector9>:
.globl vector9
vector9:
  pushl $9
  101da7:	6a 09                	push   $0x9
  jmp __alltraps
  101da9:	e9 1a 0a 00 00       	jmp    1027c8 <__alltraps>

00101dae <vector10>:
.globl vector10
vector10:
  pushl $10
  101dae:	6a 0a                	push   $0xa
  jmp __alltraps
  101db0:	e9 13 0a 00 00       	jmp    1027c8 <__alltraps>

00101db5 <vector11>:
.globl vector11
vector11:
  pushl $11
  101db5:	6a 0b                	push   $0xb
  jmp __alltraps
  101db7:	e9 0c 0a 00 00       	jmp    1027c8 <__alltraps>

00101dbc <vector12>:
.globl vector12
vector12:
  pushl $12
  101dbc:	6a 0c                	push   $0xc
  jmp __alltraps
  101dbe:	e9 05 0a 00 00       	jmp    1027c8 <__alltraps>

00101dc3 <vector13>:
.globl vector13
vector13:
  pushl $13
  101dc3:	6a 0d                	push   $0xd
  jmp __alltraps
  101dc5:	e9 fe 09 00 00       	jmp    1027c8 <__alltraps>

00101dca <vector14>:
.globl vector14
vector14:
  pushl $14
  101dca:	6a 0e                	push   $0xe
  jmp __alltraps
  101dcc:	e9 f7 09 00 00       	jmp    1027c8 <__alltraps>

00101dd1 <vector15>:
.globl vector15
vector15:
  pushl $0
  101dd1:	6a 00                	push   $0x0
  pushl $15
  101dd3:	6a 0f                	push   $0xf
  jmp __alltraps
  101dd5:	e9 ee 09 00 00       	jmp    1027c8 <__alltraps>

00101dda <vector16>:
.globl vector16
vector16:
  pushl $0
  101dda:	6a 00                	push   $0x0
  pushl $16
  101ddc:	6a 10                	push   $0x10
  jmp __alltraps
  101dde:	e9 e5 09 00 00       	jmp    1027c8 <__alltraps>

00101de3 <vector17>:
.globl vector17
vector17:
  pushl $17
  101de3:	6a 11                	push   $0x11
  jmp __alltraps
  101de5:	e9 de 09 00 00       	jmp    1027c8 <__alltraps>

00101dea <vector18>:
.globl vector18
vector18:
  pushl $0
  101dea:	6a 00                	push   $0x0
  pushl $18
  101dec:	6a 12                	push   $0x12
  jmp __alltraps
  101dee:	e9 d5 09 00 00       	jmp    1027c8 <__alltraps>

00101df3 <vector19>:
.globl vector19
vector19:
  pushl $0
  101df3:	6a 00                	push   $0x0
  pushl $19
  101df5:	6a 13                	push   $0x13
  jmp __alltraps
  101df7:	e9 cc 09 00 00       	jmp    1027c8 <__alltraps>

00101dfc <vector20>:
.globl vector20
vector20:
  pushl $0
  101dfc:	6a 00                	push   $0x0
  pushl $20
  101dfe:	6a 14                	push   $0x14
  jmp __alltraps
  101e00:	e9 c3 09 00 00       	jmp    1027c8 <__alltraps>

00101e05 <vector21>:
.globl vector21
vector21:
  pushl $0
  101e05:	6a 00                	push   $0x0
  pushl $21
  101e07:	6a 15                	push   $0x15
  jmp __alltraps
  101e09:	e9 ba 09 00 00       	jmp    1027c8 <__alltraps>

00101e0e <vector22>:
.globl vector22
vector22:
  pushl $0
  101e0e:	6a 00                	push   $0x0
  pushl $22
  101e10:	6a 16                	push   $0x16
  jmp __alltraps
  101e12:	e9 b1 09 00 00       	jmp    1027c8 <__alltraps>

00101e17 <vector23>:
.globl vector23
vector23:
  pushl $0
  101e17:	6a 00                	push   $0x0
  pushl $23
  101e19:	6a 17                	push   $0x17
  jmp __alltraps
  101e1b:	e9 a8 09 00 00       	jmp    1027c8 <__alltraps>

00101e20 <vector24>:
.globl vector24
vector24:
  pushl $0
  101e20:	6a 00                	push   $0x0
  pushl $24
  101e22:	6a 18                	push   $0x18
  jmp __alltraps
  101e24:	e9 9f 09 00 00       	jmp    1027c8 <__alltraps>

00101e29 <vector25>:
.globl vector25
vector25:
  pushl $0
  101e29:	6a 00                	push   $0x0
  pushl $25
  101e2b:	6a 19                	push   $0x19
  jmp __alltraps
  101e2d:	e9 96 09 00 00       	jmp    1027c8 <__alltraps>

00101e32 <vector26>:
.globl vector26
vector26:
  pushl $0
  101e32:	6a 00                	push   $0x0
  pushl $26
  101e34:	6a 1a                	push   $0x1a
  jmp __alltraps
  101e36:	e9 8d 09 00 00       	jmp    1027c8 <__alltraps>

00101e3b <vector27>:
.globl vector27
vector27:
  pushl $0
  101e3b:	6a 00                	push   $0x0
  pushl $27
  101e3d:	6a 1b                	push   $0x1b
  jmp __alltraps
  101e3f:	e9 84 09 00 00       	jmp    1027c8 <__alltraps>

00101e44 <vector28>:
.globl vector28
vector28:
  pushl $0
  101e44:	6a 00                	push   $0x0
  pushl $28
  101e46:	6a 1c                	push   $0x1c
  jmp __alltraps
  101e48:	e9 7b 09 00 00       	jmp    1027c8 <__alltraps>

00101e4d <vector29>:
.globl vector29
vector29:
  pushl $0
  101e4d:	6a 00                	push   $0x0
  pushl $29
  101e4f:	6a 1d                	push   $0x1d
  jmp __alltraps
  101e51:	e9 72 09 00 00       	jmp    1027c8 <__alltraps>

00101e56 <vector30>:
.globl vector30
vector30:
  pushl $0
  101e56:	6a 00                	push   $0x0
  pushl $30
  101e58:	6a 1e                	push   $0x1e
  jmp __alltraps
  101e5a:	e9 69 09 00 00       	jmp    1027c8 <__alltraps>

00101e5f <vector31>:
.globl vector31
vector31:
  pushl $0
  101e5f:	6a 00                	push   $0x0
  pushl $31
  101e61:	6a 1f                	push   $0x1f
  jmp __alltraps
  101e63:	e9 60 09 00 00       	jmp    1027c8 <__alltraps>

00101e68 <vector32>:
.globl vector32
vector32:
  pushl $0
  101e68:	6a 00                	push   $0x0
  pushl $32
  101e6a:	6a 20                	push   $0x20
  jmp __alltraps
  101e6c:	e9 57 09 00 00       	jmp    1027c8 <__alltraps>

00101e71 <vector33>:
.globl vector33
vector33:
  pushl $0
  101e71:	6a 00                	push   $0x0
  pushl $33
  101e73:	6a 21                	push   $0x21
  jmp __alltraps
  101e75:	e9 4e 09 00 00       	jmp    1027c8 <__alltraps>

00101e7a <vector34>:
.globl vector34
vector34:
  pushl $0
  101e7a:	6a 00                	push   $0x0
  pushl $34
  101e7c:	6a 22                	push   $0x22
  jmp __alltraps
  101e7e:	e9 45 09 00 00       	jmp    1027c8 <__alltraps>

00101e83 <vector35>:
.globl vector35
vector35:
  pushl $0
  101e83:	6a 00                	push   $0x0
  pushl $35
  101e85:	6a 23                	push   $0x23
  jmp __alltraps
  101e87:	e9 3c 09 00 00       	jmp    1027c8 <__alltraps>

00101e8c <vector36>:
.globl vector36
vector36:
  pushl $0
  101e8c:	6a 00                	push   $0x0
  pushl $36
  101e8e:	6a 24                	push   $0x24
  jmp __alltraps
  101e90:	e9 33 09 00 00       	jmp    1027c8 <__alltraps>

00101e95 <vector37>:
.globl vector37
vector37:
  pushl $0
  101e95:	6a 00                	push   $0x0
  pushl $37
  101e97:	6a 25                	push   $0x25
  jmp __alltraps
  101e99:	e9 2a 09 00 00       	jmp    1027c8 <__alltraps>

00101e9e <vector38>:
.globl vector38
vector38:
  pushl $0
  101e9e:	6a 00                	push   $0x0
  pushl $38
  101ea0:	6a 26                	push   $0x26
  jmp __alltraps
  101ea2:	e9 21 09 00 00       	jmp    1027c8 <__alltraps>

00101ea7 <vector39>:
.globl vector39
vector39:
  pushl $0
  101ea7:	6a 00                	push   $0x0
  pushl $39
  101ea9:	6a 27                	push   $0x27
  jmp __alltraps
  101eab:	e9 18 09 00 00       	jmp    1027c8 <__alltraps>

00101eb0 <vector40>:
.globl vector40
vector40:
  pushl $0
  101eb0:	6a 00                	push   $0x0
  pushl $40
  101eb2:	6a 28                	push   $0x28
  jmp __alltraps
  101eb4:	e9 0f 09 00 00       	jmp    1027c8 <__alltraps>

00101eb9 <vector41>:
.globl vector41
vector41:
  pushl $0
  101eb9:	6a 00                	push   $0x0
  pushl $41
  101ebb:	6a 29                	push   $0x29
  jmp __alltraps
  101ebd:	e9 06 09 00 00       	jmp    1027c8 <__alltraps>

00101ec2 <vector42>:
.globl vector42
vector42:
  pushl $0
  101ec2:	6a 00                	push   $0x0
  pushl $42
  101ec4:	6a 2a                	push   $0x2a
  jmp __alltraps
  101ec6:	e9 fd 08 00 00       	jmp    1027c8 <__alltraps>

00101ecb <vector43>:
.globl vector43
vector43:
  pushl $0
  101ecb:	6a 00                	push   $0x0
  pushl $43
  101ecd:	6a 2b                	push   $0x2b
  jmp __alltraps
  101ecf:	e9 f4 08 00 00       	jmp    1027c8 <__alltraps>

00101ed4 <vector44>:
.globl vector44
vector44:
  pushl $0
  101ed4:	6a 00                	push   $0x0
  pushl $44
  101ed6:	6a 2c                	push   $0x2c
  jmp __alltraps
  101ed8:	e9 eb 08 00 00       	jmp    1027c8 <__alltraps>

00101edd <vector45>:
.globl vector45
vector45:
  pushl $0
  101edd:	6a 00                	push   $0x0
  pushl $45
  101edf:	6a 2d                	push   $0x2d
  jmp __alltraps
  101ee1:	e9 e2 08 00 00       	jmp    1027c8 <__alltraps>

00101ee6 <vector46>:
.globl vector46
vector46:
  pushl $0
  101ee6:	6a 00                	push   $0x0
  pushl $46
  101ee8:	6a 2e                	push   $0x2e
  jmp __alltraps
  101eea:	e9 d9 08 00 00       	jmp    1027c8 <__alltraps>

00101eef <vector47>:
.globl vector47
vector47:
  pushl $0
  101eef:	6a 00                	push   $0x0
  pushl $47
  101ef1:	6a 2f                	push   $0x2f
  jmp __alltraps
  101ef3:	e9 d0 08 00 00       	jmp    1027c8 <__alltraps>

00101ef8 <vector48>:
.globl vector48
vector48:
  pushl $0
  101ef8:	6a 00                	push   $0x0
  pushl $48
  101efa:	6a 30                	push   $0x30
  jmp __alltraps
  101efc:	e9 c7 08 00 00       	jmp    1027c8 <__alltraps>

00101f01 <vector49>:
.globl vector49
vector49:
  pushl $0
  101f01:	6a 00                	push   $0x0
  pushl $49
  101f03:	6a 31                	push   $0x31
  jmp __alltraps
  101f05:	e9 be 08 00 00       	jmp    1027c8 <__alltraps>

00101f0a <vector50>:
.globl vector50
vector50:
  pushl $0
  101f0a:	6a 00                	push   $0x0
  pushl $50
  101f0c:	6a 32                	push   $0x32
  jmp __alltraps
  101f0e:	e9 b5 08 00 00       	jmp    1027c8 <__alltraps>

00101f13 <vector51>:
.globl vector51
vector51:
  pushl $0
  101f13:	6a 00                	push   $0x0
  pushl $51
  101f15:	6a 33                	push   $0x33
  jmp __alltraps
  101f17:	e9 ac 08 00 00       	jmp    1027c8 <__alltraps>

00101f1c <vector52>:
.globl vector52
vector52:
  pushl $0
  101f1c:	6a 00                	push   $0x0
  pushl $52
  101f1e:	6a 34                	push   $0x34
  jmp __alltraps
  101f20:	e9 a3 08 00 00       	jmp    1027c8 <__alltraps>

00101f25 <vector53>:
.globl vector53
vector53:
  pushl $0
  101f25:	6a 00                	push   $0x0
  pushl $53
  101f27:	6a 35                	push   $0x35
  jmp __alltraps
  101f29:	e9 9a 08 00 00       	jmp    1027c8 <__alltraps>

00101f2e <vector54>:
.globl vector54
vector54:
  pushl $0
  101f2e:	6a 00                	push   $0x0
  pushl $54
  101f30:	6a 36                	push   $0x36
  jmp __alltraps
  101f32:	e9 91 08 00 00       	jmp    1027c8 <__alltraps>

00101f37 <vector55>:
.globl vector55
vector55:
  pushl $0
  101f37:	6a 00                	push   $0x0
  pushl $55
  101f39:	6a 37                	push   $0x37
  jmp __alltraps
  101f3b:	e9 88 08 00 00       	jmp    1027c8 <__alltraps>

00101f40 <vector56>:
.globl vector56
vector56:
  pushl $0
  101f40:	6a 00                	push   $0x0
  pushl $56
  101f42:	6a 38                	push   $0x38
  jmp __alltraps
  101f44:	e9 7f 08 00 00       	jmp    1027c8 <__alltraps>

00101f49 <vector57>:
.globl vector57
vector57:
  pushl $0
  101f49:	6a 00                	push   $0x0
  pushl $57
  101f4b:	6a 39                	push   $0x39
  jmp __alltraps
  101f4d:	e9 76 08 00 00       	jmp    1027c8 <__alltraps>

00101f52 <vector58>:
.globl vector58
vector58:
  pushl $0
  101f52:	6a 00                	push   $0x0
  pushl $58
  101f54:	6a 3a                	push   $0x3a
  jmp __alltraps
  101f56:	e9 6d 08 00 00       	jmp    1027c8 <__alltraps>

00101f5b <vector59>:
.globl vector59
vector59:
  pushl $0
  101f5b:	6a 00                	push   $0x0
  pushl $59
  101f5d:	6a 3b                	push   $0x3b
  jmp __alltraps
  101f5f:	e9 64 08 00 00       	jmp    1027c8 <__alltraps>

00101f64 <vector60>:
.globl vector60
vector60:
  pushl $0
  101f64:	6a 00                	push   $0x0
  pushl $60
  101f66:	6a 3c                	push   $0x3c
  jmp __alltraps
  101f68:	e9 5b 08 00 00       	jmp    1027c8 <__alltraps>

00101f6d <vector61>:
.globl vector61
vector61:
  pushl $0
  101f6d:	6a 00                	push   $0x0
  pushl $61
  101f6f:	6a 3d                	push   $0x3d
  jmp __alltraps
  101f71:	e9 52 08 00 00       	jmp    1027c8 <__alltraps>

00101f76 <vector62>:
.globl vector62
vector62:
  pushl $0
  101f76:	6a 00                	push   $0x0
  pushl $62
  101f78:	6a 3e                	push   $0x3e
  jmp __alltraps
  101f7a:	e9 49 08 00 00       	jmp    1027c8 <__alltraps>

00101f7f <vector63>:
.globl vector63
vector63:
  pushl $0
  101f7f:	6a 00                	push   $0x0
  pushl $63
  101f81:	6a 3f                	push   $0x3f
  jmp __alltraps
  101f83:	e9 40 08 00 00       	jmp    1027c8 <__alltraps>

00101f88 <vector64>:
.globl vector64
vector64:
  pushl $0
  101f88:	6a 00                	push   $0x0
  pushl $64
  101f8a:	6a 40                	push   $0x40
  jmp __alltraps
  101f8c:	e9 37 08 00 00       	jmp    1027c8 <__alltraps>

00101f91 <vector65>:
.globl vector65
vector65:
  pushl $0
  101f91:	6a 00                	push   $0x0
  pushl $65
  101f93:	6a 41                	push   $0x41
  jmp __alltraps
  101f95:	e9 2e 08 00 00       	jmp    1027c8 <__alltraps>

00101f9a <vector66>:
.globl vector66
vector66:
  pushl $0
  101f9a:	6a 00                	push   $0x0
  pushl $66
  101f9c:	6a 42                	push   $0x42
  jmp __alltraps
  101f9e:	e9 25 08 00 00       	jmp    1027c8 <__alltraps>

00101fa3 <vector67>:
.globl vector67
vector67:
  pushl $0
  101fa3:	6a 00                	push   $0x0
  pushl $67
  101fa5:	6a 43                	push   $0x43
  jmp __alltraps
  101fa7:	e9 1c 08 00 00       	jmp    1027c8 <__alltraps>

00101fac <vector68>:
.globl vector68
vector68:
  pushl $0
  101fac:	6a 00                	push   $0x0
  pushl $68
  101fae:	6a 44                	push   $0x44
  jmp __alltraps
  101fb0:	e9 13 08 00 00       	jmp    1027c8 <__alltraps>

00101fb5 <vector69>:
.globl vector69
vector69:
  pushl $0
  101fb5:	6a 00                	push   $0x0
  pushl $69
  101fb7:	6a 45                	push   $0x45
  jmp __alltraps
  101fb9:	e9 0a 08 00 00       	jmp    1027c8 <__alltraps>

00101fbe <vector70>:
.globl vector70
vector70:
  pushl $0
  101fbe:	6a 00                	push   $0x0
  pushl $70
  101fc0:	6a 46                	push   $0x46
  jmp __alltraps
  101fc2:	e9 01 08 00 00       	jmp    1027c8 <__alltraps>

00101fc7 <vector71>:
.globl vector71
vector71:
  pushl $0
  101fc7:	6a 00                	push   $0x0
  pushl $71
  101fc9:	6a 47                	push   $0x47
  jmp __alltraps
  101fcb:	e9 f8 07 00 00       	jmp    1027c8 <__alltraps>

00101fd0 <vector72>:
.globl vector72
vector72:
  pushl $0
  101fd0:	6a 00                	push   $0x0
  pushl $72
  101fd2:	6a 48                	push   $0x48
  jmp __alltraps
  101fd4:	e9 ef 07 00 00       	jmp    1027c8 <__alltraps>

00101fd9 <vector73>:
.globl vector73
vector73:
  pushl $0
  101fd9:	6a 00                	push   $0x0
  pushl $73
  101fdb:	6a 49                	push   $0x49
  jmp __alltraps
  101fdd:	e9 e6 07 00 00       	jmp    1027c8 <__alltraps>

00101fe2 <vector74>:
.globl vector74
vector74:
  pushl $0
  101fe2:	6a 00                	push   $0x0
  pushl $74
  101fe4:	6a 4a                	push   $0x4a
  jmp __alltraps
  101fe6:	e9 dd 07 00 00       	jmp    1027c8 <__alltraps>

00101feb <vector75>:
.globl vector75
vector75:
  pushl $0
  101feb:	6a 00                	push   $0x0
  pushl $75
  101fed:	6a 4b                	push   $0x4b
  jmp __alltraps
  101fef:	e9 d4 07 00 00       	jmp    1027c8 <__alltraps>

00101ff4 <vector76>:
.globl vector76
vector76:
  pushl $0
  101ff4:	6a 00                	push   $0x0
  pushl $76
  101ff6:	6a 4c                	push   $0x4c
  jmp __alltraps
  101ff8:	e9 cb 07 00 00       	jmp    1027c8 <__alltraps>

00101ffd <vector77>:
.globl vector77
vector77:
  pushl $0
  101ffd:	6a 00                	push   $0x0
  pushl $77
  101fff:	6a 4d                	push   $0x4d
  jmp __alltraps
  102001:	e9 c2 07 00 00       	jmp    1027c8 <__alltraps>

00102006 <vector78>:
.globl vector78
vector78:
  pushl $0
  102006:	6a 00                	push   $0x0
  pushl $78
  102008:	6a 4e                	push   $0x4e
  jmp __alltraps
  10200a:	e9 b9 07 00 00       	jmp    1027c8 <__alltraps>

0010200f <vector79>:
.globl vector79
vector79:
  pushl $0
  10200f:	6a 00                	push   $0x0
  pushl $79
  102011:	6a 4f                	push   $0x4f
  jmp __alltraps
  102013:	e9 b0 07 00 00       	jmp    1027c8 <__alltraps>

00102018 <vector80>:
.globl vector80
vector80:
  pushl $0
  102018:	6a 00                	push   $0x0
  pushl $80
  10201a:	6a 50                	push   $0x50
  jmp __alltraps
  10201c:	e9 a7 07 00 00       	jmp    1027c8 <__alltraps>

00102021 <vector81>:
.globl vector81
vector81:
  pushl $0
  102021:	6a 00                	push   $0x0
  pushl $81
  102023:	6a 51                	push   $0x51
  jmp __alltraps
  102025:	e9 9e 07 00 00       	jmp    1027c8 <__alltraps>

0010202a <vector82>:
.globl vector82
vector82:
  pushl $0
  10202a:	6a 00                	push   $0x0
  pushl $82
  10202c:	6a 52                	push   $0x52
  jmp __alltraps
  10202e:	e9 95 07 00 00       	jmp    1027c8 <__alltraps>

00102033 <vector83>:
.globl vector83
vector83:
  pushl $0
  102033:	6a 00                	push   $0x0
  pushl $83
  102035:	6a 53                	push   $0x53
  jmp __alltraps
  102037:	e9 8c 07 00 00       	jmp    1027c8 <__alltraps>

0010203c <vector84>:
.globl vector84
vector84:
  pushl $0
  10203c:	6a 00                	push   $0x0
  pushl $84
  10203e:	6a 54                	push   $0x54
  jmp __alltraps
  102040:	e9 83 07 00 00       	jmp    1027c8 <__alltraps>

00102045 <vector85>:
.globl vector85
vector85:
  pushl $0
  102045:	6a 00                	push   $0x0
  pushl $85
  102047:	6a 55                	push   $0x55
  jmp __alltraps
  102049:	e9 7a 07 00 00       	jmp    1027c8 <__alltraps>

0010204e <vector86>:
.globl vector86
vector86:
  pushl $0
  10204e:	6a 00                	push   $0x0
  pushl $86
  102050:	6a 56                	push   $0x56
  jmp __alltraps
  102052:	e9 71 07 00 00       	jmp    1027c8 <__alltraps>

00102057 <vector87>:
.globl vector87
vector87:
  pushl $0
  102057:	6a 00                	push   $0x0
  pushl $87
  102059:	6a 57                	push   $0x57
  jmp __alltraps
  10205b:	e9 68 07 00 00       	jmp    1027c8 <__alltraps>

00102060 <vector88>:
.globl vector88
vector88:
  pushl $0
  102060:	6a 00                	push   $0x0
  pushl $88
  102062:	6a 58                	push   $0x58
  jmp __alltraps
  102064:	e9 5f 07 00 00       	jmp    1027c8 <__alltraps>

00102069 <vector89>:
.globl vector89
vector89:
  pushl $0
  102069:	6a 00                	push   $0x0
  pushl $89
  10206b:	6a 59                	push   $0x59
  jmp __alltraps
  10206d:	e9 56 07 00 00       	jmp    1027c8 <__alltraps>

00102072 <vector90>:
.globl vector90
vector90:
  pushl $0
  102072:	6a 00                	push   $0x0
  pushl $90
  102074:	6a 5a                	push   $0x5a
  jmp __alltraps
  102076:	e9 4d 07 00 00       	jmp    1027c8 <__alltraps>

0010207b <vector91>:
.globl vector91
vector91:
  pushl $0
  10207b:	6a 00                	push   $0x0
  pushl $91
  10207d:	6a 5b                	push   $0x5b
  jmp __alltraps
  10207f:	e9 44 07 00 00       	jmp    1027c8 <__alltraps>

00102084 <vector92>:
.globl vector92
vector92:
  pushl $0
  102084:	6a 00                	push   $0x0
  pushl $92
  102086:	6a 5c                	push   $0x5c
  jmp __alltraps
  102088:	e9 3b 07 00 00       	jmp    1027c8 <__alltraps>

0010208d <vector93>:
.globl vector93
vector93:
  pushl $0
  10208d:	6a 00                	push   $0x0
  pushl $93
  10208f:	6a 5d                	push   $0x5d
  jmp __alltraps
  102091:	e9 32 07 00 00       	jmp    1027c8 <__alltraps>

00102096 <vector94>:
.globl vector94
vector94:
  pushl $0
  102096:	6a 00                	push   $0x0
  pushl $94
  102098:	6a 5e                	push   $0x5e
  jmp __alltraps
  10209a:	e9 29 07 00 00       	jmp    1027c8 <__alltraps>

0010209f <vector95>:
.globl vector95
vector95:
  pushl $0
  10209f:	6a 00                	push   $0x0
  pushl $95
  1020a1:	6a 5f                	push   $0x5f
  jmp __alltraps
  1020a3:	e9 20 07 00 00       	jmp    1027c8 <__alltraps>

001020a8 <vector96>:
.globl vector96
vector96:
  pushl $0
  1020a8:	6a 00                	push   $0x0
  pushl $96
  1020aa:	6a 60                	push   $0x60
  jmp __alltraps
  1020ac:	e9 17 07 00 00       	jmp    1027c8 <__alltraps>

001020b1 <vector97>:
.globl vector97
vector97:
  pushl $0
  1020b1:	6a 00                	push   $0x0
  pushl $97
  1020b3:	6a 61                	push   $0x61
  jmp __alltraps
  1020b5:	e9 0e 07 00 00       	jmp    1027c8 <__alltraps>

001020ba <vector98>:
.globl vector98
vector98:
  pushl $0
  1020ba:	6a 00                	push   $0x0
  pushl $98
  1020bc:	6a 62                	push   $0x62
  jmp __alltraps
  1020be:	e9 05 07 00 00       	jmp    1027c8 <__alltraps>

001020c3 <vector99>:
.globl vector99
vector99:
  pushl $0
  1020c3:	6a 00                	push   $0x0
  pushl $99
  1020c5:	6a 63                	push   $0x63
  jmp __alltraps
  1020c7:	e9 fc 06 00 00       	jmp    1027c8 <__alltraps>

001020cc <vector100>:
.globl vector100
vector100:
  pushl $0
  1020cc:	6a 00                	push   $0x0
  pushl $100
  1020ce:	6a 64                	push   $0x64
  jmp __alltraps
  1020d0:	e9 f3 06 00 00       	jmp    1027c8 <__alltraps>

001020d5 <vector101>:
.globl vector101
vector101:
  pushl $0
  1020d5:	6a 00                	push   $0x0
  pushl $101
  1020d7:	6a 65                	push   $0x65
  jmp __alltraps
  1020d9:	e9 ea 06 00 00       	jmp    1027c8 <__alltraps>

001020de <vector102>:
.globl vector102
vector102:
  pushl $0
  1020de:	6a 00                	push   $0x0
  pushl $102
  1020e0:	6a 66                	push   $0x66
  jmp __alltraps
  1020e2:	e9 e1 06 00 00       	jmp    1027c8 <__alltraps>

001020e7 <vector103>:
.globl vector103
vector103:
  pushl $0
  1020e7:	6a 00                	push   $0x0
  pushl $103
  1020e9:	6a 67                	push   $0x67
  jmp __alltraps
  1020eb:	e9 d8 06 00 00       	jmp    1027c8 <__alltraps>

001020f0 <vector104>:
.globl vector104
vector104:
  pushl $0
  1020f0:	6a 00                	push   $0x0
  pushl $104
  1020f2:	6a 68                	push   $0x68
  jmp __alltraps
  1020f4:	e9 cf 06 00 00       	jmp    1027c8 <__alltraps>

001020f9 <vector105>:
.globl vector105
vector105:
  pushl $0
  1020f9:	6a 00                	push   $0x0
  pushl $105
  1020fb:	6a 69                	push   $0x69
  jmp __alltraps
  1020fd:	e9 c6 06 00 00       	jmp    1027c8 <__alltraps>

00102102 <vector106>:
.globl vector106
vector106:
  pushl $0
  102102:	6a 00                	push   $0x0
  pushl $106
  102104:	6a 6a                	push   $0x6a
  jmp __alltraps
  102106:	e9 bd 06 00 00       	jmp    1027c8 <__alltraps>

0010210b <vector107>:
.globl vector107
vector107:
  pushl $0
  10210b:	6a 00                	push   $0x0
  pushl $107
  10210d:	6a 6b                	push   $0x6b
  jmp __alltraps
  10210f:	e9 b4 06 00 00       	jmp    1027c8 <__alltraps>

00102114 <vector108>:
.globl vector108
vector108:
  pushl $0
  102114:	6a 00                	push   $0x0
  pushl $108
  102116:	6a 6c                	push   $0x6c
  jmp __alltraps
  102118:	e9 ab 06 00 00       	jmp    1027c8 <__alltraps>

0010211d <vector109>:
.globl vector109
vector109:
  pushl $0
  10211d:	6a 00                	push   $0x0
  pushl $109
  10211f:	6a 6d                	push   $0x6d
  jmp __alltraps
  102121:	e9 a2 06 00 00       	jmp    1027c8 <__alltraps>

00102126 <vector110>:
.globl vector110
vector110:
  pushl $0
  102126:	6a 00                	push   $0x0
  pushl $110
  102128:	6a 6e                	push   $0x6e
  jmp __alltraps
  10212a:	e9 99 06 00 00       	jmp    1027c8 <__alltraps>

0010212f <vector111>:
.globl vector111
vector111:
  pushl $0
  10212f:	6a 00                	push   $0x0
  pushl $111
  102131:	6a 6f                	push   $0x6f
  jmp __alltraps
  102133:	e9 90 06 00 00       	jmp    1027c8 <__alltraps>

00102138 <vector112>:
.globl vector112
vector112:
  pushl $0
  102138:	6a 00                	push   $0x0
  pushl $112
  10213a:	6a 70                	push   $0x70
  jmp __alltraps
  10213c:	e9 87 06 00 00       	jmp    1027c8 <__alltraps>

00102141 <vector113>:
.globl vector113
vector113:
  pushl $0
  102141:	6a 00                	push   $0x0
  pushl $113
  102143:	6a 71                	push   $0x71
  jmp __alltraps
  102145:	e9 7e 06 00 00       	jmp    1027c8 <__alltraps>

0010214a <vector114>:
.globl vector114
vector114:
  pushl $0
  10214a:	6a 00                	push   $0x0
  pushl $114
  10214c:	6a 72                	push   $0x72
  jmp __alltraps
  10214e:	e9 75 06 00 00       	jmp    1027c8 <__alltraps>

00102153 <vector115>:
.globl vector115
vector115:
  pushl $0
  102153:	6a 00                	push   $0x0
  pushl $115
  102155:	6a 73                	push   $0x73
  jmp __alltraps
  102157:	e9 6c 06 00 00       	jmp    1027c8 <__alltraps>

0010215c <vector116>:
.globl vector116
vector116:
  pushl $0
  10215c:	6a 00                	push   $0x0
  pushl $116
  10215e:	6a 74                	push   $0x74
  jmp __alltraps
  102160:	e9 63 06 00 00       	jmp    1027c8 <__alltraps>

00102165 <vector117>:
.globl vector117
vector117:
  pushl $0
  102165:	6a 00                	push   $0x0
  pushl $117
  102167:	6a 75                	push   $0x75
  jmp __alltraps
  102169:	e9 5a 06 00 00       	jmp    1027c8 <__alltraps>

0010216e <vector118>:
.globl vector118
vector118:
  pushl $0
  10216e:	6a 00                	push   $0x0
  pushl $118
  102170:	6a 76                	push   $0x76
  jmp __alltraps
  102172:	e9 51 06 00 00       	jmp    1027c8 <__alltraps>

00102177 <vector119>:
.globl vector119
vector119:
  pushl $0
  102177:	6a 00                	push   $0x0
  pushl $119
  102179:	6a 77                	push   $0x77
  jmp __alltraps
  10217b:	e9 48 06 00 00       	jmp    1027c8 <__alltraps>

00102180 <vector120>:
.globl vector120
vector120:
  pushl $0
  102180:	6a 00                	push   $0x0
  pushl $120
  102182:	6a 78                	push   $0x78
  jmp __alltraps
  102184:	e9 3f 06 00 00       	jmp    1027c8 <__alltraps>

00102189 <vector121>:
.globl vector121
vector121:
  pushl $0
  102189:	6a 00                	push   $0x0
  pushl $121
  10218b:	6a 79                	push   $0x79
  jmp __alltraps
  10218d:	e9 36 06 00 00       	jmp    1027c8 <__alltraps>

00102192 <vector122>:
.globl vector122
vector122:
  pushl $0
  102192:	6a 00                	push   $0x0
  pushl $122
  102194:	6a 7a                	push   $0x7a
  jmp __alltraps
  102196:	e9 2d 06 00 00       	jmp    1027c8 <__alltraps>

0010219b <vector123>:
.globl vector123
vector123:
  pushl $0
  10219b:	6a 00                	push   $0x0
  pushl $123
  10219d:	6a 7b                	push   $0x7b
  jmp __alltraps
  10219f:	e9 24 06 00 00       	jmp    1027c8 <__alltraps>

001021a4 <vector124>:
.globl vector124
vector124:
  pushl $0
  1021a4:	6a 00                	push   $0x0
  pushl $124
  1021a6:	6a 7c                	push   $0x7c
  jmp __alltraps
  1021a8:	e9 1b 06 00 00       	jmp    1027c8 <__alltraps>

001021ad <vector125>:
.globl vector125
vector125:
  pushl $0
  1021ad:	6a 00                	push   $0x0
  pushl $125
  1021af:	6a 7d                	push   $0x7d
  jmp __alltraps
  1021b1:	e9 12 06 00 00       	jmp    1027c8 <__alltraps>

001021b6 <vector126>:
.globl vector126
vector126:
  pushl $0
  1021b6:	6a 00                	push   $0x0
  pushl $126
  1021b8:	6a 7e                	push   $0x7e
  jmp __alltraps
  1021ba:	e9 09 06 00 00       	jmp    1027c8 <__alltraps>

001021bf <vector127>:
.globl vector127
vector127:
  pushl $0
  1021bf:	6a 00                	push   $0x0
  pushl $127
  1021c1:	6a 7f                	push   $0x7f
  jmp __alltraps
  1021c3:	e9 00 06 00 00       	jmp    1027c8 <__alltraps>

001021c8 <vector128>:
.globl vector128
vector128:
  pushl $0
  1021c8:	6a 00                	push   $0x0
  pushl $128
  1021ca:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1021cf:	e9 f4 05 00 00       	jmp    1027c8 <__alltraps>

001021d4 <vector129>:
.globl vector129
vector129:
  pushl $0
  1021d4:	6a 00                	push   $0x0
  pushl $129
  1021d6:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1021db:	e9 e8 05 00 00       	jmp    1027c8 <__alltraps>

001021e0 <vector130>:
.globl vector130
vector130:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $130
  1021e2:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1021e7:	e9 dc 05 00 00       	jmp    1027c8 <__alltraps>

001021ec <vector131>:
.globl vector131
vector131:
  pushl $0
  1021ec:	6a 00                	push   $0x0
  pushl $131
  1021ee:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1021f3:	e9 d0 05 00 00       	jmp    1027c8 <__alltraps>

001021f8 <vector132>:
.globl vector132
vector132:
  pushl $0
  1021f8:	6a 00                	push   $0x0
  pushl $132
  1021fa:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1021ff:	e9 c4 05 00 00       	jmp    1027c8 <__alltraps>

00102204 <vector133>:
.globl vector133
vector133:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $133
  102206:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10220b:	e9 b8 05 00 00       	jmp    1027c8 <__alltraps>

00102210 <vector134>:
.globl vector134
vector134:
  pushl $0
  102210:	6a 00                	push   $0x0
  pushl $134
  102212:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102217:	e9 ac 05 00 00       	jmp    1027c8 <__alltraps>

0010221c <vector135>:
.globl vector135
vector135:
  pushl $0
  10221c:	6a 00                	push   $0x0
  pushl $135
  10221e:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102223:	e9 a0 05 00 00       	jmp    1027c8 <__alltraps>

00102228 <vector136>:
.globl vector136
vector136:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $136
  10222a:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10222f:	e9 94 05 00 00       	jmp    1027c8 <__alltraps>

00102234 <vector137>:
.globl vector137
vector137:
  pushl $0
  102234:	6a 00                	push   $0x0
  pushl $137
  102236:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10223b:	e9 88 05 00 00       	jmp    1027c8 <__alltraps>

00102240 <vector138>:
.globl vector138
vector138:
  pushl $0
  102240:	6a 00                	push   $0x0
  pushl $138
  102242:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102247:	e9 7c 05 00 00       	jmp    1027c8 <__alltraps>

0010224c <vector139>:
.globl vector139
vector139:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $139
  10224e:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102253:	e9 70 05 00 00       	jmp    1027c8 <__alltraps>

00102258 <vector140>:
.globl vector140
vector140:
  pushl $0
  102258:	6a 00                	push   $0x0
  pushl $140
  10225a:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10225f:	e9 64 05 00 00       	jmp    1027c8 <__alltraps>

00102264 <vector141>:
.globl vector141
vector141:
  pushl $0
  102264:	6a 00                	push   $0x0
  pushl $141
  102266:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10226b:	e9 58 05 00 00       	jmp    1027c8 <__alltraps>

00102270 <vector142>:
.globl vector142
vector142:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $142
  102272:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102277:	e9 4c 05 00 00       	jmp    1027c8 <__alltraps>

0010227c <vector143>:
.globl vector143
vector143:
  pushl $0
  10227c:	6a 00                	push   $0x0
  pushl $143
  10227e:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102283:	e9 40 05 00 00       	jmp    1027c8 <__alltraps>

00102288 <vector144>:
.globl vector144
vector144:
  pushl $0
  102288:	6a 00                	push   $0x0
  pushl $144
  10228a:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10228f:	e9 34 05 00 00       	jmp    1027c8 <__alltraps>

00102294 <vector145>:
.globl vector145
vector145:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $145
  102296:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10229b:	e9 28 05 00 00       	jmp    1027c8 <__alltraps>

001022a0 <vector146>:
.globl vector146
vector146:
  pushl $0
  1022a0:	6a 00                	push   $0x0
  pushl $146
  1022a2:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1022a7:	e9 1c 05 00 00       	jmp    1027c8 <__alltraps>

001022ac <vector147>:
.globl vector147
vector147:
  pushl $0
  1022ac:	6a 00                	push   $0x0
  pushl $147
  1022ae:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1022b3:	e9 10 05 00 00       	jmp    1027c8 <__alltraps>

001022b8 <vector148>:
.globl vector148
vector148:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $148
  1022ba:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1022bf:	e9 04 05 00 00       	jmp    1027c8 <__alltraps>

001022c4 <vector149>:
.globl vector149
vector149:
  pushl $0
  1022c4:	6a 00                	push   $0x0
  pushl $149
  1022c6:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1022cb:	e9 f8 04 00 00       	jmp    1027c8 <__alltraps>

001022d0 <vector150>:
.globl vector150
vector150:
  pushl $0
  1022d0:	6a 00                	push   $0x0
  pushl $150
  1022d2:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1022d7:	e9 ec 04 00 00       	jmp    1027c8 <__alltraps>

001022dc <vector151>:
.globl vector151
vector151:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $151
  1022de:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1022e3:	e9 e0 04 00 00       	jmp    1027c8 <__alltraps>

001022e8 <vector152>:
.globl vector152
vector152:
  pushl $0
  1022e8:	6a 00                	push   $0x0
  pushl $152
  1022ea:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1022ef:	e9 d4 04 00 00       	jmp    1027c8 <__alltraps>

001022f4 <vector153>:
.globl vector153
vector153:
  pushl $0
  1022f4:	6a 00                	push   $0x0
  pushl $153
  1022f6:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1022fb:	e9 c8 04 00 00       	jmp    1027c8 <__alltraps>

00102300 <vector154>:
.globl vector154
vector154:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $154
  102302:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102307:	e9 bc 04 00 00       	jmp    1027c8 <__alltraps>

0010230c <vector155>:
.globl vector155
vector155:
  pushl $0
  10230c:	6a 00                	push   $0x0
  pushl $155
  10230e:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102313:	e9 b0 04 00 00       	jmp    1027c8 <__alltraps>

00102318 <vector156>:
.globl vector156
vector156:
  pushl $0
  102318:	6a 00                	push   $0x0
  pushl $156
  10231a:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10231f:	e9 a4 04 00 00       	jmp    1027c8 <__alltraps>

00102324 <vector157>:
.globl vector157
vector157:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $157
  102326:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10232b:	e9 98 04 00 00       	jmp    1027c8 <__alltraps>

00102330 <vector158>:
.globl vector158
vector158:
  pushl $0
  102330:	6a 00                	push   $0x0
  pushl $158
  102332:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102337:	e9 8c 04 00 00       	jmp    1027c8 <__alltraps>

0010233c <vector159>:
.globl vector159
vector159:
  pushl $0
  10233c:	6a 00                	push   $0x0
  pushl $159
  10233e:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102343:	e9 80 04 00 00       	jmp    1027c8 <__alltraps>

00102348 <vector160>:
.globl vector160
vector160:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $160
  10234a:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10234f:	e9 74 04 00 00       	jmp    1027c8 <__alltraps>

00102354 <vector161>:
.globl vector161
vector161:
  pushl $0
  102354:	6a 00                	push   $0x0
  pushl $161
  102356:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10235b:	e9 68 04 00 00       	jmp    1027c8 <__alltraps>

00102360 <vector162>:
.globl vector162
vector162:
  pushl $0
  102360:	6a 00                	push   $0x0
  pushl $162
  102362:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102367:	e9 5c 04 00 00       	jmp    1027c8 <__alltraps>

0010236c <vector163>:
.globl vector163
vector163:
  pushl $0
  10236c:	6a 00                	push   $0x0
  pushl $163
  10236e:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102373:	e9 50 04 00 00       	jmp    1027c8 <__alltraps>

00102378 <vector164>:
.globl vector164
vector164:
  pushl $0
  102378:	6a 00                	push   $0x0
  pushl $164
  10237a:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10237f:	e9 44 04 00 00       	jmp    1027c8 <__alltraps>

00102384 <vector165>:
.globl vector165
vector165:
  pushl $0
  102384:	6a 00                	push   $0x0
  pushl $165
  102386:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10238b:	e9 38 04 00 00       	jmp    1027c8 <__alltraps>

00102390 <vector166>:
.globl vector166
vector166:
  pushl $0
  102390:	6a 00                	push   $0x0
  pushl $166
  102392:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102397:	e9 2c 04 00 00       	jmp    1027c8 <__alltraps>

0010239c <vector167>:
.globl vector167
vector167:
  pushl $0
  10239c:	6a 00                	push   $0x0
  pushl $167
  10239e:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1023a3:	e9 20 04 00 00       	jmp    1027c8 <__alltraps>

001023a8 <vector168>:
.globl vector168
vector168:
  pushl $0
  1023a8:	6a 00                	push   $0x0
  pushl $168
  1023aa:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1023af:	e9 14 04 00 00       	jmp    1027c8 <__alltraps>

001023b4 <vector169>:
.globl vector169
vector169:
  pushl $0
  1023b4:	6a 00                	push   $0x0
  pushl $169
  1023b6:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1023bb:	e9 08 04 00 00       	jmp    1027c8 <__alltraps>

001023c0 <vector170>:
.globl vector170
vector170:
  pushl $0
  1023c0:	6a 00                	push   $0x0
  pushl $170
  1023c2:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1023c7:	e9 fc 03 00 00       	jmp    1027c8 <__alltraps>

001023cc <vector171>:
.globl vector171
vector171:
  pushl $0
  1023cc:	6a 00                	push   $0x0
  pushl $171
  1023ce:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1023d3:	e9 f0 03 00 00       	jmp    1027c8 <__alltraps>

001023d8 <vector172>:
.globl vector172
vector172:
  pushl $0
  1023d8:	6a 00                	push   $0x0
  pushl $172
  1023da:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1023df:	e9 e4 03 00 00       	jmp    1027c8 <__alltraps>

001023e4 <vector173>:
.globl vector173
vector173:
  pushl $0
  1023e4:	6a 00                	push   $0x0
  pushl $173
  1023e6:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1023eb:	e9 d8 03 00 00       	jmp    1027c8 <__alltraps>

001023f0 <vector174>:
.globl vector174
vector174:
  pushl $0
  1023f0:	6a 00                	push   $0x0
  pushl $174
  1023f2:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1023f7:	e9 cc 03 00 00       	jmp    1027c8 <__alltraps>

001023fc <vector175>:
.globl vector175
vector175:
  pushl $0
  1023fc:	6a 00                	push   $0x0
  pushl $175
  1023fe:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102403:	e9 c0 03 00 00       	jmp    1027c8 <__alltraps>

00102408 <vector176>:
.globl vector176
vector176:
  pushl $0
  102408:	6a 00                	push   $0x0
  pushl $176
  10240a:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10240f:	e9 b4 03 00 00       	jmp    1027c8 <__alltraps>

00102414 <vector177>:
.globl vector177
vector177:
  pushl $0
  102414:	6a 00                	push   $0x0
  pushl $177
  102416:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10241b:	e9 a8 03 00 00       	jmp    1027c8 <__alltraps>

00102420 <vector178>:
.globl vector178
vector178:
  pushl $0
  102420:	6a 00                	push   $0x0
  pushl $178
  102422:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102427:	e9 9c 03 00 00       	jmp    1027c8 <__alltraps>

0010242c <vector179>:
.globl vector179
vector179:
  pushl $0
  10242c:	6a 00                	push   $0x0
  pushl $179
  10242e:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102433:	e9 90 03 00 00       	jmp    1027c8 <__alltraps>

00102438 <vector180>:
.globl vector180
vector180:
  pushl $0
  102438:	6a 00                	push   $0x0
  pushl $180
  10243a:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10243f:	e9 84 03 00 00       	jmp    1027c8 <__alltraps>

00102444 <vector181>:
.globl vector181
vector181:
  pushl $0
  102444:	6a 00                	push   $0x0
  pushl $181
  102446:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10244b:	e9 78 03 00 00       	jmp    1027c8 <__alltraps>

00102450 <vector182>:
.globl vector182
vector182:
  pushl $0
  102450:	6a 00                	push   $0x0
  pushl $182
  102452:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102457:	e9 6c 03 00 00       	jmp    1027c8 <__alltraps>

0010245c <vector183>:
.globl vector183
vector183:
  pushl $0
  10245c:	6a 00                	push   $0x0
  pushl $183
  10245e:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102463:	e9 60 03 00 00       	jmp    1027c8 <__alltraps>

00102468 <vector184>:
.globl vector184
vector184:
  pushl $0
  102468:	6a 00                	push   $0x0
  pushl $184
  10246a:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10246f:	e9 54 03 00 00       	jmp    1027c8 <__alltraps>

00102474 <vector185>:
.globl vector185
vector185:
  pushl $0
  102474:	6a 00                	push   $0x0
  pushl $185
  102476:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10247b:	e9 48 03 00 00       	jmp    1027c8 <__alltraps>

00102480 <vector186>:
.globl vector186
vector186:
  pushl $0
  102480:	6a 00                	push   $0x0
  pushl $186
  102482:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102487:	e9 3c 03 00 00       	jmp    1027c8 <__alltraps>

0010248c <vector187>:
.globl vector187
vector187:
  pushl $0
  10248c:	6a 00                	push   $0x0
  pushl $187
  10248e:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102493:	e9 30 03 00 00       	jmp    1027c8 <__alltraps>

00102498 <vector188>:
.globl vector188
vector188:
  pushl $0
  102498:	6a 00                	push   $0x0
  pushl $188
  10249a:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10249f:	e9 24 03 00 00       	jmp    1027c8 <__alltraps>

001024a4 <vector189>:
.globl vector189
vector189:
  pushl $0
  1024a4:	6a 00                	push   $0x0
  pushl $189
  1024a6:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1024ab:	e9 18 03 00 00       	jmp    1027c8 <__alltraps>

001024b0 <vector190>:
.globl vector190
vector190:
  pushl $0
  1024b0:	6a 00                	push   $0x0
  pushl $190
  1024b2:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1024b7:	e9 0c 03 00 00       	jmp    1027c8 <__alltraps>

001024bc <vector191>:
.globl vector191
vector191:
  pushl $0
  1024bc:	6a 00                	push   $0x0
  pushl $191
  1024be:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1024c3:	e9 00 03 00 00       	jmp    1027c8 <__alltraps>

001024c8 <vector192>:
.globl vector192
vector192:
  pushl $0
  1024c8:	6a 00                	push   $0x0
  pushl $192
  1024ca:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1024cf:	e9 f4 02 00 00       	jmp    1027c8 <__alltraps>

001024d4 <vector193>:
.globl vector193
vector193:
  pushl $0
  1024d4:	6a 00                	push   $0x0
  pushl $193
  1024d6:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1024db:	e9 e8 02 00 00       	jmp    1027c8 <__alltraps>

001024e0 <vector194>:
.globl vector194
vector194:
  pushl $0
  1024e0:	6a 00                	push   $0x0
  pushl $194
  1024e2:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1024e7:	e9 dc 02 00 00       	jmp    1027c8 <__alltraps>

001024ec <vector195>:
.globl vector195
vector195:
  pushl $0
  1024ec:	6a 00                	push   $0x0
  pushl $195
  1024ee:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1024f3:	e9 d0 02 00 00       	jmp    1027c8 <__alltraps>

001024f8 <vector196>:
.globl vector196
vector196:
  pushl $0
  1024f8:	6a 00                	push   $0x0
  pushl $196
  1024fa:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1024ff:	e9 c4 02 00 00       	jmp    1027c8 <__alltraps>

00102504 <vector197>:
.globl vector197
vector197:
  pushl $0
  102504:	6a 00                	push   $0x0
  pushl $197
  102506:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10250b:	e9 b8 02 00 00       	jmp    1027c8 <__alltraps>

00102510 <vector198>:
.globl vector198
vector198:
  pushl $0
  102510:	6a 00                	push   $0x0
  pushl $198
  102512:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102517:	e9 ac 02 00 00       	jmp    1027c8 <__alltraps>

0010251c <vector199>:
.globl vector199
vector199:
  pushl $0
  10251c:	6a 00                	push   $0x0
  pushl $199
  10251e:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102523:	e9 a0 02 00 00       	jmp    1027c8 <__alltraps>

00102528 <vector200>:
.globl vector200
vector200:
  pushl $0
  102528:	6a 00                	push   $0x0
  pushl $200
  10252a:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10252f:	e9 94 02 00 00       	jmp    1027c8 <__alltraps>

00102534 <vector201>:
.globl vector201
vector201:
  pushl $0
  102534:	6a 00                	push   $0x0
  pushl $201
  102536:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10253b:	e9 88 02 00 00       	jmp    1027c8 <__alltraps>

00102540 <vector202>:
.globl vector202
vector202:
  pushl $0
  102540:	6a 00                	push   $0x0
  pushl $202
  102542:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102547:	e9 7c 02 00 00       	jmp    1027c8 <__alltraps>

0010254c <vector203>:
.globl vector203
vector203:
  pushl $0
  10254c:	6a 00                	push   $0x0
  pushl $203
  10254e:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102553:	e9 70 02 00 00       	jmp    1027c8 <__alltraps>

00102558 <vector204>:
.globl vector204
vector204:
  pushl $0
  102558:	6a 00                	push   $0x0
  pushl $204
  10255a:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10255f:	e9 64 02 00 00       	jmp    1027c8 <__alltraps>

00102564 <vector205>:
.globl vector205
vector205:
  pushl $0
  102564:	6a 00                	push   $0x0
  pushl $205
  102566:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10256b:	e9 58 02 00 00       	jmp    1027c8 <__alltraps>

00102570 <vector206>:
.globl vector206
vector206:
  pushl $0
  102570:	6a 00                	push   $0x0
  pushl $206
  102572:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102577:	e9 4c 02 00 00       	jmp    1027c8 <__alltraps>

0010257c <vector207>:
.globl vector207
vector207:
  pushl $0
  10257c:	6a 00                	push   $0x0
  pushl $207
  10257e:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102583:	e9 40 02 00 00       	jmp    1027c8 <__alltraps>

00102588 <vector208>:
.globl vector208
vector208:
  pushl $0
  102588:	6a 00                	push   $0x0
  pushl $208
  10258a:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10258f:	e9 34 02 00 00       	jmp    1027c8 <__alltraps>

00102594 <vector209>:
.globl vector209
vector209:
  pushl $0
  102594:	6a 00                	push   $0x0
  pushl $209
  102596:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10259b:	e9 28 02 00 00       	jmp    1027c8 <__alltraps>

001025a0 <vector210>:
.globl vector210
vector210:
  pushl $0
  1025a0:	6a 00                	push   $0x0
  pushl $210
  1025a2:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1025a7:	e9 1c 02 00 00       	jmp    1027c8 <__alltraps>

001025ac <vector211>:
.globl vector211
vector211:
  pushl $0
  1025ac:	6a 00                	push   $0x0
  pushl $211
  1025ae:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1025b3:	e9 10 02 00 00       	jmp    1027c8 <__alltraps>

001025b8 <vector212>:
.globl vector212
vector212:
  pushl $0
  1025b8:	6a 00                	push   $0x0
  pushl $212
  1025ba:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1025bf:	e9 04 02 00 00       	jmp    1027c8 <__alltraps>

001025c4 <vector213>:
.globl vector213
vector213:
  pushl $0
  1025c4:	6a 00                	push   $0x0
  pushl $213
  1025c6:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1025cb:	e9 f8 01 00 00       	jmp    1027c8 <__alltraps>

001025d0 <vector214>:
.globl vector214
vector214:
  pushl $0
  1025d0:	6a 00                	push   $0x0
  pushl $214
  1025d2:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1025d7:	e9 ec 01 00 00       	jmp    1027c8 <__alltraps>

001025dc <vector215>:
.globl vector215
vector215:
  pushl $0
  1025dc:	6a 00                	push   $0x0
  pushl $215
  1025de:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1025e3:	e9 e0 01 00 00       	jmp    1027c8 <__alltraps>

001025e8 <vector216>:
.globl vector216
vector216:
  pushl $0
  1025e8:	6a 00                	push   $0x0
  pushl $216
  1025ea:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1025ef:	e9 d4 01 00 00       	jmp    1027c8 <__alltraps>

001025f4 <vector217>:
.globl vector217
vector217:
  pushl $0
  1025f4:	6a 00                	push   $0x0
  pushl $217
  1025f6:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1025fb:	e9 c8 01 00 00       	jmp    1027c8 <__alltraps>

00102600 <vector218>:
.globl vector218
vector218:
  pushl $0
  102600:	6a 00                	push   $0x0
  pushl $218
  102602:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102607:	e9 bc 01 00 00       	jmp    1027c8 <__alltraps>

0010260c <vector219>:
.globl vector219
vector219:
  pushl $0
  10260c:	6a 00                	push   $0x0
  pushl $219
  10260e:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102613:	e9 b0 01 00 00       	jmp    1027c8 <__alltraps>

00102618 <vector220>:
.globl vector220
vector220:
  pushl $0
  102618:	6a 00                	push   $0x0
  pushl $220
  10261a:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10261f:	e9 a4 01 00 00       	jmp    1027c8 <__alltraps>

00102624 <vector221>:
.globl vector221
vector221:
  pushl $0
  102624:	6a 00                	push   $0x0
  pushl $221
  102626:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10262b:	e9 98 01 00 00       	jmp    1027c8 <__alltraps>

00102630 <vector222>:
.globl vector222
vector222:
  pushl $0
  102630:	6a 00                	push   $0x0
  pushl $222
  102632:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102637:	e9 8c 01 00 00       	jmp    1027c8 <__alltraps>

0010263c <vector223>:
.globl vector223
vector223:
  pushl $0
  10263c:	6a 00                	push   $0x0
  pushl $223
  10263e:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102643:	e9 80 01 00 00       	jmp    1027c8 <__alltraps>

00102648 <vector224>:
.globl vector224
vector224:
  pushl $0
  102648:	6a 00                	push   $0x0
  pushl $224
  10264a:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10264f:	e9 74 01 00 00       	jmp    1027c8 <__alltraps>

00102654 <vector225>:
.globl vector225
vector225:
  pushl $0
  102654:	6a 00                	push   $0x0
  pushl $225
  102656:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10265b:	e9 68 01 00 00       	jmp    1027c8 <__alltraps>

00102660 <vector226>:
.globl vector226
vector226:
  pushl $0
  102660:	6a 00                	push   $0x0
  pushl $226
  102662:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102667:	e9 5c 01 00 00       	jmp    1027c8 <__alltraps>

0010266c <vector227>:
.globl vector227
vector227:
  pushl $0
  10266c:	6a 00                	push   $0x0
  pushl $227
  10266e:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102673:	e9 50 01 00 00       	jmp    1027c8 <__alltraps>

00102678 <vector228>:
.globl vector228
vector228:
  pushl $0
  102678:	6a 00                	push   $0x0
  pushl $228
  10267a:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10267f:	e9 44 01 00 00       	jmp    1027c8 <__alltraps>

00102684 <vector229>:
.globl vector229
vector229:
  pushl $0
  102684:	6a 00                	push   $0x0
  pushl $229
  102686:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10268b:	e9 38 01 00 00       	jmp    1027c8 <__alltraps>

00102690 <vector230>:
.globl vector230
vector230:
  pushl $0
  102690:	6a 00                	push   $0x0
  pushl $230
  102692:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102697:	e9 2c 01 00 00       	jmp    1027c8 <__alltraps>

0010269c <vector231>:
.globl vector231
vector231:
  pushl $0
  10269c:	6a 00                	push   $0x0
  pushl $231
  10269e:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1026a3:	e9 20 01 00 00       	jmp    1027c8 <__alltraps>

001026a8 <vector232>:
.globl vector232
vector232:
  pushl $0
  1026a8:	6a 00                	push   $0x0
  pushl $232
  1026aa:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1026af:	e9 14 01 00 00       	jmp    1027c8 <__alltraps>

001026b4 <vector233>:
.globl vector233
vector233:
  pushl $0
  1026b4:	6a 00                	push   $0x0
  pushl $233
  1026b6:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1026bb:	e9 08 01 00 00       	jmp    1027c8 <__alltraps>

001026c0 <vector234>:
.globl vector234
vector234:
  pushl $0
  1026c0:	6a 00                	push   $0x0
  pushl $234
  1026c2:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1026c7:	e9 fc 00 00 00       	jmp    1027c8 <__alltraps>

001026cc <vector235>:
.globl vector235
vector235:
  pushl $0
  1026cc:	6a 00                	push   $0x0
  pushl $235
  1026ce:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1026d3:	e9 f0 00 00 00       	jmp    1027c8 <__alltraps>

001026d8 <vector236>:
.globl vector236
vector236:
  pushl $0
  1026d8:	6a 00                	push   $0x0
  pushl $236
  1026da:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1026df:	e9 e4 00 00 00       	jmp    1027c8 <__alltraps>

001026e4 <vector237>:
.globl vector237
vector237:
  pushl $0
  1026e4:	6a 00                	push   $0x0
  pushl $237
  1026e6:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1026eb:	e9 d8 00 00 00       	jmp    1027c8 <__alltraps>

001026f0 <vector238>:
.globl vector238
vector238:
  pushl $0
  1026f0:	6a 00                	push   $0x0
  pushl $238
  1026f2:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1026f7:	e9 cc 00 00 00       	jmp    1027c8 <__alltraps>

001026fc <vector239>:
.globl vector239
vector239:
  pushl $0
  1026fc:	6a 00                	push   $0x0
  pushl $239
  1026fe:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102703:	e9 c0 00 00 00       	jmp    1027c8 <__alltraps>

00102708 <vector240>:
.globl vector240
vector240:
  pushl $0
  102708:	6a 00                	push   $0x0
  pushl $240
  10270a:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10270f:	e9 b4 00 00 00       	jmp    1027c8 <__alltraps>

00102714 <vector241>:
.globl vector241
vector241:
  pushl $0
  102714:	6a 00                	push   $0x0
  pushl $241
  102716:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10271b:	e9 a8 00 00 00       	jmp    1027c8 <__alltraps>

00102720 <vector242>:
.globl vector242
vector242:
  pushl $0
  102720:	6a 00                	push   $0x0
  pushl $242
  102722:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102727:	e9 9c 00 00 00       	jmp    1027c8 <__alltraps>

0010272c <vector243>:
.globl vector243
vector243:
  pushl $0
  10272c:	6a 00                	push   $0x0
  pushl $243
  10272e:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102733:	e9 90 00 00 00       	jmp    1027c8 <__alltraps>

00102738 <vector244>:
.globl vector244
vector244:
  pushl $0
  102738:	6a 00                	push   $0x0
  pushl $244
  10273a:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10273f:	e9 84 00 00 00       	jmp    1027c8 <__alltraps>

00102744 <vector245>:
.globl vector245
vector245:
  pushl $0
  102744:	6a 00                	push   $0x0
  pushl $245
  102746:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10274b:	e9 78 00 00 00       	jmp    1027c8 <__alltraps>

00102750 <vector246>:
.globl vector246
vector246:
  pushl $0
  102750:	6a 00                	push   $0x0
  pushl $246
  102752:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102757:	e9 6c 00 00 00       	jmp    1027c8 <__alltraps>

0010275c <vector247>:
.globl vector247
vector247:
  pushl $0
  10275c:	6a 00                	push   $0x0
  pushl $247
  10275e:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102763:	e9 60 00 00 00       	jmp    1027c8 <__alltraps>

00102768 <vector248>:
.globl vector248
vector248:
  pushl $0
  102768:	6a 00                	push   $0x0
  pushl $248
  10276a:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10276f:	e9 54 00 00 00       	jmp    1027c8 <__alltraps>

00102774 <vector249>:
.globl vector249
vector249:
  pushl $0
  102774:	6a 00                	push   $0x0
  pushl $249
  102776:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10277b:	e9 48 00 00 00       	jmp    1027c8 <__alltraps>

00102780 <vector250>:
.globl vector250
vector250:
  pushl $0
  102780:	6a 00                	push   $0x0
  pushl $250
  102782:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102787:	e9 3c 00 00 00       	jmp    1027c8 <__alltraps>

0010278c <vector251>:
.globl vector251
vector251:
  pushl $0
  10278c:	6a 00                	push   $0x0
  pushl $251
  10278e:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102793:	e9 30 00 00 00       	jmp    1027c8 <__alltraps>

00102798 <vector252>:
.globl vector252
vector252:
  pushl $0
  102798:	6a 00                	push   $0x0
  pushl $252
  10279a:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10279f:	e9 24 00 00 00       	jmp    1027c8 <__alltraps>

001027a4 <vector253>:
.globl vector253
vector253:
  pushl $0
  1027a4:	6a 00                	push   $0x0
  pushl $253
  1027a6:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1027ab:	e9 18 00 00 00       	jmp    1027c8 <__alltraps>

001027b0 <vector254>:
.globl vector254
vector254:
  pushl $0
  1027b0:	6a 00                	push   $0x0
  pushl $254
  1027b2:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1027b7:	e9 0c 00 00 00       	jmp    1027c8 <__alltraps>

001027bc <vector255>:
.globl vector255
vector255:
  pushl $0
  1027bc:	6a 00                	push   $0x0
  pushl $255
  1027be:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1027c3:	e9 00 00 00 00       	jmp    1027c8 <__alltraps>

001027c8 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  1027c8:	1e                   	push   %ds
    pushl %es
  1027c9:	06                   	push   %es
    pushl %fs
  1027ca:	0f a0                	push   %fs
    pushl %gs
  1027cc:	0f a8                	push   %gs
    pushal
  1027ce:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  1027cf:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  1027d4:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  1027d6:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  1027d8:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  1027d9:	e8 63 f5 ff ff       	call   101d41 <trap>

    # pop the pushed stack pointer
    popl %esp
  1027de:	5c                   	pop    %esp

001027df <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  1027df:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  1027e0:	0f a9                	pop    %gs
    popl %fs
  1027e2:	0f a1                	pop    %fs
    popl %es
  1027e4:	07                   	pop    %es
    popl %ds
  1027e5:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  1027e6:	83 c4 08             	add    $0x8,%esp
    iret
  1027e9:	cf                   	iret   

001027ea <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1027ea:	55                   	push   %ebp
  1027eb:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1027ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1027f0:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1027f3:	b8 23 00 00 00       	mov    $0x23,%eax
  1027f8:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1027fa:	b8 23 00 00 00       	mov    $0x23,%eax
  1027ff:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102801:	b8 10 00 00 00       	mov    $0x10,%eax
  102806:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102808:	b8 10 00 00 00       	mov    $0x10,%eax
  10280d:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  10280f:	b8 10 00 00 00       	mov    $0x10,%eax
  102814:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102816:	ea 1d 28 10 00 08 00 	ljmp   $0x8,$0x10281d
}
  10281d:	90                   	nop
  10281e:	5d                   	pop    %ebp
  10281f:	c3                   	ret    

00102820 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102820:	55                   	push   %ebp
  102821:	89 e5                	mov    %esp,%ebp
  102823:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102826:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  10282b:	05 00 04 00 00       	add    $0x400,%eax
  102830:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  102835:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  10283c:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  10283e:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102845:	68 00 
  102847:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  10284c:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  102852:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102857:	c1 e8 10             	shr    $0x10,%eax
  10285a:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  10285f:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102866:	83 e0 f0             	and    $0xfffffff0,%eax
  102869:	83 c8 09             	or     $0x9,%eax
  10286c:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102871:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102878:	83 c8 10             	or     $0x10,%eax
  10287b:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102880:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102887:	83 e0 9f             	and    $0xffffff9f,%eax
  10288a:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10288f:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102896:	83 c8 80             	or     $0xffffff80,%eax
  102899:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10289e:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028a5:	83 e0 f0             	and    $0xfffffff0,%eax
  1028a8:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028ad:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028b4:	83 e0 ef             	and    $0xffffffef,%eax
  1028b7:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028bc:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028c3:	83 e0 df             	and    $0xffffffdf,%eax
  1028c6:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028cb:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028d2:	83 c8 40             	or     $0x40,%eax
  1028d5:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028da:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028e1:	83 e0 7f             	and    $0x7f,%eax
  1028e4:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028e9:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1028ee:	c1 e8 18             	shr    $0x18,%eax
  1028f1:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  1028f6:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028fd:	83 e0 ef             	and    $0xffffffef,%eax
  102900:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102905:	68 10 ea 10 00       	push   $0x10ea10
  10290a:	e8 db fe ff ff       	call   1027ea <lgdt>
  10290f:	83 c4 04             	add    $0x4,%esp
  102912:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102918:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  10291c:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  10291f:	90                   	nop
  102920:	c9                   	leave  
  102921:	c3                   	ret    

00102922 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102922:	55                   	push   %ebp
  102923:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102925:	e8 f6 fe ff ff       	call   102820 <gdt_init>
}
  10292a:	90                   	nop
  10292b:	5d                   	pop    %ebp
  10292c:	c3                   	ret    

0010292d <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  10292d:	55                   	push   %ebp
  10292e:	89 e5                	mov    %esp,%ebp
  102930:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102933:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  10293a:	eb 04                	jmp    102940 <strlen+0x13>
        cnt ++;
  10293c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  102940:	8b 45 08             	mov    0x8(%ebp),%eax
  102943:	8d 50 01             	lea    0x1(%eax),%edx
  102946:	89 55 08             	mov    %edx,0x8(%ebp)
  102949:	0f b6 00             	movzbl (%eax),%eax
  10294c:	84 c0                	test   %al,%al
  10294e:	75 ec                	jne    10293c <strlen+0xf>
        cnt ++;
    }
    return cnt;
  102950:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102953:	c9                   	leave  
  102954:	c3                   	ret    

00102955 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102955:	55                   	push   %ebp
  102956:	89 e5                	mov    %esp,%ebp
  102958:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10295b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102962:	eb 04                	jmp    102968 <strnlen+0x13>
        cnt ++;
  102964:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  102968:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10296b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10296e:	73 10                	jae    102980 <strnlen+0x2b>
  102970:	8b 45 08             	mov    0x8(%ebp),%eax
  102973:	8d 50 01             	lea    0x1(%eax),%edx
  102976:	89 55 08             	mov    %edx,0x8(%ebp)
  102979:	0f b6 00             	movzbl (%eax),%eax
  10297c:	84 c0                	test   %al,%al
  10297e:	75 e4                	jne    102964 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  102980:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102983:	c9                   	leave  
  102984:	c3                   	ret    

00102985 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102985:	55                   	push   %ebp
  102986:	89 e5                	mov    %esp,%ebp
  102988:	57                   	push   %edi
  102989:	56                   	push   %esi
  10298a:	83 ec 20             	sub    $0x20,%esp
  10298d:	8b 45 08             	mov    0x8(%ebp),%eax
  102990:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102993:	8b 45 0c             	mov    0xc(%ebp),%eax
  102996:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102999:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10299f:	89 d1                	mov    %edx,%ecx
  1029a1:	89 c2                	mov    %eax,%edx
  1029a3:	89 ce                	mov    %ecx,%esi
  1029a5:	89 d7                	mov    %edx,%edi
  1029a7:	ac                   	lods   %ds:(%esi),%al
  1029a8:	aa                   	stos   %al,%es:(%edi)
  1029a9:	84 c0                	test   %al,%al
  1029ab:	75 fa                	jne    1029a7 <strcpy+0x22>
  1029ad:	89 fa                	mov    %edi,%edx
  1029af:	89 f1                	mov    %esi,%ecx
  1029b1:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1029b4:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1029b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  1029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1029bd:	83 c4 20             	add    $0x20,%esp
  1029c0:	5e                   	pop    %esi
  1029c1:	5f                   	pop    %edi
  1029c2:	5d                   	pop    %ebp
  1029c3:	c3                   	ret    

001029c4 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1029c4:	55                   	push   %ebp
  1029c5:	89 e5                	mov    %esp,%ebp
  1029c7:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1029ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1029cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1029d0:	eb 21                	jmp    1029f3 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  1029d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029d5:	0f b6 10             	movzbl (%eax),%edx
  1029d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1029db:	88 10                	mov    %dl,(%eax)
  1029dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1029e0:	0f b6 00             	movzbl (%eax),%eax
  1029e3:	84 c0                	test   %al,%al
  1029e5:	74 04                	je     1029eb <strncpy+0x27>
            src ++;
  1029e7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  1029eb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1029ef:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  1029f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1029f7:	75 d9                	jne    1029d2 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  1029f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1029fc:	c9                   	leave  
  1029fd:	c3                   	ret    

001029fe <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1029fe:	55                   	push   %ebp
  1029ff:	89 e5                	mov    %esp,%ebp
  102a01:	57                   	push   %edi
  102a02:	56                   	push   %esi
  102a03:	83 ec 20             	sub    $0x20,%esp
  102a06:	8b 45 08             	mov    0x8(%ebp),%eax
  102a09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  102a12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a18:	89 d1                	mov    %edx,%ecx
  102a1a:	89 c2                	mov    %eax,%edx
  102a1c:	89 ce                	mov    %ecx,%esi
  102a1e:	89 d7                	mov    %edx,%edi
  102a20:	ac                   	lods   %ds:(%esi),%al
  102a21:	ae                   	scas   %es:(%edi),%al
  102a22:	75 08                	jne    102a2c <strcmp+0x2e>
  102a24:	84 c0                	test   %al,%al
  102a26:	75 f8                	jne    102a20 <strcmp+0x22>
  102a28:	31 c0                	xor    %eax,%eax
  102a2a:	eb 04                	jmp    102a30 <strcmp+0x32>
  102a2c:	19 c0                	sbb    %eax,%eax
  102a2e:	0c 01                	or     $0x1,%al
  102a30:	89 fa                	mov    %edi,%edx
  102a32:	89 f1                	mov    %esi,%ecx
  102a34:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102a37:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102a3a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  102a3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102a40:	83 c4 20             	add    $0x20,%esp
  102a43:	5e                   	pop    %esi
  102a44:	5f                   	pop    %edi
  102a45:	5d                   	pop    %ebp
  102a46:	c3                   	ret    

00102a47 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102a47:	55                   	push   %ebp
  102a48:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102a4a:	eb 0c                	jmp    102a58 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  102a4c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102a50:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102a54:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102a58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102a5c:	74 1a                	je     102a78 <strncmp+0x31>
  102a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a61:	0f b6 00             	movzbl (%eax),%eax
  102a64:	84 c0                	test   %al,%al
  102a66:	74 10                	je     102a78 <strncmp+0x31>
  102a68:	8b 45 08             	mov    0x8(%ebp),%eax
  102a6b:	0f b6 10             	movzbl (%eax),%edx
  102a6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a71:	0f b6 00             	movzbl (%eax),%eax
  102a74:	38 c2                	cmp    %al,%dl
  102a76:	74 d4                	je     102a4c <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102a78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102a7c:	74 18                	je     102a96 <strncmp+0x4f>
  102a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a81:	0f b6 00             	movzbl (%eax),%eax
  102a84:	0f b6 d0             	movzbl %al,%edx
  102a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a8a:	0f b6 00             	movzbl (%eax),%eax
  102a8d:	0f b6 c0             	movzbl %al,%eax
  102a90:	29 c2                	sub    %eax,%edx
  102a92:	89 d0                	mov    %edx,%eax
  102a94:	eb 05                	jmp    102a9b <strncmp+0x54>
  102a96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102a9b:	5d                   	pop    %ebp
  102a9c:	c3                   	ret    

00102a9d <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102a9d:	55                   	push   %ebp
  102a9e:	89 e5                	mov    %esp,%ebp
  102aa0:	83 ec 04             	sub    $0x4,%esp
  102aa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102aa6:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102aa9:	eb 14                	jmp    102abf <strchr+0x22>
        if (*s == c) {
  102aab:	8b 45 08             	mov    0x8(%ebp),%eax
  102aae:	0f b6 00             	movzbl (%eax),%eax
  102ab1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102ab4:	75 05                	jne    102abb <strchr+0x1e>
            return (char *)s;
  102ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab9:	eb 13                	jmp    102ace <strchr+0x31>
        }
        s ++;
  102abb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  102abf:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac2:	0f b6 00             	movzbl (%eax),%eax
  102ac5:	84 c0                	test   %al,%al
  102ac7:	75 e2                	jne    102aab <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  102ac9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102ace:	c9                   	leave  
  102acf:	c3                   	ret    

00102ad0 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102ad0:	55                   	push   %ebp
  102ad1:	89 e5                	mov    %esp,%ebp
  102ad3:	83 ec 04             	sub    $0x4,%esp
  102ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ad9:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102adc:	eb 11                	jmp    102aef <strfind+0x1f>
        if (*s == c) {
  102ade:	8b 45 08             	mov    0x8(%ebp),%eax
  102ae1:	0f b6 00             	movzbl (%eax),%eax
  102ae4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102ae7:	75 02                	jne    102aeb <strfind+0x1b>
            break;
  102ae9:	eb 0e                	jmp    102af9 <strfind+0x29>
        }
        s ++;
  102aeb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  102aef:	8b 45 08             	mov    0x8(%ebp),%eax
  102af2:	0f b6 00             	movzbl (%eax),%eax
  102af5:	84 c0                	test   %al,%al
  102af7:	75 e5                	jne    102ade <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  102af9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102afc:	c9                   	leave  
  102afd:	c3                   	ret    

00102afe <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102afe:	55                   	push   %ebp
  102aff:	89 e5                	mov    %esp,%ebp
  102b01:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102b04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102b0b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102b12:	eb 04                	jmp    102b18 <strtol+0x1a>
        s ++;
  102b14:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102b18:	8b 45 08             	mov    0x8(%ebp),%eax
  102b1b:	0f b6 00             	movzbl (%eax),%eax
  102b1e:	3c 20                	cmp    $0x20,%al
  102b20:	74 f2                	je     102b14 <strtol+0x16>
  102b22:	8b 45 08             	mov    0x8(%ebp),%eax
  102b25:	0f b6 00             	movzbl (%eax),%eax
  102b28:	3c 09                	cmp    $0x9,%al
  102b2a:	74 e8                	je     102b14 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  102b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b2f:	0f b6 00             	movzbl (%eax),%eax
  102b32:	3c 2b                	cmp    $0x2b,%al
  102b34:	75 06                	jne    102b3c <strtol+0x3e>
        s ++;
  102b36:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102b3a:	eb 15                	jmp    102b51 <strtol+0x53>
    }
    else if (*s == '-') {
  102b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b3f:	0f b6 00             	movzbl (%eax),%eax
  102b42:	3c 2d                	cmp    $0x2d,%al
  102b44:	75 0b                	jne    102b51 <strtol+0x53>
        s ++, neg = 1;
  102b46:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102b4a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102b51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b55:	74 06                	je     102b5d <strtol+0x5f>
  102b57:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102b5b:	75 24                	jne    102b81 <strtol+0x83>
  102b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  102b60:	0f b6 00             	movzbl (%eax),%eax
  102b63:	3c 30                	cmp    $0x30,%al
  102b65:	75 1a                	jne    102b81 <strtol+0x83>
  102b67:	8b 45 08             	mov    0x8(%ebp),%eax
  102b6a:	83 c0 01             	add    $0x1,%eax
  102b6d:	0f b6 00             	movzbl (%eax),%eax
  102b70:	3c 78                	cmp    $0x78,%al
  102b72:	75 0d                	jne    102b81 <strtol+0x83>
        s += 2, base = 16;
  102b74:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102b78:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102b7f:	eb 2a                	jmp    102bab <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  102b81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b85:	75 17                	jne    102b9e <strtol+0xa0>
  102b87:	8b 45 08             	mov    0x8(%ebp),%eax
  102b8a:	0f b6 00             	movzbl (%eax),%eax
  102b8d:	3c 30                	cmp    $0x30,%al
  102b8f:	75 0d                	jne    102b9e <strtol+0xa0>
        s ++, base = 8;
  102b91:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102b95:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102b9c:	eb 0d                	jmp    102bab <strtol+0xad>
    }
    else if (base == 0) {
  102b9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ba2:	75 07                	jne    102bab <strtol+0xad>
        base = 10;
  102ba4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102bab:	8b 45 08             	mov    0x8(%ebp),%eax
  102bae:	0f b6 00             	movzbl (%eax),%eax
  102bb1:	3c 2f                	cmp    $0x2f,%al
  102bb3:	7e 1b                	jle    102bd0 <strtol+0xd2>
  102bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  102bb8:	0f b6 00             	movzbl (%eax),%eax
  102bbb:	3c 39                	cmp    $0x39,%al
  102bbd:	7f 11                	jg     102bd0 <strtol+0xd2>
            dig = *s - '0';
  102bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  102bc2:	0f b6 00             	movzbl (%eax),%eax
  102bc5:	0f be c0             	movsbl %al,%eax
  102bc8:	83 e8 30             	sub    $0x30,%eax
  102bcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102bce:	eb 48                	jmp    102c18 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  102bd3:	0f b6 00             	movzbl (%eax),%eax
  102bd6:	3c 60                	cmp    $0x60,%al
  102bd8:	7e 1b                	jle    102bf5 <strtol+0xf7>
  102bda:	8b 45 08             	mov    0x8(%ebp),%eax
  102bdd:	0f b6 00             	movzbl (%eax),%eax
  102be0:	3c 7a                	cmp    $0x7a,%al
  102be2:	7f 11                	jg     102bf5 <strtol+0xf7>
            dig = *s - 'a' + 10;
  102be4:	8b 45 08             	mov    0x8(%ebp),%eax
  102be7:	0f b6 00             	movzbl (%eax),%eax
  102bea:	0f be c0             	movsbl %al,%eax
  102bed:	83 e8 57             	sub    $0x57,%eax
  102bf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102bf3:	eb 23                	jmp    102c18 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf8:	0f b6 00             	movzbl (%eax),%eax
  102bfb:	3c 40                	cmp    $0x40,%al
  102bfd:	7e 3d                	jle    102c3c <strtol+0x13e>
  102bff:	8b 45 08             	mov    0x8(%ebp),%eax
  102c02:	0f b6 00             	movzbl (%eax),%eax
  102c05:	3c 5a                	cmp    $0x5a,%al
  102c07:	7f 33                	jg     102c3c <strtol+0x13e>
            dig = *s - 'A' + 10;
  102c09:	8b 45 08             	mov    0x8(%ebp),%eax
  102c0c:	0f b6 00             	movzbl (%eax),%eax
  102c0f:	0f be c0             	movsbl %al,%eax
  102c12:	83 e8 37             	sub    $0x37,%eax
  102c15:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c1b:	3b 45 10             	cmp    0x10(%ebp),%eax
  102c1e:	7c 02                	jl     102c22 <strtol+0x124>
            break;
  102c20:	eb 1a                	jmp    102c3c <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  102c22:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102c26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102c29:	0f af 45 10          	imul   0x10(%ebp),%eax
  102c2d:	89 c2                	mov    %eax,%edx
  102c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c32:	01 d0                	add    %edx,%eax
  102c34:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  102c37:	e9 6f ff ff ff       	jmp    102bab <strtol+0xad>

    if (endptr) {
  102c3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c40:	74 08                	je     102c4a <strtol+0x14c>
        *endptr = (char *) s;
  102c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c45:	8b 55 08             	mov    0x8(%ebp),%edx
  102c48:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102c4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102c4e:	74 07                	je     102c57 <strtol+0x159>
  102c50:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102c53:	f7 d8                	neg    %eax
  102c55:	eb 03                	jmp    102c5a <strtol+0x15c>
  102c57:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102c5a:	c9                   	leave  
  102c5b:	c3                   	ret    

00102c5c <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102c5c:	55                   	push   %ebp
  102c5d:	89 e5                	mov    %esp,%ebp
  102c5f:	57                   	push   %edi
  102c60:	83 ec 24             	sub    $0x24,%esp
  102c63:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c66:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102c69:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102c6d:	8b 55 08             	mov    0x8(%ebp),%edx
  102c70:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102c73:	88 45 f7             	mov    %al,-0x9(%ebp)
  102c76:	8b 45 10             	mov    0x10(%ebp),%eax
  102c79:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102c7c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102c7f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102c83:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102c86:	89 d7                	mov    %edx,%edi
  102c88:	f3 aa                	rep stos %al,%es:(%edi)
  102c8a:	89 fa                	mov    %edi,%edx
  102c8c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102c8f:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102c92:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102c95:	83 c4 24             	add    $0x24,%esp
  102c98:	5f                   	pop    %edi
  102c99:	5d                   	pop    %ebp
  102c9a:	c3                   	ret    

00102c9b <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102c9b:	55                   	push   %ebp
  102c9c:	89 e5                	mov    %esp,%ebp
  102c9e:	57                   	push   %edi
  102c9f:	56                   	push   %esi
  102ca0:	53                   	push   %ebx
  102ca1:	83 ec 30             	sub    $0x30,%esp
  102ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102cb0:	8b 45 10             	mov    0x10(%ebp),%eax
  102cb3:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cb9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102cbc:	73 42                	jae    102d00 <memmove+0x65>
  102cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cc1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102cc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102cc7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102cca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ccd:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102cd0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102cd3:	c1 e8 02             	shr    $0x2,%eax
  102cd6:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102cd8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102cdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102cde:	89 d7                	mov    %edx,%edi
  102ce0:	89 c6                	mov    %eax,%esi
  102ce2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102ce4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102ce7:	83 e1 03             	and    $0x3,%ecx
  102cea:	74 02                	je     102cee <memmove+0x53>
  102cec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102cee:	89 f0                	mov    %esi,%eax
  102cf0:	89 fa                	mov    %edi,%edx
  102cf2:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102cf5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102cf8:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102cfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102cfe:	eb 36                	jmp    102d36 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102d00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d03:	8d 50 ff             	lea    -0x1(%eax),%edx
  102d06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d09:	01 c2                	add    %eax,%edx
  102d0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d0e:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d14:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  102d17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d1a:	89 c1                	mov    %eax,%ecx
  102d1c:	89 d8                	mov    %ebx,%eax
  102d1e:	89 d6                	mov    %edx,%esi
  102d20:	89 c7                	mov    %eax,%edi
  102d22:	fd                   	std    
  102d23:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102d25:	fc                   	cld    
  102d26:	89 f8                	mov    %edi,%eax
  102d28:	89 f2                	mov    %esi,%edx
  102d2a:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102d2d:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102d30:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  102d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102d36:	83 c4 30             	add    $0x30,%esp
  102d39:	5b                   	pop    %ebx
  102d3a:	5e                   	pop    %esi
  102d3b:	5f                   	pop    %edi
  102d3c:	5d                   	pop    %ebp
  102d3d:	c3                   	ret    

00102d3e <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102d3e:	55                   	push   %ebp
  102d3f:	89 e5                	mov    %esp,%ebp
  102d41:	57                   	push   %edi
  102d42:	56                   	push   %esi
  102d43:	83 ec 20             	sub    $0x20,%esp
  102d46:	8b 45 08             	mov    0x8(%ebp),%eax
  102d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d52:	8b 45 10             	mov    0x10(%ebp),%eax
  102d55:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102d58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d5b:	c1 e8 02             	shr    $0x2,%eax
  102d5e:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102d60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d66:	89 d7                	mov    %edx,%edi
  102d68:	89 c6                	mov    %eax,%esi
  102d6a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102d6c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102d6f:	83 e1 03             	and    $0x3,%ecx
  102d72:	74 02                	je     102d76 <memcpy+0x38>
  102d74:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102d76:	89 f0                	mov    %esi,%eax
  102d78:	89 fa                	mov    %edi,%edx
  102d7a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102d7d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102d80:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102d86:	83 c4 20             	add    $0x20,%esp
  102d89:	5e                   	pop    %esi
  102d8a:	5f                   	pop    %edi
  102d8b:	5d                   	pop    %ebp
  102d8c:	c3                   	ret    

00102d8d <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102d8d:	55                   	push   %ebp
  102d8e:	89 e5                	mov    %esp,%ebp
  102d90:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102d93:	8b 45 08             	mov    0x8(%ebp),%eax
  102d96:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d9c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102d9f:	eb 30                	jmp    102dd1 <memcmp+0x44>
        if (*s1 != *s2) {
  102da1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102da4:	0f b6 10             	movzbl (%eax),%edx
  102da7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102daa:	0f b6 00             	movzbl (%eax),%eax
  102dad:	38 c2                	cmp    %al,%dl
  102daf:	74 18                	je     102dc9 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102db1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102db4:	0f b6 00             	movzbl (%eax),%eax
  102db7:	0f b6 d0             	movzbl %al,%edx
  102dba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102dbd:	0f b6 00             	movzbl (%eax),%eax
  102dc0:	0f b6 c0             	movzbl %al,%eax
  102dc3:	29 c2                	sub    %eax,%edx
  102dc5:	89 d0                	mov    %edx,%eax
  102dc7:	eb 1a                	jmp    102de3 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  102dc9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102dcd:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  102dd1:	8b 45 10             	mov    0x10(%ebp),%eax
  102dd4:	8d 50 ff             	lea    -0x1(%eax),%edx
  102dd7:	89 55 10             	mov    %edx,0x10(%ebp)
  102dda:	85 c0                	test   %eax,%eax
  102ddc:	75 c3                	jne    102da1 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  102dde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102de3:	c9                   	leave  
  102de4:	c3                   	ret    

00102de5 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102de5:	55                   	push   %ebp
  102de6:	89 e5                	mov    %esp,%ebp
  102de8:	83 ec 58             	sub    $0x58,%esp
  102deb:	8b 45 10             	mov    0x10(%ebp),%eax
  102dee:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102df1:	8b 45 14             	mov    0x14(%ebp),%eax
  102df4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102df7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102dfa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102dfd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e00:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102e03:	8b 45 18             	mov    0x18(%ebp),%eax
  102e06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102e09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e0c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102e0f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102e12:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102e15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102e1f:	74 1c                	je     102e3d <printnum+0x58>
  102e21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e24:	ba 00 00 00 00       	mov    $0x0,%edx
  102e29:	f7 75 e4             	divl   -0x1c(%ebp)
  102e2c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102e2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e32:	ba 00 00 00 00       	mov    $0x0,%edx
  102e37:	f7 75 e4             	divl   -0x1c(%ebp)
  102e3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102e43:	f7 75 e4             	divl   -0x1c(%ebp)
  102e46:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102e49:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102e4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e4f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102e52:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e55:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102e58:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102e5b:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102e5e:	8b 45 18             	mov    0x18(%ebp),%eax
  102e61:	ba 00 00 00 00       	mov    $0x0,%edx
  102e66:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102e69:	77 56                	ja     102ec1 <printnum+0xdc>
  102e6b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102e6e:	72 05                	jb     102e75 <printnum+0x90>
  102e70:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102e73:	77 4c                	ja     102ec1 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102e75:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102e78:	8d 50 ff             	lea    -0x1(%eax),%edx
  102e7b:	8b 45 20             	mov    0x20(%ebp),%eax
  102e7e:	89 44 24 18          	mov    %eax,0x18(%esp)
  102e82:	89 54 24 14          	mov    %edx,0x14(%esp)
  102e86:	8b 45 18             	mov    0x18(%ebp),%eax
  102e89:	89 44 24 10          	mov    %eax,0x10(%esp)
  102e8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e90:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102e93:	89 44 24 08          	mov    %eax,0x8(%esp)
  102e97:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea5:	89 04 24             	mov    %eax,(%esp)
  102ea8:	e8 38 ff ff ff       	call   102de5 <printnum>
  102ead:	eb 1c                	jmp    102ecb <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eb2:	89 44 24 04          	mov    %eax,0x4(%esp)
  102eb6:	8b 45 20             	mov    0x20(%ebp),%eax
  102eb9:	89 04 24             	mov    %eax,(%esp)
  102ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  102ebf:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102ec1:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102ec5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102ec9:	7f e4                	jg     102eaf <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102ecb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102ece:	05 10 3c 10 00       	add    $0x103c10,%eax
  102ed3:	0f b6 00             	movzbl (%eax),%eax
  102ed6:	0f be c0             	movsbl %al,%eax
  102ed9:	8b 55 0c             	mov    0xc(%ebp),%edx
  102edc:	89 54 24 04          	mov    %edx,0x4(%esp)
  102ee0:	89 04 24             	mov    %eax,(%esp)
  102ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee6:	ff d0                	call   *%eax
}
  102ee8:	c9                   	leave  
  102ee9:	c3                   	ret    

00102eea <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102eea:	55                   	push   %ebp
  102eeb:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102eed:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102ef1:	7e 14                	jle    102f07 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef6:	8b 00                	mov    (%eax),%eax
  102ef8:	8d 48 08             	lea    0x8(%eax),%ecx
  102efb:	8b 55 08             	mov    0x8(%ebp),%edx
  102efe:	89 0a                	mov    %ecx,(%edx)
  102f00:	8b 50 04             	mov    0x4(%eax),%edx
  102f03:	8b 00                	mov    (%eax),%eax
  102f05:	eb 30                	jmp    102f37 <getuint+0x4d>
    }
    else if (lflag) {
  102f07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102f0b:	74 16                	je     102f23 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f10:	8b 00                	mov    (%eax),%eax
  102f12:	8d 48 04             	lea    0x4(%eax),%ecx
  102f15:	8b 55 08             	mov    0x8(%ebp),%edx
  102f18:	89 0a                	mov    %ecx,(%edx)
  102f1a:	8b 00                	mov    (%eax),%eax
  102f1c:	ba 00 00 00 00       	mov    $0x0,%edx
  102f21:	eb 14                	jmp    102f37 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102f23:	8b 45 08             	mov    0x8(%ebp),%eax
  102f26:	8b 00                	mov    (%eax),%eax
  102f28:	8d 48 04             	lea    0x4(%eax),%ecx
  102f2b:	8b 55 08             	mov    0x8(%ebp),%edx
  102f2e:	89 0a                	mov    %ecx,(%edx)
  102f30:	8b 00                	mov    (%eax),%eax
  102f32:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102f37:	5d                   	pop    %ebp
  102f38:	c3                   	ret    

00102f39 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102f39:	55                   	push   %ebp
  102f3a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102f3c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102f40:	7e 14                	jle    102f56 <getint+0x1d>
        return va_arg(*ap, long long);
  102f42:	8b 45 08             	mov    0x8(%ebp),%eax
  102f45:	8b 00                	mov    (%eax),%eax
  102f47:	8d 48 08             	lea    0x8(%eax),%ecx
  102f4a:	8b 55 08             	mov    0x8(%ebp),%edx
  102f4d:	89 0a                	mov    %ecx,(%edx)
  102f4f:	8b 50 04             	mov    0x4(%eax),%edx
  102f52:	8b 00                	mov    (%eax),%eax
  102f54:	eb 28                	jmp    102f7e <getint+0x45>
    }
    else if (lflag) {
  102f56:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102f5a:	74 12                	je     102f6e <getint+0x35>
        return va_arg(*ap, long);
  102f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  102f5f:	8b 00                	mov    (%eax),%eax
  102f61:	8d 48 04             	lea    0x4(%eax),%ecx
  102f64:	8b 55 08             	mov    0x8(%ebp),%edx
  102f67:	89 0a                	mov    %ecx,(%edx)
  102f69:	8b 00                	mov    (%eax),%eax
  102f6b:	99                   	cltd   
  102f6c:	eb 10                	jmp    102f7e <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  102f71:	8b 00                	mov    (%eax),%eax
  102f73:	8d 48 04             	lea    0x4(%eax),%ecx
  102f76:	8b 55 08             	mov    0x8(%ebp),%edx
  102f79:	89 0a                	mov    %ecx,(%edx)
  102f7b:	8b 00                	mov    (%eax),%eax
  102f7d:	99                   	cltd   
    }
}
  102f7e:	5d                   	pop    %ebp
  102f7f:	c3                   	ret    

00102f80 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102f80:	55                   	push   %ebp
  102f81:	89 e5                	mov    %esp,%ebp
  102f83:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102f86:	8d 45 14             	lea    0x14(%ebp),%eax
  102f89:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f93:	8b 45 10             	mov    0x10(%ebp),%eax
  102f96:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  102fa4:	89 04 24             	mov    %eax,(%esp)
  102fa7:	e8 02 00 00 00       	call   102fae <vprintfmt>
    va_end(ap);
}
  102fac:	c9                   	leave  
  102fad:	c3                   	ret    

00102fae <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102fae:	55                   	push   %ebp
  102faf:	89 e5                	mov    %esp,%ebp
  102fb1:	56                   	push   %esi
  102fb2:	53                   	push   %ebx
  102fb3:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102fb6:	eb 18                	jmp    102fd0 <vprintfmt+0x22>
            if (ch == '\0') {
  102fb8:	85 db                	test   %ebx,%ebx
  102fba:	75 05                	jne    102fc1 <vprintfmt+0x13>
                return;
  102fbc:	e9 d1 03 00 00       	jmp    103392 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fc8:	89 1c 24             	mov    %ebx,(%esp)
  102fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  102fce:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  102fd3:	8d 50 01             	lea    0x1(%eax),%edx
  102fd6:	89 55 10             	mov    %edx,0x10(%ebp)
  102fd9:	0f b6 00             	movzbl (%eax),%eax
  102fdc:	0f b6 d8             	movzbl %al,%ebx
  102fdf:	83 fb 25             	cmp    $0x25,%ebx
  102fe2:	75 d4                	jne    102fb8 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102fe4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102fe8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102fef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ff2:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102ff5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102ffc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102fff:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  103002:	8b 45 10             	mov    0x10(%ebp),%eax
  103005:	8d 50 01             	lea    0x1(%eax),%edx
  103008:	89 55 10             	mov    %edx,0x10(%ebp)
  10300b:	0f b6 00             	movzbl (%eax),%eax
  10300e:	0f b6 d8             	movzbl %al,%ebx
  103011:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103014:	83 f8 55             	cmp    $0x55,%eax
  103017:	0f 87 44 03 00 00    	ja     103361 <vprintfmt+0x3b3>
  10301d:	8b 04 85 34 3c 10 00 	mov    0x103c34(,%eax,4),%eax
  103024:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  103026:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10302a:	eb d6                	jmp    103002 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10302c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  103030:	eb d0                	jmp    103002 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  103032:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  103039:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10303c:	89 d0                	mov    %edx,%eax
  10303e:	c1 e0 02             	shl    $0x2,%eax
  103041:	01 d0                	add    %edx,%eax
  103043:	01 c0                	add    %eax,%eax
  103045:	01 d8                	add    %ebx,%eax
  103047:	83 e8 30             	sub    $0x30,%eax
  10304a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10304d:	8b 45 10             	mov    0x10(%ebp),%eax
  103050:	0f b6 00             	movzbl (%eax),%eax
  103053:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  103056:	83 fb 2f             	cmp    $0x2f,%ebx
  103059:	7e 0b                	jle    103066 <vprintfmt+0xb8>
  10305b:	83 fb 39             	cmp    $0x39,%ebx
  10305e:	7f 06                	jg     103066 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  103060:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  103064:	eb d3                	jmp    103039 <vprintfmt+0x8b>
            goto process_precision;
  103066:	eb 33                	jmp    10309b <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  103068:	8b 45 14             	mov    0x14(%ebp),%eax
  10306b:	8d 50 04             	lea    0x4(%eax),%edx
  10306e:	89 55 14             	mov    %edx,0x14(%ebp)
  103071:	8b 00                	mov    (%eax),%eax
  103073:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  103076:	eb 23                	jmp    10309b <vprintfmt+0xed>

        case '.':
            if (width < 0)
  103078:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10307c:	79 0c                	jns    10308a <vprintfmt+0xdc>
                width = 0;
  10307e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  103085:	e9 78 ff ff ff       	jmp    103002 <vprintfmt+0x54>
  10308a:	e9 73 ff ff ff       	jmp    103002 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  10308f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  103096:	e9 67 ff ff ff       	jmp    103002 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  10309b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10309f:	79 12                	jns    1030b3 <vprintfmt+0x105>
                width = precision, precision = -1;
  1030a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1030a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1030a7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1030ae:	e9 4f ff ff ff       	jmp    103002 <vprintfmt+0x54>
  1030b3:	e9 4a ff ff ff       	jmp    103002 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1030b8:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1030bc:	e9 41 ff ff ff       	jmp    103002 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1030c1:	8b 45 14             	mov    0x14(%ebp),%eax
  1030c4:	8d 50 04             	lea    0x4(%eax),%edx
  1030c7:	89 55 14             	mov    %edx,0x14(%ebp)
  1030ca:	8b 00                	mov    (%eax),%eax
  1030cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  1030cf:	89 54 24 04          	mov    %edx,0x4(%esp)
  1030d3:	89 04 24             	mov    %eax,(%esp)
  1030d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1030d9:	ff d0                	call   *%eax
            break;
  1030db:	e9 ac 02 00 00       	jmp    10338c <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1030e0:	8b 45 14             	mov    0x14(%ebp),%eax
  1030e3:	8d 50 04             	lea    0x4(%eax),%edx
  1030e6:	89 55 14             	mov    %edx,0x14(%ebp)
  1030e9:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1030eb:	85 db                	test   %ebx,%ebx
  1030ed:	79 02                	jns    1030f1 <vprintfmt+0x143>
                err = -err;
  1030ef:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1030f1:	83 fb 06             	cmp    $0x6,%ebx
  1030f4:	7f 0b                	jg     103101 <vprintfmt+0x153>
  1030f6:	8b 34 9d f4 3b 10 00 	mov    0x103bf4(,%ebx,4),%esi
  1030fd:	85 f6                	test   %esi,%esi
  1030ff:	75 23                	jne    103124 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  103101:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  103105:	c7 44 24 08 21 3c 10 	movl   $0x103c21,0x8(%esp)
  10310c:	00 
  10310d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103110:	89 44 24 04          	mov    %eax,0x4(%esp)
  103114:	8b 45 08             	mov    0x8(%ebp),%eax
  103117:	89 04 24             	mov    %eax,(%esp)
  10311a:	e8 61 fe ff ff       	call   102f80 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10311f:	e9 68 02 00 00       	jmp    10338c <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  103124:	89 74 24 0c          	mov    %esi,0xc(%esp)
  103128:	c7 44 24 08 2a 3c 10 	movl   $0x103c2a,0x8(%esp)
  10312f:	00 
  103130:	8b 45 0c             	mov    0xc(%ebp),%eax
  103133:	89 44 24 04          	mov    %eax,0x4(%esp)
  103137:	8b 45 08             	mov    0x8(%ebp),%eax
  10313a:	89 04 24             	mov    %eax,(%esp)
  10313d:	e8 3e fe ff ff       	call   102f80 <printfmt>
            }
            break;
  103142:	e9 45 02 00 00       	jmp    10338c <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  103147:	8b 45 14             	mov    0x14(%ebp),%eax
  10314a:	8d 50 04             	lea    0x4(%eax),%edx
  10314d:	89 55 14             	mov    %edx,0x14(%ebp)
  103150:	8b 30                	mov    (%eax),%esi
  103152:	85 f6                	test   %esi,%esi
  103154:	75 05                	jne    10315b <vprintfmt+0x1ad>
                p = "(null)";
  103156:	be 2d 3c 10 00       	mov    $0x103c2d,%esi
            }
            if (width > 0 && padc != '-') {
  10315b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10315f:	7e 3e                	jle    10319f <vprintfmt+0x1f1>
  103161:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  103165:	74 38                	je     10319f <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  103167:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  10316a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10316d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103171:	89 34 24             	mov    %esi,(%esp)
  103174:	e8 dc f7 ff ff       	call   102955 <strnlen>
  103179:	29 c3                	sub    %eax,%ebx
  10317b:	89 d8                	mov    %ebx,%eax
  10317d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103180:	eb 17                	jmp    103199 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  103182:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  103186:	8b 55 0c             	mov    0xc(%ebp),%edx
  103189:	89 54 24 04          	mov    %edx,0x4(%esp)
  10318d:	89 04 24             	mov    %eax,(%esp)
  103190:	8b 45 08             	mov    0x8(%ebp),%eax
  103193:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  103195:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103199:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10319d:	7f e3                	jg     103182 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10319f:	eb 38                	jmp    1031d9 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  1031a1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1031a5:	74 1f                	je     1031c6 <vprintfmt+0x218>
  1031a7:	83 fb 1f             	cmp    $0x1f,%ebx
  1031aa:	7e 05                	jle    1031b1 <vprintfmt+0x203>
  1031ac:	83 fb 7e             	cmp    $0x7e,%ebx
  1031af:	7e 15                	jle    1031c6 <vprintfmt+0x218>
                    putch('?', putdat);
  1031b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031b8:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  1031bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1031c2:	ff d0                	call   *%eax
  1031c4:	eb 0f                	jmp    1031d5 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  1031c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031cd:	89 1c 24             	mov    %ebx,(%esp)
  1031d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1031d3:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1031d5:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1031d9:	89 f0                	mov    %esi,%eax
  1031db:	8d 70 01             	lea    0x1(%eax),%esi
  1031de:	0f b6 00             	movzbl (%eax),%eax
  1031e1:	0f be d8             	movsbl %al,%ebx
  1031e4:	85 db                	test   %ebx,%ebx
  1031e6:	74 10                	je     1031f8 <vprintfmt+0x24a>
  1031e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1031ec:	78 b3                	js     1031a1 <vprintfmt+0x1f3>
  1031ee:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  1031f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1031f6:	79 a9                	jns    1031a1 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1031f8:	eb 17                	jmp    103211 <vprintfmt+0x263>
                putch(' ', putdat);
  1031fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  103201:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  103208:	8b 45 08             	mov    0x8(%ebp),%eax
  10320b:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  10320d:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103211:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103215:	7f e3                	jg     1031fa <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  103217:	e9 70 01 00 00       	jmp    10338c <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10321c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10321f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103223:	8d 45 14             	lea    0x14(%ebp),%eax
  103226:	89 04 24             	mov    %eax,(%esp)
  103229:	e8 0b fd ff ff       	call   102f39 <getint>
  10322e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103231:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  103234:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103237:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10323a:	85 d2                	test   %edx,%edx
  10323c:	79 26                	jns    103264 <vprintfmt+0x2b6>
                putch('-', putdat);
  10323e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103241:	89 44 24 04          	mov    %eax,0x4(%esp)
  103245:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  10324c:	8b 45 08             	mov    0x8(%ebp),%eax
  10324f:	ff d0                	call   *%eax
                num = -(long long)num;
  103251:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103254:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103257:	f7 d8                	neg    %eax
  103259:	83 d2 00             	adc    $0x0,%edx
  10325c:	f7 da                	neg    %edx
  10325e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103261:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  103264:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10326b:	e9 a8 00 00 00       	jmp    103318 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  103270:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103273:	89 44 24 04          	mov    %eax,0x4(%esp)
  103277:	8d 45 14             	lea    0x14(%ebp),%eax
  10327a:	89 04 24             	mov    %eax,(%esp)
  10327d:	e8 68 fc ff ff       	call   102eea <getuint>
  103282:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103285:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  103288:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10328f:	e9 84 00 00 00       	jmp    103318 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  103294:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103297:	89 44 24 04          	mov    %eax,0x4(%esp)
  10329b:	8d 45 14             	lea    0x14(%ebp),%eax
  10329e:	89 04 24             	mov    %eax,(%esp)
  1032a1:	e8 44 fc ff ff       	call   102eea <getuint>
  1032a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1032ac:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1032b3:	eb 63                	jmp    103318 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  1032b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032bc:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  1032c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c6:	ff d0                	call   *%eax
            putch('x', putdat);
  1032c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032cf:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  1032d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1032d9:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1032db:	8b 45 14             	mov    0x14(%ebp),%eax
  1032de:	8d 50 04             	lea    0x4(%eax),%edx
  1032e1:	89 55 14             	mov    %edx,0x14(%ebp)
  1032e4:	8b 00                	mov    (%eax),%eax
  1032e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1032f0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1032f7:	eb 1f                	jmp    103318 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1032f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1032fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  103300:	8d 45 14             	lea    0x14(%ebp),%eax
  103303:	89 04 24             	mov    %eax,(%esp)
  103306:	e8 df fb ff ff       	call   102eea <getuint>
  10330b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10330e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103311:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103318:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10331c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10331f:	89 54 24 18          	mov    %edx,0x18(%esp)
  103323:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103326:	89 54 24 14          	mov    %edx,0x14(%esp)
  10332a:	89 44 24 10          	mov    %eax,0x10(%esp)
  10332e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103331:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103334:	89 44 24 08          	mov    %eax,0x8(%esp)
  103338:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10333c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10333f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103343:	8b 45 08             	mov    0x8(%ebp),%eax
  103346:	89 04 24             	mov    %eax,(%esp)
  103349:	e8 97 fa ff ff       	call   102de5 <printnum>
            break;
  10334e:	eb 3c                	jmp    10338c <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103350:	8b 45 0c             	mov    0xc(%ebp),%eax
  103353:	89 44 24 04          	mov    %eax,0x4(%esp)
  103357:	89 1c 24             	mov    %ebx,(%esp)
  10335a:	8b 45 08             	mov    0x8(%ebp),%eax
  10335d:	ff d0                	call   *%eax
            break;
  10335f:	eb 2b                	jmp    10338c <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103361:	8b 45 0c             	mov    0xc(%ebp),%eax
  103364:	89 44 24 04          	mov    %eax,0x4(%esp)
  103368:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  10336f:	8b 45 08             	mov    0x8(%ebp),%eax
  103372:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  103374:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103378:	eb 04                	jmp    10337e <vprintfmt+0x3d0>
  10337a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10337e:	8b 45 10             	mov    0x10(%ebp),%eax
  103381:	83 e8 01             	sub    $0x1,%eax
  103384:	0f b6 00             	movzbl (%eax),%eax
  103387:	3c 25                	cmp    $0x25,%al
  103389:	75 ef                	jne    10337a <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  10338b:	90                   	nop
        }
    }
  10338c:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10338d:	e9 3e fc ff ff       	jmp    102fd0 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  103392:	83 c4 40             	add    $0x40,%esp
  103395:	5b                   	pop    %ebx
  103396:	5e                   	pop    %esi
  103397:	5d                   	pop    %ebp
  103398:	c3                   	ret    

00103399 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103399:	55                   	push   %ebp
  10339a:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  10339c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10339f:	8b 40 08             	mov    0x8(%eax),%eax
  1033a2:	8d 50 01             	lea    0x1(%eax),%edx
  1033a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033a8:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1033ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033ae:	8b 10                	mov    (%eax),%edx
  1033b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033b3:	8b 40 04             	mov    0x4(%eax),%eax
  1033b6:	39 c2                	cmp    %eax,%edx
  1033b8:	73 12                	jae    1033cc <sprintputch+0x33>
        *b->buf ++ = ch;
  1033ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033bd:	8b 00                	mov    (%eax),%eax
  1033bf:	8d 48 01             	lea    0x1(%eax),%ecx
  1033c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1033c5:	89 0a                	mov    %ecx,(%edx)
  1033c7:	8b 55 08             	mov    0x8(%ebp),%edx
  1033ca:	88 10                	mov    %dl,(%eax)
    }
}
  1033cc:	5d                   	pop    %ebp
  1033cd:	c3                   	ret    

001033ce <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1033ce:	55                   	push   %ebp
  1033cf:	89 e5                	mov    %esp,%ebp
  1033d1:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1033d4:	8d 45 14             	lea    0x14(%ebp),%eax
  1033d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1033da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033dd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1033e1:	8b 45 10             	mov    0x10(%ebp),%eax
  1033e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1033e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1033f2:	89 04 24             	mov    %eax,(%esp)
  1033f5:	e8 08 00 00 00       	call   103402 <vsnprintf>
  1033fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1033fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103400:	c9                   	leave  
  103401:	c3                   	ret    

00103402 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103402:	55                   	push   %ebp
  103403:	89 e5                	mov    %esp,%ebp
  103405:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103408:	8b 45 08             	mov    0x8(%ebp),%eax
  10340b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10340e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103411:	8d 50 ff             	lea    -0x1(%eax),%edx
  103414:	8b 45 08             	mov    0x8(%ebp),%eax
  103417:	01 d0                	add    %edx,%eax
  103419:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10341c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103423:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103427:	74 0a                	je     103433 <vsnprintf+0x31>
  103429:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10342c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10342f:	39 c2                	cmp    %eax,%edx
  103431:	76 07                	jbe    10343a <vsnprintf+0x38>
        return -E_INVAL;
  103433:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103438:	eb 2a                	jmp    103464 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10343a:	8b 45 14             	mov    0x14(%ebp),%eax
  10343d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103441:	8b 45 10             	mov    0x10(%ebp),%eax
  103444:	89 44 24 08          	mov    %eax,0x8(%esp)
  103448:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10344b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10344f:	c7 04 24 99 33 10 00 	movl   $0x103399,(%esp)
  103456:	e8 53 fb ff ff       	call   102fae <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  10345b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10345e:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103461:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103464:	c9                   	leave  
  103465:	c3                   	ret    
