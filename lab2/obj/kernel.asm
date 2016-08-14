
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 68 89 11 c0       	mov    $0xc0118968,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	83 ec 04             	sub    $0x4,%esp
c0100041:	50                   	push   %eax
c0100042:	6a 00                	push   $0x0
c0100044:	68 36 7a 11 c0       	push   $0xc0117a36
c0100049:	e8 8b 53 00 00       	call   c01053d9 <memset>
c010004e:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c0100051:	e8 53 15 00 00       	call   c01015a9 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100056:	c7 45 f4 80 5b 10 c0 	movl   $0xc0105b80,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010005d:	83 ec 08             	sub    $0x8,%esp
c0100060:	ff 75 f4             	pushl  -0xc(%ebp)
c0100063:	68 9c 5b 10 c0       	push   $0xc0105b9c
c0100068:	e8 fa 01 00 00       	call   c0100267 <cprintf>
c010006d:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c0100070:	e8 7c 08 00 00       	call   c01008f1 <print_kerninfo>

    grade_backtrace();
c0100075:	e8 74 00 00 00       	call   c01000ee <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007a:	e8 a6 30 00 00       	call   c0103125 <pmm_init>

    pic_init();                 // init interrupt controller
c010007f:	e8 97 16 00 00       	call   c010171b <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100084:	e8 f8 17 00 00       	call   c0101881 <idt_init>

    clock_init();               // init clock interrupt
c0100089:	e8 c2 0c 00 00       	call   c0100d50 <clock_init>
    intr_enable();              // enable irq interrupt
c010008e:	e8 c5 17 00 00       	call   c0101858 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100093:	eb fe                	jmp    c0100093 <kern_init+0x69>

c0100095 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c0100095:	55                   	push   %ebp
c0100096:	89 e5                	mov    %esp,%ebp
c0100098:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
c010009b:	83 ec 04             	sub    $0x4,%esp
c010009e:	6a 00                	push   $0x0
c01000a0:	6a 00                	push   $0x0
c01000a2:	6a 00                	push   $0x0
c01000a4:	e8 95 0c 00 00       	call   c0100d3e <mon_backtrace>
c01000a9:	83 c4 10             	add    $0x10,%esp
}
c01000ac:	90                   	nop
c01000ad:	c9                   	leave  
c01000ae:	c3                   	ret    

c01000af <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000af:	55                   	push   %ebp
c01000b0:	89 e5                	mov    %esp,%ebp
c01000b2:	53                   	push   %ebx
c01000b3:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000b6:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000b9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000bc:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01000c2:	51                   	push   %ecx
c01000c3:	52                   	push   %edx
c01000c4:	53                   	push   %ebx
c01000c5:	50                   	push   %eax
c01000c6:	e8 ca ff ff ff       	call   c0100095 <grade_backtrace2>
c01000cb:	83 c4 10             	add    $0x10,%esp
}
c01000ce:	90                   	nop
c01000cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000d2:	c9                   	leave  
c01000d3:	c3                   	ret    

c01000d4 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000d4:	55                   	push   %ebp
c01000d5:	89 e5                	mov    %esp,%ebp
c01000d7:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
c01000da:	83 ec 08             	sub    $0x8,%esp
c01000dd:	ff 75 10             	pushl  0x10(%ebp)
c01000e0:	ff 75 08             	pushl  0x8(%ebp)
c01000e3:	e8 c7 ff ff ff       	call   c01000af <grade_backtrace1>
c01000e8:	83 c4 10             	add    $0x10,%esp
}
c01000eb:	90                   	nop
c01000ec:	c9                   	leave  
c01000ed:	c3                   	ret    

c01000ee <grade_backtrace>:

void
grade_backtrace(void) {
c01000ee:	55                   	push   %ebp
c01000ef:	89 e5                	mov    %esp,%ebp
c01000f1:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c01000f4:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01000f9:	83 ec 04             	sub    $0x4,%esp
c01000fc:	68 00 00 ff ff       	push   $0xffff0000
c0100101:	50                   	push   %eax
c0100102:	6a 00                	push   $0x0
c0100104:	e8 cb ff ff ff       	call   c01000d4 <grade_backtrace0>
c0100109:	83 c4 10             	add    $0x10,%esp
}
c010010c:	90                   	nop
c010010d:	c9                   	leave  
c010010e:	c3                   	ret    

c010010f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010010f:	55                   	push   %ebp
c0100110:	89 e5                	mov    %esp,%ebp
c0100112:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100115:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100118:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010011b:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010011e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100121:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100125:	0f b7 c0             	movzwl %ax,%eax
c0100128:	83 e0 03             	and    $0x3,%eax
c010012b:	89 c2                	mov    %eax,%edx
c010012d:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100132:	83 ec 04             	sub    $0x4,%esp
c0100135:	52                   	push   %edx
c0100136:	50                   	push   %eax
c0100137:	68 a1 5b 10 c0       	push   $0xc0105ba1
c010013c:	e8 26 01 00 00       	call   c0100267 <cprintf>
c0100141:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c0100144:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100148:	0f b7 d0             	movzwl %ax,%edx
c010014b:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100150:	83 ec 04             	sub    $0x4,%esp
c0100153:	52                   	push   %edx
c0100154:	50                   	push   %eax
c0100155:	68 af 5b 10 c0       	push   $0xc0105baf
c010015a:	e8 08 01 00 00       	call   c0100267 <cprintf>
c010015f:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c0100162:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100166:	0f b7 d0             	movzwl %ax,%edx
c0100169:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016e:	83 ec 04             	sub    $0x4,%esp
c0100171:	52                   	push   %edx
c0100172:	50                   	push   %eax
c0100173:	68 bd 5b 10 c0       	push   $0xc0105bbd
c0100178:	e8 ea 00 00 00       	call   c0100267 <cprintf>
c010017d:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c0100180:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100184:	0f b7 d0             	movzwl %ax,%edx
c0100187:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018c:	83 ec 04             	sub    $0x4,%esp
c010018f:	52                   	push   %edx
c0100190:	50                   	push   %eax
c0100191:	68 cb 5b 10 c0       	push   $0xc0105bcb
c0100196:	e8 cc 00 00 00       	call   c0100267 <cprintf>
c010019b:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c010019e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001a2:	0f b7 d0             	movzwl %ax,%edx
c01001a5:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001aa:	83 ec 04             	sub    $0x4,%esp
c01001ad:	52                   	push   %edx
c01001ae:	50                   	push   %eax
c01001af:	68 d9 5b 10 c0       	push   $0xc0105bd9
c01001b4:	e8 ae 00 00 00       	call   c0100267 <cprintf>
c01001b9:	83 c4 10             	add    $0x10,%esp
    round ++;
c01001bc:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001c1:	83 c0 01             	add    $0x1,%eax
c01001c4:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001c9:	90                   	nop
c01001ca:	c9                   	leave  
c01001cb:	c3                   	ret    

c01001cc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001cc:	55                   	push   %ebp
c01001cd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001cf:	90                   	nop
c01001d0:	5d                   	pop    %ebp
c01001d1:	c3                   	ret    

c01001d2 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001d2:	55                   	push   %ebp
c01001d3:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001d5:	90                   	nop
c01001d6:	5d                   	pop    %ebp
c01001d7:	c3                   	ret    

c01001d8 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001d8:	55                   	push   %ebp
c01001d9:	89 e5                	mov    %esp,%ebp
c01001db:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
c01001de:	e8 2c ff ff ff       	call   c010010f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c01001e3:	83 ec 0c             	sub    $0xc,%esp
c01001e6:	68 e8 5b 10 c0       	push   $0xc0105be8
c01001eb:	e8 77 00 00 00       	call   c0100267 <cprintf>
c01001f0:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c01001f3:	e8 d4 ff ff ff       	call   c01001cc <lab1_switch_to_user>
    lab1_print_cur_status();
c01001f8:	e8 12 ff ff ff       	call   c010010f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c01001fd:	83 ec 0c             	sub    $0xc,%esp
c0100200:	68 08 5c 10 c0       	push   $0xc0105c08
c0100205:	e8 5d 00 00 00       	call   c0100267 <cprintf>
c010020a:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
c010020d:	e8 c0 ff ff ff       	call   c01001d2 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100212:	e8 f8 fe ff ff       	call   c010010f <lab1_print_cur_status>
}
c0100217:	90                   	nop
c0100218:	c9                   	leave  
c0100219:	c3                   	ret    

c010021a <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010021a:	55                   	push   %ebp
c010021b:	89 e5                	mov    %esp,%ebp
c010021d:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c0100220:	83 ec 0c             	sub    $0xc,%esp
c0100223:	ff 75 08             	pushl  0x8(%ebp)
c0100226:	e8 af 13 00 00       	call   c01015da <cons_putc>
c010022b:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
c010022e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100231:	8b 00                	mov    (%eax),%eax
c0100233:	8d 50 01             	lea    0x1(%eax),%edx
c0100236:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100239:	89 10                	mov    %edx,(%eax)
}
c010023b:	90                   	nop
c010023c:	c9                   	leave  
c010023d:	c3                   	ret    

c010023e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010023e:	55                   	push   %ebp
c010023f:	89 e5                	mov    %esp,%ebp
c0100241:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c0100244:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010024b:	ff 75 0c             	pushl  0xc(%ebp)
c010024e:	ff 75 08             	pushl  0x8(%ebp)
c0100251:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100254:	50                   	push   %eax
c0100255:	68 1a 02 10 c0       	push   $0xc010021a
c010025a:	e8 b0 54 00 00       	call   c010570f <vprintfmt>
c010025f:	83 c4 10             	add    $0x10,%esp
    return cnt;
c0100262:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100265:	c9                   	leave  
c0100266:	c3                   	ret    

c0100267 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100267:	55                   	push   %ebp
c0100268:	89 e5                	mov    %esp,%ebp
c010026a:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010026d:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100270:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100273:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100276:	83 ec 08             	sub    $0x8,%esp
c0100279:	50                   	push   %eax
c010027a:	ff 75 08             	pushl  0x8(%ebp)
c010027d:	e8 bc ff ff ff       	call   c010023e <vcprintf>
c0100282:	83 c4 10             	add    $0x10,%esp
c0100285:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010028b:	c9                   	leave  
c010028c:	c3                   	ret    

c010028d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010028d:	55                   	push   %ebp
c010028e:	89 e5                	mov    %esp,%ebp
c0100290:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c0100293:	83 ec 0c             	sub    $0xc,%esp
c0100296:	ff 75 08             	pushl  0x8(%ebp)
c0100299:	e8 3c 13 00 00       	call   c01015da <cons_putc>
c010029e:	83 c4 10             	add    $0x10,%esp
}
c01002a1:	90                   	nop
c01002a2:	c9                   	leave  
c01002a3:	c3                   	ret    

c01002a4 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002a4:	55                   	push   %ebp
c01002a5:	89 e5                	mov    %esp,%ebp
c01002a7:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c01002aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002b1:	eb 14                	jmp    c01002c7 <cputs+0x23>
        cputch(c, &cnt);
c01002b3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002b7:	83 ec 08             	sub    $0x8,%esp
c01002ba:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002bd:	52                   	push   %edx
c01002be:	50                   	push   %eax
c01002bf:	e8 56 ff ff ff       	call   c010021a <cputch>
c01002c4:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01002c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01002ca:	8d 50 01             	lea    0x1(%eax),%edx
c01002cd:	89 55 08             	mov    %edx,0x8(%ebp)
c01002d0:	0f b6 00             	movzbl (%eax),%eax
c01002d3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01002d6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01002da:	75 d7                	jne    c01002b3 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01002dc:	83 ec 08             	sub    $0x8,%esp
c01002df:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01002e2:	50                   	push   %eax
c01002e3:	6a 0a                	push   $0xa
c01002e5:	e8 30 ff ff ff       	call   c010021a <cputch>
c01002ea:	83 c4 10             	add    $0x10,%esp
    return cnt;
c01002ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01002f0:	c9                   	leave  
c01002f1:	c3                   	ret    

c01002f2 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01002f2:	55                   	push   %ebp
c01002f3:	89 e5                	mov    %esp,%ebp
c01002f5:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01002f8:	e8 26 13 00 00       	call   c0101623 <cons_getc>
c01002fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100300:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100304:	74 f2                	je     c01002f8 <getchar+0x6>
        /* do nothing */;
    return c;
c0100306:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100309:	c9                   	leave  
c010030a:	c3                   	ret    

c010030b <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010030b:	55                   	push   %ebp
c010030c:	89 e5                	mov    %esp,%ebp
c010030e:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
c0100311:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100315:	74 13                	je     c010032a <readline+0x1f>
        cprintf("%s", prompt);
c0100317:	83 ec 08             	sub    $0x8,%esp
c010031a:	ff 75 08             	pushl  0x8(%ebp)
c010031d:	68 27 5c 10 c0       	push   $0xc0105c27
c0100322:	e8 40 ff ff ff       	call   c0100267 <cprintf>
c0100327:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
c010032a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100331:	e8 bc ff ff ff       	call   c01002f2 <getchar>
c0100336:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100339:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010033d:	79 0a                	jns    c0100349 <readline+0x3e>
            return NULL;
c010033f:	b8 00 00 00 00       	mov    $0x0,%eax
c0100344:	e9 82 00 00 00       	jmp    c01003cb <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100349:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010034d:	7e 2b                	jle    c010037a <readline+0x6f>
c010034f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100356:	7f 22                	jg     c010037a <readline+0x6f>
            cputchar(c);
c0100358:	83 ec 0c             	sub    $0xc,%esp
c010035b:	ff 75 f0             	pushl  -0x10(%ebp)
c010035e:	e8 2a ff ff ff       	call   c010028d <cputchar>
c0100363:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
c0100366:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100369:	8d 50 01             	lea    0x1(%eax),%edx
c010036c:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010036f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100372:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c0100378:	eb 4c                	jmp    c01003c6 <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
c010037a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c010037e:	75 1a                	jne    c010039a <readline+0x8f>
c0100380:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100384:	7e 14                	jle    c010039a <readline+0x8f>
            cputchar(c);
c0100386:	83 ec 0c             	sub    $0xc,%esp
c0100389:	ff 75 f0             	pushl  -0x10(%ebp)
c010038c:	e8 fc fe ff ff       	call   c010028d <cputchar>
c0100391:	83 c4 10             	add    $0x10,%esp
            i --;
c0100394:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0100398:	eb 2c                	jmp    c01003c6 <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
c010039a:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c010039e:	74 06                	je     c01003a6 <readline+0x9b>
c01003a0:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003a4:	75 8b                	jne    c0100331 <readline+0x26>
            cputchar(c);
c01003a6:	83 ec 0c             	sub    $0xc,%esp
c01003a9:	ff 75 f0             	pushl  -0x10(%ebp)
c01003ac:	e8 dc fe ff ff       	call   c010028d <cputchar>
c01003b1:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
c01003b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003b7:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01003bc:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003bf:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01003c4:	eb 05                	jmp    c01003cb <readline+0xc0>
        }
    }
c01003c6:	e9 66 ff ff ff       	jmp    c0100331 <readline+0x26>
}
c01003cb:	c9                   	leave  
c01003cc:	c3                   	ret    

c01003cd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003cd:	55                   	push   %ebp
c01003ce:	89 e5                	mov    %esp,%ebp
c01003d0:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
c01003d3:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c01003d8:	85 c0                	test   %eax,%eax
c01003da:	75 4a                	jne    c0100426 <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
c01003dc:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c01003e3:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c01003e6:	8d 45 14             	lea    0x14(%ebp),%eax
c01003e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c01003ec:	83 ec 04             	sub    $0x4,%esp
c01003ef:	ff 75 0c             	pushl  0xc(%ebp)
c01003f2:	ff 75 08             	pushl  0x8(%ebp)
c01003f5:	68 2a 5c 10 c0       	push   $0xc0105c2a
c01003fa:	e8 68 fe ff ff       	call   c0100267 <cprintf>
c01003ff:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c0100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100405:	83 ec 08             	sub    $0x8,%esp
c0100408:	50                   	push   %eax
c0100409:	ff 75 10             	pushl  0x10(%ebp)
c010040c:	e8 2d fe ff ff       	call   c010023e <vcprintf>
c0100411:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100414:	83 ec 0c             	sub    $0xc,%esp
c0100417:	68 46 5c 10 c0       	push   $0xc0105c46
c010041c:	e8 46 fe ff ff       	call   c0100267 <cprintf>
c0100421:	83 c4 10             	add    $0x10,%esp
c0100424:	eb 01                	jmp    c0100427 <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
c0100426:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
c0100427:	e8 33 14 00 00       	call   c010185f <intr_disable>
    while (1) {
        kmonitor(NULL);
c010042c:	83 ec 0c             	sub    $0xc,%esp
c010042f:	6a 00                	push   $0x0
c0100431:	e8 2e 08 00 00       	call   c0100c64 <kmonitor>
c0100436:	83 c4 10             	add    $0x10,%esp
    }
c0100439:	eb f1                	jmp    c010042c <__panic+0x5f>

c010043b <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c010043b:	55                   	push   %ebp
c010043c:	89 e5                	mov    %esp,%ebp
c010043e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
c0100441:	8d 45 14             	lea    0x14(%ebp),%eax
c0100444:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100447:	83 ec 04             	sub    $0x4,%esp
c010044a:	ff 75 0c             	pushl  0xc(%ebp)
c010044d:	ff 75 08             	pushl  0x8(%ebp)
c0100450:	68 48 5c 10 c0       	push   $0xc0105c48
c0100455:	e8 0d fe ff ff       	call   c0100267 <cprintf>
c010045a:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c010045d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100460:	83 ec 08             	sub    $0x8,%esp
c0100463:	50                   	push   %eax
c0100464:	ff 75 10             	pushl  0x10(%ebp)
c0100467:	e8 d2 fd ff ff       	call   c010023e <vcprintf>
c010046c:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c010046f:	83 ec 0c             	sub    $0xc,%esp
c0100472:	68 46 5c 10 c0       	push   $0xc0105c46
c0100477:	e8 eb fd ff ff       	call   c0100267 <cprintf>
c010047c:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c010047f:	90                   	nop
c0100480:	c9                   	leave  
c0100481:	c3                   	ret    

c0100482 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100482:	55                   	push   %ebp
c0100483:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100485:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c010048a:	5d                   	pop    %ebp
c010048b:	c3                   	ret    

c010048c <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c010048c:	55                   	push   %ebp
c010048d:	89 e5                	mov    %esp,%ebp
c010048f:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c0100492:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100495:	8b 00                	mov    (%eax),%eax
c0100497:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010049a:	8b 45 10             	mov    0x10(%ebp),%eax
c010049d:	8b 00                	mov    (%eax),%eax
c010049f:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004a9:	e9 d2 00 00 00       	jmp    c0100580 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01004ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004b4:	01 d0                	add    %edx,%eax
c01004b6:	89 c2                	mov    %eax,%edx
c01004b8:	c1 ea 1f             	shr    $0x1f,%edx
c01004bb:	01 d0                	add    %edx,%eax
c01004bd:	d1 f8                	sar    %eax
c01004bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004c5:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004c8:	eb 04                	jmp    c01004ce <stab_binsearch+0x42>
            m --;
c01004ca:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004d4:	7c 1f                	jl     c01004f5 <stab_binsearch+0x69>
c01004d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004d9:	89 d0                	mov    %edx,%eax
c01004db:	01 c0                	add    %eax,%eax
c01004dd:	01 d0                	add    %edx,%eax
c01004df:	c1 e0 02             	shl    $0x2,%eax
c01004e2:	89 c2                	mov    %eax,%edx
c01004e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01004e7:	01 d0                	add    %edx,%eax
c01004e9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01004ed:	0f b6 c0             	movzbl %al,%eax
c01004f0:	3b 45 14             	cmp    0x14(%ebp),%eax
c01004f3:	75 d5                	jne    c01004ca <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c01004f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004fb:	7d 0b                	jge    c0100508 <stab_binsearch+0x7c>
            l = true_m + 1;
c01004fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100500:	83 c0 01             	add    $0x1,%eax
c0100503:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100506:	eb 78                	jmp    c0100580 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100508:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010050f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100512:	89 d0                	mov    %edx,%eax
c0100514:	01 c0                	add    %eax,%eax
c0100516:	01 d0                	add    %edx,%eax
c0100518:	c1 e0 02             	shl    $0x2,%eax
c010051b:	89 c2                	mov    %eax,%edx
c010051d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100520:	01 d0                	add    %edx,%eax
c0100522:	8b 40 08             	mov    0x8(%eax),%eax
c0100525:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100528:	73 13                	jae    c010053d <stab_binsearch+0xb1>
            *region_left = m;
c010052a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100530:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100532:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100535:	83 c0 01             	add    $0x1,%eax
c0100538:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010053b:	eb 43                	jmp    c0100580 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010053d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100540:	89 d0                	mov    %edx,%eax
c0100542:	01 c0                	add    %eax,%eax
c0100544:	01 d0                	add    %edx,%eax
c0100546:	c1 e0 02             	shl    $0x2,%eax
c0100549:	89 c2                	mov    %eax,%edx
c010054b:	8b 45 08             	mov    0x8(%ebp),%eax
c010054e:	01 d0                	add    %edx,%eax
c0100550:	8b 40 08             	mov    0x8(%eax),%eax
c0100553:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100556:	76 16                	jbe    c010056e <stab_binsearch+0xe2>
            *region_right = m - 1;
c0100558:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010055b:	8d 50 ff             	lea    -0x1(%eax),%edx
c010055e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100561:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c0100563:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100566:	83 e8 01             	sub    $0x1,%eax
c0100569:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010056c:	eb 12                	jmp    c0100580 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c010056e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100571:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100574:	89 10                	mov    %edx,(%eax)
            l = m;
c0100576:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100579:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c010057c:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c0100580:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100583:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0100586:	0f 8e 22 ff ff ff    	jle    c01004ae <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c010058c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100590:	75 0f                	jne    c01005a1 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c0100592:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100595:	8b 00                	mov    (%eax),%eax
c0100597:	8d 50 ff             	lea    -0x1(%eax),%edx
c010059a:	8b 45 10             	mov    0x10(%ebp),%eax
c010059d:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c010059f:	eb 3f                	jmp    c01005e0 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01005a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01005a4:	8b 00                	mov    (%eax),%eax
c01005a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005a9:	eb 04                	jmp    c01005af <stab_binsearch+0x123>
c01005ab:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c01005af:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005b2:	8b 00                	mov    (%eax),%eax
c01005b4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01005b7:	7d 1f                	jge    c01005d8 <stab_binsearch+0x14c>
c01005b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005bc:	89 d0                	mov    %edx,%eax
c01005be:	01 c0                	add    %eax,%eax
c01005c0:	01 d0                	add    %edx,%eax
c01005c2:	c1 e0 02             	shl    $0x2,%eax
c01005c5:	89 c2                	mov    %eax,%edx
c01005c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01005ca:	01 d0                	add    %edx,%eax
c01005cc:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01005d0:	0f b6 c0             	movzbl %al,%eax
c01005d3:	3b 45 14             	cmp    0x14(%ebp),%eax
c01005d6:	75 d3                	jne    c01005ab <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c01005d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005db:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005de:	89 10                	mov    %edx,(%eax)
    }
}
c01005e0:	90                   	nop
c01005e1:	c9                   	leave  
c01005e2:	c3                   	ret    

c01005e3 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c01005e3:	55                   	push   %ebp
c01005e4:	89 e5                	mov    %esp,%ebp
c01005e6:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c01005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ec:	c7 00 68 5c 10 c0    	movl   $0xc0105c68,(%eax)
    info->eip_line = 0;
c01005f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c01005fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ff:	c7 40 08 68 5c 10 c0 	movl   $0xc0105c68,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100606:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100609:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100610:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100613:	8b 55 08             	mov    0x8(%ebp),%edx
c0100616:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100619:	8b 45 0c             	mov    0xc(%ebp),%eax
c010061c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100623:	c7 45 f4 bc 6e 10 c0 	movl   $0xc0106ebc,-0xc(%ebp)
    stab_end = __STAB_END__;
c010062a:	c7 45 f0 e0 1c 11 c0 	movl   $0xc0111ce0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100631:	c7 45 ec e1 1c 11 c0 	movl   $0xc0111ce1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100638:	c7 45 e8 cd 47 11 c0 	movl   $0xc01147cd,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010063f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100642:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100645:	76 0d                	jbe    c0100654 <debuginfo_eip+0x71>
c0100647:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010064a:	83 e8 01             	sub    $0x1,%eax
c010064d:	0f b6 00             	movzbl (%eax),%eax
c0100650:	84 c0                	test   %al,%al
c0100652:	74 0a                	je     c010065e <debuginfo_eip+0x7b>
        return -1;
c0100654:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100659:	e9 91 02 00 00       	jmp    c01008ef <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c010065e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0100665:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100668:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010066b:	29 c2                	sub    %eax,%edx
c010066d:	89 d0                	mov    %edx,%eax
c010066f:	c1 f8 02             	sar    $0x2,%eax
c0100672:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c0100678:	83 e8 01             	sub    $0x1,%eax
c010067b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c010067e:	ff 75 08             	pushl  0x8(%ebp)
c0100681:	6a 64                	push   $0x64
c0100683:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0100686:	50                   	push   %eax
c0100687:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c010068a:	50                   	push   %eax
c010068b:	ff 75 f4             	pushl  -0xc(%ebp)
c010068e:	e8 f9 fd ff ff       	call   c010048c <stab_binsearch>
c0100693:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
c0100696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100699:	85 c0                	test   %eax,%eax
c010069b:	75 0a                	jne    c01006a7 <debuginfo_eip+0xc4>
        return -1;
c010069d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006a2:	e9 48 02 00 00       	jmp    c01008ef <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006b3:	ff 75 08             	pushl  0x8(%ebp)
c01006b6:	6a 24                	push   $0x24
c01006b8:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006bb:	50                   	push   %eax
c01006bc:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006bf:	50                   	push   %eax
c01006c0:	ff 75 f4             	pushl  -0xc(%ebp)
c01006c3:	e8 c4 fd ff ff       	call   c010048c <stab_binsearch>
c01006c8:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
c01006cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01006ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006d1:	39 c2                	cmp    %eax,%edx
c01006d3:	7f 7c                	jg     c0100751 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c01006d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006d8:	89 c2                	mov    %eax,%edx
c01006da:	89 d0                	mov    %edx,%eax
c01006dc:	01 c0                	add    %eax,%eax
c01006de:	01 d0                	add    %edx,%eax
c01006e0:	c1 e0 02             	shl    $0x2,%eax
c01006e3:	89 c2                	mov    %eax,%edx
c01006e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006e8:	01 d0                	add    %edx,%eax
c01006ea:	8b 00                	mov    (%eax),%eax
c01006ec:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01006ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01006f2:	29 d1                	sub    %edx,%ecx
c01006f4:	89 ca                	mov    %ecx,%edx
c01006f6:	39 d0                	cmp    %edx,%eax
c01006f8:	73 22                	jae    c010071c <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c01006fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006fd:	89 c2                	mov    %eax,%edx
c01006ff:	89 d0                	mov    %edx,%eax
c0100701:	01 c0                	add    %eax,%eax
c0100703:	01 d0                	add    %edx,%eax
c0100705:	c1 e0 02             	shl    $0x2,%eax
c0100708:	89 c2                	mov    %eax,%edx
c010070a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010070d:	01 d0                	add    %edx,%eax
c010070f:	8b 10                	mov    (%eax),%edx
c0100711:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100714:	01 c2                	add    %eax,%edx
c0100716:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100719:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010071c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010071f:	89 c2                	mov    %eax,%edx
c0100721:	89 d0                	mov    %edx,%eax
c0100723:	01 c0                	add    %eax,%eax
c0100725:	01 d0                	add    %edx,%eax
c0100727:	c1 e0 02             	shl    $0x2,%eax
c010072a:	89 c2                	mov    %eax,%edx
c010072c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010072f:	01 d0                	add    %edx,%eax
c0100731:	8b 50 08             	mov    0x8(%eax),%edx
c0100734:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100737:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c010073a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010073d:	8b 40 10             	mov    0x10(%eax),%eax
c0100740:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100743:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100746:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c0100749:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010074c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010074f:	eb 15                	jmp    c0100766 <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c0100751:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100754:	8b 55 08             	mov    0x8(%ebp),%edx
c0100757:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c010075a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010075d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c0100760:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100763:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c0100766:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100769:	8b 40 08             	mov    0x8(%eax),%eax
c010076c:	83 ec 08             	sub    $0x8,%esp
c010076f:	6a 3a                	push   $0x3a
c0100771:	50                   	push   %eax
c0100772:	e8 d6 4a 00 00       	call   c010524d <strfind>
c0100777:	83 c4 10             	add    $0x10,%esp
c010077a:	89 c2                	mov    %eax,%edx
c010077c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010077f:	8b 40 08             	mov    0x8(%eax),%eax
c0100782:	29 c2                	sub    %eax,%edx
c0100784:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100787:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010078a:	83 ec 0c             	sub    $0xc,%esp
c010078d:	ff 75 08             	pushl  0x8(%ebp)
c0100790:	6a 44                	push   $0x44
c0100792:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100795:	50                   	push   %eax
c0100796:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100799:	50                   	push   %eax
c010079a:	ff 75 f4             	pushl  -0xc(%ebp)
c010079d:	e8 ea fc ff ff       	call   c010048c <stab_binsearch>
c01007a2:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
c01007a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007ab:	39 c2                	cmp    %eax,%edx
c01007ad:	7f 24                	jg     c01007d3 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
c01007af:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007b2:	89 c2                	mov    %eax,%edx
c01007b4:	89 d0                	mov    %edx,%eax
c01007b6:	01 c0                	add    %eax,%eax
c01007b8:	01 d0                	add    %edx,%eax
c01007ba:	c1 e0 02             	shl    $0x2,%eax
c01007bd:	89 c2                	mov    %eax,%edx
c01007bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007c2:	01 d0                	add    %edx,%eax
c01007c4:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c01007c8:	0f b7 d0             	movzwl %ax,%edx
c01007cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007ce:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c01007d1:	eb 13                	jmp    c01007e6 <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c01007d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01007d8:	e9 12 01 00 00       	jmp    c01008ef <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c01007dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e0:	83 e8 01             	sub    $0x1,%eax
c01007e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c01007e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007ec:	39 c2                	cmp    %eax,%edx
c01007ee:	7c 56                	jl     c0100846 <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
c01007f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f3:	89 c2                	mov    %eax,%edx
c01007f5:	89 d0                	mov    %edx,%eax
c01007f7:	01 c0                	add    %eax,%eax
c01007f9:	01 d0                	add    %edx,%eax
c01007fb:	c1 e0 02             	shl    $0x2,%eax
c01007fe:	89 c2                	mov    %eax,%edx
c0100800:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100803:	01 d0                	add    %edx,%eax
c0100805:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100809:	3c 84                	cmp    $0x84,%al
c010080b:	74 39                	je     c0100846 <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010080d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100810:	89 c2                	mov    %eax,%edx
c0100812:	89 d0                	mov    %edx,%eax
c0100814:	01 c0                	add    %eax,%eax
c0100816:	01 d0                	add    %edx,%eax
c0100818:	c1 e0 02             	shl    $0x2,%eax
c010081b:	89 c2                	mov    %eax,%edx
c010081d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100820:	01 d0                	add    %edx,%eax
c0100822:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100826:	3c 64                	cmp    $0x64,%al
c0100828:	75 b3                	jne    c01007dd <debuginfo_eip+0x1fa>
c010082a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010082d:	89 c2                	mov    %eax,%edx
c010082f:	89 d0                	mov    %edx,%eax
c0100831:	01 c0                	add    %eax,%eax
c0100833:	01 d0                	add    %edx,%eax
c0100835:	c1 e0 02             	shl    $0x2,%eax
c0100838:	89 c2                	mov    %eax,%edx
c010083a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010083d:	01 d0                	add    %edx,%eax
c010083f:	8b 40 08             	mov    0x8(%eax),%eax
c0100842:	85 c0                	test   %eax,%eax
c0100844:	74 97                	je     c01007dd <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c0100846:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010084c:	39 c2                	cmp    %eax,%edx
c010084e:	7c 46                	jl     c0100896 <debuginfo_eip+0x2b3>
c0100850:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100853:	89 c2                	mov    %eax,%edx
c0100855:	89 d0                	mov    %edx,%eax
c0100857:	01 c0                	add    %eax,%eax
c0100859:	01 d0                	add    %edx,%eax
c010085b:	c1 e0 02             	shl    $0x2,%eax
c010085e:	89 c2                	mov    %eax,%edx
c0100860:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100863:	01 d0                	add    %edx,%eax
c0100865:	8b 00                	mov    (%eax),%eax
c0100867:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010086a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010086d:	29 d1                	sub    %edx,%ecx
c010086f:	89 ca                	mov    %ecx,%edx
c0100871:	39 d0                	cmp    %edx,%eax
c0100873:	73 21                	jae    c0100896 <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100875:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100878:	89 c2                	mov    %eax,%edx
c010087a:	89 d0                	mov    %edx,%eax
c010087c:	01 c0                	add    %eax,%eax
c010087e:	01 d0                	add    %edx,%eax
c0100880:	c1 e0 02             	shl    $0x2,%eax
c0100883:	89 c2                	mov    %eax,%edx
c0100885:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100888:	01 d0                	add    %edx,%eax
c010088a:	8b 10                	mov    (%eax),%edx
c010088c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010088f:	01 c2                	add    %eax,%edx
c0100891:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100894:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100896:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100899:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010089c:	39 c2                	cmp    %eax,%edx
c010089e:	7d 4a                	jge    c01008ea <debuginfo_eip+0x307>
        for (lline = lfun + 1;
c01008a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008a3:	83 c0 01             	add    $0x1,%eax
c01008a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01008a9:	eb 18                	jmp    c01008c3 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01008ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008ae:	8b 40 14             	mov    0x14(%eax),%eax
c01008b1:	8d 50 01             	lea    0x1(%eax),%edx
c01008b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008b7:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c01008ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008bd:	83 c0 01             	add    $0x1,%eax
c01008c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008c3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c01008c9:	39 c2                	cmp    %eax,%edx
c01008cb:	7d 1d                	jge    c01008ea <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008d0:	89 c2                	mov    %eax,%edx
c01008d2:	89 d0                	mov    %edx,%eax
c01008d4:	01 c0                	add    %eax,%eax
c01008d6:	01 d0                	add    %edx,%eax
c01008d8:	c1 e0 02             	shl    $0x2,%eax
c01008db:	89 c2                	mov    %eax,%edx
c01008dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008e0:	01 d0                	add    %edx,%eax
c01008e2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008e6:	3c a0                	cmp    $0xa0,%al
c01008e8:	74 c1                	je     c01008ab <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c01008ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01008ef:	c9                   	leave  
c01008f0:	c3                   	ret    

c01008f1 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c01008f1:	55                   	push   %ebp
c01008f2:	89 e5                	mov    %esp,%ebp
c01008f4:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c01008f7:	83 ec 0c             	sub    $0xc,%esp
c01008fa:	68 72 5c 10 c0       	push   $0xc0105c72
c01008ff:	e8 63 f9 ff ff       	call   c0100267 <cprintf>
c0100904:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100907:	83 ec 08             	sub    $0x8,%esp
c010090a:	68 2a 00 10 c0       	push   $0xc010002a
c010090f:	68 8b 5c 10 c0       	push   $0xc0105c8b
c0100914:	e8 4e f9 ff ff       	call   c0100267 <cprintf>
c0100919:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c010091c:	83 ec 08             	sub    $0x8,%esp
c010091f:	68 70 5b 10 c0       	push   $0xc0105b70
c0100924:	68 a3 5c 10 c0       	push   $0xc0105ca3
c0100929:	e8 39 f9 ff ff       	call   c0100267 <cprintf>
c010092e:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100931:	83 ec 08             	sub    $0x8,%esp
c0100934:	68 36 7a 11 c0       	push   $0xc0117a36
c0100939:	68 bb 5c 10 c0       	push   $0xc0105cbb
c010093e:	e8 24 f9 ff ff       	call   c0100267 <cprintf>
c0100943:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c0100946:	83 ec 08             	sub    $0x8,%esp
c0100949:	68 68 89 11 c0       	push   $0xc0118968
c010094e:	68 d3 5c 10 c0       	push   $0xc0105cd3
c0100953:	e8 0f f9 ff ff       	call   c0100267 <cprintf>
c0100958:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c010095b:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0100960:	05 ff 03 00 00       	add    $0x3ff,%eax
c0100965:	ba 2a 00 10 c0       	mov    $0xc010002a,%edx
c010096a:	29 d0                	sub    %edx,%eax
c010096c:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100972:	85 c0                	test   %eax,%eax
c0100974:	0f 48 c2             	cmovs  %edx,%eax
c0100977:	c1 f8 0a             	sar    $0xa,%eax
c010097a:	83 ec 08             	sub    $0x8,%esp
c010097d:	50                   	push   %eax
c010097e:	68 ec 5c 10 c0       	push   $0xc0105cec
c0100983:	e8 df f8 ff ff       	call   c0100267 <cprintf>
c0100988:	83 c4 10             	add    $0x10,%esp
}
c010098b:	90                   	nop
c010098c:	c9                   	leave  
c010098d:	c3                   	ret    

c010098e <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c010098e:	55                   	push   %ebp
c010098f:	89 e5                	mov    %esp,%ebp
c0100991:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100997:	83 ec 08             	sub    $0x8,%esp
c010099a:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010099d:	50                   	push   %eax
c010099e:	ff 75 08             	pushl  0x8(%ebp)
c01009a1:	e8 3d fc ff ff       	call   c01005e3 <debuginfo_eip>
c01009a6:	83 c4 10             	add    $0x10,%esp
c01009a9:	85 c0                	test   %eax,%eax
c01009ab:	74 15                	je     c01009c2 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01009ad:	83 ec 08             	sub    $0x8,%esp
c01009b0:	ff 75 08             	pushl  0x8(%ebp)
c01009b3:	68 16 5d 10 c0       	push   $0xc0105d16
c01009b8:	e8 aa f8 ff ff       	call   c0100267 <cprintf>
c01009bd:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c01009c0:	eb 65                	jmp    c0100a27 <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01009c9:	eb 1c                	jmp    c01009e7 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c01009cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01009ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009d1:	01 d0                	add    %edx,%eax
c01009d3:	0f b6 00             	movzbl (%eax),%eax
c01009d6:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01009df:	01 ca                	add    %ecx,%edx
c01009e1:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01009e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01009ea:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01009ed:	7f dc                	jg     c01009cb <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c01009ef:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c01009f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f8:	01 d0                	add    %edx,%eax
c01009fa:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c01009fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a00:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a03:	89 d1                	mov    %edx,%ecx
c0100a05:	29 c1                	sub    %eax,%ecx
c0100a07:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a0d:	83 ec 0c             	sub    $0xc,%esp
c0100a10:	51                   	push   %ecx
c0100a11:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a17:	51                   	push   %ecx
c0100a18:	52                   	push   %edx
c0100a19:	50                   	push   %eax
c0100a1a:	68 32 5d 10 c0       	push   $0xc0105d32
c0100a1f:	e8 43 f8 ff ff       	call   c0100267 <cprintf>
c0100a24:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a27:	90                   	nop
c0100a28:	c9                   	leave  
c0100a29:	c3                   	ret    

c0100a2a <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a2a:	55                   	push   %ebp
c0100a2b:	89 e5                	mov    %esp,%ebp
c0100a2d:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a30:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a33:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a39:	c9                   	leave  
c0100a3a:	c3                   	ret    

c0100a3b <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a3b:	55                   	push   %ebp
c0100a3c:	89 e5                	mov    %esp,%ebp
c0100a3e:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100a41:	89 e8                	mov    %ebp,%eax
c0100a43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
c0100a46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp, eip;
    int arg_n, stack_depth, i;
     
    ebp = read_ebp();
c0100a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
    eip = read_eip();
c0100a4c:	e8 d9 ff ff ff       	call   c0100a2a <read_eip>
c0100a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
    for( stack_depth = 0; ebp != 0 && stack_depth < STACKFRAME_DEPTH; stack_depth++ ) 
c0100a54:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100a5b:	e9 85 00 00 00       	jmp    c0100ae5 <print_stackframe+0xaa>
    { 
        cprintf( "ebp = 0x%08x eip = 0x%08x args: ", ebp, eip );
c0100a60:	83 ec 04             	sub    $0x4,%esp
c0100a63:	ff 75 f0             	pushl  -0x10(%ebp)
c0100a66:	ff 75 f4             	pushl  -0xc(%ebp)
c0100a69:	68 44 5d 10 c0       	push   $0xc0105d44
c0100a6e:	e8 f4 f7 ff ff       	call   c0100267 <cprintf>
c0100a73:	83 c4 10             	add    $0x10,%esp
        
        for( i = 0; i < 4; i++ ) 
c0100a76:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a7d:	eb 27                	jmp    c0100aa6 <print_stackframe+0x6b>
            cprintf( "0x%08x ", *( ( uint32_t * )( ebp + 8 + 4 * i ) ) );
c0100a7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a82:	c1 e0 02             	shl    $0x2,%eax
c0100a85:	89 c2                	mov    %eax,%edx
c0100a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a8a:	01 d0                	add    %edx,%eax
c0100a8c:	83 c0 08             	add    $0x8,%eax
c0100a8f:	8b 00                	mov    (%eax),%eax
c0100a91:	83 ec 08             	sub    $0x8,%esp
c0100a94:	50                   	push   %eax
c0100a95:	68 65 5d 10 c0       	push   $0xc0105d65
c0100a9a:	e8 c8 f7 ff ff       	call   c0100267 <cprintf>
c0100a9f:	83 c4 10             	add    $0x10,%esp
    
    for( stack_depth = 0; ebp != 0 && stack_depth < STACKFRAME_DEPTH; stack_depth++ ) 
    { 
        cprintf( "ebp = 0x%08x eip = 0x%08x args: ", ebp, eip );
        
        for( i = 0; i < 4; i++ ) 
c0100aa2:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100aa6:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100aaa:	7e d3                	jle    c0100a7f <print_stackframe+0x44>
            cprintf( "0x%08x ", *( ( uint32_t * )( ebp + 8 + 4 * i ) ) );
        
        cprintf( "\n" );
c0100aac:	83 ec 0c             	sub    $0xc,%esp
c0100aaf:	68 6d 5d 10 c0       	push   $0xc0105d6d
c0100ab4:	e8 ae f7 ff ff       	call   c0100267 <cprintf>
c0100ab9:	83 c4 10             	add    $0x10,%esp
        print_debuginfo( eip - 1 );
c0100abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100abf:	83 e8 01             	sub    $0x1,%eax
c0100ac2:	83 ec 0c             	sub    $0xc,%esp
c0100ac5:	50                   	push   %eax
c0100ac6:	e8 c3 fe ff ff       	call   c010098e <print_debuginfo>
c0100acb:	83 c4 10             	add    $0x10,%esp
        eip = *( ( uint32_t * )( ebp + 4 ) );
c0100ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ad1:	83 c0 04             	add    $0x4,%eax
c0100ad4:	8b 00                	mov    (%eax),%eax
c0100ad6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = *( ( uint32_t * )( ebp ) );
c0100ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100adc:	8b 00                	mov    (%eax),%eax
c0100ade:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int arg_n, stack_depth, i;
     
    ebp = read_ebp();
    eip = read_eip();
    
    for( stack_depth = 0; ebp != 0 && stack_depth < STACKFRAME_DEPTH; stack_depth++ ) 
c0100ae1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100ae5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100ae9:	74 0a                	je     c0100af5 <print_stackframe+0xba>
c0100aeb:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100aef:	0f 8e 6b ff ff ff    	jle    c0100a60 <print_stackframe+0x25>
        cprintf( "\n" );
        print_debuginfo( eip - 1 );
        eip = *( ( uint32_t * )( ebp + 4 ) );
        ebp = *( ( uint32_t * )( ebp ) );
    }        
}
c0100af5:	90                   	nop
c0100af6:	c9                   	leave  
c0100af7:	c3                   	ret    

c0100af8 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100af8:	55                   	push   %ebp
c0100af9:	89 e5                	mov    %esp,%ebp
c0100afb:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
c0100afe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b05:	eb 0c                	jmp    c0100b13 <parse+0x1b>
            *buf ++ = '\0';
c0100b07:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0a:	8d 50 01             	lea    0x1(%eax),%edx
c0100b0d:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b10:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b13:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b16:	0f b6 00             	movzbl (%eax),%eax
c0100b19:	84 c0                	test   %al,%al
c0100b1b:	74 1e                	je     c0100b3b <parse+0x43>
c0100b1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b20:	0f b6 00             	movzbl (%eax),%eax
c0100b23:	0f be c0             	movsbl %al,%eax
c0100b26:	83 ec 08             	sub    $0x8,%esp
c0100b29:	50                   	push   %eax
c0100b2a:	68 f0 5d 10 c0       	push   $0xc0105df0
c0100b2f:	e8 e6 46 00 00       	call   c010521a <strchr>
c0100b34:	83 c4 10             	add    $0x10,%esp
c0100b37:	85 c0                	test   %eax,%eax
c0100b39:	75 cc                	jne    c0100b07 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100b3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b3e:	0f b6 00             	movzbl (%eax),%eax
c0100b41:	84 c0                	test   %al,%al
c0100b43:	74 69                	je     c0100bae <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100b45:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100b49:	75 12                	jne    c0100b5d <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100b4b:	83 ec 08             	sub    $0x8,%esp
c0100b4e:	6a 10                	push   $0x10
c0100b50:	68 f5 5d 10 c0       	push   $0xc0105df5
c0100b55:	e8 0d f7 ff ff       	call   c0100267 <cprintf>
c0100b5a:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
c0100b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b60:	8d 50 01             	lea    0x1(%eax),%edx
c0100b63:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b66:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b70:	01 c2                	add    %eax,%edx
c0100b72:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b75:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b77:	eb 04                	jmp    c0100b7d <parse+0x85>
            buf ++;
c0100b79:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b80:	0f b6 00             	movzbl (%eax),%eax
c0100b83:	84 c0                	test   %al,%al
c0100b85:	0f 84 7a ff ff ff    	je     c0100b05 <parse+0xd>
c0100b8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b8e:	0f b6 00             	movzbl (%eax),%eax
c0100b91:	0f be c0             	movsbl %al,%eax
c0100b94:	83 ec 08             	sub    $0x8,%esp
c0100b97:	50                   	push   %eax
c0100b98:	68 f0 5d 10 c0       	push   $0xc0105df0
c0100b9d:	e8 78 46 00 00       	call   c010521a <strchr>
c0100ba2:	83 c4 10             	add    $0x10,%esp
c0100ba5:	85 c0                	test   %eax,%eax
c0100ba7:	74 d0                	je     c0100b79 <parse+0x81>
            buf ++;
        }
    }
c0100ba9:	e9 57 ff ff ff       	jmp    c0100b05 <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
c0100bae:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100bb2:	c9                   	leave  
c0100bb3:	c3                   	ret    

c0100bb4 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100bb4:	55                   	push   %ebp
c0100bb5:	89 e5                	mov    %esp,%ebp
c0100bb7:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100bba:	83 ec 08             	sub    $0x8,%esp
c0100bbd:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100bc0:	50                   	push   %eax
c0100bc1:	ff 75 08             	pushl  0x8(%ebp)
c0100bc4:	e8 2f ff ff ff       	call   c0100af8 <parse>
c0100bc9:	83 c4 10             	add    $0x10,%esp
c0100bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100bcf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100bd3:	75 0a                	jne    c0100bdf <runcmd+0x2b>
        return 0;
c0100bd5:	b8 00 00 00 00       	mov    $0x0,%eax
c0100bda:	e9 83 00 00 00       	jmp    c0100c62 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bdf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100be6:	eb 59                	jmp    c0100c41 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100be8:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100beb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bee:	89 d0                	mov    %edx,%eax
c0100bf0:	01 c0                	add    %eax,%eax
c0100bf2:	01 d0                	add    %edx,%eax
c0100bf4:	c1 e0 02             	shl    $0x2,%eax
c0100bf7:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100bfc:	8b 00                	mov    (%eax),%eax
c0100bfe:	83 ec 08             	sub    $0x8,%esp
c0100c01:	51                   	push   %ecx
c0100c02:	50                   	push   %eax
c0100c03:	e8 72 45 00 00       	call   c010517a <strcmp>
c0100c08:	83 c4 10             	add    $0x10,%esp
c0100c0b:	85 c0                	test   %eax,%eax
c0100c0d:	75 2e                	jne    c0100c3d <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c12:	89 d0                	mov    %edx,%eax
c0100c14:	01 c0                	add    %eax,%eax
c0100c16:	01 d0                	add    %edx,%eax
c0100c18:	c1 e0 02             	shl    $0x2,%eax
c0100c1b:	05 28 70 11 c0       	add    $0xc0117028,%eax
c0100c20:	8b 10                	mov    (%eax),%edx
c0100c22:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c25:	83 c0 04             	add    $0x4,%eax
c0100c28:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100c2b:	83 e9 01             	sub    $0x1,%ecx
c0100c2e:	83 ec 04             	sub    $0x4,%esp
c0100c31:	ff 75 0c             	pushl  0xc(%ebp)
c0100c34:	50                   	push   %eax
c0100c35:	51                   	push   %ecx
c0100c36:	ff d2                	call   *%edx
c0100c38:	83 c4 10             	add    $0x10,%esp
c0100c3b:	eb 25                	jmp    c0100c62 <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c3d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c44:	83 f8 02             	cmp    $0x2,%eax
c0100c47:	76 9f                	jbe    c0100be8 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100c49:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100c4c:	83 ec 08             	sub    $0x8,%esp
c0100c4f:	50                   	push   %eax
c0100c50:	68 13 5e 10 c0       	push   $0xc0105e13
c0100c55:	e8 0d f6 ff ff       	call   c0100267 <cprintf>
c0100c5a:	83 c4 10             	add    $0x10,%esp
    return 0;
c0100c5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c62:	c9                   	leave  
c0100c63:	c3                   	ret    

c0100c64 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c64:	55                   	push   %ebp
c0100c65:	89 e5                	mov    %esp,%ebp
c0100c67:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c6a:	83 ec 0c             	sub    $0xc,%esp
c0100c6d:	68 2c 5e 10 c0       	push   $0xc0105e2c
c0100c72:	e8 f0 f5 ff ff       	call   c0100267 <cprintf>
c0100c77:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100c7a:	83 ec 0c             	sub    $0xc,%esp
c0100c7d:	68 54 5e 10 c0       	push   $0xc0105e54
c0100c82:	e8 e0 f5 ff ff       	call   c0100267 <cprintf>
c0100c87:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100c8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c8e:	74 0e                	je     c0100c9e <kmonitor+0x3a>
        print_trapframe(tf);
c0100c90:	83 ec 0c             	sub    $0xc,%esp
c0100c93:	ff 75 08             	pushl  0x8(%ebp)
c0100c96:	e8 9e 0d 00 00       	call   c0101a39 <print_trapframe>
c0100c9b:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c9e:	83 ec 0c             	sub    $0xc,%esp
c0100ca1:	68 79 5e 10 c0       	push   $0xc0105e79
c0100ca6:	e8 60 f6 ff ff       	call   c010030b <readline>
c0100cab:	83 c4 10             	add    $0x10,%esp
c0100cae:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100cb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100cb5:	74 e7                	je     c0100c9e <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
c0100cb7:	83 ec 08             	sub    $0x8,%esp
c0100cba:	ff 75 08             	pushl  0x8(%ebp)
c0100cbd:	ff 75 f4             	pushl  -0xc(%ebp)
c0100cc0:	e8 ef fe ff ff       	call   c0100bb4 <runcmd>
c0100cc5:	83 c4 10             	add    $0x10,%esp
c0100cc8:	85 c0                	test   %eax,%eax
c0100cca:	78 02                	js     c0100cce <kmonitor+0x6a>
                break;
            }
        }
    }
c0100ccc:	eb d0                	jmp    c0100c9e <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
c0100cce:	90                   	nop
            }
        }
    }
}
c0100ccf:	90                   	nop
c0100cd0:	c9                   	leave  
c0100cd1:	c3                   	ret    

c0100cd2 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100cd2:	55                   	push   %ebp
c0100cd3:	89 e5                	mov    %esp,%ebp
c0100cd5:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100cdf:	eb 3c                	jmp    c0100d1d <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100ce1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ce4:	89 d0                	mov    %edx,%eax
c0100ce6:	01 c0                	add    %eax,%eax
c0100ce8:	01 d0                	add    %edx,%eax
c0100cea:	c1 e0 02             	shl    $0x2,%eax
c0100ced:	05 24 70 11 c0       	add    $0xc0117024,%eax
c0100cf2:	8b 08                	mov    (%eax),%ecx
c0100cf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100cf7:	89 d0                	mov    %edx,%eax
c0100cf9:	01 c0                	add    %eax,%eax
c0100cfb:	01 d0                	add    %edx,%eax
c0100cfd:	c1 e0 02             	shl    $0x2,%eax
c0100d00:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100d05:	8b 00                	mov    (%eax),%eax
c0100d07:	83 ec 04             	sub    $0x4,%esp
c0100d0a:	51                   	push   %ecx
c0100d0b:	50                   	push   %eax
c0100d0c:	68 7d 5e 10 c0       	push   $0xc0105e7d
c0100d11:	e8 51 f5 ff ff       	call   c0100267 <cprintf>
c0100d16:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d19:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d20:	83 f8 02             	cmp    $0x2,%eax
c0100d23:	76 bc                	jbe    c0100ce1 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100d25:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d2a:	c9                   	leave  
c0100d2b:	c3                   	ret    

c0100d2c <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d2c:	55                   	push   %ebp
c0100d2d:	89 e5                	mov    %esp,%ebp
c0100d2f:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d32:	e8 ba fb ff ff       	call   c01008f1 <print_kerninfo>
    return 0;
c0100d37:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d3c:	c9                   	leave  
c0100d3d:	c3                   	ret    

c0100d3e <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d3e:	55                   	push   %ebp
c0100d3f:	89 e5                	mov    %esp,%ebp
c0100d41:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100d44:	e8 f2 fc ff ff       	call   c0100a3b <print_stackframe>
    return 0;
c0100d49:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d4e:	c9                   	leave  
c0100d4f:	c3                   	ret    

c0100d50 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d50:	55                   	push   %ebp
c0100d51:	89 e5                	mov    %esp,%ebp
c0100d53:	83 ec 18             	sub    $0x18,%esp
c0100d56:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d5c:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d60:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0100d64:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d68:	ee                   	out    %al,(%dx)
c0100d69:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
c0100d6f:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
c0100d73:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c0100d77:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c0100d7b:	ee                   	out    %al,(%dx)
c0100d7c:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d82:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
c0100d86:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100d8a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100d8e:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100d8f:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100d96:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100d99:	83 ec 0c             	sub    $0xc,%esp
c0100d9c:	68 86 5e 10 c0       	push   $0xc0105e86
c0100da1:	e8 c1 f4 ff ff       	call   c0100267 <cprintf>
c0100da6:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
c0100da9:	83 ec 0c             	sub    $0xc,%esp
c0100dac:	6a 00                	push   $0x0
c0100dae:	e8 3b 09 00 00       	call   c01016ee <pic_enable>
c0100db3:	83 c4 10             	add    $0x10,%esp
}
c0100db6:	90                   	nop
c0100db7:	c9                   	leave  
c0100db8:	c3                   	ret    

c0100db9 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100db9:	55                   	push   %ebp
c0100dba:	89 e5                	mov    %esp,%ebp
c0100dbc:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100dbf:	9c                   	pushf  
c0100dc0:	58                   	pop    %eax
c0100dc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100dc7:	25 00 02 00 00       	and    $0x200,%eax
c0100dcc:	85 c0                	test   %eax,%eax
c0100dce:	74 0c                	je     c0100ddc <__intr_save+0x23>
        intr_disable();
c0100dd0:	e8 8a 0a 00 00       	call   c010185f <intr_disable>
        return 1;
c0100dd5:	b8 01 00 00 00       	mov    $0x1,%eax
c0100dda:	eb 05                	jmp    c0100de1 <__intr_save+0x28>
    }
    return 0;
c0100ddc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100de1:	c9                   	leave  
c0100de2:	c3                   	ret    

c0100de3 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100de3:	55                   	push   %ebp
c0100de4:	89 e5                	mov    %esp,%ebp
c0100de6:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100de9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100ded:	74 05                	je     c0100df4 <__intr_restore+0x11>
        intr_enable();
c0100def:	e8 64 0a 00 00       	call   c0101858 <intr_enable>
    }
}
c0100df4:	90                   	nop
c0100df5:	c9                   	leave  
c0100df6:	c3                   	ret    

c0100df7 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100df7:	55                   	push   %ebp
c0100df8:	89 e5                	mov    %esp,%ebp
c0100dfa:	83 ec 10             	sub    $0x10,%esp
c0100dfd:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e03:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e07:	89 c2                	mov    %eax,%edx
c0100e09:	ec                   	in     (%dx),%al
c0100e0a:	88 45 f4             	mov    %al,-0xc(%ebp)
c0100e0d:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
c0100e13:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0100e17:	89 c2                	mov    %eax,%edx
c0100e19:	ec                   	in     (%dx),%al
c0100e1a:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e1d:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e23:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e27:	89 c2                	mov    %eax,%edx
c0100e29:	ec                   	in     (%dx),%al
c0100e2a:	88 45 f6             	mov    %al,-0xa(%ebp)
c0100e2d:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
c0100e33:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c0100e37:	89 c2                	mov    %eax,%edx
c0100e39:	ec                   	in     (%dx),%al
c0100e3a:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e3d:	90                   	nop
c0100e3e:	c9                   	leave  
c0100e3f:	c3                   	ret    

c0100e40 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e40:	55                   	push   %ebp
c0100e41:	89 e5                	mov    %esp,%ebp
c0100e43:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e46:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e50:	0f b7 00             	movzwl (%eax),%eax
c0100e53:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e57:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e5a:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e62:	0f b7 00             	movzwl (%eax),%eax
c0100e65:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e69:	74 12                	je     c0100e7d <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e6b:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e72:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100e79:	b4 03 
c0100e7b:	eb 13                	jmp    c0100e90 <cga_init+0x50>
    } else {
        *cp = was;
c0100e7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e80:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100e84:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100e87:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100e8e:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100e90:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100e97:	0f b7 c0             	movzwl %ax,%eax
c0100e9a:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
c0100e9e:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ea2:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0100ea6:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c0100eaa:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100eab:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100eb2:	83 c0 01             	add    $0x1,%eax
c0100eb5:	0f b7 c0             	movzwl %ax,%eax
c0100eb8:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ebc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100ec0:	89 c2                	mov    %eax,%edx
c0100ec2:	ec                   	in     (%dx),%al
c0100ec3:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0100ec6:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0100eca:	0f b6 c0             	movzbl %al,%eax
c0100ecd:	c1 e0 08             	shl    $0x8,%eax
c0100ed0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100ed3:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100eda:	0f b7 c0             	movzwl %ax,%eax
c0100edd:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
c0100ee1:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ee5:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0100ee9:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0100eed:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100eee:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ef5:	83 c0 01             	add    $0x1,%eax
c0100ef8:	0f b7 c0             	movzwl %ax,%eax
c0100efb:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100eff:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f03:	89 c2                	mov    %eax,%edx
c0100f05:	ec                   	in     (%dx),%al
c0100f06:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f09:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f0d:	0f b6 c0             	movzbl %al,%eax
c0100f10:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f13:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f16:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f1e:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f24:	90                   	nop
c0100f25:	c9                   	leave  
c0100f26:	c3                   	ret    

c0100f27 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f27:	55                   	push   %ebp
c0100f28:	89 e5                	mov    %esp,%ebp
c0100f2a:	83 ec 28             	sub    $0x28,%esp
c0100f2d:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f33:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f37:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0100f3b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f3f:	ee                   	out    %al,(%dx)
c0100f40:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
c0100f46:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
c0100f4a:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0100f4e:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c0100f52:	ee                   	out    %al,(%dx)
c0100f53:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
c0100f59:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
c0100f5d:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c0100f61:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f65:	ee                   	out    %al,(%dx)
c0100f66:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
c0100f6c:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c0100f70:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100f74:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0100f78:	ee                   	out    %al,(%dx)
c0100f79:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
c0100f7f:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
c0100f83:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c0100f87:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f8b:	ee                   	out    %al,(%dx)
c0100f8c:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
c0100f92:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
c0100f96:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0100f9a:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c0100f9e:	ee                   	out    %al,(%dx)
c0100f9f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fa5:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
c0100fa9:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c0100fad:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fb1:	ee                   	out    %al,(%dx)
c0100fb2:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fb8:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
c0100fbc:	89 c2                	mov    %eax,%edx
c0100fbe:	ec                   	in     (%dx),%al
c0100fbf:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
c0100fc2:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fc6:	3c ff                	cmp    $0xff,%al
c0100fc8:	0f 95 c0             	setne  %al
c0100fcb:	0f b6 c0             	movzbl %al,%eax
c0100fce:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0100fd3:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fd9:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100fdd:	89 c2                	mov    %eax,%edx
c0100fdf:	ec                   	in     (%dx),%al
c0100fe0:	88 45 e2             	mov    %al,-0x1e(%ebp)
c0100fe3:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
c0100fe9:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
c0100fed:	89 c2                	mov    %eax,%edx
c0100fef:	ec                   	in     (%dx),%al
c0100ff0:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0100ff3:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0100ff8:	85 c0                	test   %eax,%eax
c0100ffa:	74 0d                	je     c0101009 <serial_init+0xe2>
        pic_enable(IRQ_COM1);
c0100ffc:	83 ec 0c             	sub    $0xc,%esp
c0100fff:	6a 04                	push   $0x4
c0101001:	e8 e8 06 00 00       	call   c01016ee <pic_enable>
c0101006:	83 c4 10             	add    $0x10,%esp
    }
}
c0101009:	90                   	nop
c010100a:	c9                   	leave  
c010100b:	c3                   	ret    

c010100c <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010100c:	55                   	push   %ebp
c010100d:	89 e5                	mov    %esp,%ebp
c010100f:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101012:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101019:	eb 09                	jmp    c0101024 <lpt_putc_sub+0x18>
        delay();
c010101b:	e8 d7 fd ff ff       	call   c0100df7 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101020:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101024:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
c010102a:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010102e:	89 c2                	mov    %eax,%edx
c0101030:	ec                   	in     (%dx),%al
c0101031:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
c0101034:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101038:	84 c0                	test   %al,%al
c010103a:	78 09                	js     c0101045 <lpt_putc_sub+0x39>
c010103c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101043:	7e d6                	jle    c010101b <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101045:	8b 45 08             	mov    0x8(%ebp),%eax
c0101048:	0f b6 c0             	movzbl %al,%eax
c010104b:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
c0101051:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101054:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c0101058:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c010105c:	ee                   	out    %al,(%dx)
c010105d:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c0101063:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101067:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010106b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010106f:	ee                   	out    %al,(%dx)
c0101070:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
c0101076:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
c010107a:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
c010107e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101082:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101083:	90                   	nop
c0101084:	c9                   	leave  
c0101085:	c3                   	ret    

c0101086 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101086:	55                   	push   %ebp
c0101087:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c0101089:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010108d:	74 0d                	je     c010109c <lpt_putc+0x16>
        lpt_putc_sub(c);
c010108f:	ff 75 08             	pushl  0x8(%ebp)
c0101092:	e8 75 ff ff ff       	call   c010100c <lpt_putc_sub>
c0101097:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c010109a:	eb 1e                	jmp    c01010ba <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
c010109c:	6a 08                	push   $0x8
c010109e:	e8 69 ff ff ff       	call   c010100c <lpt_putc_sub>
c01010a3:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
c01010a6:	6a 20                	push   $0x20
c01010a8:	e8 5f ff ff ff       	call   c010100c <lpt_putc_sub>
c01010ad:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
c01010b0:	6a 08                	push   $0x8
c01010b2:	e8 55 ff ff ff       	call   c010100c <lpt_putc_sub>
c01010b7:	83 c4 04             	add    $0x4,%esp
    }
}
c01010ba:	90                   	nop
c01010bb:	c9                   	leave  
c01010bc:	c3                   	ret    

c01010bd <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010bd:	55                   	push   %ebp
c01010be:	89 e5                	mov    %esp,%ebp
c01010c0:	53                   	push   %ebx
c01010c1:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01010c7:	b0 00                	mov    $0x0,%al
c01010c9:	85 c0                	test   %eax,%eax
c01010cb:	75 07                	jne    c01010d4 <cga_putc+0x17>
        c |= 0x0700;
c01010cd:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01010d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01010d7:	0f b6 c0             	movzbl %al,%eax
c01010da:	83 f8 0a             	cmp    $0xa,%eax
c01010dd:	74 4e                	je     c010112d <cga_putc+0x70>
c01010df:	83 f8 0d             	cmp    $0xd,%eax
c01010e2:	74 59                	je     c010113d <cga_putc+0x80>
c01010e4:	83 f8 08             	cmp    $0x8,%eax
c01010e7:	0f 85 8a 00 00 00    	jne    c0101177 <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
c01010ed:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01010f4:	66 85 c0             	test   %ax,%ax
c01010f7:	0f 84 a0 00 00 00    	je     c010119d <cga_putc+0xe0>
            crt_pos --;
c01010fd:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101104:	83 e8 01             	sub    $0x1,%eax
c0101107:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010110d:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101112:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c0101119:	0f b7 d2             	movzwl %dx,%edx
c010111c:	01 d2                	add    %edx,%edx
c010111e:	01 d0                	add    %edx,%eax
c0101120:	8b 55 08             	mov    0x8(%ebp),%edx
c0101123:	b2 00                	mov    $0x0,%dl
c0101125:	83 ca 20             	or     $0x20,%edx
c0101128:	66 89 10             	mov    %dx,(%eax)
        }
        break;
c010112b:	eb 70                	jmp    c010119d <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
c010112d:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101134:	83 c0 50             	add    $0x50,%eax
c0101137:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010113d:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c0101144:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c010114b:	0f b7 c1             	movzwl %cx,%eax
c010114e:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101154:	c1 e8 10             	shr    $0x10,%eax
c0101157:	89 c2                	mov    %eax,%edx
c0101159:	66 c1 ea 06          	shr    $0x6,%dx
c010115d:	89 d0                	mov    %edx,%eax
c010115f:	c1 e0 02             	shl    $0x2,%eax
c0101162:	01 d0                	add    %edx,%eax
c0101164:	c1 e0 04             	shl    $0x4,%eax
c0101167:	29 c1                	sub    %eax,%ecx
c0101169:	89 ca                	mov    %ecx,%edx
c010116b:	89 d8                	mov    %ebx,%eax
c010116d:	29 d0                	sub    %edx,%eax
c010116f:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c0101175:	eb 27                	jmp    c010119e <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101177:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c010117d:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101184:	8d 50 01             	lea    0x1(%eax),%edx
c0101187:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c010118e:	0f b7 c0             	movzwl %ax,%eax
c0101191:	01 c0                	add    %eax,%eax
c0101193:	01 c8                	add    %ecx,%eax
c0101195:	8b 55 08             	mov    0x8(%ebp),%edx
c0101198:	66 89 10             	mov    %dx,(%eax)
        break;
c010119b:	eb 01                	jmp    c010119e <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
c010119d:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c010119e:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011a5:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011a9:	76 59                	jbe    c0101204 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011ab:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011b0:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011b6:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011bb:	83 ec 04             	sub    $0x4,%esp
c01011be:	68 00 0f 00 00       	push   $0xf00
c01011c3:	52                   	push   %edx
c01011c4:	50                   	push   %eax
c01011c5:	e8 4f 42 00 00       	call   c0105419 <memmove>
c01011ca:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011cd:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01011d4:	eb 15                	jmp    c01011eb <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
c01011d6:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011db:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01011de:	01 d2                	add    %edx,%edx
c01011e0:	01 d0                	add    %edx,%eax
c01011e2:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011e7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01011eb:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c01011f2:	7e e2                	jle    c01011d6 <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c01011f4:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011fb:	83 e8 50             	sub    $0x50,%eax
c01011fe:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101204:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c010120b:	0f b7 c0             	movzwl %ax,%eax
c010120e:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101212:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
c0101216:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
c010121a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010121e:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010121f:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101226:	66 c1 e8 08          	shr    $0x8,%ax
c010122a:	0f b6 c0             	movzbl %al,%eax
c010122d:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101234:	83 c2 01             	add    $0x1,%edx
c0101237:	0f b7 d2             	movzwl %dx,%edx
c010123a:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
c010123e:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101241:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101245:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0101249:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010124a:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101251:	0f b7 c0             	movzwl %ax,%eax
c0101254:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101258:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
c010125c:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0101260:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101264:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101265:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010126c:	0f b6 c0             	movzbl %al,%eax
c010126f:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101276:	83 c2 01             	add    $0x1,%edx
c0101279:	0f b7 d2             	movzwl %dx,%edx
c010127c:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
c0101280:	88 45 eb             	mov    %al,-0x15(%ebp)
c0101283:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0101287:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c010128b:	ee                   	out    %al,(%dx)
}
c010128c:	90                   	nop
c010128d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101290:	c9                   	leave  
c0101291:	c3                   	ret    

c0101292 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101292:	55                   	push   %ebp
c0101293:	89 e5                	mov    %esp,%ebp
c0101295:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101298:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010129f:	eb 09                	jmp    c01012aa <serial_putc_sub+0x18>
        delay();
c01012a1:	e8 51 fb ff ff       	call   c0100df7 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012a6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012aa:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012b0:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c01012b4:	89 c2                	mov    %eax,%edx
c01012b6:	ec                   	in     (%dx),%al
c01012b7:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c01012ba:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01012be:	0f b6 c0             	movzbl %al,%eax
c01012c1:	83 e0 20             	and    $0x20,%eax
c01012c4:	85 c0                	test   %eax,%eax
c01012c6:	75 09                	jne    c01012d1 <serial_putc_sub+0x3f>
c01012c8:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012cf:	7e d0                	jle    c01012a1 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c01012d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01012d4:	0f b6 c0             	movzbl %al,%eax
c01012d7:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
c01012dd:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012e0:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
c01012e4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01012e8:	ee                   	out    %al,(%dx)
}
c01012e9:	90                   	nop
c01012ea:	c9                   	leave  
c01012eb:	c3                   	ret    

c01012ec <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c01012ec:	55                   	push   %ebp
c01012ed:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c01012ef:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01012f3:	74 0d                	je     c0101302 <serial_putc+0x16>
        serial_putc_sub(c);
c01012f5:	ff 75 08             	pushl  0x8(%ebp)
c01012f8:	e8 95 ff ff ff       	call   c0101292 <serial_putc_sub>
c01012fd:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c0101300:	eb 1e                	jmp    c0101320 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
c0101302:	6a 08                	push   $0x8
c0101304:	e8 89 ff ff ff       	call   c0101292 <serial_putc_sub>
c0101309:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
c010130c:	6a 20                	push   $0x20
c010130e:	e8 7f ff ff ff       	call   c0101292 <serial_putc_sub>
c0101313:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
c0101316:	6a 08                	push   $0x8
c0101318:	e8 75 ff ff ff       	call   c0101292 <serial_putc_sub>
c010131d:	83 c4 04             	add    $0x4,%esp
    }
}
c0101320:	90                   	nop
c0101321:	c9                   	leave  
c0101322:	c3                   	ret    

c0101323 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101323:	55                   	push   %ebp
c0101324:	89 e5                	mov    %esp,%ebp
c0101326:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101329:	eb 33                	jmp    c010135e <cons_intr+0x3b>
        if (c != 0) {
c010132b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010132f:	74 2d                	je     c010135e <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101331:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101336:	8d 50 01             	lea    0x1(%eax),%edx
c0101339:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c010133f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101342:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101348:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010134d:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101352:	75 0a                	jne    c010135e <cons_intr+0x3b>
                cons.wpos = 0;
c0101354:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c010135b:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c010135e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101361:	ff d0                	call   *%eax
c0101363:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101366:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c010136a:	75 bf                	jne    c010132b <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c010136c:	90                   	nop
c010136d:	c9                   	leave  
c010136e:	c3                   	ret    

c010136f <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c010136f:	55                   	push   %ebp
c0101370:	89 e5                	mov    %esp,%ebp
c0101372:	83 ec 10             	sub    $0x10,%esp
c0101375:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010137b:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c010137f:	89 c2                	mov    %eax,%edx
c0101381:	ec                   	in     (%dx),%al
c0101382:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c0101385:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101389:	0f b6 c0             	movzbl %al,%eax
c010138c:	83 e0 01             	and    $0x1,%eax
c010138f:	85 c0                	test   %eax,%eax
c0101391:	75 07                	jne    c010139a <serial_proc_data+0x2b>
        return -1;
c0101393:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101398:	eb 2a                	jmp    c01013c4 <serial_proc_data+0x55>
c010139a:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013a0:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013a4:	89 c2                	mov    %eax,%edx
c01013a6:	ec                   	in     (%dx),%al
c01013a7:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
c01013aa:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013ae:	0f b6 c0             	movzbl %al,%eax
c01013b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013b4:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013b8:	75 07                	jne    c01013c1 <serial_proc_data+0x52>
        c = '\b';
c01013ba:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013c4:	c9                   	leave  
c01013c5:	c3                   	ret    

c01013c6 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013c6:	55                   	push   %ebp
c01013c7:	89 e5                	mov    %esp,%ebp
c01013c9:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
c01013cc:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01013d1:	85 c0                	test   %eax,%eax
c01013d3:	74 10                	je     c01013e5 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c01013d5:	83 ec 0c             	sub    $0xc,%esp
c01013d8:	68 6f 13 10 c0       	push   $0xc010136f
c01013dd:	e8 41 ff ff ff       	call   c0101323 <cons_intr>
c01013e2:	83 c4 10             	add    $0x10,%esp
    }
}
c01013e5:	90                   	nop
c01013e6:	c9                   	leave  
c01013e7:	c3                   	ret    

c01013e8 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01013e8:	55                   	push   %ebp
c01013e9:	89 e5                	mov    %esp,%ebp
c01013eb:	83 ec 18             	sub    $0x18,%esp
c01013ee:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013f4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01013f8:	89 c2                	mov    %eax,%edx
c01013fa:	ec                   	in     (%dx),%al
c01013fb:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c01013fe:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101402:	0f b6 c0             	movzbl %al,%eax
c0101405:	83 e0 01             	and    $0x1,%eax
c0101408:	85 c0                	test   %eax,%eax
c010140a:	75 0a                	jne    c0101416 <kbd_proc_data+0x2e>
        return -1;
c010140c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101411:	e9 5d 01 00 00       	jmp    c0101573 <kbd_proc_data+0x18b>
c0101416:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010141c:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101420:	89 c2                	mov    %eax,%edx
c0101422:	ec                   	in     (%dx),%al
c0101423:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
c0101426:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
c010142a:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010142d:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101431:	75 17                	jne    c010144a <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101433:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101438:	83 c8 40             	or     $0x40,%eax
c010143b:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c0101440:	b8 00 00 00 00       	mov    $0x0,%eax
c0101445:	e9 29 01 00 00       	jmp    c0101573 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
c010144a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010144e:	84 c0                	test   %al,%al
c0101450:	79 47                	jns    c0101499 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101452:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101457:	83 e0 40             	and    $0x40,%eax
c010145a:	85 c0                	test   %eax,%eax
c010145c:	75 09                	jne    c0101467 <kbd_proc_data+0x7f>
c010145e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101462:	83 e0 7f             	and    $0x7f,%eax
c0101465:	eb 04                	jmp    c010146b <kbd_proc_data+0x83>
c0101467:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010146b:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c010146e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101472:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c0101479:	83 c8 40             	or     $0x40,%eax
c010147c:	0f b6 c0             	movzbl %al,%eax
c010147f:	f7 d0                	not    %eax
c0101481:	89 c2                	mov    %eax,%edx
c0101483:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101488:	21 d0                	and    %edx,%eax
c010148a:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c010148f:	b8 00 00 00 00       	mov    $0x0,%eax
c0101494:	e9 da 00 00 00       	jmp    c0101573 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
c0101499:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010149e:	83 e0 40             	and    $0x40,%eax
c01014a1:	85 c0                	test   %eax,%eax
c01014a3:	74 11                	je     c01014b6 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014a5:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014a9:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014ae:	83 e0 bf             	and    $0xffffffbf,%eax
c01014b1:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014b6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ba:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014c1:	0f b6 d0             	movzbl %al,%edx
c01014c4:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014c9:	09 d0                	or     %edx,%eax
c01014cb:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c01014d0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014d4:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c01014db:	0f b6 d0             	movzbl %al,%edx
c01014de:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014e3:	31 d0                	xor    %edx,%eax
c01014e5:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c01014ea:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014ef:	83 e0 03             	and    $0x3,%eax
c01014f2:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c01014f9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014fd:	01 d0                	add    %edx,%eax
c01014ff:	0f b6 00             	movzbl (%eax),%eax
c0101502:	0f b6 c0             	movzbl %al,%eax
c0101505:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101508:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010150d:	83 e0 08             	and    $0x8,%eax
c0101510:	85 c0                	test   %eax,%eax
c0101512:	74 22                	je     c0101536 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101514:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101518:	7e 0c                	jle    c0101526 <kbd_proc_data+0x13e>
c010151a:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010151e:	7f 06                	jg     c0101526 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101520:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101524:	eb 10                	jmp    c0101536 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101526:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010152a:	7e 0a                	jle    c0101536 <kbd_proc_data+0x14e>
c010152c:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101530:	7f 04                	jg     c0101536 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101532:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101536:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010153b:	f7 d0                	not    %eax
c010153d:	83 e0 06             	and    $0x6,%eax
c0101540:	85 c0                	test   %eax,%eax
c0101542:	75 2c                	jne    c0101570 <kbd_proc_data+0x188>
c0101544:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010154b:	75 23                	jne    c0101570 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
c010154d:	83 ec 0c             	sub    $0xc,%esp
c0101550:	68 a1 5e 10 c0       	push   $0xc0105ea1
c0101555:	e8 0d ed ff ff       	call   c0100267 <cprintf>
c010155a:	83 c4 10             	add    $0x10,%esp
c010155d:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
c0101563:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101567:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010156b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010156f:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101570:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101573:	c9                   	leave  
c0101574:	c3                   	ret    

c0101575 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101575:	55                   	push   %ebp
c0101576:	89 e5                	mov    %esp,%ebp
c0101578:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
c010157b:	83 ec 0c             	sub    $0xc,%esp
c010157e:	68 e8 13 10 c0       	push   $0xc01013e8
c0101583:	e8 9b fd ff ff       	call   c0101323 <cons_intr>
c0101588:	83 c4 10             	add    $0x10,%esp
}
c010158b:	90                   	nop
c010158c:	c9                   	leave  
c010158d:	c3                   	ret    

c010158e <kbd_init>:

static void
kbd_init(void) {
c010158e:	55                   	push   %ebp
c010158f:	89 e5                	mov    %esp,%ebp
c0101591:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
c0101594:	e8 dc ff ff ff       	call   c0101575 <kbd_intr>
    pic_enable(IRQ_KBD);
c0101599:	83 ec 0c             	sub    $0xc,%esp
c010159c:	6a 01                	push   $0x1
c010159e:	e8 4b 01 00 00       	call   c01016ee <pic_enable>
c01015a3:	83 c4 10             	add    $0x10,%esp
}
c01015a6:	90                   	nop
c01015a7:	c9                   	leave  
c01015a8:	c3                   	ret    

c01015a9 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015a9:	55                   	push   %ebp
c01015aa:	89 e5                	mov    %esp,%ebp
c01015ac:	83 ec 08             	sub    $0x8,%esp
    cga_init();
c01015af:	e8 8c f8 ff ff       	call   c0100e40 <cga_init>
    serial_init();
c01015b4:	e8 6e f9 ff ff       	call   c0100f27 <serial_init>
    kbd_init();
c01015b9:	e8 d0 ff ff ff       	call   c010158e <kbd_init>
    if (!serial_exists) {
c01015be:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015c3:	85 c0                	test   %eax,%eax
c01015c5:	75 10                	jne    c01015d7 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c01015c7:	83 ec 0c             	sub    $0xc,%esp
c01015ca:	68 ad 5e 10 c0       	push   $0xc0105ead
c01015cf:	e8 93 ec ff ff       	call   c0100267 <cprintf>
c01015d4:	83 c4 10             	add    $0x10,%esp
    }
}
c01015d7:	90                   	nop
c01015d8:	c9                   	leave  
c01015d9:	c3                   	ret    

c01015da <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015da:	55                   	push   %ebp
c01015db:	89 e5                	mov    %esp,%ebp
c01015dd:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01015e0:	e8 d4 f7 ff ff       	call   c0100db9 <__intr_save>
c01015e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01015e8:	83 ec 0c             	sub    $0xc,%esp
c01015eb:	ff 75 08             	pushl  0x8(%ebp)
c01015ee:	e8 93 fa ff ff       	call   c0101086 <lpt_putc>
c01015f3:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
c01015f6:	83 ec 0c             	sub    $0xc,%esp
c01015f9:	ff 75 08             	pushl  0x8(%ebp)
c01015fc:	e8 bc fa ff ff       	call   c01010bd <cga_putc>
c0101601:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
c0101604:	83 ec 0c             	sub    $0xc,%esp
c0101607:	ff 75 08             	pushl  0x8(%ebp)
c010160a:	e8 dd fc ff ff       	call   c01012ec <serial_putc>
c010160f:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0101612:	83 ec 0c             	sub    $0xc,%esp
c0101615:	ff 75 f4             	pushl  -0xc(%ebp)
c0101618:	e8 c6 f7 ff ff       	call   c0100de3 <__intr_restore>
c010161d:	83 c4 10             	add    $0x10,%esp
}
c0101620:	90                   	nop
c0101621:	c9                   	leave  
c0101622:	c3                   	ret    

c0101623 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101623:	55                   	push   %ebp
c0101624:	89 e5                	mov    %esp,%ebp
c0101626:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
c0101629:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101630:	e8 84 f7 ff ff       	call   c0100db9 <__intr_save>
c0101635:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101638:	e8 89 fd ff ff       	call   c01013c6 <serial_intr>
        kbd_intr();
c010163d:	e8 33 ff ff ff       	call   c0101575 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101642:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c0101648:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010164d:	39 c2                	cmp    %eax,%edx
c010164f:	74 31                	je     c0101682 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101651:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101656:	8d 50 01             	lea    0x1(%eax),%edx
c0101659:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c010165f:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c0101666:	0f b6 c0             	movzbl %al,%eax
c0101669:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010166c:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101671:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101676:	75 0a                	jne    c0101682 <cons_getc+0x5f>
                cons.rpos = 0;
c0101678:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c010167f:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101682:	83 ec 0c             	sub    $0xc,%esp
c0101685:	ff 75 f0             	pushl  -0x10(%ebp)
c0101688:	e8 56 f7 ff ff       	call   c0100de3 <__intr_restore>
c010168d:	83 c4 10             	add    $0x10,%esp
    return c;
c0101690:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101693:	c9                   	leave  
c0101694:	c3                   	ret    

c0101695 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101695:	55                   	push   %ebp
c0101696:	89 e5                	mov    %esp,%ebp
c0101698:	83 ec 14             	sub    $0x14,%esp
c010169b:	8b 45 08             	mov    0x8(%ebp),%eax
c010169e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016a2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016a6:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016ac:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016b1:	85 c0                	test   %eax,%eax
c01016b3:	74 36                	je     c01016eb <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016b5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016b9:	0f b6 c0             	movzbl %al,%eax
c01016bc:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016c2:	88 45 fa             	mov    %al,-0x6(%ebp)
c01016c5:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
c01016c9:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016cd:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016ce:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016d2:	66 c1 e8 08          	shr    $0x8,%ax
c01016d6:	0f b6 c0             	movzbl %al,%eax
c01016d9:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c01016df:	88 45 fb             	mov    %al,-0x5(%ebp)
c01016e2:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01016e6:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c01016ea:	ee                   	out    %al,(%dx)
    }
}
c01016eb:	90                   	nop
c01016ec:	c9                   	leave  
c01016ed:	c3                   	ret    

c01016ee <pic_enable>:

void
pic_enable(unsigned int irq) {
c01016ee:	55                   	push   %ebp
c01016ef:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
c01016f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01016f4:	ba 01 00 00 00       	mov    $0x1,%edx
c01016f9:	89 c1                	mov    %eax,%ecx
c01016fb:	d3 e2                	shl    %cl,%edx
c01016fd:	89 d0                	mov    %edx,%eax
c01016ff:	f7 d0                	not    %eax
c0101701:	89 c2                	mov    %eax,%edx
c0101703:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010170a:	21 d0                	and    %edx,%eax
c010170c:	0f b7 c0             	movzwl %ax,%eax
c010170f:	50                   	push   %eax
c0101710:	e8 80 ff ff ff       	call   c0101695 <pic_setmask>
c0101715:	83 c4 04             	add    $0x4,%esp
}
c0101718:	90                   	nop
c0101719:	c9                   	leave  
c010171a:	c3                   	ret    

c010171b <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010171b:	55                   	push   %ebp
c010171c:	89 e5                	mov    %esp,%ebp
c010171e:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
c0101721:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c0101728:	00 00 00 
c010172b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101731:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
c0101735:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
c0101739:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010173d:	ee                   	out    %al,(%dx)
c010173e:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c0101744:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
c0101748:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c010174c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c0101750:	ee                   	out    %al,(%dx)
c0101751:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
c0101757:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
c010175b:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
c010175f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101763:	ee                   	out    %al,(%dx)
c0101764:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
c010176a:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
c010176e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101772:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c0101776:	ee                   	out    %al,(%dx)
c0101777:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
c010177d:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
c0101781:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0101785:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101789:	ee                   	out    %al,(%dx)
c010178a:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
c0101790:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c0101794:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0101798:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c010179c:	ee                   	out    %al,(%dx)
c010179d:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
c01017a3:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
c01017a7:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c01017ab:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01017af:	ee                   	out    %al,(%dx)
c01017b0:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
c01017b6:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
c01017ba:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017be:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c01017c2:	ee                   	out    %al,(%dx)
c01017c3:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01017c9:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
c01017cd:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c01017d1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017d5:	ee                   	out    %al,(%dx)
c01017d6:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
c01017dc:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
c01017e0:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c01017e4:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c01017e8:	ee                   	out    %al,(%dx)
c01017e9:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
c01017ef:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
c01017f3:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c01017f7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017fb:	ee                   	out    %al,(%dx)
c01017fc:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
c0101802:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
c0101806:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010180a:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c010180e:	ee                   	out    %al,(%dx)
c010180f:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0101815:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
c0101819:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
c010181d:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101821:	ee                   	out    %al,(%dx)
c0101822:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
c0101828:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
c010182c:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c0101830:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
c0101834:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101835:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010183c:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101840:	74 13                	je     c0101855 <pic_init+0x13a>
        pic_setmask(irq_mask);
c0101842:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101849:	0f b7 c0             	movzwl %ax,%eax
c010184c:	50                   	push   %eax
c010184d:	e8 43 fe ff ff       	call   c0101695 <pic_setmask>
c0101852:	83 c4 04             	add    $0x4,%esp
    }
}
c0101855:	90                   	nop
c0101856:	c9                   	leave  
c0101857:	c3                   	ret    

c0101858 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101858:	55                   	push   %ebp
c0101859:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c010185b:	fb                   	sti    
    sti();
}
c010185c:	90                   	nop
c010185d:	5d                   	pop    %ebp
c010185e:	c3                   	ret    

c010185f <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c010185f:	55                   	push   %ebp
c0101860:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101862:	fa                   	cli    
    cli();
}
c0101863:	90                   	nop
c0101864:	5d                   	pop    %ebp
c0101865:	c3                   	ret    

c0101866 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101866:	55                   	push   %ebp
c0101867:	89 e5                	mov    %esp,%ebp
c0101869:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010186c:	83 ec 08             	sub    $0x8,%esp
c010186f:	6a 64                	push   $0x64
c0101871:	68 e0 5e 10 c0       	push   $0xc0105ee0
c0101876:	e8 ec e9 ff ff       	call   c0100267 <cprintf>
c010187b:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c010187e:	90                   	nop
c010187f:	c9                   	leave  
c0101880:	c3                   	ret    

c0101881 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0101881:	55                   	push   %ebp
c0101882:	89 e5                	mov    %esp,%ebp
c0101884:	83 ec 10             	sub    $0x10,%esp
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i; 
    
    for( i = 0; i < 256; i++ )
c0101887:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010188e:	e9 c3 00 00 00       	jmp    c0101956 <idt_init+0xd5>
    {
        SETGATE( idt[ i ], 0, GD_KTEXT, __vectors[ i ], DPL_KERNEL ); 
c0101893:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101896:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c010189d:	89 c2                	mov    %eax,%edx
c010189f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018a2:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018a9:	c0 
c01018aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ad:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018b4:	c0 08 00 
c01018b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ba:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018c1:	c0 
c01018c2:	83 e2 e0             	and    $0xffffffe0,%edx
c01018c5:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018cf:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018d6:	c0 
c01018d7:	83 e2 1f             	and    $0x1f,%edx
c01018da:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e4:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c01018eb:	c0 
c01018ec:	83 e2 f0             	and    $0xfffffff0,%edx
c01018ef:	83 ca 0e             	or     $0xe,%edx
c01018f2:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c01018f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018fc:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101903:	c0 
c0101904:	83 e2 ef             	and    $0xffffffef,%edx
c0101907:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010190e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101911:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101918:	c0 
c0101919:	83 e2 9f             	and    $0xffffff9f,%edx
c010191c:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101923:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101926:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010192d:	c0 
c010192e:	83 ca 80             	or     $0xffffff80,%edx
c0101931:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101938:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010193b:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101942:	c1 e8 10             	shr    $0x10,%eax
c0101945:	89 c2                	mov    %eax,%edx
c0101947:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010194a:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c0101951:	c0 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i; 
    
    for( i = 0; i < 256; i++ )
c0101952:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101956:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c010195d:	0f 8e 30 ff ff ff    	jle    c0101893 <idt_init+0x12>
    {
        SETGATE( idt[ i ], 0, GD_KTEXT, __vectors[ i ], DPL_KERNEL ); 
    }

    SETGATE( idt[ T_SWITCH_TOK ], 0, GD_KTEXT, __vectors[ T_SWITCH_TOK ], DPL_USER ); 
c0101963:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c0101968:	66 a3 88 84 11 c0    	mov    %ax,0xc0118488
c010196e:	66 c7 05 8a 84 11 c0 	movw   $0x8,0xc011848a
c0101975:	08 00 
c0101977:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c010197e:	83 e0 e0             	and    $0xffffffe0,%eax
c0101981:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c0101986:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c010198d:	83 e0 1f             	and    $0x1f,%eax
c0101990:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c0101995:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c010199c:	83 e0 f0             	and    $0xfffffff0,%eax
c010199f:	83 c8 0e             	or     $0xe,%eax
c01019a2:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019a7:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019ae:	83 e0 ef             	and    $0xffffffef,%eax
c01019b1:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019b6:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019bd:	83 c8 60             	or     $0x60,%eax
c01019c0:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019c5:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019cc:	83 c8 80             	or     $0xffffff80,%eax
c01019cf:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019d4:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c01019d9:	c1 e8 10             	shr    $0x10,%eax
c01019dc:	66 a3 8e 84 11 c0    	mov    %ax,0xc011848e
c01019e2:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01019e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019ec:	0f 01 18             	lidtl  (%eax)
    lidt( &idt_pd );
}
c01019ef:	90                   	nop
c01019f0:	c9                   	leave  
c01019f1:	c3                   	ret    

c01019f2 <trapname>:

static const char *
trapname(int trapno) {
c01019f2:	55                   	push   %ebp
c01019f3:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01019f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01019f8:	83 f8 13             	cmp    $0x13,%eax
c01019fb:	77 0c                	ja     c0101a09 <trapname+0x17>
        return excnames[trapno];
c01019fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a00:	8b 04 85 40 62 10 c0 	mov    -0x3fef9dc0(,%eax,4),%eax
c0101a07:	eb 18                	jmp    c0101a21 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a09:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a0d:	7e 0d                	jle    c0101a1c <trapname+0x2a>
c0101a0f:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a13:	7f 07                	jg     c0101a1c <trapname+0x2a>
        return "Hardware Interrupt";
c0101a15:	b8 ea 5e 10 c0       	mov    $0xc0105eea,%eax
c0101a1a:	eb 05                	jmp    c0101a21 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a1c:	b8 fd 5e 10 c0       	mov    $0xc0105efd,%eax
}
c0101a21:	5d                   	pop    %ebp
c0101a22:	c3                   	ret    

c0101a23 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a23:	55                   	push   %ebp
c0101a24:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a26:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a29:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a2d:	66 83 f8 08          	cmp    $0x8,%ax
c0101a31:	0f 94 c0             	sete   %al
c0101a34:	0f b6 c0             	movzbl %al,%eax
}
c0101a37:	5d                   	pop    %ebp
c0101a38:	c3                   	ret    

c0101a39 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a39:	55                   	push   %ebp
c0101a3a:	89 e5                	mov    %esp,%ebp
c0101a3c:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
c0101a3f:	83 ec 08             	sub    $0x8,%esp
c0101a42:	ff 75 08             	pushl  0x8(%ebp)
c0101a45:	68 3e 5f 10 c0       	push   $0xc0105f3e
c0101a4a:	e8 18 e8 ff ff       	call   c0100267 <cprintf>
c0101a4f:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c0101a52:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a55:	83 ec 0c             	sub    $0xc,%esp
c0101a58:	50                   	push   %eax
c0101a59:	e8 b8 01 00 00       	call   c0101c16 <print_regs>
c0101a5e:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a61:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a64:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a68:	0f b7 c0             	movzwl %ax,%eax
c0101a6b:	83 ec 08             	sub    $0x8,%esp
c0101a6e:	50                   	push   %eax
c0101a6f:	68 4f 5f 10 c0       	push   $0xc0105f4f
c0101a74:	e8 ee e7 ff ff       	call   c0100267 <cprintf>
c0101a79:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a7f:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a83:	0f b7 c0             	movzwl %ax,%eax
c0101a86:	83 ec 08             	sub    $0x8,%esp
c0101a89:	50                   	push   %eax
c0101a8a:	68 62 5f 10 c0       	push   $0xc0105f62
c0101a8f:	e8 d3 e7 ff ff       	call   c0100267 <cprintf>
c0101a94:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101a97:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a9a:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101a9e:	0f b7 c0             	movzwl %ax,%eax
c0101aa1:	83 ec 08             	sub    $0x8,%esp
c0101aa4:	50                   	push   %eax
c0101aa5:	68 75 5f 10 c0       	push   $0xc0105f75
c0101aaa:	e8 b8 e7 ff ff       	call   c0100267 <cprintf>
c0101aaf:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab5:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101ab9:	0f b7 c0             	movzwl %ax,%eax
c0101abc:	83 ec 08             	sub    $0x8,%esp
c0101abf:	50                   	push   %eax
c0101ac0:	68 88 5f 10 c0       	push   $0xc0105f88
c0101ac5:	e8 9d e7 ff ff       	call   c0100267 <cprintf>
c0101aca:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101acd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad0:	8b 40 30             	mov    0x30(%eax),%eax
c0101ad3:	83 ec 0c             	sub    $0xc,%esp
c0101ad6:	50                   	push   %eax
c0101ad7:	e8 16 ff ff ff       	call   c01019f2 <trapname>
c0101adc:	83 c4 10             	add    $0x10,%esp
c0101adf:	89 c2                	mov    %eax,%edx
c0101ae1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae4:	8b 40 30             	mov    0x30(%eax),%eax
c0101ae7:	83 ec 04             	sub    $0x4,%esp
c0101aea:	52                   	push   %edx
c0101aeb:	50                   	push   %eax
c0101aec:	68 9b 5f 10 c0       	push   $0xc0105f9b
c0101af1:	e8 71 e7 ff ff       	call   c0100267 <cprintf>
c0101af6:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101af9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101afc:	8b 40 34             	mov    0x34(%eax),%eax
c0101aff:	83 ec 08             	sub    $0x8,%esp
c0101b02:	50                   	push   %eax
c0101b03:	68 ad 5f 10 c0       	push   $0xc0105fad
c0101b08:	e8 5a e7 ff ff       	call   c0100267 <cprintf>
c0101b0d:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b10:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b13:	8b 40 38             	mov    0x38(%eax),%eax
c0101b16:	83 ec 08             	sub    $0x8,%esp
c0101b19:	50                   	push   %eax
c0101b1a:	68 bc 5f 10 c0       	push   $0xc0105fbc
c0101b1f:	e8 43 e7 ff ff       	call   c0100267 <cprintf>
c0101b24:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b27:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b2a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b2e:	0f b7 c0             	movzwl %ax,%eax
c0101b31:	83 ec 08             	sub    $0x8,%esp
c0101b34:	50                   	push   %eax
c0101b35:	68 cb 5f 10 c0       	push   $0xc0105fcb
c0101b3a:	e8 28 e7 ff ff       	call   c0100267 <cprintf>
c0101b3f:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b42:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b45:	8b 40 40             	mov    0x40(%eax),%eax
c0101b48:	83 ec 08             	sub    $0x8,%esp
c0101b4b:	50                   	push   %eax
c0101b4c:	68 de 5f 10 c0       	push   $0xc0105fde
c0101b51:	e8 11 e7 ff ff       	call   c0100267 <cprintf>
c0101b56:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b60:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b67:	eb 3f                	jmp    c0101ba8 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b69:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b6c:	8b 50 40             	mov    0x40(%eax),%edx
c0101b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b72:	21 d0                	and    %edx,%eax
c0101b74:	85 c0                	test   %eax,%eax
c0101b76:	74 29                	je     c0101ba1 <print_trapframe+0x168>
c0101b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b7b:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b82:	85 c0                	test   %eax,%eax
c0101b84:	74 1b                	je     c0101ba1 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
c0101b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b89:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b90:	83 ec 08             	sub    $0x8,%esp
c0101b93:	50                   	push   %eax
c0101b94:	68 ed 5f 10 c0       	push   $0xc0105fed
c0101b99:	e8 c9 e6 ff ff       	call   c0100267 <cprintf>
c0101b9e:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101ba1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101ba5:	d1 65 f0             	shll   -0x10(%ebp)
c0101ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bab:	83 f8 17             	cmp    $0x17,%eax
c0101bae:	76 b9                	jbe    c0101b69 <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb3:	8b 40 40             	mov    0x40(%eax),%eax
c0101bb6:	25 00 30 00 00       	and    $0x3000,%eax
c0101bbb:	c1 e8 0c             	shr    $0xc,%eax
c0101bbe:	83 ec 08             	sub    $0x8,%esp
c0101bc1:	50                   	push   %eax
c0101bc2:	68 f1 5f 10 c0       	push   $0xc0105ff1
c0101bc7:	e8 9b e6 ff ff       	call   c0100267 <cprintf>
c0101bcc:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c0101bcf:	83 ec 0c             	sub    $0xc,%esp
c0101bd2:	ff 75 08             	pushl  0x8(%ebp)
c0101bd5:	e8 49 fe ff ff       	call   c0101a23 <trap_in_kernel>
c0101bda:	83 c4 10             	add    $0x10,%esp
c0101bdd:	85 c0                	test   %eax,%eax
c0101bdf:	75 32                	jne    c0101c13 <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101be1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be4:	8b 40 44             	mov    0x44(%eax),%eax
c0101be7:	83 ec 08             	sub    $0x8,%esp
c0101bea:	50                   	push   %eax
c0101beb:	68 fa 5f 10 c0       	push   $0xc0105ffa
c0101bf0:	e8 72 e6 ff ff       	call   c0100267 <cprintf>
c0101bf5:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101bf8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bfb:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101bff:	0f b7 c0             	movzwl %ax,%eax
c0101c02:	83 ec 08             	sub    $0x8,%esp
c0101c05:	50                   	push   %eax
c0101c06:	68 09 60 10 c0       	push   $0xc0106009
c0101c0b:	e8 57 e6 ff ff       	call   c0100267 <cprintf>
c0101c10:	83 c4 10             	add    $0x10,%esp
    }
}
c0101c13:	90                   	nop
c0101c14:	c9                   	leave  
c0101c15:	c3                   	ret    

c0101c16 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c16:	55                   	push   %ebp
c0101c17:	89 e5                	mov    %esp,%ebp
c0101c19:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1f:	8b 00                	mov    (%eax),%eax
c0101c21:	83 ec 08             	sub    $0x8,%esp
c0101c24:	50                   	push   %eax
c0101c25:	68 1c 60 10 c0       	push   $0xc010601c
c0101c2a:	e8 38 e6 ff ff       	call   c0100267 <cprintf>
c0101c2f:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c32:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c35:	8b 40 04             	mov    0x4(%eax),%eax
c0101c38:	83 ec 08             	sub    $0x8,%esp
c0101c3b:	50                   	push   %eax
c0101c3c:	68 2b 60 10 c0       	push   $0xc010602b
c0101c41:	e8 21 e6 ff ff       	call   c0100267 <cprintf>
c0101c46:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c49:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c4c:	8b 40 08             	mov    0x8(%eax),%eax
c0101c4f:	83 ec 08             	sub    $0x8,%esp
c0101c52:	50                   	push   %eax
c0101c53:	68 3a 60 10 c0       	push   $0xc010603a
c0101c58:	e8 0a e6 ff ff       	call   c0100267 <cprintf>
c0101c5d:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c60:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c63:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c66:	83 ec 08             	sub    $0x8,%esp
c0101c69:	50                   	push   %eax
c0101c6a:	68 49 60 10 c0       	push   $0xc0106049
c0101c6f:	e8 f3 e5 ff ff       	call   c0100267 <cprintf>
c0101c74:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c77:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7a:	8b 40 10             	mov    0x10(%eax),%eax
c0101c7d:	83 ec 08             	sub    $0x8,%esp
c0101c80:	50                   	push   %eax
c0101c81:	68 58 60 10 c0       	push   $0xc0106058
c0101c86:	e8 dc e5 ff ff       	call   c0100267 <cprintf>
c0101c8b:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c91:	8b 40 14             	mov    0x14(%eax),%eax
c0101c94:	83 ec 08             	sub    $0x8,%esp
c0101c97:	50                   	push   %eax
c0101c98:	68 67 60 10 c0       	push   $0xc0106067
c0101c9d:	e8 c5 e5 ff ff       	call   c0100267 <cprintf>
c0101ca2:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101ca5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca8:	8b 40 18             	mov    0x18(%eax),%eax
c0101cab:	83 ec 08             	sub    $0x8,%esp
c0101cae:	50                   	push   %eax
c0101caf:	68 76 60 10 c0       	push   $0xc0106076
c0101cb4:	e8 ae e5 ff ff       	call   c0100267 <cprintf>
c0101cb9:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101cbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cbf:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cc2:	83 ec 08             	sub    $0x8,%esp
c0101cc5:	50                   	push   %eax
c0101cc6:	68 85 60 10 c0       	push   $0xc0106085
c0101ccb:	e8 97 e5 ff ff       	call   c0100267 <cprintf>
c0101cd0:	83 c4 10             	add    $0x10,%esp
}
c0101cd3:	90                   	nop
c0101cd4:	c9                   	leave  
c0101cd5:	c3                   	ret    

c0101cd6 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101cd6:	55                   	push   %ebp
c0101cd7:	89 e5                	mov    %esp,%ebp
c0101cd9:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
c0101cdc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cdf:	8b 40 30             	mov    0x30(%eax),%eax
c0101ce2:	83 f8 2f             	cmp    $0x2f,%eax
c0101ce5:	77 1e                	ja     c0101d05 <trap_dispatch+0x2f>
c0101ce7:	83 f8 2e             	cmp    $0x2e,%eax
c0101cea:	0f 83 b4 00 00 00    	jae    c0101da4 <trap_dispatch+0xce>
c0101cf0:	83 f8 21             	cmp    $0x21,%eax
c0101cf3:	74 3e                	je     c0101d33 <trap_dispatch+0x5d>
c0101cf5:	83 f8 24             	cmp    $0x24,%eax
c0101cf8:	74 15                	je     c0101d0f <trap_dispatch+0x39>
c0101cfa:	83 f8 20             	cmp    $0x20,%eax
c0101cfd:	0f 84 a4 00 00 00    	je     c0101da7 <trap_dispatch+0xd1>
c0101d03:	eb 69                	jmp    c0101d6e <trap_dispatch+0x98>
c0101d05:	83 e8 78             	sub    $0x78,%eax
c0101d08:	83 f8 01             	cmp    $0x1,%eax
c0101d0b:	77 61                	ja     c0101d6e <trap_dispatch+0x98>
c0101d0d:	eb 48                	jmp    c0101d57 <trap_dispatch+0x81>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d0f:	e8 0f f9 ff ff       	call   c0101623 <cons_getc>
c0101d14:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d17:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d1b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d1f:	83 ec 04             	sub    $0x4,%esp
c0101d22:	52                   	push   %edx
c0101d23:	50                   	push   %eax
c0101d24:	68 94 60 10 c0       	push   $0xc0106094
c0101d29:	e8 39 e5 ff ff       	call   c0100267 <cprintf>
c0101d2e:	83 c4 10             	add    $0x10,%esp
        break;
c0101d31:	eb 75                	jmp    c0101da8 <trap_dispatch+0xd2>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d33:	e8 eb f8 ff ff       	call   c0101623 <cons_getc>
c0101d38:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d3b:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d3f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d43:	83 ec 04             	sub    $0x4,%esp
c0101d46:	52                   	push   %edx
c0101d47:	50                   	push   %eax
c0101d48:	68 a6 60 10 c0       	push   $0xc01060a6
c0101d4d:	e8 15 e5 ff ff       	call   c0100267 <cprintf>
c0101d52:	83 c4 10             	add    $0x10,%esp
        break;
c0101d55:	eb 51                	jmp    c0101da8 <trap_dispatch+0xd2>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101d57:	83 ec 04             	sub    $0x4,%esp
c0101d5a:	68 b5 60 10 c0       	push   $0xc01060b5
c0101d5f:	68 ac 00 00 00       	push   $0xac
c0101d64:	68 c5 60 10 c0       	push   $0xc01060c5
c0101d69:	e8 5f e6 ff ff       	call   c01003cd <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101d6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d71:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101d75:	0f b7 c0             	movzwl %ax,%eax
c0101d78:	83 e0 03             	and    $0x3,%eax
c0101d7b:	85 c0                	test   %eax,%eax
c0101d7d:	75 29                	jne    c0101da8 <trap_dispatch+0xd2>
            print_trapframe(tf);
c0101d7f:	83 ec 0c             	sub    $0xc,%esp
c0101d82:	ff 75 08             	pushl  0x8(%ebp)
c0101d85:	e8 af fc ff ff       	call   c0101a39 <print_trapframe>
c0101d8a:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c0101d8d:	83 ec 04             	sub    $0x4,%esp
c0101d90:	68 d6 60 10 c0       	push   $0xc01060d6
c0101d95:	68 b6 00 00 00       	push   $0xb6
c0101d9a:	68 c5 60 10 c0       	push   $0xc01060c5
c0101d9f:	e8 29 e6 ff ff       	call   c01003cd <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101da4:	90                   	nop
c0101da5:	eb 01                	jmp    c0101da8 <trap_dispatch+0xd2>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
c0101da7:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101da8:	90                   	nop
c0101da9:	c9                   	leave  
c0101daa:	c3                   	ret    

c0101dab <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101dab:	55                   	push   %ebp
c0101dac:	89 e5                	mov    %esp,%ebp
c0101dae:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101db1:	83 ec 0c             	sub    $0xc,%esp
c0101db4:	ff 75 08             	pushl  0x8(%ebp)
c0101db7:	e8 1a ff ff ff       	call   c0101cd6 <trap_dispatch>
c0101dbc:	83 c4 10             	add    $0x10,%esp
}
c0101dbf:	90                   	nop
c0101dc0:	c9                   	leave  
c0101dc1:	c3                   	ret    

c0101dc2 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101dc2:	6a 00                	push   $0x0
  pushl $0
c0101dc4:	6a 00                	push   $0x0
  jmp __alltraps
c0101dc6:	e9 67 0a 00 00       	jmp    c0102832 <__alltraps>

c0101dcb <vector1>:
.globl vector1
vector1:
  pushl $0
c0101dcb:	6a 00                	push   $0x0
  pushl $1
c0101dcd:	6a 01                	push   $0x1
  jmp __alltraps
c0101dcf:	e9 5e 0a 00 00       	jmp    c0102832 <__alltraps>

c0101dd4 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101dd4:	6a 00                	push   $0x0
  pushl $2
c0101dd6:	6a 02                	push   $0x2
  jmp __alltraps
c0101dd8:	e9 55 0a 00 00       	jmp    c0102832 <__alltraps>

c0101ddd <vector3>:
.globl vector3
vector3:
  pushl $0
c0101ddd:	6a 00                	push   $0x0
  pushl $3
c0101ddf:	6a 03                	push   $0x3
  jmp __alltraps
c0101de1:	e9 4c 0a 00 00       	jmp    c0102832 <__alltraps>

c0101de6 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101de6:	6a 00                	push   $0x0
  pushl $4
c0101de8:	6a 04                	push   $0x4
  jmp __alltraps
c0101dea:	e9 43 0a 00 00       	jmp    c0102832 <__alltraps>

c0101def <vector5>:
.globl vector5
vector5:
  pushl $0
c0101def:	6a 00                	push   $0x0
  pushl $5
c0101df1:	6a 05                	push   $0x5
  jmp __alltraps
c0101df3:	e9 3a 0a 00 00       	jmp    c0102832 <__alltraps>

c0101df8 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101df8:	6a 00                	push   $0x0
  pushl $6
c0101dfa:	6a 06                	push   $0x6
  jmp __alltraps
c0101dfc:	e9 31 0a 00 00       	jmp    c0102832 <__alltraps>

c0101e01 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101e01:	6a 00                	push   $0x0
  pushl $7
c0101e03:	6a 07                	push   $0x7
  jmp __alltraps
c0101e05:	e9 28 0a 00 00       	jmp    c0102832 <__alltraps>

c0101e0a <vector8>:
.globl vector8
vector8:
  pushl $8
c0101e0a:	6a 08                	push   $0x8
  jmp __alltraps
c0101e0c:	e9 21 0a 00 00       	jmp    c0102832 <__alltraps>

c0101e11 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101e11:	6a 09                	push   $0x9
  jmp __alltraps
c0101e13:	e9 1a 0a 00 00       	jmp    c0102832 <__alltraps>

c0101e18 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101e18:	6a 0a                	push   $0xa
  jmp __alltraps
c0101e1a:	e9 13 0a 00 00       	jmp    c0102832 <__alltraps>

c0101e1f <vector11>:
.globl vector11
vector11:
  pushl $11
c0101e1f:	6a 0b                	push   $0xb
  jmp __alltraps
c0101e21:	e9 0c 0a 00 00       	jmp    c0102832 <__alltraps>

c0101e26 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101e26:	6a 0c                	push   $0xc
  jmp __alltraps
c0101e28:	e9 05 0a 00 00       	jmp    c0102832 <__alltraps>

c0101e2d <vector13>:
.globl vector13
vector13:
  pushl $13
c0101e2d:	6a 0d                	push   $0xd
  jmp __alltraps
c0101e2f:	e9 fe 09 00 00       	jmp    c0102832 <__alltraps>

c0101e34 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101e34:	6a 0e                	push   $0xe
  jmp __alltraps
c0101e36:	e9 f7 09 00 00       	jmp    c0102832 <__alltraps>

c0101e3b <vector15>:
.globl vector15
vector15:
  pushl $0
c0101e3b:	6a 00                	push   $0x0
  pushl $15
c0101e3d:	6a 0f                	push   $0xf
  jmp __alltraps
c0101e3f:	e9 ee 09 00 00       	jmp    c0102832 <__alltraps>

c0101e44 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101e44:	6a 00                	push   $0x0
  pushl $16
c0101e46:	6a 10                	push   $0x10
  jmp __alltraps
c0101e48:	e9 e5 09 00 00       	jmp    c0102832 <__alltraps>

c0101e4d <vector17>:
.globl vector17
vector17:
  pushl $17
c0101e4d:	6a 11                	push   $0x11
  jmp __alltraps
c0101e4f:	e9 de 09 00 00       	jmp    c0102832 <__alltraps>

c0101e54 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101e54:	6a 00                	push   $0x0
  pushl $18
c0101e56:	6a 12                	push   $0x12
  jmp __alltraps
c0101e58:	e9 d5 09 00 00       	jmp    c0102832 <__alltraps>

c0101e5d <vector19>:
.globl vector19
vector19:
  pushl $0
c0101e5d:	6a 00                	push   $0x0
  pushl $19
c0101e5f:	6a 13                	push   $0x13
  jmp __alltraps
c0101e61:	e9 cc 09 00 00       	jmp    c0102832 <__alltraps>

c0101e66 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101e66:	6a 00                	push   $0x0
  pushl $20
c0101e68:	6a 14                	push   $0x14
  jmp __alltraps
c0101e6a:	e9 c3 09 00 00       	jmp    c0102832 <__alltraps>

c0101e6f <vector21>:
.globl vector21
vector21:
  pushl $0
c0101e6f:	6a 00                	push   $0x0
  pushl $21
c0101e71:	6a 15                	push   $0x15
  jmp __alltraps
c0101e73:	e9 ba 09 00 00       	jmp    c0102832 <__alltraps>

c0101e78 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101e78:	6a 00                	push   $0x0
  pushl $22
c0101e7a:	6a 16                	push   $0x16
  jmp __alltraps
c0101e7c:	e9 b1 09 00 00       	jmp    c0102832 <__alltraps>

c0101e81 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101e81:	6a 00                	push   $0x0
  pushl $23
c0101e83:	6a 17                	push   $0x17
  jmp __alltraps
c0101e85:	e9 a8 09 00 00       	jmp    c0102832 <__alltraps>

c0101e8a <vector24>:
.globl vector24
vector24:
  pushl $0
c0101e8a:	6a 00                	push   $0x0
  pushl $24
c0101e8c:	6a 18                	push   $0x18
  jmp __alltraps
c0101e8e:	e9 9f 09 00 00       	jmp    c0102832 <__alltraps>

c0101e93 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101e93:	6a 00                	push   $0x0
  pushl $25
c0101e95:	6a 19                	push   $0x19
  jmp __alltraps
c0101e97:	e9 96 09 00 00       	jmp    c0102832 <__alltraps>

c0101e9c <vector26>:
.globl vector26
vector26:
  pushl $0
c0101e9c:	6a 00                	push   $0x0
  pushl $26
c0101e9e:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101ea0:	e9 8d 09 00 00       	jmp    c0102832 <__alltraps>

c0101ea5 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101ea5:	6a 00                	push   $0x0
  pushl $27
c0101ea7:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101ea9:	e9 84 09 00 00       	jmp    c0102832 <__alltraps>

c0101eae <vector28>:
.globl vector28
vector28:
  pushl $0
c0101eae:	6a 00                	push   $0x0
  pushl $28
c0101eb0:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101eb2:	e9 7b 09 00 00       	jmp    c0102832 <__alltraps>

c0101eb7 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101eb7:	6a 00                	push   $0x0
  pushl $29
c0101eb9:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101ebb:	e9 72 09 00 00       	jmp    c0102832 <__alltraps>

c0101ec0 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101ec0:	6a 00                	push   $0x0
  pushl $30
c0101ec2:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101ec4:	e9 69 09 00 00       	jmp    c0102832 <__alltraps>

c0101ec9 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101ec9:	6a 00                	push   $0x0
  pushl $31
c0101ecb:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101ecd:	e9 60 09 00 00       	jmp    c0102832 <__alltraps>

c0101ed2 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101ed2:	6a 00                	push   $0x0
  pushl $32
c0101ed4:	6a 20                	push   $0x20
  jmp __alltraps
c0101ed6:	e9 57 09 00 00       	jmp    c0102832 <__alltraps>

c0101edb <vector33>:
.globl vector33
vector33:
  pushl $0
c0101edb:	6a 00                	push   $0x0
  pushl $33
c0101edd:	6a 21                	push   $0x21
  jmp __alltraps
c0101edf:	e9 4e 09 00 00       	jmp    c0102832 <__alltraps>

c0101ee4 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101ee4:	6a 00                	push   $0x0
  pushl $34
c0101ee6:	6a 22                	push   $0x22
  jmp __alltraps
c0101ee8:	e9 45 09 00 00       	jmp    c0102832 <__alltraps>

c0101eed <vector35>:
.globl vector35
vector35:
  pushl $0
c0101eed:	6a 00                	push   $0x0
  pushl $35
c0101eef:	6a 23                	push   $0x23
  jmp __alltraps
c0101ef1:	e9 3c 09 00 00       	jmp    c0102832 <__alltraps>

c0101ef6 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101ef6:	6a 00                	push   $0x0
  pushl $36
c0101ef8:	6a 24                	push   $0x24
  jmp __alltraps
c0101efa:	e9 33 09 00 00       	jmp    c0102832 <__alltraps>

c0101eff <vector37>:
.globl vector37
vector37:
  pushl $0
c0101eff:	6a 00                	push   $0x0
  pushl $37
c0101f01:	6a 25                	push   $0x25
  jmp __alltraps
c0101f03:	e9 2a 09 00 00       	jmp    c0102832 <__alltraps>

c0101f08 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101f08:	6a 00                	push   $0x0
  pushl $38
c0101f0a:	6a 26                	push   $0x26
  jmp __alltraps
c0101f0c:	e9 21 09 00 00       	jmp    c0102832 <__alltraps>

c0101f11 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101f11:	6a 00                	push   $0x0
  pushl $39
c0101f13:	6a 27                	push   $0x27
  jmp __alltraps
c0101f15:	e9 18 09 00 00       	jmp    c0102832 <__alltraps>

c0101f1a <vector40>:
.globl vector40
vector40:
  pushl $0
c0101f1a:	6a 00                	push   $0x0
  pushl $40
c0101f1c:	6a 28                	push   $0x28
  jmp __alltraps
c0101f1e:	e9 0f 09 00 00       	jmp    c0102832 <__alltraps>

c0101f23 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101f23:	6a 00                	push   $0x0
  pushl $41
c0101f25:	6a 29                	push   $0x29
  jmp __alltraps
c0101f27:	e9 06 09 00 00       	jmp    c0102832 <__alltraps>

c0101f2c <vector42>:
.globl vector42
vector42:
  pushl $0
c0101f2c:	6a 00                	push   $0x0
  pushl $42
c0101f2e:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101f30:	e9 fd 08 00 00       	jmp    c0102832 <__alltraps>

c0101f35 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101f35:	6a 00                	push   $0x0
  pushl $43
c0101f37:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101f39:	e9 f4 08 00 00       	jmp    c0102832 <__alltraps>

c0101f3e <vector44>:
.globl vector44
vector44:
  pushl $0
c0101f3e:	6a 00                	push   $0x0
  pushl $44
c0101f40:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101f42:	e9 eb 08 00 00       	jmp    c0102832 <__alltraps>

c0101f47 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101f47:	6a 00                	push   $0x0
  pushl $45
c0101f49:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101f4b:	e9 e2 08 00 00       	jmp    c0102832 <__alltraps>

c0101f50 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101f50:	6a 00                	push   $0x0
  pushl $46
c0101f52:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101f54:	e9 d9 08 00 00       	jmp    c0102832 <__alltraps>

c0101f59 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101f59:	6a 00                	push   $0x0
  pushl $47
c0101f5b:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101f5d:	e9 d0 08 00 00       	jmp    c0102832 <__alltraps>

c0101f62 <vector48>:
.globl vector48
vector48:
  pushl $0
c0101f62:	6a 00                	push   $0x0
  pushl $48
c0101f64:	6a 30                	push   $0x30
  jmp __alltraps
c0101f66:	e9 c7 08 00 00       	jmp    c0102832 <__alltraps>

c0101f6b <vector49>:
.globl vector49
vector49:
  pushl $0
c0101f6b:	6a 00                	push   $0x0
  pushl $49
c0101f6d:	6a 31                	push   $0x31
  jmp __alltraps
c0101f6f:	e9 be 08 00 00       	jmp    c0102832 <__alltraps>

c0101f74 <vector50>:
.globl vector50
vector50:
  pushl $0
c0101f74:	6a 00                	push   $0x0
  pushl $50
c0101f76:	6a 32                	push   $0x32
  jmp __alltraps
c0101f78:	e9 b5 08 00 00       	jmp    c0102832 <__alltraps>

c0101f7d <vector51>:
.globl vector51
vector51:
  pushl $0
c0101f7d:	6a 00                	push   $0x0
  pushl $51
c0101f7f:	6a 33                	push   $0x33
  jmp __alltraps
c0101f81:	e9 ac 08 00 00       	jmp    c0102832 <__alltraps>

c0101f86 <vector52>:
.globl vector52
vector52:
  pushl $0
c0101f86:	6a 00                	push   $0x0
  pushl $52
c0101f88:	6a 34                	push   $0x34
  jmp __alltraps
c0101f8a:	e9 a3 08 00 00       	jmp    c0102832 <__alltraps>

c0101f8f <vector53>:
.globl vector53
vector53:
  pushl $0
c0101f8f:	6a 00                	push   $0x0
  pushl $53
c0101f91:	6a 35                	push   $0x35
  jmp __alltraps
c0101f93:	e9 9a 08 00 00       	jmp    c0102832 <__alltraps>

c0101f98 <vector54>:
.globl vector54
vector54:
  pushl $0
c0101f98:	6a 00                	push   $0x0
  pushl $54
c0101f9a:	6a 36                	push   $0x36
  jmp __alltraps
c0101f9c:	e9 91 08 00 00       	jmp    c0102832 <__alltraps>

c0101fa1 <vector55>:
.globl vector55
vector55:
  pushl $0
c0101fa1:	6a 00                	push   $0x0
  pushl $55
c0101fa3:	6a 37                	push   $0x37
  jmp __alltraps
c0101fa5:	e9 88 08 00 00       	jmp    c0102832 <__alltraps>

c0101faa <vector56>:
.globl vector56
vector56:
  pushl $0
c0101faa:	6a 00                	push   $0x0
  pushl $56
c0101fac:	6a 38                	push   $0x38
  jmp __alltraps
c0101fae:	e9 7f 08 00 00       	jmp    c0102832 <__alltraps>

c0101fb3 <vector57>:
.globl vector57
vector57:
  pushl $0
c0101fb3:	6a 00                	push   $0x0
  pushl $57
c0101fb5:	6a 39                	push   $0x39
  jmp __alltraps
c0101fb7:	e9 76 08 00 00       	jmp    c0102832 <__alltraps>

c0101fbc <vector58>:
.globl vector58
vector58:
  pushl $0
c0101fbc:	6a 00                	push   $0x0
  pushl $58
c0101fbe:	6a 3a                	push   $0x3a
  jmp __alltraps
c0101fc0:	e9 6d 08 00 00       	jmp    c0102832 <__alltraps>

c0101fc5 <vector59>:
.globl vector59
vector59:
  pushl $0
c0101fc5:	6a 00                	push   $0x0
  pushl $59
c0101fc7:	6a 3b                	push   $0x3b
  jmp __alltraps
c0101fc9:	e9 64 08 00 00       	jmp    c0102832 <__alltraps>

c0101fce <vector60>:
.globl vector60
vector60:
  pushl $0
c0101fce:	6a 00                	push   $0x0
  pushl $60
c0101fd0:	6a 3c                	push   $0x3c
  jmp __alltraps
c0101fd2:	e9 5b 08 00 00       	jmp    c0102832 <__alltraps>

c0101fd7 <vector61>:
.globl vector61
vector61:
  pushl $0
c0101fd7:	6a 00                	push   $0x0
  pushl $61
c0101fd9:	6a 3d                	push   $0x3d
  jmp __alltraps
c0101fdb:	e9 52 08 00 00       	jmp    c0102832 <__alltraps>

c0101fe0 <vector62>:
.globl vector62
vector62:
  pushl $0
c0101fe0:	6a 00                	push   $0x0
  pushl $62
c0101fe2:	6a 3e                	push   $0x3e
  jmp __alltraps
c0101fe4:	e9 49 08 00 00       	jmp    c0102832 <__alltraps>

c0101fe9 <vector63>:
.globl vector63
vector63:
  pushl $0
c0101fe9:	6a 00                	push   $0x0
  pushl $63
c0101feb:	6a 3f                	push   $0x3f
  jmp __alltraps
c0101fed:	e9 40 08 00 00       	jmp    c0102832 <__alltraps>

c0101ff2 <vector64>:
.globl vector64
vector64:
  pushl $0
c0101ff2:	6a 00                	push   $0x0
  pushl $64
c0101ff4:	6a 40                	push   $0x40
  jmp __alltraps
c0101ff6:	e9 37 08 00 00       	jmp    c0102832 <__alltraps>

c0101ffb <vector65>:
.globl vector65
vector65:
  pushl $0
c0101ffb:	6a 00                	push   $0x0
  pushl $65
c0101ffd:	6a 41                	push   $0x41
  jmp __alltraps
c0101fff:	e9 2e 08 00 00       	jmp    c0102832 <__alltraps>

c0102004 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102004:	6a 00                	push   $0x0
  pushl $66
c0102006:	6a 42                	push   $0x42
  jmp __alltraps
c0102008:	e9 25 08 00 00       	jmp    c0102832 <__alltraps>

c010200d <vector67>:
.globl vector67
vector67:
  pushl $0
c010200d:	6a 00                	push   $0x0
  pushl $67
c010200f:	6a 43                	push   $0x43
  jmp __alltraps
c0102011:	e9 1c 08 00 00       	jmp    c0102832 <__alltraps>

c0102016 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102016:	6a 00                	push   $0x0
  pushl $68
c0102018:	6a 44                	push   $0x44
  jmp __alltraps
c010201a:	e9 13 08 00 00       	jmp    c0102832 <__alltraps>

c010201f <vector69>:
.globl vector69
vector69:
  pushl $0
c010201f:	6a 00                	push   $0x0
  pushl $69
c0102021:	6a 45                	push   $0x45
  jmp __alltraps
c0102023:	e9 0a 08 00 00       	jmp    c0102832 <__alltraps>

c0102028 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102028:	6a 00                	push   $0x0
  pushl $70
c010202a:	6a 46                	push   $0x46
  jmp __alltraps
c010202c:	e9 01 08 00 00       	jmp    c0102832 <__alltraps>

c0102031 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102031:	6a 00                	push   $0x0
  pushl $71
c0102033:	6a 47                	push   $0x47
  jmp __alltraps
c0102035:	e9 f8 07 00 00       	jmp    c0102832 <__alltraps>

c010203a <vector72>:
.globl vector72
vector72:
  pushl $0
c010203a:	6a 00                	push   $0x0
  pushl $72
c010203c:	6a 48                	push   $0x48
  jmp __alltraps
c010203e:	e9 ef 07 00 00       	jmp    c0102832 <__alltraps>

c0102043 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102043:	6a 00                	push   $0x0
  pushl $73
c0102045:	6a 49                	push   $0x49
  jmp __alltraps
c0102047:	e9 e6 07 00 00       	jmp    c0102832 <__alltraps>

c010204c <vector74>:
.globl vector74
vector74:
  pushl $0
c010204c:	6a 00                	push   $0x0
  pushl $74
c010204e:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102050:	e9 dd 07 00 00       	jmp    c0102832 <__alltraps>

c0102055 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102055:	6a 00                	push   $0x0
  pushl $75
c0102057:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102059:	e9 d4 07 00 00       	jmp    c0102832 <__alltraps>

c010205e <vector76>:
.globl vector76
vector76:
  pushl $0
c010205e:	6a 00                	push   $0x0
  pushl $76
c0102060:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102062:	e9 cb 07 00 00       	jmp    c0102832 <__alltraps>

c0102067 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102067:	6a 00                	push   $0x0
  pushl $77
c0102069:	6a 4d                	push   $0x4d
  jmp __alltraps
c010206b:	e9 c2 07 00 00       	jmp    c0102832 <__alltraps>

c0102070 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102070:	6a 00                	push   $0x0
  pushl $78
c0102072:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102074:	e9 b9 07 00 00       	jmp    c0102832 <__alltraps>

c0102079 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102079:	6a 00                	push   $0x0
  pushl $79
c010207b:	6a 4f                	push   $0x4f
  jmp __alltraps
c010207d:	e9 b0 07 00 00       	jmp    c0102832 <__alltraps>

c0102082 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102082:	6a 00                	push   $0x0
  pushl $80
c0102084:	6a 50                	push   $0x50
  jmp __alltraps
c0102086:	e9 a7 07 00 00       	jmp    c0102832 <__alltraps>

c010208b <vector81>:
.globl vector81
vector81:
  pushl $0
c010208b:	6a 00                	push   $0x0
  pushl $81
c010208d:	6a 51                	push   $0x51
  jmp __alltraps
c010208f:	e9 9e 07 00 00       	jmp    c0102832 <__alltraps>

c0102094 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102094:	6a 00                	push   $0x0
  pushl $82
c0102096:	6a 52                	push   $0x52
  jmp __alltraps
c0102098:	e9 95 07 00 00       	jmp    c0102832 <__alltraps>

c010209d <vector83>:
.globl vector83
vector83:
  pushl $0
c010209d:	6a 00                	push   $0x0
  pushl $83
c010209f:	6a 53                	push   $0x53
  jmp __alltraps
c01020a1:	e9 8c 07 00 00       	jmp    c0102832 <__alltraps>

c01020a6 <vector84>:
.globl vector84
vector84:
  pushl $0
c01020a6:	6a 00                	push   $0x0
  pushl $84
c01020a8:	6a 54                	push   $0x54
  jmp __alltraps
c01020aa:	e9 83 07 00 00       	jmp    c0102832 <__alltraps>

c01020af <vector85>:
.globl vector85
vector85:
  pushl $0
c01020af:	6a 00                	push   $0x0
  pushl $85
c01020b1:	6a 55                	push   $0x55
  jmp __alltraps
c01020b3:	e9 7a 07 00 00       	jmp    c0102832 <__alltraps>

c01020b8 <vector86>:
.globl vector86
vector86:
  pushl $0
c01020b8:	6a 00                	push   $0x0
  pushl $86
c01020ba:	6a 56                	push   $0x56
  jmp __alltraps
c01020bc:	e9 71 07 00 00       	jmp    c0102832 <__alltraps>

c01020c1 <vector87>:
.globl vector87
vector87:
  pushl $0
c01020c1:	6a 00                	push   $0x0
  pushl $87
c01020c3:	6a 57                	push   $0x57
  jmp __alltraps
c01020c5:	e9 68 07 00 00       	jmp    c0102832 <__alltraps>

c01020ca <vector88>:
.globl vector88
vector88:
  pushl $0
c01020ca:	6a 00                	push   $0x0
  pushl $88
c01020cc:	6a 58                	push   $0x58
  jmp __alltraps
c01020ce:	e9 5f 07 00 00       	jmp    c0102832 <__alltraps>

c01020d3 <vector89>:
.globl vector89
vector89:
  pushl $0
c01020d3:	6a 00                	push   $0x0
  pushl $89
c01020d5:	6a 59                	push   $0x59
  jmp __alltraps
c01020d7:	e9 56 07 00 00       	jmp    c0102832 <__alltraps>

c01020dc <vector90>:
.globl vector90
vector90:
  pushl $0
c01020dc:	6a 00                	push   $0x0
  pushl $90
c01020de:	6a 5a                	push   $0x5a
  jmp __alltraps
c01020e0:	e9 4d 07 00 00       	jmp    c0102832 <__alltraps>

c01020e5 <vector91>:
.globl vector91
vector91:
  pushl $0
c01020e5:	6a 00                	push   $0x0
  pushl $91
c01020e7:	6a 5b                	push   $0x5b
  jmp __alltraps
c01020e9:	e9 44 07 00 00       	jmp    c0102832 <__alltraps>

c01020ee <vector92>:
.globl vector92
vector92:
  pushl $0
c01020ee:	6a 00                	push   $0x0
  pushl $92
c01020f0:	6a 5c                	push   $0x5c
  jmp __alltraps
c01020f2:	e9 3b 07 00 00       	jmp    c0102832 <__alltraps>

c01020f7 <vector93>:
.globl vector93
vector93:
  pushl $0
c01020f7:	6a 00                	push   $0x0
  pushl $93
c01020f9:	6a 5d                	push   $0x5d
  jmp __alltraps
c01020fb:	e9 32 07 00 00       	jmp    c0102832 <__alltraps>

c0102100 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102100:	6a 00                	push   $0x0
  pushl $94
c0102102:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102104:	e9 29 07 00 00       	jmp    c0102832 <__alltraps>

c0102109 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102109:	6a 00                	push   $0x0
  pushl $95
c010210b:	6a 5f                	push   $0x5f
  jmp __alltraps
c010210d:	e9 20 07 00 00       	jmp    c0102832 <__alltraps>

c0102112 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102112:	6a 00                	push   $0x0
  pushl $96
c0102114:	6a 60                	push   $0x60
  jmp __alltraps
c0102116:	e9 17 07 00 00       	jmp    c0102832 <__alltraps>

c010211b <vector97>:
.globl vector97
vector97:
  pushl $0
c010211b:	6a 00                	push   $0x0
  pushl $97
c010211d:	6a 61                	push   $0x61
  jmp __alltraps
c010211f:	e9 0e 07 00 00       	jmp    c0102832 <__alltraps>

c0102124 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102124:	6a 00                	push   $0x0
  pushl $98
c0102126:	6a 62                	push   $0x62
  jmp __alltraps
c0102128:	e9 05 07 00 00       	jmp    c0102832 <__alltraps>

c010212d <vector99>:
.globl vector99
vector99:
  pushl $0
c010212d:	6a 00                	push   $0x0
  pushl $99
c010212f:	6a 63                	push   $0x63
  jmp __alltraps
c0102131:	e9 fc 06 00 00       	jmp    c0102832 <__alltraps>

c0102136 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102136:	6a 00                	push   $0x0
  pushl $100
c0102138:	6a 64                	push   $0x64
  jmp __alltraps
c010213a:	e9 f3 06 00 00       	jmp    c0102832 <__alltraps>

c010213f <vector101>:
.globl vector101
vector101:
  pushl $0
c010213f:	6a 00                	push   $0x0
  pushl $101
c0102141:	6a 65                	push   $0x65
  jmp __alltraps
c0102143:	e9 ea 06 00 00       	jmp    c0102832 <__alltraps>

c0102148 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102148:	6a 00                	push   $0x0
  pushl $102
c010214a:	6a 66                	push   $0x66
  jmp __alltraps
c010214c:	e9 e1 06 00 00       	jmp    c0102832 <__alltraps>

c0102151 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102151:	6a 00                	push   $0x0
  pushl $103
c0102153:	6a 67                	push   $0x67
  jmp __alltraps
c0102155:	e9 d8 06 00 00       	jmp    c0102832 <__alltraps>

c010215a <vector104>:
.globl vector104
vector104:
  pushl $0
c010215a:	6a 00                	push   $0x0
  pushl $104
c010215c:	6a 68                	push   $0x68
  jmp __alltraps
c010215e:	e9 cf 06 00 00       	jmp    c0102832 <__alltraps>

c0102163 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102163:	6a 00                	push   $0x0
  pushl $105
c0102165:	6a 69                	push   $0x69
  jmp __alltraps
c0102167:	e9 c6 06 00 00       	jmp    c0102832 <__alltraps>

c010216c <vector106>:
.globl vector106
vector106:
  pushl $0
c010216c:	6a 00                	push   $0x0
  pushl $106
c010216e:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102170:	e9 bd 06 00 00       	jmp    c0102832 <__alltraps>

c0102175 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102175:	6a 00                	push   $0x0
  pushl $107
c0102177:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102179:	e9 b4 06 00 00       	jmp    c0102832 <__alltraps>

c010217e <vector108>:
.globl vector108
vector108:
  pushl $0
c010217e:	6a 00                	push   $0x0
  pushl $108
c0102180:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102182:	e9 ab 06 00 00       	jmp    c0102832 <__alltraps>

c0102187 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102187:	6a 00                	push   $0x0
  pushl $109
c0102189:	6a 6d                	push   $0x6d
  jmp __alltraps
c010218b:	e9 a2 06 00 00       	jmp    c0102832 <__alltraps>

c0102190 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102190:	6a 00                	push   $0x0
  pushl $110
c0102192:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102194:	e9 99 06 00 00       	jmp    c0102832 <__alltraps>

c0102199 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102199:	6a 00                	push   $0x0
  pushl $111
c010219b:	6a 6f                	push   $0x6f
  jmp __alltraps
c010219d:	e9 90 06 00 00       	jmp    c0102832 <__alltraps>

c01021a2 <vector112>:
.globl vector112
vector112:
  pushl $0
c01021a2:	6a 00                	push   $0x0
  pushl $112
c01021a4:	6a 70                	push   $0x70
  jmp __alltraps
c01021a6:	e9 87 06 00 00       	jmp    c0102832 <__alltraps>

c01021ab <vector113>:
.globl vector113
vector113:
  pushl $0
c01021ab:	6a 00                	push   $0x0
  pushl $113
c01021ad:	6a 71                	push   $0x71
  jmp __alltraps
c01021af:	e9 7e 06 00 00       	jmp    c0102832 <__alltraps>

c01021b4 <vector114>:
.globl vector114
vector114:
  pushl $0
c01021b4:	6a 00                	push   $0x0
  pushl $114
c01021b6:	6a 72                	push   $0x72
  jmp __alltraps
c01021b8:	e9 75 06 00 00       	jmp    c0102832 <__alltraps>

c01021bd <vector115>:
.globl vector115
vector115:
  pushl $0
c01021bd:	6a 00                	push   $0x0
  pushl $115
c01021bf:	6a 73                	push   $0x73
  jmp __alltraps
c01021c1:	e9 6c 06 00 00       	jmp    c0102832 <__alltraps>

c01021c6 <vector116>:
.globl vector116
vector116:
  pushl $0
c01021c6:	6a 00                	push   $0x0
  pushl $116
c01021c8:	6a 74                	push   $0x74
  jmp __alltraps
c01021ca:	e9 63 06 00 00       	jmp    c0102832 <__alltraps>

c01021cf <vector117>:
.globl vector117
vector117:
  pushl $0
c01021cf:	6a 00                	push   $0x0
  pushl $117
c01021d1:	6a 75                	push   $0x75
  jmp __alltraps
c01021d3:	e9 5a 06 00 00       	jmp    c0102832 <__alltraps>

c01021d8 <vector118>:
.globl vector118
vector118:
  pushl $0
c01021d8:	6a 00                	push   $0x0
  pushl $118
c01021da:	6a 76                	push   $0x76
  jmp __alltraps
c01021dc:	e9 51 06 00 00       	jmp    c0102832 <__alltraps>

c01021e1 <vector119>:
.globl vector119
vector119:
  pushl $0
c01021e1:	6a 00                	push   $0x0
  pushl $119
c01021e3:	6a 77                	push   $0x77
  jmp __alltraps
c01021e5:	e9 48 06 00 00       	jmp    c0102832 <__alltraps>

c01021ea <vector120>:
.globl vector120
vector120:
  pushl $0
c01021ea:	6a 00                	push   $0x0
  pushl $120
c01021ec:	6a 78                	push   $0x78
  jmp __alltraps
c01021ee:	e9 3f 06 00 00       	jmp    c0102832 <__alltraps>

c01021f3 <vector121>:
.globl vector121
vector121:
  pushl $0
c01021f3:	6a 00                	push   $0x0
  pushl $121
c01021f5:	6a 79                	push   $0x79
  jmp __alltraps
c01021f7:	e9 36 06 00 00       	jmp    c0102832 <__alltraps>

c01021fc <vector122>:
.globl vector122
vector122:
  pushl $0
c01021fc:	6a 00                	push   $0x0
  pushl $122
c01021fe:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102200:	e9 2d 06 00 00       	jmp    c0102832 <__alltraps>

c0102205 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102205:	6a 00                	push   $0x0
  pushl $123
c0102207:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102209:	e9 24 06 00 00       	jmp    c0102832 <__alltraps>

c010220e <vector124>:
.globl vector124
vector124:
  pushl $0
c010220e:	6a 00                	push   $0x0
  pushl $124
c0102210:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102212:	e9 1b 06 00 00       	jmp    c0102832 <__alltraps>

c0102217 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102217:	6a 00                	push   $0x0
  pushl $125
c0102219:	6a 7d                	push   $0x7d
  jmp __alltraps
c010221b:	e9 12 06 00 00       	jmp    c0102832 <__alltraps>

c0102220 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102220:	6a 00                	push   $0x0
  pushl $126
c0102222:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102224:	e9 09 06 00 00       	jmp    c0102832 <__alltraps>

c0102229 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102229:	6a 00                	push   $0x0
  pushl $127
c010222b:	6a 7f                	push   $0x7f
  jmp __alltraps
c010222d:	e9 00 06 00 00       	jmp    c0102832 <__alltraps>

c0102232 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102232:	6a 00                	push   $0x0
  pushl $128
c0102234:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102239:	e9 f4 05 00 00       	jmp    c0102832 <__alltraps>

c010223e <vector129>:
.globl vector129
vector129:
  pushl $0
c010223e:	6a 00                	push   $0x0
  pushl $129
c0102240:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102245:	e9 e8 05 00 00       	jmp    c0102832 <__alltraps>

c010224a <vector130>:
.globl vector130
vector130:
  pushl $0
c010224a:	6a 00                	push   $0x0
  pushl $130
c010224c:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102251:	e9 dc 05 00 00       	jmp    c0102832 <__alltraps>

c0102256 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102256:	6a 00                	push   $0x0
  pushl $131
c0102258:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010225d:	e9 d0 05 00 00       	jmp    c0102832 <__alltraps>

c0102262 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102262:	6a 00                	push   $0x0
  pushl $132
c0102264:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102269:	e9 c4 05 00 00       	jmp    c0102832 <__alltraps>

c010226e <vector133>:
.globl vector133
vector133:
  pushl $0
c010226e:	6a 00                	push   $0x0
  pushl $133
c0102270:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102275:	e9 b8 05 00 00       	jmp    c0102832 <__alltraps>

c010227a <vector134>:
.globl vector134
vector134:
  pushl $0
c010227a:	6a 00                	push   $0x0
  pushl $134
c010227c:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102281:	e9 ac 05 00 00       	jmp    c0102832 <__alltraps>

c0102286 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102286:	6a 00                	push   $0x0
  pushl $135
c0102288:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010228d:	e9 a0 05 00 00       	jmp    c0102832 <__alltraps>

c0102292 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102292:	6a 00                	push   $0x0
  pushl $136
c0102294:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102299:	e9 94 05 00 00       	jmp    c0102832 <__alltraps>

c010229e <vector137>:
.globl vector137
vector137:
  pushl $0
c010229e:	6a 00                	push   $0x0
  pushl $137
c01022a0:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01022a5:	e9 88 05 00 00       	jmp    c0102832 <__alltraps>

c01022aa <vector138>:
.globl vector138
vector138:
  pushl $0
c01022aa:	6a 00                	push   $0x0
  pushl $138
c01022ac:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01022b1:	e9 7c 05 00 00       	jmp    c0102832 <__alltraps>

c01022b6 <vector139>:
.globl vector139
vector139:
  pushl $0
c01022b6:	6a 00                	push   $0x0
  pushl $139
c01022b8:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01022bd:	e9 70 05 00 00       	jmp    c0102832 <__alltraps>

c01022c2 <vector140>:
.globl vector140
vector140:
  pushl $0
c01022c2:	6a 00                	push   $0x0
  pushl $140
c01022c4:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01022c9:	e9 64 05 00 00       	jmp    c0102832 <__alltraps>

c01022ce <vector141>:
.globl vector141
vector141:
  pushl $0
c01022ce:	6a 00                	push   $0x0
  pushl $141
c01022d0:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01022d5:	e9 58 05 00 00       	jmp    c0102832 <__alltraps>

c01022da <vector142>:
.globl vector142
vector142:
  pushl $0
c01022da:	6a 00                	push   $0x0
  pushl $142
c01022dc:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01022e1:	e9 4c 05 00 00       	jmp    c0102832 <__alltraps>

c01022e6 <vector143>:
.globl vector143
vector143:
  pushl $0
c01022e6:	6a 00                	push   $0x0
  pushl $143
c01022e8:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01022ed:	e9 40 05 00 00       	jmp    c0102832 <__alltraps>

c01022f2 <vector144>:
.globl vector144
vector144:
  pushl $0
c01022f2:	6a 00                	push   $0x0
  pushl $144
c01022f4:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01022f9:	e9 34 05 00 00       	jmp    c0102832 <__alltraps>

c01022fe <vector145>:
.globl vector145
vector145:
  pushl $0
c01022fe:	6a 00                	push   $0x0
  pushl $145
c0102300:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102305:	e9 28 05 00 00       	jmp    c0102832 <__alltraps>

c010230a <vector146>:
.globl vector146
vector146:
  pushl $0
c010230a:	6a 00                	push   $0x0
  pushl $146
c010230c:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102311:	e9 1c 05 00 00       	jmp    c0102832 <__alltraps>

c0102316 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102316:	6a 00                	push   $0x0
  pushl $147
c0102318:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010231d:	e9 10 05 00 00       	jmp    c0102832 <__alltraps>

c0102322 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102322:	6a 00                	push   $0x0
  pushl $148
c0102324:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102329:	e9 04 05 00 00       	jmp    c0102832 <__alltraps>

c010232e <vector149>:
.globl vector149
vector149:
  pushl $0
c010232e:	6a 00                	push   $0x0
  pushl $149
c0102330:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102335:	e9 f8 04 00 00       	jmp    c0102832 <__alltraps>

c010233a <vector150>:
.globl vector150
vector150:
  pushl $0
c010233a:	6a 00                	push   $0x0
  pushl $150
c010233c:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102341:	e9 ec 04 00 00       	jmp    c0102832 <__alltraps>

c0102346 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102346:	6a 00                	push   $0x0
  pushl $151
c0102348:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010234d:	e9 e0 04 00 00       	jmp    c0102832 <__alltraps>

c0102352 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102352:	6a 00                	push   $0x0
  pushl $152
c0102354:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102359:	e9 d4 04 00 00       	jmp    c0102832 <__alltraps>

c010235e <vector153>:
.globl vector153
vector153:
  pushl $0
c010235e:	6a 00                	push   $0x0
  pushl $153
c0102360:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102365:	e9 c8 04 00 00       	jmp    c0102832 <__alltraps>

c010236a <vector154>:
.globl vector154
vector154:
  pushl $0
c010236a:	6a 00                	push   $0x0
  pushl $154
c010236c:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102371:	e9 bc 04 00 00       	jmp    c0102832 <__alltraps>

c0102376 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102376:	6a 00                	push   $0x0
  pushl $155
c0102378:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010237d:	e9 b0 04 00 00       	jmp    c0102832 <__alltraps>

c0102382 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102382:	6a 00                	push   $0x0
  pushl $156
c0102384:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102389:	e9 a4 04 00 00       	jmp    c0102832 <__alltraps>

c010238e <vector157>:
.globl vector157
vector157:
  pushl $0
c010238e:	6a 00                	push   $0x0
  pushl $157
c0102390:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102395:	e9 98 04 00 00       	jmp    c0102832 <__alltraps>

c010239a <vector158>:
.globl vector158
vector158:
  pushl $0
c010239a:	6a 00                	push   $0x0
  pushl $158
c010239c:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01023a1:	e9 8c 04 00 00       	jmp    c0102832 <__alltraps>

c01023a6 <vector159>:
.globl vector159
vector159:
  pushl $0
c01023a6:	6a 00                	push   $0x0
  pushl $159
c01023a8:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01023ad:	e9 80 04 00 00       	jmp    c0102832 <__alltraps>

c01023b2 <vector160>:
.globl vector160
vector160:
  pushl $0
c01023b2:	6a 00                	push   $0x0
  pushl $160
c01023b4:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01023b9:	e9 74 04 00 00       	jmp    c0102832 <__alltraps>

c01023be <vector161>:
.globl vector161
vector161:
  pushl $0
c01023be:	6a 00                	push   $0x0
  pushl $161
c01023c0:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01023c5:	e9 68 04 00 00       	jmp    c0102832 <__alltraps>

c01023ca <vector162>:
.globl vector162
vector162:
  pushl $0
c01023ca:	6a 00                	push   $0x0
  pushl $162
c01023cc:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01023d1:	e9 5c 04 00 00       	jmp    c0102832 <__alltraps>

c01023d6 <vector163>:
.globl vector163
vector163:
  pushl $0
c01023d6:	6a 00                	push   $0x0
  pushl $163
c01023d8:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01023dd:	e9 50 04 00 00       	jmp    c0102832 <__alltraps>

c01023e2 <vector164>:
.globl vector164
vector164:
  pushl $0
c01023e2:	6a 00                	push   $0x0
  pushl $164
c01023e4:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01023e9:	e9 44 04 00 00       	jmp    c0102832 <__alltraps>

c01023ee <vector165>:
.globl vector165
vector165:
  pushl $0
c01023ee:	6a 00                	push   $0x0
  pushl $165
c01023f0:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01023f5:	e9 38 04 00 00       	jmp    c0102832 <__alltraps>

c01023fa <vector166>:
.globl vector166
vector166:
  pushl $0
c01023fa:	6a 00                	push   $0x0
  pushl $166
c01023fc:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102401:	e9 2c 04 00 00       	jmp    c0102832 <__alltraps>

c0102406 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102406:	6a 00                	push   $0x0
  pushl $167
c0102408:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010240d:	e9 20 04 00 00       	jmp    c0102832 <__alltraps>

c0102412 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102412:	6a 00                	push   $0x0
  pushl $168
c0102414:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102419:	e9 14 04 00 00       	jmp    c0102832 <__alltraps>

c010241e <vector169>:
.globl vector169
vector169:
  pushl $0
c010241e:	6a 00                	push   $0x0
  pushl $169
c0102420:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102425:	e9 08 04 00 00       	jmp    c0102832 <__alltraps>

c010242a <vector170>:
.globl vector170
vector170:
  pushl $0
c010242a:	6a 00                	push   $0x0
  pushl $170
c010242c:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102431:	e9 fc 03 00 00       	jmp    c0102832 <__alltraps>

c0102436 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102436:	6a 00                	push   $0x0
  pushl $171
c0102438:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010243d:	e9 f0 03 00 00       	jmp    c0102832 <__alltraps>

c0102442 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102442:	6a 00                	push   $0x0
  pushl $172
c0102444:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102449:	e9 e4 03 00 00       	jmp    c0102832 <__alltraps>

c010244e <vector173>:
.globl vector173
vector173:
  pushl $0
c010244e:	6a 00                	push   $0x0
  pushl $173
c0102450:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102455:	e9 d8 03 00 00       	jmp    c0102832 <__alltraps>

c010245a <vector174>:
.globl vector174
vector174:
  pushl $0
c010245a:	6a 00                	push   $0x0
  pushl $174
c010245c:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102461:	e9 cc 03 00 00       	jmp    c0102832 <__alltraps>

c0102466 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102466:	6a 00                	push   $0x0
  pushl $175
c0102468:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010246d:	e9 c0 03 00 00       	jmp    c0102832 <__alltraps>

c0102472 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102472:	6a 00                	push   $0x0
  pushl $176
c0102474:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102479:	e9 b4 03 00 00       	jmp    c0102832 <__alltraps>

c010247e <vector177>:
.globl vector177
vector177:
  pushl $0
c010247e:	6a 00                	push   $0x0
  pushl $177
c0102480:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102485:	e9 a8 03 00 00       	jmp    c0102832 <__alltraps>

c010248a <vector178>:
.globl vector178
vector178:
  pushl $0
c010248a:	6a 00                	push   $0x0
  pushl $178
c010248c:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102491:	e9 9c 03 00 00       	jmp    c0102832 <__alltraps>

c0102496 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102496:	6a 00                	push   $0x0
  pushl $179
c0102498:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010249d:	e9 90 03 00 00       	jmp    c0102832 <__alltraps>

c01024a2 <vector180>:
.globl vector180
vector180:
  pushl $0
c01024a2:	6a 00                	push   $0x0
  pushl $180
c01024a4:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01024a9:	e9 84 03 00 00       	jmp    c0102832 <__alltraps>

c01024ae <vector181>:
.globl vector181
vector181:
  pushl $0
c01024ae:	6a 00                	push   $0x0
  pushl $181
c01024b0:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01024b5:	e9 78 03 00 00       	jmp    c0102832 <__alltraps>

c01024ba <vector182>:
.globl vector182
vector182:
  pushl $0
c01024ba:	6a 00                	push   $0x0
  pushl $182
c01024bc:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01024c1:	e9 6c 03 00 00       	jmp    c0102832 <__alltraps>

c01024c6 <vector183>:
.globl vector183
vector183:
  pushl $0
c01024c6:	6a 00                	push   $0x0
  pushl $183
c01024c8:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01024cd:	e9 60 03 00 00       	jmp    c0102832 <__alltraps>

c01024d2 <vector184>:
.globl vector184
vector184:
  pushl $0
c01024d2:	6a 00                	push   $0x0
  pushl $184
c01024d4:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01024d9:	e9 54 03 00 00       	jmp    c0102832 <__alltraps>

c01024de <vector185>:
.globl vector185
vector185:
  pushl $0
c01024de:	6a 00                	push   $0x0
  pushl $185
c01024e0:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01024e5:	e9 48 03 00 00       	jmp    c0102832 <__alltraps>

c01024ea <vector186>:
.globl vector186
vector186:
  pushl $0
c01024ea:	6a 00                	push   $0x0
  pushl $186
c01024ec:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01024f1:	e9 3c 03 00 00       	jmp    c0102832 <__alltraps>

c01024f6 <vector187>:
.globl vector187
vector187:
  pushl $0
c01024f6:	6a 00                	push   $0x0
  pushl $187
c01024f8:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01024fd:	e9 30 03 00 00       	jmp    c0102832 <__alltraps>

c0102502 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102502:	6a 00                	push   $0x0
  pushl $188
c0102504:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102509:	e9 24 03 00 00       	jmp    c0102832 <__alltraps>

c010250e <vector189>:
.globl vector189
vector189:
  pushl $0
c010250e:	6a 00                	push   $0x0
  pushl $189
c0102510:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102515:	e9 18 03 00 00       	jmp    c0102832 <__alltraps>

c010251a <vector190>:
.globl vector190
vector190:
  pushl $0
c010251a:	6a 00                	push   $0x0
  pushl $190
c010251c:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102521:	e9 0c 03 00 00       	jmp    c0102832 <__alltraps>

c0102526 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102526:	6a 00                	push   $0x0
  pushl $191
c0102528:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010252d:	e9 00 03 00 00       	jmp    c0102832 <__alltraps>

c0102532 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102532:	6a 00                	push   $0x0
  pushl $192
c0102534:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102539:	e9 f4 02 00 00       	jmp    c0102832 <__alltraps>

c010253e <vector193>:
.globl vector193
vector193:
  pushl $0
c010253e:	6a 00                	push   $0x0
  pushl $193
c0102540:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102545:	e9 e8 02 00 00       	jmp    c0102832 <__alltraps>

c010254a <vector194>:
.globl vector194
vector194:
  pushl $0
c010254a:	6a 00                	push   $0x0
  pushl $194
c010254c:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102551:	e9 dc 02 00 00       	jmp    c0102832 <__alltraps>

c0102556 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102556:	6a 00                	push   $0x0
  pushl $195
c0102558:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010255d:	e9 d0 02 00 00       	jmp    c0102832 <__alltraps>

c0102562 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102562:	6a 00                	push   $0x0
  pushl $196
c0102564:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102569:	e9 c4 02 00 00       	jmp    c0102832 <__alltraps>

c010256e <vector197>:
.globl vector197
vector197:
  pushl $0
c010256e:	6a 00                	push   $0x0
  pushl $197
c0102570:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102575:	e9 b8 02 00 00       	jmp    c0102832 <__alltraps>

c010257a <vector198>:
.globl vector198
vector198:
  pushl $0
c010257a:	6a 00                	push   $0x0
  pushl $198
c010257c:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102581:	e9 ac 02 00 00       	jmp    c0102832 <__alltraps>

c0102586 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102586:	6a 00                	push   $0x0
  pushl $199
c0102588:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010258d:	e9 a0 02 00 00       	jmp    c0102832 <__alltraps>

c0102592 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102592:	6a 00                	push   $0x0
  pushl $200
c0102594:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102599:	e9 94 02 00 00       	jmp    c0102832 <__alltraps>

c010259e <vector201>:
.globl vector201
vector201:
  pushl $0
c010259e:	6a 00                	push   $0x0
  pushl $201
c01025a0:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01025a5:	e9 88 02 00 00       	jmp    c0102832 <__alltraps>

c01025aa <vector202>:
.globl vector202
vector202:
  pushl $0
c01025aa:	6a 00                	push   $0x0
  pushl $202
c01025ac:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01025b1:	e9 7c 02 00 00       	jmp    c0102832 <__alltraps>

c01025b6 <vector203>:
.globl vector203
vector203:
  pushl $0
c01025b6:	6a 00                	push   $0x0
  pushl $203
c01025b8:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01025bd:	e9 70 02 00 00       	jmp    c0102832 <__alltraps>

c01025c2 <vector204>:
.globl vector204
vector204:
  pushl $0
c01025c2:	6a 00                	push   $0x0
  pushl $204
c01025c4:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01025c9:	e9 64 02 00 00       	jmp    c0102832 <__alltraps>

c01025ce <vector205>:
.globl vector205
vector205:
  pushl $0
c01025ce:	6a 00                	push   $0x0
  pushl $205
c01025d0:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01025d5:	e9 58 02 00 00       	jmp    c0102832 <__alltraps>

c01025da <vector206>:
.globl vector206
vector206:
  pushl $0
c01025da:	6a 00                	push   $0x0
  pushl $206
c01025dc:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01025e1:	e9 4c 02 00 00       	jmp    c0102832 <__alltraps>

c01025e6 <vector207>:
.globl vector207
vector207:
  pushl $0
c01025e6:	6a 00                	push   $0x0
  pushl $207
c01025e8:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01025ed:	e9 40 02 00 00       	jmp    c0102832 <__alltraps>

c01025f2 <vector208>:
.globl vector208
vector208:
  pushl $0
c01025f2:	6a 00                	push   $0x0
  pushl $208
c01025f4:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01025f9:	e9 34 02 00 00       	jmp    c0102832 <__alltraps>

c01025fe <vector209>:
.globl vector209
vector209:
  pushl $0
c01025fe:	6a 00                	push   $0x0
  pushl $209
c0102600:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102605:	e9 28 02 00 00       	jmp    c0102832 <__alltraps>

c010260a <vector210>:
.globl vector210
vector210:
  pushl $0
c010260a:	6a 00                	push   $0x0
  pushl $210
c010260c:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102611:	e9 1c 02 00 00       	jmp    c0102832 <__alltraps>

c0102616 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102616:	6a 00                	push   $0x0
  pushl $211
c0102618:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010261d:	e9 10 02 00 00       	jmp    c0102832 <__alltraps>

c0102622 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102622:	6a 00                	push   $0x0
  pushl $212
c0102624:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102629:	e9 04 02 00 00       	jmp    c0102832 <__alltraps>

c010262e <vector213>:
.globl vector213
vector213:
  pushl $0
c010262e:	6a 00                	push   $0x0
  pushl $213
c0102630:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102635:	e9 f8 01 00 00       	jmp    c0102832 <__alltraps>

c010263a <vector214>:
.globl vector214
vector214:
  pushl $0
c010263a:	6a 00                	push   $0x0
  pushl $214
c010263c:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102641:	e9 ec 01 00 00       	jmp    c0102832 <__alltraps>

c0102646 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102646:	6a 00                	push   $0x0
  pushl $215
c0102648:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010264d:	e9 e0 01 00 00       	jmp    c0102832 <__alltraps>

c0102652 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102652:	6a 00                	push   $0x0
  pushl $216
c0102654:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102659:	e9 d4 01 00 00       	jmp    c0102832 <__alltraps>

c010265e <vector217>:
.globl vector217
vector217:
  pushl $0
c010265e:	6a 00                	push   $0x0
  pushl $217
c0102660:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102665:	e9 c8 01 00 00       	jmp    c0102832 <__alltraps>

c010266a <vector218>:
.globl vector218
vector218:
  pushl $0
c010266a:	6a 00                	push   $0x0
  pushl $218
c010266c:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102671:	e9 bc 01 00 00       	jmp    c0102832 <__alltraps>

c0102676 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102676:	6a 00                	push   $0x0
  pushl $219
c0102678:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010267d:	e9 b0 01 00 00       	jmp    c0102832 <__alltraps>

c0102682 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102682:	6a 00                	push   $0x0
  pushl $220
c0102684:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102689:	e9 a4 01 00 00       	jmp    c0102832 <__alltraps>

c010268e <vector221>:
.globl vector221
vector221:
  pushl $0
c010268e:	6a 00                	push   $0x0
  pushl $221
c0102690:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102695:	e9 98 01 00 00       	jmp    c0102832 <__alltraps>

c010269a <vector222>:
.globl vector222
vector222:
  pushl $0
c010269a:	6a 00                	push   $0x0
  pushl $222
c010269c:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01026a1:	e9 8c 01 00 00       	jmp    c0102832 <__alltraps>

c01026a6 <vector223>:
.globl vector223
vector223:
  pushl $0
c01026a6:	6a 00                	push   $0x0
  pushl $223
c01026a8:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01026ad:	e9 80 01 00 00       	jmp    c0102832 <__alltraps>

c01026b2 <vector224>:
.globl vector224
vector224:
  pushl $0
c01026b2:	6a 00                	push   $0x0
  pushl $224
c01026b4:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01026b9:	e9 74 01 00 00       	jmp    c0102832 <__alltraps>

c01026be <vector225>:
.globl vector225
vector225:
  pushl $0
c01026be:	6a 00                	push   $0x0
  pushl $225
c01026c0:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01026c5:	e9 68 01 00 00       	jmp    c0102832 <__alltraps>

c01026ca <vector226>:
.globl vector226
vector226:
  pushl $0
c01026ca:	6a 00                	push   $0x0
  pushl $226
c01026cc:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01026d1:	e9 5c 01 00 00       	jmp    c0102832 <__alltraps>

c01026d6 <vector227>:
.globl vector227
vector227:
  pushl $0
c01026d6:	6a 00                	push   $0x0
  pushl $227
c01026d8:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01026dd:	e9 50 01 00 00       	jmp    c0102832 <__alltraps>

c01026e2 <vector228>:
.globl vector228
vector228:
  pushl $0
c01026e2:	6a 00                	push   $0x0
  pushl $228
c01026e4:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01026e9:	e9 44 01 00 00       	jmp    c0102832 <__alltraps>

c01026ee <vector229>:
.globl vector229
vector229:
  pushl $0
c01026ee:	6a 00                	push   $0x0
  pushl $229
c01026f0:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01026f5:	e9 38 01 00 00       	jmp    c0102832 <__alltraps>

c01026fa <vector230>:
.globl vector230
vector230:
  pushl $0
c01026fa:	6a 00                	push   $0x0
  pushl $230
c01026fc:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102701:	e9 2c 01 00 00       	jmp    c0102832 <__alltraps>

c0102706 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102706:	6a 00                	push   $0x0
  pushl $231
c0102708:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010270d:	e9 20 01 00 00       	jmp    c0102832 <__alltraps>

c0102712 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102712:	6a 00                	push   $0x0
  pushl $232
c0102714:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102719:	e9 14 01 00 00       	jmp    c0102832 <__alltraps>

c010271e <vector233>:
.globl vector233
vector233:
  pushl $0
c010271e:	6a 00                	push   $0x0
  pushl $233
c0102720:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102725:	e9 08 01 00 00       	jmp    c0102832 <__alltraps>

c010272a <vector234>:
.globl vector234
vector234:
  pushl $0
c010272a:	6a 00                	push   $0x0
  pushl $234
c010272c:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102731:	e9 fc 00 00 00       	jmp    c0102832 <__alltraps>

c0102736 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102736:	6a 00                	push   $0x0
  pushl $235
c0102738:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010273d:	e9 f0 00 00 00       	jmp    c0102832 <__alltraps>

c0102742 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102742:	6a 00                	push   $0x0
  pushl $236
c0102744:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102749:	e9 e4 00 00 00       	jmp    c0102832 <__alltraps>

c010274e <vector237>:
.globl vector237
vector237:
  pushl $0
c010274e:	6a 00                	push   $0x0
  pushl $237
c0102750:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102755:	e9 d8 00 00 00       	jmp    c0102832 <__alltraps>

c010275a <vector238>:
.globl vector238
vector238:
  pushl $0
c010275a:	6a 00                	push   $0x0
  pushl $238
c010275c:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102761:	e9 cc 00 00 00       	jmp    c0102832 <__alltraps>

c0102766 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102766:	6a 00                	push   $0x0
  pushl $239
c0102768:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010276d:	e9 c0 00 00 00       	jmp    c0102832 <__alltraps>

c0102772 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102772:	6a 00                	push   $0x0
  pushl $240
c0102774:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102779:	e9 b4 00 00 00       	jmp    c0102832 <__alltraps>

c010277e <vector241>:
.globl vector241
vector241:
  pushl $0
c010277e:	6a 00                	push   $0x0
  pushl $241
c0102780:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102785:	e9 a8 00 00 00       	jmp    c0102832 <__alltraps>

c010278a <vector242>:
.globl vector242
vector242:
  pushl $0
c010278a:	6a 00                	push   $0x0
  pushl $242
c010278c:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102791:	e9 9c 00 00 00       	jmp    c0102832 <__alltraps>

c0102796 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102796:	6a 00                	push   $0x0
  pushl $243
c0102798:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010279d:	e9 90 00 00 00       	jmp    c0102832 <__alltraps>

c01027a2 <vector244>:
.globl vector244
vector244:
  pushl $0
c01027a2:	6a 00                	push   $0x0
  pushl $244
c01027a4:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01027a9:	e9 84 00 00 00       	jmp    c0102832 <__alltraps>

c01027ae <vector245>:
.globl vector245
vector245:
  pushl $0
c01027ae:	6a 00                	push   $0x0
  pushl $245
c01027b0:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01027b5:	e9 78 00 00 00       	jmp    c0102832 <__alltraps>

c01027ba <vector246>:
.globl vector246
vector246:
  pushl $0
c01027ba:	6a 00                	push   $0x0
  pushl $246
c01027bc:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01027c1:	e9 6c 00 00 00       	jmp    c0102832 <__alltraps>

c01027c6 <vector247>:
.globl vector247
vector247:
  pushl $0
c01027c6:	6a 00                	push   $0x0
  pushl $247
c01027c8:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01027cd:	e9 60 00 00 00       	jmp    c0102832 <__alltraps>

c01027d2 <vector248>:
.globl vector248
vector248:
  pushl $0
c01027d2:	6a 00                	push   $0x0
  pushl $248
c01027d4:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01027d9:	e9 54 00 00 00       	jmp    c0102832 <__alltraps>

c01027de <vector249>:
.globl vector249
vector249:
  pushl $0
c01027de:	6a 00                	push   $0x0
  pushl $249
c01027e0:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01027e5:	e9 48 00 00 00       	jmp    c0102832 <__alltraps>

c01027ea <vector250>:
.globl vector250
vector250:
  pushl $0
c01027ea:	6a 00                	push   $0x0
  pushl $250
c01027ec:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01027f1:	e9 3c 00 00 00       	jmp    c0102832 <__alltraps>

c01027f6 <vector251>:
.globl vector251
vector251:
  pushl $0
c01027f6:	6a 00                	push   $0x0
  pushl $251
c01027f8:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01027fd:	e9 30 00 00 00       	jmp    c0102832 <__alltraps>

c0102802 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102802:	6a 00                	push   $0x0
  pushl $252
c0102804:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102809:	e9 24 00 00 00       	jmp    c0102832 <__alltraps>

c010280e <vector253>:
.globl vector253
vector253:
  pushl $0
c010280e:	6a 00                	push   $0x0
  pushl $253
c0102810:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102815:	e9 18 00 00 00       	jmp    c0102832 <__alltraps>

c010281a <vector254>:
.globl vector254
vector254:
  pushl $0
c010281a:	6a 00                	push   $0x0
  pushl $254
c010281c:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102821:	e9 0c 00 00 00       	jmp    c0102832 <__alltraps>

c0102826 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102826:	6a 00                	push   $0x0
  pushl $255
c0102828:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010282d:	e9 00 00 00 00       	jmp    c0102832 <__alltraps>

c0102832 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102832:	1e                   	push   %ds
    pushl %es
c0102833:	06                   	push   %es
    pushl %fs
c0102834:	0f a0                	push   %fs
    pushl %gs
c0102836:	0f a8                	push   %gs
    pushal
c0102838:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102839:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010283e:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102840:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102842:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102843:	e8 63 f5 ff ff       	call   c0101dab <trap>

    # pop the pushed stack pointer
    popl %esp
c0102848:	5c                   	pop    %esp

c0102849 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102849:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c010284a:	0f a9                	pop    %gs
    popl %fs
c010284c:	0f a1                	pop    %fs
    popl %es
c010284e:	07                   	pop    %es
    popl %ds
c010284f:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102850:	83 c4 08             	add    $0x8,%esp
    iret
c0102853:	cf                   	iret   

c0102854 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102854:	55                   	push   %ebp
c0102855:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102857:	8b 45 08             	mov    0x8(%ebp),%eax
c010285a:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102860:	29 d0                	sub    %edx,%eax
c0102862:	c1 f8 02             	sar    $0x2,%eax
c0102865:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010286b:	5d                   	pop    %ebp
c010286c:	c3                   	ret    

c010286d <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010286d:	55                   	push   %ebp
c010286e:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0102870:	ff 75 08             	pushl  0x8(%ebp)
c0102873:	e8 dc ff ff ff       	call   c0102854 <page2ppn>
c0102878:	83 c4 04             	add    $0x4,%esp
c010287b:	c1 e0 0c             	shl    $0xc,%eax
}
c010287e:	c9                   	leave  
c010287f:	c3                   	ret    

c0102880 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0102880:	55                   	push   %ebp
c0102881:	89 e5                	mov    %esp,%ebp
c0102883:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c0102886:	8b 45 08             	mov    0x8(%ebp),%eax
c0102889:	c1 e8 0c             	shr    $0xc,%eax
c010288c:	89 c2                	mov    %eax,%edx
c010288e:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0102893:	39 c2                	cmp    %eax,%edx
c0102895:	72 14                	jb     c01028ab <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0102897:	83 ec 04             	sub    $0x4,%esp
c010289a:	68 90 62 10 c0       	push   $0xc0106290
c010289f:	6a 5a                	push   $0x5a
c01028a1:	68 af 62 10 c0       	push   $0xc01062af
c01028a6:	e8 22 db ff ff       	call   c01003cd <__panic>
    }
    return &pages[PPN(pa)];
c01028ab:	8b 0d 58 89 11 c0    	mov    0xc0118958,%ecx
c01028b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01028b4:	c1 e8 0c             	shr    $0xc,%eax
c01028b7:	89 c2                	mov    %eax,%edx
c01028b9:	89 d0                	mov    %edx,%eax
c01028bb:	c1 e0 02             	shl    $0x2,%eax
c01028be:	01 d0                	add    %edx,%eax
c01028c0:	c1 e0 02             	shl    $0x2,%eax
c01028c3:	01 c8                	add    %ecx,%eax
}
c01028c5:	c9                   	leave  
c01028c6:	c3                   	ret    

c01028c7 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01028c7:	55                   	push   %ebp
c01028c8:	89 e5                	mov    %esp,%ebp
c01028ca:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c01028cd:	ff 75 08             	pushl  0x8(%ebp)
c01028d0:	e8 98 ff ff ff       	call   c010286d <page2pa>
c01028d5:	83 c4 04             	add    $0x4,%esp
c01028d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028de:	c1 e8 0c             	shr    $0xc,%eax
c01028e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01028e4:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01028e9:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01028ec:	72 14                	jb     c0102902 <page2kva+0x3b>
c01028ee:	ff 75 f4             	pushl  -0xc(%ebp)
c01028f1:	68 c0 62 10 c0       	push   $0xc01062c0
c01028f6:	6a 61                	push   $0x61
c01028f8:	68 af 62 10 c0       	push   $0xc01062af
c01028fd:	e8 cb da ff ff       	call   c01003cd <__panic>
c0102902:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102905:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010290a:	c9                   	leave  
c010290b:	c3                   	ret    

c010290c <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c010290c:	55                   	push   %ebp
c010290d:	89 e5                	mov    %esp,%ebp
c010290f:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c0102912:	8b 45 08             	mov    0x8(%ebp),%eax
c0102915:	83 e0 01             	and    $0x1,%eax
c0102918:	85 c0                	test   %eax,%eax
c010291a:	75 14                	jne    c0102930 <pte2page+0x24>
        panic("pte2page called with invalid pte");
c010291c:	83 ec 04             	sub    $0x4,%esp
c010291f:	68 e4 62 10 c0       	push   $0xc01062e4
c0102924:	6a 6c                	push   $0x6c
c0102926:	68 af 62 10 c0       	push   $0xc01062af
c010292b:	e8 9d da ff ff       	call   c01003cd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102930:	8b 45 08             	mov    0x8(%ebp),%eax
c0102933:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102938:	83 ec 0c             	sub    $0xc,%esp
c010293b:	50                   	push   %eax
c010293c:	e8 3f ff ff ff       	call   c0102880 <pa2page>
c0102941:	83 c4 10             	add    $0x10,%esp
}
c0102944:	c9                   	leave  
c0102945:	c3                   	ret    

c0102946 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102946:	55                   	push   %ebp
c0102947:	89 e5                	mov    %esp,%ebp
c0102949:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c010294c:	8b 45 08             	mov    0x8(%ebp),%eax
c010294f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102954:	83 ec 0c             	sub    $0xc,%esp
c0102957:	50                   	push   %eax
c0102958:	e8 23 ff ff ff       	call   c0102880 <pa2page>
c010295d:	83 c4 10             	add    $0x10,%esp
}
c0102960:	c9                   	leave  
c0102961:	c3                   	ret    

c0102962 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102962:	55                   	push   %ebp
c0102963:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102965:	8b 45 08             	mov    0x8(%ebp),%eax
c0102968:	8b 00                	mov    (%eax),%eax
}
c010296a:	5d                   	pop    %ebp
c010296b:	c3                   	ret    

c010296c <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
c010296c:	55                   	push   %ebp
c010296d:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c010296f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102972:	8b 00                	mov    (%eax),%eax
c0102974:	8d 50 01             	lea    0x1(%eax),%edx
c0102977:	8b 45 08             	mov    0x8(%ebp),%eax
c010297a:	89 10                	mov    %edx,(%eax)
    return page->ref;
c010297c:	8b 45 08             	mov    0x8(%ebp),%eax
c010297f:	8b 00                	mov    (%eax),%eax
}
c0102981:	5d                   	pop    %ebp
c0102982:	c3                   	ret    

c0102983 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102983:	55                   	push   %ebp
c0102984:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102986:	8b 45 08             	mov    0x8(%ebp),%eax
c0102989:	8b 00                	mov    (%eax),%eax
c010298b:	8d 50 ff             	lea    -0x1(%eax),%edx
c010298e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102991:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102993:	8b 45 08             	mov    0x8(%ebp),%eax
c0102996:	8b 00                	mov    (%eax),%eax
}
c0102998:	5d                   	pop    %ebp
c0102999:	c3                   	ret    

c010299a <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c010299a:	55                   	push   %ebp
c010299b:	89 e5                	mov    %esp,%ebp
c010299d:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01029a0:	9c                   	pushf  
c01029a1:	58                   	pop    %eax
c01029a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01029a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01029a8:	25 00 02 00 00       	and    $0x200,%eax
c01029ad:	85 c0                	test   %eax,%eax
c01029af:	74 0c                	je     c01029bd <__intr_save+0x23>
        intr_disable();
c01029b1:	e8 a9 ee ff ff       	call   c010185f <intr_disable>
        return 1;
c01029b6:	b8 01 00 00 00       	mov    $0x1,%eax
c01029bb:	eb 05                	jmp    c01029c2 <__intr_save+0x28>
    }
    return 0;
c01029bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01029c2:	c9                   	leave  
c01029c3:	c3                   	ret    

c01029c4 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01029c4:	55                   	push   %ebp
c01029c5:	89 e5                	mov    %esp,%ebp
c01029c7:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01029ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01029ce:	74 05                	je     c01029d5 <__intr_restore+0x11>
        intr_enable();
c01029d0:	e8 83 ee ff ff       	call   c0101858 <intr_enable>
    }
}
c01029d5:	90                   	nop
c01029d6:	c9                   	leave  
c01029d7:	c3                   	ret    

c01029d8 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c01029d8:	55                   	push   %ebp
c01029d9:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c01029db:	8b 45 08             	mov    0x8(%ebp),%eax
c01029de:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c01029e1:	b8 23 00 00 00       	mov    $0x23,%eax
c01029e6:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c01029e8:	b8 23 00 00 00       	mov    $0x23,%eax
c01029ed:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c01029ef:	b8 10 00 00 00       	mov    $0x10,%eax
c01029f4:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c01029f6:	b8 10 00 00 00       	mov    $0x10,%eax
c01029fb:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c01029fd:	b8 10 00 00 00       	mov    $0x10,%eax
c0102a02:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102a04:	ea 0b 2a 10 c0 08 00 	ljmp   $0x8,$0xc0102a0b
}
c0102a0b:	90                   	nop
c0102a0c:	5d                   	pop    %ebp
c0102a0d:	c3                   	ret    

c0102a0e <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102a0e:	55                   	push   %ebp
c0102a0f:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102a11:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a14:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0102a19:	90                   	nop
c0102a1a:	5d                   	pop    %ebp
c0102a1b:	c3                   	ret    

c0102a1c <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102a1c:	55                   	push   %ebp
c0102a1d:	89 e5                	mov    %esp,%ebp
c0102a1f:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102a22:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0102a27:	50                   	push   %eax
c0102a28:	e8 e1 ff ff ff       	call   c0102a0e <load_esp0>
c0102a2d:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c0102a30:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0102a37:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102a39:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0102a40:	68 00 
c0102a42:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102a47:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0102a4d:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102a52:	c1 e8 10             	shr    $0x10,%eax
c0102a55:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0102a5a:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102a61:	83 e0 f0             	and    $0xfffffff0,%eax
c0102a64:	83 c8 09             	or     $0x9,%eax
c0102a67:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102a6c:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102a73:	83 e0 ef             	and    $0xffffffef,%eax
c0102a76:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102a7b:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102a82:	83 e0 9f             	and    $0xffffff9f,%eax
c0102a85:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102a8a:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102a91:	83 c8 80             	or     $0xffffff80,%eax
c0102a94:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102a99:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102aa0:	83 e0 f0             	and    $0xfffffff0,%eax
c0102aa3:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102aa8:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102aaf:	83 e0 ef             	and    $0xffffffef,%eax
c0102ab2:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102ab7:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102abe:	83 e0 df             	and    $0xffffffdf,%eax
c0102ac1:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102ac6:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102acd:	83 c8 40             	or     $0x40,%eax
c0102ad0:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102ad5:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102adc:	83 e0 7f             	and    $0x7f,%eax
c0102adf:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102ae4:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102ae9:	c1 e8 18             	shr    $0x18,%eax
c0102aec:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102af1:	68 30 7a 11 c0       	push   $0xc0117a30
c0102af6:	e8 dd fe ff ff       	call   c01029d8 <lgdt>
c0102afb:	83 c4 04             	add    $0x4,%esp
c0102afe:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102b04:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102b08:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0102b0b:	90                   	nop
c0102b0c:	c9                   	leave  
c0102b0d:	c3                   	ret    

c0102b0e <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102b0e:	55                   	push   %ebp
c0102b0f:	89 e5                	mov    %esp,%ebp
c0102b11:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c0102b14:	c7 05 50 89 11 c0 a4 	movl   $0xc0106ca4,0xc0118950
c0102b1b:	6c 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102b1e:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102b23:	8b 00                	mov    (%eax),%eax
c0102b25:	83 ec 08             	sub    $0x8,%esp
c0102b28:	50                   	push   %eax
c0102b29:	68 10 63 10 c0       	push   $0xc0106310
c0102b2e:	e8 34 d7 ff ff       	call   c0100267 <cprintf>
c0102b33:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c0102b36:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102b3b:	8b 40 04             	mov    0x4(%eax),%eax
c0102b3e:	ff d0                	call   *%eax
}
c0102b40:	90                   	nop
c0102b41:	c9                   	leave  
c0102b42:	c3                   	ret    

c0102b43 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102b43:	55                   	push   %ebp
c0102b44:	89 e5                	mov    %esp,%ebp
c0102b46:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c0102b49:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102b4e:	8b 40 08             	mov    0x8(%eax),%eax
c0102b51:	83 ec 08             	sub    $0x8,%esp
c0102b54:	ff 75 0c             	pushl  0xc(%ebp)
c0102b57:	ff 75 08             	pushl  0x8(%ebp)
c0102b5a:	ff d0                	call   *%eax
c0102b5c:	83 c4 10             	add    $0x10,%esp
}
c0102b5f:	90                   	nop
c0102b60:	c9                   	leave  
c0102b61:	c3                   	ret    

c0102b62 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102b62:	55                   	push   %ebp
c0102b63:	89 e5                	mov    %esp,%ebp
c0102b65:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c0102b68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102b6f:	e8 26 fe ff ff       	call   c010299a <__intr_save>
c0102b74:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102b77:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102b7c:	8b 40 0c             	mov    0xc(%eax),%eax
c0102b7f:	83 ec 0c             	sub    $0xc,%esp
c0102b82:	ff 75 08             	pushl  0x8(%ebp)
c0102b85:	ff d0                	call   *%eax
c0102b87:	83 c4 10             	add    $0x10,%esp
c0102b8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102b8d:	83 ec 0c             	sub    $0xc,%esp
c0102b90:	ff 75 f0             	pushl  -0x10(%ebp)
c0102b93:	e8 2c fe ff ff       	call   c01029c4 <__intr_restore>
c0102b98:	83 c4 10             	add    $0x10,%esp
    return page;
c0102b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102b9e:	c9                   	leave  
c0102b9f:	c3                   	ret    

c0102ba0 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102ba0:	55                   	push   %ebp
c0102ba1:	89 e5                	mov    %esp,%ebp
c0102ba3:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102ba6:	e8 ef fd ff ff       	call   c010299a <__intr_save>
c0102bab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102bae:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102bb3:	8b 40 10             	mov    0x10(%eax),%eax
c0102bb6:	83 ec 08             	sub    $0x8,%esp
c0102bb9:	ff 75 0c             	pushl  0xc(%ebp)
c0102bbc:	ff 75 08             	pushl  0x8(%ebp)
c0102bbf:	ff d0                	call   *%eax
c0102bc1:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0102bc4:	83 ec 0c             	sub    $0xc,%esp
c0102bc7:	ff 75 f4             	pushl  -0xc(%ebp)
c0102bca:	e8 f5 fd ff ff       	call   c01029c4 <__intr_restore>
c0102bcf:	83 c4 10             	add    $0x10,%esp
}
c0102bd2:	90                   	nop
c0102bd3:	c9                   	leave  
c0102bd4:	c3                   	ret    

c0102bd5 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102bd5:	55                   	push   %ebp
c0102bd6:	89 e5                	mov    %esp,%ebp
c0102bd8:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102bdb:	e8 ba fd ff ff       	call   c010299a <__intr_save>
c0102be0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102be3:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102be8:	8b 40 14             	mov    0x14(%eax),%eax
c0102beb:	ff d0                	call   *%eax
c0102bed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102bf0:	83 ec 0c             	sub    $0xc,%esp
c0102bf3:	ff 75 f4             	pushl  -0xc(%ebp)
c0102bf6:	e8 c9 fd ff ff       	call   c01029c4 <__intr_restore>
c0102bfb:	83 c4 10             	add    $0x10,%esp
    return ret;
c0102bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102c01:	c9                   	leave  
c0102c02:	c3                   	ret    

c0102c03 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102c03:	55                   	push   %ebp
c0102c04:	89 e5                	mov    %esp,%ebp
c0102c06:	57                   	push   %edi
c0102c07:	56                   	push   %esi
c0102c08:	53                   	push   %ebx
c0102c09:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102c0c:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102c13:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102c1a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102c21:	83 ec 0c             	sub    $0xc,%esp
c0102c24:	68 27 63 10 c0       	push   $0xc0106327
c0102c29:	e8 39 d6 ff ff       	call   c0100267 <cprintf>
c0102c2e:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102c31:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102c38:	e9 fc 00 00 00       	jmp    c0102d39 <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102c3d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102c40:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c43:	89 d0                	mov    %edx,%eax
c0102c45:	c1 e0 02             	shl    $0x2,%eax
c0102c48:	01 d0                	add    %edx,%eax
c0102c4a:	c1 e0 02             	shl    $0x2,%eax
c0102c4d:	01 c8                	add    %ecx,%eax
c0102c4f:	8b 50 08             	mov    0x8(%eax),%edx
c0102c52:	8b 40 04             	mov    0x4(%eax),%eax
c0102c55:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102c58:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0102c5b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102c5e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c61:	89 d0                	mov    %edx,%eax
c0102c63:	c1 e0 02             	shl    $0x2,%eax
c0102c66:	01 d0                	add    %edx,%eax
c0102c68:	c1 e0 02             	shl    $0x2,%eax
c0102c6b:	01 c8                	add    %ecx,%eax
c0102c6d:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102c70:	8b 58 10             	mov    0x10(%eax),%ebx
c0102c73:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102c76:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102c79:	01 c8                	add    %ecx,%eax
c0102c7b:	11 da                	adc    %ebx,%edx
c0102c7d:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0102c80:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102c83:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102c86:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c89:	89 d0                	mov    %edx,%eax
c0102c8b:	c1 e0 02             	shl    $0x2,%eax
c0102c8e:	01 d0                	add    %edx,%eax
c0102c90:	c1 e0 02             	shl    $0x2,%eax
c0102c93:	01 c8                	add    %ecx,%eax
c0102c95:	83 c0 14             	add    $0x14,%eax
c0102c98:	8b 00                	mov    (%eax),%eax
c0102c9a:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102c9d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102ca0:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102ca3:	83 c0 ff             	add    $0xffffffff,%eax
c0102ca6:	83 d2 ff             	adc    $0xffffffff,%edx
c0102ca9:	89 c1                	mov    %eax,%ecx
c0102cab:	89 d3                	mov    %edx,%ebx
c0102cad:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102cb0:	89 55 80             	mov    %edx,-0x80(%ebp)
c0102cb3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102cb6:	89 d0                	mov    %edx,%eax
c0102cb8:	c1 e0 02             	shl    $0x2,%eax
c0102cbb:	01 d0                	add    %edx,%eax
c0102cbd:	c1 e0 02             	shl    $0x2,%eax
c0102cc0:	03 45 80             	add    -0x80(%ebp),%eax
c0102cc3:	8b 50 10             	mov    0x10(%eax),%edx
c0102cc6:	8b 40 0c             	mov    0xc(%eax),%eax
c0102cc9:	ff 75 84             	pushl  -0x7c(%ebp)
c0102ccc:	53                   	push   %ebx
c0102ccd:	51                   	push   %ecx
c0102cce:	ff 75 bc             	pushl  -0x44(%ebp)
c0102cd1:	ff 75 b8             	pushl  -0x48(%ebp)
c0102cd4:	52                   	push   %edx
c0102cd5:	50                   	push   %eax
c0102cd6:	68 34 63 10 c0       	push   $0xc0106334
c0102cdb:	e8 87 d5 ff ff       	call   c0100267 <cprintf>
c0102ce0:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102ce3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102ce6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ce9:	89 d0                	mov    %edx,%eax
c0102ceb:	c1 e0 02             	shl    $0x2,%eax
c0102cee:	01 d0                	add    %edx,%eax
c0102cf0:	c1 e0 02             	shl    $0x2,%eax
c0102cf3:	01 c8                	add    %ecx,%eax
c0102cf5:	83 c0 14             	add    $0x14,%eax
c0102cf8:	8b 00                	mov    (%eax),%eax
c0102cfa:	83 f8 01             	cmp    $0x1,%eax
c0102cfd:	75 36                	jne    c0102d35 <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
c0102cff:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102d02:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102d05:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102d08:	77 2b                	ja     c0102d35 <page_init+0x132>
c0102d0a:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102d0d:	72 05                	jb     c0102d14 <page_init+0x111>
c0102d0f:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0102d12:	73 21                	jae    c0102d35 <page_init+0x132>
c0102d14:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102d18:	77 1b                	ja     c0102d35 <page_init+0x132>
c0102d1a:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102d1e:	72 09                	jb     c0102d29 <page_init+0x126>
c0102d20:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0102d27:	77 0c                	ja     c0102d35 <page_init+0x132>
                maxpa = end;
c0102d29:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102d2c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102d2f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102d32:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102d35:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102d39:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d3c:	8b 00                	mov    (%eax),%eax
c0102d3e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0102d41:	0f 8f f6 fe ff ff    	jg     c0102c3d <page_init+0x3a>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102d47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102d4b:	72 1d                	jb     c0102d6a <page_init+0x167>
c0102d4d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102d51:	77 09                	ja     c0102d5c <page_init+0x159>
c0102d53:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0102d5a:	76 0e                	jbe    c0102d6a <page_init+0x167>
        maxpa = KMEMSIZE;
c0102d5c:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102d63:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0102d6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102d6d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102d70:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102d74:	c1 ea 0c             	shr    $0xc,%edx
c0102d77:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102d7c:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0102d83:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0102d88:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102d8b:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102d8e:	01 d0                	add    %edx,%eax
c0102d90:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0102d93:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102d96:	ba 00 00 00 00       	mov    $0x0,%edx
c0102d9b:	f7 75 ac             	divl   -0x54(%ebp)
c0102d9e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102da1:	29 d0                	sub    %edx,%eax
c0102da3:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    for (i = 0; i < npage; i ++) {
c0102da8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102daf:	eb 2f                	jmp    c0102de0 <page_init+0x1dd>
        SetPageReserved(pages + i);
c0102db1:	8b 0d 58 89 11 c0    	mov    0xc0118958,%ecx
c0102db7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102dba:	89 d0                	mov    %edx,%eax
c0102dbc:	c1 e0 02             	shl    $0x2,%eax
c0102dbf:	01 d0                	add    %edx,%eax
c0102dc1:	c1 e0 02             	shl    $0x2,%eax
c0102dc4:	01 c8                	add    %ecx,%eax
c0102dc6:	83 c0 04             	add    $0x4,%eax
c0102dc9:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0102dd0:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102dd3:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102dd6:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102dd9:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0102ddc:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102de0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102de3:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0102de8:	39 c2                	cmp    %eax,%edx
c0102dea:	72 c5                	jb     c0102db1 <page_init+0x1ae>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0102dec:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102df2:	89 d0                	mov    %edx,%eax
c0102df4:	c1 e0 02             	shl    $0x2,%eax
c0102df7:	01 d0                	add    %edx,%eax
c0102df9:	c1 e0 02             	shl    $0x2,%eax
c0102dfc:	89 c2                	mov    %eax,%edx
c0102dfe:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102e03:	01 d0                	add    %edx,%eax
c0102e05:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0102e08:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0102e0f:	77 17                	ja     c0102e28 <page_init+0x225>
c0102e11:	ff 75 a4             	pushl  -0x5c(%ebp)
c0102e14:	68 64 63 10 c0       	push   $0xc0106364
c0102e19:	68 db 00 00 00       	push   $0xdb
c0102e1e:	68 88 63 10 c0       	push   $0xc0106388
c0102e23:	e8 a5 d5 ff ff       	call   c01003cd <__panic>
c0102e28:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102e2b:	05 00 00 00 40       	add    $0x40000000,%eax
c0102e30:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0102e33:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102e3a:	e9 69 01 00 00       	jmp    c0102fa8 <page_init+0x3a5>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102e3f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e42:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e45:	89 d0                	mov    %edx,%eax
c0102e47:	c1 e0 02             	shl    $0x2,%eax
c0102e4a:	01 d0                	add    %edx,%eax
c0102e4c:	c1 e0 02             	shl    $0x2,%eax
c0102e4f:	01 c8                	add    %ecx,%eax
c0102e51:	8b 50 08             	mov    0x8(%eax),%edx
c0102e54:	8b 40 04             	mov    0x4(%eax),%eax
c0102e57:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102e5a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102e5d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e60:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e63:	89 d0                	mov    %edx,%eax
c0102e65:	c1 e0 02             	shl    $0x2,%eax
c0102e68:	01 d0                	add    %edx,%eax
c0102e6a:	c1 e0 02             	shl    $0x2,%eax
c0102e6d:	01 c8                	add    %ecx,%eax
c0102e6f:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102e72:	8b 58 10             	mov    0x10(%eax),%ebx
c0102e75:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102e78:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102e7b:	01 c8                	add    %ecx,%eax
c0102e7d:	11 da                	adc    %ebx,%edx
c0102e7f:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102e82:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0102e85:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e88:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e8b:	89 d0                	mov    %edx,%eax
c0102e8d:	c1 e0 02             	shl    $0x2,%eax
c0102e90:	01 d0                	add    %edx,%eax
c0102e92:	c1 e0 02             	shl    $0x2,%eax
c0102e95:	01 c8                	add    %ecx,%eax
c0102e97:	83 c0 14             	add    $0x14,%eax
c0102e9a:	8b 00                	mov    (%eax),%eax
c0102e9c:	83 f8 01             	cmp    $0x1,%eax
c0102e9f:	0f 85 ff 00 00 00    	jne    c0102fa4 <page_init+0x3a1>
            if (begin < freemem) {
c0102ea5:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102ea8:	ba 00 00 00 00       	mov    $0x0,%edx
c0102ead:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0102eb0:	72 17                	jb     c0102ec9 <page_init+0x2c6>
c0102eb2:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0102eb5:	77 05                	ja     c0102ebc <page_init+0x2b9>
c0102eb7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0102eba:	76 0d                	jbe    c0102ec9 <page_init+0x2c6>
                begin = freemem;
c0102ebc:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102ebf:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102ec2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0102ec9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102ecd:	72 1d                	jb     c0102eec <page_init+0x2e9>
c0102ecf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102ed3:	77 09                	ja     c0102ede <page_init+0x2db>
c0102ed5:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0102edc:	76 0e                	jbe    c0102eec <page_init+0x2e9>
                end = KMEMSIZE;
c0102ede:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0102ee5:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0102eec:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102eef:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102ef2:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102ef5:	0f 87 a9 00 00 00    	ja     c0102fa4 <page_init+0x3a1>
c0102efb:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102efe:	72 09                	jb     c0102f09 <page_init+0x306>
c0102f00:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0102f03:	0f 83 9b 00 00 00    	jae    c0102fa4 <page_init+0x3a1>
                begin = ROUNDUP(begin, PGSIZE);
c0102f09:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0102f10:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102f13:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102f16:	01 d0                	add    %edx,%eax
c0102f18:	83 e8 01             	sub    $0x1,%eax
c0102f1b:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102f1e:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102f21:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f26:	f7 75 9c             	divl   -0x64(%ebp)
c0102f29:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102f2c:	29 d0                	sub    %edx,%eax
c0102f2e:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f33:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102f36:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0102f39:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102f3c:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102f3f:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102f42:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f47:	89 c3                	mov    %eax,%ebx
c0102f49:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0102f4f:	89 de                	mov    %ebx,%esi
c0102f51:	89 d0                	mov    %edx,%eax
c0102f53:	83 e0 00             	and    $0x0,%eax
c0102f56:	89 c7                	mov    %eax,%edi
c0102f58:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0102f5b:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0102f5e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102f61:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102f64:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f67:	77 3b                	ja     c0102fa4 <page_init+0x3a1>
c0102f69:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f6c:	72 05                	jb     c0102f73 <page_init+0x370>
c0102f6e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0102f71:	73 31                	jae    c0102fa4 <page_init+0x3a1>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0102f73:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102f76:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102f79:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0102f7c:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0102f7f:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102f83:	c1 ea 0c             	shr    $0xc,%edx
c0102f86:	89 c3                	mov    %eax,%ebx
c0102f88:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102f8b:	83 ec 0c             	sub    $0xc,%esp
c0102f8e:	50                   	push   %eax
c0102f8f:	e8 ec f8 ff ff       	call   c0102880 <pa2page>
c0102f94:	83 c4 10             	add    $0x10,%esp
c0102f97:	83 ec 08             	sub    $0x8,%esp
c0102f9a:	53                   	push   %ebx
c0102f9b:	50                   	push   %eax
c0102f9c:	e8 a2 fb ff ff       	call   c0102b43 <init_memmap>
c0102fa1:	83 c4 10             	add    $0x10,%esp
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0102fa4:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102fa8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102fab:	8b 00                	mov    (%eax),%eax
c0102fad:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0102fb0:	0f 8f 89 fe ff ff    	jg     c0102e3f <page_init+0x23c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0102fb6:	90                   	nop
c0102fb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0102fba:	5b                   	pop    %ebx
c0102fbb:	5e                   	pop    %esi
c0102fbc:	5f                   	pop    %edi
c0102fbd:	5d                   	pop    %ebp
c0102fbe:	c3                   	ret    

c0102fbf <enable_paging>:

static void
enable_paging(void) {
c0102fbf:	55                   	push   %ebp
c0102fc0:	89 e5                	mov    %esp,%ebp
c0102fc2:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0102fc5:	a1 54 89 11 c0       	mov    0xc0118954,%eax
c0102fca:	89 45 fc             	mov    %eax,-0x4(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0102fcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102fd0:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0102fd3:	0f 20 c0             	mov    %cr0,%eax
c0102fd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0102fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0102fdc:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0102fdf:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0102fe6:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
c0102fea:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102fed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0102ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ff3:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0102ff6:	90                   	nop
c0102ff7:	c9                   	leave  
c0102ff8:	c3                   	ret    

c0102ff9 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0102ff9:	55                   	push   %ebp
c0102ffa:	89 e5                	mov    %esp,%ebp
c0102ffc:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0102fff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103002:	33 45 14             	xor    0x14(%ebp),%eax
c0103005:	25 ff 0f 00 00       	and    $0xfff,%eax
c010300a:	85 c0                	test   %eax,%eax
c010300c:	74 19                	je     c0103027 <boot_map_segment+0x2e>
c010300e:	68 96 63 10 c0       	push   $0xc0106396
c0103013:	68 ad 63 10 c0       	push   $0xc01063ad
c0103018:	68 04 01 00 00       	push   $0x104
c010301d:	68 88 63 10 c0       	push   $0xc0106388
c0103022:	e8 a6 d3 ff ff       	call   c01003cd <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0103027:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c010302e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103031:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103036:	89 c2                	mov    %eax,%edx
c0103038:	8b 45 10             	mov    0x10(%ebp),%eax
c010303b:	01 c2                	add    %eax,%edx
c010303d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103040:	01 d0                	add    %edx,%eax
c0103042:	83 e8 01             	sub    $0x1,%eax
c0103045:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103048:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010304b:	ba 00 00 00 00       	mov    $0x0,%edx
c0103050:	f7 75 f0             	divl   -0x10(%ebp)
c0103053:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103056:	29 d0                	sub    %edx,%eax
c0103058:	c1 e8 0c             	shr    $0xc,%eax
c010305b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c010305e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103061:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103064:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103067:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010306c:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c010306f:	8b 45 14             	mov    0x14(%ebp),%eax
c0103072:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103075:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103078:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010307d:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103080:	eb 57                	jmp    c01030d9 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0103082:	83 ec 04             	sub    $0x4,%esp
c0103085:	6a 01                	push   $0x1
c0103087:	ff 75 0c             	pushl  0xc(%ebp)
c010308a:	ff 75 08             	pushl  0x8(%ebp)
c010308d:	e8 98 01 00 00       	call   c010322a <get_pte>
c0103092:	83 c4 10             	add    $0x10,%esp
c0103095:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0103098:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010309c:	75 19                	jne    c01030b7 <boot_map_segment+0xbe>
c010309e:	68 c2 63 10 c0       	push   $0xc01063c2
c01030a3:	68 ad 63 10 c0       	push   $0xc01063ad
c01030a8:	68 0a 01 00 00       	push   $0x10a
c01030ad:	68 88 63 10 c0       	push   $0xc0106388
c01030b2:	e8 16 d3 ff ff       	call   c01003cd <__panic>
        *ptep = pa | PTE_P | perm;
c01030b7:	8b 45 14             	mov    0x14(%ebp),%eax
c01030ba:	0b 45 18             	or     0x18(%ebp),%eax
c01030bd:	83 c8 01             	or     $0x1,%eax
c01030c0:	89 c2                	mov    %eax,%edx
c01030c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030c5:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01030c7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01030cb:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01030d2:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01030d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01030dd:	75 a3                	jne    c0103082 <boot_map_segment+0x89>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c01030df:	90                   	nop
c01030e0:	c9                   	leave  
c01030e1:	c3                   	ret    

c01030e2 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01030e2:	55                   	push   %ebp
c01030e3:	89 e5                	mov    %esp,%ebp
c01030e5:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c01030e8:	83 ec 0c             	sub    $0xc,%esp
c01030eb:	6a 01                	push   $0x1
c01030ed:	e8 70 fa ff ff       	call   c0102b62 <alloc_pages>
c01030f2:	83 c4 10             	add    $0x10,%esp
c01030f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01030f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01030fc:	75 17                	jne    c0103115 <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
c01030fe:	83 ec 04             	sub    $0x4,%esp
c0103101:	68 cf 63 10 c0       	push   $0xc01063cf
c0103106:	68 16 01 00 00       	push   $0x116
c010310b:	68 88 63 10 c0       	push   $0xc0106388
c0103110:	e8 b8 d2 ff ff       	call   c01003cd <__panic>
    }
    return page2kva(p);
c0103115:	83 ec 0c             	sub    $0xc,%esp
c0103118:	ff 75 f4             	pushl  -0xc(%ebp)
c010311b:	e8 a7 f7 ff ff       	call   c01028c7 <page2kva>
c0103120:	83 c4 10             	add    $0x10,%esp
}
c0103123:	c9                   	leave  
c0103124:	c3                   	ret    

c0103125 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0103125:	55                   	push   %ebp
c0103126:	89 e5                	mov    %esp,%ebp
c0103128:	83 ec 18             	sub    $0x18,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c010312b:	e8 de f9 ff ff       	call   c0102b0e <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0103130:	e8 ce fa ff ff       	call   c0102c03 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0103135:	e8 85 02 00 00       	call   c01033bf <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c010313a:	e8 a3 ff ff ff       	call   c01030e2 <boot_alloc_page>
c010313f:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c0103144:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103149:	83 ec 04             	sub    $0x4,%esp
c010314c:	68 00 10 00 00       	push   $0x1000
c0103151:	6a 00                	push   $0x0
c0103153:	50                   	push   %eax
c0103154:	e8 80 22 00 00       	call   c01053d9 <memset>
c0103159:	83 c4 10             	add    $0x10,%esp
    boot_cr3 = PADDR(boot_pgdir);
c010315c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103161:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103164:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010316b:	77 17                	ja     c0103184 <pmm_init+0x5f>
c010316d:	ff 75 f4             	pushl  -0xc(%ebp)
c0103170:	68 64 63 10 c0       	push   $0xc0106364
c0103175:	68 30 01 00 00       	push   $0x130
c010317a:	68 88 63 10 c0       	push   $0xc0106388
c010317f:	e8 49 d2 ff ff       	call   c01003cd <__panic>
c0103184:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103187:	05 00 00 00 40       	add    $0x40000000,%eax
c010318c:	a3 54 89 11 c0       	mov    %eax,0xc0118954

    check_pgdir();
c0103191:	e8 4c 02 00 00       	call   c01033e2 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0103196:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010319b:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01031a1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01031a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01031a9:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01031b0:	77 17                	ja     c01031c9 <pmm_init+0xa4>
c01031b2:	ff 75 f0             	pushl  -0x10(%ebp)
c01031b5:	68 64 63 10 c0       	push   $0xc0106364
c01031ba:	68 38 01 00 00       	push   $0x138
c01031bf:	68 88 63 10 c0       	push   $0xc0106388
c01031c4:	e8 04 d2 ff ff       	call   c01003cd <__panic>
c01031c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031cc:	05 00 00 00 40       	add    $0x40000000,%eax
c01031d1:	83 c8 03             	or     $0x3,%eax
c01031d4:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01031d6:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01031db:	83 ec 0c             	sub    $0xc,%esp
c01031de:	6a 02                	push   $0x2
c01031e0:	6a 00                	push   $0x0
c01031e2:	68 00 00 00 38       	push   $0x38000000
c01031e7:	68 00 00 00 c0       	push   $0xc0000000
c01031ec:	50                   	push   %eax
c01031ed:	e8 07 fe ff ff       	call   c0102ff9 <boot_map_segment>
c01031f2:	83 c4 20             	add    $0x20,%esp

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c01031f5:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01031fa:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c0103200:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0103206:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0103208:	e8 b2 fd ff ff       	call   c0102fbf <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010320d:	e8 0a f8 ff ff       	call   c0102a1c <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0103212:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103217:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c010321d:	e8 26 07 00 00       	call   c0103948 <check_boot_pgdir>

    print_pgdir();
c0103222:	e8 1c 0b 00 00       	call   c0103d43 <print_pgdir>

}
c0103227:	90                   	nop
c0103228:	c9                   	leave  
c0103229:	c3                   	ret    

c010322a <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010322a:	55                   	push   %ebp
c010322b:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c010322d:	90                   	nop
c010322e:	5d                   	pop    %ebp
c010322f:	c3                   	ret    

c0103230 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0103230:	55                   	push   %ebp
c0103231:	89 e5                	mov    %esp,%ebp
c0103233:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103236:	6a 00                	push   $0x0
c0103238:	ff 75 0c             	pushl  0xc(%ebp)
c010323b:	ff 75 08             	pushl  0x8(%ebp)
c010323e:	e8 e7 ff ff ff       	call   c010322a <get_pte>
c0103243:	83 c4 0c             	add    $0xc,%esp
c0103246:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0103249:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010324d:	74 08                	je     c0103257 <get_page+0x27>
        *ptep_store = ptep;
c010324f:	8b 45 10             	mov    0x10(%ebp),%eax
c0103252:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103255:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0103257:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010325b:	74 1f                	je     c010327c <get_page+0x4c>
c010325d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103260:	8b 00                	mov    (%eax),%eax
c0103262:	83 e0 01             	and    $0x1,%eax
c0103265:	85 c0                	test   %eax,%eax
c0103267:	74 13                	je     c010327c <get_page+0x4c>
        return pte2page(*ptep);
c0103269:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010326c:	8b 00                	mov    (%eax),%eax
c010326e:	83 ec 0c             	sub    $0xc,%esp
c0103271:	50                   	push   %eax
c0103272:	e8 95 f6 ff ff       	call   c010290c <pte2page>
c0103277:	83 c4 10             	add    $0x10,%esp
c010327a:	eb 05                	jmp    c0103281 <get_page+0x51>
    }
    return NULL;
c010327c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103281:	c9                   	leave  
c0103282:	c3                   	ret    

c0103283 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0103283:	55                   	push   %ebp
c0103284:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c0103286:	90                   	nop
c0103287:	5d                   	pop    %ebp
c0103288:	c3                   	ret    

c0103289 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0103289:	55                   	push   %ebp
c010328a:	89 e5                	mov    %esp,%ebp
c010328c:	83 ec 10             	sub    $0x10,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010328f:	6a 00                	push   $0x0
c0103291:	ff 75 0c             	pushl  0xc(%ebp)
c0103294:	ff 75 08             	pushl  0x8(%ebp)
c0103297:	e8 8e ff ff ff       	call   c010322a <get_pte>
c010329c:	83 c4 0c             	add    $0xc,%esp
c010329f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c01032a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01032a6:	74 11                	je     c01032b9 <page_remove+0x30>
        page_remove_pte(pgdir, la, ptep);
c01032a8:	ff 75 fc             	pushl  -0x4(%ebp)
c01032ab:	ff 75 0c             	pushl  0xc(%ebp)
c01032ae:	ff 75 08             	pushl  0x8(%ebp)
c01032b1:	e8 cd ff ff ff       	call   c0103283 <page_remove_pte>
c01032b6:	83 c4 0c             	add    $0xc,%esp
    }
}
c01032b9:	90                   	nop
c01032ba:	c9                   	leave  
c01032bb:	c3                   	ret    

c01032bc <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01032bc:	55                   	push   %ebp
c01032bd:	89 e5                	mov    %esp,%ebp
c01032bf:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01032c2:	6a 01                	push   $0x1
c01032c4:	ff 75 10             	pushl  0x10(%ebp)
c01032c7:	ff 75 08             	pushl  0x8(%ebp)
c01032ca:	e8 5b ff ff ff       	call   c010322a <get_pte>
c01032cf:	83 c4 0c             	add    $0xc,%esp
c01032d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01032d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01032d9:	75 0a                	jne    c01032e5 <page_insert+0x29>
        return -E_NO_MEM;
c01032db:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01032e0:	e9 88 00 00 00       	jmp    c010336d <page_insert+0xb1>
    }
    page_ref_inc(page);
c01032e5:	ff 75 0c             	pushl  0xc(%ebp)
c01032e8:	e8 7f f6 ff ff       	call   c010296c <page_ref_inc>
c01032ed:	83 c4 04             	add    $0x4,%esp
    if (*ptep & PTE_P) {
c01032f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032f3:	8b 00                	mov    (%eax),%eax
c01032f5:	83 e0 01             	and    $0x1,%eax
c01032f8:	85 c0                	test   %eax,%eax
c01032fa:	74 40                	je     c010333c <page_insert+0x80>
        struct Page *p = pte2page(*ptep);
c01032fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032ff:	8b 00                	mov    (%eax),%eax
c0103301:	83 ec 0c             	sub    $0xc,%esp
c0103304:	50                   	push   %eax
c0103305:	e8 02 f6 ff ff       	call   c010290c <pte2page>
c010330a:	83 c4 10             	add    $0x10,%esp
c010330d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0103310:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103313:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103316:	75 10                	jne    c0103328 <page_insert+0x6c>
            page_ref_dec(page);
c0103318:	83 ec 0c             	sub    $0xc,%esp
c010331b:	ff 75 0c             	pushl  0xc(%ebp)
c010331e:	e8 60 f6 ff ff       	call   c0102983 <page_ref_dec>
c0103323:	83 c4 10             	add    $0x10,%esp
c0103326:	eb 14                	jmp    c010333c <page_insert+0x80>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0103328:	83 ec 04             	sub    $0x4,%esp
c010332b:	ff 75 f4             	pushl  -0xc(%ebp)
c010332e:	ff 75 10             	pushl  0x10(%ebp)
c0103331:	ff 75 08             	pushl  0x8(%ebp)
c0103334:	e8 4a ff ff ff       	call   c0103283 <page_remove_pte>
c0103339:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010333c:	83 ec 0c             	sub    $0xc,%esp
c010333f:	ff 75 0c             	pushl  0xc(%ebp)
c0103342:	e8 26 f5 ff ff       	call   c010286d <page2pa>
c0103347:	83 c4 10             	add    $0x10,%esp
c010334a:	0b 45 14             	or     0x14(%ebp),%eax
c010334d:	83 c8 01             	or     $0x1,%eax
c0103350:	89 c2                	mov    %eax,%edx
c0103352:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103355:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0103357:	83 ec 08             	sub    $0x8,%esp
c010335a:	ff 75 10             	pushl  0x10(%ebp)
c010335d:	ff 75 08             	pushl  0x8(%ebp)
c0103360:	e8 0a 00 00 00       	call   c010336f <tlb_invalidate>
c0103365:	83 c4 10             	add    $0x10,%esp
    return 0;
c0103368:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010336d:	c9                   	leave  
c010336e:	c3                   	ret    

c010336f <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010336f:	55                   	push   %ebp
c0103370:	89 e5                	mov    %esp,%ebp
c0103372:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0103375:	0f 20 d8             	mov    %cr3,%eax
c0103378:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
c010337b:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c010337e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103381:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103384:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010338b:	77 17                	ja     c01033a4 <tlb_invalidate+0x35>
c010338d:	ff 75 f0             	pushl  -0x10(%ebp)
c0103390:	68 64 63 10 c0       	push   $0xc0106364
c0103395:	68 d8 01 00 00       	push   $0x1d8
c010339a:	68 88 63 10 c0       	push   $0xc0106388
c010339f:	e8 29 d0 ff ff       	call   c01003cd <__panic>
c01033a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033a7:	05 00 00 00 40       	add    $0x40000000,%eax
c01033ac:	39 c2                	cmp    %eax,%edx
c01033ae:	75 0c                	jne    c01033bc <tlb_invalidate+0x4d>
        invlpg((void *)la);
c01033b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01033b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033b9:	0f 01 38             	invlpg (%eax)
    }
}
c01033bc:	90                   	nop
c01033bd:	c9                   	leave  
c01033be:	c3                   	ret    

c01033bf <check_alloc_page>:

static void
check_alloc_page(void) {
c01033bf:	55                   	push   %ebp
c01033c0:	89 e5                	mov    %esp,%ebp
c01033c2:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c01033c5:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c01033ca:	8b 40 18             	mov    0x18(%eax),%eax
c01033cd:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01033cf:	83 ec 0c             	sub    $0xc,%esp
c01033d2:	68 e8 63 10 c0       	push   $0xc01063e8
c01033d7:	e8 8b ce ff ff       	call   c0100267 <cprintf>
c01033dc:	83 c4 10             	add    $0x10,%esp
}
c01033df:	90                   	nop
c01033e0:	c9                   	leave  
c01033e1:	c3                   	ret    

c01033e2 <check_pgdir>:

static void
check_pgdir(void) {
c01033e2:	55                   	push   %ebp
c01033e3:	89 e5                	mov    %esp,%ebp
c01033e5:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01033e8:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01033ed:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01033f2:	76 19                	jbe    c010340d <check_pgdir+0x2b>
c01033f4:	68 07 64 10 c0       	push   $0xc0106407
c01033f9:	68 ad 63 10 c0       	push   $0xc01063ad
c01033fe:	68 e5 01 00 00       	push   $0x1e5
c0103403:	68 88 63 10 c0       	push   $0xc0106388
c0103408:	e8 c0 cf ff ff       	call   c01003cd <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010340d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103412:	85 c0                	test   %eax,%eax
c0103414:	74 0e                	je     c0103424 <check_pgdir+0x42>
c0103416:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010341b:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103420:	85 c0                	test   %eax,%eax
c0103422:	74 19                	je     c010343d <check_pgdir+0x5b>
c0103424:	68 24 64 10 c0       	push   $0xc0106424
c0103429:	68 ad 63 10 c0       	push   $0xc01063ad
c010342e:	68 e6 01 00 00       	push   $0x1e6
c0103433:	68 88 63 10 c0       	push   $0xc0106388
c0103438:	e8 90 cf ff ff       	call   c01003cd <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c010343d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103442:	83 ec 04             	sub    $0x4,%esp
c0103445:	6a 00                	push   $0x0
c0103447:	6a 00                	push   $0x0
c0103449:	50                   	push   %eax
c010344a:	e8 e1 fd ff ff       	call   c0103230 <get_page>
c010344f:	83 c4 10             	add    $0x10,%esp
c0103452:	85 c0                	test   %eax,%eax
c0103454:	74 19                	je     c010346f <check_pgdir+0x8d>
c0103456:	68 5c 64 10 c0       	push   $0xc010645c
c010345b:	68 ad 63 10 c0       	push   $0xc01063ad
c0103460:	68 e7 01 00 00       	push   $0x1e7
c0103465:	68 88 63 10 c0       	push   $0xc0106388
c010346a:	e8 5e cf ff ff       	call   c01003cd <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010346f:	83 ec 0c             	sub    $0xc,%esp
c0103472:	6a 01                	push   $0x1
c0103474:	e8 e9 f6 ff ff       	call   c0102b62 <alloc_pages>
c0103479:	83 c4 10             	add    $0x10,%esp
c010347c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c010347f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103484:	6a 00                	push   $0x0
c0103486:	6a 00                	push   $0x0
c0103488:	ff 75 f4             	pushl  -0xc(%ebp)
c010348b:	50                   	push   %eax
c010348c:	e8 2b fe ff ff       	call   c01032bc <page_insert>
c0103491:	83 c4 10             	add    $0x10,%esp
c0103494:	85 c0                	test   %eax,%eax
c0103496:	74 19                	je     c01034b1 <check_pgdir+0xcf>
c0103498:	68 84 64 10 c0       	push   $0xc0106484
c010349d:	68 ad 63 10 c0       	push   $0xc01063ad
c01034a2:	68 eb 01 00 00       	push   $0x1eb
c01034a7:	68 88 63 10 c0       	push   $0xc0106388
c01034ac:	e8 1c cf ff ff       	call   c01003cd <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01034b1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01034b6:	83 ec 04             	sub    $0x4,%esp
c01034b9:	6a 00                	push   $0x0
c01034bb:	6a 00                	push   $0x0
c01034bd:	50                   	push   %eax
c01034be:	e8 67 fd ff ff       	call   c010322a <get_pte>
c01034c3:	83 c4 10             	add    $0x10,%esp
c01034c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01034c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01034cd:	75 19                	jne    c01034e8 <check_pgdir+0x106>
c01034cf:	68 b0 64 10 c0       	push   $0xc01064b0
c01034d4:	68 ad 63 10 c0       	push   $0xc01063ad
c01034d9:	68 ee 01 00 00       	push   $0x1ee
c01034de:	68 88 63 10 c0       	push   $0xc0106388
c01034e3:	e8 e5 ce ff ff       	call   c01003cd <__panic>
    assert(pte2page(*ptep) == p1);
c01034e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034eb:	8b 00                	mov    (%eax),%eax
c01034ed:	83 ec 0c             	sub    $0xc,%esp
c01034f0:	50                   	push   %eax
c01034f1:	e8 16 f4 ff ff       	call   c010290c <pte2page>
c01034f6:	83 c4 10             	add    $0x10,%esp
c01034f9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01034fc:	74 19                	je     c0103517 <check_pgdir+0x135>
c01034fe:	68 dd 64 10 c0       	push   $0xc01064dd
c0103503:	68 ad 63 10 c0       	push   $0xc01063ad
c0103508:	68 ef 01 00 00       	push   $0x1ef
c010350d:	68 88 63 10 c0       	push   $0xc0106388
c0103512:	e8 b6 ce ff ff       	call   c01003cd <__panic>
    assert(page_ref(p1) == 1);
c0103517:	83 ec 0c             	sub    $0xc,%esp
c010351a:	ff 75 f4             	pushl  -0xc(%ebp)
c010351d:	e8 40 f4 ff ff       	call   c0102962 <page_ref>
c0103522:	83 c4 10             	add    $0x10,%esp
c0103525:	83 f8 01             	cmp    $0x1,%eax
c0103528:	74 19                	je     c0103543 <check_pgdir+0x161>
c010352a:	68 f3 64 10 c0       	push   $0xc01064f3
c010352f:	68 ad 63 10 c0       	push   $0xc01063ad
c0103534:	68 f0 01 00 00       	push   $0x1f0
c0103539:	68 88 63 10 c0       	push   $0xc0106388
c010353e:	e8 8a ce ff ff       	call   c01003cd <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0103543:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103548:	8b 00                	mov    (%eax),%eax
c010354a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010354f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103552:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103555:	c1 e8 0c             	shr    $0xc,%eax
c0103558:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010355b:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103560:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103563:	72 17                	jb     c010357c <check_pgdir+0x19a>
c0103565:	ff 75 ec             	pushl  -0x14(%ebp)
c0103568:	68 c0 62 10 c0       	push   $0xc01062c0
c010356d:	68 f2 01 00 00       	push   $0x1f2
c0103572:	68 88 63 10 c0       	push   $0xc0106388
c0103577:	e8 51 ce ff ff       	call   c01003cd <__panic>
c010357c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010357f:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103584:	83 c0 04             	add    $0x4,%eax
c0103587:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c010358a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010358f:	83 ec 04             	sub    $0x4,%esp
c0103592:	6a 00                	push   $0x0
c0103594:	68 00 10 00 00       	push   $0x1000
c0103599:	50                   	push   %eax
c010359a:	e8 8b fc ff ff       	call   c010322a <get_pte>
c010359f:	83 c4 10             	add    $0x10,%esp
c01035a2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01035a5:	74 19                	je     c01035c0 <check_pgdir+0x1de>
c01035a7:	68 08 65 10 c0       	push   $0xc0106508
c01035ac:	68 ad 63 10 c0       	push   $0xc01063ad
c01035b1:	68 f3 01 00 00       	push   $0x1f3
c01035b6:	68 88 63 10 c0       	push   $0xc0106388
c01035bb:	e8 0d ce ff ff       	call   c01003cd <__panic>

    p2 = alloc_page();
c01035c0:	83 ec 0c             	sub    $0xc,%esp
c01035c3:	6a 01                	push   $0x1
c01035c5:	e8 98 f5 ff ff       	call   c0102b62 <alloc_pages>
c01035ca:	83 c4 10             	add    $0x10,%esp
c01035cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01035d0:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01035d5:	6a 06                	push   $0x6
c01035d7:	68 00 10 00 00       	push   $0x1000
c01035dc:	ff 75 e4             	pushl  -0x1c(%ebp)
c01035df:	50                   	push   %eax
c01035e0:	e8 d7 fc ff ff       	call   c01032bc <page_insert>
c01035e5:	83 c4 10             	add    $0x10,%esp
c01035e8:	85 c0                	test   %eax,%eax
c01035ea:	74 19                	je     c0103605 <check_pgdir+0x223>
c01035ec:	68 30 65 10 c0       	push   $0xc0106530
c01035f1:	68 ad 63 10 c0       	push   $0xc01063ad
c01035f6:	68 f6 01 00 00       	push   $0x1f6
c01035fb:	68 88 63 10 c0       	push   $0xc0106388
c0103600:	e8 c8 cd ff ff       	call   c01003cd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103605:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010360a:	83 ec 04             	sub    $0x4,%esp
c010360d:	6a 00                	push   $0x0
c010360f:	68 00 10 00 00       	push   $0x1000
c0103614:	50                   	push   %eax
c0103615:	e8 10 fc ff ff       	call   c010322a <get_pte>
c010361a:	83 c4 10             	add    $0x10,%esp
c010361d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103620:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103624:	75 19                	jne    c010363f <check_pgdir+0x25d>
c0103626:	68 68 65 10 c0       	push   $0xc0106568
c010362b:	68 ad 63 10 c0       	push   $0xc01063ad
c0103630:	68 f7 01 00 00       	push   $0x1f7
c0103635:	68 88 63 10 c0       	push   $0xc0106388
c010363a:	e8 8e cd ff ff       	call   c01003cd <__panic>
    assert(*ptep & PTE_U);
c010363f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103642:	8b 00                	mov    (%eax),%eax
c0103644:	83 e0 04             	and    $0x4,%eax
c0103647:	85 c0                	test   %eax,%eax
c0103649:	75 19                	jne    c0103664 <check_pgdir+0x282>
c010364b:	68 98 65 10 c0       	push   $0xc0106598
c0103650:	68 ad 63 10 c0       	push   $0xc01063ad
c0103655:	68 f8 01 00 00       	push   $0x1f8
c010365a:	68 88 63 10 c0       	push   $0xc0106388
c010365f:	e8 69 cd ff ff       	call   c01003cd <__panic>
    assert(*ptep & PTE_W);
c0103664:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103667:	8b 00                	mov    (%eax),%eax
c0103669:	83 e0 02             	and    $0x2,%eax
c010366c:	85 c0                	test   %eax,%eax
c010366e:	75 19                	jne    c0103689 <check_pgdir+0x2a7>
c0103670:	68 a6 65 10 c0       	push   $0xc01065a6
c0103675:	68 ad 63 10 c0       	push   $0xc01063ad
c010367a:	68 f9 01 00 00       	push   $0x1f9
c010367f:	68 88 63 10 c0       	push   $0xc0106388
c0103684:	e8 44 cd ff ff       	call   c01003cd <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103689:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010368e:	8b 00                	mov    (%eax),%eax
c0103690:	83 e0 04             	and    $0x4,%eax
c0103693:	85 c0                	test   %eax,%eax
c0103695:	75 19                	jne    c01036b0 <check_pgdir+0x2ce>
c0103697:	68 b4 65 10 c0       	push   $0xc01065b4
c010369c:	68 ad 63 10 c0       	push   $0xc01063ad
c01036a1:	68 fa 01 00 00       	push   $0x1fa
c01036a6:	68 88 63 10 c0       	push   $0xc0106388
c01036ab:	e8 1d cd ff ff       	call   c01003cd <__panic>
    assert(page_ref(p2) == 1);
c01036b0:	83 ec 0c             	sub    $0xc,%esp
c01036b3:	ff 75 e4             	pushl  -0x1c(%ebp)
c01036b6:	e8 a7 f2 ff ff       	call   c0102962 <page_ref>
c01036bb:	83 c4 10             	add    $0x10,%esp
c01036be:	83 f8 01             	cmp    $0x1,%eax
c01036c1:	74 19                	je     c01036dc <check_pgdir+0x2fa>
c01036c3:	68 ca 65 10 c0       	push   $0xc01065ca
c01036c8:	68 ad 63 10 c0       	push   $0xc01063ad
c01036cd:	68 fb 01 00 00       	push   $0x1fb
c01036d2:	68 88 63 10 c0       	push   $0xc0106388
c01036d7:	e8 f1 cc ff ff       	call   c01003cd <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01036dc:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01036e1:	6a 00                	push   $0x0
c01036e3:	68 00 10 00 00       	push   $0x1000
c01036e8:	ff 75 f4             	pushl  -0xc(%ebp)
c01036eb:	50                   	push   %eax
c01036ec:	e8 cb fb ff ff       	call   c01032bc <page_insert>
c01036f1:	83 c4 10             	add    $0x10,%esp
c01036f4:	85 c0                	test   %eax,%eax
c01036f6:	74 19                	je     c0103711 <check_pgdir+0x32f>
c01036f8:	68 dc 65 10 c0       	push   $0xc01065dc
c01036fd:	68 ad 63 10 c0       	push   $0xc01063ad
c0103702:	68 fd 01 00 00       	push   $0x1fd
c0103707:	68 88 63 10 c0       	push   $0xc0106388
c010370c:	e8 bc cc ff ff       	call   c01003cd <__panic>
    assert(page_ref(p1) == 2);
c0103711:	83 ec 0c             	sub    $0xc,%esp
c0103714:	ff 75 f4             	pushl  -0xc(%ebp)
c0103717:	e8 46 f2 ff ff       	call   c0102962 <page_ref>
c010371c:	83 c4 10             	add    $0x10,%esp
c010371f:	83 f8 02             	cmp    $0x2,%eax
c0103722:	74 19                	je     c010373d <check_pgdir+0x35b>
c0103724:	68 08 66 10 c0       	push   $0xc0106608
c0103729:	68 ad 63 10 c0       	push   $0xc01063ad
c010372e:	68 fe 01 00 00       	push   $0x1fe
c0103733:	68 88 63 10 c0       	push   $0xc0106388
c0103738:	e8 90 cc ff ff       	call   c01003cd <__panic>
    assert(page_ref(p2) == 0);
c010373d:	83 ec 0c             	sub    $0xc,%esp
c0103740:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103743:	e8 1a f2 ff ff       	call   c0102962 <page_ref>
c0103748:	83 c4 10             	add    $0x10,%esp
c010374b:	85 c0                	test   %eax,%eax
c010374d:	74 19                	je     c0103768 <check_pgdir+0x386>
c010374f:	68 1a 66 10 c0       	push   $0xc010661a
c0103754:	68 ad 63 10 c0       	push   $0xc01063ad
c0103759:	68 ff 01 00 00       	push   $0x1ff
c010375e:	68 88 63 10 c0       	push   $0xc0106388
c0103763:	e8 65 cc ff ff       	call   c01003cd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103768:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010376d:	83 ec 04             	sub    $0x4,%esp
c0103770:	6a 00                	push   $0x0
c0103772:	68 00 10 00 00       	push   $0x1000
c0103777:	50                   	push   %eax
c0103778:	e8 ad fa ff ff       	call   c010322a <get_pte>
c010377d:	83 c4 10             	add    $0x10,%esp
c0103780:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103783:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103787:	75 19                	jne    c01037a2 <check_pgdir+0x3c0>
c0103789:	68 68 65 10 c0       	push   $0xc0106568
c010378e:	68 ad 63 10 c0       	push   $0xc01063ad
c0103793:	68 00 02 00 00       	push   $0x200
c0103798:	68 88 63 10 c0       	push   $0xc0106388
c010379d:	e8 2b cc ff ff       	call   c01003cd <__panic>
    assert(pte2page(*ptep) == p1);
c01037a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037a5:	8b 00                	mov    (%eax),%eax
c01037a7:	83 ec 0c             	sub    $0xc,%esp
c01037aa:	50                   	push   %eax
c01037ab:	e8 5c f1 ff ff       	call   c010290c <pte2page>
c01037b0:	83 c4 10             	add    $0x10,%esp
c01037b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01037b6:	74 19                	je     c01037d1 <check_pgdir+0x3ef>
c01037b8:	68 dd 64 10 c0       	push   $0xc01064dd
c01037bd:	68 ad 63 10 c0       	push   $0xc01063ad
c01037c2:	68 01 02 00 00       	push   $0x201
c01037c7:	68 88 63 10 c0       	push   $0xc0106388
c01037cc:	e8 fc cb ff ff       	call   c01003cd <__panic>
    assert((*ptep & PTE_U) == 0);
c01037d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037d4:	8b 00                	mov    (%eax),%eax
c01037d6:	83 e0 04             	and    $0x4,%eax
c01037d9:	85 c0                	test   %eax,%eax
c01037db:	74 19                	je     c01037f6 <check_pgdir+0x414>
c01037dd:	68 2c 66 10 c0       	push   $0xc010662c
c01037e2:	68 ad 63 10 c0       	push   $0xc01063ad
c01037e7:	68 02 02 00 00       	push   $0x202
c01037ec:	68 88 63 10 c0       	push   $0xc0106388
c01037f1:	e8 d7 cb ff ff       	call   c01003cd <__panic>

    page_remove(boot_pgdir, 0x0);
c01037f6:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01037fb:	83 ec 08             	sub    $0x8,%esp
c01037fe:	6a 00                	push   $0x0
c0103800:	50                   	push   %eax
c0103801:	e8 83 fa ff ff       	call   c0103289 <page_remove>
c0103806:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c0103809:	83 ec 0c             	sub    $0xc,%esp
c010380c:	ff 75 f4             	pushl  -0xc(%ebp)
c010380f:	e8 4e f1 ff ff       	call   c0102962 <page_ref>
c0103814:	83 c4 10             	add    $0x10,%esp
c0103817:	83 f8 01             	cmp    $0x1,%eax
c010381a:	74 19                	je     c0103835 <check_pgdir+0x453>
c010381c:	68 f3 64 10 c0       	push   $0xc01064f3
c0103821:	68 ad 63 10 c0       	push   $0xc01063ad
c0103826:	68 05 02 00 00       	push   $0x205
c010382b:	68 88 63 10 c0       	push   $0xc0106388
c0103830:	e8 98 cb ff ff       	call   c01003cd <__panic>
    assert(page_ref(p2) == 0);
c0103835:	83 ec 0c             	sub    $0xc,%esp
c0103838:	ff 75 e4             	pushl  -0x1c(%ebp)
c010383b:	e8 22 f1 ff ff       	call   c0102962 <page_ref>
c0103840:	83 c4 10             	add    $0x10,%esp
c0103843:	85 c0                	test   %eax,%eax
c0103845:	74 19                	je     c0103860 <check_pgdir+0x47e>
c0103847:	68 1a 66 10 c0       	push   $0xc010661a
c010384c:	68 ad 63 10 c0       	push   $0xc01063ad
c0103851:	68 06 02 00 00       	push   $0x206
c0103856:	68 88 63 10 c0       	push   $0xc0106388
c010385b:	e8 6d cb ff ff       	call   c01003cd <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103860:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103865:	83 ec 08             	sub    $0x8,%esp
c0103868:	68 00 10 00 00       	push   $0x1000
c010386d:	50                   	push   %eax
c010386e:	e8 16 fa ff ff       	call   c0103289 <page_remove>
c0103873:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c0103876:	83 ec 0c             	sub    $0xc,%esp
c0103879:	ff 75 f4             	pushl  -0xc(%ebp)
c010387c:	e8 e1 f0 ff ff       	call   c0102962 <page_ref>
c0103881:	83 c4 10             	add    $0x10,%esp
c0103884:	85 c0                	test   %eax,%eax
c0103886:	74 19                	je     c01038a1 <check_pgdir+0x4bf>
c0103888:	68 41 66 10 c0       	push   $0xc0106641
c010388d:	68 ad 63 10 c0       	push   $0xc01063ad
c0103892:	68 09 02 00 00       	push   $0x209
c0103897:	68 88 63 10 c0       	push   $0xc0106388
c010389c:	e8 2c cb ff ff       	call   c01003cd <__panic>
    assert(page_ref(p2) == 0);
c01038a1:	83 ec 0c             	sub    $0xc,%esp
c01038a4:	ff 75 e4             	pushl  -0x1c(%ebp)
c01038a7:	e8 b6 f0 ff ff       	call   c0102962 <page_ref>
c01038ac:	83 c4 10             	add    $0x10,%esp
c01038af:	85 c0                	test   %eax,%eax
c01038b1:	74 19                	je     c01038cc <check_pgdir+0x4ea>
c01038b3:	68 1a 66 10 c0       	push   $0xc010661a
c01038b8:	68 ad 63 10 c0       	push   $0xc01063ad
c01038bd:	68 0a 02 00 00       	push   $0x20a
c01038c2:	68 88 63 10 c0       	push   $0xc0106388
c01038c7:	e8 01 cb ff ff       	call   c01003cd <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c01038cc:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01038d1:	8b 00                	mov    (%eax),%eax
c01038d3:	83 ec 0c             	sub    $0xc,%esp
c01038d6:	50                   	push   %eax
c01038d7:	e8 6a f0 ff ff       	call   c0102946 <pde2page>
c01038dc:	83 c4 10             	add    $0x10,%esp
c01038df:	83 ec 0c             	sub    $0xc,%esp
c01038e2:	50                   	push   %eax
c01038e3:	e8 7a f0 ff ff       	call   c0102962 <page_ref>
c01038e8:	83 c4 10             	add    $0x10,%esp
c01038eb:	83 f8 01             	cmp    $0x1,%eax
c01038ee:	74 19                	je     c0103909 <check_pgdir+0x527>
c01038f0:	68 54 66 10 c0       	push   $0xc0106654
c01038f5:	68 ad 63 10 c0       	push   $0xc01063ad
c01038fa:	68 0c 02 00 00       	push   $0x20c
c01038ff:	68 88 63 10 c0       	push   $0xc0106388
c0103904:	e8 c4 ca ff ff       	call   c01003cd <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103909:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010390e:	8b 00                	mov    (%eax),%eax
c0103910:	83 ec 0c             	sub    $0xc,%esp
c0103913:	50                   	push   %eax
c0103914:	e8 2d f0 ff ff       	call   c0102946 <pde2page>
c0103919:	83 c4 10             	add    $0x10,%esp
c010391c:	83 ec 08             	sub    $0x8,%esp
c010391f:	6a 01                	push   $0x1
c0103921:	50                   	push   %eax
c0103922:	e8 79 f2 ff ff       	call   c0102ba0 <free_pages>
c0103927:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c010392a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010392f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103935:	83 ec 0c             	sub    $0xc,%esp
c0103938:	68 7b 66 10 c0       	push   $0xc010667b
c010393d:	e8 25 c9 ff ff       	call   c0100267 <cprintf>
c0103942:	83 c4 10             	add    $0x10,%esp
}
c0103945:	90                   	nop
c0103946:	c9                   	leave  
c0103947:	c3                   	ret    

c0103948 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103948:	55                   	push   %ebp
c0103949:	89 e5                	mov    %esp,%ebp
c010394b:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c010394e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103955:	e9 a3 00 00 00       	jmp    c01039fd <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c010395a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010395d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103960:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103963:	c1 e8 0c             	shr    $0xc,%eax
c0103966:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103969:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010396e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103971:	72 17                	jb     c010398a <check_boot_pgdir+0x42>
c0103973:	ff 75 f0             	pushl  -0x10(%ebp)
c0103976:	68 c0 62 10 c0       	push   $0xc01062c0
c010397b:	68 18 02 00 00       	push   $0x218
c0103980:	68 88 63 10 c0       	push   $0xc0106388
c0103985:	e8 43 ca ff ff       	call   c01003cd <__panic>
c010398a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010398d:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103992:	89 c2                	mov    %eax,%edx
c0103994:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103999:	83 ec 04             	sub    $0x4,%esp
c010399c:	6a 00                	push   $0x0
c010399e:	52                   	push   %edx
c010399f:	50                   	push   %eax
c01039a0:	e8 85 f8 ff ff       	call   c010322a <get_pte>
c01039a5:	83 c4 10             	add    $0x10,%esp
c01039a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01039ab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01039af:	75 19                	jne    c01039ca <check_boot_pgdir+0x82>
c01039b1:	68 98 66 10 c0       	push   $0xc0106698
c01039b6:	68 ad 63 10 c0       	push   $0xc01063ad
c01039bb:	68 18 02 00 00       	push   $0x218
c01039c0:	68 88 63 10 c0       	push   $0xc0106388
c01039c5:	e8 03 ca ff ff       	call   c01003cd <__panic>
        assert(PTE_ADDR(*ptep) == i);
c01039ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01039cd:	8b 00                	mov    (%eax),%eax
c01039cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01039d4:	89 c2                	mov    %eax,%edx
c01039d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039d9:	39 c2                	cmp    %eax,%edx
c01039db:	74 19                	je     c01039f6 <check_boot_pgdir+0xae>
c01039dd:	68 d5 66 10 c0       	push   $0xc01066d5
c01039e2:	68 ad 63 10 c0       	push   $0xc01063ad
c01039e7:	68 19 02 00 00       	push   $0x219
c01039ec:	68 88 63 10 c0       	push   $0xc0106388
c01039f1:	e8 d7 c9 ff ff       	call   c01003cd <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01039f6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01039fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103a00:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103a05:	39 c2                	cmp    %eax,%edx
c0103a07:	0f 82 4d ff ff ff    	jb     c010395a <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103a0d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103a12:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103a17:	8b 00                	mov    (%eax),%eax
c0103a19:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103a1e:	89 c2                	mov    %eax,%edx
c0103a20:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103a25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103a28:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0103a2f:	77 17                	ja     c0103a48 <check_boot_pgdir+0x100>
c0103a31:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103a34:	68 64 63 10 c0       	push   $0xc0106364
c0103a39:	68 1c 02 00 00       	push   $0x21c
c0103a3e:	68 88 63 10 c0       	push   $0xc0106388
c0103a43:	e8 85 c9 ff ff       	call   c01003cd <__panic>
c0103a48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a4b:	05 00 00 00 40       	add    $0x40000000,%eax
c0103a50:	39 c2                	cmp    %eax,%edx
c0103a52:	74 19                	je     c0103a6d <check_boot_pgdir+0x125>
c0103a54:	68 ec 66 10 c0       	push   $0xc01066ec
c0103a59:	68 ad 63 10 c0       	push   $0xc01063ad
c0103a5e:	68 1c 02 00 00       	push   $0x21c
c0103a63:	68 88 63 10 c0       	push   $0xc0106388
c0103a68:	e8 60 c9 ff ff       	call   c01003cd <__panic>

    assert(boot_pgdir[0] == 0);
c0103a6d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103a72:	8b 00                	mov    (%eax),%eax
c0103a74:	85 c0                	test   %eax,%eax
c0103a76:	74 19                	je     c0103a91 <check_boot_pgdir+0x149>
c0103a78:	68 20 67 10 c0       	push   $0xc0106720
c0103a7d:	68 ad 63 10 c0       	push   $0xc01063ad
c0103a82:	68 1e 02 00 00       	push   $0x21e
c0103a87:	68 88 63 10 c0       	push   $0xc0106388
c0103a8c:	e8 3c c9 ff ff       	call   c01003cd <__panic>

    struct Page *p;
    p = alloc_page();
c0103a91:	83 ec 0c             	sub    $0xc,%esp
c0103a94:	6a 01                	push   $0x1
c0103a96:	e8 c7 f0 ff ff       	call   c0102b62 <alloc_pages>
c0103a9b:	83 c4 10             	add    $0x10,%esp
c0103a9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103aa1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103aa6:	6a 02                	push   $0x2
c0103aa8:	68 00 01 00 00       	push   $0x100
c0103aad:	ff 75 e0             	pushl  -0x20(%ebp)
c0103ab0:	50                   	push   %eax
c0103ab1:	e8 06 f8 ff ff       	call   c01032bc <page_insert>
c0103ab6:	83 c4 10             	add    $0x10,%esp
c0103ab9:	85 c0                	test   %eax,%eax
c0103abb:	74 19                	je     c0103ad6 <check_boot_pgdir+0x18e>
c0103abd:	68 34 67 10 c0       	push   $0xc0106734
c0103ac2:	68 ad 63 10 c0       	push   $0xc01063ad
c0103ac7:	68 22 02 00 00       	push   $0x222
c0103acc:	68 88 63 10 c0       	push   $0xc0106388
c0103ad1:	e8 f7 c8 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p) == 1);
c0103ad6:	83 ec 0c             	sub    $0xc,%esp
c0103ad9:	ff 75 e0             	pushl  -0x20(%ebp)
c0103adc:	e8 81 ee ff ff       	call   c0102962 <page_ref>
c0103ae1:	83 c4 10             	add    $0x10,%esp
c0103ae4:	83 f8 01             	cmp    $0x1,%eax
c0103ae7:	74 19                	je     c0103b02 <check_boot_pgdir+0x1ba>
c0103ae9:	68 62 67 10 c0       	push   $0xc0106762
c0103aee:	68 ad 63 10 c0       	push   $0xc01063ad
c0103af3:	68 23 02 00 00       	push   $0x223
c0103af8:	68 88 63 10 c0       	push   $0xc0106388
c0103afd:	e8 cb c8 ff ff       	call   c01003cd <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0103b02:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103b07:	6a 02                	push   $0x2
c0103b09:	68 00 11 00 00       	push   $0x1100
c0103b0e:	ff 75 e0             	pushl  -0x20(%ebp)
c0103b11:	50                   	push   %eax
c0103b12:	e8 a5 f7 ff ff       	call   c01032bc <page_insert>
c0103b17:	83 c4 10             	add    $0x10,%esp
c0103b1a:	85 c0                	test   %eax,%eax
c0103b1c:	74 19                	je     c0103b37 <check_boot_pgdir+0x1ef>
c0103b1e:	68 74 67 10 c0       	push   $0xc0106774
c0103b23:	68 ad 63 10 c0       	push   $0xc01063ad
c0103b28:	68 24 02 00 00       	push   $0x224
c0103b2d:	68 88 63 10 c0       	push   $0xc0106388
c0103b32:	e8 96 c8 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p) == 2);
c0103b37:	83 ec 0c             	sub    $0xc,%esp
c0103b3a:	ff 75 e0             	pushl  -0x20(%ebp)
c0103b3d:	e8 20 ee ff ff       	call   c0102962 <page_ref>
c0103b42:	83 c4 10             	add    $0x10,%esp
c0103b45:	83 f8 02             	cmp    $0x2,%eax
c0103b48:	74 19                	je     c0103b63 <check_boot_pgdir+0x21b>
c0103b4a:	68 ab 67 10 c0       	push   $0xc01067ab
c0103b4f:	68 ad 63 10 c0       	push   $0xc01063ad
c0103b54:	68 25 02 00 00       	push   $0x225
c0103b59:	68 88 63 10 c0       	push   $0xc0106388
c0103b5e:	e8 6a c8 ff ff       	call   c01003cd <__panic>

    const char *str = "ucore: Hello world!!";
c0103b63:	c7 45 dc bc 67 10 c0 	movl   $0xc01067bc,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0103b6a:	83 ec 08             	sub    $0x8,%esp
c0103b6d:	ff 75 dc             	pushl  -0x24(%ebp)
c0103b70:	68 00 01 00 00       	push   $0x100
c0103b75:	e8 86 15 00 00       	call   c0105100 <strcpy>
c0103b7a:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0103b7d:	83 ec 08             	sub    $0x8,%esp
c0103b80:	68 00 11 00 00       	push   $0x1100
c0103b85:	68 00 01 00 00       	push   $0x100
c0103b8a:	e8 eb 15 00 00       	call   c010517a <strcmp>
c0103b8f:	83 c4 10             	add    $0x10,%esp
c0103b92:	85 c0                	test   %eax,%eax
c0103b94:	74 19                	je     c0103baf <check_boot_pgdir+0x267>
c0103b96:	68 d4 67 10 c0       	push   $0xc01067d4
c0103b9b:	68 ad 63 10 c0       	push   $0xc01063ad
c0103ba0:	68 29 02 00 00       	push   $0x229
c0103ba5:	68 88 63 10 c0       	push   $0xc0106388
c0103baa:	e8 1e c8 ff ff       	call   c01003cd <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0103baf:	83 ec 0c             	sub    $0xc,%esp
c0103bb2:	ff 75 e0             	pushl  -0x20(%ebp)
c0103bb5:	e8 0d ed ff ff       	call   c01028c7 <page2kva>
c0103bba:	83 c4 10             	add    $0x10,%esp
c0103bbd:	05 00 01 00 00       	add    $0x100,%eax
c0103bc2:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0103bc5:	83 ec 0c             	sub    $0xc,%esp
c0103bc8:	68 00 01 00 00       	push   $0x100
c0103bcd:	e8 d6 14 00 00       	call   c01050a8 <strlen>
c0103bd2:	83 c4 10             	add    $0x10,%esp
c0103bd5:	85 c0                	test   %eax,%eax
c0103bd7:	74 19                	je     c0103bf2 <check_boot_pgdir+0x2aa>
c0103bd9:	68 0c 68 10 c0       	push   $0xc010680c
c0103bde:	68 ad 63 10 c0       	push   $0xc01063ad
c0103be3:	68 2c 02 00 00       	push   $0x22c
c0103be8:	68 88 63 10 c0       	push   $0xc0106388
c0103bed:	e8 db c7 ff ff       	call   c01003cd <__panic>

    free_page(p);
c0103bf2:	83 ec 08             	sub    $0x8,%esp
c0103bf5:	6a 01                	push   $0x1
c0103bf7:	ff 75 e0             	pushl  -0x20(%ebp)
c0103bfa:	e8 a1 ef ff ff       	call   c0102ba0 <free_pages>
c0103bff:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c0103c02:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103c07:	8b 00                	mov    (%eax),%eax
c0103c09:	83 ec 0c             	sub    $0xc,%esp
c0103c0c:	50                   	push   %eax
c0103c0d:	e8 34 ed ff ff       	call   c0102946 <pde2page>
c0103c12:	83 c4 10             	add    $0x10,%esp
c0103c15:	83 ec 08             	sub    $0x8,%esp
c0103c18:	6a 01                	push   $0x1
c0103c1a:	50                   	push   %eax
c0103c1b:	e8 80 ef ff ff       	call   c0102ba0 <free_pages>
c0103c20:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103c23:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103c28:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0103c2e:	83 ec 0c             	sub    $0xc,%esp
c0103c31:	68 30 68 10 c0       	push   $0xc0106830
c0103c36:	e8 2c c6 ff ff       	call   c0100267 <cprintf>
c0103c3b:	83 c4 10             	add    $0x10,%esp
}
c0103c3e:	90                   	nop
c0103c3f:	c9                   	leave  
c0103c40:	c3                   	ret    

c0103c41 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0103c41:	55                   	push   %ebp
c0103c42:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0103c44:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c47:	83 e0 04             	and    $0x4,%eax
c0103c4a:	85 c0                	test   %eax,%eax
c0103c4c:	74 07                	je     c0103c55 <perm2str+0x14>
c0103c4e:	b8 75 00 00 00       	mov    $0x75,%eax
c0103c53:	eb 05                	jmp    c0103c5a <perm2str+0x19>
c0103c55:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103c5a:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c0103c5f:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0103c66:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c69:	83 e0 02             	and    $0x2,%eax
c0103c6c:	85 c0                	test   %eax,%eax
c0103c6e:	74 07                	je     c0103c77 <perm2str+0x36>
c0103c70:	b8 77 00 00 00       	mov    $0x77,%eax
c0103c75:	eb 05                	jmp    c0103c7c <perm2str+0x3b>
c0103c77:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103c7c:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c0103c81:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c0103c88:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c0103c8d:	5d                   	pop    %ebp
c0103c8e:	c3                   	ret    

c0103c8f <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0103c8f:	55                   	push   %ebp
c0103c90:	89 e5                	mov    %esp,%ebp
c0103c92:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0103c95:	8b 45 10             	mov    0x10(%ebp),%eax
c0103c98:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103c9b:	72 0e                	jb     c0103cab <get_pgtable_items+0x1c>
        return 0;
c0103c9d:	b8 00 00 00 00       	mov    $0x0,%eax
c0103ca2:	e9 9a 00 00 00       	jmp    c0103d41 <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0103ca7:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0103cab:	8b 45 10             	mov    0x10(%ebp),%eax
c0103cae:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103cb1:	73 18                	jae    c0103ccb <get_pgtable_items+0x3c>
c0103cb3:	8b 45 10             	mov    0x10(%ebp),%eax
c0103cb6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103cbd:	8b 45 14             	mov    0x14(%ebp),%eax
c0103cc0:	01 d0                	add    %edx,%eax
c0103cc2:	8b 00                	mov    (%eax),%eax
c0103cc4:	83 e0 01             	and    $0x1,%eax
c0103cc7:	85 c0                	test   %eax,%eax
c0103cc9:	74 dc                	je     c0103ca7 <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
c0103ccb:	8b 45 10             	mov    0x10(%ebp),%eax
c0103cce:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103cd1:	73 69                	jae    c0103d3c <get_pgtable_items+0xad>
        if (left_store != NULL) {
c0103cd3:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0103cd7:	74 08                	je     c0103ce1 <get_pgtable_items+0x52>
            *left_store = start;
c0103cd9:	8b 45 18             	mov    0x18(%ebp),%eax
c0103cdc:	8b 55 10             	mov    0x10(%ebp),%edx
c0103cdf:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0103ce1:	8b 45 10             	mov    0x10(%ebp),%eax
c0103ce4:	8d 50 01             	lea    0x1(%eax),%edx
c0103ce7:	89 55 10             	mov    %edx,0x10(%ebp)
c0103cea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103cf1:	8b 45 14             	mov    0x14(%ebp),%eax
c0103cf4:	01 d0                	add    %edx,%eax
c0103cf6:	8b 00                	mov    (%eax),%eax
c0103cf8:	83 e0 07             	and    $0x7,%eax
c0103cfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103cfe:	eb 04                	jmp    c0103d04 <get_pgtable_items+0x75>
            start ++;
c0103d00:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103d04:	8b 45 10             	mov    0x10(%ebp),%eax
c0103d07:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103d0a:	73 1d                	jae    c0103d29 <get_pgtable_items+0x9a>
c0103d0c:	8b 45 10             	mov    0x10(%ebp),%eax
c0103d0f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103d16:	8b 45 14             	mov    0x14(%ebp),%eax
c0103d19:	01 d0                	add    %edx,%eax
c0103d1b:	8b 00                	mov    (%eax),%eax
c0103d1d:	83 e0 07             	and    $0x7,%eax
c0103d20:	89 c2                	mov    %eax,%edx
c0103d22:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103d25:	39 c2                	cmp    %eax,%edx
c0103d27:	74 d7                	je     c0103d00 <get_pgtable_items+0x71>
            start ++;
        }
        if (right_store != NULL) {
c0103d29:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0103d2d:	74 08                	je     c0103d37 <get_pgtable_items+0xa8>
            *right_store = start;
c0103d2f:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0103d32:	8b 55 10             	mov    0x10(%ebp),%edx
c0103d35:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0103d37:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103d3a:	eb 05                	jmp    c0103d41 <get_pgtable_items+0xb2>
    }
    return 0;
c0103d3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103d41:	c9                   	leave  
c0103d42:	c3                   	ret    

c0103d43 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0103d43:	55                   	push   %ebp
c0103d44:	89 e5                	mov    %esp,%ebp
c0103d46:	57                   	push   %edi
c0103d47:	56                   	push   %esi
c0103d48:	53                   	push   %ebx
c0103d49:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0103d4c:	83 ec 0c             	sub    $0xc,%esp
c0103d4f:	68 50 68 10 c0       	push   $0xc0106850
c0103d54:	e8 0e c5 ff ff       	call   c0100267 <cprintf>
c0103d59:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c0103d5c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0103d63:	e9 e5 00 00 00       	jmp    c0103e4d <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0103d68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d6b:	83 ec 0c             	sub    $0xc,%esp
c0103d6e:	50                   	push   %eax
c0103d6f:	e8 cd fe ff ff       	call   c0103c41 <perm2str>
c0103d74:	83 c4 10             	add    $0x10,%esp
c0103d77:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0103d79:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103d7f:	29 c2                	sub    %eax,%edx
c0103d81:	89 d0                	mov    %edx,%eax
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0103d83:	c1 e0 16             	shl    $0x16,%eax
c0103d86:	89 c3                	mov    %eax,%ebx
c0103d88:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103d8b:	c1 e0 16             	shl    $0x16,%eax
c0103d8e:	89 c1                	mov    %eax,%ecx
c0103d90:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103d93:	c1 e0 16             	shl    $0x16,%eax
c0103d96:	89 c2                	mov    %eax,%edx
c0103d98:	8b 75 dc             	mov    -0x24(%ebp),%esi
c0103d9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103d9e:	29 c6                	sub    %eax,%esi
c0103da0:	89 f0                	mov    %esi,%eax
c0103da2:	83 ec 08             	sub    $0x8,%esp
c0103da5:	57                   	push   %edi
c0103da6:	53                   	push   %ebx
c0103da7:	51                   	push   %ecx
c0103da8:	52                   	push   %edx
c0103da9:	50                   	push   %eax
c0103daa:	68 81 68 10 c0       	push   $0xc0106881
c0103daf:	e8 b3 c4 ff ff       	call   c0100267 <cprintf>
c0103db4:	83 c4 20             	add    $0x20,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0103db7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103dba:	c1 e0 0a             	shl    $0xa,%eax
c0103dbd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0103dc0:	eb 4f                	jmp    c0103e11 <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0103dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103dc5:	83 ec 0c             	sub    $0xc,%esp
c0103dc8:	50                   	push   %eax
c0103dc9:	e8 73 fe ff ff       	call   c0103c41 <perm2str>
c0103dce:	83 c4 10             	add    $0x10,%esp
c0103dd1:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0103dd3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103dd6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103dd9:	29 c2                	sub    %eax,%edx
c0103ddb:	89 d0                	mov    %edx,%eax
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0103ddd:	c1 e0 0c             	shl    $0xc,%eax
c0103de0:	89 c3                	mov    %eax,%ebx
c0103de2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103de5:	c1 e0 0c             	shl    $0xc,%eax
c0103de8:	89 c1                	mov    %eax,%ecx
c0103dea:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103ded:	c1 e0 0c             	shl    $0xc,%eax
c0103df0:	89 c2                	mov    %eax,%edx
c0103df2:	8b 75 d4             	mov    -0x2c(%ebp),%esi
c0103df5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103df8:	29 c6                	sub    %eax,%esi
c0103dfa:	89 f0                	mov    %esi,%eax
c0103dfc:	83 ec 08             	sub    $0x8,%esp
c0103dff:	57                   	push   %edi
c0103e00:	53                   	push   %ebx
c0103e01:	51                   	push   %ecx
c0103e02:	52                   	push   %edx
c0103e03:	50                   	push   %eax
c0103e04:	68 a0 68 10 c0       	push   $0xc01068a0
c0103e09:	e8 59 c4 ff ff       	call   c0100267 <cprintf>
c0103e0e:	83 c4 20             	add    $0x20,%esp
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0103e11:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0103e16:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103e19:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e1c:	89 d3                	mov    %edx,%ebx
c0103e1e:	c1 e3 0a             	shl    $0xa,%ebx
c0103e21:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103e24:	89 d1                	mov    %edx,%ecx
c0103e26:	c1 e1 0a             	shl    $0xa,%ecx
c0103e29:	83 ec 08             	sub    $0x8,%esp
c0103e2c:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0103e2f:	52                   	push   %edx
c0103e30:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0103e33:	52                   	push   %edx
c0103e34:	56                   	push   %esi
c0103e35:	50                   	push   %eax
c0103e36:	53                   	push   %ebx
c0103e37:	51                   	push   %ecx
c0103e38:	e8 52 fe ff ff       	call   c0103c8f <get_pgtable_items>
c0103e3d:	83 c4 20             	add    $0x20,%esp
c0103e40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103e43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103e47:	0f 85 75 ff ff ff    	jne    c0103dc2 <print_pgdir+0x7f>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0103e4d:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0103e52:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103e55:	83 ec 08             	sub    $0x8,%esp
c0103e58:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0103e5b:	52                   	push   %edx
c0103e5c:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0103e5f:	52                   	push   %edx
c0103e60:	51                   	push   %ecx
c0103e61:	50                   	push   %eax
c0103e62:	68 00 04 00 00       	push   $0x400
c0103e67:	6a 00                	push   $0x0
c0103e69:	e8 21 fe ff ff       	call   c0103c8f <get_pgtable_items>
c0103e6e:	83 c4 20             	add    $0x20,%esp
c0103e71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103e74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103e78:	0f 85 ea fe ff ff    	jne    c0103d68 <print_pgdir+0x25>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0103e7e:	83 ec 0c             	sub    $0xc,%esp
c0103e81:	68 c4 68 10 c0       	push   $0xc01068c4
c0103e86:	e8 dc c3 ff ff       	call   c0100267 <cprintf>
c0103e8b:	83 c4 10             	add    $0x10,%esp
}
c0103e8e:	90                   	nop
c0103e8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0103e92:	5b                   	pop    %ebx
c0103e93:	5e                   	pop    %esi
c0103e94:	5f                   	pop    %edi
c0103e95:	5d                   	pop    %ebp
c0103e96:	c3                   	ret    

c0103e97 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103e97:	55                   	push   %ebp
c0103e98:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103e9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e9d:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0103ea3:	29 d0                	sub    %edx,%eax
c0103ea5:	c1 f8 02             	sar    $0x2,%eax
c0103ea8:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103eae:	5d                   	pop    %ebp
c0103eaf:	c3                   	ret    

c0103eb0 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103eb0:	55                   	push   %ebp
c0103eb1:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0103eb3:	ff 75 08             	pushl  0x8(%ebp)
c0103eb6:	e8 dc ff ff ff       	call   c0103e97 <page2ppn>
c0103ebb:	83 c4 04             	add    $0x4,%esp
c0103ebe:	c1 e0 0c             	shl    $0xc,%eax
}
c0103ec1:	c9                   	leave  
c0103ec2:	c3                   	ret    

c0103ec3 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103ec3:	55                   	push   %ebp
c0103ec4:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103ec6:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ec9:	8b 00                	mov    (%eax),%eax
}
c0103ecb:	5d                   	pop    %ebp
c0103ecc:	c3                   	ret    

c0103ecd <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103ecd:	55                   	push   %ebp
c0103ece:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103ed0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ed3:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103ed6:	89 10                	mov    %edx,(%eax)
}
c0103ed8:	90                   	nop
c0103ed9:	5d                   	pop    %ebp
c0103eda:	c3                   	ret    

c0103edb <display_free_list>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)
#define DEBUG 0 

static void display_free_list()
{
c0103edb:	55                   	push   %ebp
c0103edc:	89 e5                	mov    %esp,%ebp
c0103ede:	83 ec 18             	sub    $0x18,%esp
    list_entry_t *le = &free_list;
c0103ee1:	c7 45 f4 5c 89 11 c0 	movl   $0xc011895c,-0xc(%ebp)
        
    cprintf( "\n#################################\n" );
c0103ee8:	83 ec 0c             	sub    $0xc,%esp
c0103eeb:	68 f8 68 10 c0       	push   $0xc01068f8
c0103ef0:	e8 72 c3 ff ff       	call   c0100267 <cprintf>
c0103ef5:	83 c4 10             	add    $0x10,%esp
    while( &free_list != ( le = list_next( le ) ) )
c0103ef8:	eb 31                	jmp    c0103f2b <display_free_list+0x50>
    {
        cprintf( "page address  = 0x%x\n", le2page( le, page_link ) );
c0103efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103efd:	83 e8 0c             	sub    $0xc,%eax
c0103f00:	83 ec 08             	sub    $0x8,%esp
c0103f03:	50                   	push   %eax
c0103f04:	68 1c 69 10 c0       	push   $0xc010691c
c0103f09:	e8 59 c3 ff ff       	call   c0100267 <cprintf>
c0103f0e:	83 c4 10             	add    $0x10,%esp
        cprintf( "page property = %d\n", le2page( le, page_link )->property );
c0103f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f14:	83 e8 0c             	sub    $0xc,%eax
c0103f17:	8b 40 08             	mov    0x8(%eax),%eax
c0103f1a:	83 ec 08             	sub    $0x8,%esp
c0103f1d:	50                   	push   %eax
c0103f1e:	68 32 69 10 c0       	push   $0xc0106932
c0103f23:	e8 3f c3 ff ff       	call   c0100267 <cprintf>
c0103f28:	83 c4 10             	add    $0x10,%esp
c0103f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f34:	8b 40 04             	mov    0x4(%eax),%eax
static void display_free_list()
{
    list_entry_t *le = &free_list;
        
    cprintf( "\n#################################\n" );
    while( &free_list != ( le = list_next( le ) ) )
c0103f37:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103f3a:	81 7d f4 5c 89 11 c0 	cmpl   $0xc011895c,-0xc(%ebp)
c0103f41:	75 b7                	jne    c0103efa <display_free_list+0x1f>
    {
        cprintf( "page address  = 0x%x\n", le2page( le, page_link ) );
        cprintf( "page property = %d\n", le2page( le, page_link )->property );
    }
    cprintf( "#################################\n\n" );
c0103f43:	83 ec 0c             	sub    $0xc,%esp
c0103f46:	68 48 69 10 c0       	push   $0xc0106948
c0103f4b:	e8 17 c3 ff ff       	call   c0100267 <cprintf>
c0103f50:	83 c4 10             	add    $0x10,%esp
}
c0103f53:	90                   	nop
c0103f54:	c9                   	leave  
c0103f55:	c3                   	ret    

c0103f56 <default_init>:

static void default_init( void ) 
{
c0103f56:	55                   	push   %ebp
c0103f57:	89 e5                	mov    %esp,%ebp
c0103f59:	83 ec 10             	sub    $0x10,%esp
c0103f5c:	c7 45 fc 5c 89 11 c0 	movl   $0xc011895c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103f63:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103f66:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103f69:	89 50 04             	mov    %edx,0x4(%eax)
c0103f6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103f6f:	8b 50 04             	mov    0x4(%eax),%edx
c0103f72:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103f75:	89 10                	mov    %edx,(%eax)
    list_init( &free_list );
    nr_free = 0;
c0103f77:	c7 05 64 89 11 c0 00 	movl   $0x0,0xc0118964
c0103f7e:	00 00 00 
}
c0103f81:	90                   	nop
c0103f82:	c9                   	leave  
c0103f83:	c3                   	ret    

c0103f84 <default_init_memmap>:

static void default_init_memmap( struct Page *base, size_t n ) 
{
c0103f84:	55                   	push   %ebp
c0103f85:	89 e5                	mov    %esp,%ebp
c0103f87:	83 ec 30             	sub    $0x30,%esp
    struct Page *p = base;
c0103f8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f8d:	89 45 fc             	mov    %eax,-0x4(%ebp)

    for( ; p != base + n; p++ ) 
c0103f90:	eb 23                	jmp    c0103fb5 <default_init_memmap+0x31>
        p->flags = p->property = p->ref = 0;
c0103f92:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103f95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
c0103f9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103f9e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0103fa5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103fa8:	8b 50 08             	mov    0x8(%eax),%edx
c0103fab:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103fae:	89 50 04             	mov    %edx,0x4(%eax)

static void default_init_memmap( struct Page *base, size_t n ) 
{
    struct Page *p = base;

    for( ; p != base + n; p++ ) 
c0103fb1:	83 45 fc 14          	addl   $0x14,-0x4(%ebp)
c0103fb5:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103fb8:	89 d0                	mov    %edx,%eax
c0103fba:	c1 e0 02             	shl    $0x2,%eax
c0103fbd:	01 d0                	add    %edx,%eax
c0103fbf:	c1 e0 02             	shl    $0x2,%eax
c0103fc2:	89 c2                	mov    %eax,%edx
c0103fc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0103fc7:	01 d0                	add    %edx,%eax
c0103fc9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0103fcc:	75 c4                	jne    c0103f92 <default_init_memmap+0xe>
        p->flags = p->property = p->ref = 0;
    
    SetPageProperty(base); 
c0103fce:	8b 45 08             	mov    0x8(%ebp),%eax
c0103fd1:	83 c0 04             	add    $0x4,%eax
c0103fd4:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
c0103fdb:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103fde:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103fe1:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0103fe4:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
c0103fe7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103fea:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103fed:	89 50 08             	mov    %edx,0x8(%eax)
    list_add( &free_list, &( base->page_link ) );
c0103ff0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ff3:	83 c0 0c             	add    $0xc,%eax
c0103ff6:	c7 45 f4 5c 89 11 c0 	movl   $0xc011895c,-0xc(%ebp)
c0103ffd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104000:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104003:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104006:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104009:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010400c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010400f:	8b 40 04             	mov    0x4(%eax),%eax
c0104012:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104015:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0104018:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010401b:	89 55 e0             	mov    %edx,-0x20(%ebp)
c010401e:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104021:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104024:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104027:	89 10                	mov    %edx,(%eax)
c0104029:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010402c:	8b 10                	mov    (%eax),%edx
c010402e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104031:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104034:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104037:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010403a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010403d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104040:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104043:	89 10                	mov    %edx,(%eax)
    nr_free += n;
c0104045:	8b 15 64 89 11 c0    	mov    0xc0118964,%edx
c010404b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010404e:	01 d0                	add    %edx,%eax
c0104050:	a3 64 89 11 c0       	mov    %eax,0xc0118964
}
c0104055:	90                   	nop
c0104056:	c9                   	leave  
c0104057:	c3                   	ret    

c0104058 <default_alloc_pages>:

static struct Page *default_alloc_pages( size_t n ) 
{
c0104058:	55                   	push   %ebp
c0104059:	89 e5                	mov    %esp,%ebp
c010405b:	83 ec 50             	sub    $0x50,%esp
    struct Page *page = NULL, *rp = NULL;
c010405e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0104065:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c010406c:	c7 45 f8 5c 89 11 c0 	movl   $0xc011895c,-0x8(%ebp)
    int i;

    if( n > nr_free ) 
c0104073:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104078:	3b 45 08             	cmp    0x8(%ebp),%eax
c010407b:	0f 83 54 01 00 00    	jae    c01041d5 <default_alloc_pages+0x17d>
        return NULL;
c0104081:	b8 00 00 00 00       	mov    $0x0,%eax
c0104086:	e9 69 01 00 00       	jmp    c01041f4 <default_alloc_pages+0x19c>
    
    while( &free_list != ( le = list_next( le ) ) )  
    {
        struct Page *p = le2page(le, page_link), *pp;
c010408b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010408e:	83 e8 0c             	sub    $0xc,%eax
c0104091:	89 45 ec             	mov    %eax,-0x14(%ebp)
        
        if( p->property >= n ) 
c0104094:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104097:	8b 40 08             	mov    0x8(%eax),%eax
c010409a:	3b 45 08             	cmp    0x8(%ebp),%eax
c010409d:	0f 82 32 01 00 00    	jb     c01041d5 <default_alloc_pages+0x17d>
        {
            page = p;
c01040a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01040a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            
            for( i = 0; i < n; i++ )
c01040a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01040b0:	eb 3e                	jmp    c01040f0 <default_alloc_pages+0x98>
            {
                pp = page + i; 
c01040b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01040b5:	89 d0                	mov    %edx,%eax
c01040b7:	c1 e0 02             	shl    $0x2,%eax
c01040ba:	01 d0                	add    %edx,%eax
c01040bc:	c1 e0 02             	shl    $0x2,%eax
c01040bf:	89 c2                	mov    %eax,%edx
c01040c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01040c4:	01 d0                	add    %edx,%eax
c01040c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
                pp->flags = 0;
c01040c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01040cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
                SetPageReserved(pp);
c01040d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01040d6:	83 c0 04             	add    $0x4,%eax
c01040d9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
c01040e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01040e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01040e6:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01040e9:	0f ab 10             	bts    %edx,(%eax)
        
        if( p->property >= n ) 
        {
            page = p;
            
            for( i = 0; i < n; i++ )
c01040ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01040f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040f3:	3b 45 08             	cmp    0x8(%ebp),%eax
c01040f6:	72 ba                	jb     c01040b2 <default_alloc_pages+0x5a>
                pp = page + i; 
                pp->flags = 0;
                SetPageReserved(pp);
            } 
            
            if( page->property > n)
c01040f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01040fb:	8b 40 08             	mov    0x8(%eax),%eax
c01040fe:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104101:	0f 86 8a 00 00 00    	jbe    c0104191 <default_alloc_pages+0x139>
            {
                ( page + n )->property = page->property - n;
c0104107:	8b 55 08             	mov    0x8(%ebp),%edx
c010410a:	89 d0                	mov    %edx,%eax
c010410c:	c1 e0 02             	shl    $0x2,%eax
c010410f:	01 d0                	add    %edx,%eax
c0104111:	c1 e0 02             	shl    $0x2,%eax
c0104114:	89 c2                	mov    %eax,%edx
c0104116:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104119:	01 c2                	add    %eax,%edx
c010411b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010411e:	8b 40 08             	mov    0x8(%eax),%eax
c0104121:	2b 45 08             	sub    0x8(%ebp),%eax
c0104124:	89 42 08             	mov    %eax,0x8(%edx)
                list_add( &( page->page_link ), &( ( page + n )->page_link ) );
c0104127:	8b 55 08             	mov    0x8(%ebp),%edx
c010412a:	89 d0                	mov    %edx,%eax
c010412c:	c1 e0 02             	shl    $0x2,%eax
c010412f:	01 d0                	add    %edx,%eax
c0104131:	c1 e0 02             	shl    $0x2,%eax
c0104134:	89 c2                	mov    %eax,%edx
c0104136:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104139:	01 d0                	add    %edx,%eax
c010413b:	83 c0 0c             	add    $0xc,%eax
c010413e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104141:	83 c2 0c             	add    $0xc,%edx
c0104144:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0104147:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010414a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010414d:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0104150:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104153:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0104156:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104159:	8b 40 04             	mov    0x4(%eax),%eax
c010415c:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010415f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0104162:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104165:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0104168:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010416b:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010416e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104171:	89 10                	mov    %edx,(%eax)
c0104173:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104176:	8b 10                	mov    (%eax),%edx
c0104178:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010417b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010417e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104181:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104184:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104187:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010418a:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010418d:	89 10                	mov    %edx,(%eax)
c010418f:	eb 0a                	jmp    c010419b <default_alloc_pages+0x143>
                //rp = page + n;
            }
            else
            {
                page->property = 0;
c0104191:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104194:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                //rp = page;
            }

            list_del( &( page->page_link ) );
c010419b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010419e:	83 c0 0c             	add    $0xc,%eax
c01041a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01041a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01041a7:	8b 40 04             	mov    0x4(%eax),%eax
c01041aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01041ad:	8b 12                	mov    (%edx),%edx
c01041af:	89 55 b8             	mov    %edx,-0x48(%ebp)
c01041b2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01041b5:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01041b8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01041bb:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01041be:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01041c1:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01041c4:	89 10                	mov    %edx,(%eax)
            
            nr_free -= n;
c01041c6:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c01041cb:	2b 45 08             	sub    0x8(%ebp),%eax
c01041ce:	a3 64 89 11 c0       	mov    %eax,0xc0118964
            break;
c01041d3:	eb 1c                	jmp    c01041f1 <default_alloc_pages+0x199>
c01041d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01041d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01041db:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01041de:	8b 40 04             	mov    0x4(%eax),%eax
    int i;

    if( n > nr_free ) 
        return NULL;
    
    while( &free_list != ( le = list_next( le ) ) )  
c01041e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01041e4:	81 7d f8 5c 89 11 c0 	cmpl   $0xc011895c,-0x8(%ebp)
c01041eb:	0f 85 9a fe ff ff    	jne    c010408b <default_alloc_pages+0x33>
            nr_free -= n;
            break;
        }
    }
    
    return page;
c01041f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01041f4:	c9                   	leave  
c01041f5:	c3                   	ret    

c01041f6 <default_free_pages>:

static void default_free_pages( struct Page *base, size_t n ) 
{
c01041f6:	55                   	push   %ebp
c01041f7:	89 e5                	mov    %esp,%ebp
c01041f9:	81 ec d0 00 00 00    	sub    $0xd0,%esp
    struct Page *p = base, *page, *front_merge_p;
c01041ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0104202:	89 45 fc             	mov    %eax,-0x4(%ebp)
    list_entry_t *le = &free_list; 
c0104205:	c7 45 f4 5c 89 11 c0 	movl   $0xc011895c,-0xc(%ebp)
    size_t merge_front = 0, merge_back = 0;
c010420c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0104213:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

#if DEBUG 
    assert( n > 0 );
#endif

    for( ; p != base + n; p++ ) 
c010421a:	eb 1b                	jmp    c0104237 <default_free_pages+0x41>

#if DEBUG
        assert( !PageReserved(p) && !PageProperty(p) );
#endif
        
        p->flags = 0;
c010421c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010421f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref( p, 0 );
c0104226:	6a 00                	push   $0x0
c0104228:	ff 75 fc             	pushl  -0x4(%ebp)
c010422b:	e8 9d fc ff ff       	call   c0103ecd <set_page_ref>
c0104230:	83 c4 08             	add    $0x8,%esp

#if DEBUG 
    assert( n > 0 );
#endif

    for( ; p != base + n; p++ ) 
c0104233:	83 45 fc 14          	addl   $0x14,-0x4(%ebp)
c0104237:	8b 55 0c             	mov    0xc(%ebp),%edx
c010423a:	89 d0                	mov    %edx,%eax
c010423c:	c1 e0 02             	shl    $0x2,%eax
c010423f:	01 d0                	add    %edx,%eax
c0104241:	c1 e0 02             	shl    $0x2,%eax
c0104244:	89 c2                	mov    %eax,%edx
c0104246:	8b 45 08             	mov    0x8(%ebp),%eax
c0104249:	01 d0                	add    %edx,%eax
c010424b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010424e:	75 cc                	jne    c010421c <default_free_pages+0x26>
        
        p->flags = 0;
        set_page_ref( p, 0 );
    }
    
    SetPageProperty(base);
c0104250:	8b 45 08             	mov    0x8(%ebp),%eax
c0104253:	83 c0 04             	add    $0x4,%eax
c0104256:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c010425d:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0104260:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104263:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104266:	0f ab 10             	bts    %edx,(%eax)
    base->property = n; 
c0104269:	8b 45 08             	mov    0x8(%ebp),%eax
c010426c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010426f:	89 50 08             	mov    %edx,0x8(%eax)
c0104272:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104275:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104278:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010427b:	8b 40 04             	mov    0x4(%eax),%eax
    
    if( &free_list == list_next( le ) ) 
c010427e:	3d 5c 89 11 c0       	cmp    $0xc011895c,%eax
c0104283:	0f 85 09 02 00 00    	jne    c0104492 <default_free_pages+0x29c>
    {
        base->flags = 0;
c0104289:	8b 45 08             	mov    0x8(%ebp),%eax
c010428c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(base); 
c0104293:	8b 45 08             	mov    0x8(%ebp),%eax
c0104296:	83 c0 04             	add    $0x4,%eax
c0104299:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c01042a0:	89 45 90             	mov    %eax,-0x70(%ebp)
c01042a3:	8b 45 90             	mov    -0x70(%ebp),%eax
c01042a6:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01042a9:	0f ab 10             	bts    %edx,(%eax)
        list_add( &free_list, &( base->page_link ) );
c01042ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01042af:	83 c0 0c             	add    $0xc,%eax
c01042b2:	c7 45 e4 5c 89 11 c0 	movl   $0xc011895c,-0x1c(%ebp)
c01042b9:	89 45 a8             	mov    %eax,-0x58(%ebp)
c01042bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042bf:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c01042c2:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01042c5:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01042c8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01042cb:	8b 40 04             	mov    0x4(%eax),%eax
c01042ce:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01042d1:	89 55 9c             	mov    %edx,-0x64(%ebp)
c01042d4:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01042d7:	89 55 98             	mov    %edx,-0x68(%ebp)
c01042da:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01042dd:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01042e0:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01042e3:	89 10                	mov    %edx,(%eax)
c01042e5:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01042e8:	8b 10                	mov    (%eax),%edx
c01042ea:	8b 45 98             	mov    -0x68(%ebp),%eax
c01042ed:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01042f0:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01042f3:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01042f6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01042f9:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01042fc:	8b 55 98             	mov    -0x68(%ebp),%edx
c01042ff:	89 10                	mov    %edx,(%eax)
c0104301:	e9 93 03 00 00       	jmp    c0104699 <default_free_pages+0x4a3>
    }
    else
    {
        while( &free_list != ( le = ( list_next( le ) ) ) )
        {
            page = le2page( le, page_link );
c0104306:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104309:	83 e8 0c             	sub    $0xc,%eax
c010430c:	89 45 d0             	mov    %eax,-0x30(%ebp)

            if( base == page + page->property )
c010430f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104312:	8b 50 08             	mov    0x8(%eax),%edx
c0104315:	89 d0                	mov    %edx,%eax
c0104317:	c1 e0 02             	shl    $0x2,%eax
c010431a:	01 d0                	add    %edx,%eax
c010431c:	c1 e0 02             	shl    $0x2,%eax
c010431f:	89 c2                	mov    %eax,%edx
c0104321:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104324:	01 d0                	add    %edx,%eax
c0104326:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104329:	75 28                	jne    c0104353 <default_free_pages+0x15d>
            {
                front_merge_p = page;
c010432b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010432e:	89 45 f8             	mov    %eax,-0x8(%ebp)
                base->flags = 0;
c0104331:	8b 45 08             	mov    0x8(%ebp),%eax
c0104334:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
                page->property += n;
c010433b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010433e:	8b 50 08             	mov    0x8(%eax),%edx
c0104341:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104344:	01 c2                	add    %eax,%edx
c0104346:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104349:	89 50 08             	mov    %edx,0x8(%eax)
                merge_front = 1;
c010434c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            }

            if( page == base + base->property )
c0104353:	8b 45 08             	mov    0x8(%ebp),%eax
c0104356:	8b 50 08             	mov    0x8(%eax),%edx
c0104359:	89 d0                	mov    %edx,%eax
c010435b:	c1 e0 02             	shl    $0x2,%eax
c010435e:	01 d0                	add    %edx,%eax
c0104360:	c1 e0 02             	shl    $0x2,%eax
c0104363:	89 c2                	mov    %eax,%edx
c0104365:	8b 45 08             	mov    0x8(%ebp),%eax
c0104368:	01 d0                	add    %edx,%eax
c010436a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010436d:	0f 85 1f 01 00 00    	jne    c0104492 <default_free_pages+0x29c>
            {
                if( 1 == merge_front )
c0104373:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
c0104377:	75 19                	jne    c0104392 <default_free_pages+0x19c>
                    front_merge_p->property += page->property; 
c0104379:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010437c:	8b 50 08             	mov    0x8(%eax),%edx
c010437f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104382:	8b 40 08             	mov    0x8(%eax),%eax
c0104385:	01 c2                	add    %eax,%edx
c0104387:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010438a:	89 50 08             	mov    %edx,0x8(%eax)
c010438d:	e9 a6 00 00 00       	jmp    c0104438 <default_free_pages+0x242>
                else
                {
                    base->flags = 0;
c0104392:	8b 45 08             	mov    0x8(%ebp),%eax
c0104395:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
                    SetPageProperty(base); 
c010439c:	8b 45 08             	mov    0x8(%ebp),%eax
c010439f:	83 c0 04             	add    $0x4,%eax
c01043a2:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c01043a9:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
c01043af:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
c01043b5:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01043b8:	0f ab 10             	bts    %edx,(%eax)
                    base->property = n + page->property;
c01043bb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01043be:	8b 50 08             	mov    0x8(%eax),%edx
c01043c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043c4:	01 c2                	add    %eax,%edx
c01043c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01043c9:	89 50 08             	mov    %edx,0x8(%eax)
                    list_add( page->page_link.prev, &( base->page_link ) );
c01043cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01043cf:	8d 50 0c             	lea    0xc(%eax),%edx
c01043d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01043d5:	8b 40 0c             	mov    0xc(%eax),%eax
c01043d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01043db:	89 55 8c             	mov    %edx,-0x74(%ebp)
c01043de:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01043e1:	89 45 88             	mov    %eax,-0x78(%ebp)
c01043e4:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01043e7:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01043ea:	8b 45 88             	mov    -0x78(%ebp),%eax
c01043ed:	8b 40 04             	mov    0x4(%eax),%eax
c01043f0:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01043f3:	89 55 80             	mov    %edx,-0x80(%ebp)
c01043f6:	8b 55 88             	mov    -0x78(%ebp),%edx
c01043f9:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c01043ff:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104405:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c010440b:	8b 55 80             	mov    -0x80(%ebp),%edx
c010440e:	89 10                	mov    %edx,(%eax)
c0104410:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0104416:	8b 10                	mov    (%eax),%edx
c0104418:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c010441e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104421:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104424:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
c010442a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010442d:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104430:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0104436:	89 10                	mov    %edx,(%eax)
                }

                page->flags = page->property = 0;
c0104438:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010443b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0104442:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104445:	8b 50 08             	mov    0x8(%eax),%edx
c0104448:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010444b:	89 50 04             	mov    %edx,0x4(%eax)
                list_del( &( page->page_link ) );
c010444e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104451:	83 c0 0c             	add    $0xc,%eax
c0104454:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0104457:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010445a:	8b 40 04             	mov    0x4(%eax),%eax
c010445d:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104460:	8b 12                	mov    (%edx),%edx
c0104462:	89 95 70 ff ff ff    	mov    %edx,-0x90(%ebp)
c0104468:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010446e:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
c0104474:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
c010447a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010447d:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
c0104483:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
c0104489:	89 10                	mov    %edx,(%eax)
                merge_back = 1;
c010448b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c0104492:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104495:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104498:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010449b:	8b 40 04             	mov    0x4(%eax),%eax
        SetPageProperty(base); 
        list_add( &free_list, &( base->page_link ) );
    }
    else
    {
        while( &free_list != ( le = ( list_next( le ) ) ) )
c010449e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01044a1:	81 7d f4 5c 89 11 c0 	cmpl   $0xc011895c,-0xc(%ebp)
c01044a8:	0f 85 58 fe ff ff    	jne    c0104306 <default_free_pages+0x110>
                list_del( &( page->page_link ) );
                merge_back = 1;
            }
        }
        
        if( 1 == merge_front )
c01044ae:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
c01044b2:	75 0f                	jne    c01044c3 <default_free_pages+0x2cd>
            base->property = 0;
c01044b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01044b7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01044be:	e9 d6 01 00 00       	jmp    c0104699 <default_free_pages+0x4a3>
        else if( ( 0 == merge_front ) && ( 0 == merge_back ) )
c01044c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01044c7:	0f 85 cc 01 00 00    	jne    c0104699 <default_free_pages+0x4a3>
c01044cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01044d1:	0f 85 c2 01 00 00    	jne    c0104699 <default_free_pages+0x4a3>
        {
            size_t found = 0;
c01044d7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

            le = &free_list; 
c01044de:	c7 45 f4 5c 89 11 c0 	movl   $0xc011895c,-0xc(%ebp)
            while( &free_list != ( le = ( list_next( le ) ) ) )
c01044e5:	e9 d4 00 00 00       	jmp    c01045be <default_free_pages+0x3c8>
            {
                page = le2page( le, page_link );
c01044ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044ed:	83 e8 0c             	sub    $0xc,%eax
c01044f0:	89 45 d0             	mov    %eax,-0x30(%ebp)

                if( page > base )
c01044f3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01044f6:	3b 45 08             	cmp    0x8(%ebp),%eax
c01044f9:	0f 86 bf 00 00 00    	jbe    c01045be <default_free_pages+0x3c8>
                {
                    base->flags = 0;
c01044ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0104502:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
                    SetPageProperty(base); 
c0104509:	8b 45 08             	mov    0x8(%ebp),%eax
c010450c:	83 c0 04             	add    $0x4,%eax
c010450f:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0104516:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
c010451c:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
c0104522:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104525:	0f ab 10             	bts    %edx,(%eax)
                    list_add( page->page_link.prev, &( base->page_link ) ); 
c0104528:	8b 45 08             	mov    0x8(%ebp),%eax
c010452b:	8d 50 0c             	lea    0xc(%eax),%edx
c010452e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104531:	8b 40 0c             	mov    0xc(%eax),%eax
c0104534:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0104537:	89 95 68 ff ff ff    	mov    %edx,-0x98(%ebp)
c010453d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104540:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
c0104546:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
c010454c:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0104552:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
c0104558:	8b 40 04             	mov    0x4(%eax),%eax
c010455b:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
c0104561:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
c0104567:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
c010456d:	89 95 58 ff ff ff    	mov    %edx,-0xa8(%ebp)
c0104573:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104579:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
c010457f:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
c0104585:	89 10                	mov    %edx,(%eax)
c0104587:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
c010458d:	8b 10                	mov    (%eax),%edx
c010458f:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
c0104595:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104598:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
c010459e:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
c01045a4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01045a7:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
c01045ad:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
c01045b3:	89 10                	mov    %edx,(%eax)
                    found = 1;
c01045b5:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
                    break;
c01045bc:	eb 1c                	jmp    c01045da <default_free_pages+0x3e4>
c01045be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045c1:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01045c4:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01045c7:	8b 40 04             	mov    0x4(%eax),%eax
        else if( ( 0 == merge_front ) && ( 0 == merge_back ) )
        {
            size_t found = 0;

            le = &free_list; 
            while( &free_list != ( le = ( list_next( le ) ) ) )
c01045ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01045cd:	81 7d f4 5c 89 11 c0 	cmpl   $0xc011895c,-0xc(%ebp)
c01045d4:	0f 85 10 ff ff ff    	jne    c01044ea <default_free_pages+0x2f4>
                    found = 1;
                    break;
                }
            }

            if( 0 == found )
c01045da:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01045de:	0f 85 b5 00 00 00    	jne    c0104699 <default_free_pages+0x4a3>
            {
                base->flags = 0;
c01045e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01045e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
                SetPageProperty(base); 
c01045ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01045f1:	83 c0 04             	add    $0x4,%eax
c01045f4:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c01045fb:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
c0104601:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
c0104607:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010460a:	0f ab 10             	bts    %edx,(%eax)
                list_add( free_list.prev, &( base->page_link ) ); 
c010460d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104610:	8d 50 0c             	lea    0xc(%eax),%edx
c0104613:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0104618:	89 45 c0             	mov    %eax,-0x40(%ebp)
c010461b:	89 95 4c ff ff ff    	mov    %edx,-0xb4(%ebp)
c0104621:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104624:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
c010462a:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
c0104630:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0104636:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
c010463c:	8b 40 04             	mov    0x4(%eax),%eax
c010463f:	8b 95 44 ff ff ff    	mov    -0xbc(%ebp),%edx
c0104645:	89 95 40 ff ff ff    	mov    %edx,-0xc0(%ebp)
c010464b:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
c0104651:	89 95 3c ff ff ff    	mov    %edx,-0xc4(%ebp)
c0104657:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010465d:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
c0104663:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
c0104669:	89 10                	mov    %edx,(%eax)
c010466b:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
c0104671:	8b 10                	mov    (%eax),%edx
c0104673:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
c0104679:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010467c:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
c0104682:	8b 95 38 ff ff ff    	mov    -0xc8(%ebp),%edx
c0104688:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010468b:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
c0104691:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
c0104697:	89 10                	mov    %edx,(%eax)
            }
        }
    }

    nr_free += n;
c0104699:	8b 15 64 89 11 c0    	mov    0xc0118964,%edx
c010469f:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046a2:	01 d0                	add    %edx,%eax
c01046a4:	a3 64 89 11 c0       	mov    %eax,0xc0118964
}
c01046a9:	90                   	nop
c01046aa:	c9                   	leave  
c01046ab:	c3                   	ret    

c01046ac <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c01046ac:	55                   	push   %ebp
c01046ad:	89 e5                	mov    %esp,%ebp
    return nr_free;
c01046af:	a1 64 89 11 c0       	mov    0xc0118964,%eax
}
c01046b4:	5d                   	pop    %ebp
c01046b5:	c3                   	ret    

c01046b6 <basic_check>:

static void
basic_check(void) {
c01046b6:	55                   	push   %ebp
c01046b7:	89 e5                	mov    %esp,%ebp
c01046b9:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c01046bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01046c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01046c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01046cf:	83 ec 0c             	sub    $0xc,%esp
c01046d2:	6a 01                	push   $0x1
c01046d4:	e8 89 e4 ff ff       	call   c0102b62 <alloc_pages>
c01046d9:	83 c4 10             	add    $0x10,%esp
c01046dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01046df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01046e3:	75 19                	jne    c01046fe <basic_check+0x48>
c01046e5:	68 6c 69 10 c0       	push   $0xc010696c
c01046ea:	68 88 69 10 c0       	push   $0xc0106988
c01046ef:	68 f5 00 00 00       	push   $0xf5
c01046f4:	68 9d 69 10 c0       	push   $0xc010699d
c01046f9:	e8 cf bc ff ff       	call   c01003cd <__panic>
    assert((p1 = alloc_page()) != NULL);
c01046fe:	83 ec 0c             	sub    $0xc,%esp
c0104701:	6a 01                	push   $0x1
c0104703:	e8 5a e4 ff ff       	call   c0102b62 <alloc_pages>
c0104708:	83 c4 10             	add    $0x10,%esp
c010470b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010470e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104712:	75 19                	jne    c010472d <basic_check+0x77>
c0104714:	68 b3 69 10 c0       	push   $0xc01069b3
c0104719:	68 88 69 10 c0       	push   $0xc0106988
c010471e:	68 f6 00 00 00       	push   $0xf6
c0104723:	68 9d 69 10 c0       	push   $0xc010699d
c0104728:	e8 a0 bc ff ff       	call   c01003cd <__panic>
    assert((p2 = alloc_page()) != NULL);
c010472d:	83 ec 0c             	sub    $0xc,%esp
c0104730:	6a 01                	push   $0x1
c0104732:	e8 2b e4 ff ff       	call   c0102b62 <alloc_pages>
c0104737:	83 c4 10             	add    $0x10,%esp
c010473a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010473d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104741:	75 19                	jne    c010475c <basic_check+0xa6>
c0104743:	68 cf 69 10 c0       	push   $0xc01069cf
c0104748:	68 88 69 10 c0       	push   $0xc0106988
c010474d:	68 f7 00 00 00       	push   $0xf7
c0104752:	68 9d 69 10 c0       	push   $0xc010699d
c0104757:	e8 71 bc ff ff       	call   c01003cd <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c010475c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010475f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104762:	74 10                	je     c0104774 <basic_check+0xbe>
c0104764:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104767:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010476a:	74 08                	je     c0104774 <basic_check+0xbe>
c010476c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010476f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104772:	75 19                	jne    c010478d <basic_check+0xd7>
c0104774:	68 ec 69 10 c0       	push   $0xc01069ec
c0104779:	68 88 69 10 c0       	push   $0xc0106988
c010477e:	68 f9 00 00 00       	push   $0xf9
c0104783:	68 9d 69 10 c0       	push   $0xc010699d
c0104788:	e8 40 bc ff ff       	call   c01003cd <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c010478d:	83 ec 0c             	sub    $0xc,%esp
c0104790:	ff 75 ec             	pushl  -0x14(%ebp)
c0104793:	e8 2b f7 ff ff       	call   c0103ec3 <page_ref>
c0104798:	83 c4 10             	add    $0x10,%esp
c010479b:	85 c0                	test   %eax,%eax
c010479d:	75 24                	jne    c01047c3 <basic_check+0x10d>
c010479f:	83 ec 0c             	sub    $0xc,%esp
c01047a2:	ff 75 f0             	pushl  -0x10(%ebp)
c01047a5:	e8 19 f7 ff ff       	call   c0103ec3 <page_ref>
c01047aa:	83 c4 10             	add    $0x10,%esp
c01047ad:	85 c0                	test   %eax,%eax
c01047af:	75 12                	jne    c01047c3 <basic_check+0x10d>
c01047b1:	83 ec 0c             	sub    $0xc,%esp
c01047b4:	ff 75 f4             	pushl  -0xc(%ebp)
c01047b7:	e8 07 f7 ff ff       	call   c0103ec3 <page_ref>
c01047bc:	83 c4 10             	add    $0x10,%esp
c01047bf:	85 c0                	test   %eax,%eax
c01047c1:	74 19                	je     c01047dc <basic_check+0x126>
c01047c3:	68 10 6a 10 c0       	push   $0xc0106a10
c01047c8:	68 88 69 10 c0       	push   $0xc0106988
c01047cd:	68 fa 00 00 00       	push   $0xfa
c01047d2:	68 9d 69 10 c0       	push   $0xc010699d
c01047d7:	e8 f1 bb ff ff       	call   c01003cd <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c01047dc:	83 ec 0c             	sub    $0xc,%esp
c01047df:	ff 75 ec             	pushl  -0x14(%ebp)
c01047e2:	e8 c9 f6 ff ff       	call   c0103eb0 <page2pa>
c01047e7:	83 c4 10             	add    $0x10,%esp
c01047ea:	89 c2                	mov    %eax,%edx
c01047ec:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01047f1:	c1 e0 0c             	shl    $0xc,%eax
c01047f4:	39 c2                	cmp    %eax,%edx
c01047f6:	72 19                	jb     c0104811 <basic_check+0x15b>
c01047f8:	68 4c 6a 10 c0       	push   $0xc0106a4c
c01047fd:	68 88 69 10 c0       	push   $0xc0106988
c0104802:	68 fc 00 00 00       	push   $0xfc
c0104807:	68 9d 69 10 c0       	push   $0xc010699d
c010480c:	e8 bc bb ff ff       	call   c01003cd <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0104811:	83 ec 0c             	sub    $0xc,%esp
c0104814:	ff 75 f0             	pushl  -0x10(%ebp)
c0104817:	e8 94 f6 ff ff       	call   c0103eb0 <page2pa>
c010481c:	83 c4 10             	add    $0x10,%esp
c010481f:	89 c2                	mov    %eax,%edx
c0104821:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104826:	c1 e0 0c             	shl    $0xc,%eax
c0104829:	39 c2                	cmp    %eax,%edx
c010482b:	72 19                	jb     c0104846 <basic_check+0x190>
c010482d:	68 69 6a 10 c0       	push   $0xc0106a69
c0104832:	68 88 69 10 c0       	push   $0xc0106988
c0104837:	68 fd 00 00 00       	push   $0xfd
c010483c:	68 9d 69 10 c0       	push   $0xc010699d
c0104841:	e8 87 bb ff ff       	call   c01003cd <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0104846:	83 ec 0c             	sub    $0xc,%esp
c0104849:	ff 75 f4             	pushl  -0xc(%ebp)
c010484c:	e8 5f f6 ff ff       	call   c0103eb0 <page2pa>
c0104851:	83 c4 10             	add    $0x10,%esp
c0104854:	89 c2                	mov    %eax,%edx
c0104856:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010485b:	c1 e0 0c             	shl    $0xc,%eax
c010485e:	39 c2                	cmp    %eax,%edx
c0104860:	72 19                	jb     c010487b <basic_check+0x1c5>
c0104862:	68 86 6a 10 c0       	push   $0xc0106a86
c0104867:	68 88 69 10 c0       	push   $0xc0106988
c010486c:	68 fe 00 00 00       	push   $0xfe
c0104871:	68 9d 69 10 c0       	push   $0xc010699d
c0104876:	e8 52 bb ff ff       	call   c01003cd <__panic>

    list_entry_t free_list_store = free_list;
c010487b:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0104880:	8b 15 60 89 11 c0    	mov    0xc0118960,%edx
c0104886:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104889:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010488c:	c7 45 e4 5c 89 11 c0 	movl   $0xc011895c,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104893:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104896:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104899:	89 50 04             	mov    %edx,0x4(%eax)
c010489c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010489f:	8b 50 04             	mov    0x4(%eax),%edx
c01048a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01048a5:	89 10                	mov    %edx,(%eax)
c01048a7:	c7 45 d8 5c 89 11 c0 	movl   $0xc011895c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01048ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01048b1:	8b 40 04             	mov    0x4(%eax),%eax
c01048b4:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01048b7:	0f 94 c0             	sete   %al
c01048ba:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01048bd:	85 c0                	test   %eax,%eax
c01048bf:	75 19                	jne    c01048da <basic_check+0x224>
c01048c1:	68 a3 6a 10 c0       	push   $0xc0106aa3
c01048c6:	68 88 69 10 c0       	push   $0xc0106988
c01048cb:	68 02 01 00 00       	push   $0x102
c01048d0:	68 9d 69 10 c0       	push   $0xc010699d
c01048d5:	e8 f3 ba ff ff       	call   c01003cd <__panic>

    unsigned int nr_free_store = nr_free;
c01048da:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c01048df:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01048e2:	c7 05 64 89 11 c0 00 	movl   $0x0,0xc0118964
c01048e9:	00 00 00 
    assert(alloc_page() == NULL);
c01048ec:	83 ec 0c             	sub    $0xc,%esp
c01048ef:	6a 01                	push   $0x1
c01048f1:	e8 6c e2 ff ff       	call   c0102b62 <alloc_pages>
c01048f6:	83 c4 10             	add    $0x10,%esp
c01048f9:	85 c0                	test   %eax,%eax
c01048fb:	74 19                	je     c0104916 <basic_check+0x260>
c01048fd:	68 ba 6a 10 c0       	push   $0xc0106aba
c0104902:	68 88 69 10 c0       	push   $0xc0106988
c0104907:	68 06 01 00 00       	push   $0x106
c010490c:	68 9d 69 10 c0       	push   $0xc010699d
c0104911:	e8 b7 ba ff ff       	call   c01003cd <__panic>
    
    free_page(p0);
c0104916:	83 ec 08             	sub    $0x8,%esp
c0104919:	6a 01                	push   $0x1
c010491b:	ff 75 ec             	pushl  -0x14(%ebp)
c010491e:	e8 7d e2 ff ff       	call   c0102ba0 <free_pages>
c0104923:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0104926:	83 ec 08             	sub    $0x8,%esp
c0104929:	6a 01                	push   $0x1
c010492b:	ff 75 f0             	pushl  -0x10(%ebp)
c010492e:	e8 6d e2 ff ff       	call   c0102ba0 <free_pages>
c0104933:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104936:	83 ec 08             	sub    $0x8,%esp
c0104939:	6a 01                	push   $0x1
c010493b:	ff 75 f4             	pushl  -0xc(%ebp)
c010493e:	e8 5d e2 ff ff       	call   c0102ba0 <free_pages>
c0104943:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c0104946:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c010494b:	83 f8 03             	cmp    $0x3,%eax
c010494e:	74 19                	je     c0104969 <basic_check+0x2b3>
c0104950:	68 cf 6a 10 c0       	push   $0xc0106acf
c0104955:	68 88 69 10 c0       	push   $0xc0106988
c010495a:	68 0b 01 00 00       	push   $0x10b
c010495f:	68 9d 69 10 c0       	push   $0xc010699d
c0104964:	e8 64 ba ff ff       	call   c01003cd <__panic>
    
    assert((p0 = alloc_page()) != NULL);
c0104969:	83 ec 0c             	sub    $0xc,%esp
c010496c:	6a 01                	push   $0x1
c010496e:	e8 ef e1 ff ff       	call   c0102b62 <alloc_pages>
c0104973:	83 c4 10             	add    $0x10,%esp
c0104976:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104979:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010497d:	75 19                	jne    c0104998 <basic_check+0x2e2>
c010497f:	68 6c 69 10 c0       	push   $0xc010696c
c0104984:	68 88 69 10 c0       	push   $0xc0106988
c0104989:	68 0d 01 00 00       	push   $0x10d
c010498e:	68 9d 69 10 c0       	push   $0xc010699d
c0104993:	e8 35 ba ff ff       	call   c01003cd <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104998:	83 ec 0c             	sub    $0xc,%esp
c010499b:	6a 01                	push   $0x1
c010499d:	e8 c0 e1 ff ff       	call   c0102b62 <alloc_pages>
c01049a2:	83 c4 10             	add    $0x10,%esp
c01049a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01049a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01049ac:	75 19                	jne    c01049c7 <basic_check+0x311>
c01049ae:	68 b3 69 10 c0       	push   $0xc01069b3
c01049b3:	68 88 69 10 c0       	push   $0xc0106988
c01049b8:	68 0e 01 00 00       	push   $0x10e
c01049bd:	68 9d 69 10 c0       	push   $0xc010699d
c01049c2:	e8 06 ba ff ff       	call   c01003cd <__panic>
    assert((p2 = alloc_page()) != NULL);
c01049c7:	83 ec 0c             	sub    $0xc,%esp
c01049ca:	6a 01                	push   $0x1
c01049cc:	e8 91 e1 ff ff       	call   c0102b62 <alloc_pages>
c01049d1:	83 c4 10             	add    $0x10,%esp
c01049d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01049d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01049db:	75 19                	jne    c01049f6 <basic_check+0x340>
c01049dd:	68 cf 69 10 c0       	push   $0xc01069cf
c01049e2:	68 88 69 10 c0       	push   $0xc0106988
c01049e7:	68 0f 01 00 00       	push   $0x10f
c01049ec:	68 9d 69 10 c0       	push   $0xc010699d
c01049f1:	e8 d7 b9 ff ff       	call   c01003cd <__panic>
    assert(alloc_page() == NULL);
c01049f6:	83 ec 0c             	sub    $0xc,%esp
c01049f9:	6a 01                	push   $0x1
c01049fb:	e8 62 e1 ff ff       	call   c0102b62 <alloc_pages>
c0104a00:	83 c4 10             	add    $0x10,%esp
c0104a03:	85 c0                	test   %eax,%eax
c0104a05:	74 19                	je     c0104a20 <basic_check+0x36a>
c0104a07:	68 ba 6a 10 c0       	push   $0xc0106aba
c0104a0c:	68 88 69 10 c0       	push   $0xc0106988
c0104a11:	68 10 01 00 00       	push   $0x110
c0104a16:	68 9d 69 10 c0       	push   $0xc010699d
c0104a1b:	e8 ad b9 ff ff       	call   c01003cd <__panic>
    free_page(p0);
c0104a20:	83 ec 08             	sub    $0x8,%esp
c0104a23:	6a 01                	push   $0x1
c0104a25:	ff 75 ec             	pushl  -0x14(%ebp)
c0104a28:	e8 73 e1 ff ff       	call   c0102ba0 <free_pages>
c0104a2d:	83 c4 10             	add    $0x10,%esp
c0104a30:	c7 45 e8 5c 89 11 c0 	movl   $0xc011895c,-0x18(%ebp)
c0104a37:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104a3a:	8b 40 04             	mov    0x4(%eax),%eax
c0104a3d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104a40:	0f 94 c0             	sete   %al
c0104a43:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0104a46:	85 c0                	test   %eax,%eax
c0104a48:	74 19                	je     c0104a63 <basic_check+0x3ad>
c0104a4a:	68 dc 6a 10 c0       	push   $0xc0106adc
c0104a4f:	68 88 69 10 c0       	push   $0xc0106988
c0104a54:	68 12 01 00 00       	push   $0x112
c0104a59:	68 9d 69 10 c0       	push   $0xc010699d
c0104a5e:	e8 6a b9 ff ff       	call   c01003cd <__panic>
    
    struct Page *p;
    assert((p = alloc_page()) == p0);
c0104a63:	83 ec 0c             	sub    $0xc,%esp
c0104a66:	6a 01                	push   $0x1
c0104a68:	e8 f5 e0 ff ff       	call   c0102b62 <alloc_pages>
c0104a6d:	83 c4 10             	add    $0x10,%esp
c0104a70:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104a73:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104a76:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104a79:	74 19                	je     c0104a94 <basic_check+0x3de>
c0104a7b:	68 f4 6a 10 c0       	push   $0xc0106af4
c0104a80:	68 88 69 10 c0       	push   $0xc0106988
c0104a85:	68 15 01 00 00       	push   $0x115
c0104a8a:	68 9d 69 10 c0       	push   $0xc010699d
c0104a8f:	e8 39 b9 ff ff       	call   c01003cd <__panic>
    assert(alloc_page() == NULL);
c0104a94:	83 ec 0c             	sub    $0xc,%esp
c0104a97:	6a 01                	push   $0x1
c0104a99:	e8 c4 e0 ff ff       	call   c0102b62 <alloc_pages>
c0104a9e:	83 c4 10             	add    $0x10,%esp
c0104aa1:	85 c0                	test   %eax,%eax
c0104aa3:	74 19                	je     c0104abe <basic_check+0x408>
c0104aa5:	68 ba 6a 10 c0       	push   $0xc0106aba
c0104aaa:	68 88 69 10 c0       	push   $0xc0106988
c0104aaf:	68 16 01 00 00       	push   $0x116
c0104ab4:	68 9d 69 10 c0       	push   $0xc010699d
c0104ab9:	e8 0f b9 ff ff       	call   c01003cd <__panic>
    assert(nr_free == 0);
c0104abe:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104ac3:	85 c0                	test   %eax,%eax
c0104ac5:	74 19                	je     c0104ae0 <basic_check+0x42a>
c0104ac7:	68 0d 6b 10 c0       	push   $0xc0106b0d
c0104acc:	68 88 69 10 c0       	push   $0xc0106988
c0104ad1:	68 17 01 00 00       	push   $0x117
c0104ad6:	68 9d 69 10 c0       	push   $0xc010699d
c0104adb:	e8 ed b8 ff ff       	call   c01003cd <__panic>
    free_list = free_list_store;
c0104ae0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104ae3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104ae6:	a3 5c 89 11 c0       	mov    %eax,0xc011895c
c0104aeb:	89 15 60 89 11 c0    	mov    %edx,0xc0118960
    nr_free = nr_free_store;
c0104af1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104af4:	a3 64 89 11 c0       	mov    %eax,0xc0118964
    free_page(p);
c0104af9:	83 ec 08             	sub    $0x8,%esp
c0104afc:	6a 01                	push   $0x1
c0104afe:	ff 75 dc             	pushl  -0x24(%ebp)
c0104b01:	e8 9a e0 ff ff       	call   c0102ba0 <free_pages>
c0104b06:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0104b09:	83 ec 08             	sub    $0x8,%esp
c0104b0c:	6a 01                	push   $0x1
c0104b0e:	ff 75 f0             	pushl  -0x10(%ebp)
c0104b11:	e8 8a e0 ff ff       	call   c0102ba0 <free_pages>
c0104b16:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104b19:	83 ec 08             	sub    $0x8,%esp
c0104b1c:	6a 01                	push   $0x1
c0104b1e:	ff 75 f4             	pushl  -0xc(%ebp)
c0104b21:	e8 7a e0 ff ff       	call   c0102ba0 <free_pages>
c0104b26:	83 c4 10             	add    $0x10,%esp
}
c0104b29:	90                   	nop
c0104b2a:	c9                   	leave  
c0104b2b:	c3                   	ret    

c0104b2c <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104b2c:	55                   	push   %ebp
c0104b2d:	89 e5                	mov    %esp,%ebp
c0104b2f:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
c0104b35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104b3c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104b43:	c7 45 ec 5c 89 11 c0 	movl   $0xc011895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104b4a:	eb 60                	jmp    c0104bac <default_check+0x80>
        struct Page *p = le2page(le, page_link);
c0104b4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b4f:	83 e8 0c             	sub    $0xc,%eax
c0104b52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0104b55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b58:	83 c0 04             	add    $0x4,%eax
c0104b5b:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0104b62:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104b65:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104b68:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104b6b:	0f a3 10             	bt     %edx,(%eax)
c0104b6e:	19 c0                	sbb    %eax,%eax
c0104b70:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c0104b73:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c0104b77:	0f 95 c0             	setne  %al
c0104b7a:	0f b6 c0             	movzbl %al,%eax
c0104b7d:	85 c0                	test   %eax,%eax
c0104b7f:	75 19                	jne    c0104b9a <default_check+0x6e>
c0104b81:	68 1a 6b 10 c0       	push   $0xc0106b1a
c0104b86:	68 88 69 10 c0       	push   $0xc0106988
c0104b8b:	68 27 01 00 00       	push   $0x127
c0104b90:	68 9d 69 10 c0       	push   $0xc010699d
c0104b95:	e8 33 b8 ff ff       	call   c01003cd <__panic>
        count++, total += p->property;
c0104b9a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104b9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ba1:	8b 50 08             	mov    0x8(%eax),%edx
c0104ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ba7:	01 d0                	add    %edx,%eax
c0104ba9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104bac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104baf:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104bb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104bb5:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104bb8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104bbb:	81 7d ec 5c 89 11 c0 	cmpl   $0xc011895c,-0x14(%ebp)
c0104bc2:	75 88                	jne    c0104b4c <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count++, total += p->property;
    }
    assert(total == nr_free_pages());
c0104bc4:	e8 0c e0 ff ff       	call   c0102bd5 <nr_free_pages>
c0104bc9:	89 c2                	mov    %eax,%edx
c0104bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bce:	39 c2                	cmp    %eax,%edx
c0104bd0:	74 19                	je     c0104beb <default_check+0xbf>
c0104bd2:	68 2a 6b 10 c0       	push   $0xc0106b2a
c0104bd7:	68 88 69 10 c0       	push   $0xc0106988
c0104bdc:	68 2a 01 00 00       	push   $0x12a
c0104be1:	68 9d 69 10 c0       	push   $0xc010699d
c0104be6:	e8 e2 b7 ff ff       	call   c01003cd <__panic>

    basic_check();
c0104beb:	e8 c6 fa ff ff       	call   c01046b6 <basic_check>
    display_free_list();
c0104bf0:	e8 e6 f2 ff ff       	call   c0103edb <display_free_list>
    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0104bf5:	83 ec 0c             	sub    $0xc,%esp
c0104bf8:	6a 05                	push   $0x5
c0104bfa:	e8 63 df ff ff       	call   c0102b62 <alloc_pages>
c0104bff:	83 c4 10             	add    $0x10,%esp
c0104c02:	89 45 dc             	mov    %eax,-0x24(%ebp)
    
    assert(p0 != NULL);
c0104c05:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104c09:	75 19                	jne    c0104c24 <default_check+0xf8>
c0104c0b:	68 43 6b 10 c0       	push   $0xc0106b43
c0104c10:	68 88 69 10 c0       	push   $0xc0106988
c0104c15:	68 30 01 00 00       	push   $0x130
c0104c1a:	68 9d 69 10 c0       	push   $0xc010699d
c0104c1f:	e8 a9 b7 ff ff       	call   c01003cd <__panic>
    assert(!PageProperty(p0));
c0104c24:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104c27:	83 c0 04             	add    $0x4,%eax
c0104c2a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c0104c31:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104c34:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104c37:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104c3a:	0f a3 10             	bt     %edx,(%eax)
c0104c3d:	19 c0                	sbb    %eax,%eax
c0104c3f:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c0104c42:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c0104c46:	0f 95 c0             	setne  %al
c0104c49:	0f b6 c0             	movzbl %al,%eax
c0104c4c:	85 c0                	test   %eax,%eax
c0104c4e:	74 19                	je     c0104c69 <default_check+0x13d>
c0104c50:	68 4e 6b 10 c0       	push   $0xc0106b4e
c0104c55:	68 88 69 10 c0       	push   $0xc0106988
c0104c5a:	68 31 01 00 00       	push   $0x131
c0104c5f:	68 9d 69 10 c0       	push   $0xc010699d
c0104c64:	e8 64 b7 ff ff       	call   c01003cd <__panic>

    list_entry_t free_list_store = free_list;
c0104c69:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0104c6e:	8b 15 60 89 11 c0    	mov    0xc0118960,%edx
c0104c74:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104c77:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104c7a:	c7 45 d0 5c 89 11 c0 	movl   $0xc011895c,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104c81:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104c84:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104c87:	89 50 04             	mov    %edx,0x4(%eax)
c0104c8a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104c8d:	8b 50 04             	mov    0x4(%eax),%edx
c0104c90:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104c93:	89 10                	mov    %edx,(%eax)
c0104c95:	c7 45 d8 5c 89 11 c0 	movl   $0xc011895c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0104c9c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104c9f:	8b 40 04             	mov    0x4(%eax),%eax
c0104ca2:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104ca5:	0f 94 c0             	sete   %al
c0104ca8:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104cab:	85 c0                	test   %eax,%eax
c0104cad:	75 19                	jne    c0104cc8 <default_check+0x19c>
c0104caf:	68 a3 6a 10 c0       	push   $0xc0106aa3
c0104cb4:	68 88 69 10 c0       	push   $0xc0106988
c0104cb9:	68 35 01 00 00       	push   $0x135
c0104cbe:	68 9d 69 10 c0       	push   $0xc010699d
c0104cc3:	e8 05 b7 ff ff       	call   c01003cd <__panic>
    assert(alloc_page() == NULL);
c0104cc8:	83 ec 0c             	sub    $0xc,%esp
c0104ccb:	6a 01                	push   $0x1
c0104ccd:	e8 90 de ff ff       	call   c0102b62 <alloc_pages>
c0104cd2:	83 c4 10             	add    $0x10,%esp
c0104cd5:	85 c0                	test   %eax,%eax
c0104cd7:	74 19                	je     c0104cf2 <default_check+0x1c6>
c0104cd9:	68 ba 6a 10 c0       	push   $0xc0106aba
c0104cde:	68 88 69 10 c0       	push   $0xc0106988
c0104ce3:	68 36 01 00 00       	push   $0x136
c0104ce8:	68 9d 69 10 c0       	push   $0xc010699d
c0104ced:	e8 db b6 ff ff       	call   c01003cd <__panic>

    unsigned int nr_free_store = nr_free;
c0104cf2:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104cf7:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
c0104cfa:	c7 05 64 89 11 c0 00 	movl   $0x0,0xc0118964
c0104d01:	00 00 00 

    free_pages(p0 + 2, 3);
c0104d04:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104d07:	83 c0 28             	add    $0x28,%eax
c0104d0a:	83 ec 08             	sub    $0x8,%esp
c0104d0d:	6a 03                	push   $0x3
c0104d0f:	50                   	push   %eax
c0104d10:	e8 8b de ff ff       	call   c0102ba0 <free_pages>
c0104d15:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c0104d18:	83 ec 0c             	sub    $0xc,%esp
c0104d1b:	6a 04                	push   $0x4
c0104d1d:	e8 40 de ff ff       	call   c0102b62 <alloc_pages>
c0104d22:	83 c4 10             	add    $0x10,%esp
c0104d25:	85 c0                	test   %eax,%eax
c0104d27:	74 19                	je     c0104d42 <default_check+0x216>
c0104d29:	68 60 6b 10 c0       	push   $0xc0106b60
c0104d2e:	68 88 69 10 c0       	push   $0xc0106988
c0104d33:	68 3c 01 00 00       	push   $0x13c
c0104d38:	68 9d 69 10 c0       	push   $0xc010699d
c0104d3d:	e8 8b b6 ff ff       	call   c01003cd <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104d42:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104d45:	83 c0 28             	add    $0x28,%eax
c0104d48:	83 c0 04             	add    $0x4,%eax
c0104d4b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0104d52:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104d55:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104d58:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104d5b:	0f a3 10             	bt     %edx,(%eax)
c0104d5e:	19 c0                	sbb    %eax,%eax
c0104d60:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0104d63:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104d67:	0f 95 c0             	setne  %al
c0104d6a:	0f b6 c0             	movzbl %al,%eax
c0104d6d:	85 c0                	test   %eax,%eax
c0104d6f:	74 0e                	je     c0104d7f <default_check+0x253>
c0104d71:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104d74:	83 c0 28             	add    $0x28,%eax
c0104d77:	8b 40 08             	mov    0x8(%eax),%eax
c0104d7a:	83 f8 03             	cmp    $0x3,%eax
c0104d7d:	74 19                	je     c0104d98 <default_check+0x26c>
c0104d7f:	68 78 6b 10 c0       	push   $0xc0106b78
c0104d84:	68 88 69 10 c0       	push   $0xc0106988
c0104d89:	68 3d 01 00 00       	push   $0x13d
c0104d8e:	68 9d 69 10 c0       	push   $0xc010699d
c0104d93:	e8 35 b6 ff ff       	call   c01003cd <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104d98:	83 ec 0c             	sub    $0xc,%esp
c0104d9b:	6a 03                	push   $0x3
c0104d9d:	e8 c0 dd ff ff       	call   c0102b62 <alloc_pages>
c0104da2:	83 c4 10             	add    $0x10,%esp
c0104da5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0104da8:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0104dac:	75 19                	jne    c0104dc7 <default_check+0x29b>
c0104dae:	68 a4 6b 10 c0       	push   $0xc0106ba4
c0104db3:	68 88 69 10 c0       	push   $0xc0106988
c0104db8:	68 3e 01 00 00       	push   $0x13e
c0104dbd:	68 9d 69 10 c0       	push   $0xc010699d
c0104dc2:	e8 06 b6 ff ff       	call   c01003cd <__panic>
    assert(alloc_page() == NULL);
c0104dc7:	83 ec 0c             	sub    $0xc,%esp
c0104dca:	6a 01                	push   $0x1
c0104dcc:	e8 91 dd ff ff       	call   c0102b62 <alloc_pages>
c0104dd1:	83 c4 10             	add    $0x10,%esp
c0104dd4:	85 c0                	test   %eax,%eax
c0104dd6:	74 19                	je     c0104df1 <default_check+0x2c5>
c0104dd8:	68 ba 6a 10 c0       	push   $0xc0106aba
c0104ddd:	68 88 69 10 c0       	push   $0xc0106988
c0104de2:	68 3f 01 00 00       	push   $0x13f
c0104de7:	68 9d 69 10 c0       	push   $0xc010699d
c0104dec:	e8 dc b5 ff ff       	call   c01003cd <__panic>
    assert(p0 + 2 == p1);
c0104df1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104df4:	83 c0 28             	add    $0x28,%eax
c0104df7:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
c0104dfa:	74 19                	je     c0104e15 <default_check+0x2e9>
c0104dfc:	68 c2 6b 10 c0       	push   $0xc0106bc2
c0104e01:	68 88 69 10 c0       	push   $0xc0106988
c0104e06:	68 40 01 00 00       	push   $0x140
c0104e0b:	68 9d 69 10 c0       	push   $0xc010699d
c0104e10:	e8 b8 b5 ff ff       	call   c01003cd <__panic>

    p2 = p0 + 1;
c0104e15:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104e18:	83 c0 14             	add    $0x14,%eax
c0104e1b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
c0104e1e:	83 ec 08             	sub    $0x8,%esp
c0104e21:	6a 01                	push   $0x1
c0104e23:	ff 75 dc             	pushl  -0x24(%ebp)
c0104e26:	e8 75 dd ff ff       	call   c0102ba0 <free_pages>
c0104e2b:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c0104e2e:	83 ec 08             	sub    $0x8,%esp
c0104e31:	6a 03                	push   $0x3
c0104e33:	ff 75 c4             	pushl  -0x3c(%ebp)
c0104e36:	e8 65 dd ff ff       	call   c0102ba0 <free_pages>
c0104e3b:	83 c4 10             	add    $0x10,%esp
    display_free_list();
c0104e3e:	e8 98 f0 ff ff       	call   c0103edb <display_free_list>
    assert(PageProperty(p0) && p0->property == 1);
c0104e43:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104e46:	83 c0 04             	add    $0x4,%eax
c0104e49:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0104e50:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104e53:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104e56:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104e59:	0f a3 10             	bt     %edx,(%eax)
c0104e5c:	19 c0                	sbb    %eax,%eax
c0104e5e:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
c0104e61:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
c0104e65:	0f 95 c0             	setne  %al
c0104e68:	0f b6 c0             	movzbl %al,%eax
c0104e6b:	85 c0                	test   %eax,%eax
c0104e6d:	74 0b                	je     c0104e7a <default_check+0x34e>
c0104e6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104e72:	8b 40 08             	mov    0x8(%eax),%eax
c0104e75:	83 f8 01             	cmp    $0x1,%eax
c0104e78:	74 19                	je     c0104e93 <default_check+0x367>
c0104e7a:	68 d0 6b 10 c0       	push   $0xc0106bd0
c0104e7f:	68 88 69 10 c0       	push   $0xc0106988
c0104e84:	68 46 01 00 00       	push   $0x146
c0104e89:	68 9d 69 10 c0       	push   $0xc010699d
c0104e8e:	e8 3a b5 ff ff       	call   c01003cd <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104e93:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104e96:	83 c0 04             	add    $0x4,%eax
c0104e99:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0104ea0:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104ea3:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104ea6:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104ea9:	0f a3 10             	bt     %edx,(%eax)
c0104eac:	19 c0                	sbb    %eax,%eax
c0104eae:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
c0104eb1:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
c0104eb5:	0f 95 c0             	setne  %al
c0104eb8:	0f b6 c0             	movzbl %al,%eax
c0104ebb:	85 c0                	test   %eax,%eax
c0104ebd:	74 0b                	je     c0104eca <default_check+0x39e>
c0104ebf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104ec2:	8b 40 08             	mov    0x8(%eax),%eax
c0104ec5:	83 f8 03             	cmp    $0x3,%eax
c0104ec8:	74 19                	je     c0104ee3 <default_check+0x3b7>
c0104eca:	68 f8 6b 10 c0       	push   $0xc0106bf8
c0104ecf:	68 88 69 10 c0       	push   $0xc0106988
c0104ed4:	68 47 01 00 00       	push   $0x147
c0104ed9:	68 9d 69 10 c0       	push   $0xc010699d
c0104ede:	e8 ea b4 ff ff       	call   c01003cd <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104ee3:	83 ec 0c             	sub    $0xc,%esp
c0104ee6:	6a 01                	push   $0x1
c0104ee8:	e8 75 dc ff ff       	call   c0102b62 <alloc_pages>
c0104eed:	83 c4 10             	add    $0x10,%esp
c0104ef0:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104ef3:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104ef6:	83 e8 14             	sub    $0x14,%eax
c0104ef9:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104efc:	74 19                	je     c0104f17 <default_check+0x3eb>
c0104efe:	68 1e 6c 10 c0       	push   $0xc0106c1e
c0104f03:	68 88 69 10 c0       	push   $0xc0106988
c0104f08:	68 49 01 00 00       	push   $0x149
c0104f0d:	68 9d 69 10 c0       	push   $0xc010699d
c0104f12:	e8 b6 b4 ff ff       	call   c01003cd <__panic>
    free_page(p0);
c0104f17:	83 ec 08             	sub    $0x8,%esp
c0104f1a:	6a 01                	push   $0x1
c0104f1c:	ff 75 dc             	pushl  -0x24(%ebp)
c0104f1f:	e8 7c dc ff ff       	call   c0102ba0 <free_pages>
c0104f24:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104f27:	83 ec 0c             	sub    $0xc,%esp
c0104f2a:	6a 02                	push   $0x2
c0104f2c:	e8 31 dc ff ff       	call   c0102b62 <alloc_pages>
c0104f31:	83 c4 10             	add    $0x10,%esp
c0104f34:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104f37:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104f3a:	83 c0 14             	add    $0x14,%eax
c0104f3d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104f40:	74 19                	je     c0104f5b <default_check+0x42f>
c0104f42:	68 3c 6c 10 c0       	push   $0xc0106c3c
c0104f47:	68 88 69 10 c0       	push   $0xc0106988
c0104f4c:	68 4b 01 00 00       	push   $0x14b
c0104f51:	68 9d 69 10 c0       	push   $0xc010699d
c0104f56:	e8 72 b4 ff ff       	call   c01003cd <__panic>

    free_pages(p0, 2);
c0104f5b:	83 ec 08             	sub    $0x8,%esp
c0104f5e:	6a 02                	push   $0x2
c0104f60:	ff 75 dc             	pushl  -0x24(%ebp)
c0104f63:	e8 38 dc ff ff       	call   c0102ba0 <free_pages>
c0104f68:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104f6b:	83 ec 08             	sub    $0x8,%esp
c0104f6e:	6a 01                	push   $0x1
c0104f70:	ff 75 c0             	pushl  -0x40(%ebp)
c0104f73:	e8 28 dc ff ff       	call   c0102ba0 <free_pages>
c0104f78:	83 c4 10             	add    $0x10,%esp
    display_free_list();
c0104f7b:	e8 5b ef ff ff       	call   c0103edb <display_free_list>

    assert((p0 = alloc_pages(5)) != NULL);
c0104f80:	83 ec 0c             	sub    $0xc,%esp
c0104f83:	6a 05                	push   $0x5
c0104f85:	e8 d8 db ff ff       	call   c0102b62 <alloc_pages>
c0104f8a:	83 c4 10             	add    $0x10,%esp
c0104f8d:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104f90:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104f94:	75 19                	jne    c0104faf <default_check+0x483>
c0104f96:	68 5c 6c 10 c0       	push   $0xc0106c5c
c0104f9b:	68 88 69 10 c0       	push   $0xc0106988
c0104fa0:	68 51 01 00 00       	push   $0x151
c0104fa5:	68 9d 69 10 c0       	push   $0xc010699d
c0104faa:	e8 1e b4 ff ff       	call   c01003cd <__panic>
    assert(alloc_page() == NULL);
c0104faf:	83 ec 0c             	sub    $0xc,%esp
c0104fb2:	6a 01                	push   $0x1
c0104fb4:	e8 a9 db ff ff       	call   c0102b62 <alloc_pages>
c0104fb9:	83 c4 10             	add    $0x10,%esp
c0104fbc:	85 c0                	test   %eax,%eax
c0104fbe:	74 19                	je     c0104fd9 <default_check+0x4ad>
c0104fc0:	68 ba 6a 10 c0       	push   $0xc0106aba
c0104fc5:	68 88 69 10 c0       	push   $0xc0106988
c0104fca:	68 52 01 00 00       	push   $0x152
c0104fcf:	68 9d 69 10 c0       	push   $0xc010699d
c0104fd4:	e8 f4 b3 ff ff       	call   c01003cd <__panic>
    display_free_list();
c0104fd9:	e8 fd ee ff ff       	call   c0103edb <display_free_list>

    assert(nr_free == 0);
c0104fde:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104fe3:	85 c0                	test   %eax,%eax
c0104fe5:	74 19                	je     c0105000 <default_check+0x4d4>
c0104fe7:	68 0d 6b 10 c0       	push   $0xc0106b0d
c0104fec:	68 88 69 10 c0       	push   $0xc0106988
c0104ff1:	68 55 01 00 00       	push   $0x155
c0104ff6:	68 9d 69 10 c0       	push   $0xc010699d
c0104ffb:	e8 cd b3 ff ff       	call   c01003cd <__panic>
    nr_free = nr_free_store;
c0105000:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105003:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    free_list = free_list_store;
c0105008:	8b 45 80             	mov    -0x80(%ebp),%eax
c010500b:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010500e:	a3 5c 89 11 c0       	mov    %eax,0xc011895c
c0105013:	89 15 60 89 11 c0    	mov    %edx,0xc0118960
    free_pages(p0, 5);
c0105019:	83 ec 08             	sub    $0x8,%esp
c010501c:	6a 05                	push   $0x5
c010501e:	ff 75 dc             	pushl  -0x24(%ebp)
c0105021:	e8 7a db ff ff       	call   c0102ba0 <free_pages>
c0105026:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c0105029:	c7 45 ec 5c 89 11 c0 	movl   $0xc011895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0105030:	eb 1d                	jmp    c010504f <default_check+0x523>
        struct Page *p = le2page(le, page_link);
c0105032:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105035:	83 e8 0c             	sub    $0xc,%eax
c0105038:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
c010503b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010503f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105042:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105045:	8b 40 08             	mov    0x8(%eax),%eax
c0105048:	29 c2                	sub    %eax,%edx
c010504a:	89 d0                	mov    %edx,%eax
c010504c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010504f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105052:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0105055:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105058:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010505b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010505e:	81 7d ec 5c 89 11 c0 	cmpl   $0xc011895c,-0x14(%ebp)
c0105065:	75 cb                	jne    c0105032 <default_check+0x506>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0105067:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010506b:	74 19                	je     c0105086 <default_check+0x55a>
c010506d:	68 7a 6c 10 c0       	push   $0xc0106c7a
c0105072:	68 88 69 10 c0       	push   $0xc0106988
c0105077:	68 60 01 00 00       	push   $0x160
c010507c:	68 9d 69 10 c0       	push   $0xc010699d
c0105081:	e8 47 b3 ff ff       	call   c01003cd <__panic>
    assert(total == 0);
c0105086:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010508a:	74 19                	je     c01050a5 <default_check+0x579>
c010508c:	68 85 6c 10 c0       	push   $0xc0106c85
c0105091:	68 88 69 10 c0       	push   $0xc0106988
c0105096:	68 61 01 00 00       	push   $0x161
c010509b:	68 9d 69 10 c0       	push   $0xc010699d
c01050a0:	e8 28 b3 ff ff       	call   c01003cd <__panic>
}
c01050a5:	90                   	nop
c01050a6:	c9                   	leave  
c01050a7:	c3                   	ret    

c01050a8 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01050a8:	55                   	push   %ebp
c01050a9:	89 e5                	mov    %esp,%ebp
c01050ab:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01050ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01050b5:	eb 04                	jmp    c01050bb <strlen+0x13>
        cnt ++;
c01050b7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c01050bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01050be:	8d 50 01             	lea    0x1(%eax),%edx
c01050c1:	89 55 08             	mov    %edx,0x8(%ebp)
c01050c4:	0f b6 00             	movzbl (%eax),%eax
c01050c7:	84 c0                	test   %al,%al
c01050c9:	75 ec                	jne    c01050b7 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c01050cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01050ce:	c9                   	leave  
c01050cf:	c3                   	ret    

c01050d0 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01050d0:	55                   	push   %ebp
c01050d1:	89 e5                	mov    %esp,%ebp
c01050d3:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01050d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01050dd:	eb 04                	jmp    c01050e3 <strnlen+0x13>
        cnt ++;
c01050df:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c01050e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01050e6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01050e9:	73 10                	jae    c01050fb <strnlen+0x2b>
c01050eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01050ee:	8d 50 01             	lea    0x1(%eax),%edx
c01050f1:	89 55 08             	mov    %edx,0x8(%ebp)
c01050f4:	0f b6 00             	movzbl (%eax),%eax
c01050f7:	84 c0                	test   %al,%al
c01050f9:	75 e4                	jne    c01050df <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c01050fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01050fe:	c9                   	leave  
c01050ff:	c3                   	ret    

c0105100 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105100:	55                   	push   %ebp
c0105101:	89 e5                	mov    %esp,%ebp
c0105103:	57                   	push   %edi
c0105104:	56                   	push   %esi
c0105105:	83 ec 20             	sub    $0x20,%esp
c0105108:	8b 45 08             	mov    0x8(%ebp),%eax
c010510b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010510e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105111:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105114:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105117:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010511a:	89 d1                	mov    %edx,%ecx
c010511c:	89 c2                	mov    %eax,%edx
c010511e:	89 ce                	mov    %ecx,%esi
c0105120:	89 d7                	mov    %edx,%edi
c0105122:	ac                   	lods   %ds:(%esi),%al
c0105123:	aa                   	stos   %al,%es:(%edi)
c0105124:	84 c0                	test   %al,%al
c0105126:	75 fa                	jne    c0105122 <strcpy+0x22>
c0105128:	89 fa                	mov    %edi,%edx
c010512a:	89 f1                	mov    %esi,%ecx
c010512c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010512f:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105132:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105135:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c0105138:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105139:	83 c4 20             	add    $0x20,%esp
c010513c:	5e                   	pop    %esi
c010513d:	5f                   	pop    %edi
c010513e:	5d                   	pop    %ebp
c010513f:	c3                   	ret    

c0105140 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105140:	55                   	push   %ebp
c0105141:	89 e5                	mov    %esp,%ebp
c0105143:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105146:	8b 45 08             	mov    0x8(%ebp),%eax
c0105149:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c010514c:	eb 21                	jmp    c010516f <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c010514e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105151:	0f b6 10             	movzbl (%eax),%edx
c0105154:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105157:	88 10                	mov    %dl,(%eax)
c0105159:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010515c:	0f b6 00             	movzbl (%eax),%eax
c010515f:	84 c0                	test   %al,%al
c0105161:	74 04                	je     c0105167 <strncpy+0x27>
            src ++;
c0105163:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105167:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010516b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c010516f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105173:	75 d9                	jne    c010514e <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105175:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105178:	c9                   	leave  
c0105179:	c3                   	ret    

c010517a <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c010517a:	55                   	push   %ebp
c010517b:	89 e5                	mov    %esp,%ebp
c010517d:	57                   	push   %edi
c010517e:	56                   	push   %esi
c010517f:	83 ec 20             	sub    $0x20,%esp
c0105182:	8b 45 08             	mov    0x8(%ebp),%eax
c0105185:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105188:	8b 45 0c             	mov    0xc(%ebp),%eax
c010518b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c010518e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105191:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105194:	89 d1                	mov    %edx,%ecx
c0105196:	89 c2                	mov    %eax,%edx
c0105198:	89 ce                	mov    %ecx,%esi
c010519a:	89 d7                	mov    %edx,%edi
c010519c:	ac                   	lods   %ds:(%esi),%al
c010519d:	ae                   	scas   %es:(%edi),%al
c010519e:	75 08                	jne    c01051a8 <strcmp+0x2e>
c01051a0:	84 c0                	test   %al,%al
c01051a2:	75 f8                	jne    c010519c <strcmp+0x22>
c01051a4:	31 c0                	xor    %eax,%eax
c01051a6:	eb 04                	jmp    c01051ac <strcmp+0x32>
c01051a8:	19 c0                	sbb    %eax,%eax
c01051aa:	0c 01                	or     $0x1,%al
c01051ac:	89 fa                	mov    %edi,%edx
c01051ae:	89 f1                	mov    %esi,%ecx
c01051b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01051b3:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01051b6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c01051b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c01051bc:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01051bd:	83 c4 20             	add    $0x20,%esp
c01051c0:	5e                   	pop    %esi
c01051c1:	5f                   	pop    %edi
c01051c2:	5d                   	pop    %ebp
c01051c3:	c3                   	ret    

c01051c4 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01051c4:	55                   	push   %ebp
c01051c5:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01051c7:	eb 0c                	jmp    c01051d5 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c01051c9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01051cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01051d1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01051d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01051d9:	74 1a                	je     c01051f5 <strncmp+0x31>
c01051db:	8b 45 08             	mov    0x8(%ebp),%eax
c01051de:	0f b6 00             	movzbl (%eax),%eax
c01051e1:	84 c0                	test   %al,%al
c01051e3:	74 10                	je     c01051f5 <strncmp+0x31>
c01051e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01051e8:	0f b6 10             	movzbl (%eax),%edx
c01051eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051ee:	0f b6 00             	movzbl (%eax),%eax
c01051f1:	38 c2                	cmp    %al,%dl
c01051f3:	74 d4                	je     c01051c9 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c01051f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01051f9:	74 18                	je     c0105213 <strncmp+0x4f>
c01051fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01051fe:	0f b6 00             	movzbl (%eax),%eax
c0105201:	0f b6 d0             	movzbl %al,%edx
c0105204:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105207:	0f b6 00             	movzbl (%eax),%eax
c010520a:	0f b6 c0             	movzbl %al,%eax
c010520d:	29 c2                	sub    %eax,%edx
c010520f:	89 d0                	mov    %edx,%eax
c0105211:	eb 05                	jmp    c0105218 <strncmp+0x54>
c0105213:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105218:	5d                   	pop    %ebp
c0105219:	c3                   	ret    

c010521a <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c010521a:	55                   	push   %ebp
c010521b:	89 e5                	mov    %esp,%ebp
c010521d:	83 ec 04             	sub    $0x4,%esp
c0105220:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105223:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105226:	eb 14                	jmp    c010523c <strchr+0x22>
        if (*s == c) {
c0105228:	8b 45 08             	mov    0x8(%ebp),%eax
c010522b:	0f b6 00             	movzbl (%eax),%eax
c010522e:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105231:	75 05                	jne    c0105238 <strchr+0x1e>
            return (char *)s;
c0105233:	8b 45 08             	mov    0x8(%ebp),%eax
c0105236:	eb 13                	jmp    c010524b <strchr+0x31>
        }
        s ++;
c0105238:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c010523c:	8b 45 08             	mov    0x8(%ebp),%eax
c010523f:	0f b6 00             	movzbl (%eax),%eax
c0105242:	84 c0                	test   %al,%al
c0105244:	75 e2                	jne    c0105228 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105246:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010524b:	c9                   	leave  
c010524c:	c3                   	ret    

c010524d <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c010524d:	55                   	push   %ebp
c010524e:	89 e5                	mov    %esp,%ebp
c0105250:	83 ec 04             	sub    $0x4,%esp
c0105253:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105256:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105259:	eb 0f                	jmp    c010526a <strfind+0x1d>
        if (*s == c) {
c010525b:	8b 45 08             	mov    0x8(%ebp),%eax
c010525e:	0f b6 00             	movzbl (%eax),%eax
c0105261:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105264:	74 10                	je     c0105276 <strfind+0x29>
            break;
        }
        s ++;
c0105266:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c010526a:	8b 45 08             	mov    0x8(%ebp),%eax
c010526d:	0f b6 00             	movzbl (%eax),%eax
c0105270:	84 c0                	test   %al,%al
c0105272:	75 e7                	jne    c010525b <strfind+0xe>
c0105274:	eb 01                	jmp    c0105277 <strfind+0x2a>
        if (*s == c) {
            break;
c0105276:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c0105277:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010527a:	c9                   	leave  
c010527b:	c3                   	ret    

c010527c <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c010527c:	55                   	push   %ebp
c010527d:	89 e5                	mov    %esp,%ebp
c010527f:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105282:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105289:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105290:	eb 04                	jmp    c0105296 <strtol+0x1a>
        s ++;
c0105292:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105296:	8b 45 08             	mov    0x8(%ebp),%eax
c0105299:	0f b6 00             	movzbl (%eax),%eax
c010529c:	3c 20                	cmp    $0x20,%al
c010529e:	74 f2                	je     c0105292 <strtol+0x16>
c01052a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01052a3:	0f b6 00             	movzbl (%eax),%eax
c01052a6:	3c 09                	cmp    $0x9,%al
c01052a8:	74 e8                	je     c0105292 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c01052aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01052ad:	0f b6 00             	movzbl (%eax),%eax
c01052b0:	3c 2b                	cmp    $0x2b,%al
c01052b2:	75 06                	jne    c01052ba <strtol+0x3e>
        s ++;
c01052b4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01052b8:	eb 15                	jmp    c01052cf <strtol+0x53>
    }
    else if (*s == '-') {
c01052ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01052bd:	0f b6 00             	movzbl (%eax),%eax
c01052c0:	3c 2d                	cmp    $0x2d,%al
c01052c2:	75 0b                	jne    c01052cf <strtol+0x53>
        s ++, neg = 1;
c01052c4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01052c8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c01052cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01052d3:	74 06                	je     c01052db <strtol+0x5f>
c01052d5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c01052d9:	75 24                	jne    c01052ff <strtol+0x83>
c01052db:	8b 45 08             	mov    0x8(%ebp),%eax
c01052de:	0f b6 00             	movzbl (%eax),%eax
c01052e1:	3c 30                	cmp    $0x30,%al
c01052e3:	75 1a                	jne    c01052ff <strtol+0x83>
c01052e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01052e8:	83 c0 01             	add    $0x1,%eax
c01052eb:	0f b6 00             	movzbl (%eax),%eax
c01052ee:	3c 78                	cmp    $0x78,%al
c01052f0:	75 0d                	jne    c01052ff <strtol+0x83>
        s += 2, base = 16;
c01052f2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c01052f6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c01052fd:	eb 2a                	jmp    c0105329 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c01052ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105303:	75 17                	jne    c010531c <strtol+0xa0>
c0105305:	8b 45 08             	mov    0x8(%ebp),%eax
c0105308:	0f b6 00             	movzbl (%eax),%eax
c010530b:	3c 30                	cmp    $0x30,%al
c010530d:	75 0d                	jne    c010531c <strtol+0xa0>
        s ++, base = 8;
c010530f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105313:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c010531a:	eb 0d                	jmp    c0105329 <strtol+0xad>
    }
    else if (base == 0) {
c010531c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105320:	75 07                	jne    c0105329 <strtol+0xad>
        base = 10;
c0105322:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105329:	8b 45 08             	mov    0x8(%ebp),%eax
c010532c:	0f b6 00             	movzbl (%eax),%eax
c010532f:	3c 2f                	cmp    $0x2f,%al
c0105331:	7e 1b                	jle    c010534e <strtol+0xd2>
c0105333:	8b 45 08             	mov    0x8(%ebp),%eax
c0105336:	0f b6 00             	movzbl (%eax),%eax
c0105339:	3c 39                	cmp    $0x39,%al
c010533b:	7f 11                	jg     c010534e <strtol+0xd2>
            dig = *s - '0';
c010533d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105340:	0f b6 00             	movzbl (%eax),%eax
c0105343:	0f be c0             	movsbl %al,%eax
c0105346:	83 e8 30             	sub    $0x30,%eax
c0105349:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010534c:	eb 48                	jmp    c0105396 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c010534e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105351:	0f b6 00             	movzbl (%eax),%eax
c0105354:	3c 60                	cmp    $0x60,%al
c0105356:	7e 1b                	jle    c0105373 <strtol+0xf7>
c0105358:	8b 45 08             	mov    0x8(%ebp),%eax
c010535b:	0f b6 00             	movzbl (%eax),%eax
c010535e:	3c 7a                	cmp    $0x7a,%al
c0105360:	7f 11                	jg     c0105373 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105362:	8b 45 08             	mov    0x8(%ebp),%eax
c0105365:	0f b6 00             	movzbl (%eax),%eax
c0105368:	0f be c0             	movsbl %al,%eax
c010536b:	83 e8 57             	sub    $0x57,%eax
c010536e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105371:	eb 23                	jmp    c0105396 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105373:	8b 45 08             	mov    0x8(%ebp),%eax
c0105376:	0f b6 00             	movzbl (%eax),%eax
c0105379:	3c 40                	cmp    $0x40,%al
c010537b:	7e 3c                	jle    c01053b9 <strtol+0x13d>
c010537d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105380:	0f b6 00             	movzbl (%eax),%eax
c0105383:	3c 5a                	cmp    $0x5a,%al
c0105385:	7f 32                	jg     c01053b9 <strtol+0x13d>
            dig = *s - 'A' + 10;
c0105387:	8b 45 08             	mov    0x8(%ebp),%eax
c010538a:	0f b6 00             	movzbl (%eax),%eax
c010538d:	0f be c0             	movsbl %al,%eax
c0105390:	83 e8 37             	sub    $0x37,%eax
c0105393:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105396:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105399:	3b 45 10             	cmp    0x10(%ebp),%eax
c010539c:	7d 1a                	jge    c01053b8 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
c010539e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01053a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01053a5:	0f af 45 10          	imul   0x10(%ebp),%eax
c01053a9:	89 c2                	mov    %eax,%edx
c01053ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053ae:	01 d0                	add    %edx,%eax
c01053b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c01053b3:	e9 71 ff ff ff       	jmp    c0105329 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c01053b8:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c01053b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01053bd:	74 08                	je     c01053c7 <strtol+0x14b>
        *endptr = (char *) s;
c01053bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053c2:	8b 55 08             	mov    0x8(%ebp),%edx
c01053c5:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c01053c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01053cb:	74 07                	je     c01053d4 <strtol+0x158>
c01053cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01053d0:	f7 d8                	neg    %eax
c01053d2:	eb 03                	jmp    c01053d7 <strtol+0x15b>
c01053d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c01053d7:	c9                   	leave  
c01053d8:	c3                   	ret    

c01053d9 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c01053d9:	55                   	push   %ebp
c01053da:	89 e5                	mov    %esp,%ebp
c01053dc:	57                   	push   %edi
c01053dd:	83 ec 24             	sub    $0x24,%esp
c01053e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053e3:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c01053e6:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c01053ea:	8b 55 08             	mov    0x8(%ebp),%edx
c01053ed:	89 55 f8             	mov    %edx,-0x8(%ebp)
c01053f0:	88 45 f7             	mov    %al,-0x9(%ebp)
c01053f3:	8b 45 10             	mov    0x10(%ebp),%eax
c01053f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c01053f9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01053fc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105400:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105403:	89 d7                	mov    %edx,%edi
c0105405:	f3 aa                	rep stos %al,%es:(%edi)
c0105407:	89 fa                	mov    %edi,%edx
c0105409:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010540c:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c010540f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105412:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105413:	83 c4 24             	add    $0x24,%esp
c0105416:	5f                   	pop    %edi
c0105417:	5d                   	pop    %ebp
c0105418:	c3                   	ret    

c0105419 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105419:	55                   	push   %ebp
c010541a:	89 e5                	mov    %esp,%ebp
c010541c:	57                   	push   %edi
c010541d:	56                   	push   %esi
c010541e:	53                   	push   %ebx
c010541f:	83 ec 30             	sub    $0x30,%esp
c0105422:	8b 45 08             	mov    0x8(%ebp),%eax
c0105425:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105428:	8b 45 0c             	mov    0xc(%ebp),%eax
c010542b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010542e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105431:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105434:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105437:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010543a:	73 42                	jae    c010547e <memmove+0x65>
c010543c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010543f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105442:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105445:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105448:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010544b:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010544e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105451:	c1 e8 02             	shr    $0x2,%eax
c0105454:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105456:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105459:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010545c:	89 d7                	mov    %edx,%edi
c010545e:	89 c6                	mov    %eax,%esi
c0105460:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105462:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105465:	83 e1 03             	and    $0x3,%ecx
c0105468:	74 02                	je     c010546c <memmove+0x53>
c010546a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010546c:	89 f0                	mov    %esi,%eax
c010546e:	89 fa                	mov    %edi,%edx
c0105470:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105473:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105476:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105479:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c010547c:	eb 36                	jmp    c01054b4 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010547e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105481:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105484:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105487:	01 c2                	add    %eax,%edx
c0105489:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010548c:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010548f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105492:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105495:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105498:	89 c1                	mov    %eax,%ecx
c010549a:	89 d8                	mov    %ebx,%eax
c010549c:	89 d6                	mov    %edx,%esi
c010549e:	89 c7                	mov    %eax,%edi
c01054a0:	fd                   	std    
c01054a1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01054a3:	fc                   	cld    
c01054a4:	89 f8                	mov    %edi,%eax
c01054a6:	89 f2                	mov    %esi,%edx
c01054a8:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c01054ab:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01054ae:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c01054b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c01054b4:	83 c4 30             	add    $0x30,%esp
c01054b7:	5b                   	pop    %ebx
c01054b8:	5e                   	pop    %esi
c01054b9:	5f                   	pop    %edi
c01054ba:	5d                   	pop    %ebp
c01054bb:	c3                   	ret    

c01054bc <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c01054bc:	55                   	push   %ebp
c01054bd:	89 e5                	mov    %esp,%ebp
c01054bf:	57                   	push   %edi
c01054c0:	56                   	push   %esi
c01054c1:	83 ec 20             	sub    $0x20,%esp
c01054c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01054c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01054ca:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054d0:	8b 45 10             	mov    0x10(%ebp),%eax
c01054d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01054d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01054d9:	c1 e8 02             	shr    $0x2,%eax
c01054dc:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c01054de:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01054e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054e4:	89 d7                	mov    %edx,%edi
c01054e6:	89 c6                	mov    %eax,%esi
c01054e8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01054ea:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c01054ed:	83 e1 03             	and    $0x3,%ecx
c01054f0:	74 02                	je     c01054f4 <memcpy+0x38>
c01054f2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01054f4:	89 f0                	mov    %esi,%eax
c01054f6:	89 fa                	mov    %edi,%edx
c01054f8:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01054fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01054fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105501:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c0105504:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105505:	83 c4 20             	add    $0x20,%esp
c0105508:	5e                   	pop    %esi
c0105509:	5f                   	pop    %edi
c010550a:	5d                   	pop    %ebp
c010550b:	c3                   	ret    

c010550c <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c010550c:	55                   	push   %ebp
c010550d:	89 e5                	mov    %esp,%ebp
c010550f:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105512:	8b 45 08             	mov    0x8(%ebp),%eax
c0105515:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105518:	8b 45 0c             	mov    0xc(%ebp),%eax
c010551b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c010551e:	eb 30                	jmp    c0105550 <memcmp+0x44>
        if (*s1 != *s2) {
c0105520:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105523:	0f b6 10             	movzbl (%eax),%edx
c0105526:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105529:	0f b6 00             	movzbl (%eax),%eax
c010552c:	38 c2                	cmp    %al,%dl
c010552e:	74 18                	je     c0105548 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105530:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105533:	0f b6 00             	movzbl (%eax),%eax
c0105536:	0f b6 d0             	movzbl %al,%edx
c0105539:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010553c:	0f b6 00             	movzbl (%eax),%eax
c010553f:	0f b6 c0             	movzbl %al,%eax
c0105542:	29 c2                	sub    %eax,%edx
c0105544:	89 d0                	mov    %edx,%eax
c0105546:	eb 1a                	jmp    c0105562 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105548:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010554c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105550:	8b 45 10             	mov    0x10(%ebp),%eax
c0105553:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105556:	89 55 10             	mov    %edx,0x10(%ebp)
c0105559:	85 c0                	test   %eax,%eax
c010555b:	75 c3                	jne    c0105520 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c010555d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105562:	c9                   	leave  
c0105563:	c3                   	ret    

c0105564 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105564:	55                   	push   %ebp
c0105565:	89 e5                	mov    %esp,%ebp
c0105567:	83 ec 38             	sub    $0x38,%esp
c010556a:	8b 45 10             	mov    0x10(%ebp),%eax
c010556d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105570:	8b 45 14             	mov    0x14(%ebp),%eax
c0105573:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105576:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105579:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010557c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010557f:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105582:	8b 45 18             	mov    0x18(%ebp),%eax
c0105585:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105588:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010558b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010558e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105591:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105594:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105597:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010559a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010559e:	74 1c                	je     c01055bc <printnum+0x58>
c01055a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055a3:	ba 00 00 00 00       	mov    $0x0,%edx
c01055a8:	f7 75 e4             	divl   -0x1c(%ebp)
c01055ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01055ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055b1:	ba 00 00 00 00       	mov    $0x0,%edx
c01055b6:	f7 75 e4             	divl   -0x1c(%ebp)
c01055b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01055bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01055bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01055c2:	f7 75 e4             	divl   -0x1c(%ebp)
c01055c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01055c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01055cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01055ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01055d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01055d4:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01055d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01055da:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01055dd:	8b 45 18             	mov    0x18(%ebp),%eax
c01055e0:	ba 00 00 00 00       	mov    $0x0,%edx
c01055e5:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01055e8:	77 41                	ja     c010562b <printnum+0xc7>
c01055ea:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01055ed:	72 05                	jb     c01055f4 <printnum+0x90>
c01055ef:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01055f2:	77 37                	ja     c010562b <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
c01055f4:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01055f7:	83 e8 01             	sub    $0x1,%eax
c01055fa:	83 ec 04             	sub    $0x4,%esp
c01055fd:	ff 75 20             	pushl  0x20(%ebp)
c0105600:	50                   	push   %eax
c0105601:	ff 75 18             	pushl  0x18(%ebp)
c0105604:	ff 75 ec             	pushl  -0x14(%ebp)
c0105607:	ff 75 e8             	pushl  -0x18(%ebp)
c010560a:	ff 75 0c             	pushl  0xc(%ebp)
c010560d:	ff 75 08             	pushl  0x8(%ebp)
c0105610:	e8 4f ff ff ff       	call   c0105564 <printnum>
c0105615:	83 c4 20             	add    $0x20,%esp
c0105618:	eb 1b                	jmp    c0105635 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010561a:	83 ec 08             	sub    $0x8,%esp
c010561d:	ff 75 0c             	pushl  0xc(%ebp)
c0105620:	ff 75 20             	pushl  0x20(%ebp)
c0105623:	8b 45 08             	mov    0x8(%ebp),%eax
c0105626:	ff d0                	call   *%eax
c0105628:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c010562b:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010562f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105633:	7f e5                	jg     c010561a <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105635:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105638:	05 40 6d 10 c0       	add    $0xc0106d40,%eax
c010563d:	0f b6 00             	movzbl (%eax),%eax
c0105640:	0f be c0             	movsbl %al,%eax
c0105643:	83 ec 08             	sub    $0x8,%esp
c0105646:	ff 75 0c             	pushl  0xc(%ebp)
c0105649:	50                   	push   %eax
c010564a:	8b 45 08             	mov    0x8(%ebp),%eax
c010564d:	ff d0                	call   *%eax
c010564f:	83 c4 10             	add    $0x10,%esp
}
c0105652:	90                   	nop
c0105653:	c9                   	leave  
c0105654:	c3                   	ret    

c0105655 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105655:	55                   	push   %ebp
c0105656:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105658:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010565c:	7e 14                	jle    c0105672 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010565e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105661:	8b 00                	mov    (%eax),%eax
c0105663:	8d 48 08             	lea    0x8(%eax),%ecx
c0105666:	8b 55 08             	mov    0x8(%ebp),%edx
c0105669:	89 0a                	mov    %ecx,(%edx)
c010566b:	8b 50 04             	mov    0x4(%eax),%edx
c010566e:	8b 00                	mov    (%eax),%eax
c0105670:	eb 30                	jmp    c01056a2 <getuint+0x4d>
    }
    else if (lflag) {
c0105672:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105676:	74 16                	je     c010568e <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105678:	8b 45 08             	mov    0x8(%ebp),%eax
c010567b:	8b 00                	mov    (%eax),%eax
c010567d:	8d 48 04             	lea    0x4(%eax),%ecx
c0105680:	8b 55 08             	mov    0x8(%ebp),%edx
c0105683:	89 0a                	mov    %ecx,(%edx)
c0105685:	8b 00                	mov    (%eax),%eax
c0105687:	ba 00 00 00 00       	mov    $0x0,%edx
c010568c:	eb 14                	jmp    c01056a2 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010568e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105691:	8b 00                	mov    (%eax),%eax
c0105693:	8d 48 04             	lea    0x4(%eax),%ecx
c0105696:	8b 55 08             	mov    0x8(%ebp),%edx
c0105699:	89 0a                	mov    %ecx,(%edx)
c010569b:	8b 00                	mov    (%eax),%eax
c010569d:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01056a2:	5d                   	pop    %ebp
c01056a3:	c3                   	ret    

c01056a4 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01056a4:	55                   	push   %ebp
c01056a5:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01056a7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01056ab:	7e 14                	jle    c01056c1 <getint+0x1d>
        return va_arg(*ap, long long);
c01056ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01056b0:	8b 00                	mov    (%eax),%eax
c01056b2:	8d 48 08             	lea    0x8(%eax),%ecx
c01056b5:	8b 55 08             	mov    0x8(%ebp),%edx
c01056b8:	89 0a                	mov    %ecx,(%edx)
c01056ba:	8b 50 04             	mov    0x4(%eax),%edx
c01056bd:	8b 00                	mov    (%eax),%eax
c01056bf:	eb 28                	jmp    c01056e9 <getint+0x45>
    }
    else if (lflag) {
c01056c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01056c5:	74 12                	je     c01056d9 <getint+0x35>
        return va_arg(*ap, long);
c01056c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01056ca:	8b 00                	mov    (%eax),%eax
c01056cc:	8d 48 04             	lea    0x4(%eax),%ecx
c01056cf:	8b 55 08             	mov    0x8(%ebp),%edx
c01056d2:	89 0a                	mov    %ecx,(%edx)
c01056d4:	8b 00                	mov    (%eax),%eax
c01056d6:	99                   	cltd   
c01056d7:	eb 10                	jmp    c01056e9 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01056d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01056dc:	8b 00                	mov    (%eax),%eax
c01056de:	8d 48 04             	lea    0x4(%eax),%ecx
c01056e1:	8b 55 08             	mov    0x8(%ebp),%edx
c01056e4:	89 0a                	mov    %ecx,(%edx)
c01056e6:	8b 00                	mov    (%eax),%eax
c01056e8:	99                   	cltd   
    }
}
c01056e9:	5d                   	pop    %ebp
c01056ea:	c3                   	ret    

c01056eb <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01056eb:	55                   	push   %ebp
c01056ec:	89 e5                	mov    %esp,%ebp
c01056ee:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c01056f1:	8d 45 14             	lea    0x14(%ebp),%eax
c01056f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01056f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056fa:	50                   	push   %eax
c01056fb:	ff 75 10             	pushl  0x10(%ebp)
c01056fe:	ff 75 0c             	pushl  0xc(%ebp)
c0105701:	ff 75 08             	pushl  0x8(%ebp)
c0105704:	e8 06 00 00 00       	call   c010570f <vprintfmt>
c0105709:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c010570c:	90                   	nop
c010570d:	c9                   	leave  
c010570e:	c3                   	ret    

c010570f <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010570f:	55                   	push   %ebp
c0105710:	89 e5                	mov    %esp,%ebp
c0105712:	56                   	push   %esi
c0105713:	53                   	push   %ebx
c0105714:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105717:	eb 17                	jmp    c0105730 <vprintfmt+0x21>
            if (ch == '\0') {
c0105719:	85 db                	test   %ebx,%ebx
c010571b:	0f 84 8e 03 00 00    	je     c0105aaf <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
c0105721:	83 ec 08             	sub    $0x8,%esp
c0105724:	ff 75 0c             	pushl  0xc(%ebp)
c0105727:	53                   	push   %ebx
c0105728:	8b 45 08             	mov    0x8(%ebp),%eax
c010572b:	ff d0                	call   *%eax
c010572d:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105730:	8b 45 10             	mov    0x10(%ebp),%eax
c0105733:	8d 50 01             	lea    0x1(%eax),%edx
c0105736:	89 55 10             	mov    %edx,0x10(%ebp)
c0105739:	0f b6 00             	movzbl (%eax),%eax
c010573c:	0f b6 d8             	movzbl %al,%ebx
c010573f:	83 fb 25             	cmp    $0x25,%ebx
c0105742:	75 d5                	jne    c0105719 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105744:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105748:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010574f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105752:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105755:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010575c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010575f:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105762:	8b 45 10             	mov    0x10(%ebp),%eax
c0105765:	8d 50 01             	lea    0x1(%eax),%edx
c0105768:	89 55 10             	mov    %edx,0x10(%ebp)
c010576b:	0f b6 00             	movzbl (%eax),%eax
c010576e:	0f b6 d8             	movzbl %al,%ebx
c0105771:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105774:	83 f8 55             	cmp    $0x55,%eax
c0105777:	0f 87 05 03 00 00    	ja     c0105a82 <vprintfmt+0x373>
c010577d:	8b 04 85 64 6d 10 c0 	mov    -0x3fef929c(,%eax,4),%eax
c0105784:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105786:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010578a:	eb d6                	jmp    c0105762 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010578c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105790:	eb d0                	jmp    c0105762 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105792:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105799:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010579c:	89 d0                	mov    %edx,%eax
c010579e:	c1 e0 02             	shl    $0x2,%eax
c01057a1:	01 d0                	add    %edx,%eax
c01057a3:	01 c0                	add    %eax,%eax
c01057a5:	01 d8                	add    %ebx,%eax
c01057a7:	83 e8 30             	sub    $0x30,%eax
c01057aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01057ad:	8b 45 10             	mov    0x10(%ebp),%eax
c01057b0:	0f b6 00             	movzbl (%eax),%eax
c01057b3:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01057b6:	83 fb 2f             	cmp    $0x2f,%ebx
c01057b9:	7e 39                	jle    c01057f4 <vprintfmt+0xe5>
c01057bb:	83 fb 39             	cmp    $0x39,%ebx
c01057be:	7f 34                	jg     c01057f4 <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01057c0:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01057c4:	eb d3                	jmp    c0105799 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c01057c6:	8b 45 14             	mov    0x14(%ebp),%eax
c01057c9:	8d 50 04             	lea    0x4(%eax),%edx
c01057cc:	89 55 14             	mov    %edx,0x14(%ebp)
c01057cf:	8b 00                	mov    (%eax),%eax
c01057d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01057d4:	eb 1f                	jmp    c01057f5 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
c01057d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057da:	79 86                	jns    c0105762 <vprintfmt+0x53>
                width = 0;
c01057dc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01057e3:	e9 7a ff ff ff       	jmp    c0105762 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c01057e8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01057ef:	e9 6e ff ff ff       	jmp    c0105762 <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c01057f4:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c01057f5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057f9:	0f 89 63 ff ff ff    	jns    c0105762 <vprintfmt+0x53>
                width = precision, precision = -1;
c01057ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105802:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105805:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010580c:	e9 51 ff ff ff       	jmp    c0105762 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105811:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0105815:	e9 48 ff ff ff       	jmp    c0105762 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010581a:	8b 45 14             	mov    0x14(%ebp),%eax
c010581d:	8d 50 04             	lea    0x4(%eax),%edx
c0105820:	89 55 14             	mov    %edx,0x14(%ebp)
c0105823:	8b 00                	mov    (%eax),%eax
c0105825:	83 ec 08             	sub    $0x8,%esp
c0105828:	ff 75 0c             	pushl  0xc(%ebp)
c010582b:	50                   	push   %eax
c010582c:	8b 45 08             	mov    0x8(%ebp),%eax
c010582f:	ff d0                	call   *%eax
c0105831:	83 c4 10             	add    $0x10,%esp
            break;
c0105834:	e9 71 02 00 00       	jmp    c0105aaa <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105839:	8b 45 14             	mov    0x14(%ebp),%eax
c010583c:	8d 50 04             	lea    0x4(%eax),%edx
c010583f:	89 55 14             	mov    %edx,0x14(%ebp)
c0105842:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105844:	85 db                	test   %ebx,%ebx
c0105846:	79 02                	jns    c010584a <vprintfmt+0x13b>
                err = -err;
c0105848:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010584a:	83 fb 06             	cmp    $0x6,%ebx
c010584d:	7f 0b                	jg     c010585a <vprintfmt+0x14b>
c010584f:	8b 34 9d 24 6d 10 c0 	mov    -0x3fef92dc(,%ebx,4),%esi
c0105856:	85 f6                	test   %esi,%esi
c0105858:	75 19                	jne    c0105873 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
c010585a:	53                   	push   %ebx
c010585b:	68 51 6d 10 c0       	push   $0xc0106d51
c0105860:	ff 75 0c             	pushl  0xc(%ebp)
c0105863:	ff 75 08             	pushl  0x8(%ebp)
c0105866:	e8 80 fe ff ff       	call   c01056eb <printfmt>
c010586b:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010586e:	e9 37 02 00 00       	jmp    c0105aaa <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105873:	56                   	push   %esi
c0105874:	68 5a 6d 10 c0       	push   $0xc0106d5a
c0105879:	ff 75 0c             	pushl  0xc(%ebp)
c010587c:	ff 75 08             	pushl  0x8(%ebp)
c010587f:	e8 67 fe ff ff       	call   c01056eb <printfmt>
c0105884:	83 c4 10             	add    $0x10,%esp
            }
            break;
c0105887:	e9 1e 02 00 00       	jmp    c0105aaa <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010588c:	8b 45 14             	mov    0x14(%ebp),%eax
c010588f:	8d 50 04             	lea    0x4(%eax),%edx
c0105892:	89 55 14             	mov    %edx,0x14(%ebp)
c0105895:	8b 30                	mov    (%eax),%esi
c0105897:	85 f6                	test   %esi,%esi
c0105899:	75 05                	jne    c01058a0 <vprintfmt+0x191>
                p = "(null)";
c010589b:	be 5d 6d 10 c0       	mov    $0xc0106d5d,%esi
            }
            if (width > 0 && padc != '-') {
c01058a0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01058a4:	7e 76                	jle    c010591c <vprintfmt+0x20d>
c01058a6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01058aa:	74 70                	je     c010591c <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01058ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058af:	83 ec 08             	sub    $0x8,%esp
c01058b2:	50                   	push   %eax
c01058b3:	56                   	push   %esi
c01058b4:	e8 17 f8 ff ff       	call   c01050d0 <strnlen>
c01058b9:	83 c4 10             	add    $0x10,%esp
c01058bc:	89 c2                	mov    %eax,%edx
c01058be:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01058c1:	29 d0                	sub    %edx,%eax
c01058c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01058c6:	eb 17                	jmp    c01058df <vprintfmt+0x1d0>
                    putch(padc, putdat);
c01058c8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01058cc:	83 ec 08             	sub    $0x8,%esp
c01058cf:	ff 75 0c             	pushl  0xc(%ebp)
c01058d2:	50                   	push   %eax
c01058d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01058d6:	ff d0                	call   *%eax
c01058d8:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01058db:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01058df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01058e3:	7f e3                	jg     c01058c8 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01058e5:	eb 35                	jmp    c010591c <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
c01058e7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01058eb:	74 1c                	je     c0105909 <vprintfmt+0x1fa>
c01058ed:	83 fb 1f             	cmp    $0x1f,%ebx
c01058f0:	7e 05                	jle    c01058f7 <vprintfmt+0x1e8>
c01058f2:	83 fb 7e             	cmp    $0x7e,%ebx
c01058f5:	7e 12                	jle    c0105909 <vprintfmt+0x1fa>
                    putch('?', putdat);
c01058f7:	83 ec 08             	sub    $0x8,%esp
c01058fa:	ff 75 0c             	pushl  0xc(%ebp)
c01058fd:	6a 3f                	push   $0x3f
c01058ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0105902:	ff d0                	call   *%eax
c0105904:	83 c4 10             	add    $0x10,%esp
c0105907:	eb 0f                	jmp    c0105918 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
c0105909:	83 ec 08             	sub    $0x8,%esp
c010590c:	ff 75 0c             	pushl  0xc(%ebp)
c010590f:	53                   	push   %ebx
c0105910:	8b 45 08             	mov    0x8(%ebp),%eax
c0105913:	ff d0                	call   *%eax
c0105915:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105918:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010591c:	89 f0                	mov    %esi,%eax
c010591e:	8d 70 01             	lea    0x1(%eax),%esi
c0105921:	0f b6 00             	movzbl (%eax),%eax
c0105924:	0f be d8             	movsbl %al,%ebx
c0105927:	85 db                	test   %ebx,%ebx
c0105929:	74 26                	je     c0105951 <vprintfmt+0x242>
c010592b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010592f:	78 b6                	js     c01058e7 <vprintfmt+0x1d8>
c0105931:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105935:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105939:	79 ac                	jns    c01058e7 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010593b:	eb 14                	jmp    c0105951 <vprintfmt+0x242>
                putch(' ', putdat);
c010593d:	83 ec 08             	sub    $0x8,%esp
c0105940:	ff 75 0c             	pushl  0xc(%ebp)
c0105943:	6a 20                	push   $0x20
c0105945:	8b 45 08             	mov    0x8(%ebp),%eax
c0105948:	ff d0                	call   *%eax
c010594a:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010594d:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105951:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105955:	7f e6                	jg     c010593d <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
c0105957:	e9 4e 01 00 00       	jmp    c0105aaa <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010595c:	83 ec 08             	sub    $0x8,%esp
c010595f:	ff 75 e0             	pushl  -0x20(%ebp)
c0105962:	8d 45 14             	lea    0x14(%ebp),%eax
c0105965:	50                   	push   %eax
c0105966:	e8 39 fd ff ff       	call   c01056a4 <getint>
c010596b:	83 c4 10             	add    $0x10,%esp
c010596e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105971:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105974:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105977:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010597a:	85 d2                	test   %edx,%edx
c010597c:	79 23                	jns    c01059a1 <vprintfmt+0x292>
                putch('-', putdat);
c010597e:	83 ec 08             	sub    $0x8,%esp
c0105981:	ff 75 0c             	pushl  0xc(%ebp)
c0105984:	6a 2d                	push   $0x2d
c0105986:	8b 45 08             	mov    0x8(%ebp),%eax
c0105989:	ff d0                	call   *%eax
c010598b:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c010598e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105991:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105994:	f7 d8                	neg    %eax
c0105996:	83 d2 00             	adc    $0x0,%edx
c0105999:	f7 da                	neg    %edx
c010599b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010599e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01059a1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01059a8:	e9 9f 00 00 00       	jmp    c0105a4c <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01059ad:	83 ec 08             	sub    $0x8,%esp
c01059b0:	ff 75 e0             	pushl  -0x20(%ebp)
c01059b3:	8d 45 14             	lea    0x14(%ebp),%eax
c01059b6:	50                   	push   %eax
c01059b7:	e8 99 fc ff ff       	call   c0105655 <getuint>
c01059bc:	83 c4 10             	add    $0x10,%esp
c01059bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01059c5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01059cc:	eb 7e                	jmp    c0105a4c <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01059ce:	83 ec 08             	sub    $0x8,%esp
c01059d1:	ff 75 e0             	pushl  -0x20(%ebp)
c01059d4:	8d 45 14             	lea    0x14(%ebp),%eax
c01059d7:	50                   	push   %eax
c01059d8:	e8 78 fc ff ff       	call   c0105655 <getuint>
c01059dd:	83 c4 10             	add    $0x10,%esp
c01059e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01059e6:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01059ed:	eb 5d                	jmp    c0105a4c <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
c01059ef:	83 ec 08             	sub    $0x8,%esp
c01059f2:	ff 75 0c             	pushl  0xc(%ebp)
c01059f5:	6a 30                	push   $0x30
c01059f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01059fa:	ff d0                	call   *%eax
c01059fc:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c01059ff:	83 ec 08             	sub    $0x8,%esp
c0105a02:	ff 75 0c             	pushl  0xc(%ebp)
c0105a05:	6a 78                	push   $0x78
c0105a07:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a0a:	ff d0                	call   *%eax
c0105a0c:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105a0f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105a12:	8d 50 04             	lea    0x4(%eax),%edx
c0105a15:	89 55 14             	mov    %edx,0x14(%ebp)
c0105a18:	8b 00                	mov    (%eax),%eax
c0105a1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105a24:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105a2b:	eb 1f                	jmp    c0105a4c <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105a2d:	83 ec 08             	sub    $0x8,%esp
c0105a30:	ff 75 e0             	pushl  -0x20(%ebp)
c0105a33:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a36:	50                   	push   %eax
c0105a37:	e8 19 fc ff ff       	call   c0105655 <getuint>
c0105a3c:	83 c4 10             	add    $0x10,%esp
c0105a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a42:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105a45:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105a4c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105a50:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a53:	83 ec 04             	sub    $0x4,%esp
c0105a56:	52                   	push   %edx
c0105a57:	ff 75 e8             	pushl  -0x18(%ebp)
c0105a5a:	50                   	push   %eax
c0105a5b:	ff 75 f4             	pushl  -0xc(%ebp)
c0105a5e:	ff 75 f0             	pushl  -0x10(%ebp)
c0105a61:	ff 75 0c             	pushl  0xc(%ebp)
c0105a64:	ff 75 08             	pushl  0x8(%ebp)
c0105a67:	e8 f8 fa ff ff       	call   c0105564 <printnum>
c0105a6c:	83 c4 20             	add    $0x20,%esp
            break;
c0105a6f:	eb 39                	jmp    c0105aaa <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105a71:	83 ec 08             	sub    $0x8,%esp
c0105a74:	ff 75 0c             	pushl  0xc(%ebp)
c0105a77:	53                   	push   %ebx
c0105a78:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a7b:	ff d0                	call   *%eax
c0105a7d:	83 c4 10             	add    $0x10,%esp
            break;
c0105a80:	eb 28                	jmp    c0105aaa <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105a82:	83 ec 08             	sub    $0x8,%esp
c0105a85:	ff 75 0c             	pushl  0xc(%ebp)
c0105a88:	6a 25                	push   $0x25
c0105a8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a8d:	ff d0                	call   *%eax
c0105a8f:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105a92:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105a96:	eb 04                	jmp    c0105a9c <vprintfmt+0x38d>
c0105a98:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105a9c:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a9f:	83 e8 01             	sub    $0x1,%eax
c0105aa2:	0f b6 00             	movzbl (%eax),%eax
c0105aa5:	3c 25                	cmp    $0x25,%al
c0105aa7:	75 ef                	jne    c0105a98 <vprintfmt+0x389>
                /* do nothing */;
            break;
c0105aa9:	90                   	nop
        }
    }
c0105aaa:	e9 68 fc ff ff       	jmp    c0105717 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
c0105aaf:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105ab0:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0105ab3:	5b                   	pop    %ebx
c0105ab4:	5e                   	pop    %esi
c0105ab5:	5d                   	pop    %ebp
c0105ab6:	c3                   	ret    

c0105ab7 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105ab7:	55                   	push   %ebp
c0105ab8:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105aba:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105abd:	8b 40 08             	mov    0x8(%eax),%eax
c0105ac0:	8d 50 01             	lea    0x1(%eax),%edx
c0105ac3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ac6:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105ac9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105acc:	8b 10                	mov    (%eax),%edx
c0105ace:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ad1:	8b 40 04             	mov    0x4(%eax),%eax
c0105ad4:	39 c2                	cmp    %eax,%edx
c0105ad6:	73 12                	jae    c0105aea <sprintputch+0x33>
        *b->buf ++ = ch;
c0105ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105adb:	8b 00                	mov    (%eax),%eax
c0105add:	8d 48 01             	lea    0x1(%eax),%ecx
c0105ae0:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105ae3:	89 0a                	mov    %ecx,(%edx)
c0105ae5:	8b 55 08             	mov    0x8(%ebp),%edx
c0105ae8:	88 10                	mov    %dl,(%eax)
    }
}
c0105aea:	90                   	nop
c0105aeb:	5d                   	pop    %ebp
c0105aec:	c3                   	ret    

c0105aed <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105aed:	55                   	push   %ebp
c0105aee:	89 e5                	mov    %esp,%ebp
c0105af0:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105af3:	8d 45 14             	lea    0x14(%ebp),%eax
c0105af6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105afc:	50                   	push   %eax
c0105afd:	ff 75 10             	pushl  0x10(%ebp)
c0105b00:	ff 75 0c             	pushl  0xc(%ebp)
c0105b03:	ff 75 08             	pushl  0x8(%ebp)
c0105b06:	e8 0b 00 00 00       	call   c0105b16 <vsnprintf>
c0105b0b:	83 c4 10             	add    $0x10,%esp
c0105b0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105b14:	c9                   	leave  
c0105b15:	c3                   	ret    

c0105b16 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105b16:	55                   	push   %ebp
c0105b17:	89 e5                	mov    %esp,%ebp
c0105b19:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105b1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105b22:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b25:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105b28:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b2b:	01 d0                	add    %edx,%eax
c0105b2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105b37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105b3b:	74 0a                	je     c0105b47 <vsnprintf+0x31>
c0105b3d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b43:	39 c2                	cmp    %eax,%edx
c0105b45:	76 07                	jbe    c0105b4e <vsnprintf+0x38>
        return -E_INVAL;
c0105b47:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105b4c:	eb 20                	jmp    c0105b6e <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105b4e:	ff 75 14             	pushl  0x14(%ebp)
c0105b51:	ff 75 10             	pushl  0x10(%ebp)
c0105b54:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105b57:	50                   	push   %eax
c0105b58:	68 b7 5a 10 c0       	push   $0xc0105ab7
c0105b5d:	e8 ad fb ff ff       	call   c010570f <vprintfmt>
c0105b62:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c0105b65:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b68:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105b6e:	c9                   	leave  
c0105b6f:	c3                   	ret    
