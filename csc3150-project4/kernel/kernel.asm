
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	89013103          	ld	sp,-1904(sp) # 80008890 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	742050ef          	jal	ra,80005758 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	d2078793          	addi	a5,a5,-736 # 80021d50 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	89090913          	addi	s2,s2,-1904 # 800088e0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	0ea080e7          	jalr	234(ra) # 80006144 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	18a080e7          	jalr	394(ra) # 800061f8 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	b82080e7          	jalr	-1150(ra) # 80005c0c <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	addi	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00008517          	auipc	a0,0x8
    800000f2:	7f250513          	addi	a0,a0,2034 # 800088e0 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	fbe080e7          	jalr	-66(ra) # 800060b4 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	c4e50513          	addi	a0,a0,-946 # 80021d50 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00008497          	auipc	s1,0x8
    80000128:	7bc48493          	addi	s1,s1,1980 # 800088e0 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	016080e7          	jalr	22(ra) # 80006144 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00008517          	auipc	a0,0x8
    80000140:	7a450513          	addi	a0,a0,1956 # 800088e0 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	0b2080e7          	jalr	178(ra) # 800061f8 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00008517          	auipc	a0,0x8
    8000016c:	77850513          	addi	a0,a0,1912 # 800088e0 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	088080e7          	jalr	136(ra) # 800061f8 <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd2b1>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
  if(n == 0)
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	addi	sp,sp,16
    80000280:	8082                	ret
    return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028c:	872a                	mv	a4,a0
    8000028e:	8832                	mv	a6,a2
    80000290:	367d                	addiw	a2,a2,-1
    80000292:	01005963          	blez	a6,800002a4 <strncpy+0x1e>
    80000296:	0705                	addi	a4,a4,1
    80000298:	0005c783          	lbu	a5,0(a1)
    8000029c:	fef70fa3          	sb	a5,-1(a4)
    800002a0:	0585                	addi	a1,a1,1
    800002a2:	f7f5                	bnez	a5,8000028e <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a4:	86ba                	mv	a3,a4
    800002a6:	00c05c63          	blez	a2,800002be <strncpy+0x38>
    *s++ = 0;
    800002aa:	0685                	addi	a3,a3,1
    800002ac:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b0:	40d707bb          	subw	a5,a4,a3
    800002b4:	37fd                	addiw	a5,a5,-1
    800002b6:	010787bb          	addw	a5,a5,a6
    800002ba:	fef048e3          	bgtz	a5,800002aa <strncpy+0x24>
  return os;
}
    800002be:	6422                	ld	s0,8(sp)
    800002c0:	0141                	addi	sp,sp,16
    800002c2:	8082                	ret

00000000800002c4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c4:	1141                	addi	sp,sp,-16
    800002c6:	e422                	sd	s0,8(sp)
    800002c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002ca:	02c05363          	blez	a2,800002f0 <safestrcpy+0x2c>
    800002ce:	fff6069b          	addiw	a3,a2,-1
    800002d2:	1682                	slli	a3,a3,0x20
    800002d4:	9281                	srli	a3,a3,0x20
    800002d6:	96ae                	add	a3,a3,a1
    800002d8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002da:	00d58963          	beq	a1,a3,800002ec <safestrcpy+0x28>
    800002de:	0585                	addi	a1,a1,1
    800002e0:	0785                	addi	a5,a5,1
    800002e2:	fff5c703          	lbu	a4,-1(a1)
    800002e6:	fee78fa3          	sb	a4,-1(a5)
    800002ea:	fb65                	bnez	a4,800002da <safestrcpy+0x16>
    ;
  *s = 0;
    800002ec:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f0:	6422                	ld	s0,8(sp)
    800002f2:	0141                	addi	sp,sp,16
    800002f4:	8082                	ret

00000000800002f6 <strlen>:

int
strlen(const char *s)
{
    800002f6:	1141                	addi	sp,sp,-16
    800002f8:	e422                	sd	s0,8(sp)
    800002fa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fc:	00054783          	lbu	a5,0(a0)
    80000300:	cf91                	beqz	a5,8000031c <strlen+0x26>
    80000302:	0505                	addi	a0,a0,1
    80000304:	87aa                	mv	a5,a0
    80000306:	4685                	li	a3,1
    80000308:	9e89                	subw	a3,a3,a0
    8000030a:	00f6853b          	addw	a0,a3,a5
    8000030e:	0785                	addi	a5,a5,1
    80000310:	fff7c703          	lbu	a4,-1(a5)
    80000314:	fb7d                	bnez	a4,8000030a <strlen+0x14>
    ;
  return n;
}
    80000316:	6422                	ld	s0,8(sp)
    80000318:	0141                	addi	sp,sp,16
    8000031a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031c:	4501                	li	a0,0
    8000031e:	bfe5                	j	80000316 <strlen+0x20>

0000000080000320 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000320:	1141                	addi	sp,sp,-16
    80000322:	e406                	sd	ra,8(sp)
    80000324:	e022                	sd	s0,0(sp)
    80000326:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000328:	00001097          	auipc	ra,0x1
    8000032c:	ae6080e7          	jalr	-1306(ra) # 80000e0e <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000330:	00008717          	auipc	a4,0x8
    80000334:	58070713          	addi	a4,a4,1408 # 800088b0 <started>
  if(cpuid() == 0){
    80000338:	c139                	beqz	a0,8000037e <main+0x5e>
    while(started == 0)
    8000033a:	431c                	lw	a5,0(a4)
    8000033c:	2781                	sext.w	a5,a5
    8000033e:	dff5                	beqz	a5,8000033a <main+0x1a>
      ;
    __sync_synchronize();
    80000340:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000344:	00001097          	auipc	ra,0x1
    80000348:	aca080e7          	jalr	-1334(ra) # 80000e0e <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	900080e7          	jalr	-1792(ra) # 80005c56 <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00001097          	auipc	ra,0x1
    8000036a:	772080e7          	jalr	1906(ra) # 80001ad8 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	da2080e7          	jalr	-606(ra) # 80005110 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	fba080e7          	jalr	-70(ra) # 80001330 <scheduler>
    consoleinit();
    8000037e:	00005097          	auipc	ra,0x5
    80000382:	79e080e7          	jalr	1950(ra) # 80005b1c <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	ab0080e7          	jalr	-1360(ra) # 80005e36 <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	8c0080e7          	jalr	-1856(ra) # 80005c56 <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	8b0080e7          	jalr	-1872(ra) # 80005c56 <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	8a0080e7          	jalr	-1888(ra) # 80005c56 <printf>
    kinit();         // physical page allocator
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	d20080e7          	jalr	-736(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	326080e7          	jalr	806(ra) # 800006ec <kvminit>
    kvminithart();   // turn on paging
    800003ce:	00000097          	auipc	ra,0x0
    800003d2:	068080e7          	jalr	104(ra) # 80000436 <kvminithart>
    procinit();      // process table
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	984080e7          	jalr	-1660(ra) # 80000d5a <procinit>
    trapinit();      // trap vectors
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	6d2080e7          	jalr	1746(ra) # 80001ab0 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00001097          	auipc	ra,0x1
    800003ea:	6f2080e7          	jalr	1778(ra) # 80001ad8 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	d0c080e7          	jalr	-756(ra) # 800050fa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	d1a080e7          	jalr	-742(ra) # 80005110 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	e4a080e7          	jalr	-438(ra) # 80002248 <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	4ea080e7          	jalr	1258(ra) # 800028f0 <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	490080e7          	jalr	1168(ra) # 8000389e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	e02080e7          	jalr	-510(ra) # 80005218 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	cf4080e7          	jalr	-780(ra) # 80001112 <userinit>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00008717          	auipc	a4,0x8
    80000430:	48f72223          	sw	a5,1156(a4) # 800088b0 <started>
    80000434:	b789                	j	80000376 <main+0x56>

0000000080000436 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000436:	1141                	addi	sp,sp,-16
    80000438:	e422                	sd	s0,8(sp)
    8000043a:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000043c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000440:	00008797          	auipc	a5,0x8
    80000444:	4787b783          	ld	a5,1144(a5) # 800088b8 <kernel_pagetable>
    80000448:	83b1                	srli	a5,a5,0xc
    8000044a:	577d                	li	a4,-1
    8000044c:	177e                	slli	a4,a4,0x3f
    8000044e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000450:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000454:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000458:	6422                	ld	s0,8(sp)
    8000045a:	0141                	addi	sp,sp,16
    8000045c:	8082                	ret

000000008000045e <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045e:	7139                	addi	sp,sp,-64
    80000460:	fc06                	sd	ra,56(sp)
    80000462:	f822                	sd	s0,48(sp)
    80000464:	f426                	sd	s1,40(sp)
    80000466:	f04a                	sd	s2,32(sp)
    80000468:	ec4e                	sd	s3,24(sp)
    8000046a:	e852                	sd	s4,16(sp)
    8000046c:	e456                	sd	s5,8(sp)
    8000046e:	e05a                	sd	s6,0(sp)
    80000470:	0080                	addi	s0,sp,64
    80000472:	84aa                	mv	s1,a0
    80000474:	89ae                	mv	s3,a1
    80000476:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000478:	57fd                	li	a5,-1
    8000047a:	83e9                	srli	a5,a5,0x1a
    8000047c:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047e:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000480:	04b7f263          	bgeu	a5,a1,800004c4 <walk+0x66>
    panic("walk");
    80000484:	00008517          	auipc	a0,0x8
    80000488:	bcc50513          	addi	a0,a0,-1076 # 80008050 <etext+0x50>
    8000048c:	00005097          	auipc	ra,0x5
    80000490:	780080e7          	jalr	1920(ra) # 80005c0c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000494:	060a8663          	beqz	s5,80000500 <walk+0xa2>
    80000498:	00000097          	auipc	ra,0x0
    8000049c:	c82080e7          	jalr	-894(ra) # 8000011a <kalloc>
    800004a0:	84aa                	mv	s1,a0
    800004a2:	c529                	beqz	a0,800004ec <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a4:	6605                	lui	a2,0x1
    800004a6:	4581                	li	a1,0
    800004a8:	00000097          	auipc	ra,0x0
    800004ac:	cd2080e7          	jalr	-814(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b0:	00c4d793          	srli	a5,s1,0xc
    800004b4:	07aa                	slli	a5,a5,0xa
    800004b6:	0017e793          	ori	a5,a5,1
    800004ba:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004be:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdd2a7>
    800004c0:	036a0063          	beq	s4,s6,800004e0 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c4:	0149d933          	srl	s2,s3,s4
    800004c8:	1ff97913          	andi	s2,s2,511
    800004cc:	090e                	slli	s2,s2,0x3
    800004ce:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d0:	00093483          	ld	s1,0(s2)
    800004d4:	0014f793          	andi	a5,s1,1
    800004d8:	dfd5                	beqz	a5,80000494 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004da:	80a9                	srli	s1,s1,0xa
    800004dc:	04b2                	slli	s1,s1,0xc
    800004de:	b7c5                	j	800004be <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e0:	00c9d513          	srli	a0,s3,0xc
    800004e4:	1ff57513          	andi	a0,a0,511
    800004e8:	050e                	slli	a0,a0,0x3
    800004ea:	9526                	add	a0,a0,s1
}
    800004ec:	70e2                	ld	ra,56(sp)
    800004ee:	7442                	ld	s0,48(sp)
    800004f0:	74a2                	ld	s1,40(sp)
    800004f2:	7902                	ld	s2,32(sp)
    800004f4:	69e2                	ld	s3,24(sp)
    800004f6:	6a42                	ld	s4,16(sp)
    800004f8:	6aa2                	ld	s5,8(sp)
    800004fa:	6b02                	ld	s6,0(sp)
    800004fc:	6121                	addi	sp,sp,64
    800004fe:	8082                	ret
        return 0;
    80000500:	4501                	li	a0,0
    80000502:	b7ed                	j	800004ec <walk+0x8e>

0000000080000504 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000504:	57fd                	li	a5,-1
    80000506:	83e9                	srli	a5,a5,0x1a
    80000508:	00b7f463          	bgeu	a5,a1,80000510 <walkaddr+0xc>
    return 0;
    8000050c:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050e:	8082                	ret
{
    80000510:	1141                	addi	sp,sp,-16
    80000512:	e406                	sd	ra,8(sp)
    80000514:	e022                	sd	s0,0(sp)
    80000516:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000518:	4601                	li	a2,0
    8000051a:	00000097          	auipc	ra,0x0
    8000051e:	f44080e7          	jalr	-188(ra) # 8000045e <walk>
  if(pte == 0)
    80000522:	c105                	beqz	a0,80000542 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000524:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000526:	0117f693          	andi	a3,a5,17
    8000052a:	4745                	li	a4,17
    return 0;
    8000052c:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052e:	00e68663          	beq	a3,a4,8000053a <walkaddr+0x36>
}
    80000532:	60a2                	ld	ra,8(sp)
    80000534:	6402                	ld	s0,0(sp)
    80000536:	0141                	addi	sp,sp,16
    80000538:	8082                	ret
  pa = PTE2PA(*pte);
    8000053a:	83a9                	srli	a5,a5,0xa
    8000053c:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000540:	bfcd                	j	80000532 <walkaddr+0x2e>
    return 0;
    80000542:	4501                	li	a0,0
    80000544:	b7fd                	j	80000532 <walkaddr+0x2e>

0000000080000546 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000546:	715d                	addi	sp,sp,-80
    80000548:	e486                	sd	ra,72(sp)
    8000054a:	e0a2                	sd	s0,64(sp)
    8000054c:	fc26                	sd	s1,56(sp)
    8000054e:	f84a                	sd	s2,48(sp)
    80000550:	f44e                	sd	s3,40(sp)
    80000552:	f052                	sd	s4,32(sp)
    80000554:	ec56                	sd	s5,24(sp)
    80000556:	e85a                	sd	s6,16(sp)
    80000558:	e45e                	sd	s7,8(sp)
    8000055a:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055c:	c639                	beqz	a2,800005aa <mappages+0x64>
    8000055e:	8aaa                	mv	s5,a0
    80000560:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000562:	777d                	lui	a4,0xfffff
    80000564:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000568:	fff58993          	addi	s3,a1,-1
    8000056c:	99b2                	add	s3,s3,a2
    8000056e:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000572:	893e                	mv	s2,a5
    80000574:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000578:	6b85                	lui	s7,0x1
    8000057a:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057e:	4605                	li	a2,1
    80000580:	85ca                	mv	a1,s2
    80000582:	8556                	mv	a0,s5
    80000584:	00000097          	auipc	ra,0x0
    80000588:	eda080e7          	jalr	-294(ra) # 8000045e <walk>
    8000058c:	cd1d                	beqz	a0,800005ca <mappages+0x84>
    if(*pte & PTE_V)
    8000058e:	611c                	ld	a5,0(a0)
    80000590:	8b85                	andi	a5,a5,1
    80000592:	e785                	bnez	a5,800005ba <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000594:	80b1                	srli	s1,s1,0xc
    80000596:	04aa                	slli	s1,s1,0xa
    80000598:	0164e4b3          	or	s1,s1,s6
    8000059c:	0014e493          	ori	s1,s1,1
    800005a0:	e104                	sd	s1,0(a0)
    if(a == last)
    800005a2:	05390063          	beq	s2,s3,800005e2 <mappages+0x9c>
    a += PGSIZE;
    800005a6:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a8:	bfc9                	j	8000057a <mappages+0x34>
    panic("mappages: size");
    800005aa:	00008517          	auipc	a0,0x8
    800005ae:	aae50513          	addi	a0,a0,-1362 # 80008058 <etext+0x58>
    800005b2:	00005097          	auipc	ra,0x5
    800005b6:	65a080e7          	jalr	1626(ra) # 80005c0c <panic>
      panic("mappages: remap");
    800005ba:	00008517          	auipc	a0,0x8
    800005be:	aae50513          	addi	a0,a0,-1362 # 80008068 <etext+0x68>
    800005c2:	00005097          	auipc	ra,0x5
    800005c6:	64a080e7          	jalr	1610(ra) # 80005c0c <panic>
      return -1;
    800005ca:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005cc:	60a6                	ld	ra,72(sp)
    800005ce:	6406                	ld	s0,64(sp)
    800005d0:	74e2                	ld	s1,56(sp)
    800005d2:	7942                	ld	s2,48(sp)
    800005d4:	79a2                	ld	s3,40(sp)
    800005d6:	7a02                	ld	s4,32(sp)
    800005d8:	6ae2                	ld	s5,24(sp)
    800005da:	6b42                	ld	s6,16(sp)
    800005dc:	6ba2                	ld	s7,8(sp)
    800005de:	6161                	addi	sp,sp,80
    800005e0:	8082                	ret
  return 0;
    800005e2:	4501                	li	a0,0
    800005e4:	b7e5                	j	800005cc <mappages+0x86>

00000000800005e6 <kvmmap>:
{
    800005e6:	1141                	addi	sp,sp,-16
    800005e8:	e406                	sd	ra,8(sp)
    800005ea:	e022                	sd	s0,0(sp)
    800005ec:	0800                	addi	s0,sp,16
    800005ee:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f0:	86b2                	mv	a3,a2
    800005f2:	863e                	mv	a2,a5
    800005f4:	00000097          	auipc	ra,0x0
    800005f8:	f52080e7          	jalr	-174(ra) # 80000546 <mappages>
    800005fc:	e509                	bnez	a0,80000606 <kvmmap+0x20>
}
    800005fe:	60a2                	ld	ra,8(sp)
    80000600:	6402                	ld	s0,0(sp)
    80000602:	0141                	addi	sp,sp,16
    80000604:	8082                	ret
    panic("kvmmap");
    80000606:	00008517          	auipc	a0,0x8
    8000060a:	a7250513          	addi	a0,a0,-1422 # 80008078 <etext+0x78>
    8000060e:	00005097          	auipc	ra,0x5
    80000612:	5fe080e7          	jalr	1534(ra) # 80005c0c <panic>

0000000080000616 <kvmmake>:
{
    80000616:	1101                	addi	sp,sp,-32
    80000618:	ec06                	sd	ra,24(sp)
    8000061a:	e822                	sd	s0,16(sp)
    8000061c:	e426                	sd	s1,8(sp)
    8000061e:	e04a                	sd	s2,0(sp)
    80000620:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000622:	00000097          	auipc	ra,0x0
    80000626:	af8080e7          	jalr	-1288(ra) # 8000011a <kalloc>
    8000062a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062c:	6605                	lui	a2,0x1
    8000062e:	4581                	li	a1,0
    80000630:	00000097          	auipc	ra,0x0
    80000634:	b4a080e7          	jalr	-1206(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000638:	4719                	li	a4,6
    8000063a:	6685                	lui	a3,0x1
    8000063c:	10000637          	lui	a2,0x10000
    80000640:	100005b7          	lui	a1,0x10000
    80000644:	8526                	mv	a0,s1
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	fa0080e7          	jalr	-96(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064e:	4719                	li	a4,6
    80000650:	6685                	lui	a3,0x1
    80000652:	10001637          	lui	a2,0x10001
    80000656:	100015b7          	lui	a1,0x10001
    8000065a:	8526                	mv	a0,s1
    8000065c:	00000097          	auipc	ra,0x0
    80000660:	f8a080e7          	jalr	-118(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000664:	4719                	li	a4,6
    80000666:	004006b7          	lui	a3,0x400
    8000066a:	0c000637          	lui	a2,0xc000
    8000066e:	0c0005b7          	lui	a1,0xc000
    80000672:	8526                	mv	a0,s1
    80000674:	00000097          	auipc	ra,0x0
    80000678:	f72080e7          	jalr	-142(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067c:	00008917          	auipc	s2,0x8
    80000680:	98490913          	addi	s2,s2,-1660 # 80008000 <etext>
    80000684:	4729                	li	a4,10
    80000686:	80008697          	auipc	a3,0x80008
    8000068a:	97a68693          	addi	a3,a3,-1670 # 8000 <_entry-0x7fff8000>
    8000068e:	4605                	li	a2,1
    80000690:	067e                	slli	a2,a2,0x1f
    80000692:	85b2                	mv	a1,a2
    80000694:	8526                	mv	a0,s1
    80000696:	00000097          	auipc	ra,0x0
    8000069a:	f50080e7          	jalr	-176(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069e:	4719                	li	a4,6
    800006a0:	46c5                	li	a3,17
    800006a2:	06ee                	slli	a3,a3,0x1b
    800006a4:	412686b3          	sub	a3,a3,s2
    800006a8:	864a                	mv	a2,s2
    800006aa:	85ca                	mv	a1,s2
    800006ac:	8526                	mv	a0,s1
    800006ae:	00000097          	auipc	ra,0x0
    800006b2:	f38080e7          	jalr	-200(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b6:	4729                	li	a4,10
    800006b8:	6685                	lui	a3,0x1
    800006ba:	00007617          	auipc	a2,0x7
    800006be:	94660613          	addi	a2,a2,-1722 # 80007000 <_trampoline>
    800006c2:	040005b7          	lui	a1,0x4000
    800006c6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006c8:	05b2                	slli	a1,a1,0xc
    800006ca:	8526                	mv	a0,s1
    800006cc:	00000097          	auipc	ra,0x0
    800006d0:	f1a080e7          	jalr	-230(ra) # 800005e6 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d4:	8526                	mv	a0,s1
    800006d6:	00000097          	auipc	ra,0x0
    800006da:	5ee080e7          	jalr	1518(ra) # 80000cc4 <proc_mapstacks>
}
    800006de:	8526                	mv	a0,s1
    800006e0:	60e2                	ld	ra,24(sp)
    800006e2:	6442                	ld	s0,16(sp)
    800006e4:	64a2                	ld	s1,8(sp)
    800006e6:	6902                	ld	s2,0(sp)
    800006e8:	6105                	addi	sp,sp,32
    800006ea:	8082                	ret

00000000800006ec <kvminit>:
{
    800006ec:	1141                	addi	sp,sp,-16
    800006ee:	e406                	sd	ra,8(sp)
    800006f0:	e022                	sd	s0,0(sp)
    800006f2:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	f22080e7          	jalr	-222(ra) # 80000616 <kvmmake>
    800006fc:	00008797          	auipc	a5,0x8
    80000700:	1aa7be23          	sd	a0,444(a5) # 800088b8 <kernel_pagetable>
}
    80000704:	60a2                	ld	ra,8(sp)
    80000706:	6402                	ld	s0,0(sp)
    80000708:	0141                	addi	sp,sp,16
    8000070a:	8082                	ret

000000008000070c <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070c:	715d                	addi	sp,sp,-80
    8000070e:	e486                	sd	ra,72(sp)
    80000710:	e0a2                	sd	s0,64(sp)
    80000712:	fc26                	sd	s1,56(sp)
    80000714:	f84a                	sd	s2,48(sp)
    80000716:	f44e                	sd	s3,40(sp)
    80000718:	f052                	sd	s4,32(sp)
    8000071a:	ec56                	sd	s5,24(sp)
    8000071c:	e85a                	sd	s6,16(sp)
    8000071e:	e45e                	sd	s7,8(sp)
    80000720:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000722:	03459793          	slli	a5,a1,0x34
    80000726:	e795                	bnez	a5,80000752 <uvmunmap+0x46>
    80000728:	8a2a                	mv	s4,a0
    8000072a:	892e                	mv	s2,a1
    8000072c:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072e:	0632                	slli	a2,a2,0xc
    80000730:	00b609b3          	add	s3,a2,a1
        // if (do_free == -1)
          continue;
        // else
        //   panic("uvmunmap: not mapped");
      }
    if(PTE_FLAGS(*pte) == PTE_V)
    80000734:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000736:	6a85                	lui	s5,0x1
    80000738:	0535ea63          	bltu	a1,s3,8000078c <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073c:	60a6                	ld	ra,72(sp)
    8000073e:	6406                	ld	s0,64(sp)
    80000740:	74e2                	ld	s1,56(sp)
    80000742:	7942                	ld	s2,48(sp)
    80000744:	79a2                	ld	s3,40(sp)
    80000746:	7a02                	ld	s4,32(sp)
    80000748:	6ae2                	ld	s5,24(sp)
    8000074a:	6b42                	ld	s6,16(sp)
    8000074c:	6ba2                	ld	s7,8(sp)
    8000074e:	6161                	addi	sp,sp,80
    80000750:	8082                	ret
    panic("uvmunmap: not aligned");
    80000752:	00008517          	auipc	a0,0x8
    80000756:	92e50513          	addi	a0,a0,-1746 # 80008080 <etext+0x80>
    8000075a:	00005097          	auipc	ra,0x5
    8000075e:	4b2080e7          	jalr	1202(ra) # 80005c0c <panic>
      panic("uvmunmap: walk");
    80000762:	00008517          	auipc	a0,0x8
    80000766:	93650513          	addi	a0,a0,-1738 # 80008098 <etext+0x98>
    8000076a:	00005097          	auipc	ra,0x5
    8000076e:	4a2080e7          	jalr	1186(ra) # 80005c0c <panic>
      panic("uvmunmap: not a leaf");
    80000772:	00008517          	auipc	a0,0x8
    80000776:	93650513          	addi	a0,a0,-1738 # 800080a8 <etext+0xa8>
    8000077a:	00005097          	auipc	ra,0x5
    8000077e:	492080e7          	jalr	1170(ra) # 80005c0c <panic>
    *pte = 0;
    80000782:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000786:	9956                	add	s2,s2,s5
    80000788:	fb397ae3          	bgeu	s2,s3,8000073c <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000078c:	4601                	li	a2,0
    8000078e:	85ca                	mv	a1,s2
    80000790:	8552                	mv	a0,s4
    80000792:	00000097          	auipc	ra,0x0
    80000796:	ccc080e7          	jalr	-820(ra) # 8000045e <walk>
    8000079a:	84aa                	mv	s1,a0
    8000079c:	d179                	beqz	a0,80000762 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0) {
    8000079e:	611c                	ld	a5,0(a0)
    800007a0:	0017f713          	andi	a4,a5,1
    800007a4:	d36d                	beqz	a4,80000786 <uvmunmap+0x7a>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007a6:	3ff7f713          	andi	a4,a5,1023
    800007aa:	fd7704e3          	beq	a4,s7,80000772 <uvmunmap+0x66>
    if(do_free){
    800007ae:	fc0b0ae3          	beqz	s6,80000782 <uvmunmap+0x76>
      uint64 pa = PTE2PA(*pte);
    800007b2:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    800007b4:	00c79513          	slli	a0,a5,0xc
    800007b8:	00000097          	auipc	ra,0x0
    800007bc:	864080e7          	jalr	-1948(ra) # 8000001c <kfree>
    800007c0:	b7c9                	j	80000782 <uvmunmap+0x76>

00000000800007c2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007c2:	1101                	addi	sp,sp,-32
    800007c4:	ec06                	sd	ra,24(sp)
    800007c6:	e822                	sd	s0,16(sp)
    800007c8:	e426                	sd	s1,8(sp)
    800007ca:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007cc:	00000097          	auipc	ra,0x0
    800007d0:	94e080e7          	jalr	-1714(ra) # 8000011a <kalloc>
    800007d4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007d6:	c519                	beqz	a0,800007e4 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007d8:	6605                	lui	a2,0x1
    800007da:	4581                	li	a1,0
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	99e080e7          	jalr	-1634(ra) # 8000017a <memset>
  return pagetable;
}
    800007e4:	8526                	mv	a0,s1
    800007e6:	60e2                	ld	ra,24(sp)
    800007e8:	6442                	ld	s0,16(sp)
    800007ea:	64a2                	ld	s1,8(sp)
    800007ec:	6105                	addi	sp,sp,32
    800007ee:	8082                	ret

00000000800007f0 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800007f0:	7179                	addi	sp,sp,-48
    800007f2:	f406                	sd	ra,40(sp)
    800007f4:	f022                	sd	s0,32(sp)
    800007f6:	ec26                	sd	s1,24(sp)
    800007f8:	e84a                	sd	s2,16(sp)
    800007fa:	e44e                	sd	s3,8(sp)
    800007fc:	e052                	sd	s4,0(sp)
    800007fe:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000800:	6785                	lui	a5,0x1
    80000802:	04f67863          	bgeu	a2,a5,80000852 <uvmfirst+0x62>
    80000806:	8a2a                	mv	s4,a0
    80000808:	89ae                	mv	s3,a1
    8000080a:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000080c:	00000097          	auipc	ra,0x0
    80000810:	90e080e7          	jalr	-1778(ra) # 8000011a <kalloc>
    80000814:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000816:	6605                	lui	a2,0x1
    80000818:	4581                	li	a1,0
    8000081a:	00000097          	auipc	ra,0x0
    8000081e:	960080e7          	jalr	-1696(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000822:	4779                	li	a4,30
    80000824:	86ca                	mv	a3,s2
    80000826:	6605                	lui	a2,0x1
    80000828:	4581                	li	a1,0
    8000082a:	8552                	mv	a0,s4
    8000082c:	00000097          	auipc	ra,0x0
    80000830:	d1a080e7          	jalr	-742(ra) # 80000546 <mappages>
  memmove(mem, src, sz);
    80000834:	8626                	mv	a2,s1
    80000836:	85ce                	mv	a1,s3
    80000838:	854a                	mv	a0,s2
    8000083a:	00000097          	auipc	ra,0x0
    8000083e:	99c080e7          	jalr	-1636(ra) # 800001d6 <memmove>
}
    80000842:	70a2                	ld	ra,40(sp)
    80000844:	7402                	ld	s0,32(sp)
    80000846:	64e2                	ld	s1,24(sp)
    80000848:	6942                	ld	s2,16(sp)
    8000084a:	69a2                	ld	s3,8(sp)
    8000084c:	6a02                	ld	s4,0(sp)
    8000084e:	6145                	addi	sp,sp,48
    80000850:	8082                	ret
    panic("uvmfirst: more than a page");
    80000852:	00008517          	auipc	a0,0x8
    80000856:	86e50513          	addi	a0,a0,-1938 # 800080c0 <etext+0xc0>
    8000085a:	00005097          	auipc	ra,0x5
    8000085e:	3b2080e7          	jalr	946(ra) # 80005c0c <panic>

0000000080000862 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000862:	1101                	addi	sp,sp,-32
    80000864:	ec06                	sd	ra,24(sp)
    80000866:	e822                	sd	s0,16(sp)
    80000868:	e426                	sd	s1,8(sp)
    8000086a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000086c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000086e:	00b67d63          	bgeu	a2,a1,80000888 <uvmdealloc+0x26>
    80000872:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000874:	6785                	lui	a5,0x1
    80000876:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000878:	00f60733          	add	a4,a2,a5
    8000087c:	76fd                	lui	a3,0xfffff
    8000087e:	8f75                	and	a4,a4,a3
    80000880:	97ae                	add	a5,a5,a1
    80000882:	8ff5                	and	a5,a5,a3
    80000884:	00f76863          	bltu	a4,a5,80000894 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000888:	8526                	mv	a0,s1
    8000088a:	60e2                	ld	ra,24(sp)
    8000088c:	6442                	ld	s0,16(sp)
    8000088e:	64a2                	ld	s1,8(sp)
    80000890:	6105                	addi	sp,sp,32
    80000892:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000894:	8f99                	sub	a5,a5,a4
    80000896:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000898:	4685                	li	a3,1
    8000089a:	0007861b          	sext.w	a2,a5
    8000089e:	85ba                	mv	a1,a4
    800008a0:	00000097          	auipc	ra,0x0
    800008a4:	e6c080e7          	jalr	-404(ra) # 8000070c <uvmunmap>
    800008a8:	b7c5                	j	80000888 <uvmdealloc+0x26>

00000000800008aa <uvmalloc>:
  if(newsz < oldsz)
    800008aa:	0ab66563          	bltu	a2,a1,80000954 <uvmalloc+0xaa>
{
    800008ae:	7139                	addi	sp,sp,-64
    800008b0:	fc06                	sd	ra,56(sp)
    800008b2:	f822                	sd	s0,48(sp)
    800008b4:	f426                	sd	s1,40(sp)
    800008b6:	f04a                	sd	s2,32(sp)
    800008b8:	ec4e                	sd	s3,24(sp)
    800008ba:	e852                	sd	s4,16(sp)
    800008bc:	e456                	sd	s5,8(sp)
    800008be:	e05a                	sd	s6,0(sp)
    800008c0:	0080                	addi	s0,sp,64
    800008c2:	8aaa                	mv	s5,a0
    800008c4:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008c6:	6785                	lui	a5,0x1
    800008c8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008ca:	95be                	add	a1,a1,a5
    800008cc:	77fd                	lui	a5,0xfffff
    800008ce:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008d2:	08c9f363          	bgeu	s3,a2,80000958 <uvmalloc+0xae>
    800008d6:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008d8:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008dc:	00000097          	auipc	ra,0x0
    800008e0:	83e080e7          	jalr	-1986(ra) # 8000011a <kalloc>
    800008e4:	84aa                	mv	s1,a0
    if(mem == 0){
    800008e6:	c51d                	beqz	a0,80000914 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008e8:	6605                	lui	a2,0x1
    800008ea:	4581                	li	a1,0
    800008ec:	00000097          	auipc	ra,0x0
    800008f0:	88e080e7          	jalr	-1906(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008f4:	875a                	mv	a4,s6
    800008f6:	86a6                	mv	a3,s1
    800008f8:	6605                	lui	a2,0x1
    800008fa:	85ca                	mv	a1,s2
    800008fc:	8556                	mv	a0,s5
    800008fe:	00000097          	auipc	ra,0x0
    80000902:	c48080e7          	jalr	-952(ra) # 80000546 <mappages>
    80000906:	e90d                	bnez	a0,80000938 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000908:	6785                	lui	a5,0x1
    8000090a:	993e                	add	s2,s2,a5
    8000090c:	fd4968e3          	bltu	s2,s4,800008dc <uvmalloc+0x32>
  return newsz;
    80000910:	8552                	mv	a0,s4
    80000912:	a809                	j	80000924 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000914:	864e                	mv	a2,s3
    80000916:	85ca                	mv	a1,s2
    80000918:	8556                	mv	a0,s5
    8000091a:	00000097          	auipc	ra,0x0
    8000091e:	f48080e7          	jalr	-184(ra) # 80000862 <uvmdealloc>
      return 0;
    80000922:	4501                	li	a0,0
}
    80000924:	70e2                	ld	ra,56(sp)
    80000926:	7442                	ld	s0,48(sp)
    80000928:	74a2                	ld	s1,40(sp)
    8000092a:	7902                	ld	s2,32(sp)
    8000092c:	69e2                	ld	s3,24(sp)
    8000092e:	6a42                	ld	s4,16(sp)
    80000930:	6aa2                	ld	s5,8(sp)
    80000932:	6b02                	ld	s6,0(sp)
    80000934:	6121                	addi	sp,sp,64
    80000936:	8082                	ret
      kfree(mem);
    80000938:	8526                	mv	a0,s1
    8000093a:	fffff097          	auipc	ra,0xfffff
    8000093e:	6e2080e7          	jalr	1762(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000942:	864e                	mv	a2,s3
    80000944:	85ca                	mv	a1,s2
    80000946:	8556                	mv	a0,s5
    80000948:	00000097          	auipc	ra,0x0
    8000094c:	f1a080e7          	jalr	-230(ra) # 80000862 <uvmdealloc>
      return 0;
    80000950:	4501                	li	a0,0
    80000952:	bfc9                	j	80000924 <uvmalloc+0x7a>
    return oldsz;
    80000954:	852e                	mv	a0,a1
}
    80000956:	8082                	ret
  return newsz;
    80000958:	8532                	mv	a0,a2
    8000095a:	b7e9                	j	80000924 <uvmalloc+0x7a>

000000008000095c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000095c:	7179                	addi	sp,sp,-48
    8000095e:	f406                	sd	ra,40(sp)
    80000960:	f022                	sd	s0,32(sp)
    80000962:	ec26                	sd	s1,24(sp)
    80000964:	e84a                	sd	s2,16(sp)
    80000966:	e44e                	sd	s3,8(sp)
    80000968:	e052                	sd	s4,0(sp)
    8000096a:	1800                	addi	s0,sp,48
    8000096c:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000096e:	84aa                	mv	s1,a0
    80000970:	6905                	lui	s2,0x1
    80000972:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000974:	4985                	li	s3,1
    80000976:	a829                	j	80000990 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000978:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000097a:	00c79513          	slli	a0,a5,0xc
    8000097e:	00000097          	auipc	ra,0x0
    80000982:	fde080e7          	jalr	-34(ra) # 8000095c <freewalk>
      pagetable[i] = 0;
    80000986:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000098a:	04a1                	addi	s1,s1,8
    8000098c:	03248163          	beq	s1,s2,800009ae <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000990:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000992:	00f7f713          	andi	a4,a5,15
    80000996:	ff3701e3          	beq	a4,s3,80000978 <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000099a:	8b85                	andi	a5,a5,1
    8000099c:	d7fd                	beqz	a5,8000098a <freewalk+0x2e>
      panic("freewalk: leaf");
    8000099e:	00007517          	auipc	a0,0x7
    800009a2:	74250513          	addi	a0,a0,1858 # 800080e0 <etext+0xe0>
    800009a6:	00005097          	auipc	ra,0x5
    800009aa:	266080e7          	jalr	614(ra) # 80005c0c <panic>
    }
  }
  kfree((void*)pagetable);
    800009ae:	8552                	mv	a0,s4
    800009b0:	fffff097          	auipc	ra,0xfffff
    800009b4:	66c080e7          	jalr	1644(ra) # 8000001c <kfree>
}
    800009b8:	70a2                	ld	ra,40(sp)
    800009ba:	7402                	ld	s0,32(sp)
    800009bc:	64e2                	ld	s1,24(sp)
    800009be:	6942                	ld	s2,16(sp)
    800009c0:	69a2                	ld	s3,8(sp)
    800009c2:	6a02                	ld	s4,0(sp)
    800009c4:	6145                	addi	sp,sp,48
    800009c6:	8082                	ret

00000000800009c8 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009c8:	1101                	addi	sp,sp,-32
    800009ca:	ec06                	sd	ra,24(sp)
    800009cc:	e822                	sd	s0,16(sp)
    800009ce:	e426                	sd	s1,8(sp)
    800009d0:	1000                	addi	s0,sp,32
    800009d2:	84aa                	mv	s1,a0
  if(sz > 0)
    800009d4:	e999                	bnez	a1,800009ea <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009d6:	8526                	mv	a0,s1
    800009d8:	00000097          	auipc	ra,0x0
    800009dc:	f84080e7          	jalr	-124(ra) # 8000095c <freewalk>
}
    800009e0:	60e2                	ld	ra,24(sp)
    800009e2:	6442                	ld	s0,16(sp)
    800009e4:	64a2                	ld	s1,8(sp)
    800009e6:	6105                	addi	sp,sp,32
    800009e8:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009ea:	6785                	lui	a5,0x1
    800009ec:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009ee:	95be                	add	a1,a1,a5
    800009f0:	4685                	li	a3,1
    800009f2:	00c5d613          	srli	a2,a1,0xc
    800009f6:	4581                	li	a1,0
    800009f8:	00000097          	auipc	ra,0x0
    800009fc:	d14080e7          	jalr	-748(ra) # 8000070c <uvmunmap>
    80000a00:	bfd9                	j	800009d6 <uvmfree+0xe>

0000000080000a02 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a02:	c269                	beqz	a2,80000ac4 <uvmcopy+0xc2>
{
    80000a04:	715d                	addi	sp,sp,-80
    80000a06:	e486                	sd	ra,72(sp)
    80000a08:	e0a2                	sd	s0,64(sp)
    80000a0a:	fc26                	sd	s1,56(sp)
    80000a0c:	f84a                	sd	s2,48(sp)
    80000a0e:	f44e                	sd	s3,40(sp)
    80000a10:	f052                	sd	s4,32(sp)
    80000a12:	ec56                	sd	s5,24(sp)
    80000a14:	e85a                	sd	s6,16(sp)
    80000a16:	e45e                	sd	s7,8(sp)
    80000a18:	0880                	addi	s0,sp,80
    80000a1a:	8aaa                	mv	s5,a0
    80000a1c:	8b2e                	mv	s6,a1
    80000a1e:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a20:	4481                	li	s1,0
    80000a22:	a829                	j	80000a3c <uvmcopy+0x3a>
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    80000a24:	00007517          	auipc	a0,0x7
    80000a28:	6cc50513          	addi	a0,a0,1740 # 800080f0 <etext+0xf0>
    80000a2c:	00005097          	auipc	ra,0x5
    80000a30:	1e0080e7          	jalr	480(ra) # 80005c0c <panic>
  for(i = 0; i < sz; i += PGSIZE){
    80000a34:	6785                	lui	a5,0x1
    80000a36:	94be                	add	s1,s1,a5
    80000a38:	0944f463          	bgeu	s1,s4,80000ac0 <uvmcopy+0xbe>
    if((pte = walk(old, i, 0)) == 0)
    80000a3c:	4601                	li	a2,0
    80000a3e:	85a6                	mv	a1,s1
    80000a40:	8556                	mv	a0,s5
    80000a42:	00000097          	auipc	ra,0x0
    80000a46:	a1c080e7          	jalr	-1508(ra) # 8000045e <walk>
    80000a4a:	dd69                	beqz	a0,80000a24 <uvmcopy+0x22>
    if((*pte & PTE_V) == 0) continue;
    80000a4c:	6118                	ld	a4,0(a0)
    80000a4e:	00177793          	andi	a5,a4,1
    80000a52:	d3ed                	beqz	a5,80000a34 <uvmcopy+0x32>
      // panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a54:	00a75593          	srli	a1,a4,0xa
    80000a58:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a5c:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    80000a60:	fffff097          	auipc	ra,0xfffff
    80000a64:	6ba080e7          	jalr	1722(ra) # 8000011a <kalloc>
    80000a68:	89aa                	mv	s3,a0
    80000a6a:	c515                	beqz	a0,80000a96 <uvmcopy+0x94>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a6c:	6605                	lui	a2,0x1
    80000a6e:	85de                	mv	a1,s7
    80000a70:	fffff097          	auipc	ra,0xfffff
    80000a74:	766080e7          	jalr	1894(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a78:	874a                	mv	a4,s2
    80000a7a:	86ce                	mv	a3,s3
    80000a7c:	6605                	lui	a2,0x1
    80000a7e:	85a6                	mv	a1,s1
    80000a80:	855a                	mv	a0,s6
    80000a82:	00000097          	auipc	ra,0x0
    80000a86:	ac4080e7          	jalr	-1340(ra) # 80000546 <mappages>
    80000a8a:	d54d                	beqz	a0,80000a34 <uvmcopy+0x32>
      kfree(mem);
    80000a8c:	854e                	mv	a0,s3
    80000a8e:	fffff097          	auipc	ra,0xfffff
    80000a92:	58e080e7          	jalr	1422(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000a96:	4685                	li	a3,1
    80000a98:	00c4d613          	srli	a2,s1,0xc
    80000a9c:	4581                	li	a1,0
    80000a9e:	855a                	mv	a0,s6
    80000aa0:	00000097          	auipc	ra,0x0
    80000aa4:	c6c080e7          	jalr	-916(ra) # 8000070c <uvmunmap>
  return -1;
    80000aa8:	557d                	li	a0,-1
}
    80000aaa:	60a6                	ld	ra,72(sp)
    80000aac:	6406                	ld	s0,64(sp)
    80000aae:	74e2                	ld	s1,56(sp)
    80000ab0:	7942                	ld	s2,48(sp)
    80000ab2:	79a2                	ld	s3,40(sp)
    80000ab4:	7a02                	ld	s4,32(sp)
    80000ab6:	6ae2                	ld	s5,24(sp)
    80000ab8:	6b42                	ld	s6,16(sp)
    80000aba:	6ba2                	ld	s7,8(sp)
    80000abc:	6161                	addi	sp,sp,80
    80000abe:	8082                	ret
  return 0;
    80000ac0:	4501                	li	a0,0
    80000ac2:	b7e5                	j	80000aaa <uvmcopy+0xa8>
    80000ac4:	4501                	li	a0,0
}
    80000ac6:	8082                	ret

0000000080000ac8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ac8:	1141                	addi	sp,sp,-16
    80000aca:	e406                	sd	ra,8(sp)
    80000acc:	e022                	sd	s0,0(sp)
    80000ace:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ad0:	4601                	li	a2,0
    80000ad2:	00000097          	auipc	ra,0x0
    80000ad6:	98c080e7          	jalr	-1652(ra) # 8000045e <walk>
  if(pte == 0)
    80000ada:	c901                	beqz	a0,80000aea <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000adc:	611c                	ld	a5,0(a0)
    80000ade:	9bbd                	andi	a5,a5,-17
    80000ae0:	e11c                	sd	a5,0(a0)
}
    80000ae2:	60a2                	ld	ra,8(sp)
    80000ae4:	6402                	ld	s0,0(sp)
    80000ae6:	0141                	addi	sp,sp,16
    80000ae8:	8082                	ret
    panic("uvmclear");
    80000aea:	00007517          	auipc	a0,0x7
    80000aee:	62650513          	addi	a0,a0,1574 # 80008110 <etext+0x110>
    80000af2:	00005097          	auipc	ra,0x5
    80000af6:	11a080e7          	jalr	282(ra) # 80005c0c <panic>

0000000080000afa <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000afa:	c6bd                	beqz	a3,80000b68 <copyout+0x6e>
{
    80000afc:	715d                	addi	sp,sp,-80
    80000afe:	e486                	sd	ra,72(sp)
    80000b00:	e0a2                	sd	s0,64(sp)
    80000b02:	fc26                	sd	s1,56(sp)
    80000b04:	f84a                	sd	s2,48(sp)
    80000b06:	f44e                	sd	s3,40(sp)
    80000b08:	f052                	sd	s4,32(sp)
    80000b0a:	ec56                	sd	s5,24(sp)
    80000b0c:	e85a                	sd	s6,16(sp)
    80000b0e:	e45e                	sd	s7,8(sp)
    80000b10:	e062                	sd	s8,0(sp)
    80000b12:	0880                	addi	s0,sp,80
    80000b14:	8b2a                	mv	s6,a0
    80000b16:	8c2e                	mv	s8,a1
    80000b18:	8a32                	mv	s4,a2
    80000b1a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b1c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b1e:	6a85                	lui	s5,0x1
    80000b20:	a015                	j	80000b44 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b22:	9562                	add	a0,a0,s8
    80000b24:	0004861b          	sext.w	a2,s1
    80000b28:	85d2                	mv	a1,s4
    80000b2a:	41250533          	sub	a0,a0,s2
    80000b2e:	fffff097          	auipc	ra,0xfffff
    80000b32:	6a8080e7          	jalr	1704(ra) # 800001d6 <memmove>

    len -= n;
    80000b36:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b3a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b3c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b40:	02098263          	beqz	s3,80000b64 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b44:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b48:	85ca                	mv	a1,s2
    80000b4a:	855a                	mv	a0,s6
    80000b4c:	00000097          	auipc	ra,0x0
    80000b50:	9b8080e7          	jalr	-1608(ra) # 80000504 <walkaddr>
    if(pa0 == 0)
    80000b54:	cd01                	beqz	a0,80000b6c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b56:	418904b3          	sub	s1,s2,s8
    80000b5a:	94d6                	add	s1,s1,s5
    80000b5c:	fc99f3e3          	bgeu	s3,s1,80000b22 <copyout+0x28>
    80000b60:	84ce                	mv	s1,s3
    80000b62:	b7c1                	j	80000b22 <copyout+0x28>
  }
  return 0;
    80000b64:	4501                	li	a0,0
    80000b66:	a021                	j	80000b6e <copyout+0x74>
    80000b68:	4501                	li	a0,0
}
    80000b6a:	8082                	ret
      return -1;
    80000b6c:	557d                	li	a0,-1
}
    80000b6e:	60a6                	ld	ra,72(sp)
    80000b70:	6406                	ld	s0,64(sp)
    80000b72:	74e2                	ld	s1,56(sp)
    80000b74:	7942                	ld	s2,48(sp)
    80000b76:	79a2                	ld	s3,40(sp)
    80000b78:	7a02                	ld	s4,32(sp)
    80000b7a:	6ae2                	ld	s5,24(sp)
    80000b7c:	6b42                	ld	s6,16(sp)
    80000b7e:	6ba2                	ld	s7,8(sp)
    80000b80:	6c02                	ld	s8,0(sp)
    80000b82:	6161                	addi	sp,sp,80
    80000b84:	8082                	ret

0000000080000b86 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b86:	caa5                	beqz	a3,80000bf6 <copyin+0x70>
{
    80000b88:	715d                	addi	sp,sp,-80
    80000b8a:	e486                	sd	ra,72(sp)
    80000b8c:	e0a2                	sd	s0,64(sp)
    80000b8e:	fc26                	sd	s1,56(sp)
    80000b90:	f84a                	sd	s2,48(sp)
    80000b92:	f44e                	sd	s3,40(sp)
    80000b94:	f052                	sd	s4,32(sp)
    80000b96:	ec56                	sd	s5,24(sp)
    80000b98:	e85a                	sd	s6,16(sp)
    80000b9a:	e45e                	sd	s7,8(sp)
    80000b9c:	e062                	sd	s8,0(sp)
    80000b9e:	0880                	addi	s0,sp,80
    80000ba0:	8b2a                	mv	s6,a0
    80000ba2:	8a2e                	mv	s4,a1
    80000ba4:	8c32                	mv	s8,a2
    80000ba6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000ba8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000baa:	6a85                	lui	s5,0x1
    80000bac:	a01d                	j	80000bd2 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bae:	018505b3          	add	a1,a0,s8
    80000bb2:	0004861b          	sext.w	a2,s1
    80000bb6:	412585b3          	sub	a1,a1,s2
    80000bba:	8552                	mv	a0,s4
    80000bbc:	fffff097          	auipc	ra,0xfffff
    80000bc0:	61a080e7          	jalr	1562(ra) # 800001d6 <memmove>

    len -= n;
    80000bc4:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bc8:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bca:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bce:	02098263          	beqz	s3,80000bf2 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bd2:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bd6:	85ca                	mv	a1,s2
    80000bd8:	855a                	mv	a0,s6
    80000bda:	00000097          	auipc	ra,0x0
    80000bde:	92a080e7          	jalr	-1750(ra) # 80000504 <walkaddr>
    if(pa0 == 0)
    80000be2:	cd01                	beqz	a0,80000bfa <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000be4:	418904b3          	sub	s1,s2,s8
    80000be8:	94d6                	add	s1,s1,s5
    80000bea:	fc99f2e3          	bgeu	s3,s1,80000bae <copyin+0x28>
    80000bee:	84ce                	mv	s1,s3
    80000bf0:	bf7d                	j	80000bae <copyin+0x28>
  }
  return 0;
    80000bf2:	4501                	li	a0,0
    80000bf4:	a021                	j	80000bfc <copyin+0x76>
    80000bf6:	4501                	li	a0,0
}
    80000bf8:	8082                	ret
      return -1;
    80000bfa:	557d                	li	a0,-1
}
    80000bfc:	60a6                	ld	ra,72(sp)
    80000bfe:	6406                	ld	s0,64(sp)
    80000c00:	74e2                	ld	s1,56(sp)
    80000c02:	7942                	ld	s2,48(sp)
    80000c04:	79a2                	ld	s3,40(sp)
    80000c06:	7a02                	ld	s4,32(sp)
    80000c08:	6ae2                	ld	s5,24(sp)
    80000c0a:	6b42                	ld	s6,16(sp)
    80000c0c:	6ba2                	ld	s7,8(sp)
    80000c0e:	6c02                	ld	s8,0(sp)
    80000c10:	6161                	addi	sp,sp,80
    80000c12:	8082                	ret

0000000080000c14 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c14:	c2dd                	beqz	a3,80000cba <copyinstr+0xa6>
{
    80000c16:	715d                	addi	sp,sp,-80
    80000c18:	e486                	sd	ra,72(sp)
    80000c1a:	e0a2                	sd	s0,64(sp)
    80000c1c:	fc26                	sd	s1,56(sp)
    80000c1e:	f84a                	sd	s2,48(sp)
    80000c20:	f44e                	sd	s3,40(sp)
    80000c22:	f052                	sd	s4,32(sp)
    80000c24:	ec56                	sd	s5,24(sp)
    80000c26:	e85a                	sd	s6,16(sp)
    80000c28:	e45e                	sd	s7,8(sp)
    80000c2a:	0880                	addi	s0,sp,80
    80000c2c:	8a2a                	mv	s4,a0
    80000c2e:	8b2e                	mv	s6,a1
    80000c30:	8bb2                	mv	s7,a2
    80000c32:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c34:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c36:	6985                	lui	s3,0x1
    80000c38:	a02d                	j	80000c62 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c3a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c3e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c40:	37fd                	addiw	a5,a5,-1
    80000c42:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c46:	60a6                	ld	ra,72(sp)
    80000c48:	6406                	ld	s0,64(sp)
    80000c4a:	74e2                	ld	s1,56(sp)
    80000c4c:	7942                	ld	s2,48(sp)
    80000c4e:	79a2                	ld	s3,40(sp)
    80000c50:	7a02                	ld	s4,32(sp)
    80000c52:	6ae2                	ld	s5,24(sp)
    80000c54:	6b42                	ld	s6,16(sp)
    80000c56:	6ba2                	ld	s7,8(sp)
    80000c58:	6161                	addi	sp,sp,80
    80000c5a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c5c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c60:	c8a9                	beqz	s1,80000cb2 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c62:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c66:	85ca                	mv	a1,s2
    80000c68:	8552                	mv	a0,s4
    80000c6a:	00000097          	auipc	ra,0x0
    80000c6e:	89a080e7          	jalr	-1894(ra) # 80000504 <walkaddr>
    if(pa0 == 0)
    80000c72:	c131                	beqz	a0,80000cb6 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000c74:	417906b3          	sub	a3,s2,s7
    80000c78:	96ce                	add	a3,a3,s3
    80000c7a:	00d4f363          	bgeu	s1,a3,80000c80 <copyinstr+0x6c>
    80000c7e:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c80:	955e                	add	a0,a0,s7
    80000c82:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c86:	daf9                	beqz	a3,80000c5c <copyinstr+0x48>
    80000c88:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c8a:	41650633          	sub	a2,a0,s6
    80000c8e:	fff48593          	addi	a1,s1,-1
    80000c92:	95da                	add	a1,a1,s6
    while(n > 0){
    80000c94:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000c96:	00f60733          	add	a4,a2,a5
    80000c9a:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdd2b0>
    80000c9e:	df51                	beqz	a4,80000c3a <copyinstr+0x26>
        *dst = *p;
    80000ca0:	00e78023          	sb	a4,0(a5)
      --max;
    80000ca4:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000ca8:	0785                	addi	a5,a5,1
    while(n > 0){
    80000caa:	fed796e3          	bne	a5,a3,80000c96 <copyinstr+0x82>
      dst++;
    80000cae:	8b3e                	mv	s6,a5
    80000cb0:	b775                	j	80000c5c <copyinstr+0x48>
    80000cb2:	4781                	li	a5,0
    80000cb4:	b771                	j	80000c40 <copyinstr+0x2c>
      return -1;
    80000cb6:	557d                	li	a0,-1
    80000cb8:	b779                	j	80000c46 <copyinstr+0x32>
  int got_null = 0;
    80000cba:	4781                	li	a5,0
  if(got_null){
    80000cbc:	37fd                	addiw	a5,a5,-1
    80000cbe:	0007851b          	sext.w	a0,a5
}
    80000cc2:	8082                	ret

0000000080000cc4 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000cc4:	7139                	addi	sp,sp,-64
    80000cc6:	fc06                	sd	ra,56(sp)
    80000cc8:	f822                	sd	s0,48(sp)
    80000cca:	f426                	sd	s1,40(sp)
    80000ccc:	f04a                	sd	s2,32(sp)
    80000cce:	ec4e                	sd	s3,24(sp)
    80000cd0:	e852                	sd	s4,16(sp)
    80000cd2:	e456                	sd	s5,8(sp)
    80000cd4:	e05a                	sd	s6,0(sp)
    80000cd6:	0080                	addi	s0,sp,64
    80000cd8:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cda:	00008497          	auipc	s1,0x8
    80000cde:	05648493          	addi	s1,s1,86 # 80008d30 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000ce2:	8b26                	mv	s6,s1
    80000ce4:	00007a97          	auipc	s5,0x7
    80000ce8:	31ca8a93          	addi	s5,s5,796 # 80008000 <etext>
    80000cec:	04000937          	lui	s2,0x4000
    80000cf0:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000cf2:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf4:	0000ea17          	auipc	s4,0xe
    80000cf8:	a3ca0a13          	addi	s4,s4,-1476 # 8000e730 <tickslock>
    char *pa = kalloc();
    80000cfc:	fffff097          	auipc	ra,0xfffff
    80000d00:	41e080e7          	jalr	1054(ra) # 8000011a <kalloc>
    80000d04:	862a                	mv	a2,a0
    if(pa == 0)
    80000d06:	c131                	beqz	a0,80000d4a <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d08:	416485b3          	sub	a1,s1,s6
    80000d0c:	858d                	srai	a1,a1,0x3
    80000d0e:	000ab783          	ld	a5,0(s5)
    80000d12:	02f585b3          	mul	a1,a1,a5
    80000d16:	2585                	addiw	a1,a1,1
    80000d18:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d1c:	4719                	li	a4,6
    80000d1e:	6685                	lui	a3,0x1
    80000d20:	40b905b3          	sub	a1,s2,a1
    80000d24:	854e                	mv	a0,s3
    80000d26:	00000097          	auipc	ra,0x0
    80000d2a:	8c0080e7          	jalr	-1856(ra) # 800005e6 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d2e:	16848493          	addi	s1,s1,360
    80000d32:	fd4495e3          	bne	s1,s4,80000cfc <proc_mapstacks+0x38>
  }
}
    80000d36:	70e2                	ld	ra,56(sp)
    80000d38:	7442                	ld	s0,48(sp)
    80000d3a:	74a2                	ld	s1,40(sp)
    80000d3c:	7902                	ld	s2,32(sp)
    80000d3e:	69e2                	ld	s3,24(sp)
    80000d40:	6a42                	ld	s4,16(sp)
    80000d42:	6aa2                	ld	s5,8(sp)
    80000d44:	6b02                	ld	s6,0(sp)
    80000d46:	6121                	addi	sp,sp,64
    80000d48:	8082                	ret
      panic("kalloc");
    80000d4a:	00007517          	auipc	a0,0x7
    80000d4e:	3d650513          	addi	a0,a0,982 # 80008120 <etext+0x120>
    80000d52:	00005097          	auipc	ra,0x5
    80000d56:	eba080e7          	jalr	-326(ra) # 80005c0c <panic>

0000000080000d5a <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d5a:	7139                	addi	sp,sp,-64
    80000d5c:	fc06                	sd	ra,56(sp)
    80000d5e:	f822                	sd	s0,48(sp)
    80000d60:	f426                	sd	s1,40(sp)
    80000d62:	f04a                	sd	s2,32(sp)
    80000d64:	ec4e                	sd	s3,24(sp)
    80000d66:	e852                	sd	s4,16(sp)
    80000d68:	e456                	sd	s5,8(sp)
    80000d6a:	e05a                	sd	s6,0(sp)
    80000d6c:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d6e:	00007597          	auipc	a1,0x7
    80000d72:	3ba58593          	addi	a1,a1,954 # 80008128 <etext+0x128>
    80000d76:	00008517          	auipc	a0,0x8
    80000d7a:	b8a50513          	addi	a0,a0,-1142 # 80008900 <pid_lock>
    80000d7e:	00005097          	auipc	ra,0x5
    80000d82:	336080e7          	jalr	822(ra) # 800060b4 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d86:	00007597          	auipc	a1,0x7
    80000d8a:	3aa58593          	addi	a1,a1,938 # 80008130 <etext+0x130>
    80000d8e:	00008517          	auipc	a0,0x8
    80000d92:	b8a50513          	addi	a0,a0,-1142 # 80008918 <wait_lock>
    80000d96:	00005097          	auipc	ra,0x5
    80000d9a:	31e080e7          	jalr	798(ra) # 800060b4 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d9e:	00008497          	auipc	s1,0x8
    80000da2:	f9248493          	addi	s1,s1,-110 # 80008d30 <proc>
      initlock(&p->lock, "proc");
    80000da6:	00007b17          	auipc	s6,0x7
    80000daa:	39ab0b13          	addi	s6,s6,922 # 80008140 <etext+0x140>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000dae:	8aa6                	mv	s5,s1
    80000db0:	00007a17          	auipc	s4,0x7
    80000db4:	250a0a13          	addi	s4,s4,592 # 80008000 <etext>
    80000db8:	04000937          	lui	s2,0x4000
    80000dbc:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000dbe:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dc0:	0000e997          	auipc	s3,0xe
    80000dc4:	97098993          	addi	s3,s3,-1680 # 8000e730 <tickslock>
      initlock(&p->lock, "proc");
    80000dc8:	85da                	mv	a1,s6
    80000dca:	8526                	mv	a0,s1
    80000dcc:	00005097          	auipc	ra,0x5
    80000dd0:	2e8080e7          	jalr	744(ra) # 800060b4 <initlock>
      p->state = UNUSED;
    80000dd4:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000dd8:	415487b3          	sub	a5,s1,s5
    80000ddc:	878d                	srai	a5,a5,0x3
    80000dde:	000a3703          	ld	a4,0(s4)
    80000de2:	02e787b3          	mul	a5,a5,a4
    80000de6:	2785                	addiw	a5,a5,1
    80000de8:	00d7979b          	slliw	a5,a5,0xd
    80000dec:	40f907b3          	sub	a5,s2,a5
    80000df0:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000df2:	16848493          	addi	s1,s1,360
    80000df6:	fd3499e3          	bne	s1,s3,80000dc8 <procinit+0x6e>
  }
}
    80000dfa:	70e2                	ld	ra,56(sp)
    80000dfc:	7442                	ld	s0,48(sp)
    80000dfe:	74a2                	ld	s1,40(sp)
    80000e00:	7902                	ld	s2,32(sp)
    80000e02:	69e2                	ld	s3,24(sp)
    80000e04:	6a42                	ld	s4,16(sp)
    80000e06:	6aa2                	ld	s5,8(sp)
    80000e08:	6b02                	ld	s6,0(sp)
    80000e0a:	6121                	addi	sp,sp,64
    80000e0c:	8082                	ret

0000000080000e0e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e0e:	1141                	addi	sp,sp,-16
    80000e10:	e422                	sd	s0,8(sp)
    80000e12:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e14:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e16:	2501                	sext.w	a0,a0
    80000e18:	6422                	ld	s0,8(sp)
    80000e1a:	0141                	addi	sp,sp,16
    80000e1c:	8082                	ret

0000000080000e1e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e1e:	1141                	addi	sp,sp,-16
    80000e20:	e422                	sd	s0,8(sp)
    80000e22:	0800                	addi	s0,sp,16
    80000e24:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e26:	2781                	sext.w	a5,a5
    80000e28:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e2a:	00008517          	auipc	a0,0x8
    80000e2e:	b0650513          	addi	a0,a0,-1274 # 80008930 <cpus>
    80000e32:	953e                	add	a0,a0,a5
    80000e34:	6422                	ld	s0,8(sp)
    80000e36:	0141                	addi	sp,sp,16
    80000e38:	8082                	ret

0000000080000e3a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e3a:	1101                	addi	sp,sp,-32
    80000e3c:	ec06                	sd	ra,24(sp)
    80000e3e:	e822                	sd	s0,16(sp)
    80000e40:	e426                	sd	s1,8(sp)
    80000e42:	1000                	addi	s0,sp,32
  push_off();
    80000e44:	00005097          	auipc	ra,0x5
    80000e48:	2b4080e7          	jalr	692(ra) # 800060f8 <push_off>
    80000e4c:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e4e:	2781                	sext.w	a5,a5
    80000e50:	079e                	slli	a5,a5,0x7
    80000e52:	00008717          	auipc	a4,0x8
    80000e56:	aae70713          	addi	a4,a4,-1362 # 80008900 <pid_lock>
    80000e5a:	97ba                	add	a5,a5,a4
    80000e5c:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e5e:	00005097          	auipc	ra,0x5
    80000e62:	33a080e7          	jalr	826(ra) # 80006198 <pop_off>
  return p;
}
    80000e66:	8526                	mv	a0,s1
    80000e68:	60e2                	ld	ra,24(sp)
    80000e6a:	6442                	ld	s0,16(sp)
    80000e6c:	64a2                	ld	s1,8(sp)
    80000e6e:	6105                	addi	sp,sp,32
    80000e70:	8082                	ret

0000000080000e72 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e72:	1141                	addi	sp,sp,-16
    80000e74:	e406                	sd	ra,8(sp)
    80000e76:	e022                	sd	s0,0(sp)
    80000e78:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e7a:	00000097          	auipc	ra,0x0
    80000e7e:	fc0080e7          	jalr	-64(ra) # 80000e3a <myproc>
    80000e82:	00005097          	auipc	ra,0x5
    80000e86:	376080e7          	jalr	886(ra) # 800061f8 <release>

  if (first) {
    80000e8a:	00008797          	auipc	a5,0x8
    80000e8e:	9b67a783          	lw	a5,-1610(a5) # 80008840 <first.1>
    80000e92:	eb89                	bnez	a5,80000ea4 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000e94:	00001097          	auipc	ra,0x1
    80000e98:	c5c080e7          	jalr	-932(ra) # 80001af0 <usertrapret>
}
    80000e9c:	60a2                	ld	ra,8(sp)
    80000e9e:	6402                	ld	s0,0(sp)
    80000ea0:	0141                	addi	sp,sp,16
    80000ea2:	8082                	ret
    first = 0;
    80000ea4:	00008797          	auipc	a5,0x8
    80000ea8:	9807ae23          	sw	zero,-1636(a5) # 80008840 <first.1>
    fsinit(ROOTDEV);
    80000eac:	4505                	li	a0,1
    80000eae:	00002097          	auipc	ra,0x2
    80000eb2:	9c2080e7          	jalr	-1598(ra) # 80002870 <fsinit>
    80000eb6:	bff9                	j	80000e94 <forkret+0x22>

0000000080000eb8 <allocpid>:
{
    80000eb8:	1101                	addi	sp,sp,-32
    80000eba:	ec06                	sd	ra,24(sp)
    80000ebc:	e822                	sd	s0,16(sp)
    80000ebe:	e426                	sd	s1,8(sp)
    80000ec0:	e04a                	sd	s2,0(sp)
    80000ec2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ec4:	00008917          	auipc	s2,0x8
    80000ec8:	a3c90913          	addi	s2,s2,-1476 # 80008900 <pid_lock>
    80000ecc:	854a                	mv	a0,s2
    80000ece:	00005097          	auipc	ra,0x5
    80000ed2:	276080e7          	jalr	630(ra) # 80006144 <acquire>
  pid = nextpid;
    80000ed6:	00008797          	auipc	a5,0x8
    80000eda:	96e78793          	addi	a5,a5,-1682 # 80008844 <nextpid>
    80000ede:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ee0:	0014871b          	addiw	a4,s1,1
    80000ee4:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ee6:	854a                	mv	a0,s2
    80000ee8:	00005097          	auipc	ra,0x5
    80000eec:	310080e7          	jalr	784(ra) # 800061f8 <release>
}
    80000ef0:	8526                	mv	a0,s1
    80000ef2:	60e2                	ld	ra,24(sp)
    80000ef4:	6442                	ld	s0,16(sp)
    80000ef6:	64a2                	ld	s1,8(sp)
    80000ef8:	6902                	ld	s2,0(sp)
    80000efa:	6105                	addi	sp,sp,32
    80000efc:	8082                	ret

0000000080000efe <proc_pagetable>:
{
    80000efe:	1101                	addi	sp,sp,-32
    80000f00:	ec06                	sd	ra,24(sp)
    80000f02:	e822                	sd	s0,16(sp)
    80000f04:	e426                	sd	s1,8(sp)
    80000f06:	e04a                	sd	s2,0(sp)
    80000f08:	1000                	addi	s0,sp,32
    80000f0a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f0c:	00000097          	auipc	ra,0x0
    80000f10:	8b6080e7          	jalr	-1866(ra) # 800007c2 <uvmcreate>
    80000f14:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f16:	c121                	beqz	a0,80000f56 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f18:	4729                	li	a4,10
    80000f1a:	00006697          	auipc	a3,0x6
    80000f1e:	0e668693          	addi	a3,a3,230 # 80007000 <_trampoline>
    80000f22:	6605                	lui	a2,0x1
    80000f24:	040005b7          	lui	a1,0x4000
    80000f28:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f2a:	05b2                	slli	a1,a1,0xc
    80000f2c:	fffff097          	auipc	ra,0xfffff
    80000f30:	61a080e7          	jalr	1562(ra) # 80000546 <mappages>
    80000f34:	02054863          	bltz	a0,80000f64 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f38:	4719                	li	a4,6
    80000f3a:	05893683          	ld	a3,88(s2)
    80000f3e:	6605                	lui	a2,0x1
    80000f40:	020005b7          	lui	a1,0x2000
    80000f44:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f46:	05b6                	slli	a1,a1,0xd
    80000f48:	8526                	mv	a0,s1
    80000f4a:	fffff097          	auipc	ra,0xfffff
    80000f4e:	5fc080e7          	jalr	1532(ra) # 80000546 <mappages>
    80000f52:	02054163          	bltz	a0,80000f74 <proc_pagetable+0x76>
}
    80000f56:	8526                	mv	a0,s1
    80000f58:	60e2                	ld	ra,24(sp)
    80000f5a:	6442                	ld	s0,16(sp)
    80000f5c:	64a2                	ld	s1,8(sp)
    80000f5e:	6902                	ld	s2,0(sp)
    80000f60:	6105                	addi	sp,sp,32
    80000f62:	8082                	ret
    uvmfree(pagetable, 0);
    80000f64:	4581                	li	a1,0
    80000f66:	8526                	mv	a0,s1
    80000f68:	00000097          	auipc	ra,0x0
    80000f6c:	a60080e7          	jalr	-1440(ra) # 800009c8 <uvmfree>
    return 0;
    80000f70:	4481                	li	s1,0
    80000f72:	b7d5                	j	80000f56 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f74:	4681                	li	a3,0
    80000f76:	4605                	li	a2,1
    80000f78:	040005b7          	lui	a1,0x4000
    80000f7c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f7e:	05b2                	slli	a1,a1,0xc
    80000f80:	8526                	mv	a0,s1
    80000f82:	fffff097          	auipc	ra,0xfffff
    80000f86:	78a080e7          	jalr	1930(ra) # 8000070c <uvmunmap>
    uvmfree(pagetable, 0);
    80000f8a:	4581                	li	a1,0
    80000f8c:	8526                	mv	a0,s1
    80000f8e:	00000097          	auipc	ra,0x0
    80000f92:	a3a080e7          	jalr	-1478(ra) # 800009c8 <uvmfree>
    return 0;
    80000f96:	4481                	li	s1,0
    80000f98:	bf7d                	j	80000f56 <proc_pagetable+0x58>

0000000080000f9a <proc_freepagetable>:
{
    80000f9a:	1101                	addi	sp,sp,-32
    80000f9c:	ec06                	sd	ra,24(sp)
    80000f9e:	e822                	sd	s0,16(sp)
    80000fa0:	e426                	sd	s1,8(sp)
    80000fa2:	e04a                	sd	s2,0(sp)
    80000fa4:	1000                	addi	s0,sp,32
    80000fa6:	84aa                	mv	s1,a0
    80000fa8:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000faa:	4681                	li	a3,0
    80000fac:	4605                	li	a2,1
    80000fae:	040005b7          	lui	a1,0x4000
    80000fb2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fb4:	05b2                	slli	a1,a1,0xc
    80000fb6:	fffff097          	auipc	ra,0xfffff
    80000fba:	756080e7          	jalr	1878(ra) # 8000070c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fbe:	4681                	li	a3,0
    80000fc0:	4605                	li	a2,1
    80000fc2:	020005b7          	lui	a1,0x2000
    80000fc6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fc8:	05b6                	slli	a1,a1,0xd
    80000fca:	8526                	mv	a0,s1
    80000fcc:	fffff097          	auipc	ra,0xfffff
    80000fd0:	740080e7          	jalr	1856(ra) # 8000070c <uvmunmap>
  uvmfree(pagetable, sz);
    80000fd4:	85ca                	mv	a1,s2
    80000fd6:	8526                	mv	a0,s1
    80000fd8:	00000097          	auipc	ra,0x0
    80000fdc:	9f0080e7          	jalr	-1552(ra) # 800009c8 <uvmfree>
}
    80000fe0:	60e2                	ld	ra,24(sp)
    80000fe2:	6442                	ld	s0,16(sp)
    80000fe4:	64a2                	ld	s1,8(sp)
    80000fe6:	6902                	ld	s2,0(sp)
    80000fe8:	6105                	addi	sp,sp,32
    80000fea:	8082                	ret

0000000080000fec <freeproc>:
{
    80000fec:	1101                	addi	sp,sp,-32
    80000fee:	ec06                	sd	ra,24(sp)
    80000ff0:	e822                	sd	s0,16(sp)
    80000ff2:	e426                	sd	s1,8(sp)
    80000ff4:	1000                	addi	s0,sp,32
    80000ff6:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000ff8:	6d28                	ld	a0,88(a0)
    80000ffa:	c509                	beqz	a0,80001004 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80000ffc:	fffff097          	auipc	ra,0xfffff
    80001000:	020080e7          	jalr	32(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001004:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001008:	68a8                	ld	a0,80(s1)
    8000100a:	c511                	beqz	a0,80001016 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000100c:	64ac                	ld	a1,72(s1)
    8000100e:	00000097          	auipc	ra,0x0
    80001012:	f8c080e7          	jalr	-116(ra) # 80000f9a <proc_freepagetable>
  p->pagetable = 0;
    80001016:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000101a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000101e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001022:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001026:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000102a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000102e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001032:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001036:	0004ac23          	sw	zero,24(s1)
}
    8000103a:	60e2                	ld	ra,24(sp)
    8000103c:	6442                	ld	s0,16(sp)
    8000103e:	64a2                	ld	s1,8(sp)
    80001040:	6105                	addi	sp,sp,32
    80001042:	8082                	ret

0000000080001044 <allocproc>:
{
    80001044:	1101                	addi	sp,sp,-32
    80001046:	ec06                	sd	ra,24(sp)
    80001048:	e822                	sd	s0,16(sp)
    8000104a:	e426                	sd	s1,8(sp)
    8000104c:	e04a                	sd	s2,0(sp)
    8000104e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001050:	00008497          	auipc	s1,0x8
    80001054:	ce048493          	addi	s1,s1,-800 # 80008d30 <proc>
    80001058:	0000d917          	auipc	s2,0xd
    8000105c:	6d890913          	addi	s2,s2,1752 # 8000e730 <tickslock>
    acquire(&p->lock);
    80001060:	8526                	mv	a0,s1
    80001062:	00005097          	auipc	ra,0x5
    80001066:	0e2080e7          	jalr	226(ra) # 80006144 <acquire>
    if(p->state == UNUSED) {
    8000106a:	4c9c                	lw	a5,24(s1)
    8000106c:	cf81                	beqz	a5,80001084 <allocproc+0x40>
      release(&p->lock);
    8000106e:	8526                	mv	a0,s1
    80001070:	00005097          	auipc	ra,0x5
    80001074:	188080e7          	jalr	392(ra) # 800061f8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001078:	16848493          	addi	s1,s1,360
    8000107c:	ff2492e3          	bne	s1,s2,80001060 <allocproc+0x1c>
  return 0;
    80001080:	4481                	li	s1,0
    80001082:	a889                	j	800010d4 <allocproc+0x90>
  p->pid = allocpid();
    80001084:	00000097          	auipc	ra,0x0
    80001088:	e34080e7          	jalr	-460(ra) # 80000eb8 <allocpid>
    8000108c:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000108e:	4785                	li	a5,1
    80001090:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001092:	fffff097          	auipc	ra,0xfffff
    80001096:	088080e7          	jalr	136(ra) # 8000011a <kalloc>
    8000109a:	892a                	mv	s2,a0
    8000109c:	eca8                	sd	a0,88(s1)
    8000109e:	c131                	beqz	a0,800010e2 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010a0:	8526                	mv	a0,s1
    800010a2:	00000097          	auipc	ra,0x0
    800010a6:	e5c080e7          	jalr	-420(ra) # 80000efe <proc_pagetable>
    800010aa:	892a                	mv	s2,a0
    800010ac:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010ae:	c531                	beqz	a0,800010fa <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010b0:	07000613          	li	a2,112
    800010b4:	4581                	li	a1,0
    800010b6:	06048513          	addi	a0,s1,96
    800010ba:	fffff097          	auipc	ra,0xfffff
    800010be:	0c0080e7          	jalr	192(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800010c2:	00000797          	auipc	a5,0x0
    800010c6:	db078793          	addi	a5,a5,-592 # 80000e72 <forkret>
    800010ca:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010cc:	60bc                	ld	a5,64(s1)
    800010ce:	6705                	lui	a4,0x1
    800010d0:	97ba                	add	a5,a5,a4
    800010d2:	f4bc                	sd	a5,104(s1)
}
    800010d4:	8526                	mv	a0,s1
    800010d6:	60e2                	ld	ra,24(sp)
    800010d8:	6442                	ld	s0,16(sp)
    800010da:	64a2                	ld	s1,8(sp)
    800010dc:	6902                	ld	s2,0(sp)
    800010de:	6105                	addi	sp,sp,32
    800010e0:	8082                	ret
    freeproc(p);
    800010e2:	8526                	mv	a0,s1
    800010e4:	00000097          	auipc	ra,0x0
    800010e8:	f08080e7          	jalr	-248(ra) # 80000fec <freeproc>
    release(&p->lock);
    800010ec:	8526                	mv	a0,s1
    800010ee:	00005097          	auipc	ra,0x5
    800010f2:	10a080e7          	jalr	266(ra) # 800061f8 <release>
    return 0;
    800010f6:	84ca                	mv	s1,s2
    800010f8:	bff1                	j	800010d4 <allocproc+0x90>
    freeproc(p);
    800010fa:	8526                	mv	a0,s1
    800010fc:	00000097          	auipc	ra,0x0
    80001100:	ef0080e7          	jalr	-272(ra) # 80000fec <freeproc>
    release(&p->lock);
    80001104:	8526                	mv	a0,s1
    80001106:	00005097          	auipc	ra,0x5
    8000110a:	0f2080e7          	jalr	242(ra) # 800061f8 <release>
    return 0;
    8000110e:	84ca                	mv	s1,s2
    80001110:	b7d1                	j	800010d4 <allocproc+0x90>

0000000080001112 <userinit>:
{
    80001112:	1101                	addi	sp,sp,-32
    80001114:	ec06                	sd	ra,24(sp)
    80001116:	e822                	sd	s0,16(sp)
    80001118:	e426                	sd	s1,8(sp)
    8000111a:	1000                	addi	s0,sp,32
  p = allocproc();
    8000111c:	00000097          	auipc	ra,0x0
    80001120:	f28080e7          	jalr	-216(ra) # 80001044 <allocproc>
    80001124:	84aa                	mv	s1,a0
  initproc = p;
    80001126:	00007797          	auipc	a5,0x7
    8000112a:	78a7bd23          	sd	a0,1946(a5) # 800088c0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000112e:	03400613          	li	a2,52
    80001132:	00007597          	auipc	a1,0x7
    80001136:	71e58593          	addi	a1,a1,1822 # 80008850 <initcode>
    8000113a:	6928                	ld	a0,80(a0)
    8000113c:	fffff097          	auipc	ra,0xfffff
    80001140:	6b4080e7          	jalr	1716(ra) # 800007f0 <uvmfirst>
  p->sz = PGSIZE;
    80001144:	6785                	lui	a5,0x1
    80001146:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001148:	6cb8                	ld	a4,88(s1)
    8000114a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000114e:	6cb8                	ld	a4,88(s1)
    80001150:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001152:	4641                	li	a2,16
    80001154:	00007597          	auipc	a1,0x7
    80001158:	ff458593          	addi	a1,a1,-12 # 80008148 <etext+0x148>
    8000115c:	15848513          	addi	a0,s1,344
    80001160:	fffff097          	auipc	ra,0xfffff
    80001164:	164080e7          	jalr	356(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    80001168:	00007517          	auipc	a0,0x7
    8000116c:	ff050513          	addi	a0,a0,-16 # 80008158 <etext+0x158>
    80001170:	00002097          	auipc	ra,0x2
    80001174:	12a080e7          	jalr	298(ra) # 8000329a <namei>
    80001178:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000117c:	478d                	li	a5,3
    8000117e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001180:	8526                	mv	a0,s1
    80001182:	00005097          	auipc	ra,0x5
    80001186:	076080e7          	jalr	118(ra) # 800061f8 <release>
}
    8000118a:	60e2                	ld	ra,24(sp)
    8000118c:	6442                	ld	s0,16(sp)
    8000118e:	64a2                	ld	s1,8(sp)
    80001190:	6105                	addi	sp,sp,32
    80001192:	8082                	ret

0000000080001194 <growproc>:
{
    80001194:	1101                	addi	sp,sp,-32
    80001196:	ec06                	sd	ra,24(sp)
    80001198:	e822                	sd	s0,16(sp)
    8000119a:	e426                	sd	s1,8(sp)
    8000119c:	e04a                	sd	s2,0(sp)
    8000119e:	1000                	addi	s0,sp,32
    800011a0:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800011a2:	00000097          	auipc	ra,0x0
    800011a6:	c98080e7          	jalr	-872(ra) # 80000e3a <myproc>
    800011aa:	84aa                	mv	s1,a0
  sz = p->sz;
    800011ac:	652c                	ld	a1,72(a0)
  if(n > 0){
    800011ae:	01204c63          	bgtz	s2,800011c6 <growproc+0x32>
  } else if(n < 0){
    800011b2:	02094663          	bltz	s2,800011de <growproc+0x4a>
  p->sz = sz;
    800011b6:	e4ac                	sd	a1,72(s1)
  return 0;
    800011b8:	4501                	li	a0,0
}
    800011ba:	60e2                	ld	ra,24(sp)
    800011bc:	6442                	ld	s0,16(sp)
    800011be:	64a2                	ld	s1,8(sp)
    800011c0:	6902                	ld	s2,0(sp)
    800011c2:	6105                	addi	sp,sp,32
    800011c4:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800011c6:	4691                	li	a3,4
    800011c8:	00b90633          	add	a2,s2,a1
    800011cc:	6928                	ld	a0,80(a0)
    800011ce:	fffff097          	auipc	ra,0xfffff
    800011d2:	6dc080e7          	jalr	1756(ra) # 800008aa <uvmalloc>
    800011d6:	85aa                	mv	a1,a0
    800011d8:	fd79                	bnez	a0,800011b6 <growproc+0x22>
      return -1;
    800011da:	557d                	li	a0,-1
    800011dc:	bff9                	j	800011ba <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011de:	00b90633          	add	a2,s2,a1
    800011e2:	6928                	ld	a0,80(a0)
    800011e4:	fffff097          	auipc	ra,0xfffff
    800011e8:	67e080e7          	jalr	1662(ra) # 80000862 <uvmdealloc>
    800011ec:	85aa                	mv	a1,a0
    800011ee:	b7e1                	j	800011b6 <growproc+0x22>

00000000800011f0 <fork>:
{
    800011f0:	7139                	addi	sp,sp,-64
    800011f2:	fc06                	sd	ra,56(sp)
    800011f4:	f822                	sd	s0,48(sp)
    800011f6:	f426                	sd	s1,40(sp)
    800011f8:	f04a                	sd	s2,32(sp)
    800011fa:	ec4e                	sd	s3,24(sp)
    800011fc:	e852                	sd	s4,16(sp)
    800011fe:	e456                	sd	s5,8(sp)
    80001200:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001202:	00000097          	auipc	ra,0x0
    80001206:	c38080e7          	jalr	-968(ra) # 80000e3a <myproc>
    8000120a:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000120c:	00000097          	auipc	ra,0x0
    80001210:	e38080e7          	jalr	-456(ra) # 80001044 <allocproc>
    80001214:	10050c63          	beqz	a0,8000132c <fork+0x13c>
    80001218:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000121a:	048ab603          	ld	a2,72(s5)
    8000121e:	692c                	ld	a1,80(a0)
    80001220:	050ab503          	ld	a0,80(s5)
    80001224:	fffff097          	auipc	ra,0xfffff
    80001228:	7de080e7          	jalr	2014(ra) # 80000a02 <uvmcopy>
    8000122c:	04054863          	bltz	a0,8000127c <fork+0x8c>
  np->sz = p->sz;
    80001230:	048ab783          	ld	a5,72(s5)
    80001234:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001238:	058ab683          	ld	a3,88(s5)
    8000123c:	87b6                	mv	a5,a3
    8000123e:	058a3703          	ld	a4,88(s4)
    80001242:	12068693          	addi	a3,a3,288
    80001246:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000124a:	6788                	ld	a0,8(a5)
    8000124c:	6b8c                	ld	a1,16(a5)
    8000124e:	6f90                	ld	a2,24(a5)
    80001250:	01073023          	sd	a6,0(a4)
    80001254:	e708                	sd	a0,8(a4)
    80001256:	eb0c                	sd	a1,16(a4)
    80001258:	ef10                	sd	a2,24(a4)
    8000125a:	02078793          	addi	a5,a5,32
    8000125e:	02070713          	addi	a4,a4,32
    80001262:	fed792e3          	bne	a5,a3,80001246 <fork+0x56>
  np->trapframe->a0 = 0;
    80001266:	058a3783          	ld	a5,88(s4)
    8000126a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000126e:	0d0a8493          	addi	s1,s5,208
    80001272:	0d0a0913          	addi	s2,s4,208
    80001276:	150a8993          	addi	s3,s5,336
    8000127a:	a00d                	j	8000129c <fork+0xac>
    freeproc(np);
    8000127c:	8552                	mv	a0,s4
    8000127e:	00000097          	auipc	ra,0x0
    80001282:	d6e080e7          	jalr	-658(ra) # 80000fec <freeproc>
    release(&np->lock);
    80001286:	8552                	mv	a0,s4
    80001288:	00005097          	auipc	ra,0x5
    8000128c:	f70080e7          	jalr	-144(ra) # 800061f8 <release>
    return -1;
    80001290:	597d                	li	s2,-1
    80001292:	a059                	j	80001318 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001294:	04a1                	addi	s1,s1,8
    80001296:	0921                	addi	s2,s2,8
    80001298:	01348b63          	beq	s1,s3,800012ae <fork+0xbe>
    if(p->ofile[i])
    8000129c:	6088                	ld	a0,0(s1)
    8000129e:	d97d                	beqz	a0,80001294 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800012a0:	00002097          	auipc	ra,0x2
    800012a4:	690080e7          	jalr	1680(ra) # 80003930 <filedup>
    800012a8:	00a93023          	sd	a0,0(s2)
    800012ac:	b7e5                	j	80001294 <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012ae:	150ab503          	ld	a0,336(s5)
    800012b2:	00001097          	auipc	ra,0x1
    800012b6:	7fe080e7          	jalr	2046(ra) # 80002ab0 <idup>
    800012ba:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012be:	4641                	li	a2,16
    800012c0:	158a8593          	addi	a1,s5,344
    800012c4:	158a0513          	addi	a0,s4,344
    800012c8:	fffff097          	auipc	ra,0xfffff
    800012cc:	ffc080e7          	jalr	-4(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    800012d0:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800012d4:	8552                	mv	a0,s4
    800012d6:	00005097          	auipc	ra,0x5
    800012da:	f22080e7          	jalr	-222(ra) # 800061f8 <release>
  acquire(&wait_lock);
    800012de:	00007497          	auipc	s1,0x7
    800012e2:	63a48493          	addi	s1,s1,1594 # 80008918 <wait_lock>
    800012e6:	8526                	mv	a0,s1
    800012e8:	00005097          	auipc	ra,0x5
    800012ec:	e5c080e7          	jalr	-420(ra) # 80006144 <acquire>
  np->parent = p;
    800012f0:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800012f4:	8526                	mv	a0,s1
    800012f6:	00005097          	auipc	ra,0x5
    800012fa:	f02080e7          	jalr	-254(ra) # 800061f8 <release>
  acquire(&np->lock);
    800012fe:	8552                	mv	a0,s4
    80001300:	00005097          	auipc	ra,0x5
    80001304:	e44080e7          	jalr	-444(ra) # 80006144 <acquire>
  np->state = RUNNABLE;
    80001308:	478d                	li	a5,3
    8000130a:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000130e:	8552                	mv	a0,s4
    80001310:	00005097          	auipc	ra,0x5
    80001314:	ee8080e7          	jalr	-280(ra) # 800061f8 <release>
}
    80001318:	854a                	mv	a0,s2
    8000131a:	70e2                	ld	ra,56(sp)
    8000131c:	7442                	ld	s0,48(sp)
    8000131e:	74a2                	ld	s1,40(sp)
    80001320:	7902                	ld	s2,32(sp)
    80001322:	69e2                	ld	s3,24(sp)
    80001324:	6a42                	ld	s4,16(sp)
    80001326:	6aa2                	ld	s5,8(sp)
    80001328:	6121                	addi	sp,sp,64
    8000132a:	8082                	ret
    return -1;
    8000132c:	597d                	li	s2,-1
    8000132e:	b7ed                	j	80001318 <fork+0x128>

0000000080001330 <scheduler>:
{
    80001330:	7139                	addi	sp,sp,-64
    80001332:	fc06                	sd	ra,56(sp)
    80001334:	f822                	sd	s0,48(sp)
    80001336:	f426                	sd	s1,40(sp)
    80001338:	f04a                	sd	s2,32(sp)
    8000133a:	ec4e                	sd	s3,24(sp)
    8000133c:	e852                	sd	s4,16(sp)
    8000133e:	e456                	sd	s5,8(sp)
    80001340:	e05a                	sd	s6,0(sp)
    80001342:	0080                	addi	s0,sp,64
    80001344:	8792                	mv	a5,tp
  int id = r_tp();
    80001346:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001348:	00779a93          	slli	s5,a5,0x7
    8000134c:	00007717          	auipc	a4,0x7
    80001350:	5b470713          	addi	a4,a4,1460 # 80008900 <pid_lock>
    80001354:	9756                	add	a4,a4,s5
    80001356:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000135a:	00007717          	auipc	a4,0x7
    8000135e:	5de70713          	addi	a4,a4,1502 # 80008938 <cpus+0x8>
    80001362:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001364:	498d                	li	s3,3
        p->state = RUNNING;
    80001366:	4b11                	li	s6,4
        c->proc = p;
    80001368:	079e                	slli	a5,a5,0x7
    8000136a:	00007a17          	auipc	s4,0x7
    8000136e:	596a0a13          	addi	s4,s4,1430 # 80008900 <pid_lock>
    80001372:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001374:	0000d917          	auipc	s2,0xd
    80001378:	3bc90913          	addi	s2,s2,956 # 8000e730 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000137c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001380:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001384:	10079073          	csrw	sstatus,a5
    80001388:	00008497          	auipc	s1,0x8
    8000138c:	9a848493          	addi	s1,s1,-1624 # 80008d30 <proc>
    80001390:	a811                	j	800013a4 <scheduler+0x74>
      release(&p->lock);
    80001392:	8526                	mv	a0,s1
    80001394:	00005097          	auipc	ra,0x5
    80001398:	e64080e7          	jalr	-412(ra) # 800061f8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000139c:	16848493          	addi	s1,s1,360
    800013a0:	fd248ee3          	beq	s1,s2,8000137c <scheduler+0x4c>
      acquire(&p->lock);
    800013a4:	8526                	mv	a0,s1
    800013a6:	00005097          	auipc	ra,0x5
    800013aa:	d9e080e7          	jalr	-610(ra) # 80006144 <acquire>
      if(p->state == RUNNABLE) {
    800013ae:	4c9c                	lw	a5,24(s1)
    800013b0:	ff3791e3          	bne	a5,s3,80001392 <scheduler+0x62>
        p->state = RUNNING;
    800013b4:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013b8:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013bc:	06048593          	addi	a1,s1,96
    800013c0:	8556                	mv	a0,s5
    800013c2:	00000097          	auipc	ra,0x0
    800013c6:	684080e7          	jalr	1668(ra) # 80001a46 <swtch>
        c->proc = 0;
    800013ca:	020a3823          	sd	zero,48(s4)
    800013ce:	b7d1                	j	80001392 <scheduler+0x62>

00000000800013d0 <sched>:
{
    800013d0:	7179                	addi	sp,sp,-48
    800013d2:	f406                	sd	ra,40(sp)
    800013d4:	f022                	sd	s0,32(sp)
    800013d6:	ec26                	sd	s1,24(sp)
    800013d8:	e84a                	sd	s2,16(sp)
    800013da:	e44e                	sd	s3,8(sp)
    800013dc:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013de:	00000097          	auipc	ra,0x0
    800013e2:	a5c080e7          	jalr	-1444(ra) # 80000e3a <myproc>
    800013e6:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800013e8:	00005097          	auipc	ra,0x5
    800013ec:	ce2080e7          	jalr	-798(ra) # 800060ca <holding>
    800013f0:	c93d                	beqz	a0,80001466 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800013f2:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800013f4:	2781                	sext.w	a5,a5
    800013f6:	079e                	slli	a5,a5,0x7
    800013f8:	00007717          	auipc	a4,0x7
    800013fc:	50870713          	addi	a4,a4,1288 # 80008900 <pid_lock>
    80001400:	97ba                	add	a5,a5,a4
    80001402:	0a87a703          	lw	a4,168(a5)
    80001406:	4785                	li	a5,1
    80001408:	06f71763          	bne	a4,a5,80001476 <sched+0xa6>
  if(p->state == RUNNING)
    8000140c:	4c98                	lw	a4,24(s1)
    8000140e:	4791                	li	a5,4
    80001410:	06f70b63          	beq	a4,a5,80001486 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001414:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001418:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000141a:	efb5                	bnez	a5,80001496 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000141c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000141e:	00007917          	auipc	s2,0x7
    80001422:	4e290913          	addi	s2,s2,1250 # 80008900 <pid_lock>
    80001426:	2781                	sext.w	a5,a5
    80001428:	079e                	slli	a5,a5,0x7
    8000142a:	97ca                	add	a5,a5,s2
    8000142c:	0ac7a983          	lw	s3,172(a5)
    80001430:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001432:	2781                	sext.w	a5,a5
    80001434:	079e                	slli	a5,a5,0x7
    80001436:	00007597          	auipc	a1,0x7
    8000143a:	50258593          	addi	a1,a1,1282 # 80008938 <cpus+0x8>
    8000143e:	95be                	add	a1,a1,a5
    80001440:	06048513          	addi	a0,s1,96
    80001444:	00000097          	auipc	ra,0x0
    80001448:	602080e7          	jalr	1538(ra) # 80001a46 <swtch>
    8000144c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000144e:	2781                	sext.w	a5,a5
    80001450:	079e                	slli	a5,a5,0x7
    80001452:	993e                	add	s2,s2,a5
    80001454:	0b392623          	sw	s3,172(s2)
}
    80001458:	70a2                	ld	ra,40(sp)
    8000145a:	7402                	ld	s0,32(sp)
    8000145c:	64e2                	ld	s1,24(sp)
    8000145e:	6942                	ld	s2,16(sp)
    80001460:	69a2                	ld	s3,8(sp)
    80001462:	6145                	addi	sp,sp,48
    80001464:	8082                	ret
    panic("sched p->lock");
    80001466:	00007517          	auipc	a0,0x7
    8000146a:	cfa50513          	addi	a0,a0,-774 # 80008160 <etext+0x160>
    8000146e:	00004097          	auipc	ra,0x4
    80001472:	79e080e7          	jalr	1950(ra) # 80005c0c <panic>
    panic("sched locks");
    80001476:	00007517          	auipc	a0,0x7
    8000147a:	cfa50513          	addi	a0,a0,-774 # 80008170 <etext+0x170>
    8000147e:	00004097          	auipc	ra,0x4
    80001482:	78e080e7          	jalr	1934(ra) # 80005c0c <panic>
    panic("sched running");
    80001486:	00007517          	auipc	a0,0x7
    8000148a:	cfa50513          	addi	a0,a0,-774 # 80008180 <etext+0x180>
    8000148e:	00004097          	auipc	ra,0x4
    80001492:	77e080e7          	jalr	1918(ra) # 80005c0c <panic>
    panic("sched interruptible");
    80001496:	00007517          	auipc	a0,0x7
    8000149a:	cfa50513          	addi	a0,a0,-774 # 80008190 <etext+0x190>
    8000149e:	00004097          	auipc	ra,0x4
    800014a2:	76e080e7          	jalr	1902(ra) # 80005c0c <panic>

00000000800014a6 <yield>:
{
    800014a6:	1101                	addi	sp,sp,-32
    800014a8:	ec06                	sd	ra,24(sp)
    800014aa:	e822                	sd	s0,16(sp)
    800014ac:	e426                	sd	s1,8(sp)
    800014ae:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014b0:	00000097          	auipc	ra,0x0
    800014b4:	98a080e7          	jalr	-1654(ra) # 80000e3a <myproc>
    800014b8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014ba:	00005097          	auipc	ra,0x5
    800014be:	c8a080e7          	jalr	-886(ra) # 80006144 <acquire>
  p->state = RUNNABLE;
    800014c2:	478d                	li	a5,3
    800014c4:	cc9c                	sw	a5,24(s1)
  sched();
    800014c6:	00000097          	auipc	ra,0x0
    800014ca:	f0a080e7          	jalr	-246(ra) # 800013d0 <sched>
  release(&p->lock);
    800014ce:	8526                	mv	a0,s1
    800014d0:	00005097          	auipc	ra,0x5
    800014d4:	d28080e7          	jalr	-728(ra) # 800061f8 <release>
}
    800014d8:	60e2                	ld	ra,24(sp)
    800014da:	6442                	ld	s0,16(sp)
    800014dc:	64a2                	ld	s1,8(sp)
    800014de:	6105                	addi	sp,sp,32
    800014e0:	8082                	ret

00000000800014e2 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800014e2:	7179                	addi	sp,sp,-48
    800014e4:	f406                	sd	ra,40(sp)
    800014e6:	f022                	sd	s0,32(sp)
    800014e8:	ec26                	sd	s1,24(sp)
    800014ea:	e84a                	sd	s2,16(sp)
    800014ec:	e44e                	sd	s3,8(sp)
    800014ee:	1800                	addi	s0,sp,48
    800014f0:	89aa                	mv	s3,a0
    800014f2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800014f4:	00000097          	auipc	ra,0x0
    800014f8:	946080e7          	jalr	-1722(ra) # 80000e3a <myproc>
    800014fc:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800014fe:	00005097          	auipc	ra,0x5
    80001502:	c46080e7          	jalr	-954(ra) # 80006144 <acquire>
  release(lk);
    80001506:	854a                	mv	a0,s2
    80001508:	00005097          	auipc	ra,0x5
    8000150c:	cf0080e7          	jalr	-784(ra) # 800061f8 <release>

  // Go to sleep.
  p->chan = chan;
    80001510:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001514:	4789                	li	a5,2
    80001516:	cc9c                	sw	a5,24(s1)

  sched();
    80001518:	00000097          	auipc	ra,0x0
    8000151c:	eb8080e7          	jalr	-328(ra) # 800013d0 <sched>

  // Tidy up.
  p->chan = 0;
    80001520:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001524:	8526                	mv	a0,s1
    80001526:	00005097          	auipc	ra,0x5
    8000152a:	cd2080e7          	jalr	-814(ra) # 800061f8 <release>
  acquire(lk);
    8000152e:	854a                	mv	a0,s2
    80001530:	00005097          	auipc	ra,0x5
    80001534:	c14080e7          	jalr	-1004(ra) # 80006144 <acquire>
}
    80001538:	70a2                	ld	ra,40(sp)
    8000153a:	7402                	ld	s0,32(sp)
    8000153c:	64e2                	ld	s1,24(sp)
    8000153e:	6942                	ld	s2,16(sp)
    80001540:	69a2                	ld	s3,8(sp)
    80001542:	6145                	addi	sp,sp,48
    80001544:	8082                	ret

0000000080001546 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001546:	7139                	addi	sp,sp,-64
    80001548:	fc06                	sd	ra,56(sp)
    8000154a:	f822                	sd	s0,48(sp)
    8000154c:	f426                	sd	s1,40(sp)
    8000154e:	f04a                	sd	s2,32(sp)
    80001550:	ec4e                	sd	s3,24(sp)
    80001552:	e852                	sd	s4,16(sp)
    80001554:	e456                	sd	s5,8(sp)
    80001556:	0080                	addi	s0,sp,64
    80001558:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000155a:	00007497          	auipc	s1,0x7
    8000155e:	7d648493          	addi	s1,s1,2006 # 80008d30 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001562:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001564:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001566:	0000d917          	auipc	s2,0xd
    8000156a:	1ca90913          	addi	s2,s2,458 # 8000e730 <tickslock>
    8000156e:	a811                	j	80001582 <wakeup+0x3c>
      }
      release(&p->lock);
    80001570:	8526                	mv	a0,s1
    80001572:	00005097          	auipc	ra,0x5
    80001576:	c86080e7          	jalr	-890(ra) # 800061f8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000157a:	16848493          	addi	s1,s1,360
    8000157e:	03248663          	beq	s1,s2,800015aa <wakeup+0x64>
    if(p != myproc()){
    80001582:	00000097          	auipc	ra,0x0
    80001586:	8b8080e7          	jalr	-1864(ra) # 80000e3a <myproc>
    8000158a:	fea488e3          	beq	s1,a0,8000157a <wakeup+0x34>
      acquire(&p->lock);
    8000158e:	8526                	mv	a0,s1
    80001590:	00005097          	auipc	ra,0x5
    80001594:	bb4080e7          	jalr	-1100(ra) # 80006144 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001598:	4c9c                	lw	a5,24(s1)
    8000159a:	fd379be3          	bne	a5,s3,80001570 <wakeup+0x2a>
    8000159e:	709c                	ld	a5,32(s1)
    800015a0:	fd4798e3          	bne	a5,s4,80001570 <wakeup+0x2a>
        p->state = RUNNABLE;
    800015a4:	0154ac23          	sw	s5,24(s1)
    800015a8:	b7e1                	j	80001570 <wakeup+0x2a>
    }
  }
}
    800015aa:	70e2                	ld	ra,56(sp)
    800015ac:	7442                	ld	s0,48(sp)
    800015ae:	74a2                	ld	s1,40(sp)
    800015b0:	7902                	ld	s2,32(sp)
    800015b2:	69e2                	ld	s3,24(sp)
    800015b4:	6a42                	ld	s4,16(sp)
    800015b6:	6aa2                	ld	s5,8(sp)
    800015b8:	6121                	addi	sp,sp,64
    800015ba:	8082                	ret

00000000800015bc <reparent>:
{
    800015bc:	7179                	addi	sp,sp,-48
    800015be:	f406                	sd	ra,40(sp)
    800015c0:	f022                	sd	s0,32(sp)
    800015c2:	ec26                	sd	s1,24(sp)
    800015c4:	e84a                	sd	s2,16(sp)
    800015c6:	e44e                	sd	s3,8(sp)
    800015c8:	e052                	sd	s4,0(sp)
    800015ca:	1800                	addi	s0,sp,48
    800015cc:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015ce:	00007497          	auipc	s1,0x7
    800015d2:	76248493          	addi	s1,s1,1890 # 80008d30 <proc>
      pp->parent = initproc;
    800015d6:	00007a17          	auipc	s4,0x7
    800015da:	2eaa0a13          	addi	s4,s4,746 # 800088c0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015de:	0000d997          	auipc	s3,0xd
    800015e2:	15298993          	addi	s3,s3,338 # 8000e730 <tickslock>
    800015e6:	a029                	j	800015f0 <reparent+0x34>
    800015e8:	16848493          	addi	s1,s1,360
    800015ec:	01348d63          	beq	s1,s3,80001606 <reparent+0x4a>
    if(pp->parent == p){
    800015f0:	7c9c                	ld	a5,56(s1)
    800015f2:	ff279be3          	bne	a5,s2,800015e8 <reparent+0x2c>
      pp->parent = initproc;
    800015f6:	000a3503          	ld	a0,0(s4)
    800015fa:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800015fc:	00000097          	auipc	ra,0x0
    80001600:	f4a080e7          	jalr	-182(ra) # 80001546 <wakeup>
    80001604:	b7d5                	j	800015e8 <reparent+0x2c>
}
    80001606:	70a2                	ld	ra,40(sp)
    80001608:	7402                	ld	s0,32(sp)
    8000160a:	64e2                	ld	s1,24(sp)
    8000160c:	6942                	ld	s2,16(sp)
    8000160e:	69a2                	ld	s3,8(sp)
    80001610:	6a02                	ld	s4,0(sp)
    80001612:	6145                	addi	sp,sp,48
    80001614:	8082                	ret

0000000080001616 <exit>:
{
    80001616:	7179                	addi	sp,sp,-48
    80001618:	f406                	sd	ra,40(sp)
    8000161a:	f022                	sd	s0,32(sp)
    8000161c:	ec26                	sd	s1,24(sp)
    8000161e:	e84a                	sd	s2,16(sp)
    80001620:	e44e                	sd	s3,8(sp)
    80001622:	e052                	sd	s4,0(sp)
    80001624:	1800                	addi	s0,sp,48
    80001626:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001628:	00000097          	auipc	ra,0x0
    8000162c:	812080e7          	jalr	-2030(ra) # 80000e3a <myproc>
    80001630:	89aa                	mv	s3,a0
  if(p == initproc)
    80001632:	00007797          	auipc	a5,0x7
    80001636:	28e7b783          	ld	a5,654(a5) # 800088c0 <initproc>
    8000163a:	0d050493          	addi	s1,a0,208
    8000163e:	15050913          	addi	s2,a0,336
    80001642:	02a79363          	bne	a5,a0,80001668 <exit+0x52>
    panic("init exiting");
    80001646:	00007517          	auipc	a0,0x7
    8000164a:	b6250513          	addi	a0,a0,-1182 # 800081a8 <etext+0x1a8>
    8000164e:	00004097          	auipc	ra,0x4
    80001652:	5be080e7          	jalr	1470(ra) # 80005c0c <panic>
      fileclose(f);
    80001656:	00002097          	auipc	ra,0x2
    8000165a:	32c080e7          	jalr	812(ra) # 80003982 <fileclose>
      p->ofile[fd] = 0;
    8000165e:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001662:	04a1                	addi	s1,s1,8
    80001664:	01248563          	beq	s1,s2,8000166e <exit+0x58>
    if(p->ofile[fd]){
    80001668:	6088                	ld	a0,0(s1)
    8000166a:	f575                	bnez	a0,80001656 <exit+0x40>
    8000166c:	bfdd                	j	80001662 <exit+0x4c>
  begin_op();
    8000166e:	00002097          	auipc	ra,0x2
    80001672:	e4c080e7          	jalr	-436(ra) # 800034ba <begin_op>
  iput(p->cwd);
    80001676:	1509b503          	ld	a0,336(s3)
    8000167a:	00001097          	auipc	ra,0x1
    8000167e:	62e080e7          	jalr	1582(ra) # 80002ca8 <iput>
  end_op();
    80001682:	00002097          	auipc	ra,0x2
    80001686:	eb6080e7          	jalr	-330(ra) # 80003538 <end_op>
  p->cwd = 0;
    8000168a:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000168e:	00007497          	auipc	s1,0x7
    80001692:	28a48493          	addi	s1,s1,650 # 80008918 <wait_lock>
    80001696:	8526                	mv	a0,s1
    80001698:	00005097          	auipc	ra,0x5
    8000169c:	aac080e7          	jalr	-1364(ra) # 80006144 <acquire>
  reparent(p);
    800016a0:	854e                	mv	a0,s3
    800016a2:	00000097          	auipc	ra,0x0
    800016a6:	f1a080e7          	jalr	-230(ra) # 800015bc <reparent>
  wakeup(p->parent);
    800016aa:	0389b503          	ld	a0,56(s3)
    800016ae:	00000097          	auipc	ra,0x0
    800016b2:	e98080e7          	jalr	-360(ra) # 80001546 <wakeup>
  acquire(&p->lock);
    800016b6:	854e                	mv	a0,s3
    800016b8:	00005097          	auipc	ra,0x5
    800016bc:	a8c080e7          	jalr	-1396(ra) # 80006144 <acquire>
  p->xstate = status;
    800016c0:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800016c4:	4795                	li	a5,5
    800016c6:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800016ca:	8526                	mv	a0,s1
    800016cc:	00005097          	auipc	ra,0x5
    800016d0:	b2c080e7          	jalr	-1236(ra) # 800061f8 <release>
  sched();
    800016d4:	00000097          	auipc	ra,0x0
    800016d8:	cfc080e7          	jalr	-772(ra) # 800013d0 <sched>
  panic("zombie exit");
    800016dc:	00007517          	auipc	a0,0x7
    800016e0:	adc50513          	addi	a0,a0,-1316 # 800081b8 <etext+0x1b8>
    800016e4:	00004097          	auipc	ra,0x4
    800016e8:	528080e7          	jalr	1320(ra) # 80005c0c <panic>

00000000800016ec <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800016ec:	7179                	addi	sp,sp,-48
    800016ee:	f406                	sd	ra,40(sp)
    800016f0:	f022                	sd	s0,32(sp)
    800016f2:	ec26                	sd	s1,24(sp)
    800016f4:	e84a                	sd	s2,16(sp)
    800016f6:	e44e                	sd	s3,8(sp)
    800016f8:	1800                	addi	s0,sp,48
    800016fa:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800016fc:	00007497          	auipc	s1,0x7
    80001700:	63448493          	addi	s1,s1,1588 # 80008d30 <proc>
    80001704:	0000d997          	auipc	s3,0xd
    80001708:	02c98993          	addi	s3,s3,44 # 8000e730 <tickslock>
    acquire(&p->lock);
    8000170c:	8526                	mv	a0,s1
    8000170e:	00005097          	auipc	ra,0x5
    80001712:	a36080e7          	jalr	-1482(ra) # 80006144 <acquire>
    if(p->pid == pid){
    80001716:	589c                	lw	a5,48(s1)
    80001718:	01278d63          	beq	a5,s2,80001732 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000171c:	8526                	mv	a0,s1
    8000171e:	00005097          	auipc	ra,0x5
    80001722:	ada080e7          	jalr	-1318(ra) # 800061f8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001726:	16848493          	addi	s1,s1,360
    8000172a:	ff3491e3          	bne	s1,s3,8000170c <kill+0x20>
  }
  return -1;
    8000172e:	557d                	li	a0,-1
    80001730:	a829                	j	8000174a <kill+0x5e>
      p->killed = 1;
    80001732:	4785                	li	a5,1
    80001734:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001736:	4c98                	lw	a4,24(s1)
    80001738:	4789                	li	a5,2
    8000173a:	00f70f63          	beq	a4,a5,80001758 <kill+0x6c>
      release(&p->lock);
    8000173e:	8526                	mv	a0,s1
    80001740:	00005097          	auipc	ra,0x5
    80001744:	ab8080e7          	jalr	-1352(ra) # 800061f8 <release>
      return 0;
    80001748:	4501                	li	a0,0
}
    8000174a:	70a2                	ld	ra,40(sp)
    8000174c:	7402                	ld	s0,32(sp)
    8000174e:	64e2                	ld	s1,24(sp)
    80001750:	6942                	ld	s2,16(sp)
    80001752:	69a2                	ld	s3,8(sp)
    80001754:	6145                	addi	sp,sp,48
    80001756:	8082                	ret
        p->state = RUNNABLE;
    80001758:	478d                	li	a5,3
    8000175a:	cc9c                	sw	a5,24(s1)
    8000175c:	b7cd                	j	8000173e <kill+0x52>

000000008000175e <setkilled>:

void
setkilled(struct proc *p)
{
    8000175e:	1101                	addi	sp,sp,-32
    80001760:	ec06                	sd	ra,24(sp)
    80001762:	e822                	sd	s0,16(sp)
    80001764:	e426                	sd	s1,8(sp)
    80001766:	1000                	addi	s0,sp,32
    80001768:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000176a:	00005097          	auipc	ra,0x5
    8000176e:	9da080e7          	jalr	-1574(ra) # 80006144 <acquire>
  p->killed = 1;
    80001772:	4785                	li	a5,1
    80001774:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001776:	8526                	mv	a0,s1
    80001778:	00005097          	auipc	ra,0x5
    8000177c:	a80080e7          	jalr	-1408(ra) # 800061f8 <release>
}
    80001780:	60e2                	ld	ra,24(sp)
    80001782:	6442                	ld	s0,16(sp)
    80001784:	64a2                	ld	s1,8(sp)
    80001786:	6105                	addi	sp,sp,32
    80001788:	8082                	ret

000000008000178a <killed>:

int
killed(struct proc *p)
{
    8000178a:	1101                	addi	sp,sp,-32
    8000178c:	ec06                	sd	ra,24(sp)
    8000178e:	e822                	sd	s0,16(sp)
    80001790:	e426                	sd	s1,8(sp)
    80001792:	e04a                	sd	s2,0(sp)
    80001794:	1000                	addi	s0,sp,32
    80001796:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001798:	00005097          	auipc	ra,0x5
    8000179c:	9ac080e7          	jalr	-1620(ra) # 80006144 <acquire>
  k = p->killed;
    800017a0:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017a4:	8526                	mv	a0,s1
    800017a6:	00005097          	auipc	ra,0x5
    800017aa:	a52080e7          	jalr	-1454(ra) # 800061f8 <release>
  return k;
}
    800017ae:	854a                	mv	a0,s2
    800017b0:	60e2                	ld	ra,24(sp)
    800017b2:	6442                	ld	s0,16(sp)
    800017b4:	64a2                	ld	s1,8(sp)
    800017b6:	6902                	ld	s2,0(sp)
    800017b8:	6105                	addi	sp,sp,32
    800017ba:	8082                	ret

00000000800017bc <wait>:
{
    800017bc:	715d                	addi	sp,sp,-80
    800017be:	e486                	sd	ra,72(sp)
    800017c0:	e0a2                	sd	s0,64(sp)
    800017c2:	fc26                	sd	s1,56(sp)
    800017c4:	f84a                	sd	s2,48(sp)
    800017c6:	f44e                	sd	s3,40(sp)
    800017c8:	f052                	sd	s4,32(sp)
    800017ca:	ec56                	sd	s5,24(sp)
    800017cc:	e85a                	sd	s6,16(sp)
    800017ce:	e45e                	sd	s7,8(sp)
    800017d0:	e062                	sd	s8,0(sp)
    800017d2:	0880                	addi	s0,sp,80
    800017d4:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017d6:	fffff097          	auipc	ra,0xfffff
    800017da:	664080e7          	jalr	1636(ra) # 80000e3a <myproc>
    800017de:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017e0:	00007517          	auipc	a0,0x7
    800017e4:	13850513          	addi	a0,a0,312 # 80008918 <wait_lock>
    800017e8:	00005097          	auipc	ra,0x5
    800017ec:	95c080e7          	jalr	-1700(ra) # 80006144 <acquire>
    havekids = 0;
    800017f0:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800017f2:	4a15                	li	s4,5
        havekids = 1;
    800017f4:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800017f6:	0000d997          	auipc	s3,0xd
    800017fa:	f3a98993          	addi	s3,s3,-198 # 8000e730 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017fe:	00007c17          	auipc	s8,0x7
    80001802:	11ac0c13          	addi	s8,s8,282 # 80008918 <wait_lock>
    havekids = 0;
    80001806:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001808:	00007497          	auipc	s1,0x7
    8000180c:	52848493          	addi	s1,s1,1320 # 80008d30 <proc>
    80001810:	a0bd                	j	8000187e <wait+0xc2>
          pid = pp->pid;
    80001812:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001816:	000b0e63          	beqz	s6,80001832 <wait+0x76>
    8000181a:	4691                	li	a3,4
    8000181c:	02c48613          	addi	a2,s1,44
    80001820:	85da                	mv	a1,s6
    80001822:	05093503          	ld	a0,80(s2)
    80001826:	fffff097          	auipc	ra,0xfffff
    8000182a:	2d4080e7          	jalr	724(ra) # 80000afa <copyout>
    8000182e:	02054563          	bltz	a0,80001858 <wait+0x9c>
          freeproc(pp);
    80001832:	8526                	mv	a0,s1
    80001834:	fffff097          	auipc	ra,0xfffff
    80001838:	7b8080e7          	jalr	1976(ra) # 80000fec <freeproc>
          release(&pp->lock);
    8000183c:	8526                	mv	a0,s1
    8000183e:	00005097          	auipc	ra,0x5
    80001842:	9ba080e7          	jalr	-1606(ra) # 800061f8 <release>
          release(&wait_lock);
    80001846:	00007517          	auipc	a0,0x7
    8000184a:	0d250513          	addi	a0,a0,210 # 80008918 <wait_lock>
    8000184e:	00005097          	auipc	ra,0x5
    80001852:	9aa080e7          	jalr	-1622(ra) # 800061f8 <release>
          return pid;
    80001856:	a0b5                	j	800018c2 <wait+0x106>
            release(&pp->lock);
    80001858:	8526                	mv	a0,s1
    8000185a:	00005097          	auipc	ra,0x5
    8000185e:	99e080e7          	jalr	-1634(ra) # 800061f8 <release>
            release(&wait_lock);
    80001862:	00007517          	auipc	a0,0x7
    80001866:	0b650513          	addi	a0,a0,182 # 80008918 <wait_lock>
    8000186a:	00005097          	auipc	ra,0x5
    8000186e:	98e080e7          	jalr	-1650(ra) # 800061f8 <release>
            return -1;
    80001872:	59fd                	li	s3,-1
    80001874:	a0b9                	j	800018c2 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001876:	16848493          	addi	s1,s1,360
    8000187a:	03348463          	beq	s1,s3,800018a2 <wait+0xe6>
      if(pp->parent == p){
    8000187e:	7c9c                	ld	a5,56(s1)
    80001880:	ff279be3          	bne	a5,s2,80001876 <wait+0xba>
        acquire(&pp->lock);
    80001884:	8526                	mv	a0,s1
    80001886:	00005097          	auipc	ra,0x5
    8000188a:	8be080e7          	jalr	-1858(ra) # 80006144 <acquire>
        if(pp->state == ZOMBIE){
    8000188e:	4c9c                	lw	a5,24(s1)
    80001890:	f94781e3          	beq	a5,s4,80001812 <wait+0x56>
        release(&pp->lock);
    80001894:	8526                	mv	a0,s1
    80001896:	00005097          	auipc	ra,0x5
    8000189a:	962080e7          	jalr	-1694(ra) # 800061f8 <release>
        havekids = 1;
    8000189e:	8756                	mv	a4,s5
    800018a0:	bfd9                	j	80001876 <wait+0xba>
    if(!havekids || killed(p)){
    800018a2:	c719                	beqz	a4,800018b0 <wait+0xf4>
    800018a4:	854a                	mv	a0,s2
    800018a6:	00000097          	auipc	ra,0x0
    800018aa:	ee4080e7          	jalr	-284(ra) # 8000178a <killed>
    800018ae:	c51d                	beqz	a0,800018dc <wait+0x120>
      release(&wait_lock);
    800018b0:	00007517          	auipc	a0,0x7
    800018b4:	06850513          	addi	a0,a0,104 # 80008918 <wait_lock>
    800018b8:	00005097          	auipc	ra,0x5
    800018bc:	940080e7          	jalr	-1728(ra) # 800061f8 <release>
      return -1;
    800018c0:	59fd                	li	s3,-1
}
    800018c2:	854e                	mv	a0,s3
    800018c4:	60a6                	ld	ra,72(sp)
    800018c6:	6406                	ld	s0,64(sp)
    800018c8:	74e2                	ld	s1,56(sp)
    800018ca:	7942                	ld	s2,48(sp)
    800018cc:	79a2                	ld	s3,40(sp)
    800018ce:	7a02                	ld	s4,32(sp)
    800018d0:	6ae2                	ld	s5,24(sp)
    800018d2:	6b42                	ld	s6,16(sp)
    800018d4:	6ba2                	ld	s7,8(sp)
    800018d6:	6c02                	ld	s8,0(sp)
    800018d8:	6161                	addi	sp,sp,80
    800018da:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018dc:	85e2                	mv	a1,s8
    800018de:	854a                	mv	a0,s2
    800018e0:	00000097          	auipc	ra,0x0
    800018e4:	c02080e7          	jalr	-1022(ra) # 800014e2 <sleep>
    havekids = 0;
    800018e8:	bf39                	j	80001806 <wait+0x4a>

00000000800018ea <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018ea:	7179                	addi	sp,sp,-48
    800018ec:	f406                	sd	ra,40(sp)
    800018ee:	f022                	sd	s0,32(sp)
    800018f0:	ec26                	sd	s1,24(sp)
    800018f2:	e84a                	sd	s2,16(sp)
    800018f4:	e44e                	sd	s3,8(sp)
    800018f6:	e052                	sd	s4,0(sp)
    800018f8:	1800                	addi	s0,sp,48
    800018fa:	84aa                	mv	s1,a0
    800018fc:	892e                	mv	s2,a1
    800018fe:	89b2                	mv	s3,a2
    80001900:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001902:	fffff097          	auipc	ra,0xfffff
    80001906:	538080e7          	jalr	1336(ra) # 80000e3a <myproc>
  if(user_dst){
    8000190a:	c08d                	beqz	s1,8000192c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000190c:	86d2                	mv	a3,s4
    8000190e:	864e                	mv	a2,s3
    80001910:	85ca                	mv	a1,s2
    80001912:	6928                	ld	a0,80(a0)
    80001914:	fffff097          	auipc	ra,0xfffff
    80001918:	1e6080e7          	jalr	486(ra) # 80000afa <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000191c:	70a2                	ld	ra,40(sp)
    8000191e:	7402                	ld	s0,32(sp)
    80001920:	64e2                	ld	s1,24(sp)
    80001922:	6942                	ld	s2,16(sp)
    80001924:	69a2                	ld	s3,8(sp)
    80001926:	6a02                	ld	s4,0(sp)
    80001928:	6145                	addi	sp,sp,48
    8000192a:	8082                	ret
    memmove((char *)dst, src, len);
    8000192c:	000a061b          	sext.w	a2,s4
    80001930:	85ce                	mv	a1,s3
    80001932:	854a                	mv	a0,s2
    80001934:	fffff097          	auipc	ra,0xfffff
    80001938:	8a2080e7          	jalr	-1886(ra) # 800001d6 <memmove>
    return 0;
    8000193c:	8526                	mv	a0,s1
    8000193e:	bff9                	j	8000191c <either_copyout+0x32>

0000000080001940 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001940:	7179                	addi	sp,sp,-48
    80001942:	f406                	sd	ra,40(sp)
    80001944:	f022                	sd	s0,32(sp)
    80001946:	ec26                	sd	s1,24(sp)
    80001948:	e84a                	sd	s2,16(sp)
    8000194a:	e44e                	sd	s3,8(sp)
    8000194c:	e052                	sd	s4,0(sp)
    8000194e:	1800                	addi	s0,sp,48
    80001950:	892a                	mv	s2,a0
    80001952:	84ae                	mv	s1,a1
    80001954:	89b2                	mv	s3,a2
    80001956:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001958:	fffff097          	auipc	ra,0xfffff
    8000195c:	4e2080e7          	jalr	1250(ra) # 80000e3a <myproc>
  if(user_src){
    80001960:	c08d                	beqz	s1,80001982 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001962:	86d2                	mv	a3,s4
    80001964:	864e                	mv	a2,s3
    80001966:	85ca                	mv	a1,s2
    80001968:	6928                	ld	a0,80(a0)
    8000196a:	fffff097          	auipc	ra,0xfffff
    8000196e:	21c080e7          	jalr	540(ra) # 80000b86 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001972:	70a2                	ld	ra,40(sp)
    80001974:	7402                	ld	s0,32(sp)
    80001976:	64e2                	ld	s1,24(sp)
    80001978:	6942                	ld	s2,16(sp)
    8000197a:	69a2                	ld	s3,8(sp)
    8000197c:	6a02                	ld	s4,0(sp)
    8000197e:	6145                	addi	sp,sp,48
    80001980:	8082                	ret
    memmove(dst, (char*)src, len);
    80001982:	000a061b          	sext.w	a2,s4
    80001986:	85ce                	mv	a1,s3
    80001988:	854a                	mv	a0,s2
    8000198a:	fffff097          	auipc	ra,0xfffff
    8000198e:	84c080e7          	jalr	-1972(ra) # 800001d6 <memmove>
    return 0;
    80001992:	8526                	mv	a0,s1
    80001994:	bff9                	j	80001972 <either_copyin+0x32>

0000000080001996 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001996:	715d                	addi	sp,sp,-80
    80001998:	e486                	sd	ra,72(sp)
    8000199a:	e0a2                	sd	s0,64(sp)
    8000199c:	fc26                	sd	s1,56(sp)
    8000199e:	f84a                	sd	s2,48(sp)
    800019a0:	f44e                	sd	s3,40(sp)
    800019a2:	f052                	sd	s4,32(sp)
    800019a4:	ec56                	sd	s5,24(sp)
    800019a6:	e85a                	sd	s6,16(sp)
    800019a8:	e45e                	sd	s7,8(sp)
    800019aa:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019ac:	00006517          	auipc	a0,0x6
    800019b0:	69c50513          	addi	a0,a0,1692 # 80008048 <etext+0x48>
    800019b4:	00004097          	auipc	ra,0x4
    800019b8:	2a2080e7          	jalr	674(ra) # 80005c56 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019bc:	00007497          	auipc	s1,0x7
    800019c0:	4cc48493          	addi	s1,s1,1228 # 80008e88 <proc+0x158>
    800019c4:	0000d917          	auipc	s2,0xd
    800019c8:	ec490913          	addi	s2,s2,-316 # 8000e888 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019cc:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019ce:	00006997          	auipc	s3,0x6
    800019d2:	7fa98993          	addi	s3,s3,2042 # 800081c8 <etext+0x1c8>
    printf("%d %s %s", p->pid, state, p->name);
    800019d6:	00006a97          	auipc	s5,0x6
    800019da:	7faa8a93          	addi	s5,s5,2042 # 800081d0 <etext+0x1d0>
    printf("\n");
    800019de:	00006a17          	auipc	s4,0x6
    800019e2:	66aa0a13          	addi	s4,s4,1642 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e6:	00007b97          	auipc	s7,0x7
    800019ea:	82ab8b93          	addi	s7,s7,-2006 # 80008210 <states.0>
    800019ee:	a00d                	j	80001a10 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019f0:	ed86a583          	lw	a1,-296(a3)
    800019f4:	8556                	mv	a0,s5
    800019f6:	00004097          	auipc	ra,0x4
    800019fa:	260080e7          	jalr	608(ra) # 80005c56 <printf>
    printf("\n");
    800019fe:	8552                	mv	a0,s4
    80001a00:	00004097          	auipc	ra,0x4
    80001a04:	256080e7          	jalr	598(ra) # 80005c56 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a08:	16848493          	addi	s1,s1,360
    80001a0c:	03248263          	beq	s1,s2,80001a30 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a10:	86a6                	mv	a3,s1
    80001a12:	ec04a783          	lw	a5,-320(s1)
    80001a16:	dbed                	beqz	a5,80001a08 <procdump+0x72>
      state = "???";
    80001a18:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a1a:	fcfb6be3          	bltu	s6,a5,800019f0 <procdump+0x5a>
    80001a1e:	02079713          	slli	a4,a5,0x20
    80001a22:	01d75793          	srli	a5,a4,0x1d
    80001a26:	97de                	add	a5,a5,s7
    80001a28:	6390                	ld	a2,0(a5)
    80001a2a:	f279                	bnez	a2,800019f0 <procdump+0x5a>
      state = "???";
    80001a2c:	864e                	mv	a2,s3
    80001a2e:	b7c9                	j	800019f0 <procdump+0x5a>
  }
}
    80001a30:	60a6                	ld	ra,72(sp)
    80001a32:	6406                	ld	s0,64(sp)
    80001a34:	74e2                	ld	s1,56(sp)
    80001a36:	7942                	ld	s2,48(sp)
    80001a38:	79a2                	ld	s3,40(sp)
    80001a3a:	7a02                	ld	s4,32(sp)
    80001a3c:	6ae2                	ld	s5,24(sp)
    80001a3e:	6b42                	ld	s6,16(sp)
    80001a40:	6ba2                	ld	s7,8(sp)
    80001a42:	6161                	addi	sp,sp,80
    80001a44:	8082                	ret

0000000080001a46 <swtch>:
    80001a46:	00153023          	sd	ra,0(a0)
    80001a4a:	00253423          	sd	sp,8(a0)
    80001a4e:	e900                	sd	s0,16(a0)
    80001a50:	ed04                	sd	s1,24(a0)
    80001a52:	03253023          	sd	s2,32(a0)
    80001a56:	03353423          	sd	s3,40(a0)
    80001a5a:	03453823          	sd	s4,48(a0)
    80001a5e:	03553c23          	sd	s5,56(a0)
    80001a62:	05653023          	sd	s6,64(a0)
    80001a66:	05753423          	sd	s7,72(a0)
    80001a6a:	05853823          	sd	s8,80(a0)
    80001a6e:	05953c23          	sd	s9,88(a0)
    80001a72:	07a53023          	sd	s10,96(a0)
    80001a76:	07b53423          	sd	s11,104(a0)
    80001a7a:	0005b083          	ld	ra,0(a1)
    80001a7e:	0085b103          	ld	sp,8(a1)
    80001a82:	6980                	ld	s0,16(a1)
    80001a84:	6d84                	ld	s1,24(a1)
    80001a86:	0205b903          	ld	s2,32(a1)
    80001a8a:	0285b983          	ld	s3,40(a1)
    80001a8e:	0305ba03          	ld	s4,48(a1)
    80001a92:	0385ba83          	ld	s5,56(a1)
    80001a96:	0405bb03          	ld	s6,64(a1)
    80001a9a:	0485bb83          	ld	s7,72(a1)
    80001a9e:	0505bc03          	ld	s8,80(a1)
    80001aa2:	0585bc83          	ld	s9,88(a1)
    80001aa6:	0605bd03          	ld	s10,96(a1)
    80001aaa:	0685bd83          	ld	s11,104(a1)
    80001aae:	8082                	ret

0000000080001ab0 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001ab0:	1141                	addi	sp,sp,-16
    80001ab2:	e406                	sd	ra,8(sp)
    80001ab4:	e022                	sd	s0,0(sp)
    80001ab6:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ab8:	00006597          	auipc	a1,0x6
    80001abc:	78858593          	addi	a1,a1,1928 # 80008240 <states.0+0x30>
    80001ac0:	0000d517          	auipc	a0,0xd
    80001ac4:	c7050513          	addi	a0,a0,-912 # 8000e730 <tickslock>
    80001ac8:	00004097          	auipc	ra,0x4
    80001acc:	5ec080e7          	jalr	1516(ra) # 800060b4 <initlock>
}
    80001ad0:	60a2                	ld	ra,8(sp)
    80001ad2:	6402                	ld	s0,0(sp)
    80001ad4:	0141                	addi	sp,sp,16
    80001ad6:	8082                	ret

0000000080001ad8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001ad8:	1141                	addi	sp,sp,-16
    80001ada:	e422                	sd	s0,8(sp)
    80001adc:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ade:	00003797          	auipc	a5,0x3
    80001ae2:	56278793          	addi	a5,a5,1378 # 80005040 <kernelvec>
    80001ae6:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001aea:	6422                	ld	s0,8(sp)
    80001aec:	0141                	addi	sp,sp,16
    80001aee:	8082                	ret

0000000080001af0 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001af0:	1141                	addi	sp,sp,-16
    80001af2:	e406                	sd	ra,8(sp)
    80001af4:	e022                	sd	s0,0(sp)
    80001af6:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001af8:	fffff097          	auipc	ra,0xfffff
    80001afc:	342080e7          	jalr	834(ra) # 80000e3a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b00:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b04:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b06:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b0a:	00005697          	auipc	a3,0x5
    80001b0e:	4f668693          	addi	a3,a3,1270 # 80007000 <_trampoline>
    80001b12:	00005717          	auipc	a4,0x5
    80001b16:	4ee70713          	addi	a4,a4,1262 # 80007000 <_trampoline>
    80001b1a:	8f15                	sub	a4,a4,a3
    80001b1c:	040007b7          	lui	a5,0x4000
    80001b20:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b22:	07b2                	slli	a5,a5,0xc
    80001b24:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b26:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b2a:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b2c:	18002673          	csrr	a2,satp
    80001b30:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b32:	6d30                	ld	a2,88(a0)
    80001b34:	6138                	ld	a4,64(a0)
    80001b36:	6585                	lui	a1,0x1
    80001b38:	972e                	add	a4,a4,a1
    80001b3a:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b3c:	6d38                	ld	a4,88(a0)
    80001b3e:	00000617          	auipc	a2,0x0
    80001b42:	13060613          	addi	a2,a2,304 # 80001c6e <usertrap>
    80001b46:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b48:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b4a:	8612                	mv	a2,tp
    80001b4c:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b4e:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b52:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b56:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b5a:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b5e:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b60:	6f18                	ld	a4,24(a4)
    80001b62:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b66:	6928                	ld	a0,80(a0)
    80001b68:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001b6a:	00005717          	auipc	a4,0x5
    80001b6e:	53270713          	addi	a4,a4,1330 # 8000709c <userret>
    80001b72:	8f15                	sub	a4,a4,a3
    80001b74:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001b76:	577d                	li	a4,-1
    80001b78:	177e                	slli	a4,a4,0x3f
    80001b7a:	8d59                	or	a0,a0,a4
    80001b7c:	9782                	jalr	a5
}
    80001b7e:	60a2                	ld	ra,8(sp)
    80001b80:	6402                	ld	s0,0(sp)
    80001b82:	0141                	addi	sp,sp,16
    80001b84:	8082                	ret

0000000080001b86 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b86:	1101                	addi	sp,sp,-32
    80001b88:	ec06                	sd	ra,24(sp)
    80001b8a:	e822                	sd	s0,16(sp)
    80001b8c:	e426                	sd	s1,8(sp)
    80001b8e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b90:	0000d497          	auipc	s1,0xd
    80001b94:	ba048493          	addi	s1,s1,-1120 # 8000e730 <tickslock>
    80001b98:	8526                	mv	a0,s1
    80001b9a:	00004097          	auipc	ra,0x4
    80001b9e:	5aa080e7          	jalr	1450(ra) # 80006144 <acquire>
  ticks++;
    80001ba2:	00007517          	auipc	a0,0x7
    80001ba6:	d2650513          	addi	a0,a0,-730 # 800088c8 <ticks>
    80001baa:	411c                	lw	a5,0(a0)
    80001bac:	2785                	addiw	a5,a5,1
    80001bae:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bb0:	00000097          	auipc	ra,0x0
    80001bb4:	996080e7          	jalr	-1642(ra) # 80001546 <wakeup>
  release(&tickslock);
    80001bb8:	8526                	mv	a0,s1
    80001bba:	00004097          	auipc	ra,0x4
    80001bbe:	63e080e7          	jalr	1598(ra) # 800061f8 <release>
}
    80001bc2:	60e2                	ld	ra,24(sp)
    80001bc4:	6442                	ld	s0,16(sp)
    80001bc6:	64a2                	ld	s1,8(sp)
    80001bc8:	6105                	addi	sp,sp,32
    80001bca:	8082                	ret

0000000080001bcc <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001bcc:	1101                	addi	sp,sp,-32
    80001bce:	ec06                	sd	ra,24(sp)
    80001bd0:	e822                	sd	s0,16(sp)
    80001bd2:	e426                	sd	s1,8(sp)
    80001bd4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bd6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bda:	00074d63          	bltz	a4,80001bf4 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001bde:	57fd                	li	a5,-1
    80001be0:	17fe                	slli	a5,a5,0x3f
    80001be2:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001be4:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001be6:	06f70363          	beq	a4,a5,80001c4c <devintr+0x80>
  }
}
    80001bea:	60e2                	ld	ra,24(sp)
    80001bec:	6442                	ld	s0,16(sp)
    80001bee:	64a2                	ld	s1,8(sp)
    80001bf0:	6105                	addi	sp,sp,32
    80001bf2:	8082                	ret
     (scause & 0xff) == 9){
    80001bf4:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001bf8:	46a5                	li	a3,9
    80001bfa:	fed792e3          	bne	a5,a3,80001bde <devintr+0x12>
    int irq = plic_claim();
    80001bfe:	00003097          	auipc	ra,0x3
    80001c02:	54a080e7          	jalr	1354(ra) # 80005148 <plic_claim>
    80001c06:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c08:	47a9                	li	a5,10
    80001c0a:	02f50763          	beq	a0,a5,80001c38 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c0e:	4785                	li	a5,1
    80001c10:	02f50963          	beq	a0,a5,80001c42 <devintr+0x76>
    return 1;
    80001c14:	4505                	li	a0,1
    } else if(irq){
    80001c16:	d8f1                	beqz	s1,80001bea <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c18:	85a6                	mv	a1,s1
    80001c1a:	00006517          	auipc	a0,0x6
    80001c1e:	62e50513          	addi	a0,a0,1582 # 80008248 <states.0+0x38>
    80001c22:	00004097          	auipc	ra,0x4
    80001c26:	034080e7          	jalr	52(ra) # 80005c56 <printf>
      plic_complete(irq);
    80001c2a:	8526                	mv	a0,s1
    80001c2c:	00003097          	auipc	ra,0x3
    80001c30:	540080e7          	jalr	1344(ra) # 8000516c <plic_complete>
    return 1;
    80001c34:	4505                	li	a0,1
    80001c36:	bf55                	j	80001bea <devintr+0x1e>
      uartintr();
    80001c38:	00004097          	auipc	ra,0x4
    80001c3c:	42c080e7          	jalr	1068(ra) # 80006064 <uartintr>
    80001c40:	b7ed                	j	80001c2a <devintr+0x5e>
      virtio_disk_intr();
    80001c42:	00004097          	auipc	ra,0x4
    80001c46:	9f2080e7          	jalr	-1550(ra) # 80005634 <virtio_disk_intr>
    80001c4a:	b7c5                	j	80001c2a <devintr+0x5e>
    if(cpuid() == 0){
    80001c4c:	fffff097          	auipc	ra,0xfffff
    80001c50:	1c2080e7          	jalr	450(ra) # 80000e0e <cpuid>
    80001c54:	c901                	beqz	a0,80001c64 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c56:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c5a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c5c:	14479073          	csrw	sip,a5
    return 2;
    80001c60:	4509                	li	a0,2
    80001c62:	b761                	j	80001bea <devintr+0x1e>
      clockintr();
    80001c64:	00000097          	auipc	ra,0x0
    80001c68:	f22080e7          	jalr	-222(ra) # 80001b86 <clockintr>
    80001c6c:	b7ed                	j	80001c56 <devintr+0x8a>

0000000080001c6e <usertrap>:
{
    80001c6e:	1101                	addi	sp,sp,-32
    80001c70:	ec06                	sd	ra,24(sp)
    80001c72:	e822                	sd	s0,16(sp)
    80001c74:	e426                	sd	s1,8(sp)
    80001c76:	e04a                	sd	s2,0(sp)
    80001c78:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c7a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c7e:	1007f793          	andi	a5,a5,256
    80001c82:	e3d1                	bnez	a5,80001d06 <usertrap+0x98>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c84:	00003797          	auipc	a5,0x3
    80001c88:	3bc78793          	addi	a5,a5,956 # 80005040 <kernelvec>
    80001c8c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c90:	fffff097          	auipc	ra,0xfffff
    80001c94:	1aa080e7          	jalr	426(ra) # 80000e3a <myproc>
    80001c98:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c9a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c9c:	14102773          	csrr	a4,sepc
    80001ca0:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ca2:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001ca6:	47a1                	li	a5,8
    80001ca8:	06f70763          	beq	a4,a5,80001d16 <usertrap+0xa8>
  } else if((which_dev = devintr()) != 0){
    80001cac:	00000097          	auipc	ra,0x0
    80001cb0:	f20080e7          	jalr	-224(ra) # 80001bcc <devintr>
    80001cb4:	892a                	mv	s2,a0
    80001cb6:	e171                	bnez	a0,80001d7a <usertrap+0x10c>
    80001cb8:	14202773          	csrr	a4,scause
  else if(r_scause() == 13 || r_scause() == 15) {
    80001cbc:	47b5                	li	a5,13
    80001cbe:	0af70563          	beq	a4,a5,80001d68 <usertrap+0xfa>
    80001cc2:	14202773          	csrr	a4,scause
    80001cc6:	47bd                	li	a5,15
    80001cc8:	0af70063          	beq	a4,a5,80001d68 <usertrap+0xfa>
    80001ccc:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001cd0:	5890                	lw	a2,48(s1)
    80001cd2:	00006517          	auipc	a0,0x6
    80001cd6:	5de50513          	addi	a0,a0,1502 # 800082b0 <states.0+0xa0>
    80001cda:	00004097          	auipc	ra,0x4
    80001cde:	f7c080e7          	jalr	-132(ra) # 80005c56 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ce2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ce6:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001cea:	00006517          	auipc	a0,0x6
    80001cee:	5f650513          	addi	a0,a0,1526 # 800082e0 <states.0+0xd0>
    80001cf2:	00004097          	auipc	ra,0x4
    80001cf6:	f64080e7          	jalr	-156(ra) # 80005c56 <printf>
    setkilled(p);
    80001cfa:	8526                	mv	a0,s1
    80001cfc:	00000097          	auipc	ra,0x0
    80001d00:	a62080e7          	jalr	-1438(ra) # 8000175e <setkilled>
    80001d04:	a825                	j	80001d3c <usertrap+0xce>
    panic("usertrap: not from user mode");
    80001d06:	00006517          	auipc	a0,0x6
    80001d0a:	56250513          	addi	a0,a0,1378 # 80008268 <states.0+0x58>
    80001d0e:	00004097          	auipc	ra,0x4
    80001d12:	efe080e7          	jalr	-258(ra) # 80005c0c <panic>
    if(killed(p))
    80001d16:	00000097          	auipc	ra,0x0
    80001d1a:	a74080e7          	jalr	-1420(ra) # 8000178a <killed>
    80001d1e:	ed1d                	bnez	a0,80001d5c <usertrap+0xee>
    p->trapframe->epc += 4;
    80001d20:	6cb8                	ld	a4,88(s1)
    80001d22:	6f1c                	ld	a5,24(a4)
    80001d24:	0791                	addi	a5,a5,4
    80001d26:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d28:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d2c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d30:	10079073          	csrw	sstatus,a5
    syscall();
    80001d34:	00000097          	auipc	ra,0x0
    80001d38:	2ba080e7          	jalr	698(ra) # 80001fee <syscall>
  if(killed(p))
    80001d3c:	8526                	mv	a0,s1
    80001d3e:	00000097          	auipc	ra,0x0
    80001d42:	a4c080e7          	jalr	-1460(ra) # 8000178a <killed>
    80001d46:	e129                	bnez	a0,80001d88 <usertrap+0x11a>
  usertrapret();
    80001d48:	00000097          	auipc	ra,0x0
    80001d4c:	da8080e7          	jalr	-600(ra) # 80001af0 <usertrapret>
}
    80001d50:	60e2                	ld	ra,24(sp)
    80001d52:	6442                	ld	s0,16(sp)
    80001d54:	64a2                	ld	s1,8(sp)
    80001d56:	6902                	ld	s2,0(sp)
    80001d58:	6105                	addi	sp,sp,32
    80001d5a:	8082                	ret
      exit(-1);
    80001d5c:	557d                	li	a0,-1
    80001d5e:	00000097          	auipc	ra,0x0
    80001d62:	8b8080e7          	jalr	-1864(ra) # 80001616 <exit>
    80001d66:	bf6d                	j	80001d20 <usertrap+0xb2>
    printf("Now, after mmap, we get a page fault\n");
    80001d68:	00006517          	auipc	a0,0x6
    80001d6c:	52050513          	addi	a0,a0,1312 # 80008288 <states.0+0x78>
    80001d70:	00004097          	auipc	ra,0x4
    80001d74:	ee6080e7          	jalr	-282(ra) # 80005c56 <printf>
    goto err;
    80001d78:	bf91                	j	80001ccc <usertrap+0x5e>
  if(killed(p))
    80001d7a:	8526                	mv	a0,s1
    80001d7c:	00000097          	auipc	ra,0x0
    80001d80:	a0e080e7          	jalr	-1522(ra) # 8000178a <killed>
    80001d84:	c901                	beqz	a0,80001d94 <usertrap+0x126>
    80001d86:	a011                	j	80001d8a <usertrap+0x11c>
    80001d88:	4901                	li	s2,0
    exit(-1);
    80001d8a:	557d                	li	a0,-1
    80001d8c:	00000097          	auipc	ra,0x0
    80001d90:	88a080e7          	jalr	-1910(ra) # 80001616 <exit>
  if(which_dev == 2)
    80001d94:	4789                	li	a5,2
    80001d96:	faf919e3          	bne	s2,a5,80001d48 <usertrap+0xda>
    yield();
    80001d9a:	fffff097          	auipc	ra,0xfffff
    80001d9e:	70c080e7          	jalr	1804(ra) # 800014a6 <yield>
    80001da2:	b75d                	j	80001d48 <usertrap+0xda>

0000000080001da4 <kerneltrap>:
{
    80001da4:	7179                	addi	sp,sp,-48
    80001da6:	f406                	sd	ra,40(sp)
    80001da8:	f022                	sd	s0,32(sp)
    80001daa:	ec26                	sd	s1,24(sp)
    80001dac:	e84a                	sd	s2,16(sp)
    80001dae:	e44e                	sd	s3,8(sp)
    80001db0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001db2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001db6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dba:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dbe:	1004f793          	andi	a5,s1,256
    80001dc2:	cb85                	beqz	a5,80001df2 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dc4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dc8:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dca:	ef85                	bnez	a5,80001e02 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dcc:	00000097          	auipc	ra,0x0
    80001dd0:	e00080e7          	jalr	-512(ra) # 80001bcc <devintr>
    80001dd4:	cd1d                	beqz	a0,80001e12 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dd6:	4789                	li	a5,2
    80001dd8:	06f50a63          	beq	a0,a5,80001e4c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ddc:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001de0:	10049073          	csrw	sstatus,s1
}
    80001de4:	70a2                	ld	ra,40(sp)
    80001de6:	7402                	ld	s0,32(sp)
    80001de8:	64e2                	ld	s1,24(sp)
    80001dea:	6942                	ld	s2,16(sp)
    80001dec:	69a2                	ld	s3,8(sp)
    80001dee:	6145                	addi	sp,sp,48
    80001df0:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001df2:	00006517          	auipc	a0,0x6
    80001df6:	50e50513          	addi	a0,a0,1294 # 80008300 <states.0+0xf0>
    80001dfa:	00004097          	auipc	ra,0x4
    80001dfe:	e12080e7          	jalr	-494(ra) # 80005c0c <panic>
    panic("kerneltrap: interrupts enabled");
    80001e02:	00006517          	auipc	a0,0x6
    80001e06:	52650513          	addi	a0,a0,1318 # 80008328 <states.0+0x118>
    80001e0a:	00004097          	auipc	ra,0x4
    80001e0e:	e02080e7          	jalr	-510(ra) # 80005c0c <panic>
    printf("scause %p\n", scause);
    80001e12:	85ce                	mv	a1,s3
    80001e14:	00006517          	auipc	a0,0x6
    80001e18:	53450513          	addi	a0,a0,1332 # 80008348 <states.0+0x138>
    80001e1c:	00004097          	auipc	ra,0x4
    80001e20:	e3a080e7          	jalr	-454(ra) # 80005c56 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e24:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e28:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e2c:	00006517          	auipc	a0,0x6
    80001e30:	52c50513          	addi	a0,a0,1324 # 80008358 <states.0+0x148>
    80001e34:	00004097          	auipc	ra,0x4
    80001e38:	e22080e7          	jalr	-478(ra) # 80005c56 <printf>
    panic("kerneltrap");
    80001e3c:	00006517          	auipc	a0,0x6
    80001e40:	53450513          	addi	a0,a0,1332 # 80008370 <states.0+0x160>
    80001e44:	00004097          	auipc	ra,0x4
    80001e48:	dc8080e7          	jalr	-568(ra) # 80005c0c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e4c:	fffff097          	auipc	ra,0xfffff
    80001e50:	fee080e7          	jalr	-18(ra) # 80000e3a <myproc>
    80001e54:	d541                	beqz	a0,80001ddc <kerneltrap+0x38>
    80001e56:	fffff097          	auipc	ra,0xfffff
    80001e5a:	fe4080e7          	jalr	-28(ra) # 80000e3a <myproc>
    80001e5e:	4d18                	lw	a4,24(a0)
    80001e60:	4791                	li	a5,4
    80001e62:	f6f71de3          	bne	a4,a5,80001ddc <kerneltrap+0x38>
    yield();
    80001e66:	fffff097          	auipc	ra,0xfffff
    80001e6a:	640080e7          	jalr	1600(ra) # 800014a6 <yield>
    80001e6e:	b7bd                	j	80001ddc <kerneltrap+0x38>

0000000080001e70 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e70:	1101                	addi	sp,sp,-32
    80001e72:	ec06                	sd	ra,24(sp)
    80001e74:	e822                	sd	s0,16(sp)
    80001e76:	e426                	sd	s1,8(sp)
    80001e78:	1000                	addi	s0,sp,32
    80001e7a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e7c:	fffff097          	auipc	ra,0xfffff
    80001e80:	fbe080e7          	jalr	-66(ra) # 80000e3a <myproc>
  switch (n) {
    80001e84:	4795                	li	a5,5
    80001e86:	0497e163          	bltu	a5,s1,80001ec8 <argraw+0x58>
    80001e8a:	048a                	slli	s1,s1,0x2
    80001e8c:	00006717          	auipc	a4,0x6
    80001e90:	51c70713          	addi	a4,a4,1308 # 800083a8 <states.0+0x198>
    80001e94:	94ba                	add	s1,s1,a4
    80001e96:	409c                	lw	a5,0(s1)
    80001e98:	97ba                	add	a5,a5,a4
    80001e9a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e9c:	6d3c                	ld	a5,88(a0)
    80001e9e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ea0:	60e2                	ld	ra,24(sp)
    80001ea2:	6442                	ld	s0,16(sp)
    80001ea4:	64a2                	ld	s1,8(sp)
    80001ea6:	6105                	addi	sp,sp,32
    80001ea8:	8082                	ret
    return p->trapframe->a1;
    80001eaa:	6d3c                	ld	a5,88(a0)
    80001eac:	7fa8                	ld	a0,120(a5)
    80001eae:	bfcd                	j	80001ea0 <argraw+0x30>
    return p->trapframe->a2;
    80001eb0:	6d3c                	ld	a5,88(a0)
    80001eb2:	63c8                	ld	a0,128(a5)
    80001eb4:	b7f5                	j	80001ea0 <argraw+0x30>
    return p->trapframe->a3;
    80001eb6:	6d3c                	ld	a5,88(a0)
    80001eb8:	67c8                	ld	a0,136(a5)
    80001eba:	b7dd                	j	80001ea0 <argraw+0x30>
    return p->trapframe->a4;
    80001ebc:	6d3c                	ld	a5,88(a0)
    80001ebe:	6bc8                	ld	a0,144(a5)
    80001ec0:	b7c5                	j	80001ea0 <argraw+0x30>
    return p->trapframe->a5;
    80001ec2:	6d3c                	ld	a5,88(a0)
    80001ec4:	6fc8                	ld	a0,152(a5)
    80001ec6:	bfe9                	j	80001ea0 <argraw+0x30>
  panic("argraw");
    80001ec8:	00006517          	auipc	a0,0x6
    80001ecc:	4b850513          	addi	a0,a0,1208 # 80008380 <states.0+0x170>
    80001ed0:	00004097          	auipc	ra,0x4
    80001ed4:	d3c080e7          	jalr	-708(ra) # 80005c0c <panic>

0000000080001ed8 <fetchaddr>:
{
    80001ed8:	1101                	addi	sp,sp,-32
    80001eda:	ec06                	sd	ra,24(sp)
    80001edc:	e822                	sd	s0,16(sp)
    80001ede:	e426                	sd	s1,8(sp)
    80001ee0:	e04a                	sd	s2,0(sp)
    80001ee2:	1000                	addi	s0,sp,32
    80001ee4:	84aa                	mv	s1,a0
    80001ee6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ee8:	fffff097          	auipc	ra,0xfffff
    80001eec:	f52080e7          	jalr	-174(ra) # 80000e3a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001ef0:	653c                	ld	a5,72(a0)
    80001ef2:	02f4f863          	bgeu	s1,a5,80001f22 <fetchaddr+0x4a>
    80001ef6:	00848713          	addi	a4,s1,8
    80001efa:	02e7e663          	bltu	a5,a4,80001f26 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001efe:	46a1                	li	a3,8
    80001f00:	8626                	mv	a2,s1
    80001f02:	85ca                	mv	a1,s2
    80001f04:	6928                	ld	a0,80(a0)
    80001f06:	fffff097          	auipc	ra,0xfffff
    80001f0a:	c80080e7          	jalr	-896(ra) # 80000b86 <copyin>
    80001f0e:	00a03533          	snez	a0,a0
    80001f12:	40a00533          	neg	a0,a0
}
    80001f16:	60e2                	ld	ra,24(sp)
    80001f18:	6442                	ld	s0,16(sp)
    80001f1a:	64a2                	ld	s1,8(sp)
    80001f1c:	6902                	ld	s2,0(sp)
    80001f1e:	6105                	addi	sp,sp,32
    80001f20:	8082                	ret
    return -1;
    80001f22:	557d                	li	a0,-1
    80001f24:	bfcd                	j	80001f16 <fetchaddr+0x3e>
    80001f26:	557d                	li	a0,-1
    80001f28:	b7fd                	j	80001f16 <fetchaddr+0x3e>

0000000080001f2a <fetchstr>:
{
    80001f2a:	7179                	addi	sp,sp,-48
    80001f2c:	f406                	sd	ra,40(sp)
    80001f2e:	f022                	sd	s0,32(sp)
    80001f30:	ec26                	sd	s1,24(sp)
    80001f32:	e84a                	sd	s2,16(sp)
    80001f34:	e44e                	sd	s3,8(sp)
    80001f36:	1800                	addi	s0,sp,48
    80001f38:	892a                	mv	s2,a0
    80001f3a:	84ae                	mv	s1,a1
    80001f3c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f3e:	fffff097          	auipc	ra,0xfffff
    80001f42:	efc080e7          	jalr	-260(ra) # 80000e3a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001f46:	86ce                	mv	a3,s3
    80001f48:	864a                	mv	a2,s2
    80001f4a:	85a6                	mv	a1,s1
    80001f4c:	6928                	ld	a0,80(a0)
    80001f4e:	fffff097          	auipc	ra,0xfffff
    80001f52:	cc6080e7          	jalr	-826(ra) # 80000c14 <copyinstr>
    80001f56:	00054e63          	bltz	a0,80001f72 <fetchstr+0x48>
  return strlen(buf);
    80001f5a:	8526                	mv	a0,s1
    80001f5c:	ffffe097          	auipc	ra,0xffffe
    80001f60:	39a080e7          	jalr	922(ra) # 800002f6 <strlen>
}
    80001f64:	70a2                	ld	ra,40(sp)
    80001f66:	7402                	ld	s0,32(sp)
    80001f68:	64e2                	ld	s1,24(sp)
    80001f6a:	6942                	ld	s2,16(sp)
    80001f6c:	69a2                	ld	s3,8(sp)
    80001f6e:	6145                	addi	sp,sp,48
    80001f70:	8082                	ret
    return -1;
    80001f72:	557d                	li	a0,-1
    80001f74:	bfc5                	j	80001f64 <fetchstr+0x3a>

0000000080001f76 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001f76:	1101                	addi	sp,sp,-32
    80001f78:	ec06                	sd	ra,24(sp)
    80001f7a:	e822                	sd	s0,16(sp)
    80001f7c:	e426                	sd	s1,8(sp)
    80001f7e:	1000                	addi	s0,sp,32
    80001f80:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f82:	00000097          	auipc	ra,0x0
    80001f86:	eee080e7          	jalr	-274(ra) # 80001e70 <argraw>
    80001f8a:	c088                	sw	a0,0(s1)
}
    80001f8c:	60e2                	ld	ra,24(sp)
    80001f8e:	6442                	ld	s0,16(sp)
    80001f90:	64a2                	ld	s1,8(sp)
    80001f92:	6105                	addi	sp,sp,32
    80001f94:	8082                	ret

0000000080001f96 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001f96:	1101                	addi	sp,sp,-32
    80001f98:	ec06                	sd	ra,24(sp)
    80001f9a:	e822                	sd	s0,16(sp)
    80001f9c:	e426                	sd	s1,8(sp)
    80001f9e:	1000                	addi	s0,sp,32
    80001fa0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fa2:	00000097          	auipc	ra,0x0
    80001fa6:	ece080e7          	jalr	-306(ra) # 80001e70 <argraw>
    80001faa:	e088                	sd	a0,0(s1)
}
    80001fac:	60e2                	ld	ra,24(sp)
    80001fae:	6442                	ld	s0,16(sp)
    80001fb0:	64a2                	ld	s1,8(sp)
    80001fb2:	6105                	addi	sp,sp,32
    80001fb4:	8082                	ret

0000000080001fb6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fb6:	7179                	addi	sp,sp,-48
    80001fb8:	f406                	sd	ra,40(sp)
    80001fba:	f022                	sd	s0,32(sp)
    80001fbc:	ec26                	sd	s1,24(sp)
    80001fbe:	e84a                	sd	s2,16(sp)
    80001fc0:	1800                	addi	s0,sp,48
    80001fc2:	84ae                	mv	s1,a1
    80001fc4:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001fc6:	fd840593          	addi	a1,s0,-40
    80001fca:	00000097          	auipc	ra,0x0
    80001fce:	fcc080e7          	jalr	-52(ra) # 80001f96 <argaddr>
  return fetchstr(addr, buf, max);
    80001fd2:	864a                	mv	a2,s2
    80001fd4:	85a6                	mv	a1,s1
    80001fd6:	fd843503          	ld	a0,-40(s0)
    80001fda:	00000097          	auipc	ra,0x0
    80001fde:	f50080e7          	jalr	-176(ra) # 80001f2a <fetchstr>
}
    80001fe2:	70a2                	ld	ra,40(sp)
    80001fe4:	7402                	ld	s0,32(sp)
    80001fe6:	64e2                	ld	s1,24(sp)
    80001fe8:	6942                	ld	s2,16(sp)
    80001fea:	6145                	addi	sp,sp,48
    80001fec:	8082                	ret

0000000080001fee <syscall>:
[SYS_munmap]  sys_munmap,
};

void
syscall(void)
{
    80001fee:	1101                	addi	sp,sp,-32
    80001ff0:	ec06                	sd	ra,24(sp)
    80001ff2:	e822                	sd	s0,16(sp)
    80001ff4:	e426                	sd	s1,8(sp)
    80001ff6:	e04a                	sd	s2,0(sp)
    80001ff8:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001ffa:	fffff097          	auipc	ra,0xfffff
    80001ffe:	e40080e7          	jalr	-448(ra) # 80000e3a <myproc>
    80002002:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002004:	05853903          	ld	s2,88(a0)
    80002008:	0a893783          	ld	a5,168(s2)
    8000200c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002010:	37fd                	addiw	a5,a5,-1
    80002012:	4759                	li	a4,22
    80002014:	00f76f63          	bltu	a4,a5,80002032 <syscall+0x44>
    80002018:	00369713          	slli	a4,a3,0x3
    8000201c:	00006797          	auipc	a5,0x6
    80002020:	3a478793          	addi	a5,a5,932 # 800083c0 <syscalls>
    80002024:	97ba                	add	a5,a5,a4
    80002026:	639c                	ld	a5,0(a5)
    80002028:	c789                	beqz	a5,80002032 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000202a:	9782                	jalr	a5
    8000202c:	06a93823          	sd	a0,112(s2)
    80002030:	a839                	j	8000204e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002032:	15848613          	addi	a2,s1,344
    80002036:	588c                	lw	a1,48(s1)
    80002038:	00006517          	auipc	a0,0x6
    8000203c:	35050513          	addi	a0,a0,848 # 80008388 <states.0+0x178>
    80002040:	00004097          	auipc	ra,0x4
    80002044:	c16080e7          	jalr	-1002(ra) # 80005c56 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002048:	6cbc                	ld	a5,88(s1)
    8000204a:	577d                	li	a4,-1
    8000204c:	fbb8                	sd	a4,112(a5)
  }
}
    8000204e:	60e2                	ld	ra,24(sp)
    80002050:	6442                	ld	s0,16(sp)
    80002052:	64a2                	ld	s1,8(sp)
    80002054:	6902                	ld	s2,0(sp)
    80002056:	6105                	addi	sp,sp,32
    80002058:	8082                	ret

000000008000205a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000205a:	1101                	addi	sp,sp,-32
    8000205c:	ec06                	sd	ra,24(sp)
    8000205e:	e822                	sd	s0,16(sp)
    80002060:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002062:	fec40593          	addi	a1,s0,-20
    80002066:	4501                	li	a0,0
    80002068:	00000097          	auipc	ra,0x0
    8000206c:	f0e080e7          	jalr	-242(ra) # 80001f76 <argint>
  exit(n);
    80002070:	fec42503          	lw	a0,-20(s0)
    80002074:	fffff097          	auipc	ra,0xfffff
    80002078:	5a2080e7          	jalr	1442(ra) # 80001616 <exit>
  return 0;  // not reached
}
    8000207c:	4501                	li	a0,0
    8000207e:	60e2                	ld	ra,24(sp)
    80002080:	6442                	ld	s0,16(sp)
    80002082:	6105                	addi	sp,sp,32
    80002084:	8082                	ret

0000000080002086 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002086:	1141                	addi	sp,sp,-16
    80002088:	e406                	sd	ra,8(sp)
    8000208a:	e022                	sd	s0,0(sp)
    8000208c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000208e:	fffff097          	auipc	ra,0xfffff
    80002092:	dac080e7          	jalr	-596(ra) # 80000e3a <myproc>
}
    80002096:	5908                	lw	a0,48(a0)
    80002098:	60a2                	ld	ra,8(sp)
    8000209a:	6402                	ld	s0,0(sp)
    8000209c:	0141                	addi	sp,sp,16
    8000209e:	8082                	ret

00000000800020a0 <sys_fork>:

uint64
sys_fork(void)
{
    800020a0:	1141                	addi	sp,sp,-16
    800020a2:	e406                	sd	ra,8(sp)
    800020a4:	e022                	sd	s0,0(sp)
    800020a6:	0800                	addi	s0,sp,16
  return fork();
    800020a8:	fffff097          	auipc	ra,0xfffff
    800020ac:	148080e7          	jalr	328(ra) # 800011f0 <fork>
}
    800020b0:	60a2                	ld	ra,8(sp)
    800020b2:	6402                	ld	s0,0(sp)
    800020b4:	0141                	addi	sp,sp,16
    800020b6:	8082                	ret

00000000800020b8 <sys_wait>:

uint64
sys_wait(void)
{
    800020b8:	1101                	addi	sp,sp,-32
    800020ba:	ec06                	sd	ra,24(sp)
    800020bc:	e822                	sd	s0,16(sp)
    800020be:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800020c0:	fe840593          	addi	a1,s0,-24
    800020c4:	4501                	li	a0,0
    800020c6:	00000097          	auipc	ra,0x0
    800020ca:	ed0080e7          	jalr	-304(ra) # 80001f96 <argaddr>
  return wait(p);
    800020ce:	fe843503          	ld	a0,-24(s0)
    800020d2:	fffff097          	auipc	ra,0xfffff
    800020d6:	6ea080e7          	jalr	1770(ra) # 800017bc <wait>
}
    800020da:	60e2                	ld	ra,24(sp)
    800020dc:	6442                	ld	s0,16(sp)
    800020de:	6105                	addi	sp,sp,32
    800020e0:	8082                	ret

00000000800020e2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020e2:	7179                	addi	sp,sp,-48
    800020e4:	f406                	sd	ra,40(sp)
    800020e6:	f022                	sd	s0,32(sp)
    800020e8:	ec26                	sd	s1,24(sp)
    800020ea:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800020ec:	fdc40593          	addi	a1,s0,-36
    800020f0:	4501                	li	a0,0
    800020f2:	00000097          	auipc	ra,0x0
    800020f6:	e84080e7          	jalr	-380(ra) # 80001f76 <argint>
  addr = myproc()->sz;
    800020fa:	fffff097          	auipc	ra,0xfffff
    800020fe:	d40080e7          	jalr	-704(ra) # 80000e3a <myproc>
    80002102:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002104:	fdc42503          	lw	a0,-36(s0)
    80002108:	fffff097          	auipc	ra,0xfffff
    8000210c:	08c080e7          	jalr	140(ra) # 80001194 <growproc>
    80002110:	00054863          	bltz	a0,80002120 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002114:	8526                	mv	a0,s1
    80002116:	70a2                	ld	ra,40(sp)
    80002118:	7402                	ld	s0,32(sp)
    8000211a:	64e2                	ld	s1,24(sp)
    8000211c:	6145                	addi	sp,sp,48
    8000211e:	8082                	ret
    return -1;
    80002120:	54fd                	li	s1,-1
    80002122:	bfcd                	j	80002114 <sys_sbrk+0x32>

0000000080002124 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002124:	7139                	addi	sp,sp,-64
    80002126:	fc06                	sd	ra,56(sp)
    80002128:	f822                	sd	s0,48(sp)
    8000212a:	f426                	sd	s1,40(sp)
    8000212c:	f04a                	sd	s2,32(sp)
    8000212e:	ec4e                	sd	s3,24(sp)
    80002130:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002132:	fcc40593          	addi	a1,s0,-52
    80002136:	4501                	li	a0,0
    80002138:	00000097          	auipc	ra,0x0
    8000213c:	e3e080e7          	jalr	-450(ra) # 80001f76 <argint>
  if(n < 0)
    80002140:	fcc42783          	lw	a5,-52(s0)
    80002144:	0607cf63          	bltz	a5,800021c2 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002148:	0000c517          	auipc	a0,0xc
    8000214c:	5e850513          	addi	a0,a0,1512 # 8000e730 <tickslock>
    80002150:	00004097          	auipc	ra,0x4
    80002154:	ff4080e7          	jalr	-12(ra) # 80006144 <acquire>
  ticks0 = ticks;
    80002158:	00006917          	auipc	s2,0x6
    8000215c:	77092903          	lw	s2,1904(s2) # 800088c8 <ticks>
  while(ticks - ticks0 < n){
    80002160:	fcc42783          	lw	a5,-52(s0)
    80002164:	cf9d                	beqz	a5,800021a2 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002166:	0000c997          	auipc	s3,0xc
    8000216a:	5ca98993          	addi	s3,s3,1482 # 8000e730 <tickslock>
    8000216e:	00006497          	auipc	s1,0x6
    80002172:	75a48493          	addi	s1,s1,1882 # 800088c8 <ticks>
    if(killed(myproc())){
    80002176:	fffff097          	auipc	ra,0xfffff
    8000217a:	cc4080e7          	jalr	-828(ra) # 80000e3a <myproc>
    8000217e:	fffff097          	auipc	ra,0xfffff
    80002182:	60c080e7          	jalr	1548(ra) # 8000178a <killed>
    80002186:	e129                	bnez	a0,800021c8 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002188:	85ce                	mv	a1,s3
    8000218a:	8526                	mv	a0,s1
    8000218c:	fffff097          	auipc	ra,0xfffff
    80002190:	356080e7          	jalr	854(ra) # 800014e2 <sleep>
  while(ticks - ticks0 < n){
    80002194:	409c                	lw	a5,0(s1)
    80002196:	412787bb          	subw	a5,a5,s2
    8000219a:	fcc42703          	lw	a4,-52(s0)
    8000219e:	fce7ece3          	bltu	a5,a4,80002176 <sys_sleep+0x52>
  }
  release(&tickslock);
    800021a2:	0000c517          	auipc	a0,0xc
    800021a6:	58e50513          	addi	a0,a0,1422 # 8000e730 <tickslock>
    800021aa:	00004097          	auipc	ra,0x4
    800021ae:	04e080e7          	jalr	78(ra) # 800061f8 <release>
  return 0;
    800021b2:	4501                	li	a0,0
}
    800021b4:	70e2                	ld	ra,56(sp)
    800021b6:	7442                	ld	s0,48(sp)
    800021b8:	74a2                	ld	s1,40(sp)
    800021ba:	7902                	ld	s2,32(sp)
    800021bc:	69e2                	ld	s3,24(sp)
    800021be:	6121                	addi	sp,sp,64
    800021c0:	8082                	ret
    n = 0;
    800021c2:	fc042623          	sw	zero,-52(s0)
    800021c6:	b749                	j	80002148 <sys_sleep+0x24>
      release(&tickslock);
    800021c8:	0000c517          	auipc	a0,0xc
    800021cc:	56850513          	addi	a0,a0,1384 # 8000e730 <tickslock>
    800021d0:	00004097          	auipc	ra,0x4
    800021d4:	028080e7          	jalr	40(ra) # 800061f8 <release>
      return -1;
    800021d8:	557d                	li	a0,-1
    800021da:	bfe9                	j	800021b4 <sys_sleep+0x90>

00000000800021dc <sys_kill>:

uint64
sys_kill(void)
{
    800021dc:	1101                	addi	sp,sp,-32
    800021de:	ec06                	sd	ra,24(sp)
    800021e0:	e822                	sd	s0,16(sp)
    800021e2:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800021e4:	fec40593          	addi	a1,s0,-20
    800021e8:	4501                	li	a0,0
    800021ea:	00000097          	auipc	ra,0x0
    800021ee:	d8c080e7          	jalr	-628(ra) # 80001f76 <argint>
  return kill(pid);
    800021f2:	fec42503          	lw	a0,-20(s0)
    800021f6:	fffff097          	auipc	ra,0xfffff
    800021fa:	4f6080e7          	jalr	1270(ra) # 800016ec <kill>
}
    800021fe:	60e2                	ld	ra,24(sp)
    80002200:	6442                	ld	s0,16(sp)
    80002202:	6105                	addi	sp,sp,32
    80002204:	8082                	ret

0000000080002206 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002206:	1101                	addi	sp,sp,-32
    80002208:	ec06                	sd	ra,24(sp)
    8000220a:	e822                	sd	s0,16(sp)
    8000220c:	e426                	sd	s1,8(sp)
    8000220e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002210:	0000c517          	auipc	a0,0xc
    80002214:	52050513          	addi	a0,a0,1312 # 8000e730 <tickslock>
    80002218:	00004097          	auipc	ra,0x4
    8000221c:	f2c080e7          	jalr	-212(ra) # 80006144 <acquire>
  xticks = ticks;
    80002220:	00006497          	auipc	s1,0x6
    80002224:	6a84a483          	lw	s1,1704(s1) # 800088c8 <ticks>
  release(&tickslock);
    80002228:	0000c517          	auipc	a0,0xc
    8000222c:	50850513          	addi	a0,a0,1288 # 8000e730 <tickslock>
    80002230:	00004097          	auipc	ra,0x4
    80002234:	fc8080e7          	jalr	-56(ra) # 800061f8 <release>
  return xticks;
}
    80002238:	02049513          	slli	a0,s1,0x20
    8000223c:	9101                	srli	a0,a0,0x20
    8000223e:	60e2                	ld	ra,24(sp)
    80002240:	6442                	ld	s0,16(sp)
    80002242:	64a2                	ld	s1,8(sp)
    80002244:	6105                	addi	sp,sp,32
    80002246:	8082                	ret

0000000080002248 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002248:	7179                	addi	sp,sp,-48
    8000224a:	f406                	sd	ra,40(sp)
    8000224c:	f022                	sd	s0,32(sp)
    8000224e:	ec26                	sd	s1,24(sp)
    80002250:	e84a                	sd	s2,16(sp)
    80002252:	e44e                	sd	s3,8(sp)
    80002254:	e052                	sd	s4,0(sp)
    80002256:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002258:	00006597          	auipc	a1,0x6
    8000225c:	22858593          	addi	a1,a1,552 # 80008480 <syscalls+0xc0>
    80002260:	0000c517          	auipc	a0,0xc
    80002264:	4e850513          	addi	a0,a0,1256 # 8000e748 <bcache>
    80002268:	00004097          	auipc	ra,0x4
    8000226c:	e4c080e7          	jalr	-436(ra) # 800060b4 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002270:	00014797          	auipc	a5,0x14
    80002274:	4d878793          	addi	a5,a5,1240 # 80016748 <bcache+0x8000>
    80002278:	00014717          	auipc	a4,0x14
    8000227c:	73870713          	addi	a4,a4,1848 # 800169b0 <bcache+0x8268>
    80002280:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002284:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002288:	0000c497          	auipc	s1,0xc
    8000228c:	4d848493          	addi	s1,s1,1240 # 8000e760 <bcache+0x18>
    b->next = bcache.head.next;
    80002290:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002292:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002294:	00006a17          	auipc	s4,0x6
    80002298:	1f4a0a13          	addi	s4,s4,500 # 80008488 <syscalls+0xc8>
    b->next = bcache.head.next;
    8000229c:	2b893783          	ld	a5,696(s2)
    800022a0:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800022a2:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800022a6:	85d2                	mv	a1,s4
    800022a8:	01048513          	addi	a0,s1,16
    800022ac:	00001097          	auipc	ra,0x1
    800022b0:	4c8080e7          	jalr	1224(ra) # 80003774 <initsleeplock>
    bcache.head.next->prev = b;
    800022b4:	2b893783          	ld	a5,696(s2)
    800022b8:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022ba:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022be:	45848493          	addi	s1,s1,1112
    800022c2:	fd349de3          	bne	s1,s3,8000229c <binit+0x54>
  }
}
    800022c6:	70a2                	ld	ra,40(sp)
    800022c8:	7402                	ld	s0,32(sp)
    800022ca:	64e2                	ld	s1,24(sp)
    800022cc:	6942                	ld	s2,16(sp)
    800022ce:	69a2                	ld	s3,8(sp)
    800022d0:	6a02                	ld	s4,0(sp)
    800022d2:	6145                	addi	sp,sp,48
    800022d4:	8082                	ret

00000000800022d6 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022d6:	7179                	addi	sp,sp,-48
    800022d8:	f406                	sd	ra,40(sp)
    800022da:	f022                	sd	s0,32(sp)
    800022dc:	ec26                	sd	s1,24(sp)
    800022de:	e84a                	sd	s2,16(sp)
    800022e0:	e44e                	sd	s3,8(sp)
    800022e2:	1800                	addi	s0,sp,48
    800022e4:	892a                	mv	s2,a0
    800022e6:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800022e8:	0000c517          	auipc	a0,0xc
    800022ec:	46050513          	addi	a0,a0,1120 # 8000e748 <bcache>
    800022f0:	00004097          	auipc	ra,0x4
    800022f4:	e54080e7          	jalr	-428(ra) # 80006144 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022f8:	00014497          	auipc	s1,0x14
    800022fc:	7084b483          	ld	s1,1800(s1) # 80016a00 <bcache+0x82b8>
    80002300:	00014797          	auipc	a5,0x14
    80002304:	6b078793          	addi	a5,a5,1712 # 800169b0 <bcache+0x8268>
    80002308:	02f48f63          	beq	s1,a5,80002346 <bread+0x70>
    8000230c:	873e                	mv	a4,a5
    8000230e:	a021                	j	80002316 <bread+0x40>
    80002310:	68a4                	ld	s1,80(s1)
    80002312:	02e48a63          	beq	s1,a4,80002346 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002316:	449c                	lw	a5,8(s1)
    80002318:	ff279ce3          	bne	a5,s2,80002310 <bread+0x3a>
    8000231c:	44dc                	lw	a5,12(s1)
    8000231e:	ff3799e3          	bne	a5,s3,80002310 <bread+0x3a>
      b->refcnt++;
    80002322:	40bc                	lw	a5,64(s1)
    80002324:	2785                	addiw	a5,a5,1
    80002326:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002328:	0000c517          	auipc	a0,0xc
    8000232c:	42050513          	addi	a0,a0,1056 # 8000e748 <bcache>
    80002330:	00004097          	auipc	ra,0x4
    80002334:	ec8080e7          	jalr	-312(ra) # 800061f8 <release>
      acquiresleep(&b->lock);
    80002338:	01048513          	addi	a0,s1,16
    8000233c:	00001097          	auipc	ra,0x1
    80002340:	472080e7          	jalr	1138(ra) # 800037ae <acquiresleep>
      return b;
    80002344:	a8b9                	j	800023a2 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002346:	00014497          	auipc	s1,0x14
    8000234a:	6b24b483          	ld	s1,1714(s1) # 800169f8 <bcache+0x82b0>
    8000234e:	00014797          	auipc	a5,0x14
    80002352:	66278793          	addi	a5,a5,1634 # 800169b0 <bcache+0x8268>
    80002356:	00f48863          	beq	s1,a5,80002366 <bread+0x90>
    8000235a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000235c:	40bc                	lw	a5,64(s1)
    8000235e:	cf81                	beqz	a5,80002376 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002360:	64a4                	ld	s1,72(s1)
    80002362:	fee49de3          	bne	s1,a4,8000235c <bread+0x86>
  panic("bget: no buffers");
    80002366:	00006517          	auipc	a0,0x6
    8000236a:	12a50513          	addi	a0,a0,298 # 80008490 <syscalls+0xd0>
    8000236e:	00004097          	auipc	ra,0x4
    80002372:	89e080e7          	jalr	-1890(ra) # 80005c0c <panic>
      b->dev = dev;
    80002376:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000237a:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000237e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002382:	4785                	li	a5,1
    80002384:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002386:	0000c517          	auipc	a0,0xc
    8000238a:	3c250513          	addi	a0,a0,962 # 8000e748 <bcache>
    8000238e:	00004097          	auipc	ra,0x4
    80002392:	e6a080e7          	jalr	-406(ra) # 800061f8 <release>
      acquiresleep(&b->lock);
    80002396:	01048513          	addi	a0,s1,16
    8000239a:	00001097          	auipc	ra,0x1
    8000239e:	414080e7          	jalr	1044(ra) # 800037ae <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800023a2:	409c                	lw	a5,0(s1)
    800023a4:	cb89                	beqz	a5,800023b6 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800023a6:	8526                	mv	a0,s1
    800023a8:	70a2                	ld	ra,40(sp)
    800023aa:	7402                	ld	s0,32(sp)
    800023ac:	64e2                	ld	s1,24(sp)
    800023ae:	6942                	ld	s2,16(sp)
    800023b0:	69a2                	ld	s3,8(sp)
    800023b2:	6145                	addi	sp,sp,48
    800023b4:	8082                	ret
    virtio_disk_rw(b, 0);
    800023b6:	4581                	li	a1,0
    800023b8:	8526                	mv	a0,s1
    800023ba:	00003097          	auipc	ra,0x3
    800023be:	048080e7          	jalr	72(ra) # 80005402 <virtio_disk_rw>
    b->valid = 1;
    800023c2:	4785                	li	a5,1
    800023c4:	c09c                	sw	a5,0(s1)
  return b;
    800023c6:	b7c5                	j	800023a6 <bread+0xd0>

00000000800023c8 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023c8:	1101                	addi	sp,sp,-32
    800023ca:	ec06                	sd	ra,24(sp)
    800023cc:	e822                	sd	s0,16(sp)
    800023ce:	e426                	sd	s1,8(sp)
    800023d0:	1000                	addi	s0,sp,32
    800023d2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023d4:	0541                	addi	a0,a0,16
    800023d6:	00001097          	auipc	ra,0x1
    800023da:	472080e7          	jalr	1138(ra) # 80003848 <holdingsleep>
    800023de:	cd01                	beqz	a0,800023f6 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023e0:	4585                	li	a1,1
    800023e2:	8526                	mv	a0,s1
    800023e4:	00003097          	auipc	ra,0x3
    800023e8:	01e080e7          	jalr	30(ra) # 80005402 <virtio_disk_rw>
}
    800023ec:	60e2                	ld	ra,24(sp)
    800023ee:	6442                	ld	s0,16(sp)
    800023f0:	64a2                	ld	s1,8(sp)
    800023f2:	6105                	addi	sp,sp,32
    800023f4:	8082                	ret
    panic("bwrite");
    800023f6:	00006517          	auipc	a0,0x6
    800023fa:	0b250513          	addi	a0,a0,178 # 800084a8 <syscalls+0xe8>
    800023fe:	00004097          	auipc	ra,0x4
    80002402:	80e080e7          	jalr	-2034(ra) # 80005c0c <panic>

0000000080002406 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002406:	1101                	addi	sp,sp,-32
    80002408:	ec06                	sd	ra,24(sp)
    8000240a:	e822                	sd	s0,16(sp)
    8000240c:	e426                	sd	s1,8(sp)
    8000240e:	e04a                	sd	s2,0(sp)
    80002410:	1000                	addi	s0,sp,32
    80002412:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002414:	01050913          	addi	s2,a0,16
    80002418:	854a                	mv	a0,s2
    8000241a:	00001097          	auipc	ra,0x1
    8000241e:	42e080e7          	jalr	1070(ra) # 80003848 <holdingsleep>
    80002422:	c92d                	beqz	a0,80002494 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002424:	854a                	mv	a0,s2
    80002426:	00001097          	auipc	ra,0x1
    8000242a:	3de080e7          	jalr	990(ra) # 80003804 <releasesleep>

  acquire(&bcache.lock);
    8000242e:	0000c517          	auipc	a0,0xc
    80002432:	31a50513          	addi	a0,a0,794 # 8000e748 <bcache>
    80002436:	00004097          	auipc	ra,0x4
    8000243a:	d0e080e7          	jalr	-754(ra) # 80006144 <acquire>
  b->refcnt--;
    8000243e:	40bc                	lw	a5,64(s1)
    80002440:	37fd                	addiw	a5,a5,-1
    80002442:	0007871b          	sext.w	a4,a5
    80002446:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002448:	eb05                	bnez	a4,80002478 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000244a:	68bc                	ld	a5,80(s1)
    8000244c:	64b8                	ld	a4,72(s1)
    8000244e:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002450:	64bc                	ld	a5,72(s1)
    80002452:	68b8                	ld	a4,80(s1)
    80002454:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002456:	00014797          	auipc	a5,0x14
    8000245a:	2f278793          	addi	a5,a5,754 # 80016748 <bcache+0x8000>
    8000245e:	2b87b703          	ld	a4,696(a5)
    80002462:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002464:	00014717          	auipc	a4,0x14
    80002468:	54c70713          	addi	a4,a4,1356 # 800169b0 <bcache+0x8268>
    8000246c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000246e:	2b87b703          	ld	a4,696(a5)
    80002472:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002474:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002478:	0000c517          	auipc	a0,0xc
    8000247c:	2d050513          	addi	a0,a0,720 # 8000e748 <bcache>
    80002480:	00004097          	auipc	ra,0x4
    80002484:	d78080e7          	jalr	-648(ra) # 800061f8 <release>
}
    80002488:	60e2                	ld	ra,24(sp)
    8000248a:	6442                	ld	s0,16(sp)
    8000248c:	64a2                	ld	s1,8(sp)
    8000248e:	6902                	ld	s2,0(sp)
    80002490:	6105                	addi	sp,sp,32
    80002492:	8082                	ret
    panic("brelse");
    80002494:	00006517          	auipc	a0,0x6
    80002498:	01c50513          	addi	a0,a0,28 # 800084b0 <syscalls+0xf0>
    8000249c:	00003097          	auipc	ra,0x3
    800024a0:	770080e7          	jalr	1904(ra) # 80005c0c <panic>

00000000800024a4 <bpin>:

void
bpin(struct buf *b) {
    800024a4:	1101                	addi	sp,sp,-32
    800024a6:	ec06                	sd	ra,24(sp)
    800024a8:	e822                	sd	s0,16(sp)
    800024aa:	e426                	sd	s1,8(sp)
    800024ac:	1000                	addi	s0,sp,32
    800024ae:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024b0:	0000c517          	auipc	a0,0xc
    800024b4:	29850513          	addi	a0,a0,664 # 8000e748 <bcache>
    800024b8:	00004097          	auipc	ra,0x4
    800024bc:	c8c080e7          	jalr	-884(ra) # 80006144 <acquire>
  b->refcnt++;
    800024c0:	40bc                	lw	a5,64(s1)
    800024c2:	2785                	addiw	a5,a5,1
    800024c4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024c6:	0000c517          	auipc	a0,0xc
    800024ca:	28250513          	addi	a0,a0,642 # 8000e748 <bcache>
    800024ce:	00004097          	auipc	ra,0x4
    800024d2:	d2a080e7          	jalr	-726(ra) # 800061f8 <release>
}
    800024d6:	60e2                	ld	ra,24(sp)
    800024d8:	6442                	ld	s0,16(sp)
    800024da:	64a2                	ld	s1,8(sp)
    800024dc:	6105                	addi	sp,sp,32
    800024de:	8082                	ret

00000000800024e0 <bunpin>:

void
bunpin(struct buf *b) {
    800024e0:	1101                	addi	sp,sp,-32
    800024e2:	ec06                	sd	ra,24(sp)
    800024e4:	e822                	sd	s0,16(sp)
    800024e6:	e426                	sd	s1,8(sp)
    800024e8:	1000                	addi	s0,sp,32
    800024ea:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024ec:	0000c517          	auipc	a0,0xc
    800024f0:	25c50513          	addi	a0,a0,604 # 8000e748 <bcache>
    800024f4:	00004097          	auipc	ra,0x4
    800024f8:	c50080e7          	jalr	-944(ra) # 80006144 <acquire>
  b->refcnt--;
    800024fc:	40bc                	lw	a5,64(s1)
    800024fe:	37fd                	addiw	a5,a5,-1
    80002500:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002502:	0000c517          	auipc	a0,0xc
    80002506:	24650513          	addi	a0,a0,582 # 8000e748 <bcache>
    8000250a:	00004097          	auipc	ra,0x4
    8000250e:	cee080e7          	jalr	-786(ra) # 800061f8 <release>
}
    80002512:	60e2                	ld	ra,24(sp)
    80002514:	6442                	ld	s0,16(sp)
    80002516:	64a2                	ld	s1,8(sp)
    80002518:	6105                	addi	sp,sp,32
    8000251a:	8082                	ret

000000008000251c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000251c:	1101                	addi	sp,sp,-32
    8000251e:	ec06                	sd	ra,24(sp)
    80002520:	e822                	sd	s0,16(sp)
    80002522:	e426                	sd	s1,8(sp)
    80002524:	e04a                	sd	s2,0(sp)
    80002526:	1000                	addi	s0,sp,32
    80002528:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000252a:	00d5d59b          	srliw	a1,a1,0xd
    8000252e:	00015797          	auipc	a5,0x15
    80002532:	8f67a783          	lw	a5,-1802(a5) # 80016e24 <sb+0x1c>
    80002536:	9dbd                	addw	a1,a1,a5
    80002538:	00000097          	auipc	ra,0x0
    8000253c:	d9e080e7          	jalr	-610(ra) # 800022d6 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002540:	0074f713          	andi	a4,s1,7
    80002544:	4785                	li	a5,1
    80002546:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000254a:	14ce                	slli	s1,s1,0x33
    8000254c:	90d9                	srli	s1,s1,0x36
    8000254e:	00950733          	add	a4,a0,s1
    80002552:	05874703          	lbu	a4,88(a4)
    80002556:	00e7f6b3          	and	a3,a5,a4
    8000255a:	c69d                	beqz	a3,80002588 <bfree+0x6c>
    8000255c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000255e:	94aa                	add	s1,s1,a0
    80002560:	fff7c793          	not	a5,a5
    80002564:	8f7d                	and	a4,a4,a5
    80002566:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000256a:	00001097          	auipc	ra,0x1
    8000256e:	126080e7          	jalr	294(ra) # 80003690 <log_write>
  brelse(bp);
    80002572:	854a                	mv	a0,s2
    80002574:	00000097          	auipc	ra,0x0
    80002578:	e92080e7          	jalr	-366(ra) # 80002406 <brelse>
}
    8000257c:	60e2                	ld	ra,24(sp)
    8000257e:	6442                	ld	s0,16(sp)
    80002580:	64a2                	ld	s1,8(sp)
    80002582:	6902                	ld	s2,0(sp)
    80002584:	6105                	addi	sp,sp,32
    80002586:	8082                	ret
    panic("freeing free block");
    80002588:	00006517          	auipc	a0,0x6
    8000258c:	f3050513          	addi	a0,a0,-208 # 800084b8 <syscalls+0xf8>
    80002590:	00003097          	auipc	ra,0x3
    80002594:	67c080e7          	jalr	1660(ra) # 80005c0c <panic>

0000000080002598 <balloc>:
{
    80002598:	711d                	addi	sp,sp,-96
    8000259a:	ec86                	sd	ra,88(sp)
    8000259c:	e8a2                	sd	s0,80(sp)
    8000259e:	e4a6                	sd	s1,72(sp)
    800025a0:	e0ca                	sd	s2,64(sp)
    800025a2:	fc4e                	sd	s3,56(sp)
    800025a4:	f852                	sd	s4,48(sp)
    800025a6:	f456                	sd	s5,40(sp)
    800025a8:	f05a                	sd	s6,32(sp)
    800025aa:	ec5e                	sd	s7,24(sp)
    800025ac:	e862                	sd	s8,16(sp)
    800025ae:	e466                	sd	s9,8(sp)
    800025b0:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800025b2:	00015797          	auipc	a5,0x15
    800025b6:	85a7a783          	lw	a5,-1958(a5) # 80016e0c <sb+0x4>
    800025ba:	cff5                	beqz	a5,800026b6 <balloc+0x11e>
    800025bc:	8baa                	mv	s7,a0
    800025be:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800025c0:	00015b17          	auipc	s6,0x15
    800025c4:	848b0b13          	addi	s6,s6,-1976 # 80016e08 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025c8:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025ca:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025cc:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025ce:	6c89                	lui	s9,0x2
    800025d0:	a061                	j	80002658 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    800025d2:	97ca                	add	a5,a5,s2
    800025d4:	8e55                	or	a2,a2,a3
    800025d6:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800025da:	854a                	mv	a0,s2
    800025dc:	00001097          	auipc	ra,0x1
    800025e0:	0b4080e7          	jalr	180(ra) # 80003690 <log_write>
        brelse(bp);
    800025e4:	854a                	mv	a0,s2
    800025e6:	00000097          	auipc	ra,0x0
    800025ea:	e20080e7          	jalr	-480(ra) # 80002406 <brelse>
  bp = bread(dev, bno);
    800025ee:	85a6                	mv	a1,s1
    800025f0:	855e                	mv	a0,s7
    800025f2:	00000097          	auipc	ra,0x0
    800025f6:	ce4080e7          	jalr	-796(ra) # 800022d6 <bread>
    800025fa:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800025fc:	40000613          	li	a2,1024
    80002600:	4581                	li	a1,0
    80002602:	05850513          	addi	a0,a0,88
    80002606:	ffffe097          	auipc	ra,0xffffe
    8000260a:	b74080e7          	jalr	-1164(ra) # 8000017a <memset>
  log_write(bp);
    8000260e:	854a                	mv	a0,s2
    80002610:	00001097          	auipc	ra,0x1
    80002614:	080080e7          	jalr	128(ra) # 80003690 <log_write>
  brelse(bp);
    80002618:	854a                	mv	a0,s2
    8000261a:	00000097          	auipc	ra,0x0
    8000261e:	dec080e7          	jalr	-532(ra) # 80002406 <brelse>
}
    80002622:	8526                	mv	a0,s1
    80002624:	60e6                	ld	ra,88(sp)
    80002626:	6446                	ld	s0,80(sp)
    80002628:	64a6                	ld	s1,72(sp)
    8000262a:	6906                	ld	s2,64(sp)
    8000262c:	79e2                	ld	s3,56(sp)
    8000262e:	7a42                	ld	s4,48(sp)
    80002630:	7aa2                	ld	s5,40(sp)
    80002632:	7b02                	ld	s6,32(sp)
    80002634:	6be2                	ld	s7,24(sp)
    80002636:	6c42                	ld	s8,16(sp)
    80002638:	6ca2                	ld	s9,8(sp)
    8000263a:	6125                	addi	sp,sp,96
    8000263c:	8082                	ret
    brelse(bp);
    8000263e:	854a                	mv	a0,s2
    80002640:	00000097          	auipc	ra,0x0
    80002644:	dc6080e7          	jalr	-570(ra) # 80002406 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002648:	015c87bb          	addw	a5,s9,s5
    8000264c:	00078a9b          	sext.w	s5,a5
    80002650:	004b2703          	lw	a4,4(s6)
    80002654:	06eaf163          	bgeu	s5,a4,800026b6 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80002658:	41fad79b          	sraiw	a5,s5,0x1f
    8000265c:	0137d79b          	srliw	a5,a5,0x13
    80002660:	015787bb          	addw	a5,a5,s5
    80002664:	40d7d79b          	sraiw	a5,a5,0xd
    80002668:	01cb2583          	lw	a1,28(s6)
    8000266c:	9dbd                	addw	a1,a1,a5
    8000266e:	855e                	mv	a0,s7
    80002670:	00000097          	auipc	ra,0x0
    80002674:	c66080e7          	jalr	-922(ra) # 800022d6 <bread>
    80002678:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000267a:	004b2503          	lw	a0,4(s6)
    8000267e:	000a849b          	sext.w	s1,s5
    80002682:	8762                	mv	a4,s8
    80002684:	faa4fde3          	bgeu	s1,a0,8000263e <balloc+0xa6>
      m = 1 << (bi % 8);
    80002688:	00777693          	andi	a3,a4,7
    8000268c:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002690:	41f7579b          	sraiw	a5,a4,0x1f
    80002694:	01d7d79b          	srliw	a5,a5,0x1d
    80002698:	9fb9                	addw	a5,a5,a4
    8000269a:	4037d79b          	sraiw	a5,a5,0x3
    8000269e:	00f90633          	add	a2,s2,a5
    800026a2:	05864603          	lbu	a2,88(a2)
    800026a6:	00c6f5b3          	and	a1,a3,a2
    800026aa:	d585                	beqz	a1,800025d2 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026ac:	2705                	addiw	a4,a4,1
    800026ae:	2485                	addiw	s1,s1,1
    800026b0:	fd471ae3          	bne	a4,s4,80002684 <balloc+0xec>
    800026b4:	b769                	j	8000263e <balloc+0xa6>
  printf("balloc: out of blocks\n");
    800026b6:	00006517          	auipc	a0,0x6
    800026ba:	e1a50513          	addi	a0,a0,-486 # 800084d0 <syscalls+0x110>
    800026be:	00003097          	auipc	ra,0x3
    800026c2:	598080e7          	jalr	1432(ra) # 80005c56 <printf>
  return 0;
    800026c6:	4481                	li	s1,0
    800026c8:	bfa9                	j	80002622 <balloc+0x8a>

00000000800026ca <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800026ca:	7179                	addi	sp,sp,-48
    800026cc:	f406                	sd	ra,40(sp)
    800026ce:	f022                	sd	s0,32(sp)
    800026d0:	ec26                	sd	s1,24(sp)
    800026d2:	e84a                	sd	s2,16(sp)
    800026d4:	e44e                	sd	s3,8(sp)
    800026d6:	e052                	sd	s4,0(sp)
    800026d8:	1800                	addi	s0,sp,48
    800026da:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026dc:	47ad                	li	a5,11
    800026de:	02b7e863          	bltu	a5,a1,8000270e <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    800026e2:	02059793          	slli	a5,a1,0x20
    800026e6:	01e7d593          	srli	a1,a5,0x1e
    800026ea:	00b504b3          	add	s1,a0,a1
    800026ee:	0504a903          	lw	s2,80(s1)
    800026f2:	06091e63          	bnez	s2,8000276e <bmap+0xa4>
      addr = balloc(ip->dev);
    800026f6:	4108                	lw	a0,0(a0)
    800026f8:	00000097          	auipc	ra,0x0
    800026fc:	ea0080e7          	jalr	-352(ra) # 80002598 <balloc>
    80002700:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002704:	06090563          	beqz	s2,8000276e <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80002708:	0524a823          	sw	s2,80(s1)
    8000270c:	a08d                	j	8000276e <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000270e:	ff45849b          	addiw	s1,a1,-12
    80002712:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002716:	0ff00793          	li	a5,255
    8000271a:	08e7e563          	bltu	a5,a4,800027a4 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000271e:	08052903          	lw	s2,128(a0)
    80002722:	00091d63          	bnez	s2,8000273c <bmap+0x72>
      addr = balloc(ip->dev);
    80002726:	4108                	lw	a0,0(a0)
    80002728:	00000097          	auipc	ra,0x0
    8000272c:	e70080e7          	jalr	-400(ra) # 80002598 <balloc>
    80002730:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002734:	02090d63          	beqz	s2,8000276e <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002738:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000273c:	85ca                	mv	a1,s2
    8000273e:	0009a503          	lw	a0,0(s3)
    80002742:	00000097          	auipc	ra,0x0
    80002746:	b94080e7          	jalr	-1132(ra) # 800022d6 <bread>
    8000274a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000274c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002750:	02049713          	slli	a4,s1,0x20
    80002754:	01e75593          	srli	a1,a4,0x1e
    80002758:	00b784b3          	add	s1,a5,a1
    8000275c:	0004a903          	lw	s2,0(s1)
    80002760:	02090063          	beqz	s2,80002780 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002764:	8552                	mv	a0,s4
    80002766:	00000097          	auipc	ra,0x0
    8000276a:	ca0080e7          	jalr	-864(ra) # 80002406 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000276e:	854a                	mv	a0,s2
    80002770:	70a2                	ld	ra,40(sp)
    80002772:	7402                	ld	s0,32(sp)
    80002774:	64e2                	ld	s1,24(sp)
    80002776:	6942                	ld	s2,16(sp)
    80002778:	69a2                	ld	s3,8(sp)
    8000277a:	6a02                	ld	s4,0(sp)
    8000277c:	6145                	addi	sp,sp,48
    8000277e:	8082                	ret
      addr = balloc(ip->dev);
    80002780:	0009a503          	lw	a0,0(s3)
    80002784:	00000097          	auipc	ra,0x0
    80002788:	e14080e7          	jalr	-492(ra) # 80002598 <balloc>
    8000278c:	0005091b          	sext.w	s2,a0
      if(addr){
    80002790:	fc090ae3          	beqz	s2,80002764 <bmap+0x9a>
        a[bn] = addr;
    80002794:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002798:	8552                	mv	a0,s4
    8000279a:	00001097          	auipc	ra,0x1
    8000279e:	ef6080e7          	jalr	-266(ra) # 80003690 <log_write>
    800027a2:	b7c9                	j	80002764 <bmap+0x9a>
  panic("bmap: out of range");
    800027a4:	00006517          	auipc	a0,0x6
    800027a8:	d4450513          	addi	a0,a0,-700 # 800084e8 <syscalls+0x128>
    800027ac:	00003097          	auipc	ra,0x3
    800027b0:	460080e7          	jalr	1120(ra) # 80005c0c <panic>

00000000800027b4 <iget>:
{
    800027b4:	7179                	addi	sp,sp,-48
    800027b6:	f406                	sd	ra,40(sp)
    800027b8:	f022                	sd	s0,32(sp)
    800027ba:	ec26                	sd	s1,24(sp)
    800027bc:	e84a                	sd	s2,16(sp)
    800027be:	e44e                	sd	s3,8(sp)
    800027c0:	e052                	sd	s4,0(sp)
    800027c2:	1800                	addi	s0,sp,48
    800027c4:	89aa                	mv	s3,a0
    800027c6:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800027c8:	00014517          	auipc	a0,0x14
    800027cc:	66050513          	addi	a0,a0,1632 # 80016e28 <itable>
    800027d0:	00004097          	auipc	ra,0x4
    800027d4:	974080e7          	jalr	-1676(ra) # 80006144 <acquire>
  empty = 0;
    800027d8:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027da:	00014497          	auipc	s1,0x14
    800027de:	66648493          	addi	s1,s1,1638 # 80016e40 <itable+0x18>
    800027e2:	00016697          	auipc	a3,0x16
    800027e6:	0ee68693          	addi	a3,a3,238 # 800188d0 <log>
    800027ea:	a039                	j	800027f8 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027ec:	02090b63          	beqz	s2,80002822 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027f0:	08848493          	addi	s1,s1,136
    800027f4:	02d48a63          	beq	s1,a3,80002828 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800027f8:	449c                	lw	a5,8(s1)
    800027fa:	fef059e3          	blez	a5,800027ec <iget+0x38>
    800027fe:	4098                	lw	a4,0(s1)
    80002800:	ff3716e3          	bne	a4,s3,800027ec <iget+0x38>
    80002804:	40d8                	lw	a4,4(s1)
    80002806:	ff4713e3          	bne	a4,s4,800027ec <iget+0x38>
      ip->ref++;
    8000280a:	2785                	addiw	a5,a5,1
    8000280c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000280e:	00014517          	auipc	a0,0x14
    80002812:	61a50513          	addi	a0,a0,1562 # 80016e28 <itable>
    80002816:	00004097          	auipc	ra,0x4
    8000281a:	9e2080e7          	jalr	-1566(ra) # 800061f8 <release>
      return ip;
    8000281e:	8926                	mv	s2,s1
    80002820:	a03d                	j	8000284e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002822:	f7f9                	bnez	a5,800027f0 <iget+0x3c>
    80002824:	8926                	mv	s2,s1
    80002826:	b7e9                	j	800027f0 <iget+0x3c>
  if(empty == 0)
    80002828:	02090c63          	beqz	s2,80002860 <iget+0xac>
  ip->dev = dev;
    8000282c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002830:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002834:	4785                	li	a5,1
    80002836:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000283a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000283e:	00014517          	auipc	a0,0x14
    80002842:	5ea50513          	addi	a0,a0,1514 # 80016e28 <itable>
    80002846:	00004097          	auipc	ra,0x4
    8000284a:	9b2080e7          	jalr	-1614(ra) # 800061f8 <release>
}
    8000284e:	854a                	mv	a0,s2
    80002850:	70a2                	ld	ra,40(sp)
    80002852:	7402                	ld	s0,32(sp)
    80002854:	64e2                	ld	s1,24(sp)
    80002856:	6942                	ld	s2,16(sp)
    80002858:	69a2                	ld	s3,8(sp)
    8000285a:	6a02                	ld	s4,0(sp)
    8000285c:	6145                	addi	sp,sp,48
    8000285e:	8082                	ret
    panic("iget: no inodes");
    80002860:	00006517          	auipc	a0,0x6
    80002864:	ca050513          	addi	a0,a0,-864 # 80008500 <syscalls+0x140>
    80002868:	00003097          	auipc	ra,0x3
    8000286c:	3a4080e7          	jalr	932(ra) # 80005c0c <panic>

0000000080002870 <fsinit>:
fsinit(int dev) {
    80002870:	7179                	addi	sp,sp,-48
    80002872:	f406                	sd	ra,40(sp)
    80002874:	f022                	sd	s0,32(sp)
    80002876:	ec26                	sd	s1,24(sp)
    80002878:	e84a                	sd	s2,16(sp)
    8000287a:	e44e                	sd	s3,8(sp)
    8000287c:	1800                	addi	s0,sp,48
    8000287e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002880:	4585                	li	a1,1
    80002882:	00000097          	auipc	ra,0x0
    80002886:	a54080e7          	jalr	-1452(ra) # 800022d6 <bread>
    8000288a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000288c:	00014997          	auipc	s3,0x14
    80002890:	57c98993          	addi	s3,s3,1404 # 80016e08 <sb>
    80002894:	02000613          	li	a2,32
    80002898:	05850593          	addi	a1,a0,88
    8000289c:	854e                	mv	a0,s3
    8000289e:	ffffe097          	auipc	ra,0xffffe
    800028a2:	938080e7          	jalr	-1736(ra) # 800001d6 <memmove>
  brelse(bp);
    800028a6:	8526                	mv	a0,s1
    800028a8:	00000097          	auipc	ra,0x0
    800028ac:	b5e080e7          	jalr	-1186(ra) # 80002406 <brelse>
  if(sb.magic != FSMAGIC)
    800028b0:	0009a703          	lw	a4,0(s3)
    800028b4:	102037b7          	lui	a5,0x10203
    800028b8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028bc:	02f71263          	bne	a4,a5,800028e0 <fsinit+0x70>
  initlog(dev, &sb);
    800028c0:	00014597          	auipc	a1,0x14
    800028c4:	54858593          	addi	a1,a1,1352 # 80016e08 <sb>
    800028c8:	854a                	mv	a0,s2
    800028ca:	00001097          	auipc	ra,0x1
    800028ce:	b4a080e7          	jalr	-1206(ra) # 80003414 <initlog>
}
    800028d2:	70a2                	ld	ra,40(sp)
    800028d4:	7402                	ld	s0,32(sp)
    800028d6:	64e2                	ld	s1,24(sp)
    800028d8:	6942                	ld	s2,16(sp)
    800028da:	69a2                	ld	s3,8(sp)
    800028dc:	6145                	addi	sp,sp,48
    800028de:	8082                	ret
    panic("invalid file system");
    800028e0:	00006517          	auipc	a0,0x6
    800028e4:	c3050513          	addi	a0,a0,-976 # 80008510 <syscalls+0x150>
    800028e8:	00003097          	auipc	ra,0x3
    800028ec:	324080e7          	jalr	804(ra) # 80005c0c <panic>

00000000800028f0 <iinit>:
{
    800028f0:	7179                	addi	sp,sp,-48
    800028f2:	f406                	sd	ra,40(sp)
    800028f4:	f022                	sd	s0,32(sp)
    800028f6:	ec26                	sd	s1,24(sp)
    800028f8:	e84a                	sd	s2,16(sp)
    800028fa:	e44e                	sd	s3,8(sp)
    800028fc:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800028fe:	00006597          	auipc	a1,0x6
    80002902:	c2a58593          	addi	a1,a1,-982 # 80008528 <syscalls+0x168>
    80002906:	00014517          	auipc	a0,0x14
    8000290a:	52250513          	addi	a0,a0,1314 # 80016e28 <itable>
    8000290e:	00003097          	auipc	ra,0x3
    80002912:	7a6080e7          	jalr	1958(ra) # 800060b4 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002916:	00014497          	auipc	s1,0x14
    8000291a:	53a48493          	addi	s1,s1,1338 # 80016e50 <itable+0x28>
    8000291e:	00016997          	auipc	s3,0x16
    80002922:	fc298993          	addi	s3,s3,-62 # 800188e0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002926:	00006917          	auipc	s2,0x6
    8000292a:	c0a90913          	addi	s2,s2,-1014 # 80008530 <syscalls+0x170>
    8000292e:	85ca                	mv	a1,s2
    80002930:	8526                	mv	a0,s1
    80002932:	00001097          	auipc	ra,0x1
    80002936:	e42080e7          	jalr	-446(ra) # 80003774 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000293a:	08848493          	addi	s1,s1,136
    8000293e:	ff3498e3          	bne	s1,s3,8000292e <iinit+0x3e>
}
    80002942:	70a2                	ld	ra,40(sp)
    80002944:	7402                	ld	s0,32(sp)
    80002946:	64e2                	ld	s1,24(sp)
    80002948:	6942                	ld	s2,16(sp)
    8000294a:	69a2                	ld	s3,8(sp)
    8000294c:	6145                	addi	sp,sp,48
    8000294e:	8082                	ret

0000000080002950 <ialloc>:
{
    80002950:	715d                	addi	sp,sp,-80
    80002952:	e486                	sd	ra,72(sp)
    80002954:	e0a2                	sd	s0,64(sp)
    80002956:	fc26                	sd	s1,56(sp)
    80002958:	f84a                	sd	s2,48(sp)
    8000295a:	f44e                	sd	s3,40(sp)
    8000295c:	f052                	sd	s4,32(sp)
    8000295e:	ec56                	sd	s5,24(sp)
    80002960:	e85a                	sd	s6,16(sp)
    80002962:	e45e                	sd	s7,8(sp)
    80002964:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002966:	00014717          	auipc	a4,0x14
    8000296a:	4ae72703          	lw	a4,1198(a4) # 80016e14 <sb+0xc>
    8000296e:	4785                	li	a5,1
    80002970:	04e7fa63          	bgeu	a5,a4,800029c4 <ialloc+0x74>
    80002974:	8aaa                	mv	s5,a0
    80002976:	8bae                	mv	s7,a1
    80002978:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000297a:	00014a17          	auipc	s4,0x14
    8000297e:	48ea0a13          	addi	s4,s4,1166 # 80016e08 <sb>
    80002982:	00048b1b          	sext.w	s6,s1
    80002986:	0044d593          	srli	a1,s1,0x4
    8000298a:	018a2783          	lw	a5,24(s4)
    8000298e:	9dbd                	addw	a1,a1,a5
    80002990:	8556                	mv	a0,s5
    80002992:	00000097          	auipc	ra,0x0
    80002996:	944080e7          	jalr	-1724(ra) # 800022d6 <bread>
    8000299a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000299c:	05850993          	addi	s3,a0,88
    800029a0:	00f4f793          	andi	a5,s1,15
    800029a4:	079a                	slli	a5,a5,0x6
    800029a6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800029a8:	00099783          	lh	a5,0(s3)
    800029ac:	c3a1                	beqz	a5,800029ec <ialloc+0x9c>
    brelse(bp);
    800029ae:	00000097          	auipc	ra,0x0
    800029b2:	a58080e7          	jalr	-1448(ra) # 80002406 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800029b6:	0485                	addi	s1,s1,1
    800029b8:	00ca2703          	lw	a4,12(s4)
    800029bc:	0004879b          	sext.w	a5,s1
    800029c0:	fce7e1e3          	bltu	a5,a4,80002982 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    800029c4:	00006517          	auipc	a0,0x6
    800029c8:	b7450513          	addi	a0,a0,-1164 # 80008538 <syscalls+0x178>
    800029cc:	00003097          	auipc	ra,0x3
    800029d0:	28a080e7          	jalr	650(ra) # 80005c56 <printf>
  return 0;
    800029d4:	4501                	li	a0,0
}
    800029d6:	60a6                	ld	ra,72(sp)
    800029d8:	6406                	ld	s0,64(sp)
    800029da:	74e2                	ld	s1,56(sp)
    800029dc:	7942                	ld	s2,48(sp)
    800029de:	79a2                	ld	s3,40(sp)
    800029e0:	7a02                	ld	s4,32(sp)
    800029e2:	6ae2                	ld	s5,24(sp)
    800029e4:	6b42                	ld	s6,16(sp)
    800029e6:	6ba2                	ld	s7,8(sp)
    800029e8:	6161                	addi	sp,sp,80
    800029ea:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800029ec:	04000613          	li	a2,64
    800029f0:	4581                	li	a1,0
    800029f2:	854e                	mv	a0,s3
    800029f4:	ffffd097          	auipc	ra,0xffffd
    800029f8:	786080e7          	jalr	1926(ra) # 8000017a <memset>
      dip->type = type;
    800029fc:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a00:	854a                	mv	a0,s2
    80002a02:	00001097          	auipc	ra,0x1
    80002a06:	c8e080e7          	jalr	-882(ra) # 80003690 <log_write>
      brelse(bp);
    80002a0a:	854a                	mv	a0,s2
    80002a0c:	00000097          	auipc	ra,0x0
    80002a10:	9fa080e7          	jalr	-1542(ra) # 80002406 <brelse>
      return iget(dev, inum);
    80002a14:	85da                	mv	a1,s6
    80002a16:	8556                	mv	a0,s5
    80002a18:	00000097          	auipc	ra,0x0
    80002a1c:	d9c080e7          	jalr	-612(ra) # 800027b4 <iget>
    80002a20:	bf5d                	j	800029d6 <ialloc+0x86>

0000000080002a22 <iupdate>:
{
    80002a22:	1101                	addi	sp,sp,-32
    80002a24:	ec06                	sd	ra,24(sp)
    80002a26:	e822                	sd	s0,16(sp)
    80002a28:	e426                	sd	s1,8(sp)
    80002a2a:	e04a                	sd	s2,0(sp)
    80002a2c:	1000                	addi	s0,sp,32
    80002a2e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a30:	415c                	lw	a5,4(a0)
    80002a32:	0047d79b          	srliw	a5,a5,0x4
    80002a36:	00014597          	auipc	a1,0x14
    80002a3a:	3ea5a583          	lw	a1,1002(a1) # 80016e20 <sb+0x18>
    80002a3e:	9dbd                	addw	a1,a1,a5
    80002a40:	4108                	lw	a0,0(a0)
    80002a42:	00000097          	auipc	ra,0x0
    80002a46:	894080e7          	jalr	-1900(ra) # 800022d6 <bread>
    80002a4a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a4c:	05850793          	addi	a5,a0,88
    80002a50:	40d8                	lw	a4,4(s1)
    80002a52:	8b3d                	andi	a4,a4,15
    80002a54:	071a                	slli	a4,a4,0x6
    80002a56:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002a58:	04449703          	lh	a4,68(s1)
    80002a5c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002a60:	04649703          	lh	a4,70(s1)
    80002a64:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002a68:	04849703          	lh	a4,72(s1)
    80002a6c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002a70:	04a49703          	lh	a4,74(s1)
    80002a74:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002a78:	44f8                	lw	a4,76(s1)
    80002a7a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a7c:	03400613          	li	a2,52
    80002a80:	05048593          	addi	a1,s1,80
    80002a84:	00c78513          	addi	a0,a5,12
    80002a88:	ffffd097          	auipc	ra,0xffffd
    80002a8c:	74e080e7          	jalr	1870(ra) # 800001d6 <memmove>
  log_write(bp);
    80002a90:	854a                	mv	a0,s2
    80002a92:	00001097          	auipc	ra,0x1
    80002a96:	bfe080e7          	jalr	-1026(ra) # 80003690 <log_write>
  brelse(bp);
    80002a9a:	854a                	mv	a0,s2
    80002a9c:	00000097          	auipc	ra,0x0
    80002aa0:	96a080e7          	jalr	-1686(ra) # 80002406 <brelse>
}
    80002aa4:	60e2                	ld	ra,24(sp)
    80002aa6:	6442                	ld	s0,16(sp)
    80002aa8:	64a2                	ld	s1,8(sp)
    80002aaa:	6902                	ld	s2,0(sp)
    80002aac:	6105                	addi	sp,sp,32
    80002aae:	8082                	ret

0000000080002ab0 <idup>:
{
    80002ab0:	1101                	addi	sp,sp,-32
    80002ab2:	ec06                	sd	ra,24(sp)
    80002ab4:	e822                	sd	s0,16(sp)
    80002ab6:	e426                	sd	s1,8(sp)
    80002ab8:	1000                	addi	s0,sp,32
    80002aba:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002abc:	00014517          	auipc	a0,0x14
    80002ac0:	36c50513          	addi	a0,a0,876 # 80016e28 <itable>
    80002ac4:	00003097          	auipc	ra,0x3
    80002ac8:	680080e7          	jalr	1664(ra) # 80006144 <acquire>
  ip->ref++;
    80002acc:	449c                	lw	a5,8(s1)
    80002ace:	2785                	addiw	a5,a5,1
    80002ad0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ad2:	00014517          	auipc	a0,0x14
    80002ad6:	35650513          	addi	a0,a0,854 # 80016e28 <itable>
    80002ada:	00003097          	auipc	ra,0x3
    80002ade:	71e080e7          	jalr	1822(ra) # 800061f8 <release>
}
    80002ae2:	8526                	mv	a0,s1
    80002ae4:	60e2                	ld	ra,24(sp)
    80002ae6:	6442                	ld	s0,16(sp)
    80002ae8:	64a2                	ld	s1,8(sp)
    80002aea:	6105                	addi	sp,sp,32
    80002aec:	8082                	ret

0000000080002aee <ilock>:
{
    80002aee:	1101                	addi	sp,sp,-32
    80002af0:	ec06                	sd	ra,24(sp)
    80002af2:	e822                	sd	s0,16(sp)
    80002af4:	e426                	sd	s1,8(sp)
    80002af6:	e04a                	sd	s2,0(sp)
    80002af8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002afa:	c115                	beqz	a0,80002b1e <ilock+0x30>
    80002afc:	84aa                	mv	s1,a0
    80002afe:	451c                	lw	a5,8(a0)
    80002b00:	00f05f63          	blez	a5,80002b1e <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b04:	0541                	addi	a0,a0,16
    80002b06:	00001097          	auipc	ra,0x1
    80002b0a:	ca8080e7          	jalr	-856(ra) # 800037ae <acquiresleep>
  if(ip->valid == 0){
    80002b0e:	40bc                	lw	a5,64(s1)
    80002b10:	cf99                	beqz	a5,80002b2e <ilock+0x40>
}
    80002b12:	60e2                	ld	ra,24(sp)
    80002b14:	6442                	ld	s0,16(sp)
    80002b16:	64a2                	ld	s1,8(sp)
    80002b18:	6902                	ld	s2,0(sp)
    80002b1a:	6105                	addi	sp,sp,32
    80002b1c:	8082                	ret
    panic("ilock");
    80002b1e:	00006517          	auipc	a0,0x6
    80002b22:	a3250513          	addi	a0,a0,-1486 # 80008550 <syscalls+0x190>
    80002b26:	00003097          	auipc	ra,0x3
    80002b2a:	0e6080e7          	jalr	230(ra) # 80005c0c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b2e:	40dc                	lw	a5,4(s1)
    80002b30:	0047d79b          	srliw	a5,a5,0x4
    80002b34:	00014597          	auipc	a1,0x14
    80002b38:	2ec5a583          	lw	a1,748(a1) # 80016e20 <sb+0x18>
    80002b3c:	9dbd                	addw	a1,a1,a5
    80002b3e:	4088                	lw	a0,0(s1)
    80002b40:	fffff097          	auipc	ra,0xfffff
    80002b44:	796080e7          	jalr	1942(ra) # 800022d6 <bread>
    80002b48:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b4a:	05850593          	addi	a1,a0,88
    80002b4e:	40dc                	lw	a5,4(s1)
    80002b50:	8bbd                	andi	a5,a5,15
    80002b52:	079a                	slli	a5,a5,0x6
    80002b54:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b56:	00059783          	lh	a5,0(a1)
    80002b5a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b5e:	00259783          	lh	a5,2(a1)
    80002b62:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b66:	00459783          	lh	a5,4(a1)
    80002b6a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b6e:	00659783          	lh	a5,6(a1)
    80002b72:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b76:	459c                	lw	a5,8(a1)
    80002b78:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b7a:	03400613          	li	a2,52
    80002b7e:	05b1                	addi	a1,a1,12
    80002b80:	05048513          	addi	a0,s1,80
    80002b84:	ffffd097          	auipc	ra,0xffffd
    80002b88:	652080e7          	jalr	1618(ra) # 800001d6 <memmove>
    brelse(bp);
    80002b8c:	854a                	mv	a0,s2
    80002b8e:	00000097          	auipc	ra,0x0
    80002b92:	878080e7          	jalr	-1928(ra) # 80002406 <brelse>
    ip->valid = 1;
    80002b96:	4785                	li	a5,1
    80002b98:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b9a:	04449783          	lh	a5,68(s1)
    80002b9e:	fbb5                	bnez	a5,80002b12 <ilock+0x24>
      panic("ilock: no type");
    80002ba0:	00006517          	auipc	a0,0x6
    80002ba4:	9b850513          	addi	a0,a0,-1608 # 80008558 <syscalls+0x198>
    80002ba8:	00003097          	auipc	ra,0x3
    80002bac:	064080e7          	jalr	100(ra) # 80005c0c <panic>

0000000080002bb0 <iunlock>:
{
    80002bb0:	1101                	addi	sp,sp,-32
    80002bb2:	ec06                	sd	ra,24(sp)
    80002bb4:	e822                	sd	s0,16(sp)
    80002bb6:	e426                	sd	s1,8(sp)
    80002bb8:	e04a                	sd	s2,0(sp)
    80002bba:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002bbc:	c905                	beqz	a0,80002bec <iunlock+0x3c>
    80002bbe:	84aa                	mv	s1,a0
    80002bc0:	01050913          	addi	s2,a0,16
    80002bc4:	854a                	mv	a0,s2
    80002bc6:	00001097          	auipc	ra,0x1
    80002bca:	c82080e7          	jalr	-894(ra) # 80003848 <holdingsleep>
    80002bce:	cd19                	beqz	a0,80002bec <iunlock+0x3c>
    80002bd0:	449c                	lw	a5,8(s1)
    80002bd2:	00f05d63          	blez	a5,80002bec <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002bd6:	854a                	mv	a0,s2
    80002bd8:	00001097          	auipc	ra,0x1
    80002bdc:	c2c080e7          	jalr	-980(ra) # 80003804 <releasesleep>
}
    80002be0:	60e2                	ld	ra,24(sp)
    80002be2:	6442                	ld	s0,16(sp)
    80002be4:	64a2                	ld	s1,8(sp)
    80002be6:	6902                	ld	s2,0(sp)
    80002be8:	6105                	addi	sp,sp,32
    80002bea:	8082                	ret
    panic("iunlock");
    80002bec:	00006517          	auipc	a0,0x6
    80002bf0:	97c50513          	addi	a0,a0,-1668 # 80008568 <syscalls+0x1a8>
    80002bf4:	00003097          	auipc	ra,0x3
    80002bf8:	018080e7          	jalr	24(ra) # 80005c0c <panic>

0000000080002bfc <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002bfc:	7179                	addi	sp,sp,-48
    80002bfe:	f406                	sd	ra,40(sp)
    80002c00:	f022                	sd	s0,32(sp)
    80002c02:	ec26                	sd	s1,24(sp)
    80002c04:	e84a                	sd	s2,16(sp)
    80002c06:	e44e                	sd	s3,8(sp)
    80002c08:	e052                	sd	s4,0(sp)
    80002c0a:	1800                	addi	s0,sp,48
    80002c0c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c0e:	05050493          	addi	s1,a0,80
    80002c12:	08050913          	addi	s2,a0,128
    80002c16:	a021                	j	80002c1e <itrunc+0x22>
    80002c18:	0491                	addi	s1,s1,4
    80002c1a:	01248d63          	beq	s1,s2,80002c34 <itrunc+0x38>
    if(ip->addrs[i]){
    80002c1e:	408c                	lw	a1,0(s1)
    80002c20:	dde5                	beqz	a1,80002c18 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c22:	0009a503          	lw	a0,0(s3)
    80002c26:	00000097          	auipc	ra,0x0
    80002c2a:	8f6080e7          	jalr	-1802(ra) # 8000251c <bfree>
      ip->addrs[i] = 0;
    80002c2e:	0004a023          	sw	zero,0(s1)
    80002c32:	b7dd                	j	80002c18 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c34:	0809a583          	lw	a1,128(s3)
    80002c38:	e185                	bnez	a1,80002c58 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c3a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c3e:	854e                	mv	a0,s3
    80002c40:	00000097          	auipc	ra,0x0
    80002c44:	de2080e7          	jalr	-542(ra) # 80002a22 <iupdate>
}
    80002c48:	70a2                	ld	ra,40(sp)
    80002c4a:	7402                	ld	s0,32(sp)
    80002c4c:	64e2                	ld	s1,24(sp)
    80002c4e:	6942                	ld	s2,16(sp)
    80002c50:	69a2                	ld	s3,8(sp)
    80002c52:	6a02                	ld	s4,0(sp)
    80002c54:	6145                	addi	sp,sp,48
    80002c56:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c58:	0009a503          	lw	a0,0(s3)
    80002c5c:	fffff097          	auipc	ra,0xfffff
    80002c60:	67a080e7          	jalr	1658(ra) # 800022d6 <bread>
    80002c64:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c66:	05850493          	addi	s1,a0,88
    80002c6a:	45850913          	addi	s2,a0,1112
    80002c6e:	a021                	j	80002c76 <itrunc+0x7a>
    80002c70:	0491                	addi	s1,s1,4
    80002c72:	01248b63          	beq	s1,s2,80002c88 <itrunc+0x8c>
      if(a[j])
    80002c76:	408c                	lw	a1,0(s1)
    80002c78:	dde5                	beqz	a1,80002c70 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002c7a:	0009a503          	lw	a0,0(s3)
    80002c7e:	00000097          	auipc	ra,0x0
    80002c82:	89e080e7          	jalr	-1890(ra) # 8000251c <bfree>
    80002c86:	b7ed                	j	80002c70 <itrunc+0x74>
    brelse(bp);
    80002c88:	8552                	mv	a0,s4
    80002c8a:	fffff097          	auipc	ra,0xfffff
    80002c8e:	77c080e7          	jalr	1916(ra) # 80002406 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c92:	0809a583          	lw	a1,128(s3)
    80002c96:	0009a503          	lw	a0,0(s3)
    80002c9a:	00000097          	auipc	ra,0x0
    80002c9e:	882080e7          	jalr	-1918(ra) # 8000251c <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ca2:	0809a023          	sw	zero,128(s3)
    80002ca6:	bf51                	j	80002c3a <itrunc+0x3e>

0000000080002ca8 <iput>:
{
    80002ca8:	1101                	addi	sp,sp,-32
    80002caa:	ec06                	sd	ra,24(sp)
    80002cac:	e822                	sd	s0,16(sp)
    80002cae:	e426                	sd	s1,8(sp)
    80002cb0:	e04a                	sd	s2,0(sp)
    80002cb2:	1000                	addi	s0,sp,32
    80002cb4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cb6:	00014517          	auipc	a0,0x14
    80002cba:	17250513          	addi	a0,a0,370 # 80016e28 <itable>
    80002cbe:	00003097          	auipc	ra,0x3
    80002cc2:	486080e7          	jalr	1158(ra) # 80006144 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cc6:	4498                	lw	a4,8(s1)
    80002cc8:	4785                	li	a5,1
    80002cca:	02f70363          	beq	a4,a5,80002cf0 <iput+0x48>
  ip->ref--;
    80002cce:	449c                	lw	a5,8(s1)
    80002cd0:	37fd                	addiw	a5,a5,-1
    80002cd2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cd4:	00014517          	auipc	a0,0x14
    80002cd8:	15450513          	addi	a0,a0,340 # 80016e28 <itable>
    80002cdc:	00003097          	auipc	ra,0x3
    80002ce0:	51c080e7          	jalr	1308(ra) # 800061f8 <release>
}
    80002ce4:	60e2                	ld	ra,24(sp)
    80002ce6:	6442                	ld	s0,16(sp)
    80002ce8:	64a2                	ld	s1,8(sp)
    80002cea:	6902                	ld	s2,0(sp)
    80002cec:	6105                	addi	sp,sp,32
    80002cee:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cf0:	40bc                	lw	a5,64(s1)
    80002cf2:	dff1                	beqz	a5,80002cce <iput+0x26>
    80002cf4:	04a49783          	lh	a5,74(s1)
    80002cf8:	fbf9                	bnez	a5,80002cce <iput+0x26>
    acquiresleep(&ip->lock);
    80002cfa:	01048913          	addi	s2,s1,16
    80002cfe:	854a                	mv	a0,s2
    80002d00:	00001097          	auipc	ra,0x1
    80002d04:	aae080e7          	jalr	-1362(ra) # 800037ae <acquiresleep>
    release(&itable.lock);
    80002d08:	00014517          	auipc	a0,0x14
    80002d0c:	12050513          	addi	a0,a0,288 # 80016e28 <itable>
    80002d10:	00003097          	auipc	ra,0x3
    80002d14:	4e8080e7          	jalr	1256(ra) # 800061f8 <release>
    itrunc(ip);
    80002d18:	8526                	mv	a0,s1
    80002d1a:	00000097          	auipc	ra,0x0
    80002d1e:	ee2080e7          	jalr	-286(ra) # 80002bfc <itrunc>
    ip->type = 0;
    80002d22:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d26:	8526                	mv	a0,s1
    80002d28:	00000097          	auipc	ra,0x0
    80002d2c:	cfa080e7          	jalr	-774(ra) # 80002a22 <iupdate>
    ip->valid = 0;
    80002d30:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d34:	854a                	mv	a0,s2
    80002d36:	00001097          	auipc	ra,0x1
    80002d3a:	ace080e7          	jalr	-1330(ra) # 80003804 <releasesleep>
    acquire(&itable.lock);
    80002d3e:	00014517          	auipc	a0,0x14
    80002d42:	0ea50513          	addi	a0,a0,234 # 80016e28 <itable>
    80002d46:	00003097          	auipc	ra,0x3
    80002d4a:	3fe080e7          	jalr	1022(ra) # 80006144 <acquire>
    80002d4e:	b741                	j	80002cce <iput+0x26>

0000000080002d50 <iunlockput>:
{
    80002d50:	1101                	addi	sp,sp,-32
    80002d52:	ec06                	sd	ra,24(sp)
    80002d54:	e822                	sd	s0,16(sp)
    80002d56:	e426                	sd	s1,8(sp)
    80002d58:	1000                	addi	s0,sp,32
    80002d5a:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d5c:	00000097          	auipc	ra,0x0
    80002d60:	e54080e7          	jalr	-428(ra) # 80002bb0 <iunlock>
  iput(ip);
    80002d64:	8526                	mv	a0,s1
    80002d66:	00000097          	auipc	ra,0x0
    80002d6a:	f42080e7          	jalr	-190(ra) # 80002ca8 <iput>
}
    80002d6e:	60e2                	ld	ra,24(sp)
    80002d70:	6442                	ld	s0,16(sp)
    80002d72:	64a2                	ld	s1,8(sp)
    80002d74:	6105                	addi	sp,sp,32
    80002d76:	8082                	ret

0000000080002d78 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002d78:	1141                	addi	sp,sp,-16
    80002d7a:	e422                	sd	s0,8(sp)
    80002d7c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002d7e:	411c                	lw	a5,0(a0)
    80002d80:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002d82:	415c                	lw	a5,4(a0)
    80002d84:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002d86:	04451783          	lh	a5,68(a0)
    80002d8a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d8e:	04a51783          	lh	a5,74(a0)
    80002d92:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d96:	04c56783          	lwu	a5,76(a0)
    80002d9a:	e99c                	sd	a5,16(a1)
}
    80002d9c:	6422                	ld	s0,8(sp)
    80002d9e:	0141                	addi	sp,sp,16
    80002da0:	8082                	ret

0000000080002da2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002da2:	457c                	lw	a5,76(a0)
    80002da4:	0ed7e963          	bltu	a5,a3,80002e96 <readi+0xf4>
{
    80002da8:	7159                	addi	sp,sp,-112
    80002daa:	f486                	sd	ra,104(sp)
    80002dac:	f0a2                	sd	s0,96(sp)
    80002dae:	eca6                	sd	s1,88(sp)
    80002db0:	e8ca                	sd	s2,80(sp)
    80002db2:	e4ce                	sd	s3,72(sp)
    80002db4:	e0d2                	sd	s4,64(sp)
    80002db6:	fc56                	sd	s5,56(sp)
    80002db8:	f85a                	sd	s6,48(sp)
    80002dba:	f45e                	sd	s7,40(sp)
    80002dbc:	f062                	sd	s8,32(sp)
    80002dbe:	ec66                	sd	s9,24(sp)
    80002dc0:	e86a                	sd	s10,16(sp)
    80002dc2:	e46e                	sd	s11,8(sp)
    80002dc4:	1880                	addi	s0,sp,112
    80002dc6:	8b2a                	mv	s6,a0
    80002dc8:	8bae                	mv	s7,a1
    80002dca:	8a32                	mv	s4,a2
    80002dcc:	84b6                	mv	s1,a3
    80002dce:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002dd0:	9f35                	addw	a4,a4,a3
    return 0;
    80002dd2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002dd4:	0ad76063          	bltu	a4,a3,80002e74 <readi+0xd2>
  if(off + n > ip->size)
    80002dd8:	00e7f463          	bgeu	a5,a4,80002de0 <readi+0x3e>
    n = ip->size - off;
    80002ddc:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002de0:	0a0a8963          	beqz	s5,80002e92 <readi+0xf0>
    80002de4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002de6:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002dea:	5c7d                	li	s8,-1
    80002dec:	a82d                	j	80002e26 <readi+0x84>
    80002dee:	020d1d93          	slli	s11,s10,0x20
    80002df2:	020ddd93          	srli	s11,s11,0x20
    80002df6:	05890613          	addi	a2,s2,88
    80002dfa:	86ee                	mv	a3,s11
    80002dfc:	963a                	add	a2,a2,a4
    80002dfe:	85d2                	mv	a1,s4
    80002e00:	855e                	mv	a0,s7
    80002e02:	fffff097          	auipc	ra,0xfffff
    80002e06:	ae8080e7          	jalr	-1304(ra) # 800018ea <either_copyout>
    80002e0a:	05850d63          	beq	a0,s8,80002e64 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e0e:	854a                	mv	a0,s2
    80002e10:	fffff097          	auipc	ra,0xfffff
    80002e14:	5f6080e7          	jalr	1526(ra) # 80002406 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e18:	013d09bb          	addw	s3,s10,s3
    80002e1c:	009d04bb          	addw	s1,s10,s1
    80002e20:	9a6e                	add	s4,s4,s11
    80002e22:	0559f763          	bgeu	s3,s5,80002e70 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002e26:	00a4d59b          	srliw	a1,s1,0xa
    80002e2a:	855a                	mv	a0,s6
    80002e2c:	00000097          	auipc	ra,0x0
    80002e30:	89e080e7          	jalr	-1890(ra) # 800026ca <bmap>
    80002e34:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002e38:	cd85                	beqz	a1,80002e70 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002e3a:	000b2503          	lw	a0,0(s6)
    80002e3e:	fffff097          	auipc	ra,0xfffff
    80002e42:	498080e7          	jalr	1176(ra) # 800022d6 <bread>
    80002e46:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e48:	3ff4f713          	andi	a4,s1,1023
    80002e4c:	40ec87bb          	subw	a5,s9,a4
    80002e50:	413a86bb          	subw	a3,s5,s3
    80002e54:	8d3e                	mv	s10,a5
    80002e56:	2781                	sext.w	a5,a5
    80002e58:	0006861b          	sext.w	a2,a3
    80002e5c:	f8f679e3          	bgeu	a2,a5,80002dee <readi+0x4c>
    80002e60:	8d36                	mv	s10,a3
    80002e62:	b771                	j	80002dee <readi+0x4c>
      brelse(bp);
    80002e64:	854a                	mv	a0,s2
    80002e66:	fffff097          	auipc	ra,0xfffff
    80002e6a:	5a0080e7          	jalr	1440(ra) # 80002406 <brelse>
      tot = -1;
    80002e6e:	59fd                	li	s3,-1
  }
  return tot;
    80002e70:	0009851b          	sext.w	a0,s3
}
    80002e74:	70a6                	ld	ra,104(sp)
    80002e76:	7406                	ld	s0,96(sp)
    80002e78:	64e6                	ld	s1,88(sp)
    80002e7a:	6946                	ld	s2,80(sp)
    80002e7c:	69a6                	ld	s3,72(sp)
    80002e7e:	6a06                	ld	s4,64(sp)
    80002e80:	7ae2                	ld	s5,56(sp)
    80002e82:	7b42                	ld	s6,48(sp)
    80002e84:	7ba2                	ld	s7,40(sp)
    80002e86:	7c02                	ld	s8,32(sp)
    80002e88:	6ce2                	ld	s9,24(sp)
    80002e8a:	6d42                	ld	s10,16(sp)
    80002e8c:	6da2                	ld	s11,8(sp)
    80002e8e:	6165                	addi	sp,sp,112
    80002e90:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e92:	89d6                	mv	s3,s5
    80002e94:	bff1                	j	80002e70 <readi+0xce>
    return 0;
    80002e96:	4501                	li	a0,0
}
    80002e98:	8082                	ret

0000000080002e9a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e9a:	457c                	lw	a5,76(a0)
    80002e9c:	10d7e863          	bltu	a5,a3,80002fac <writei+0x112>
{
    80002ea0:	7159                	addi	sp,sp,-112
    80002ea2:	f486                	sd	ra,104(sp)
    80002ea4:	f0a2                	sd	s0,96(sp)
    80002ea6:	eca6                	sd	s1,88(sp)
    80002ea8:	e8ca                	sd	s2,80(sp)
    80002eaa:	e4ce                	sd	s3,72(sp)
    80002eac:	e0d2                	sd	s4,64(sp)
    80002eae:	fc56                	sd	s5,56(sp)
    80002eb0:	f85a                	sd	s6,48(sp)
    80002eb2:	f45e                	sd	s7,40(sp)
    80002eb4:	f062                	sd	s8,32(sp)
    80002eb6:	ec66                	sd	s9,24(sp)
    80002eb8:	e86a                	sd	s10,16(sp)
    80002eba:	e46e                	sd	s11,8(sp)
    80002ebc:	1880                	addi	s0,sp,112
    80002ebe:	8aaa                	mv	s5,a0
    80002ec0:	8bae                	mv	s7,a1
    80002ec2:	8a32                	mv	s4,a2
    80002ec4:	8936                	mv	s2,a3
    80002ec6:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ec8:	00e687bb          	addw	a5,a3,a4
    80002ecc:	0ed7e263          	bltu	a5,a3,80002fb0 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002ed0:	00043737          	lui	a4,0x43
    80002ed4:	0ef76063          	bltu	a4,a5,80002fb4 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ed8:	0c0b0863          	beqz	s6,80002fa8 <writei+0x10e>
    80002edc:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ede:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ee2:	5c7d                	li	s8,-1
    80002ee4:	a091                	j	80002f28 <writei+0x8e>
    80002ee6:	020d1d93          	slli	s11,s10,0x20
    80002eea:	020ddd93          	srli	s11,s11,0x20
    80002eee:	05848513          	addi	a0,s1,88
    80002ef2:	86ee                	mv	a3,s11
    80002ef4:	8652                	mv	a2,s4
    80002ef6:	85de                	mv	a1,s7
    80002ef8:	953a                	add	a0,a0,a4
    80002efa:	fffff097          	auipc	ra,0xfffff
    80002efe:	a46080e7          	jalr	-1466(ra) # 80001940 <either_copyin>
    80002f02:	07850263          	beq	a0,s8,80002f66 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f06:	8526                	mv	a0,s1
    80002f08:	00000097          	auipc	ra,0x0
    80002f0c:	788080e7          	jalr	1928(ra) # 80003690 <log_write>
    brelse(bp);
    80002f10:	8526                	mv	a0,s1
    80002f12:	fffff097          	auipc	ra,0xfffff
    80002f16:	4f4080e7          	jalr	1268(ra) # 80002406 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f1a:	013d09bb          	addw	s3,s10,s3
    80002f1e:	012d093b          	addw	s2,s10,s2
    80002f22:	9a6e                	add	s4,s4,s11
    80002f24:	0569f663          	bgeu	s3,s6,80002f70 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002f28:	00a9559b          	srliw	a1,s2,0xa
    80002f2c:	8556                	mv	a0,s5
    80002f2e:	fffff097          	auipc	ra,0xfffff
    80002f32:	79c080e7          	jalr	1948(ra) # 800026ca <bmap>
    80002f36:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f3a:	c99d                	beqz	a1,80002f70 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002f3c:	000aa503          	lw	a0,0(s5)
    80002f40:	fffff097          	auipc	ra,0xfffff
    80002f44:	396080e7          	jalr	918(ra) # 800022d6 <bread>
    80002f48:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f4a:	3ff97713          	andi	a4,s2,1023
    80002f4e:	40ec87bb          	subw	a5,s9,a4
    80002f52:	413b06bb          	subw	a3,s6,s3
    80002f56:	8d3e                	mv	s10,a5
    80002f58:	2781                	sext.w	a5,a5
    80002f5a:	0006861b          	sext.w	a2,a3
    80002f5e:	f8f674e3          	bgeu	a2,a5,80002ee6 <writei+0x4c>
    80002f62:	8d36                	mv	s10,a3
    80002f64:	b749                	j	80002ee6 <writei+0x4c>
      brelse(bp);
    80002f66:	8526                	mv	a0,s1
    80002f68:	fffff097          	auipc	ra,0xfffff
    80002f6c:	49e080e7          	jalr	1182(ra) # 80002406 <brelse>
  }

  if(off > ip->size)
    80002f70:	04caa783          	lw	a5,76(s5)
    80002f74:	0127f463          	bgeu	a5,s2,80002f7c <writei+0xe2>
    ip->size = off;
    80002f78:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002f7c:	8556                	mv	a0,s5
    80002f7e:	00000097          	auipc	ra,0x0
    80002f82:	aa4080e7          	jalr	-1372(ra) # 80002a22 <iupdate>

  return tot;
    80002f86:	0009851b          	sext.w	a0,s3
}
    80002f8a:	70a6                	ld	ra,104(sp)
    80002f8c:	7406                	ld	s0,96(sp)
    80002f8e:	64e6                	ld	s1,88(sp)
    80002f90:	6946                	ld	s2,80(sp)
    80002f92:	69a6                	ld	s3,72(sp)
    80002f94:	6a06                	ld	s4,64(sp)
    80002f96:	7ae2                	ld	s5,56(sp)
    80002f98:	7b42                	ld	s6,48(sp)
    80002f9a:	7ba2                	ld	s7,40(sp)
    80002f9c:	7c02                	ld	s8,32(sp)
    80002f9e:	6ce2                	ld	s9,24(sp)
    80002fa0:	6d42                	ld	s10,16(sp)
    80002fa2:	6da2                	ld	s11,8(sp)
    80002fa4:	6165                	addi	sp,sp,112
    80002fa6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fa8:	89da                	mv	s3,s6
    80002faa:	bfc9                	j	80002f7c <writei+0xe2>
    return -1;
    80002fac:	557d                	li	a0,-1
}
    80002fae:	8082                	ret
    return -1;
    80002fb0:	557d                	li	a0,-1
    80002fb2:	bfe1                	j	80002f8a <writei+0xf0>
    return -1;
    80002fb4:	557d                	li	a0,-1
    80002fb6:	bfd1                	j	80002f8a <writei+0xf0>

0000000080002fb8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002fb8:	1141                	addi	sp,sp,-16
    80002fba:	e406                	sd	ra,8(sp)
    80002fbc:	e022                	sd	s0,0(sp)
    80002fbe:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002fc0:	4639                	li	a2,14
    80002fc2:	ffffd097          	auipc	ra,0xffffd
    80002fc6:	288080e7          	jalr	648(ra) # 8000024a <strncmp>
}
    80002fca:	60a2                	ld	ra,8(sp)
    80002fcc:	6402                	ld	s0,0(sp)
    80002fce:	0141                	addi	sp,sp,16
    80002fd0:	8082                	ret

0000000080002fd2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002fd2:	7139                	addi	sp,sp,-64
    80002fd4:	fc06                	sd	ra,56(sp)
    80002fd6:	f822                	sd	s0,48(sp)
    80002fd8:	f426                	sd	s1,40(sp)
    80002fda:	f04a                	sd	s2,32(sp)
    80002fdc:	ec4e                	sd	s3,24(sp)
    80002fde:	e852                	sd	s4,16(sp)
    80002fe0:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002fe2:	04451703          	lh	a4,68(a0)
    80002fe6:	4785                	li	a5,1
    80002fe8:	00f71a63          	bne	a4,a5,80002ffc <dirlookup+0x2a>
    80002fec:	892a                	mv	s2,a0
    80002fee:	89ae                	mv	s3,a1
    80002ff0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ff2:	457c                	lw	a5,76(a0)
    80002ff4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002ff6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ff8:	e79d                	bnez	a5,80003026 <dirlookup+0x54>
    80002ffa:	a8a5                	j	80003072 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80002ffc:	00005517          	auipc	a0,0x5
    80003000:	57450513          	addi	a0,a0,1396 # 80008570 <syscalls+0x1b0>
    80003004:	00003097          	auipc	ra,0x3
    80003008:	c08080e7          	jalr	-1016(ra) # 80005c0c <panic>
      panic("dirlookup read");
    8000300c:	00005517          	auipc	a0,0x5
    80003010:	57c50513          	addi	a0,a0,1404 # 80008588 <syscalls+0x1c8>
    80003014:	00003097          	auipc	ra,0x3
    80003018:	bf8080e7          	jalr	-1032(ra) # 80005c0c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000301c:	24c1                	addiw	s1,s1,16
    8000301e:	04c92783          	lw	a5,76(s2)
    80003022:	04f4f763          	bgeu	s1,a5,80003070 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003026:	4741                	li	a4,16
    80003028:	86a6                	mv	a3,s1
    8000302a:	fc040613          	addi	a2,s0,-64
    8000302e:	4581                	li	a1,0
    80003030:	854a                	mv	a0,s2
    80003032:	00000097          	auipc	ra,0x0
    80003036:	d70080e7          	jalr	-656(ra) # 80002da2 <readi>
    8000303a:	47c1                	li	a5,16
    8000303c:	fcf518e3          	bne	a0,a5,8000300c <dirlookup+0x3a>
    if(de.inum == 0)
    80003040:	fc045783          	lhu	a5,-64(s0)
    80003044:	dfe1                	beqz	a5,8000301c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003046:	fc240593          	addi	a1,s0,-62
    8000304a:	854e                	mv	a0,s3
    8000304c:	00000097          	auipc	ra,0x0
    80003050:	f6c080e7          	jalr	-148(ra) # 80002fb8 <namecmp>
    80003054:	f561                	bnez	a0,8000301c <dirlookup+0x4a>
      if(poff)
    80003056:	000a0463          	beqz	s4,8000305e <dirlookup+0x8c>
        *poff = off;
    8000305a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000305e:	fc045583          	lhu	a1,-64(s0)
    80003062:	00092503          	lw	a0,0(s2)
    80003066:	fffff097          	auipc	ra,0xfffff
    8000306a:	74e080e7          	jalr	1870(ra) # 800027b4 <iget>
    8000306e:	a011                	j	80003072 <dirlookup+0xa0>
  return 0;
    80003070:	4501                	li	a0,0
}
    80003072:	70e2                	ld	ra,56(sp)
    80003074:	7442                	ld	s0,48(sp)
    80003076:	74a2                	ld	s1,40(sp)
    80003078:	7902                	ld	s2,32(sp)
    8000307a:	69e2                	ld	s3,24(sp)
    8000307c:	6a42                	ld	s4,16(sp)
    8000307e:	6121                	addi	sp,sp,64
    80003080:	8082                	ret

0000000080003082 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003082:	711d                	addi	sp,sp,-96
    80003084:	ec86                	sd	ra,88(sp)
    80003086:	e8a2                	sd	s0,80(sp)
    80003088:	e4a6                	sd	s1,72(sp)
    8000308a:	e0ca                	sd	s2,64(sp)
    8000308c:	fc4e                	sd	s3,56(sp)
    8000308e:	f852                	sd	s4,48(sp)
    80003090:	f456                	sd	s5,40(sp)
    80003092:	f05a                	sd	s6,32(sp)
    80003094:	ec5e                	sd	s7,24(sp)
    80003096:	e862                	sd	s8,16(sp)
    80003098:	e466                	sd	s9,8(sp)
    8000309a:	e06a                	sd	s10,0(sp)
    8000309c:	1080                	addi	s0,sp,96
    8000309e:	84aa                	mv	s1,a0
    800030a0:	8b2e                	mv	s6,a1
    800030a2:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800030a4:	00054703          	lbu	a4,0(a0)
    800030a8:	02f00793          	li	a5,47
    800030ac:	02f70363          	beq	a4,a5,800030d2 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800030b0:	ffffe097          	auipc	ra,0xffffe
    800030b4:	d8a080e7          	jalr	-630(ra) # 80000e3a <myproc>
    800030b8:	15053503          	ld	a0,336(a0)
    800030bc:	00000097          	auipc	ra,0x0
    800030c0:	9f4080e7          	jalr	-1548(ra) # 80002ab0 <idup>
    800030c4:	8a2a                	mv	s4,a0
  while(*path == '/')
    800030c6:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800030ca:	4cb5                	li	s9,13
  len = path - s;
    800030cc:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800030ce:	4c05                	li	s8,1
    800030d0:	a87d                	j	8000318e <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800030d2:	4585                	li	a1,1
    800030d4:	4505                	li	a0,1
    800030d6:	fffff097          	auipc	ra,0xfffff
    800030da:	6de080e7          	jalr	1758(ra) # 800027b4 <iget>
    800030de:	8a2a                	mv	s4,a0
    800030e0:	b7dd                	j	800030c6 <namex+0x44>
      iunlockput(ip);
    800030e2:	8552                	mv	a0,s4
    800030e4:	00000097          	auipc	ra,0x0
    800030e8:	c6c080e7          	jalr	-916(ra) # 80002d50 <iunlockput>
      return 0;
    800030ec:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800030ee:	8552                	mv	a0,s4
    800030f0:	60e6                	ld	ra,88(sp)
    800030f2:	6446                	ld	s0,80(sp)
    800030f4:	64a6                	ld	s1,72(sp)
    800030f6:	6906                	ld	s2,64(sp)
    800030f8:	79e2                	ld	s3,56(sp)
    800030fa:	7a42                	ld	s4,48(sp)
    800030fc:	7aa2                	ld	s5,40(sp)
    800030fe:	7b02                	ld	s6,32(sp)
    80003100:	6be2                	ld	s7,24(sp)
    80003102:	6c42                	ld	s8,16(sp)
    80003104:	6ca2                	ld	s9,8(sp)
    80003106:	6d02                	ld	s10,0(sp)
    80003108:	6125                	addi	sp,sp,96
    8000310a:	8082                	ret
      iunlock(ip);
    8000310c:	8552                	mv	a0,s4
    8000310e:	00000097          	auipc	ra,0x0
    80003112:	aa2080e7          	jalr	-1374(ra) # 80002bb0 <iunlock>
      return ip;
    80003116:	bfe1                	j	800030ee <namex+0x6c>
      iunlockput(ip);
    80003118:	8552                	mv	a0,s4
    8000311a:	00000097          	auipc	ra,0x0
    8000311e:	c36080e7          	jalr	-970(ra) # 80002d50 <iunlockput>
      return 0;
    80003122:	8a4e                	mv	s4,s3
    80003124:	b7e9                	j	800030ee <namex+0x6c>
  len = path - s;
    80003126:	40998633          	sub	a2,s3,s1
    8000312a:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8000312e:	09acd863          	bge	s9,s10,800031be <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003132:	4639                	li	a2,14
    80003134:	85a6                	mv	a1,s1
    80003136:	8556                	mv	a0,s5
    80003138:	ffffd097          	auipc	ra,0xffffd
    8000313c:	09e080e7          	jalr	158(ra) # 800001d6 <memmove>
    80003140:	84ce                	mv	s1,s3
  while(*path == '/')
    80003142:	0004c783          	lbu	a5,0(s1)
    80003146:	01279763          	bne	a5,s2,80003154 <namex+0xd2>
    path++;
    8000314a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000314c:	0004c783          	lbu	a5,0(s1)
    80003150:	ff278de3          	beq	a5,s2,8000314a <namex+0xc8>
    ilock(ip);
    80003154:	8552                	mv	a0,s4
    80003156:	00000097          	auipc	ra,0x0
    8000315a:	998080e7          	jalr	-1640(ra) # 80002aee <ilock>
    if(ip->type != T_DIR){
    8000315e:	044a1783          	lh	a5,68(s4)
    80003162:	f98790e3          	bne	a5,s8,800030e2 <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003166:	000b0563          	beqz	s6,80003170 <namex+0xee>
    8000316a:	0004c783          	lbu	a5,0(s1)
    8000316e:	dfd9                	beqz	a5,8000310c <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003170:	865e                	mv	a2,s7
    80003172:	85d6                	mv	a1,s5
    80003174:	8552                	mv	a0,s4
    80003176:	00000097          	auipc	ra,0x0
    8000317a:	e5c080e7          	jalr	-420(ra) # 80002fd2 <dirlookup>
    8000317e:	89aa                	mv	s3,a0
    80003180:	dd41                	beqz	a0,80003118 <namex+0x96>
    iunlockput(ip);
    80003182:	8552                	mv	a0,s4
    80003184:	00000097          	auipc	ra,0x0
    80003188:	bcc080e7          	jalr	-1076(ra) # 80002d50 <iunlockput>
    ip = next;
    8000318c:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000318e:	0004c783          	lbu	a5,0(s1)
    80003192:	01279763          	bne	a5,s2,800031a0 <namex+0x11e>
    path++;
    80003196:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003198:	0004c783          	lbu	a5,0(s1)
    8000319c:	ff278de3          	beq	a5,s2,80003196 <namex+0x114>
  if(*path == 0)
    800031a0:	cb9d                	beqz	a5,800031d6 <namex+0x154>
  while(*path != '/' && *path != 0)
    800031a2:	0004c783          	lbu	a5,0(s1)
    800031a6:	89a6                	mv	s3,s1
  len = path - s;
    800031a8:	8d5e                	mv	s10,s7
    800031aa:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800031ac:	01278963          	beq	a5,s2,800031be <namex+0x13c>
    800031b0:	dbbd                	beqz	a5,80003126 <namex+0xa4>
    path++;
    800031b2:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800031b4:	0009c783          	lbu	a5,0(s3)
    800031b8:	ff279ce3          	bne	a5,s2,800031b0 <namex+0x12e>
    800031bc:	b7ad                	j	80003126 <namex+0xa4>
    memmove(name, s, len);
    800031be:	2601                	sext.w	a2,a2
    800031c0:	85a6                	mv	a1,s1
    800031c2:	8556                	mv	a0,s5
    800031c4:	ffffd097          	auipc	ra,0xffffd
    800031c8:	012080e7          	jalr	18(ra) # 800001d6 <memmove>
    name[len] = 0;
    800031cc:	9d56                	add	s10,s10,s5
    800031ce:	000d0023          	sb	zero,0(s10)
    800031d2:	84ce                	mv	s1,s3
    800031d4:	b7bd                	j	80003142 <namex+0xc0>
  if(nameiparent){
    800031d6:	f00b0ce3          	beqz	s6,800030ee <namex+0x6c>
    iput(ip);
    800031da:	8552                	mv	a0,s4
    800031dc:	00000097          	auipc	ra,0x0
    800031e0:	acc080e7          	jalr	-1332(ra) # 80002ca8 <iput>
    return 0;
    800031e4:	4a01                	li	s4,0
    800031e6:	b721                	j	800030ee <namex+0x6c>

00000000800031e8 <dirlink>:
{
    800031e8:	7139                	addi	sp,sp,-64
    800031ea:	fc06                	sd	ra,56(sp)
    800031ec:	f822                	sd	s0,48(sp)
    800031ee:	f426                	sd	s1,40(sp)
    800031f0:	f04a                	sd	s2,32(sp)
    800031f2:	ec4e                	sd	s3,24(sp)
    800031f4:	e852                	sd	s4,16(sp)
    800031f6:	0080                	addi	s0,sp,64
    800031f8:	892a                	mv	s2,a0
    800031fa:	8a2e                	mv	s4,a1
    800031fc:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800031fe:	4601                	li	a2,0
    80003200:	00000097          	auipc	ra,0x0
    80003204:	dd2080e7          	jalr	-558(ra) # 80002fd2 <dirlookup>
    80003208:	e93d                	bnez	a0,8000327e <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000320a:	04c92483          	lw	s1,76(s2)
    8000320e:	c49d                	beqz	s1,8000323c <dirlink+0x54>
    80003210:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003212:	4741                	li	a4,16
    80003214:	86a6                	mv	a3,s1
    80003216:	fc040613          	addi	a2,s0,-64
    8000321a:	4581                	li	a1,0
    8000321c:	854a                	mv	a0,s2
    8000321e:	00000097          	auipc	ra,0x0
    80003222:	b84080e7          	jalr	-1148(ra) # 80002da2 <readi>
    80003226:	47c1                	li	a5,16
    80003228:	06f51163          	bne	a0,a5,8000328a <dirlink+0xa2>
    if(de.inum == 0)
    8000322c:	fc045783          	lhu	a5,-64(s0)
    80003230:	c791                	beqz	a5,8000323c <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003232:	24c1                	addiw	s1,s1,16
    80003234:	04c92783          	lw	a5,76(s2)
    80003238:	fcf4ede3          	bltu	s1,a5,80003212 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000323c:	4639                	li	a2,14
    8000323e:	85d2                	mv	a1,s4
    80003240:	fc240513          	addi	a0,s0,-62
    80003244:	ffffd097          	auipc	ra,0xffffd
    80003248:	042080e7          	jalr	66(ra) # 80000286 <strncpy>
  de.inum = inum;
    8000324c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003250:	4741                	li	a4,16
    80003252:	86a6                	mv	a3,s1
    80003254:	fc040613          	addi	a2,s0,-64
    80003258:	4581                	li	a1,0
    8000325a:	854a                	mv	a0,s2
    8000325c:	00000097          	auipc	ra,0x0
    80003260:	c3e080e7          	jalr	-962(ra) # 80002e9a <writei>
    80003264:	1541                	addi	a0,a0,-16
    80003266:	00a03533          	snez	a0,a0
    8000326a:	40a00533          	neg	a0,a0
}
    8000326e:	70e2                	ld	ra,56(sp)
    80003270:	7442                	ld	s0,48(sp)
    80003272:	74a2                	ld	s1,40(sp)
    80003274:	7902                	ld	s2,32(sp)
    80003276:	69e2                	ld	s3,24(sp)
    80003278:	6a42                	ld	s4,16(sp)
    8000327a:	6121                	addi	sp,sp,64
    8000327c:	8082                	ret
    iput(ip);
    8000327e:	00000097          	auipc	ra,0x0
    80003282:	a2a080e7          	jalr	-1494(ra) # 80002ca8 <iput>
    return -1;
    80003286:	557d                	li	a0,-1
    80003288:	b7dd                	j	8000326e <dirlink+0x86>
      panic("dirlink read");
    8000328a:	00005517          	auipc	a0,0x5
    8000328e:	30e50513          	addi	a0,a0,782 # 80008598 <syscalls+0x1d8>
    80003292:	00003097          	auipc	ra,0x3
    80003296:	97a080e7          	jalr	-1670(ra) # 80005c0c <panic>

000000008000329a <namei>:

struct inode*
namei(char *path)
{
    8000329a:	1101                	addi	sp,sp,-32
    8000329c:	ec06                	sd	ra,24(sp)
    8000329e:	e822                	sd	s0,16(sp)
    800032a0:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800032a2:	fe040613          	addi	a2,s0,-32
    800032a6:	4581                	li	a1,0
    800032a8:	00000097          	auipc	ra,0x0
    800032ac:	dda080e7          	jalr	-550(ra) # 80003082 <namex>
}
    800032b0:	60e2                	ld	ra,24(sp)
    800032b2:	6442                	ld	s0,16(sp)
    800032b4:	6105                	addi	sp,sp,32
    800032b6:	8082                	ret

00000000800032b8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800032b8:	1141                	addi	sp,sp,-16
    800032ba:	e406                	sd	ra,8(sp)
    800032bc:	e022                	sd	s0,0(sp)
    800032be:	0800                	addi	s0,sp,16
    800032c0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800032c2:	4585                	li	a1,1
    800032c4:	00000097          	auipc	ra,0x0
    800032c8:	dbe080e7          	jalr	-578(ra) # 80003082 <namex>
}
    800032cc:	60a2                	ld	ra,8(sp)
    800032ce:	6402                	ld	s0,0(sp)
    800032d0:	0141                	addi	sp,sp,16
    800032d2:	8082                	ret

00000000800032d4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800032d4:	1101                	addi	sp,sp,-32
    800032d6:	ec06                	sd	ra,24(sp)
    800032d8:	e822                	sd	s0,16(sp)
    800032da:	e426                	sd	s1,8(sp)
    800032dc:	e04a                	sd	s2,0(sp)
    800032de:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800032e0:	00015917          	auipc	s2,0x15
    800032e4:	5f090913          	addi	s2,s2,1520 # 800188d0 <log>
    800032e8:	01892583          	lw	a1,24(s2)
    800032ec:	02892503          	lw	a0,40(s2)
    800032f0:	fffff097          	auipc	ra,0xfffff
    800032f4:	fe6080e7          	jalr	-26(ra) # 800022d6 <bread>
    800032f8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800032fa:	02c92683          	lw	a3,44(s2)
    800032fe:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003300:	02d05863          	blez	a3,80003330 <write_head+0x5c>
    80003304:	00015797          	auipc	a5,0x15
    80003308:	5fc78793          	addi	a5,a5,1532 # 80018900 <log+0x30>
    8000330c:	05c50713          	addi	a4,a0,92
    80003310:	36fd                	addiw	a3,a3,-1
    80003312:	02069613          	slli	a2,a3,0x20
    80003316:	01e65693          	srli	a3,a2,0x1e
    8000331a:	00015617          	auipc	a2,0x15
    8000331e:	5ea60613          	addi	a2,a2,1514 # 80018904 <log+0x34>
    80003322:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003324:	4390                	lw	a2,0(a5)
    80003326:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003328:	0791                	addi	a5,a5,4
    8000332a:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    8000332c:	fed79ce3          	bne	a5,a3,80003324 <write_head+0x50>
  }
  bwrite(buf);
    80003330:	8526                	mv	a0,s1
    80003332:	fffff097          	auipc	ra,0xfffff
    80003336:	096080e7          	jalr	150(ra) # 800023c8 <bwrite>
  brelse(buf);
    8000333a:	8526                	mv	a0,s1
    8000333c:	fffff097          	auipc	ra,0xfffff
    80003340:	0ca080e7          	jalr	202(ra) # 80002406 <brelse>
}
    80003344:	60e2                	ld	ra,24(sp)
    80003346:	6442                	ld	s0,16(sp)
    80003348:	64a2                	ld	s1,8(sp)
    8000334a:	6902                	ld	s2,0(sp)
    8000334c:	6105                	addi	sp,sp,32
    8000334e:	8082                	ret

0000000080003350 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003350:	00015797          	auipc	a5,0x15
    80003354:	5ac7a783          	lw	a5,1452(a5) # 800188fc <log+0x2c>
    80003358:	0af05d63          	blez	a5,80003412 <install_trans+0xc2>
{
    8000335c:	7139                	addi	sp,sp,-64
    8000335e:	fc06                	sd	ra,56(sp)
    80003360:	f822                	sd	s0,48(sp)
    80003362:	f426                	sd	s1,40(sp)
    80003364:	f04a                	sd	s2,32(sp)
    80003366:	ec4e                	sd	s3,24(sp)
    80003368:	e852                	sd	s4,16(sp)
    8000336a:	e456                	sd	s5,8(sp)
    8000336c:	e05a                	sd	s6,0(sp)
    8000336e:	0080                	addi	s0,sp,64
    80003370:	8b2a                	mv	s6,a0
    80003372:	00015a97          	auipc	s5,0x15
    80003376:	58ea8a93          	addi	s5,s5,1422 # 80018900 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000337a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000337c:	00015997          	auipc	s3,0x15
    80003380:	55498993          	addi	s3,s3,1364 # 800188d0 <log>
    80003384:	a00d                	j	800033a6 <install_trans+0x56>
    brelse(lbuf);
    80003386:	854a                	mv	a0,s2
    80003388:	fffff097          	auipc	ra,0xfffff
    8000338c:	07e080e7          	jalr	126(ra) # 80002406 <brelse>
    brelse(dbuf);
    80003390:	8526                	mv	a0,s1
    80003392:	fffff097          	auipc	ra,0xfffff
    80003396:	074080e7          	jalr	116(ra) # 80002406 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000339a:	2a05                	addiw	s4,s4,1
    8000339c:	0a91                	addi	s5,s5,4
    8000339e:	02c9a783          	lw	a5,44(s3)
    800033a2:	04fa5e63          	bge	s4,a5,800033fe <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033a6:	0189a583          	lw	a1,24(s3)
    800033aa:	014585bb          	addw	a1,a1,s4
    800033ae:	2585                	addiw	a1,a1,1
    800033b0:	0289a503          	lw	a0,40(s3)
    800033b4:	fffff097          	auipc	ra,0xfffff
    800033b8:	f22080e7          	jalr	-222(ra) # 800022d6 <bread>
    800033bc:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800033be:	000aa583          	lw	a1,0(s5)
    800033c2:	0289a503          	lw	a0,40(s3)
    800033c6:	fffff097          	auipc	ra,0xfffff
    800033ca:	f10080e7          	jalr	-240(ra) # 800022d6 <bread>
    800033ce:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800033d0:	40000613          	li	a2,1024
    800033d4:	05890593          	addi	a1,s2,88
    800033d8:	05850513          	addi	a0,a0,88
    800033dc:	ffffd097          	auipc	ra,0xffffd
    800033e0:	dfa080e7          	jalr	-518(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800033e4:	8526                	mv	a0,s1
    800033e6:	fffff097          	auipc	ra,0xfffff
    800033ea:	fe2080e7          	jalr	-30(ra) # 800023c8 <bwrite>
    if(recovering == 0)
    800033ee:	f80b1ce3          	bnez	s6,80003386 <install_trans+0x36>
      bunpin(dbuf);
    800033f2:	8526                	mv	a0,s1
    800033f4:	fffff097          	auipc	ra,0xfffff
    800033f8:	0ec080e7          	jalr	236(ra) # 800024e0 <bunpin>
    800033fc:	b769                	j	80003386 <install_trans+0x36>
}
    800033fe:	70e2                	ld	ra,56(sp)
    80003400:	7442                	ld	s0,48(sp)
    80003402:	74a2                	ld	s1,40(sp)
    80003404:	7902                	ld	s2,32(sp)
    80003406:	69e2                	ld	s3,24(sp)
    80003408:	6a42                	ld	s4,16(sp)
    8000340a:	6aa2                	ld	s5,8(sp)
    8000340c:	6b02                	ld	s6,0(sp)
    8000340e:	6121                	addi	sp,sp,64
    80003410:	8082                	ret
    80003412:	8082                	ret

0000000080003414 <initlog>:
{
    80003414:	7179                	addi	sp,sp,-48
    80003416:	f406                	sd	ra,40(sp)
    80003418:	f022                	sd	s0,32(sp)
    8000341a:	ec26                	sd	s1,24(sp)
    8000341c:	e84a                	sd	s2,16(sp)
    8000341e:	e44e                	sd	s3,8(sp)
    80003420:	1800                	addi	s0,sp,48
    80003422:	892a                	mv	s2,a0
    80003424:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003426:	00015497          	auipc	s1,0x15
    8000342a:	4aa48493          	addi	s1,s1,1194 # 800188d0 <log>
    8000342e:	00005597          	auipc	a1,0x5
    80003432:	17a58593          	addi	a1,a1,378 # 800085a8 <syscalls+0x1e8>
    80003436:	8526                	mv	a0,s1
    80003438:	00003097          	auipc	ra,0x3
    8000343c:	c7c080e7          	jalr	-900(ra) # 800060b4 <initlock>
  log.start = sb->logstart;
    80003440:	0149a583          	lw	a1,20(s3)
    80003444:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003446:	0109a783          	lw	a5,16(s3)
    8000344a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000344c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003450:	854a                	mv	a0,s2
    80003452:	fffff097          	auipc	ra,0xfffff
    80003456:	e84080e7          	jalr	-380(ra) # 800022d6 <bread>
  log.lh.n = lh->n;
    8000345a:	4d34                	lw	a3,88(a0)
    8000345c:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000345e:	02d05663          	blez	a3,8000348a <initlog+0x76>
    80003462:	05c50793          	addi	a5,a0,92
    80003466:	00015717          	auipc	a4,0x15
    8000346a:	49a70713          	addi	a4,a4,1178 # 80018900 <log+0x30>
    8000346e:	36fd                	addiw	a3,a3,-1
    80003470:	02069613          	slli	a2,a3,0x20
    80003474:	01e65693          	srli	a3,a2,0x1e
    80003478:	06050613          	addi	a2,a0,96
    8000347c:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000347e:	4390                	lw	a2,0(a5)
    80003480:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003482:	0791                	addi	a5,a5,4
    80003484:	0711                	addi	a4,a4,4
    80003486:	fed79ce3          	bne	a5,a3,8000347e <initlog+0x6a>
  brelse(buf);
    8000348a:	fffff097          	auipc	ra,0xfffff
    8000348e:	f7c080e7          	jalr	-132(ra) # 80002406 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003492:	4505                	li	a0,1
    80003494:	00000097          	auipc	ra,0x0
    80003498:	ebc080e7          	jalr	-324(ra) # 80003350 <install_trans>
  log.lh.n = 0;
    8000349c:	00015797          	auipc	a5,0x15
    800034a0:	4607a023          	sw	zero,1120(a5) # 800188fc <log+0x2c>
  write_head(); // clear the log
    800034a4:	00000097          	auipc	ra,0x0
    800034a8:	e30080e7          	jalr	-464(ra) # 800032d4 <write_head>
}
    800034ac:	70a2                	ld	ra,40(sp)
    800034ae:	7402                	ld	s0,32(sp)
    800034b0:	64e2                	ld	s1,24(sp)
    800034b2:	6942                	ld	s2,16(sp)
    800034b4:	69a2                	ld	s3,8(sp)
    800034b6:	6145                	addi	sp,sp,48
    800034b8:	8082                	ret

00000000800034ba <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800034ba:	1101                	addi	sp,sp,-32
    800034bc:	ec06                	sd	ra,24(sp)
    800034be:	e822                	sd	s0,16(sp)
    800034c0:	e426                	sd	s1,8(sp)
    800034c2:	e04a                	sd	s2,0(sp)
    800034c4:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800034c6:	00015517          	auipc	a0,0x15
    800034ca:	40a50513          	addi	a0,a0,1034 # 800188d0 <log>
    800034ce:	00003097          	auipc	ra,0x3
    800034d2:	c76080e7          	jalr	-906(ra) # 80006144 <acquire>
  while(1){
    if(log.committing){
    800034d6:	00015497          	auipc	s1,0x15
    800034da:	3fa48493          	addi	s1,s1,1018 # 800188d0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034de:	4979                	li	s2,30
    800034e0:	a039                	j	800034ee <begin_op+0x34>
      sleep(&log, &log.lock);
    800034e2:	85a6                	mv	a1,s1
    800034e4:	8526                	mv	a0,s1
    800034e6:	ffffe097          	auipc	ra,0xffffe
    800034ea:	ffc080e7          	jalr	-4(ra) # 800014e2 <sleep>
    if(log.committing){
    800034ee:	50dc                	lw	a5,36(s1)
    800034f0:	fbed                	bnez	a5,800034e2 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034f2:	5098                	lw	a4,32(s1)
    800034f4:	2705                	addiw	a4,a4,1
    800034f6:	0007069b          	sext.w	a3,a4
    800034fa:	0027179b          	slliw	a5,a4,0x2
    800034fe:	9fb9                	addw	a5,a5,a4
    80003500:	0017979b          	slliw	a5,a5,0x1
    80003504:	54d8                	lw	a4,44(s1)
    80003506:	9fb9                	addw	a5,a5,a4
    80003508:	00f95963          	bge	s2,a5,8000351a <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000350c:	85a6                	mv	a1,s1
    8000350e:	8526                	mv	a0,s1
    80003510:	ffffe097          	auipc	ra,0xffffe
    80003514:	fd2080e7          	jalr	-46(ra) # 800014e2 <sleep>
    80003518:	bfd9                	j	800034ee <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000351a:	00015517          	auipc	a0,0x15
    8000351e:	3b650513          	addi	a0,a0,950 # 800188d0 <log>
    80003522:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003524:	00003097          	auipc	ra,0x3
    80003528:	cd4080e7          	jalr	-812(ra) # 800061f8 <release>
      break;
    }
  }
}
    8000352c:	60e2                	ld	ra,24(sp)
    8000352e:	6442                	ld	s0,16(sp)
    80003530:	64a2                	ld	s1,8(sp)
    80003532:	6902                	ld	s2,0(sp)
    80003534:	6105                	addi	sp,sp,32
    80003536:	8082                	ret

0000000080003538 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003538:	7139                	addi	sp,sp,-64
    8000353a:	fc06                	sd	ra,56(sp)
    8000353c:	f822                	sd	s0,48(sp)
    8000353e:	f426                	sd	s1,40(sp)
    80003540:	f04a                	sd	s2,32(sp)
    80003542:	ec4e                	sd	s3,24(sp)
    80003544:	e852                	sd	s4,16(sp)
    80003546:	e456                	sd	s5,8(sp)
    80003548:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000354a:	00015497          	auipc	s1,0x15
    8000354e:	38648493          	addi	s1,s1,902 # 800188d0 <log>
    80003552:	8526                	mv	a0,s1
    80003554:	00003097          	auipc	ra,0x3
    80003558:	bf0080e7          	jalr	-1040(ra) # 80006144 <acquire>
  log.outstanding -= 1;
    8000355c:	509c                	lw	a5,32(s1)
    8000355e:	37fd                	addiw	a5,a5,-1
    80003560:	0007891b          	sext.w	s2,a5
    80003564:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003566:	50dc                	lw	a5,36(s1)
    80003568:	e7b9                	bnez	a5,800035b6 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000356a:	04091e63          	bnez	s2,800035c6 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000356e:	00015497          	auipc	s1,0x15
    80003572:	36248493          	addi	s1,s1,866 # 800188d0 <log>
    80003576:	4785                	li	a5,1
    80003578:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000357a:	8526                	mv	a0,s1
    8000357c:	00003097          	auipc	ra,0x3
    80003580:	c7c080e7          	jalr	-900(ra) # 800061f8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003584:	54dc                	lw	a5,44(s1)
    80003586:	06f04763          	bgtz	a5,800035f4 <end_op+0xbc>
    acquire(&log.lock);
    8000358a:	00015497          	auipc	s1,0x15
    8000358e:	34648493          	addi	s1,s1,838 # 800188d0 <log>
    80003592:	8526                	mv	a0,s1
    80003594:	00003097          	auipc	ra,0x3
    80003598:	bb0080e7          	jalr	-1104(ra) # 80006144 <acquire>
    log.committing = 0;
    8000359c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800035a0:	8526                	mv	a0,s1
    800035a2:	ffffe097          	auipc	ra,0xffffe
    800035a6:	fa4080e7          	jalr	-92(ra) # 80001546 <wakeup>
    release(&log.lock);
    800035aa:	8526                	mv	a0,s1
    800035ac:	00003097          	auipc	ra,0x3
    800035b0:	c4c080e7          	jalr	-948(ra) # 800061f8 <release>
}
    800035b4:	a03d                	j	800035e2 <end_op+0xaa>
    panic("log.committing");
    800035b6:	00005517          	auipc	a0,0x5
    800035ba:	ffa50513          	addi	a0,a0,-6 # 800085b0 <syscalls+0x1f0>
    800035be:	00002097          	auipc	ra,0x2
    800035c2:	64e080e7          	jalr	1614(ra) # 80005c0c <panic>
    wakeup(&log);
    800035c6:	00015497          	auipc	s1,0x15
    800035ca:	30a48493          	addi	s1,s1,778 # 800188d0 <log>
    800035ce:	8526                	mv	a0,s1
    800035d0:	ffffe097          	auipc	ra,0xffffe
    800035d4:	f76080e7          	jalr	-138(ra) # 80001546 <wakeup>
  release(&log.lock);
    800035d8:	8526                	mv	a0,s1
    800035da:	00003097          	auipc	ra,0x3
    800035de:	c1e080e7          	jalr	-994(ra) # 800061f8 <release>
}
    800035e2:	70e2                	ld	ra,56(sp)
    800035e4:	7442                	ld	s0,48(sp)
    800035e6:	74a2                	ld	s1,40(sp)
    800035e8:	7902                	ld	s2,32(sp)
    800035ea:	69e2                	ld	s3,24(sp)
    800035ec:	6a42                	ld	s4,16(sp)
    800035ee:	6aa2                	ld	s5,8(sp)
    800035f0:	6121                	addi	sp,sp,64
    800035f2:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800035f4:	00015a97          	auipc	s5,0x15
    800035f8:	30ca8a93          	addi	s5,s5,780 # 80018900 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800035fc:	00015a17          	auipc	s4,0x15
    80003600:	2d4a0a13          	addi	s4,s4,724 # 800188d0 <log>
    80003604:	018a2583          	lw	a1,24(s4)
    80003608:	012585bb          	addw	a1,a1,s2
    8000360c:	2585                	addiw	a1,a1,1
    8000360e:	028a2503          	lw	a0,40(s4)
    80003612:	fffff097          	auipc	ra,0xfffff
    80003616:	cc4080e7          	jalr	-828(ra) # 800022d6 <bread>
    8000361a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000361c:	000aa583          	lw	a1,0(s5)
    80003620:	028a2503          	lw	a0,40(s4)
    80003624:	fffff097          	auipc	ra,0xfffff
    80003628:	cb2080e7          	jalr	-846(ra) # 800022d6 <bread>
    8000362c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000362e:	40000613          	li	a2,1024
    80003632:	05850593          	addi	a1,a0,88
    80003636:	05848513          	addi	a0,s1,88
    8000363a:	ffffd097          	auipc	ra,0xffffd
    8000363e:	b9c080e7          	jalr	-1124(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003642:	8526                	mv	a0,s1
    80003644:	fffff097          	auipc	ra,0xfffff
    80003648:	d84080e7          	jalr	-636(ra) # 800023c8 <bwrite>
    brelse(from);
    8000364c:	854e                	mv	a0,s3
    8000364e:	fffff097          	auipc	ra,0xfffff
    80003652:	db8080e7          	jalr	-584(ra) # 80002406 <brelse>
    brelse(to);
    80003656:	8526                	mv	a0,s1
    80003658:	fffff097          	auipc	ra,0xfffff
    8000365c:	dae080e7          	jalr	-594(ra) # 80002406 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003660:	2905                	addiw	s2,s2,1
    80003662:	0a91                	addi	s5,s5,4
    80003664:	02ca2783          	lw	a5,44(s4)
    80003668:	f8f94ee3          	blt	s2,a5,80003604 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000366c:	00000097          	auipc	ra,0x0
    80003670:	c68080e7          	jalr	-920(ra) # 800032d4 <write_head>
    install_trans(0); // Now install writes to home locations
    80003674:	4501                	li	a0,0
    80003676:	00000097          	auipc	ra,0x0
    8000367a:	cda080e7          	jalr	-806(ra) # 80003350 <install_trans>
    log.lh.n = 0;
    8000367e:	00015797          	auipc	a5,0x15
    80003682:	2607af23          	sw	zero,638(a5) # 800188fc <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003686:	00000097          	auipc	ra,0x0
    8000368a:	c4e080e7          	jalr	-946(ra) # 800032d4 <write_head>
    8000368e:	bdf5                	j	8000358a <end_op+0x52>

0000000080003690 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003690:	1101                	addi	sp,sp,-32
    80003692:	ec06                	sd	ra,24(sp)
    80003694:	e822                	sd	s0,16(sp)
    80003696:	e426                	sd	s1,8(sp)
    80003698:	e04a                	sd	s2,0(sp)
    8000369a:	1000                	addi	s0,sp,32
    8000369c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000369e:	00015917          	auipc	s2,0x15
    800036a2:	23290913          	addi	s2,s2,562 # 800188d0 <log>
    800036a6:	854a                	mv	a0,s2
    800036a8:	00003097          	auipc	ra,0x3
    800036ac:	a9c080e7          	jalr	-1380(ra) # 80006144 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800036b0:	02c92603          	lw	a2,44(s2)
    800036b4:	47f5                	li	a5,29
    800036b6:	06c7c563          	blt	a5,a2,80003720 <log_write+0x90>
    800036ba:	00015797          	auipc	a5,0x15
    800036be:	2327a783          	lw	a5,562(a5) # 800188ec <log+0x1c>
    800036c2:	37fd                	addiw	a5,a5,-1
    800036c4:	04f65e63          	bge	a2,a5,80003720 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800036c8:	00015797          	auipc	a5,0x15
    800036cc:	2287a783          	lw	a5,552(a5) # 800188f0 <log+0x20>
    800036d0:	06f05063          	blez	a5,80003730 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800036d4:	4781                	li	a5,0
    800036d6:	06c05563          	blez	a2,80003740 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036da:	44cc                	lw	a1,12(s1)
    800036dc:	00015717          	auipc	a4,0x15
    800036e0:	22470713          	addi	a4,a4,548 # 80018900 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800036e4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036e6:	4314                	lw	a3,0(a4)
    800036e8:	04b68c63          	beq	a3,a1,80003740 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800036ec:	2785                	addiw	a5,a5,1
    800036ee:	0711                	addi	a4,a4,4
    800036f0:	fef61be3          	bne	a2,a5,800036e6 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800036f4:	0621                	addi	a2,a2,8
    800036f6:	060a                	slli	a2,a2,0x2
    800036f8:	00015797          	auipc	a5,0x15
    800036fc:	1d878793          	addi	a5,a5,472 # 800188d0 <log>
    80003700:	97b2                	add	a5,a5,a2
    80003702:	44d8                	lw	a4,12(s1)
    80003704:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003706:	8526                	mv	a0,s1
    80003708:	fffff097          	auipc	ra,0xfffff
    8000370c:	d9c080e7          	jalr	-612(ra) # 800024a4 <bpin>
    log.lh.n++;
    80003710:	00015717          	auipc	a4,0x15
    80003714:	1c070713          	addi	a4,a4,448 # 800188d0 <log>
    80003718:	575c                	lw	a5,44(a4)
    8000371a:	2785                	addiw	a5,a5,1
    8000371c:	d75c                	sw	a5,44(a4)
    8000371e:	a82d                	j	80003758 <log_write+0xc8>
    panic("too big a transaction");
    80003720:	00005517          	auipc	a0,0x5
    80003724:	ea050513          	addi	a0,a0,-352 # 800085c0 <syscalls+0x200>
    80003728:	00002097          	auipc	ra,0x2
    8000372c:	4e4080e7          	jalr	1252(ra) # 80005c0c <panic>
    panic("log_write outside of trans");
    80003730:	00005517          	auipc	a0,0x5
    80003734:	ea850513          	addi	a0,a0,-344 # 800085d8 <syscalls+0x218>
    80003738:	00002097          	auipc	ra,0x2
    8000373c:	4d4080e7          	jalr	1236(ra) # 80005c0c <panic>
  log.lh.block[i] = b->blockno;
    80003740:	00878693          	addi	a3,a5,8
    80003744:	068a                	slli	a3,a3,0x2
    80003746:	00015717          	auipc	a4,0x15
    8000374a:	18a70713          	addi	a4,a4,394 # 800188d0 <log>
    8000374e:	9736                	add	a4,a4,a3
    80003750:	44d4                	lw	a3,12(s1)
    80003752:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003754:	faf609e3          	beq	a2,a5,80003706 <log_write+0x76>
  }
  release(&log.lock);
    80003758:	00015517          	auipc	a0,0x15
    8000375c:	17850513          	addi	a0,a0,376 # 800188d0 <log>
    80003760:	00003097          	auipc	ra,0x3
    80003764:	a98080e7          	jalr	-1384(ra) # 800061f8 <release>
}
    80003768:	60e2                	ld	ra,24(sp)
    8000376a:	6442                	ld	s0,16(sp)
    8000376c:	64a2                	ld	s1,8(sp)
    8000376e:	6902                	ld	s2,0(sp)
    80003770:	6105                	addi	sp,sp,32
    80003772:	8082                	ret

0000000080003774 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003774:	1101                	addi	sp,sp,-32
    80003776:	ec06                	sd	ra,24(sp)
    80003778:	e822                	sd	s0,16(sp)
    8000377a:	e426                	sd	s1,8(sp)
    8000377c:	e04a                	sd	s2,0(sp)
    8000377e:	1000                	addi	s0,sp,32
    80003780:	84aa                	mv	s1,a0
    80003782:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003784:	00005597          	auipc	a1,0x5
    80003788:	e7458593          	addi	a1,a1,-396 # 800085f8 <syscalls+0x238>
    8000378c:	0521                	addi	a0,a0,8
    8000378e:	00003097          	auipc	ra,0x3
    80003792:	926080e7          	jalr	-1754(ra) # 800060b4 <initlock>
  lk->name = name;
    80003796:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000379a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000379e:	0204a423          	sw	zero,40(s1)
}
    800037a2:	60e2                	ld	ra,24(sp)
    800037a4:	6442                	ld	s0,16(sp)
    800037a6:	64a2                	ld	s1,8(sp)
    800037a8:	6902                	ld	s2,0(sp)
    800037aa:	6105                	addi	sp,sp,32
    800037ac:	8082                	ret

00000000800037ae <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800037ae:	1101                	addi	sp,sp,-32
    800037b0:	ec06                	sd	ra,24(sp)
    800037b2:	e822                	sd	s0,16(sp)
    800037b4:	e426                	sd	s1,8(sp)
    800037b6:	e04a                	sd	s2,0(sp)
    800037b8:	1000                	addi	s0,sp,32
    800037ba:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037bc:	00850913          	addi	s2,a0,8
    800037c0:	854a                	mv	a0,s2
    800037c2:	00003097          	auipc	ra,0x3
    800037c6:	982080e7          	jalr	-1662(ra) # 80006144 <acquire>
  while (lk->locked) {
    800037ca:	409c                	lw	a5,0(s1)
    800037cc:	cb89                	beqz	a5,800037de <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800037ce:	85ca                	mv	a1,s2
    800037d0:	8526                	mv	a0,s1
    800037d2:	ffffe097          	auipc	ra,0xffffe
    800037d6:	d10080e7          	jalr	-752(ra) # 800014e2 <sleep>
  while (lk->locked) {
    800037da:	409c                	lw	a5,0(s1)
    800037dc:	fbed                	bnez	a5,800037ce <acquiresleep+0x20>
  }
  lk->locked = 1;
    800037de:	4785                	li	a5,1
    800037e0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800037e2:	ffffd097          	auipc	ra,0xffffd
    800037e6:	658080e7          	jalr	1624(ra) # 80000e3a <myproc>
    800037ea:	591c                	lw	a5,48(a0)
    800037ec:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800037ee:	854a                	mv	a0,s2
    800037f0:	00003097          	auipc	ra,0x3
    800037f4:	a08080e7          	jalr	-1528(ra) # 800061f8 <release>
}
    800037f8:	60e2                	ld	ra,24(sp)
    800037fa:	6442                	ld	s0,16(sp)
    800037fc:	64a2                	ld	s1,8(sp)
    800037fe:	6902                	ld	s2,0(sp)
    80003800:	6105                	addi	sp,sp,32
    80003802:	8082                	ret

0000000080003804 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003804:	1101                	addi	sp,sp,-32
    80003806:	ec06                	sd	ra,24(sp)
    80003808:	e822                	sd	s0,16(sp)
    8000380a:	e426                	sd	s1,8(sp)
    8000380c:	e04a                	sd	s2,0(sp)
    8000380e:	1000                	addi	s0,sp,32
    80003810:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003812:	00850913          	addi	s2,a0,8
    80003816:	854a                	mv	a0,s2
    80003818:	00003097          	auipc	ra,0x3
    8000381c:	92c080e7          	jalr	-1748(ra) # 80006144 <acquire>
  lk->locked = 0;
    80003820:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003824:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003828:	8526                	mv	a0,s1
    8000382a:	ffffe097          	auipc	ra,0xffffe
    8000382e:	d1c080e7          	jalr	-740(ra) # 80001546 <wakeup>
  release(&lk->lk);
    80003832:	854a                	mv	a0,s2
    80003834:	00003097          	auipc	ra,0x3
    80003838:	9c4080e7          	jalr	-1596(ra) # 800061f8 <release>
}
    8000383c:	60e2                	ld	ra,24(sp)
    8000383e:	6442                	ld	s0,16(sp)
    80003840:	64a2                	ld	s1,8(sp)
    80003842:	6902                	ld	s2,0(sp)
    80003844:	6105                	addi	sp,sp,32
    80003846:	8082                	ret

0000000080003848 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003848:	7179                	addi	sp,sp,-48
    8000384a:	f406                	sd	ra,40(sp)
    8000384c:	f022                	sd	s0,32(sp)
    8000384e:	ec26                	sd	s1,24(sp)
    80003850:	e84a                	sd	s2,16(sp)
    80003852:	e44e                	sd	s3,8(sp)
    80003854:	1800                	addi	s0,sp,48
    80003856:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003858:	00850913          	addi	s2,a0,8
    8000385c:	854a                	mv	a0,s2
    8000385e:	00003097          	auipc	ra,0x3
    80003862:	8e6080e7          	jalr	-1818(ra) # 80006144 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003866:	409c                	lw	a5,0(s1)
    80003868:	ef99                	bnez	a5,80003886 <holdingsleep+0x3e>
    8000386a:	4481                	li	s1,0
  release(&lk->lk);
    8000386c:	854a                	mv	a0,s2
    8000386e:	00003097          	auipc	ra,0x3
    80003872:	98a080e7          	jalr	-1654(ra) # 800061f8 <release>
  return r;
}
    80003876:	8526                	mv	a0,s1
    80003878:	70a2                	ld	ra,40(sp)
    8000387a:	7402                	ld	s0,32(sp)
    8000387c:	64e2                	ld	s1,24(sp)
    8000387e:	6942                	ld	s2,16(sp)
    80003880:	69a2                	ld	s3,8(sp)
    80003882:	6145                	addi	sp,sp,48
    80003884:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003886:	0284a983          	lw	s3,40(s1)
    8000388a:	ffffd097          	auipc	ra,0xffffd
    8000388e:	5b0080e7          	jalr	1456(ra) # 80000e3a <myproc>
    80003892:	5904                	lw	s1,48(a0)
    80003894:	413484b3          	sub	s1,s1,s3
    80003898:	0014b493          	seqz	s1,s1
    8000389c:	bfc1                	j	8000386c <holdingsleep+0x24>

000000008000389e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000389e:	1141                	addi	sp,sp,-16
    800038a0:	e406                	sd	ra,8(sp)
    800038a2:	e022                	sd	s0,0(sp)
    800038a4:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800038a6:	00005597          	auipc	a1,0x5
    800038aa:	d6258593          	addi	a1,a1,-670 # 80008608 <syscalls+0x248>
    800038ae:	00015517          	auipc	a0,0x15
    800038b2:	16a50513          	addi	a0,a0,362 # 80018a18 <ftable>
    800038b6:	00002097          	auipc	ra,0x2
    800038ba:	7fe080e7          	jalr	2046(ra) # 800060b4 <initlock>
}
    800038be:	60a2                	ld	ra,8(sp)
    800038c0:	6402                	ld	s0,0(sp)
    800038c2:	0141                	addi	sp,sp,16
    800038c4:	8082                	ret

00000000800038c6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800038c6:	1101                	addi	sp,sp,-32
    800038c8:	ec06                	sd	ra,24(sp)
    800038ca:	e822                	sd	s0,16(sp)
    800038cc:	e426                	sd	s1,8(sp)
    800038ce:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800038d0:	00015517          	auipc	a0,0x15
    800038d4:	14850513          	addi	a0,a0,328 # 80018a18 <ftable>
    800038d8:	00003097          	auipc	ra,0x3
    800038dc:	86c080e7          	jalr	-1940(ra) # 80006144 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038e0:	00015497          	auipc	s1,0x15
    800038e4:	15048493          	addi	s1,s1,336 # 80018a30 <ftable+0x18>
    800038e8:	00016717          	auipc	a4,0x16
    800038ec:	0e870713          	addi	a4,a4,232 # 800199d0 <disk>
    if(f->ref == 0){
    800038f0:	40dc                	lw	a5,4(s1)
    800038f2:	cf99                	beqz	a5,80003910 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038f4:	02848493          	addi	s1,s1,40
    800038f8:	fee49ce3          	bne	s1,a4,800038f0 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800038fc:	00015517          	auipc	a0,0x15
    80003900:	11c50513          	addi	a0,a0,284 # 80018a18 <ftable>
    80003904:	00003097          	auipc	ra,0x3
    80003908:	8f4080e7          	jalr	-1804(ra) # 800061f8 <release>
  return 0;
    8000390c:	4481                	li	s1,0
    8000390e:	a819                	j	80003924 <filealloc+0x5e>
      f->ref = 1;
    80003910:	4785                	li	a5,1
    80003912:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003914:	00015517          	auipc	a0,0x15
    80003918:	10450513          	addi	a0,a0,260 # 80018a18 <ftable>
    8000391c:	00003097          	auipc	ra,0x3
    80003920:	8dc080e7          	jalr	-1828(ra) # 800061f8 <release>
}
    80003924:	8526                	mv	a0,s1
    80003926:	60e2                	ld	ra,24(sp)
    80003928:	6442                	ld	s0,16(sp)
    8000392a:	64a2                	ld	s1,8(sp)
    8000392c:	6105                	addi	sp,sp,32
    8000392e:	8082                	ret

0000000080003930 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003930:	1101                	addi	sp,sp,-32
    80003932:	ec06                	sd	ra,24(sp)
    80003934:	e822                	sd	s0,16(sp)
    80003936:	e426                	sd	s1,8(sp)
    80003938:	1000                	addi	s0,sp,32
    8000393a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000393c:	00015517          	auipc	a0,0x15
    80003940:	0dc50513          	addi	a0,a0,220 # 80018a18 <ftable>
    80003944:	00003097          	auipc	ra,0x3
    80003948:	800080e7          	jalr	-2048(ra) # 80006144 <acquire>
  if(f->ref < 1)
    8000394c:	40dc                	lw	a5,4(s1)
    8000394e:	02f05263          	blez	a5,80003972 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003952:	2785                	addiw	a5,a5,1
    80003954:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003956:	00015517          	auipc	a0,0x15
    8000395a:	0c250513          	addi	a0,a0,194 # 80018a18 <ftable>
    8000395e:	00003097          	auipc	ra,0x3
    80003962:	89a080e7          	jalr	-1894(ra) # 800061f8 <release>
  return f;
}
    80003966:	8526                	mv	a0,s1
    80003968:	60e2                	ld	ra,24(sp)
    8000396a:	6442                	ld	s0,16(sp)
    8000396c:	64a2                	ld	s1,8(sp)
    8000396e:	6105                	addi	sp,sp,32
    80003970:	8082                	ret
    panic("filedup");
    80003972:	00005517          	auipc	a0,0x5
    80003976:	c9e50513          	addi	a0,a0,-866 # 80008610 <syscalls+0x250>
    8000397a:	00002097          	auipc	ra,0x2
    8000397e:	292080e7          	jalr	658(ra) # 80005c0c <panic>

0000000080003982 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003982:	7139                	addi	sp,sp,-64
    80003984:	fc06                	sd	ra,56(sp)
    80003986:	f822                	sd	s0,48(sp)
    80003988:	f426                	sd	s1,40(sp)
    8000398a:	f04a                	sd	s2,32(sp)
    8000398c:	ec4e                	sd	s3,24(sp)
    8000398e:	e852                	sd	s4,16(sp)
    80003990:	e456                	sd	s5,8(sp)
    80003992:	0080                	addi	s0,sp,64
    80003994:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003996:	00015517          	auipc	a0,0x15
    8000399a:	08250513          	addi	a0,a0,130 # 80018a18 <ftable>
    8000399e:	00002097          	auipc	ra,0x2
    800039a2:	7a6080e7          	jalr	1958(ra) # 80006144 <acquire>
  if(f->ref < 1)
    800039a6:	40dc                	lw	a5,4(s1)
    800039a8:	06f05163          	blez	a5,80003a0a <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800039ac:	37fd                	addiw	a5,a5,-1
    800039ae:	0007871b          	sext.w	a4,a5
    800039b2:	c0dc                	sw	a5,4(s1)
    800039b4:	06e04363          	bgtz	a4,80003a1a <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800039b8:	0004a903          	lw	s2,0(s1)
    800039bc:	0094ca83          	lbu	s5,9(s1)
    800039c0:	0104ba03          	ld	s4,16(s1)
    800039c4:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800039c8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800039cc:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800039d0:	00015517          	auipc	a0,0x15
    800039d4:	04850513          	addi	a0,a0,72 # 80018a18 <ftable>
    800039d8:	00003097          	auipc	ra,0x3
    800039dc:	820080e7          	jalr	-2016(ra) # 800061f8 <release>

  if(ff.type == FD_PIPE){
    800039e0:	4785                	li	a5,1
    800039e2:	04f90d63          	beq	s2,a5,80003a3c <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800039e6:	3979                	addiw	s2,s2,-2
    800039e8:	4785                	li	a5,1
    800039ea:	0527e063          	bltu	a5,s2,80003a2a <fileclose+0xa8>
    begin_op();
    800039ee:	00000097          	auipc	ra,0x0
    800039f2:	acc080e7          	jalr	-1332(ra) # 800034ba <begin_op>
    iput(ff.ip);
    800039f6:	854e                	mv	a0,s3
    800039f8:	fffff097          	auipc	ra,0xfffff
    800039fc:	2b0080e7          	jalr	688(ra) # 80002ca8 <iput>
    end_op();
    80003a00:	00000097          	auipc	ra,0x0
    80003a04:	b38080e7          	jalr	-1224(ra) # 80003538 <end_op>
    80003a08:	a00d                	j	80003a2a <fileclose+0xa8>
    panic("fileclose");
    80003a0a:	00005517          	auipc	a0,0x5
    80003a0e:	c0e50513          	addi	a0,a0,-1010 # 80008618 <syscalls+0x258>
    80003a12:	00002097          	auipc	ra,0x2
    80003a16:	1fa080e7          	jalr	506(ra) # 80005c0c <panic>
    release(&ftable.lock);
    80003a1a:	00015517          	auipc	a0,0x15
    80003a1e:	ffe50513          	addi	a0,a0,-2 # 80018a18 <ftable>
    80003a22:	00002097          	auipc	ra,0x2
    80003a26:	7d6080e7          	jalr	2006(ra) # 800061f8 <release>
  }
}
    80003a2a:	70e2                	ld	ra,56(sp)
    80003a2c:	7442                	ld	s0,48(sp)
    80003a2e:	74a2                	ld	s1,40(sp)
    80003a30:	7902                	ld	s2,32(sp)
    80003a32:	69e2                	ld	s3,24(sp)
    80003a34:	6a42                	ld	s4,16(sp)
    80003a36:	6aa2                	ld	s5,8(sp)
    80003a38:	6121                	addi	sp,sp,64
    80003a3a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a3c:	85d6                	mv	a1,s5
    80003a3e:	8552                	mv	a0,s4
    80003a40:	00000097          	auipc	ra,0x0
    80003a44:	394080e7          	jalr	916(ra) # 80003dd4 <pipeclose>
    80003a48:	b7cd                	j	80003a2a <fileclose+0xa8>

0000000080003a4a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a4a:	715d                	addi	sp,sp,-80
    80003a4c:	e486                	sd	ra,72(sp)
    80003a4e:	e0a2                	sd	s0,64(sp)
    80003a50:	fc26                	sd	s1,56(sp)
    80003a52:	f84a                	sd	s2,48(sp)
    80003a54:	f44e                	sd	s3,40(sp)
    80003a56:	0880                	addi	s0,sp,80
    80003a58:	84aa                	mv	s1,a0
    80003a5a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003a5c:	ffffd097          	auipc	ra,0xffffd
    80003a60:	3de080e7          	jalr	990(ra) # 80000e3a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003a64:	409c                	lw	a5,0(s1)
    80003a66:	37f9                	addiw	a5,a5,-2
    80003a68:	4705                	li	a4,1
    80003a6a:	04f76763          	bltu	a4,a5,80003ab8 <filestat+0x6e>
    80003a6e:	892a                	mv	s2,a0
    ilock(f->ip);
    80003a70:	6c88                	ld	a0,24(s1)
    80003a72:	fffff097          	auipc	ra,0xfffff
    80003a76:	07c080e7          	jalr	124(ra) # 80002aee <ilock>
    stati(f->ip, &st);
    80003a7a:	fb840593          	addi	a1,s0,-72
    80003a7e:	6c88                	ld	a0,24(s1)
    80003a80:	fffff097          	auipc	ra,0xfffff
    80003a84:	2f8080e7          	jalr	760(ra) # 80002d78 <stati>
    iunlock(f->ip);
    80003a88:	6c88                	ld	a0,24(s1)
    80003a8a:	fffff097          	auipc	ra,0xfffff
    80003a8e:	126080e7          	jalr	294(ra) # 80002bb0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003a92:	46e1                	li	a3,24
    80003a94:	fb840613          	addi	a2,s0,-72
    80003a98:	85ce                	mv	a1,s3
    80003a9a:	05093503          	ld	a0,80(s2)
    80003a9e:	ffffd097          	auipc	ra,0xffffd
    80003aa2:	05c080e7          	jalr	92(ra) # 80000afa <copyout>
    80003aa6:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003aaa:	60a6                	ld	ra,72(sp)
    80003aac:	6406                	ld	s0,64(sp)
    80003aae:	74e2                	ld	s1,56(sp)
    80003ab0:	7942                	ld	s2,48(sp)
    80003ab2:	79a2                	ld	s3,40(sp)
    80003ab4:	6161                	addi	sp,sp,80
    80003ab6:	8082                	ret
  return -1;
    80003ab8:	557d                	li	a0,-1
    80003aba:	bfc5                	j	80003aaa <filestat+0x60>

0000000080003abc <mapfile>:

void mapfile(struct file * f, char * mem, int offset){
    80003abc:	7179                	addi	sp,sp,-48
    80003abe:	f406                	sd	ra,40(sp)
    80003ac0:	f022                	sd	s0,32(sp)
    80003ac2:	ec26                	sd	s1,24(sp)
    80003ac4:	e84a                	sd	s2,16(sp)
    80003ac6:	e44e                	sd	s3,8(sp)
    80003ac8:	1800                	addi	s0,sp,48
    80003aca:	84aa                	mv	s1,a0
    80003acc:	892e                	mv	s2,a1
    80003ace:	89b2                	mv	s3,a2
//  printf("off %d\n", offset);
  ilock(f->ip);
    80003ad0:	6d08                	ld	a0,24(a0)
    80003ad2:	fffff097          	auipc	ra,0xfffff
    80003ad6:	01c080e7          	jalr	28(ra) # 80002aee <ilock>
  readi(f->ip, 0, (uint64) mem, offset, PGSIZE);
    80003ada:	6705                	lui	a4,0x1
    80003adc:	86ce                	mv	a3,s3
    80003ade:	864a                	mv	a2,s2
    80003ae0:	4581                	li	a1,0
    80003ae2:	6c88                	ld	a0,24(s1)
    80003ae4:	fffff097          	auipc	ra,0xfffff
    80003ae8:	2be080e7          	jalr	702(ra) # 80002da2 <readi>
  iunlock(f->ip);
    80003aec:	6c88                	ld	a0,24(s1)
    80003aee:	fffff097          	auipc	ra,0xfffff
    80003af2:	0c2080e7          	jalr	194(ra) # 80002bb0 <iunlock>
}
    80003af6:	70a2                	ld	ra,40(sp)
    80003af8:	7402                	ld	s0,32(sp)
    80003afa:	64e2                	ld	s1,24(sp)
    80003afc:	6942                	ld	s2,16(sp)
    80003afe:	69a2                	ld	s3,8(sp)
    80003b00:	6145                	addi	sp,sp,48
    80003b02:	8082                	ret

0000000080003b04 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b04:	7179                	addi	sp,sp,-48
    80003b06:	f406                	sd	ra,40(sp)
    80003b08:	f022                	sd	s0,32(sp)
    80003b0a:	ec26                	sd	s1,24(sp)
    80003b0c:	e84a                	sd	s2,16(sp)
    80003b0e:	e44e                	sd	s3,8(sp)
    80003b10:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b12:	00854783          	lbu	a5,8(a0)
    80003b16:	c3d5                	beqz	a5,80003bba <fileread+0xb6>
    80003b18:	84aa                	mv	s1,a0
    80003b1a:	89ae                	mv	s3,a1
    80003b1c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b1e:	411c                	lw	a5,0(a0)
    80003b20:	4705                	li	a4,1
    80003b22:	04e78963          	beq	a5,a4,80003b74 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b26:	470d                	li	a4,3
    80003b28:	04e78d63          	beq	a5,a4,80003b82 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b2c:	4709                	li	a4,2
    80003b2e:	06e79e63          	bne	a5,a4,80003baa <fileread+0xa6>
    ilock(f->ip);
    80003b32:	6d08                	ld	a0,24(a0)
    80003b34:	fffff097          	auipc	ra,0xfffff
    80003b38:	fba080e7          	jalr	-70(ra) # 80002aee <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003b3c:	874a                	mv	a4,s2
    80003b3e:	5094                	lw	a3,32(s1)
    80003b40:	864e                	mv	a2,s3
    80003b42:	4585                	li	a1,1
    80003b44:	6c88                	ld	a0,24(s1)
    80003b46:	fffff097          	auipc	ra,0xfffff
    80003b4a:	25c080e7          	jalr	604(ra) # 80002da2 <readi>
    80003b4e:	892a                	mv	s2,a0
    80003b50:	00a05563          	blez	a0,80003b5a <fileread+0x56>
      f->off += r;
    80003b54:	509c                	lw	a5,32(s1)
    80003b56:	9fa9                	addw	a5,a5,a0
    80003b58:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003b5a:	6c88                	ld	a0,24(s1)
    80003b5c:	fffff097          	auipc	ra,0xfffff
    80003b60:	054080e7          	jalr	84(ra) # 80002bb0 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003b64:	854a                	mv	a0,s2
    80003b66:	70a2                	ld	ra,40(sp)
    80003b68:	7402                	ld	s0,32(sp)
    80003b6a:	64e2                	ld	s1,24(sp)
    80003b6c:	6942                	ld	s2,16(sp)
    80003b6e:	69a2                	ld	s3,8(sp)
    80003b70:	6145                	addi	sp,sp,48
    80003b72:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b74:	6908                	ld	a0,16(a0)
    80003b76:	00000097          	auipc	ra,0x0
    80003b7a:	3c6080e7          	jalr	966(ra) # 80003f3c <piperead>
    80003b7e:	892a                	mv	s2,a0
    80003b80:	b7d5                	j	80003b64 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b82:	02451783          	lh	a5,36(a0)
    80003b86:	03079693          	slli	a3,a5,0x30
    80003b8a:	92c1                	srli	a3,a3,0x30
    80003b8c:	4725                	li	a4,9
    80003b8e:	02d76863          	bltu	a4,a3,80003bbe <fileread+0xba>
    80003b92:	0792                	slli	a5,a5,0x4
    80003b94:	00015717          	auipc	a4,0x15
    80003b98:	de470713          	addi	a4,a4,-540 # 80018978 <devsw>
    80003b9c:	97ba                	add	a5,a5,a4
    80003b9e:	639c                	ld	a5,0(a5)
    80003ba0:	c38d                	beqz	a5,80003bc2 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003ba2:	4505                	li	a0,1
    80003ba4:	9782                	jalr	a5
    80003ba6:	892a                	mv	s2,a0
    80003ba8:	bf75                	j	80003b64 <fileread+0x60>
    panic("fileread");
    80003baa:	00005517          	auipc	a0,0x5
    80003bae:	a7e50513          	addi	a0,a0,-1410 # 80008628 <syscalls+0x268>
    80003bb2:	00002097          	auipc	ra,0x2
    80003bb6:	05a080e7          	jalr	90(ra) # 80005c0c <panic>
    return -1;
    80003bba:	597d                	li	s2,-1
    80003bbc:	b765                	j	80003b64 <fileread+0x60>
      return -1;
    80003bbe:	597d                	li	s2,-1
    80003bc0:	b755                	j	80003b64 <fileread+0x60>
    80003bc2:	597d                	li	s2,-1
    80003bc4:	b745                	j	80003b64 <fileread+0x60>

0000000080003bc6 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003bc6:	715d                	addi	sp,sp,-80
    80003bc8:	e486                	sd	ra,72(sp)
    80003bca:	e0a2                	sd	s0,64(sp)
    80003bcc:	fc26                	sd	s1,56(sp)
    80003bce:	f84a                	sd	s2,48(sp)
    80003bd0:	f44e                	sd	s3,40(sp)
    80003bd2:	f052                	sd	s4,32(sp)
    80003bd4:	ec56                	sd	s5,24(sp)
    80003bd6:	e85a                	sd	s6,16(sp)
    80003bd8:	e45e                	sd	s7,8(sp)
    80003bda:	e062                	sd	s8,0(sp)
    80003bdc:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003bde:	00954783          	lbu	a5,9(a0)
    80003be2:	10078663          	beqz	a5,80003cee <filewrite+0x128>
    80003be6:	892a                	mv	s2,a0
    80003be8:	8b2e                	mv	s6,a1
    80003bea:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bec:	411c                	lw	a5,0(a0)
    80003bee:	4705                	li	a4,1
    80003bf0:	02e78263          	beq	a5,a4,80003c14 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bf4:	470d                	li	a4,3
    80003bf6:	02e78663          	beq	a5,a4,80003c22 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bfa:	4709                	li	a4,2
    80003bfc:	0ee79163          	bne	a5,a4,80003cde <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c00:	0ac05d63          	blez	a2,80003cba <filewrite+0xf4>
    int i = 0;
    80003c04:	4981                	li	s3,0
    80003c06:	6b85                	lui	s7,0x1
    80003c08:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003c0c:	6c05                	lui	s8,0x1
    80003c0e:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003c12:	a861                	j	80003caa <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003c14:	6908                	ld	a0,16(a0)
    80003c16:	00000097          	auipc	ra,0x0
    80003c1a:	22e080e7          	jalr	558(ra) # 80003e44 <pipewrite>
    80003c1e:	8a2a                	mv	s4,a0
    80003c20:	a045                	j	80003cc0 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c22:	02451783          	lh	a5,36(a0)
    80003c26:	03079693          	slli	a3,a5,0x30
    80003c2a:	92c1                	srli	a3,a3,0x30
    80003c2c:	4725                	li	a4,9
    80003c2e:	0cd76263          	bltu	a4,a3,80003cf2 <filewrite+0x12c>
    80003c32:	0792                	slli	a5,a5,0x4
    80003c34:	00015717          	auipc	a4,0x15
    80003c38:	d4470713          	addi	a4,a4,-700 # 80018978 <devsw>
    80003c3c:	97ba                	add	a5,a5,a4
    80003c3e:	679c                	ld	a5,8(a5)
    80003c40:	cbdd                	beqz	a5,80003cf6 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003c42:	4505                	li	a0,1
    80003c44:	9782                	jalr	a5
    80003c46:	8a2a                	mv	s4,a0
    80003c48:	a8a5                	j	80003cc0 <filewrite+0xfa>
    80003c4a:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003c4e:	00000097          	auipc	ra,0x0
    80003c52:	86c080e7          	jalr	-1940(ra) # 800034ba <begin_op>
      ilock(f->ip);
    80003c56:	01893503          	ld	a0,24(s2)
    80003c5a:	fffff097          	auipc	ra,0xfffff
    80003c5e:	e94080e7          	jalr	-364(ra) # 80002aee <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c62:	8756                	mv	a4,s5
    80003c64:	02092683          	lw	a3,32(s2)
    80003c68:	01698633          	add	a2,s3,s6
    80003c6c:	4585                	li	a1,1
    80003c6e:	01893503          	ld	a0,24(s2)
    80003c72:	fffff097          	auipc	ra,0xfffff
    80003c76:	228080e7          	jalr	552(ra) # 80002e9a <writei>
    80003c7a:	84aa                	mv	s1,a0
    80003c7c:	00a05763          	blez	a0,80003c8a <filewrite+0xc4>
        f->off += r;
    80003c80:	02092783          	lw	a5,32(s2)
    80003c84:	9fa9                	addw	a5,a5,a0
    80003c86:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c8a:	01893503          	ld	a0,24(s2)
    80003c8e:	fffff097          	auipc	ra,0xfffff
    80003c92:	f22080e7          	jalr	-222(ra) # 80002bb0 <iunlock>
      end_op();
    80003c96:	00000097          	auipc	ra,0x0
    80003c9a:	8a2080e7          	jalr	-1886(ra) # 80003538 <end_op>

      if(r != n1){
    80003c9e:	009a9f63          	bne	s5,s1,80003cbc <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003ca2:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003ca6:	0149db63          	bge	s3,s4,80003cbc <filewrite+0xf6>
      int n1 = n - i;
    80003caa:	413a04bb          	subw	s1,s4,s3
    80003cae:	0004879b          	sext.w	a5,s1
    80003cb2:	f8fbdce3          	bge	s7,a5,80003c4a <filewrite+0x84>
    80003cb6:	84e2                	mv	s1,s8
    80003cb8:	bf49                	j	80003c4a <filewrite+0x84>
    int i = 0;
    80003cba:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003cbc:	013a1f63          	bne	s4,s3,80003cda <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003cc0:	8552                	mv	a0,s4
    80003cc2:	60a6                	ld	ra,72(sp)
    80003cc4:	6406                	ld	s0,64(sp)
    80003cc6:	74e2                	ld	s1,56(sp)
    80003cc8:	7942                	ld	s2,48(sp)
    80003cca:	79a2                	ld	s3,40(sp)
    80003ccc:	7a02                	ld	s4,32(sp)
    80003cce:	6ae2                	ld	s5,24(sp)
    80003cd0:	6b42                	ld	s6,16(sp)
    80003cd2:	6ba2                	ld	s7,8(sp)
    80003cd4:	6c02                	ld	s8,0(sp)
    80003cd6:	6161                	addi	sp,sp,80
    80003cd8:	8082                	ret
    ret = (i == n ? n : -1);
    80003cda:	5a7d                	li	s4,-1
    80003cdc:	b7d5                	j	80003cc0 <filewrite+0xfa>
    panic("filewrite");
    80003cde:	00005517          	auipc	a0,0x5
    80003ce2:	95a50513          	addi	a0,a0,-1702 # 80008638 <syscalls+0x278>
    80003ce6:	00002097          	auipc	ra,0x2
    80003cea:	f26080e7          	jalr	-218(ra) # 80005c0c <panic>
    return -1;
    80003cee:	5a7d                	li	s4,-1
    80003cf0:	bfc1                	j	80003cc0 <filewrite+0xfa>
      return -1;
    80003cf2:	5a7d                	li	s4,-1
    80003cf4:	b7f1                	j	80003cc0 <filewrite+0xfa>
    80003cf6:	5a7d                	li	s4,-1
    80003cf8:	b7e1                	j	80003cc0 <filewrite+0xfa>

0000000080003cfa <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003cfa:	7179                	addi	sp,sp,-48
    80003cfc:	f406                	sd	ra,40(sp)
    80003cfe:	f022                	sd	s0,32(sp)
    80003d00:	ec26                	sd	s1,24(sp)
    80003d02:	e84a                	sd	s2,16(sp)
    80003d04:	e44e                	sd	s3,8(sp)
    80003d06:	e052                	sd	s4,0(sp)
    80003d08:	1800                	addi	s0,sp,48
    80003d0a:	84aa                	mv	s1,a0
    80003d0c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d0e:	0005b023          	sd	zero,0(a1)
    80003d12:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d16:	00000097          	auipc	ra,0x0
    80003d1a:	bb0080e7          	jalr	-1104(ra) # 800038c6 <filealloc>
    80003d1e:	e088                	sd	a0,0(s1)
    80003d20:	c551                	beqz	a0,80003dac <pipealloc+0xb2>
    80003d22:	00000097          	auipc	ra,0x0
    80003d26:	ba4080e7          	jalr	-1116(ra) # 800038c6 <filealloc>
    80003d2a:	00aa3023          	sd	a0,0(s4)
    80003d2e:	c92d                	beqz	a0,80003da0 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d30:	ffffc097          	auipc	ra,0xffffc
    80003d34:	3ea080e7          	jalr	1002(ra) # 8000011a <kalloc>
    80003d38:	892a                	mv	s2,a0
    80003d3a:	c125                	beqz	a0,80003d9a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003d3c:	4985                	li	s3,1
    80003d3e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d42:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d46:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d4a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d4e:	00005597          	auipc	a1,0x5
    80003d52:	8fa58593          	addi	a1,a1,-1798 # 80008648 <syscalls+0x288>
    80003d56:	00002097          	auipc	ra,0x2
    80003d5a:	35e080e7          	jalr	862(ra) # 800060b4 <initlock>
  (*f0)->type = FD_PIPE;
    80003d5e:	609c                	ld	a5,0(s1)
    80003d60:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d64:	609c                	ld	a5,0(s1)
    80003d66:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d6a:	609c                	ld	a5,0(s1)
    80003d6c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d70:	609c                	ld	a5,0(s1)
    80003d72:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d76:	000a3783          	ld	a5,0(s4)
    80003d7a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d7e:	000a3783          	ld	a5,0(s4)
    80003d82:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d86:	000a3783          	ld	a5,0(s4)
    80003d8a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d8e:	000a3783          	ld	a5,0(s4)
    80003d92:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d96:	4501                	li	a0,0
    80003d98:	a025                	j	80003dc0 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d9a:	6088                	ld	a0,0(s1)
    80003d9c:	e501                	bnez	a0,80003da4 <pipealloc+0xaa>
    80003d9e:	a039                	j	80003dac <pipealloc+0xb2>
    80003da0:	6088                	ld	a0,0(s1)
    80003da2:	c51d                	beqz	a0,80003dd0 <pipealloc+0xd6>
    fileclose(*f0);
    80003da4:	00000097          	auipc	ra,0x0
    80003da8:	bde080e7          	jalr	-1058(ra) # 80003982 <fileclose>
  if(*f1)
    80003dac:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003db0:	557d                	li	a0,-1
  if(*f1)
    80003db2:	c799                	beqz	a5,80003dc0 <pipealloc+0xc6>
    fileclose(*f1);
    80003db4:	853e                	mv	a0,a5
    80003db6:	00000097          	auipc	ra,0x0
    80003dba:	bcc080e7          	jalr	-1076(ra) # 80003982 <fileclose>
  return -1;
    80003dbe:	557d                	li	a0,-1
}
    80003dc0:	70a2                	ld	ra,40(sp)
    80003dc2:	7402                	ld	s0,32(sp)
    80003dc4:	64e2                	ld	s1,24(sp)
    80003dc6:	6942                	ld	s2,16(sp)
    80003dc8:	69a2                	ld	s3,8(sp)
    80003dca:	6a02                	ld	s4,0(sp)
    80003dcc:	6145                	addi	sp,sp,48
    80003dce:	8082                	ret
  return -1;
    80003dd0:	557d                	li	a0,-1
    80003dd2:	b7fd                	j	80003dc0 <pipealloc+0xc6>

0000000080003dd4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003dd4:	1101                	addi	sp,sp,-32
    80003dd6:	ec06                	sd	ra,24(sp)
    80003dd8:	e822                	sd	s0,16(sp)
    80003dda:	e426                	sd	s1,8(sp)
    80003ddc:	e04a                	sd	s2,0(sp)
    80003dde:	1000                	addi	s0,sp,32
    80003de0:	84aa                	mv	s1,a0
    80003de2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003de4:	00002097          	auipc	ra,0x2
    80003de8:	360080e7          	jalr	864(ra) # 80006144 <acquire>
  if(writable){
    80003dec:	02090d63          	beqz	s2,80003e26 <pipeclose+0x52>
    pi->writeopen = 0;
    80003df0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003df4:	21848513          	addi	a0,s1,536
    80003df8:	ffffd097          	auipc	ra,0xffffd
    80003dfc:	74e080e7          	jalr	1870(ra) # 80001546 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e00:	2204b783          	ld	a5,544(s1)
    80003e04:	eb95                	bnez	a5,80003e38 <pipeclose+0x64>
    release(&pi->lock);
    80003e06:	8526                	mv	a0,s1
    80003e08:	00002097          	auipc	ra,0x2
    80003e0c:	3f0080e7          	jalr	1008(ra) # 800061f8 <release>
    kfree((char*)pi);
    80003e10:	8526                	mv	a0,s1
    80003e12:	ffffc097          	auipc	ra,0xffffc
    80003e16:	20a080e7          	jalr	522(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e1a:	60e2                	ld	ra,24(sp)
    80003e1c:	6442                	ld	s0,16(sp)
    80003e1e:	64a2                	ld	s1,8(sp)
    80003e20:	6902                	ld	s2,0(sp)
    80003e22:	6105                	addi	sp,sp,32
    80003e24:	8082                	ret
    pi->readopen = 0;
    80003e26:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e2a:	21c48513          	addi	a0,s1,540
    80003e2e:	ffffd097          	auipc	ra,0xffffd
    80003e32:	718080e7          	jalr	1816(ra) # 80001546 <wakeup>
    80003e36:	b7e9                	j	80003e00 <pipeclose+0x2c>
    release(&pi->lock);
    80003e38:	8526                	mv	a0,s1
    80003e3a:	00002097          	auipc	ra,0x2
    80003e3e:	3be080e7          	jalr	958(ra) # 800061f8 <release>
}
    80003e42:	bfe1                	j	80003e1a <pipeclose+0x46>

0000000080003e44 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e44:	711d                	addi	sp,sp,-96
    80003e46:	ec86                	sd	ra,88(sp)
    80003e48:	e8a2                	sd	s0,80(sp)
    80003e4a:	e4a6                	sd	s1,72(sp)
    80003e4c:	e0ca                	sd	s2,64(sp)
    80003e4e:	fc4e                	sd	s3,56(sp)
    80003e50:	f852                	sd	s4,48(sp)
    80003e52:	f456                	sd	s5,40(sp)
    80003e54:	f05a                	sd	s6,32(sp)
    80003e56:	ec5e                	sd	s7,24(sp)
    80003e58:	e862                	sd	s8,16(sp)
    80003e5a:	1080                	addi	s0,sp,96
    80003e5c:	84aa                	mv	s1,a0
    80003e5e:	8aae                	mv	s5,a1
    80003e60:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e62:	ffffd097          	auipc	ra,0xffffd
    80003e66:	fd8080e7          	jalr	-40(ra) # 80000e3a <myproc>
    80003e6a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e6c:	8526                	mv	a0,s1
    80003e6e:	00002097          	auipc	ra,0x2
    80003e72:	2d6080e7          	jalr	726(ra) # 80006144 <acquire>
  while(i < n){
    80003e76:	0b405663          	blez	s4,80003f22 <pipewrite+0xde>
  int i = 0;
    80003e7a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e7c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e7e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e82:	21c48b93          	addi	s7,s1,540
    80003e86:	a089                	j	80003ec8 <pipewrite+0x84>
      release(&pi->lock);
    80003e88:	8526                	mv	a0,s1
    80003e8a:	00002097          	auipc	ra,0x2
    80003e8e:	36e080e7          	jalr	878(ra) # 800061f8 <release>
      return -1;
    80003e92:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e94:	854a                	mv	a0,s2
    80003e96:	60e6                	ld	ra,88(sp)
    80003e98:	6446                	ld	s0,80(sp)
    80003e9a:	64a6                	ld	s1,72(sp)
    80003e9c:	6906                	ld	s2,64(sp)
    80003e9e:	79e2                	ld	s3,56(sp)
    80003ea0:	7a42                	ld	s4,48(sp)
    80003ea2:	7aa2                	ld	s5,40(sp)
    80003ea4:	7b02                	ld	s6,32(sp)
    80003ea6:	6be2                	ld	s7,24(sp)
    80003ea8:	6c42                	ld	s8,16(sp)
    80003eaa:	6125                	addi	sp,sp,96
    80003eac:	8082                	ret
      wakeup(&pi->nread);
    80003eae:	8562                	mv	a0,s8
    80003eb0:	ffffd097          	auipc	ra,0xffffd
    80003eb4:	696080e7          	jalr	1686(ra) # 80001546 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003eb8:	85a6                	mv	a1,s1
    80003eba:	855e                	mv	a0,s7
    80003ebc:	ffffd097          	auipc	ra,0xffffd
    80003ec0:	626080e7          	jalr	1574(ra) # 800014e2 <sleep>
  while(i < n){
    80003ec4:	07495063          	bge	s2,s4,80003f24 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003ec8:	2204a783          	lw	a5,544(s1)
    80003ecc:	dfd5                	beqz	a5,80003e88 <pipewrite+0x44>
    80003ece:	854e                	mv	a0,s3
    80003ed0:	ffffe097          	auipc	ra,0xffffe
    80003ed4:	8ba080e7          	jalr	-1862(ra) # 8000178a <killed>
    80003ed8:	f945                	bnez	a0,80003e88 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003eda:	2184a783          	lw	a5,536(s1)
    80003ede:	21c4a703          	lw	a4,540(s1)
    80003ee2:	2007879b          	addiw	a5,a5,512
    80003ee6:	fcf704e3          	beq	a4,a5,80003eae <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003eea:	4685                	li	a3,1
    80003eec:	01590633          	add	a2,s2,s5
    80003ef0:	faf40593          	addi	a1,s0,-81
    80003ef4:	0509b503          	ld	a0,80(s3)
    80003ef8:	ffffd097          	auipc	ra,0xffffd
    80003efc:	c8e080e7          	jalr	-882(ra) # 80000b86 <copyin>
    80003f00:	03650263          	beq	a0,s6,80003f24 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f04:	21c4a783          	lw	a5,540(s1)
    80003f08:	0017871b          	addiw	a4,a5,1
    80003f0c:	20e4ae23          	sw	a4,540(s1)
    80003f10:	1ff7f793          	andi	a5,a5,511
    80003f14:	97a6                	add	a5,a5,s1
    80003f16:	faf44703          	lbu	a4,-81(s0)
    80003f1a:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f1e:	2905                	addiw	s2,s2,1
    80003f20:	b755                	j	80003ec4 <pipewrite+0x80>
  int i = 0;
    80003f22:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003f24:	21848513          	addi	a0,s1,536
    80003f28:	ffffd097          	auipc	ra,0xffffd
    80003f2c:	61e080e7          	jalr	1566(ra) # 80001546 <wakeup>
  release(&pi->lock);
    80003f30:	8526                	mv	a0,s1
    80003f32:	00002097          	auipc	ra,0x2
    80003f36:	2c6080e7          	jalr	710(ra) # 800061f8 <release>
  return i;
    80003f3a:	bfa9                	j	80003e94 <pipewrite+0x50>

0000000080003f3c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f3c:	715d                	addi	sp,sp,-80
    80003f3e:	e486                	sd	ra,72(sp)
    80003f40:	e0a2                	sd	s0,64(sp)
    80003f42:	fc26                	sd	s1,56(sp)
    80003f44:	f84a                	sd	s2,48(sp)
    80003f46:	f44e                	sd	s3,40(sp)
    80003f48:	f052                	sd	s4,32(sp)
    80003f4a:	ec56                	sd	s5,24(sp)
    80003f4c:	e85a                	sd	s6,16(sp)
    80003f4e:	0880                	addi	s0,sp,80
    80003f50:	84aa                	mv	s1,a0
    80003f52:	892e                	mv	s2,a1
    80003f54:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f56:	ffffd097          	auipc	ra,0xffffd
    80003f5a:	ee4080e7          	jalr	-284(ra) # 80000e3a <myproc>
    80003f5e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f60:	8526                	mv	a0,s1
    80003f62:	00002097          	auipc	ra,0x2
    80003f66:	1e2080e7          	jalr	482(ra) # 80006144 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f6a:	2184a703          	lw	a4,536(s1)
    80003f6e:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f72:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f76:	02f71763          	bne	a4,a5,80003fa4 <piperead+0x68>
    80003f7a:	2244a783          	lw	a5,548(s1)
    80003f7e:	c39d                	beqz	a5,80003fa4 <piperead+0x68>
    if(killed(pr)){
    80003f80:	8552                	mv	a0,s4
    80003f82:	ffffe097          	auipc	ra,0xffffe
    80003f86:	808080e7          	jalr	-2040(ra) # 8000178a <killed>
    80003f8a:	e949                	bnez	a0,8000401c <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f8c:	85a6                	mv	a1,s1
    80003f8e:	854e                	mv	a0,s3
    80003f90:	ffffd097          	auipc	ra,0xffffd
    80003f94:	552080e7          	jalr	1362(ra) # 800014e2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f98:	2184a703          	lw	a4,536(s1)
    80003f9c:	21c4a783          	lw	a5,540(s1)
    80003fa0:	fcf70de3          	beq	a4,a5,80003f7a <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fa4:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fa6:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fa8:	05505463          	blez	s5,80003ff0 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80003fac:	2184a783          	lw	a5,536(s1)
    80003fb0:	21c4a703          	lw	a4,540(s1)
    80003fb4:	02f70e63          	beq	a4,a5,80003ff0 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003fb8:	0017871b          	addiw	a4,a5,1
    80003fbc:	20e4ac23          	sw	a4,536(s1)
    80003fc0:	1ff7f793          	andi	a5,a5,511
    80003fc4:	97a6                	add	a5,a5,s1
    80003fc6:	0187c783          	lbu	a5,24(a5)
    80003fca:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fce:	4685                	li	a3,1
    80003fd0:	fbf40613          	addi	a2,s0,-65
    80003fd4:	85ca                	mv	a1,s2
    80003fd6:	050a3503          	ld	a0,80(s4)
    80003fda:	ffffd097          	auipc	ra,0xffffd
    80003fde:	b20080e7          	jalr	-1248(ra) # 80000afa <copyout>
    80003fe2:	01650763          	beq	a0,s6,80003ff0 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fe6:	2985                	addiw	s3,s3,1
    80003fe8:	0905                	addi	s2,s2,1
    80003fea:	fd3a91e3          	bne	s5,s3,80003fac <piperead+0x70>
    80003fee:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003ff0:	21c48513          	addi	a0,s1,540
    80003ff4:	ffffd097          	auipc	ra,0xffffd
    80003ff8:	552080e7          	jalr	1362(ra) # 80001546 <wakeup>
  release(&pi->lock);
    80003ffc:	8526                	mv	a0,s1
    80003ffe:	00002097          	auipc	ra,0x2
    80004002:	1fa080e7          	jalr	506(ra) # 800061f8 <release>
  return i;
}
    80004006:	854e                	mv	a0,s3
    80004008:	60a6                	ld	ra,72(sp)
    8000400a:	6406                	ld	s0,64(sp)
    8000400c:	74e2                	ld	s1,56(sp)
    8000400e:	7942                	ld	s2,48(sp)
    80004010:	79a2                	ld	s3,40(sp)
    80004012:	7a02                	ld	s4,32(sp)
    80004014:	6ae2                	ld	s5,24(sp)
    80004016:	6b42                	ld	s6,16(sp)
    80004018:	6161                	addi	sp,sp,80
    8000401a:	8082                	ret
      release(&pi->lock);
    8000401c:	8526                	mv	a0,s1
    8000401e:	00002097          	auipc	ra,0x2
    80004022:	1da080e7          	jalr	474(ra) # 800061f8 <release>
      return -1;
    80004026:	59fd                	li	s3,-1
    80004028:	bff9                	j	80004006 <piperead+0xca>

000000008000402a <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000402a:	1141                	addi	sp,sp,-16
    8000402c:	e422                	sd	s0,8(sp)
    8000402e:	0800                	addi	s0,sp,16
    80004030:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004032:	8905                	andi	a0,a0,1
    80004034:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004036:	8b89                	andi	a5,a5,2
    80004038:	c399                	beqz	a5,8000403e <flags2perm+0x14>
      perm |= PTE_W;
    8000403a:	00456513          	ori	a0,a0,4
    return perm;
}
    8000403e:	6422                	ld	s0,8(sp)
    80004040:	0141                	addi	sp,sp,16
    80004042:	8082                	ret

0000000080004044 <exec>:

int
exec(char *path, char **argv)
{
    80004044:	de010113          	addi	sp,sp,-544
    80004048:	20113c23          	sd	ra,536(sp)
    8000404c:	20813823          	sd	s0,528(sp)
    80004050:	20913423          	sd	s1,520(sp)
    80004054:	21213023          	sd	s2,512(sp)
    80004058:	ffce                	sd	s3,504(sp)
    8000405a:	fbd2                	sd	s4,496(sp)
    8000405c:	f7d6                	sd	s5,488(sp)
    8000405e:	f3da                	sd	s6,480(sp)
    80004060:	efde                	sd	s7,472(sp)
    80004062:	ebe2                	sd	s8,464(sp)
    80004064:	e7e6                	sd	s9,456(sp)
    80004066:	e3ea                	sd	s10,448(sp)
    80004068:	ff6e                	sd	s11,440(sp)
    8000406a:	1400                	addi	s0,sp,544
    8000406c:	892a                	mv	s2,a0
    8000406e:	dea43423          	sd	a0,-536(s0)
    80004072:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004076:	ffffd097          	auipc	ra,0xffffd
    8000407a:	dc4080e7          	jalr	-572(ra) # 80000e3a <myproc>
    8000407e:	84aa                	mv	s1,a0

  begin_op();
    80004080:	fffff097          	auipc	ra,0xfffff
    80004084:	43a080e7          	jalr	1082(ra) # 800034ba <begin_op>

  if((ip = namei(path)) == 0){
    80004088:	854a                	mv	a0,s2
    8000408a:	fffff097          	auipc	ra,0xfffff
    8000408e:	210080e7          	jalr	528(ra) # 8000329a <namei>
    80004092:	c93d                	beqz	a0,80004108 <exec+0xc4>
    80004094:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004096:	fffff097          	auipc	ra,0xfffff
    8000409a:	a58080e7          	jalr	-1448(ra) # 80002aee <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000409e:	04000713          	li	a4,64
    800040a2:	4681                	li	a3,0
    800040a4:	e5040613          	addi	a2,s0,-432
    800040a8:	4581                	li	a1,0
    800040aa:	8556                	mv	a0,s5
    800040ac:	fffff097          	auipc	ra,0xfffff
    800040b0:	cf6080e7          	jalr	-778(ra) # 80002da2 <readi>
    800040b4:	04000793          	li	a5,64
    800040b8:	00f51a63          	bne	a0,a5,800040cc <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800040bc:	e5042703          	lw	a4,-432(s0)
    800040c0:	464c47b7          	lui	a5,0x464c4
    800040c4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800040c8:	04f70663          	beq	a4,a5,80004114 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800040cc:	8556                	mv	a0,s5
    800040ce:	fffff097          	auipc	ra,0xfffff
    800040d2:	c82080e7          	jalr	-894(ra) # 80002d50 <iunlockput>
    end_op();
    800040d6:	fffff097          	auipc	ra,0xfffff
    800040da:	462080e7          	jalr	1122(ra) # 80003538 <end_op>
  }
  return -1;
    800040de:	557d                	li	a0,-1
}
    800040e0:	21813083          	ld	ra,536(sp)
    800040e4:	21013403          	ld	s0,528(sp)
    800040e8:	20813483          	ld	s1,520(sp)
    800040ec:	20013903          	ld	s2,512(sp)
    800040f0:	79fe                	ld	s3,504(sp)
    800040f2:	7a5e                	ld	s4,496(sp)
    800040f4:	7abe                	ld	s5,488(sp)
    800040f6:	7b1e                	ld	s6,480(sp)
    800040f8:	6bfe                	ld	s7,472(sp)
    800040fa:	6c5e                	ld	s8,464(sp)
    800040fc:	6cbe                	ld	s9,456(sp)
    800040fe:	6d1e                	ld	s10,448(sp)
    80004100:	7dfa                	ld	s11,440(sp)
    80004102:	22010113          	addi	sp,sp,544
    80004106:	8082                	ret
    end_op();
    80004108:	fffff097          	auipc	ra,0xfffff
    8000410c:	430080e7          	jalr	1072(ra) # 80003538 <end_op>
    return -1;
    80004110:	557d                	li	a0,-1
    80004112:	b7f9                	j	800040e0 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004114:	8526                	mv	a0,s1
    80004116:	ffffd097          	auipc	ra,0xffffd
    8000411a:	de8080e7          	jalr	-536(ra) # 80000efe <proc_pagetable>
    8000411e:	8b2a                	mv	s6,a0
    80004120:	d555                	beqz	a0,800040cc <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004122:	e7042783          	lw	a5,-400(s0)
    80004126:	e8845703          	lhu	a4,-376(s0)
    8000412a:	c735                	beqz	a4,80004196 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000412c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000412e:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004132:	6a05                	lui	s4,0x1
    80004134:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004138:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    8000413c:	6d85                	lui	s11,0x1
    8000413e:	7d7d                	lui	s10,0xfffff
    80004140:	ac3d                	j	8000437e <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004142:	00004517          	auipc	a0,0x4
    80004146:	50e50513          	addi	a0,a0,1294 # 80008650 <syscalls+0x290>
    8000414a:	00002097          	auipc	ra,0x2
    8000414e:	ac2080e7          	jalr	-1342(ra) # 80005c0c <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004152:	874a                	mv	a4,s2
    80004154:	009c86bb          	addw	a3,s9,s1
    80004158:	4581                	li	a1,0
    8000415a:	8556                	mv	a0,s5
    8000415c:	fffff097          	auipc	ra,0xfffff
    80004160:	c46080e7          	jalr	-954(ra) # 80002da2 <readi>
    80004164:	2501                	sext.w	a0,a0
    80004166:	1aa91963          	bne	s2,a0,80004318 <exec+0x2d4>
  for(i = 0; i < sz; i += PGSIZE){
    8000416a:	009d84bb          	addw	s1,s11,s1
    8000416e:	013d09bb          	addw	s3,s10,s3
    80004172:	1f74f663          	bgeu	s1,s7,8000435e <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    80004176:	02049593          	slli	a1,s1,0x20
    8000417a:	9181                	srli	a1,a1,0x20
    8000417c:	95e2                	add	a1,a1,s8
    8000417e:	855a                	mv	a0,s6
    80004180:	ffffc097          	auipc	ra,0xffffc
    80004184:	384080e7          	jalr	900(ra) # 80000504 <walkaddr>
    80004188:	862a                	mv	a2,a0
    if(pa == 0)
    8000418a:	dd45                	beqz	a0,80004142 <exec+0xfe>
      n = PGSIZE;
    8000418c:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000418e:	fd49f2e3          	bgeu	s3,s4,80004152 <exec+0x10e>
      n = sz - i;
    80004192:	894e                	mv	s2,s3
    80004194:	bf7d                	j	80004152 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004196:	4901                	li	s2,0
  iunlockput(ip);
    80004198:	8556                	mv	a0,s5
    8000419a:	fffff097          	auipc	ra,0xfffff
    8000419e:	bb6080e7          	jalr	-1098(ra) # 80002d50 <iunlockput>
  end_op();
    800041a2:	fffff097          	auipc	ra,0xfffff
    800041a6:	396080e7          	jalr	918(ra) # 80003538 <end_op>
  p = myproc();
    800041aa:	ffffd097          	auipc	ra,0xffffd
    800041ae:	c90080e7          	jalr	-880(ra) # 80000e3a <myproc>
    800041b2:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800041b4:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800041b8:	6785                	lui	a5,0x1
    800041ba:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800041bc:	97ca                	add	a5,a5,s2
    800041be:	777d                	lui	a4,0xfffff
    800041c0:	8ff9                	and	a5,a5,a4
    800041c2:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800041c6:	4691                	li	a3,4
    800041c8:	6609                	lui	a2,0x2
    800041ca:	963e                	add	a2,a2,a5
    800041cc:	85be                	mv	a1,a5
    800041ce:	855a                	mv	a0,s6
    800041d0:	ffffc097          	auipc	ra,0xffffc
    800041d4:	6da080e7          	jalr	1754(ra) # 800008aa <uvmalloc>
    800041d8:	8c2a                	mv	s8,a0
  ip = 0;
    800041da:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800041dc:	12050e63          	beqz	a0,80004318 <exec+0x2d4>
  uvmclear(pagetable, sz-2*PGSIZE);
    800041e0:	75f9                	lui	a1,0xffffe
    800041e2:	95aa                	add	a1,a1,a0
    800041e4:	855a                	mv	a0,s6
    800041e6:	ffffd097          	auipc	ra,0xffffd
    800041ea:	8e2080e7          	jalr	-1822(ra) # 80000ac8 <uvmclear>
  stackbase = sp - PGSIZE;
    800041ee:	7afd                	lui	s5,0xfffff
    800041f0:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800041f2:	df043783          	ld	a5,-528(s0)
    800041f6:	6388                	ld	a0,0(a5)
    800041f8:	c925                	beqz	a0,80004268 <exec+0x224>
    800041fa:	e9040993          	addi	s3,s0,-368
    800041fe:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004202:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004204:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004206:	ffffc097          	auipc	ra,0xffffc
    8000420a:	0f0080e7          	jalr	240(ra) # 800002f6 <strlen>
    8000420e:	0015079b          	addiw	a5,a0,1
    80004212:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004216:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000421a:	13596663          	bltu	s2,s5,80004346 <exec+0x302>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000421e:	df043d83          	ld	s11,-528(s0)
    80004222:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004226:	8552                	mv	a0,s4
    80004228:	ffffc097          	auipc	ra,0xffffc
    8000422c:	0ce080e7          	jalr	206(ra) # 800002f6 <strlen>
    80004230:	0015069b          	addiw	a3,a0,1
    80004234:	8652                	mv	a2,s4
    80004236:	85ca                	mv	a1,s2
    80004238:	855a                	mv	a0,s6
    8000423a:	ffffd097          	auipc	ra,0xffffd
    8000423e:	8c0080e7          	jalr	-1856(ra) # 80000afa <copyout>
    80004242:	10054663          	bltz	a0,8000434e <exec+0x30a>
    ustack[argc] = sp;
    80004246:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000424a:	0485                	addi	s1,s1,1
    8000424c:	008d8793          	addi	a5,s11,8
    80004250:	def43823          	sd	a5,-528(s0)
    80004254:	008db503          	ld	a0,8(s11)
    80004258:	c911                	beqz	a0,8000426c <exec+0x228>
    if(argc >= MAXARG)
    8000425a:	09a1                	addi	s3,s3,8
    8000425c:	fb3c95e3          	bne	s9,s3,80004206 <exec+0x1c2>
  sz = sz1;
    80004260:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004264:	4a81                	li	s5,0
    80004266:	a84d                	j	80004318 <exec+0x2d4>
  sp = sz;
    80004268:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000426a:	4481                	li	s1,0
  ustack[argc] = 0;
    8000426c:	00349793          	slli	a5,s1,0x3
    80004270:	f9078793          	addi	a5,a5,-112
    80004274:	97a2                	add	a5,a5,s0
    80004276:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000427a:	00148693          	addi	a3,s1,1
    8000427e:	068e                	slli	a3,a3,0x3
    80004280:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004284:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004288:	01597663          	bgeu	s2,s5,80004294 <exec+0x250>
  sz = sz1;
    8000428c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004290:	4a81                	li	s5,0
    80004292:	a059                	j	80004318 <exec+0x2d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004294:	e9040613          	addi	a2,s0,-368
    80004298:	85ca                	mv	a1,s2
    8000429a:	855a                	mv	a0,s6
    8000429c:	ffffd097          	auipc	ra,0xffffd
    800042a0:	85e080e7          	jalr	-1954(ra) # 80000afa <copyout>
    800042a4:	0a054963          	bltz	a0,80004356 <exec+0x312>
  p->trapframe->a1 = sp;
    800042a8:	058bb783          	ld	a5,88(s7)
    800042ac:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800042b0:	de843783          	ld	a5,-536(s0)
    800042b4:	0007c703          	lbu	a4,0(a5)
    800042b8:	cf11                	beqz	a4,800042d4 <exec+0x290>
    800042ba:	0785                	addi	a5,a5,1
    if(*s == '/')
    800042bc:	02f00693          	li	a3,47
    800042c0:	a039                	j	800042ce <exec+0x28a>
      last = s+1;
    800042c2:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800042c6:	0785                	addi	a5,a5,1
    800042c8:	fff7c703          	lbu	a4,-1(a5)
    800042cc:	c701                	beqz	a4,800042d4 <exec+0x290>
    if(*s == '/')
    800042ce:	fed71ce3          	bne	a4,a3,800042c6 <exec+0x282>
    800042d2:	bfc5                	j	800042c2 <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    800042d4:	4641                	li	a2,16
    800042d6:	de843583          	ld	a1,-536(s0)
    800042da:	158b8513          	addi	a0,s7,344
    800042de:	ffffc097          	auipc	ra,0xffffc
    800042e2:	fe6080e7          	jalr	-26(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    800042e6:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800042ea:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800042ee:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800042f2:	058bb783          	ld	a5,88(s7)
    800042f6:	e6843703          	ld	a4,-408(s0)
    800042fa:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800042fc:	058bb783          	ld	a5,88(s7)
    80004300:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004304:	85ea                	mv	a1,s10
    80004306:	ffffd097          	auipc	ra,0xffffd
    8000430a:	c94080e7          	jalr	-876(ra) # 80000f9a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000430e:	0004851b          	sext.w	a0,s1
    80004312:	b3f9                	j	800040e0 <exec+0x9c>
    80004314:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004318:	df843583          	ld	a1,-520(s0)
    8000431c:	855a                	mv	a0,s6
    8000431e:	ffffd097          	auipc	ra,0xffffd
    80004322:	c7c080e7          	jalr	-900(ra) # 80000f9a <proc_freepagetable>
  if(ip){
    80004326:	da0a93e3          	bnez	s5,800040cc <exec+0x88>
  return -1;
    8000432a:	557d                	li	a0,-1
    8000432c:	bb55                	j	800040e0 <exec+0x9c>
    8000432e:	df243c23          	sd	s2,-520(s0)
    80004332:	b7dd                	j	80004318 <exec+0x2d4>
    80004334:	df243c23          	sd	s2,-520(s0)
    80004338:	b7c5                	j	80004318 <exec+0x2d4>
    8000433a:	df243c23          	sd	s2,-520(s0)
    8000433e:	bfe9                	j	80004318 <exec+0x2d4>
    80004340:	df243c23          	sd	s2,-520(s0)
    80004344:	bfd1                	j	80004318 <exec+0x2d4>
  sz = sz1;
    80004346:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000434a:	4a81                	li	s5,0
    8000434c:	b7f1                	j	80004318 <exec+0x2d4>
  sz = sz1;
    8000434e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004352:	4a81                	li	s5,0
    80004354:	b7d1                	j	80004318 <exec+0x2d4>
  sz = sz1;
    80004356:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000435a:	4a81                	li	s5,0
    8000435c:	bf75                	j	80004318 <exec+0x2d4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000435e:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004362:	e0843783          	ld	a5,-504(s0)
    80004366:	0017869b          	addiw	a3,a5,1
    8000436a:	e0d43423          	sd	a3,-504(s0)
    8000436e:	e0043783          	ld	a5,-512(s0)
    80004372:	0387879b          	addiw	a5,a5,56
    80004376:	e8845703          	lhu	a4,-376(s0)
    8000437a:	e0e6dfe3          	bge	a3,a4,80004198 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000437e:	2781                	sext.w	a5,a5
    80004380:	e0f43023          	sd	a5,-512(s0)
    80004384:	03800713          	li	a4,56
    80004388:	86be                	mv	a3,a5
    8000438a:	e1840613          	addi	a2,s0,-488
    8000438e:	4581                	li	a1,0
    80004390:	8556                	mv	a0,s5
    80004392:	fffff097          	auipc	ra,0xfffff
    80004396:	a10080e7          	jalr	-1520(ra) # 80002da2 <readi>
    8000439a:	03800793          	li	a5,56
    8000439e:	f6f51be3          	bne	a0,a5,80004314 <exec+0x2d0>
    if(ph.type != ELF_PROG_LOAD)
    800043a2:	e1842783          	lw	a5,-488(s0)
    800043a6:	4705                	li	a4,1
    800043a8:	fae79de3          	bne	a5,a4,80004362 <exec+0x31e>
    if(ph.memsz < ph.filesz)
    800043ac:	e4043483          	ld	s1,-448(s0)
    800043b0:	e3843783          	ld	a5,-456(s0)
    800043b4:	f6f4ede3          	bltu	s1,a5,8000432e <exec+0x2ea>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800043b8:	e2843783          	ld	a5,-472(s0)
    800043bc:	94be                	add	s1,s1,a5
    800043be:	f6f4ebe3          	bltu	s1,a5,80004334 <exec+0x2f0>
    if(ph.vaddr % PGSIZE != 0)
    800043c2:	de043703          	ld	a4,-544(s0)
    800043c6:	8ff9                	and	a5,a5,a4
    800043c8:	fbad                	bnez	a5,8000433a <exec+0x2f6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800043ca:	e1c42503          	lw	a0,-484(s0)
    800043ce:	00000097          	auipc	ra,0x0
    800043d2:	c5c080e7          	jalr	-932(ra) # 8000402a <flags2perm>
    800043d6:	86aa                	mv	a3,a0
    800043d8:	8626                	mv	a2,s1
    800043da:	85ca                	mv	a1,s2
    800043dc:	855a                	mv	a0,s6
    800043de:	ffffc097          	auipc	ra,0xffffc
    800043e2:	4cc080e7          	jalr	1228(ra) # 800008aa <uvmalloc>
    800043e6:	dea43c23          	sd	a0,-520(s0)
    800043ea:	d939                	beqz	a0,80004340 <exec+0x2fc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800043ec:	e2843c03          	ld	s8,-472(s0)
    800043f0:	e2042c83          	lw	s9,-480(s0)
    800043f4:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800043f8:	f60b83e3          	beqz	s7,8000435e <exec+0x31a>
    800043fc:	89de                	mv	s3,s7
    800043fe:	4481                	li	s1,0
    80004400:	bb9d                	j	80004176 <exec+0x132>

0000000080004402 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004402:	7179                	addi	sp,sp,-48
    80004404:	f406                	sd	ra,40(sp)
    80004406:	f022                	sd	s0,32(sp)
    80004408:	ec26                	sd	s1,24(sp)
    8000440a:	e84a                	sd	s2,16(sp)
    8000440c:	1800                	addi	s0,sp,48
    8000440e:	892e                	mv	s2,a1
    80004410:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004412:	fdc40593          	addi	a1,s0,-36
    80004416:	ffffe097          	auipc	ra,0xffffe
    8000441a:	b60080e7          	jalr	-1184(ra) # 80001f76 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000441e:	fdc42703          	lw	a4,-36(s0)
    80004422:	47bd                	li	a5,15
    80004424:	02e7eb63          	bltu	a5,a4,8000445a <argfd+0x58>
    80004428:	ffffd097          	auipc	ra,0xffffd
    8000442c:	a12080e7          	jalr	-1518(ra) # 80000e3a <myproc>
    80004430:	fdc42703          	lw	a4,-36(s0)
    80004434:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffdd2ca>
    80004438:	078e                	slli	a5,a5,0x3
    8000443a:	953e                	add	a0,a0,a5
    8000443c:	611c                	ld	a5,0(a0)
    8000443e:	c385                	beqz	a5,8000445e <argfd+0x5c>
    return -1;
  if(pfd)
    80004440:	00090463          	beqz	s2,80004448 <argfd+0x46>
    *pfd = fd;
    80004444:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004448:	4501                	li	a0,0
  if(pf)
    8000444a:	c091                	beqz	s1,8000444e <argfd+0x4c>
    *pf = f;
    8000444c:	e09c                	sd	a5,0(s1)
}
    8000444e:	70a2                	ld	ra,40(sp)
    80004450:	7402                	ld	s0,32(sp)
    80004452:	64e2                	ld	s1,24(sp)
    80004454:	6942                	ld	s2,16(sp)
    80004456:	6145                	addi	sp,sp,48
    80004458:	8082                	ret
    return -1;
    8000445a:	557d                	li	a0,-1
    8000445c:	bfcd                	j	8000444e <argfd+0x4c>
    8000445e:	557d                	li	a0,-1
    80004460:	b7fd                	j	8000444e <argfd+0x4c>

0000000080004462 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004462:	1101                	addi	sp,sp,-32
    80004464:	ec06                	sd	ra,24(sp)
    80004466:	e822                	sd	s0,16(sp)
    80004468:	e426                	sd	s1,8(sp)
    8000446a:	1000                	addi	s0,sp,32
    8000446c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000446e:	ffffd097          	auipc	ra,0xffffd
    80004472:	9cc080e7          	jalr	-1588(ra) # 80000e3a <myproc>
    80004476:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004478:	0d050793          	addi	a5,a0,208
    8000447c:	4501                	li	a0,0
    8000447e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004480:	6398                	ld	a4,0(a5)
    80004482:	cb19                	beqz	a4,80004498 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004484:	2505                	addiw	a0,a0,1
    80004486:	07a1                	addi	a5,a5,8
    80004488:	fed51ce3          	bne	a0,a3,80004480 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000448c:	557d                	li	a0,-1
}
    8000448e:	60e2                	ld	ra,24(sp)
    80004490:	6442                	ld	s0,16(sp)
    80004492:	64a2                	ld	s1,8(sp)
    80004494:	6105                	addi	sp,sp,32
    80004496:	8082                	ret
      p->ofile[fd] = f;
    80004498:	01a50793          	addi	a5,a0,26
    8000449c:	078e                	slli	a5,a5,0x3
    8000449e:	963e                	add	a2,a2,a5
    800044a0:	e204                	sd	s1,0(a2)
      return fd;
    800044a2:	b7f5                	j	8000448e <fdalloc+0x2c>

00000000800044a4 <create>:
}


static struct inode*
create(char *path, short type, short major, short minor)
{
    800044a4:	715d                	addi	sp,sp,-80
    800044a6:	e486                	sd	ra,72(sp)
    800044a8:	e0a2                	sd	s0,64(sp)
    800044aa:	fc26                	sd	s1,56(sp)
    800044ac:	f84a                	sd	s2,48(sp)
    800044ae:	f44e                	sd	s3,40(sp)
    800044b0:	f052                	sd	s4,32(sp)
    800044b2:	ec56                	sd	s5,24(sp)
    800044b4:	e85a                	sd	s6,16(sp)
    800044b6:	0880                	addi	s0,sp,80
    800044b8:	8b2e                	mv	s6,a1
    800044ba:	89b2                	mv	s3,a2
    800044bc:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800044be:	fb040593          	addi	a1,s0,-80
    800044c2:	fffff097          	auipc	ra,0xfffff
    800044c6:	df6080e7          	jalr	-522(ra) # 800032b8 <nameiparent>
    800044ca:	84aa                	mv	s1,a0
    800044cc:	14050f63          	beqz	a0,8000462a <create+0x186>
    return 0;

  ilock(dp);
    800044d0:	ffffe097          	auipc	ra,0xffffe
    800044d4:	61e080e7          	jalr	1566(ra) # 80002aee <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800044d8:	4601                	li	a2,0
    800044da:	fb040593          	addi	a1,s0,-80
    800044de:	8526                	mv	a0,s1
    800044e0:	fffff097          	auipc	ra,0xfffff
    800044e4:	af2080e7          	jalr	-1294(ra) # 80002fd2 <dirlookup>
    800044e8:	8aaa                	mv	s5,a0
    800044ea:	c931                	beqz	a0,8000453e <create+0x9a>
    iunlockput(dp);
    800044ec:	8526                	mv	a0,s1
    800044ee:	fffff097          	auipc	ra,0xfffff
    800044f2:	862080e7          	jalr	-1950(ra) # 80002d50 <iunlockput>
    ilock(ip);
    800044f6:	8556                	mv	a0,s5
    800044f8:	ffffe097          	auipc	ra,0xffffe
    800044fc:	5f6080e7          	jalr	1526(ra) # 80002aee <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004500:	000b059b          	sext.w	a1,s6
    80004504:	4789                	li	a5,2
    80004506:	02f59563          	bne	a1,a5,80004530 <create+0x8c>
    8000450a:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdd2f4>
    8000450e:	37f9                	addiw	a5,a5,-2
    80004510:	17c2                	slli	a5,a5,0x30
    80004512:	93c1                	srli	a5,a5,0x30
    80004514:	4705                	li	a4,1
    80004516:	00f76d63          	bltu	a4,a5,80004530 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000451a:	8556                	mv	a0,s5
    8000451c:	60a6                	ld	ra,72(sp)
    8000451e:	6406                	ld	s0,64(sp)
    80004520:	74e2                	ld	s1,56(sp)
    80004522:	7942                	ld	s2,48(sp)
    80004524:	79a2                	ld	s3,40(sp)
    80004526:	7a02                	ld	s4,32(sp)
    80004528:	6ae2                	ld	s5,24(sp)
    8000452a:	6b42                	ld	s6,16(sp)
    8000452c:	6161                	addi	sp,sp,80
    8000452e:	8082                	ret
    iunlockput(ip);
    80004530:	8556                	mv	a0,s5
    80004532:	fffff097          	auipc	ra,0xfffff
    80004536:	81e080e7          	jalr	-2018(ra) # 80002d50 <iunlockput>
    return 0;
    8000453a:	4a81                	li	s5,0
    8000453c:	bff9                	j	8000451a <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000453e:	85da                	mv	a1,s6
    80004540:	4088                	lw	a0,0(s1)
    80004542:	ffffe097          	auipc	ra,0xffffe
    80004546:	40e080e7          	jalr	1038(ra) # 80002950 <ialloc>
    8000454a:	8a2a                	mv	s4,a0
    8000454c:	c539                	beqz	a0,8000459a <create+0xf6>
  ilock(ip);
    8000454e:	ffffe097          	auipc	ra,0xffffe
    80004552:	5a0080e7          	jalr	1440(ra) # 80002aee <ilock>
  ip->major = major;
    80004556:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000455a:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000455e:	4905                	li	s2,1
    80004560:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004564:	8552                	mv	a0,s4
    80004566:	ffffe097          	auipc	ra,0xffffe
    8000456a:	4bc080e7          	jalr	1212(ra) # 80002a22 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000456e:	000b059b          	sext.w	a1,s6
    80004572:	03258b63          	beq	a1,s2,800045a8 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    80004576:	004a2603          	lw	a2,4(s4)
    8000457a:	fb040593          	addi	a1,s0,-80
    8000457e:	8526                	mv	a0,s1
    80004580:	fffff097          	auipc	ra,0xfffff
    80004584:	c68080e7          	jalr	-920(ra) # 800031e8 <dirlink>
    80004588:	06054f63          	bltz	a0,80004606 <create+0x162>
  iunlockput(dp);
    8000458c:	8526                	mv	a0,s1
    8000458e:	ffffe097          	auipc	ra,0xffffe
    80004592:	7c2080e7          	jalr	1986(ra) # 80002d50 <iunlockput>
  return ip;
    80004596:	8ad2                	mv	s5,s4
    80004598:	b749                	j	8000451a <create+0x76>
    iunlockput(dp);
    8000459a:	8526                	mv	a0,s1
    8000459c:	ffffe097          	auipc	ra,0xffffe
    800045a0:	7b4080e7          	jalr	1972(ra) # 80002d50 <iunlockput>
    return 0;
    800045a4:	8ad2                	mv	s5,s4
    800045a6:	bf95                	j	8000451a <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800045a8:	004a2603          	lw	a2,4(s4)
    800045ac:	00004597          	auipc	a1,0x4
    800045b0:	0c458593          	addi	a1,a1,196 # 80008670 <syscalls+0x2b0>
    800045b4:	8552                	mv	a0,s4
    800045b6:	fffff097          	auipc	ra,0xfffff
    800045ba:	c32080e7          	jalr	-974(ra) # 800031e8 <dirlink>
    800045be:	04054463          	bltz	a0,80004606 <create+0x162>
    800045c2:	40d0                	lw	a2,4(s1)
    800045c4:	00004597          	auipc	a1,0x4
    800045c8:	0b458593          	addi	a1,a1,180 # 80008678 <syscalls+0x2b8>
    800045cc:	8552                	mv	a0,s4
    800045ce:	fffff097          	auipc	ra,0xfffff
    800045d2:	c1a080e7          	jalr	-998(ra) # 800031e8 <dirlink>
    800045d6:	02054863          	bltz	a0,80004606 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    800045da:	004a2603          	lw	a2,4(s4)
    800045de:	fb040593          	addi	a1,s0,-80
    800045e2:	8526                	mv	a0,s1
    800045e4:	fffff097          	auipc	ra,0xfffff
    800045e8:	c04080e7          	jalr	-1020(ra) # 800031e8 <dirlink>
    800045ec:	00054d63          	bltz	a0,80004606 <create+0x162>
    dp->nlink++;  // for ".."
    800045f0:	04a4d783          	lhu	a5,74(s1)
    800045f4:	2785                	addiw	a5,a5,1
    800045f6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800045fa:	8526                	mv	a0,s1
    800045fc:	ffffe097          	auipc	ra,0xffffe
    80004600:	426080e7          	jalr	1062(ra) # 80002a22 <iupdate>
    80004604:	b761                	j	8000458c <create+0xe8>
  ip->nlink = 0;
    80004606:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000460a:	8552                	mv	a0,s4
    8000460c:	ffffe097          	auipc	ra,0xffffe
    80004610:	416080e7          	jalr	1046(ra) # 80002a22 <iupdate>
  iunlockput(ip);
    80004614:	8552                	mv	a0,s4
    80004616:	ffffe097          	auipc	ra,0xffffe
    8000461a:	73a080e7          	jalr	1850(ra) # 80002d50 <iunlockput>
  iunlockput(dp);
    8000461e:	8526                	mv	a0,s1
    80004620:	ffffe097          	auipc	ra,0xffffe
    80004624:	730080e7          	jalr	1840(ra) # 80002d50 <iunlockput>
  return 0;
    80004628:	bdcd                	j	8000451a <create+0x76>
    return 0;
    8000462a:	8aaa                	mv	s5,a0
    8000462c:	b5fd                	j	8000451a <create+0x76>

000000008000462e <sys_dup>:
{
    8000462e:	7179                	addi	sp,sp,-48
    80004630:	f406                	sd	ra,40(sp)
    80004632:	f022                	sd	s0,32(sp)
    80004634:	ec26                	sd	s1,24(sp)
    80004636:	e84a                	sd	s2,16(sp)
    80004638:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000463a:	fd840613          	addi	a2,s0,-40
    8000463e:	4581                	li	a1,0
    80004640:	4501                	li	a0,0
    80004642:	00000097          	auipc	ra,0x0
    80004646:	dc0080e7          	jalr	-576(ra) # 80004402 <argfd>
    return -1;
    8000464a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000464c:	02054363          	bltz	a0,80004672 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80004650:	fd843903          	ld	s2,-40(s0)
    80004654:	854a                	mv	a0,s2
    80004656:	00000097          	auipc	ra,0x0
    8000465a:	e0c080e7          	jalr	-500(ra) # 80004462 <fdalloc>
    8000465e:	84aa                	mv	s1,a0
    return -1;
    80004660:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004662:	00054863          	bltz	a0,80004672 <sys_dup+0x44>
  filedup(f);
    80004666:	854a                	mv	a0,s2
    80004668:	fffff097          	auipc	ra,0xfffff
    8000466c:	2c8080e7          	jalr	712(ra) # 80003930 <filedup>
  return fd;
    80004670:	87a6                	mv	a5,s1
}
    80004672:	853e                	mv	a0,a5
    80004674:	70a2                	ld	ra,40(sp)
    80004676:	7402                	ld	s0,32(sp)
    80004678:	64e2                	ld	s1,24(sp)
    8000467a:	6942                	ld	s2,16(sp)
    8000467c:	6145                	addi	sp,sp,48
    8000467e:	8082                	ret

0000000080004680 <sys_read>:
{
    80004680:	7179                	addi	sp,sp,-48
    80004682:	f406                	sd	ra,40(sp)
    80004684:	f022                	sd	s0,32(sp)
    80004686:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004688:	fd840593          	addi	a1,s0,-40
    8000468c:	4505                	li	a0,1
    8000468e:	ffffe097          	auipc	ra,0xffffe
    80004692:	908080e7          	jalr	-1784(ra) # 80001f96 <argaddr>
  argint(2, &n);
    80004696:	fe440593          	addi	a1,s0,-28
    8000469a:	4509                	li	a0,2
    8000469c:	ffffe097          	auipc	ra,0xffffe
    800046a0:	8da080e7          	jalr	-1830(ra) # 80001f76 <argint>
  if(argfd(0, 0, &f) < 0)
    800046a4:	fe840613          	addi	a2,s0,-24
    800046a8:	4581                	li	a1,0
    800046aa:	4501                	li	a0,0
    800046ac:	00000097          	auipc	ra,0x0
    800046b0:	d56080e7          	jalr	-682(ra) # 80004402 <argfd>
    800046b4:	87aa                	mv	a5,a0
    return -1;
    800046b6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800046b8:	0007cc63          	bltz	a5,800046d0 <sys_read+0x50>
  return fileread(f, p, n);
    800046bc:	fe442603          	lw	a2,-28(s0)
    800046c0:	fd843583          	ld	a1,-40(s0)
    800046c4:	fe843503          	ld	a0,-24(s0)
    800046c8:	fffff097          	auipc	ra,0xfffff
    800046cc:	43c080e7          	jalr	1084(ra) # 80003b04 <fileread>
}
    800046d0:	70a2                	ld	ra,40(sp)
    800046d2:	7402                	ld	s0,32(sp)
    800046d4:	6145                	addi	sp,sp,48
    800046d6:	8082                	ret

00000000800046d8 <sys_write>:
{
    800046d8:	7179                	addi	sp,sp,-48
    800046da:	f406                	sd	ra,40(sp)
    800046dc:	f022                	sd	s0,32(sp)
    800046de:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800046e0:	fd840593          	addi	a1,s0,-40
    800046e4:	4505                	li	a0,1
    800046e6:	ffffe097          	auipc	ra,0xffffe
    800046ea:	8b0080e7          	jalr	-1872(ra) # 80001f96 <argaddr>
  argint(2, &n);
    800046ee:	fe440593          	addi	a1,s0,-28
    800046f2:	4509                	li	a0,2
    800046f4:	ffffe097          	auipc	ra,0xffffe
    800046f8:	882080e7          	jalr	-1918(ra) # 80001f76 <argint>
  if(argfd(0, 0, &f) < 0)
    800046fc:	fe840613          	addi	a2,s0,-24
    80004700:	4581                	li	a1,0
    80004702:	4501                	li	a0,0
    80004704:	00000097          	auipc	ra,0x0
    80004708:	cfe080e7          	jalr	-770(ra) # 80004402 <argfd>
    8000470c:	87aa                	mv	a5,a0
    return -1;
    8000470e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004710:	0007cc63          	bltz	a5,80004728 <sys_write+0x50>
  return filewrite(f, p, n);
    80004714:	fe442603          	lw	a2,-28(s0)
    80004718:	fd843583          	ld	a1,-40(s0)
    8000471c:	fe843503          	ld	a0,-24(s0)
    80004720:	fffff097          	auipc	ra,0xfffff
    80004724:	4a6080e7          	jalr	1190(ra) # 80003bc6 <filewrite>
}
    80004728:	70a2                	ld	ra,40(sp)
    8000472a:	7402                	ld	s0,32(sp)
    8000472c:	6145                	addi	sp,sp,48
    8000472e:	8082                	ret

0000000080004730 <sys_close>:
{
    80004730:	1101                	addi	sp,sp,-32
    80004732:	ec06                	sd	ra,24(sp)
    80004734:	e822                	sd	s0,16(sp)
    80004736:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004738:	fe040613          	addi	a2,s0,-32
    8000473c:	fec40593          	addi	a1,s0,-20
    80004740:	4501                	li	a0,0
    80004742:	00000097          	auipc	ra,0x0
    80004746:	cc0080e7          	jalr	-832(ra) # 80004402 <argfd>
    return -1;
    8000474a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000474c:	02054463          	bltz	a0,80004774 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004750:	ffffc097          	auipc	ra,0xffffc
    80004754:	6ea080e7          	jalr	1770(ra) # 80000e3a <myproc>
    80004758:	fec42783          	lw	a5,-20(s0)
    8000475c:	07e9                	addi	a5,a5,26
    8000475e:	078e                	slli	a5,a5,0x3
    80004760:	953e                	add	a0,a0,a5
    80004762:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004766:	fe043503          	ld	a0,-32(s0)
    8000476a:	fffff097          	auipc	ra,0xfffff
    8000476e:	218080e7          	jalr	536(ra) # 80003982 <fileclose>
  return 0;
    80004772:	4781                	li	a5,0
}
    80004774:	853e                	mv	a0,a5
    80004776:	60e2                	ld	ra,24(sp)
    80004778:	6442                	ld	s0,16(sp)
    8000477a:	6105                	addi	sp,sp,32
    8000477c:	8082                	ret

000000008000477e <sys_fstat>:
{
    8000477e:	1101                	addi	sp,sp,-32
    80004780:	ec06                	sd	ra,24(sp)
    80004782:	e822                	sd	s0,16(sp)
    80004784:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004786:	fe040593          	addi	a1,s0,-32
    8000478a:	4505                	li	a0,1
    8000478c:	ffffe097          	auipc	ra,0xffffe
    80004790:	80a080e7          	jalr	-2038(ra) # 80001f96 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004794:	fe840613          	addi	a2,s0,-24
    80004798:	4581                	li	a1,0
    8000479a:	4501                	li	a0,0
    8000479c:	00000097          	auipc	ra,0x0
    800047a0:	c66080e7          	jalr	-922(ra) # 80004402 <argfd>
    800047a4:	87aa                	mv	a5,a0
    return -1;
    800047a6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047a8:	0007ca63          	bltz	a5,800047bc <sys_fstat+0x3e>
  return filestat(f, st);
    800047ac:	fe043583          	ld	a1,-32(s0)
    800047b0:	fe843503          	ld	a0,-24(s0)
    800047b4:	fffff097          	auipc	ra,0xfffff
    800047b8:	296080e7          	jalr	662(ra) # 80003a4a <filestat>
}
    800047bc:	60e2                	ld	ra,24(sp)
    800047be:	6442                	ld	s0,16(sp)
    800047c0:	6105                	addi	sp,sp,32
    800047c2:	8082                	ret

00000000800047c4 <sys_link>:
{
    800047c4:	7169                	addi	sp,sp,-304
    800047c6:	f606                	sd	ra,296(sp)
    800047c8:	f222                	sd	s0,288(sp)
    800047ca:	ee26                	sd	s1,280(sp)
    800047cc:	ea4a                	sd	s2,272(sp)
    800047ce:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047d0:	08000613          	li	a2,128
    800047d4:	ed040593          	addi	a1,s0,-304
    800047d8:	4501                	li	a0,0
    800047da:	ffffd097          	auipc	ra,0xffffd
    800047de:	7dc080e7          	jalr	2012(ra) # 80001fb6 <argstr>
    return -1;
    800047e2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047e4:	10054e63          	bltz	a0,80004900 <sys_link+0x13c>
    800047e8:	08000613          	li	a2,128
    800047ec:	f5040593          	addi	a1,s0,-176
    800047f0:	4505                	li	a0,1
    800047f2:	ffffd097          	auipc	ra,0xffffd
    800047f6:	7c4080e7          	jalr	1988(ra) # 80001fb6 <argstr>
    return -1;
    800047fa:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047fc:	10054263          	bltz	a0,80004900 <sys_link+0x13c>
  begin_op();
    80004800:	fffff097          	auipc	ra,0xfffff
    80004804:	cba080e7          	jalr	-838(ra) # 800034ba <begin_op>
  if((ip = namei(old)) == 0){
    80004808:	ed040513          	addi	a0,s0,-304
    8000480c:	fffff097          	auipc	ra,0xfffff
    80004810:	a8e080e7          	jalr	-1394(ra) # 8000329a <namei>
    80004814:	84aa                	mv	s1,a0
    80004816:	c551                	beqz	a0,800048a2 <sys_link+0xde>
  ilock(ip);
    80004818:	ffffe097          	auipc	ra,0xffffe
    8000481c:	2d6080e7          	jalr	726(ra) # 80002aee <ilock>
  if(ip->type == T_DIR){
    80004820:	04449703          	lh	a4,68(s1)
    80004824:	4785                	li	a5,1
    80004826:	08f70463          	beq	a4,a5,800048ae <sys_link+0xea>
  ip->nlink++;
    8000482a:	04a4d783          	lhu	a5,74(s1)
    8000482e:	2785                	addiw	a5,a5,1
    80004830:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004834:	8526                	mv	a0,s1
    80004836:	ffffe097          	auipc	ra,0xffffe
    8000483a:	1ec080e7          	jalr	492(ra) # 80002a22 <iupdate>
  iunlock(ip);
    8000483e:	8526                	mv	a0,s1
    80004840:	ffffe097          	auipc	ra,0xffffe
    80004844:	370080e7          	jalr	880(ra) # 80002bb0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004848:	fd040593          	addi	a1,s0,-48
    8000484c:	f5040513          	addi	a0,s0,-176
    80004850:	fffff097          	auipc	ra,0xfffff
    80004854:	a68080e7          	jalr	-1432(ra) # 800032b8 <nameiparent>
    80004858:	892a                	mv	s2,a0
    8000485a:	c935                	beqz	a0,800048ce <sys_link+0x10a>
  ilock(dp);
    8000485c:	ffffe097          	auipc	ra,0xffffe
    80004860:	292080e7          	jalr	658(ra) # 80002aee <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004864:	00092703          	lw	a4,0(s2)
    80004868:	409c                	lw	a5,0(s1)
    8000486a:	04f71d63          	bne	a4,a5,800048c4 <sys_link+0x100>
    8000486e:	40d0                	lw	a2,4(s1)
    80004870:	fd040593          	addi	a1,s0,-48
    80004874:	854a                	mv	a0,s2
    80004876:	fffff097          	auipc	ra,0xfffff
    8000487a:	972080e7          	jalr	-1678(ra) # 800031e8 <dirlink>
    8000487e:	04054363          	bltz	a0,800048c4 <sys_link+0x100>
  iunlockput(dp);
    80004882:	854a                	mv	a0,s2
    80004884:	ffffe097          	auipc	ra,0xffffe
    80004888:	4cc080e7          	jalr	1228(ra) # 80002d50 <iunlockput>
  iput(ip);
    8000488c:	8526                	mv	a0,s1
    8000488e:	ffffe097          	auipc	ra,0xffffe
    80004892:	41a080e7          	jalr	1050(ra) # 80002ca8 <iput>
  end_op();
    80004896:	fffff097          	auipc	ra,0xfffff
    8000489a:	ca2080e7          	jalr	-862(ra) # 80003538 <end_op>
  return 0;
    8000489e:	4781                	li	a5,0
    800048a0:	a085                	j	80004900 <sys_link+0x13c>
    end_op();
    800048a2:	fffff097          	auipc	ra,0xfffff
    800048a6:	c96080e7          	jalr	-874(ra) # 80003538 <end_op>
    return -1;
    800048aa:	57fd                	li	a5,-1
    800048ac:	a891                	j	80004900 <sys_link+0x13c>
    iunlockput(ip);
    800048ae:	8526                	mv	a0,s1
    800048b0:	ffffe097          	auipc	ra,0xffffe
    800048b4:	4a0080e7          	jalr	1184(ra) # 80002d50 <iunlockput>
    end_op();
    800048b8:	fffff097          	auipc	ra,0xfffff
    800048bc:	c80080e7          	jalr	-896(ra) # 80003538 <end_op>
    return -1;
    800048c0:	57fd                	li	a5,-1
    800048c2:	a83d                	j	80004900 <sys_link+0x13c>
    iunlockput(dp);
    800048c4:	854a                	mv	a0,s2
    800048c6:	ffffe097          	auipc	ra,0xffffe
    800048ca:	48a080e7          	jalr	1162(ra) # 80002d50 <iunlockput>
  ilock(ip);
    800048ce:	8526                	mv	a0,s1
    800048d0:	ffffe097          	auipc	ra,0xffffe
    800048d4:	21e080e7          	jalr	542(ra) # 80002aee <ilock>
  ip->nlink--;
    800048d8:	04a4d783          	lhu	a5,74(s1)
    800048dc:	37fd                	addiw	a5,a5,-1
    800048de:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048e2:	8526                	mv	a0,s1
    800048e4:	ffffe097          	auipc	ra,0xffffe
    800048e8:	13e080e7          	jalr	318(ra) # 80002a22 <iupdate>
  iunlockput(ip);
    800048ec:	8526                	mv	a0,s1
    800048ee:	ffffe097          	auipc	ra,0xffffe
    800048f2:	462080e7          	jalr	1122(ra) # 80002d50 <iunlockput>
  end_op();
    800048f6:	fffff097          	auipc	ra,0xfffff
    800048fa:	c42080e7          	jalr	-958(ra) # 80003538 <end_op>
  return -1;
    800048fe:	57fd                	li	a5,-1
}
    80004900:	853e                	mv	a0,a5
    80004902:	70b2                	ld	ra,296(sp)
    80004904:	7412                	ld	s0,288(sp)
    80004906:	64f2                	ld	s1,280(sp)
    80004908:	6952                	ld	s2,272(sp)
    8000490a:	6155                	addi	sp,sp,304
    8000490c:	8082                	ret

000000008000490e <sys_unlink>:
{
    8000490e:	7151                	addi	sp,sp,-240
    80004910:	f586                	sd	ra,232(sp)
    80004912:	f1a2                	sd	s0,224(sp)
    80004914:	eda6                	sd	s1,216(sp)
    80004916:	e9ca                	sd	s2,208(sp)
    80004918:	e5ce                	sd	s3,200(sp)
    8000491a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000491c:	08000613          	li	a2,128
    80004920:	f3040593          	addi	a1,s0,-208
    80004924:	4501                	li	a0,0
    80004926:	ffffd097          	auipc	ra,0xffffd
    8000492a:	690080e7          	jalr	1680(ra) # 80001fb6 <argstr>
    8000492e:	18054163          	bltz	a0,80004ab0 <sys_unlink+0x1a2>
  begin_op();
    80004932:	fffff097          	auipc	ra,0xfffff
    80004936:	b88080e7          	jalr	-1144(ra) # 800034ba <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000493a:	fb040593          	addi	a1,s0,-80
    8000493e:	f3040513          	addi	a0,s0,-208
    80004942:	fffff097          	auipc	ra,0xfffff
    80004946:	976080e7          	jalr	-1674(ra) # 800032b8 <nameiparent>
    8000494a:	84aa                	mv	s1,a0
    8000494c:	c979                	beqz	a0,80004a22 <sys_unlink+0x114>
  ilock(dp);
    8000494e:	ffffe097          	auipc	ra,0xffffe
    80004952:	1a0080e7          	jalr	416(ra) # 80002aee <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004956:	00004597          	auipc	a1,0x4
    8000495a:	d1a58593          	addi	a1,a1,-742 # 80008670 <syscalls+0x2b0>
    8000495e:	fb040513          	addi	a0,s0,-80
    80004962:	ffffe097          	auipc	ra,0xffffe
    80004966:	656080e7          	jalr	1622(ra) # 80002fb8 <namecmp>
    8000496a:	14050a63          	beqz	a0,80004abe <sys_unlink+0x1b0>
    8000496e:	00004597          	auipc	a1,0x4
    80004972:	d0a58593          	addi	a1,a1,-758 # 80008678 <syscalls+0x2b8>
    80004976:	fb040513          	addi	a0,s0,-80
    8000497a:	ffffe097          	auipc	ra,0xffffe
    8000497e:	63e080e7          	jalr	1598(ra) # 80002fb8 <namecmp>
    80004982:	12050e63          	beqz	a0,80004abe <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004986:	f2c40613          	addi	a2,s0,-212
    8000498a:	fb040593          	addi	a1,s0,-80
    8000498e:	8526                	mv	a0,s1
    80004990:	ffffe097          	auipc	ra,0xffffe
    80004994:	642080e7          	jalr	1602(ra) # 80002fd2 <dirlookup>
    80004998:	892a                	mv	s2,a0
    8000499a:	12050263          	beqz	a0,80004abe <sys_unlink+0x1b0>
  ilock(ip);
    8000499e:	ffffe097          	auipc	ra,0xffffe
    800049a2:	150080e7          	jalr	336(ra) # 80002aee <ilock>
  if(ip->nlink < 1)
    800049a6:	04a91783          	lh	a5,74(s2)
    800049aa:	08f05263          	blez	a5,80004a2e <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800049ae:	04491703          	lh	a4,68(s2)
    800049b2:	4785                	li	a5,1
    800049b4:	08f70563          	beq	a4,a5,80004a3e <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800049b8:	4641                	li	a2,16
    800049ba:	4581                	li	a1,0
    800049bc:	fc040513          	addi	a0,s0,-64
    800049c0:	ffffb097          	auipc	ra,0xffffb
    800049c4:	7ba080e7          	jalr	1978(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049c8:	4741                	li	a4,16
    800049ca:	f2c42683          	lw	a3,-212(s0)
    800049ce:	fc040613          	addi	a2,s0,-64
    800049d2:	4581                	li	a1,0
    800049d4:	8526                	mv	a0,s1
    800049d6:	ffffe097          	auipc	ra,0xffffe
    800049da:	4c4080e7          	jalr	1220(ra) # 80002e9a <writei>
    800049de:	47c1                	li	a5,16
    800049e0:	0af51563          	bne	a0,a5,80004a8a <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800049e4:	04491703          	lh	a4,68(s2)
    800049e8:	4785                	li	a5,1
    800049ea:	0af70863          	beq	a4,a5,80004a9a <sys_unlink+0x18c>
  iunlockput(dp);
    800049ee:	8526                	mv	a0,s1
    800049f0:	ffffe097          	auipc	ra,0xffffe
    800049f4:	360080e7          	jalr	864(ra) # 80002d50 <iunlockput>
  ip->nlink--;
    800049f8:	04a95783          	lhu	a5,74(s2)
    800049fc:	37fd                	addiw	a5,a5,-1
    800049fe:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a02:	854a                	mv	a0,s2
    80004a04:	ffffe097          	auipc	ra,0xffffe
    80004a08:	01e080e7          	jalr	30(ra) # 80002a22 <iupdate>
  iunlockput(ip);
    80004a0c:	854a                	mv	a0,s2
    80004a0e:	ffffe097          	auipc	ra,0xffffe
    80004a12:	342080e7          	jalr	834(ra) # 80002d50 <iunlockput>
  end_op();
    80004a16:	fffff097          	auipc	ra,0xfffff
    80004a1a:	b22080e7          	jalr	-1246(ra) # 80003538 <end_op>
  return 0;
    80004a1e:	4501                	li	a0,0
    80004a20:	a84d                	j	80004ad2 <sys_unlink+0x1c4>
    end_op();
    80004a22:	fffff097          	auipc	ra,0xfffff
    80004a26:	b16080e7          	jalr	-1258(ra) # 80003538 <end_op>
    return -1;
    80004a2a:	557d                	li	a0,-1
    80004a2c:	a05d                	j	80004ad2 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a2e:	00004517          	auipc	a0,0x4
    80004a32:	c5250513          	addi	a0,a0,-942 # 80008680 <syscalls+0x2c0>
    80004a36:	00001097          	auipc	ra,0x1
    80004a3a:	1d6080e7          	jalr	470(ra) # 80005c0c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a3e:	04c92703          	lw	a4,76(s2)
    80004a42:	02000793          	li	a5,32
    80004a46:	f6e7f9e3          	bgeu	a5,a4,800049b8 <sys_unlink+0xaa>
    80004a4a:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a4e:	4741                	li	a4,16
    80004a50:	86ce                	mv	a3,s3
    80004a52:	f1840613          	addi	a2,s0,-232
    80004a56:	4581                	li	a1,0
    80004a58:	854a                	mv	a0,s2
    80004a5a:	ffffe097          	auipc	ra,0xffffe
    80004a5e:	348080e7          	jalr	840(ra) # 80002da2 <readi>
    80004a62:	47c1                	li	a5,16
    80004a64:	00f51b63          	bne	a0,a5,80004a7a <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a68:	f1845783          	lhu	a5,-232(s0)
    80004a6c:	e7a1                	bnez	a5,80004ab4 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a6e:	29c1                	addiw	s3,s3,16
    80004a70:	04c92783          	lw	a5,76(s2)
    80004a74:	fcf9ede3          	bltu	s3,a5,80004a4e <sys_unlink+0x140>
    80004a78:	b781                	j	800049b8 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a7a:	00004517          	auipc	a0,0x4
    80004a7e:	c1e50513          	addi	a0,a0,-994 # 80008698 <syscalls+0x2d8>
    80004a82:	00001097          	auipc	ra,0x1
    80004a86:	18a080e7          	jalr	394(ra) # 80005c0c <panic>
    panic("unlink: writei");
    80004a8a:	00004517          	auipc	a0,0x4
    80004a8e:	c2650513          	addi	a0,a0,-986 # 800086b0 <syscalls+0x2f0>
    80004a92:	00001097          	auipc	ra,0x1
    80004a96:	17a080e7          	jalr	378(ra) # 80005c0c <panic>
    dp->nlink--;
    80004a9a:	04a4d783          	lhu	a5,74(s1)
    80004a9e:	37fd                	addiw	a5,a5,-1
    80004aa0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004aa4:	8526                	mv	a0,s1
    80004aa6:	ffffe097          	auipc	ra,0xffffe
    80004aaa:	f7c080e7          	jalr	-132(ra) # 80002a22 <iupdate>
    80004aae:	b781                	j	800049ee <sys_unlink+0xe0>
    return -1;
    80004ab0:	557d                	li	a0,-1
    80004ab2:	a005                	j	80004ad2 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004ab4:	854a                	mv	a0,s2
    80004ab6:	ffffe097          	auipc	ra,0xffffe
    80004aba:	29a080e7          	jalr	666(ra) # 80002d50 <iunlockput>
  iunlockput(dp);
    80004abe:	8526                	mv	a0,s1
    80004ac0:	ffffe097          	auipc	ra,0xffffe
    80004ac4:	290080e7          	jalr	656(ra) # 80002d50 <iunlockput>
  end_op();
    80004ac8:	fffff097          	auipc	ra,0xfffff
    80004acc:	a70080e7          	jalr	-1424(ra) # 80003538 <end_op>
  return -1;
    80004ad0:	557d                	li	a0,-1
}
    80004ad2:	70ae                	ld	ra,232(sp)
    80004ad4:	740e                	ld	s0,224(sp)
    80004ad6:	64ee                	ld	s1,216(sp)
    80004ad8:	694e                	ld	s2,208(sp)
    80004ada:	69ae                	ld	s3,200(sp)
    80004adc:	616d                	addi	sp,sp,240
    80004ade:	8082                	ret

0000000080004ae0 <sys_mmap>:
{
    80004ae0:	1141                	addi	sp,sp,-16
    80004ae2:	e422                	sd	s0,8(sp)
    80004ae4:	0800                	addi	s0,sp,16
}
    80004ae6:	4501                	li	a0,0
    80004ae8:	6422                	ld	s0,8(sp)
    80004aea:	0141                	addi	sp,sp,16
    80004aec:	8082                	ret

0000000080004aee <sys_munmap>:
{
    80004aee:	1141                	addi	sp,sp,-16
    80004af0:	e422                	sd	s0,8(sp)
    80004af2:	0800                	addi	s0,sp,16
}
    80004af4:	4501                	li	a0,0
    80004af6:	6422                	ld	s0,8(sp)
    80004af8:	0141                	addi	sp,sp,16
    80004afa:	8082                	ret

0000000080004afc <sys_open>:

uint64
sys_open(void)
{
    80004afc:	7131                	addi	sp,sp,-192
    80004afe:	fd06                	sd	ra,184(sp)
    80004b00:	f922                	sd	s0,176(sp)
    80004b02:	f526                	sd	s1,168(sp)
    80004b04:	f14a                	sd	s2,160(sp)
    80004b06:	ed4e                	sd	s3,152(sp)
    80004b08:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004b0a:	f4c40593          	addi	a1,s0,-180
    80004b0e:	4505                	li	a0,1
    80004b10:	ffffd097          	auipc	ra,0xffffd
    80004b14:	466080e7          	jalr	1126(ra) # 80001f76 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b18:	08000613          	li	a2,128
    80004b1c:	f5040593          	addi	a1,s0,-176
    80004b20:	4501                	li	a0,0
    80004b22:	ffffd097          	auipc	ra,0xffffd
    80004b26:	494080e7          	jalr	1172(ra) # 80001fb6 <argstr>
    80004b2a:	87aa                	mv	a5,a0
    return -1;
    80004b2c:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b2e:	0a07c963          	bltz	a5,80004be0 <sys_open+0xe4>

  begin_op();
    80004b32:	fffff097          	auipc	ra,0xfffff
    80004b36:	988080e7          	jalr	-1656(ra) # 800034ba <begin_op>

  if(omode & O_CREATE){
    80004b3a:	f4c42783          	lw	a5,-180(s0)
    80004b3e:	2007f793          	andi	a5,a5,512
    80004b42:	cfc5                	beqz	a5,80004bfa <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b44:	4681                	li	a3,0
    80004b46:	4601                	li	a2,0
    80004b48:	4589                	li	a1,2
    80004b4a:	f5040513          	addi	a0,s0,-176
    80004b4e:	00000097          	auipc	ra,0x0
    80004b52:	956080e7          	jalr	-1706(ra) # 800044a4 <create>
    80004b56:	84aa                	mv	s1,a0
    if(ip == 0){
    80004b58:	c959                	beqz	a0,80004bee <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b5a:	04449703          	lh	a4,68(s1)
    80004b5e:	478d                	li	a5,3
    80004b60:	00f71763          	bne	a4,a5,80004b6e <sys_open+0x72>
    80004b64:	0464d703          	lhu	a4,70(s1)
    80004b68:	47a5                	li	a5,9
    80004b6a:	0ce7ed63          	bltu	a5,a4,80004c44 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b6e:	fffff097          	auipc	ra,0xfffff
    80004b72:	d58080e7          	jalr	-680(ra) # 800038c6 <filealloc>
    80004b76:	89aa                	mv	s3,a0
    80004b78:	10050363          	beqz	a0,80004c7e <sys_open+0x182>
    80004b7c:	00000097          	auipc	ra,0x0
    80004b80:	8e6080e7          	jalr	-1818(ra) # 80004462 <fdalloc>
    80004b84:	892a                	mv	s2,a0
    80004b86:	0e054763          	bltz	a0,80004c74 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b8a:	04449703          	lh	a4,68(s1)
    80004b8e:	478d                	li	a5,3
    80004b90:	0cf70563          	beq	a4,a5,80004c5a <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b94:	4789                	li	a5,2
    80004b96:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b9a:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004b9e:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004ba2:	f4c42783          	lw	a5,-180(s0)
    80004ba6:	0017c713          	xori	a4,a5,1
    80004baa:	8b05                	andi	a4,a4,1
    80004bac:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004bb0:	0037f713          	andi	a4,a5,3
    80004bb4:	00e03733          	snez	a4,a4
    80004bb8:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004bbc:	4007f793          	andi	a5,a5,1024
    80004bc0:	c791                	beqz	a5,80004bcc <sys_open+0xd0>
    80004bc2:	04449703          	lh	a4,68(s1)
    80004bc6:	4789                	li	a5,2
    80004bc8:	0af70063          	beq	a4,a5,80004c68 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004bcc:	8526                	mv	a0,s1
    80004bce:	ffffe097          	auipc	ra,0xffffe
    80004bd2:	fe2080e7          	jalr	-30(ra) # 80002bb0 <iunlock>
  end_op();
    80004bd6:	fffff097          	auipc	ra,0xfffff
    80004bda:	962080e7          	jalr	-1694(ra) # 80003538 <end_op>

  return fd;
    80004bde:	854a                	mv	a0,s2
}
    80004be0:	70ea                	ld	ra,184(sp)
    80004be2:	744a                	ld	s0,176(sp)
    80004be4:	74aa                	ld	s1,168(sp)
    80004be6:	790a                	ld	s2,160(sp)
    80004be8:	69ea                	ld	s3,152(sp)
    80004bea:	6129                	addi	sp,sp,192
    80004bec:	8082                	ret
      end_op();
    80004bee:	fffff097          	auipc	ra,0xfffff
    80004bf2:	94a080e7          	jalr	-1718(ra) # 80003538 <end_op>
      return -1;
    80004bf6:	557d                	li	a0,-1
    80004bf8:	b7e5                	j	80004be0 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004bfa:	f5040513          	addi	a0,s0,-176
    80004bfe:	ffffe097          	auipc	ra,0xffffe
    80004c02:	69c080e7          	jalr	1692(ra) # 8000329a <namei>
    80004c06:	84aa                	mv	s1,a0
    80004c08:	c905                	beqz	a0,80004c38 <sys_open+0x13c>
    ilock(ip);
    80004c0a:	ffffe097          	auipc	ra,0xffffe
    80004c0e:	ee4080e7          	jalr	-284(ra) # 80002aee <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c12:	04449703          	lh	a4,68(s1)
    80004c16:	4785                	li	a5,1
    80004c18:	f4f711e3          	bne	a4,a5,80004b5a <sys_open+0x5e>
    80004c1c:	f4c42783          	lw	a5,-180(s0)
    80004c20:	d7b9                	beqz	a5,80004b6e <sys_open+0x72>
      iunlockput(ip);
    80004c22:	8526                	mv	a0,s1
    80004c24:	ffffe097          	auipc	ra,0xffffe
    80004c28:	12c080e7          	jalr	300(ra) # 80002d50 <iunlockput>
      end_op();
    80004c2c:	fffff097          	auipc	ra,0xfffff
    80004c30:	90c080e7          	jalr	-1780(ra) # 80003538 <end_op>
      return -1;
    80004c34:	557d                	li	a0,-1
    80004c36:	b76d                	j	80004be0 <sys_open+0xe4>
      end_op();
    80004c38:	fffff097          	auipc	ra,0xfffff
    80004c3c:	900080e7          	jalr	-1792(ra) # 80003538 <end_op>
      return -1;
    80004c40:	557d                	li	a0,-1
    80004c42:	bf79                	j	80004be0 <sys_open+0xe4>
    iunlockput(ip);
    80004c44:	8526                	mv	a0,s1
    80004c46:	ffffe097          	auipc	ra,0xffffe
    80004c4a:	10a080e7          	jalr	266(ra) # 80002d50 <iunlockput>
    end_op();
    80004c4e:	fffff097          	auipc	ra,0xfffff
    80004c52:	8ea080e7          	jalr	-1814(ra) # 80003538 <end_op>
    return -1;
    80004c56:	557d                	li	a0,-1
    80004c58:	b761                	j	80004be0 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c5a:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c5e:	04649783          	lh	a5,70(s1)
    80004c62:	02f99223          	sh	a5,36(s3)
    80004c66:	bf25                	j	80004b9e <sys_open+0xa2>
    itrunc(ip);
    80004c68:	8526                	mv	a0,s1
    80004c6a:	ffffe097          	auipc	ra,0xffffe
    80004c6e:	f92080e7          	jalr	-110(ra) # 80002bfc <itrunc>
    80004c72:	bfa9                	j	80004bcc <sys_open+0xd0>
      fileclose(f);
    80004c74:	854e                	mv	a0,s3
    80004c76:	fffff097          	auipc	ra,0xfffff
    80004c7a:	d0c080e7          	jalr	-756(ra) # 80003982 <fileclose>
    iunlockput(ip);
    80004c7e:	8526                	mv	a0,s1
    80004c80:	ffffe097          	auipc	ra,0xffffe
    80004c84:	0d0080e7          	jalr	208(ra) # 80002d50 <iunlockput>
    end_op();
    80004c88:	fffff097          	auipc	ra,0xfffff
    80004c8c:	8b0080e7          	jalr	-1872(ra) # 80003538 <end_op>
    return -1;
    80004c90:	557d                	li	a0,-1
    80004c92:	b7b9                	j	80004be0 <sys_open+0xe4>

0000000080004c94 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c94:	7175                	addi	sp,sp,-144
    80004c96:	e506                	sd	ra,136(sp)
    80004c98:	e122                	sd	s0,128(sp)
    80004c9a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c9c:	fffff097          	auipc	ra,0xfffff
    80004ca0:	81e080e7          	jalr	-2018(ra) # 800034ba <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004ca4:	08000613          	li	a2,128
    80004ca8:	f7040593          	addi	a1,s0,-144
    80004cac:	4501                	li	a0,0
    80004cae:	ffffd097          	auipc	ra,0xffffd
    80004cb2:	308080e7          	jalr	776(ra) # 80001fb6 <argstr>
    80004cb6:	02054963          	bltz	a0,80004ce8 <sys_mkdir+0x54>
    80004cba:	4681                	li	a3,0
    80004cbc:	4601                	li	a2,0
    80004cbe:	4585                	li	a1,1
    80004cc0:	f7040513          	addi	a0,s0,-144
    80004cc4:	fffff097          	auipc	ra,0xfffff
    80004cc8:	7e0080e7          	jalr	2016(ra) # 800044a4 <create>
    80004ccc:	cd11                	beqz	a0,80004ce8 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cce:	ffffe097          	auipc	ra,0xffffe
    80004cd2:	082080e7          	jalr	130(ra) # 80002d50 <iunlockput>
  end_op();
    80004cd6:	fffff097          	auipc	ra,0xfffff
    80004cda:	862080e7          	jalr	-1950(ra) # 80003538 <end_op>
  return 0;
    80004cde:	4501                	li	a0,0
}
    80004ce0:	60aa                	ld	ra,136(sp)
    80004ce2:	640a                	ld	s0,128(sp)
    80004ce4:	6149                	addi	sp,sp,144
    80004ce6:	8082                	ret
    end_op();
    80004ce8:	fffff097          	auipc	ra,0xfffff
    80004cec:	850080e7          	jalr	-1968(ra) # 80003538 <end_op>
    return -1;
    80004cf0:	557d                	li	a0,-1
    80004cf2:	b7fd                	j	80004ce0 <sys_mkdir+0x4c>

0000000080004cf4 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004cf4:	7135                	addi	sp,sp,-160
    80004cf6:	ed06                	sd	ra,152(sp)
    80004cf8:	e922                	sd	s0,144(sp)
    80004cfa:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004cfc:	ffffe097          	auipc	ra,0xffffe
    80004d00:	7be080e7          	jalr	1982(ra) # 800034ba <begin_op>
  argint(1, &major);
    80004d04:	f6c40593          	addi	a1,s0,-148
    80004d08:	4505                	li	a0,1
    80004d0a:	ffffd097          	auipc	ra,0xffffd
    80004d0e:	26c080e7          	jalr	620(ra) # 80001f76 <argint>
  argint(2, &minor);
    80004d12:	f6840593          	addi	a1,s0,-152
    80004d16:	4509                	li	a0,2
    80004d18:	ffffd097          	auipc	ra,0xffffd
    80004d1c:	25e080e7          	jalr	606(ra) # 80001f76 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d20:	08000613          	li	a2,128
    80004d24:	f7040593          	addi	a1,s0,-144
    80004d28:	4501                	li	a0,0
    80004d2a:	ffffd097          	auipc	ra,0xffffd
    80004d2e:	28c080e7          	jalr	652(ra) # 80001fb6 <argstr>
    80004d32:	02054b63          	bltz	a0,80004d68 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d36:	f6841683          	lh	a3,-152(s0)
    80004d3a:	f6c41603          	lh	a2,-148(s0)
    80004d3e:	458d                	li	a1,3
    80004d40:	f7040513          	addi	a0,s0,-144
    80004d44:	fffff097          	auipc	ra,0xfffff
    80004d48:	760080e7          	jalr	1888(ra) # 800044a4 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d4c:	cd11                	beqz	a0,80004d68 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d4e:	ffffe097          	auipc	ra,0xffffe
    80004d52:	002080e7          	jalr	2(ra) # 80002d50 <iunlockput>
  end_op();
    80004d56:	ffffe097          	auipc	ra,0xffffe
    80004d5a:	7e2080e7          	jalr	2018(ra) # 80003538 <end_op>
  return 0;
    80004d5e:	4501                	li	a0,0
}
    80004d60:	60ea                	ld	ra,152(sp)
    80004d62:	644a                	ld	s0,144(sp)
    80004d64:	610d                	addi	sp,sp,160
    80004d66:	8082                	ret
    end_op();
    80004d68:	ffffe097          	auipc	ra,0xffffe
    80004d6c:	7d0080e7          	jalr	2000(ra) # 80003538 <end_op>
    return -1;
    80004d70:	557d                	li	a0,-1
    80004d72:	b7fd                	j	80004d60 <sys_mknod+0x6c>

0000000080004d74 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d74:	7135                	addi	sp,sp,-160
    80004d76:	ed06                	sd	ra,152(sp)
    80004d78:	e922                	sd	s0,144(sp)
    80004d7a:	e526                	sd	s1,136(sp)
    80004d7c:	e14a                	sd	s2,128(sp)
    80004d7e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d80:	ffffc097          	auipc	ra,0xffffc
    80004d84:	0ba080e7          	jalr	186(ra) # 80000e3a <myproc>
    80004d88:	892a                	mv	s2,a0
  
  begin_op();
    80004d8a:	ffffe097          	auipc	ra,0xffffe
    80004d8e:	730080e7          	jalr	1840(ra) # 800034ba <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d92:	08000613          	li	a2,128
    80004d96:	f6040593          	addi	a1,s0,-160
    80004d9a:	4501                	li	a0,0
    80004d9c:	ffffd097          	auipc	ra,0xffffd
    80004da0:	21a080e7          	jalr	538(ra) # 80001fb6 <argstr>
    80004da4:	04054b63          	bltz	a0,80004dfa <sys_chdir+0x86>
    80004da8:	f6040513          	addi	a0,s0,-160
    80004dac:	ffffe097          	auipc	ra,0xffffe
    80004db0:	4ee080e7          	jalr	1262(ra) # 8000329a <namei>
    80004db4:	84aa                	mv	s1,a0
    80004db6:	c131                	beqz	a0,80004dfa <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004db8:	ffffe097          	auipc	ra,0xffffe
    80004dbc:	d36080e7          	jalr	-714(ra) # 80002aee <ilock>
  if(ip->type != T_DIR){
    80004dc0:	04449703          	lh	a4,68(s1)
    80004dc4:	4785                	li	a5,1
    80004dc6:	04f71063          	bne	a4,a5,80004e06 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004dca:	8526                	mv	a0,s1
    80004dcc:	ffffe097          	auipc	ra,0xffffe
    80004dd0:	de4080e7          	jalr	-540(ra) # 80002bb0 <iunlock>
  iput(p->cwd);
    80004dd4:	15093503          	ld	a0,336(s2)
    80004dd8:	ffffe097          	auipc	ra,0xffffe
    80004ddc:	ed0080e7          	jalr	-304(ra) # 80002ca8 <iput>
  end_op();
    80004de0:	ffffe097          	auipc	ra,0xffffe
    80004de4:	758080e7          	jalr	1880(ra) # 80003538 <end_op>
  p->cwd = ip;
    80004de8:	14993823          	sd	s1,336(s2)
  return 0;
    80004dec:	4501                	li	a0,0
}
    80004dee:	60ea                	ld	ra,152(sp)
    80004df0:	644a                	ld	s0,144(sp)
    80004df2:	64aa                	ld	s1,136(sp)
    80004df4:	690a                	ld	s2,128(sp)
    80004df6:	610d                	addi	sp,sp,160
    80004df8:	8082                	ret
    end_op();
    80004dfa:	ffffe097          	auipc	ra,0xffffe
    80004dfe:	73e080e7          	jalr	1854(ra) # 80003538 <end_op>
    return -1;
    80004e02:	557d                	li	a0,-1
    80004e04:	b7ed                	j	80004dee <sys_chdir+0x7a>
    iunlockput(ip);
    80004e06:	8526                	mv	a0,s1
    80004e08:	ffffe097          	auipc	ra,0xffffe
    80004e0c:	f48080e7          	jalr	-184(ra) # 80002d50 <iunlockput>
    end_op();
    80004e10:	ffffe097          	auipc	ra,0xffffe
    80004e14:	728080e7          	jalr	1832(ra) # 80003538 <end_op>
    return -1;
    80004e18:	557d                	li	a0,-1
    80004e1a:	bfd1                	j	80004dee <sys_chdir+0x7a>

0000000080004e1c <sys_exec>:

uint64
sys_exec(void)
{
    80004e1c:	7145                	addi	sp,sp,-464
    80004e1e:	e786                	sd	ra,456(sp)
    80004e20:	e3a2                	sd	s0,448(sp)
    80004e22:	ff26                	sd	s1,440(sp)
    80004e24:	fb4a                	sd	s2,432(sp)
    80004e26:	f74e                	sd	s3,424(sp)
    80004e28:	f352                	sd	s4,416(sp)
    80004e2a:	ef56                	sd	s5,408(sp)
    80004e2c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004e2e:	e3840593          	addi	a1,s0,-456
    80004e32:	4505                	li	a0,1
    80004e34:	ffffd097          	auipc	ra,0xffffd
    80004e38:	162080e7          	jalr	354(ra) # 80001f96 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004e3c:	08000613          	li	a2,128
    80004e40:	f4040593          	addi	a1,s0,-192
    80004e44:	4501                	li	a0,0
    80004e46:	ffffd097          	auipc	ra,0xffffd
    80004e4a:	170080e7          	jalr	368(ra) # 80001fb6 <argstr>
    80004e4e:	87aa                	mv	a5,a0
    return -1;
    80004e50:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004e52:	0c07c363          	bltz	a5,80004f18 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004e56:	10000613          	li	a2,256
    80004e5a:	4581                	li	a1,0
    80004e5c:	e4040513          	addi	a0,s0,-448
    80004e60:	ffffb097          	auipc	ra,0xffffb
    80004e64:	31a080e7          	jalr	794(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e68:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004e6c:	89a6                	mv	s3,s1
    80004e6e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e70:	02000a13          	li	s4,32
    80004e74:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e78:	00391513          	slli	a0,s2,0x3
    80004e7c:	e3040593          	addi	a1,s0,-464
    80004e80:	e3843783          	ld	a5,-456(s0)
    80004e84:	953e                	add	a0,a0,a5
    80004e86:	ffffd097          	auipc	ra,0xffffd
    80004e8a:	052080e7          	jalr	82(ra) # 80001ed8 <fetchaddr>
    80004e8e:	02054a63          	bltz	a0,80004ec2 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004e92:	e3043783          	ld	a5,-464(s0)
    80004e96:	c3b9                	beqz	a5,80004edc <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e98:	ffffb097          	auipc	ra,0xffffb
    80004e9c:	282080e7          	jalr	642(ra) # 8000011a <kalloc>
    80004ea0:	85aa                	mv	a1,a0
    80004ea2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ea6:	cd11                	beqz	a0,80004ec2 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ea8:	6605                	lui	a2,0x1
    80004eaa:	e3043503          	ld	a0,-464(s0)
    80004eae:	ffffd097          	auipc	ra,0xffffd
    80004eb2:	07c080e7          	jalr	124(ra) # 80001f2a <fetchstr>
    80004eb6:	00054663          	bltz	a0,80004ec2 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004eba:	0905                	addi	s2,s2,1
    80004ebc:	09a1                	addi	s3,s3,8
    80004ebe:	fb491be3          	bne	s2,s4,80004e74 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ec2:	f4040913          	addi	s2,s0,-192
    80004ec6:	6088                	ld	a0,0(s1)
    80004ec8:	c539                	beqz	a0,80004f16 <sys_exec+0xfa>
    kfree(argv[i]);
    80004eca:	ffffb097          	auipc	ra,0xffffb
    80004ece:	152080e7          	jalr	338(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ed2:	04a1                	addi	s1,s1,8
    80004ed4:	ff2499e3          	bne	s1,s2,80004ec6 <sys_exec+0xaa>
  return -1;
    80004ed8:	557d                	li	a0,-1
    80004eda:	a83d                	j	80004f18 <sys_exec+0xfc>
      argv[i] = 0;
    80004edc:	0a8e                	slli	s5,s5,0x3
    80004ede:	fc0a8793          	addi	a5,s5,-64
    80004ee2:	00878ab3          	add	s5,a5,s0
    80004ee6:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004eea:	e4040593          	addi	a1,s0,-448
    80004eee:	f4040513          	addi	a0,s0,-192
    80004ef2:	fffff097          	auipc	ra,0xfffff
    80004ef6:	152080e7          	jalr	338(ra) # 80004044 <exec>
    80004efa:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004efc:	f4040993          	addi	s3,s0,-192
    80004f00:	6088                	ld	a0,0(s1)
    80004f02:	c901                	beqz	a0,80004f12 <sys_exec+0xf6>
    kfree(argv[i]);
    80004f04:	ffffb097          	auipc	ra,0xffffb
    80004f08:	118080e7          	jalr	280(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f0c:	04a1                	addi	s1,s1,8
    80004f0e:	ff3499e3          	bne	s1,s3,80004f00 <sys_exec+0xe4>
  return ret;
    80004f12:	854a                	mv	a0,s2
    80004f14:	a011                	j	80004f18 <sys_exec+0xfc>
  return -1;
    80004f16:	557d                	li	a0,-1
}
    80004f18:	60be                	ld	ra,456(sp)
    80004f1a:	641e                	ld	s0,448(sp)
    80004f1c:	74fa                	ld	s1,440(sp)
    80004f1e:	795a                	ld	s2,432(sp)
    80004f20:	79ba                	ld	s3,424(sp)
    80004f22:	7a1a                	ld	s4,416(sp)
    80004f24:	6afa                	ld	s5,408(sp)
    80004f26:	6179                	addi	sp,sp,464
    80004f28:	8082                	ret

0000000080004f2a <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f2a:	7139                	addi	sp,sp,-64
    80004f2c:	fc06                	sd	ra,56(sp)
    80004f2e:	f822                	sd	s0,48(sp)
    80004f30:	f426                	sd	s1,40(sp)
    80004f32:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f34:	ffffc097          	auipc	ra,0xffffc
    80004f38:	f06080e7          	jalr	-250(ra) # 80000e3a <myproc>
    80004f3c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004f3e:	fd840593          	addi	a1,s0,-40
    80004f42:	4501                	li	a0,0
    80004f44:	ffffd097          	auipc	ra,0xffffd
    80004f48:	052080e7          	jalr	82(ra) # 80001f96 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004f4c:	fc840593          	addi	a1,s0,-56
    80004f50:	fd040513          	addi	a0,s0,-48
    80004f54:	fffff097          	auipc	ra,0xfffff
    80004f58:	da6080e7          	jalr	-602(ra) # 80003cfa <pipealloc>
    return -1;
    80004f5c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f5e:	0c054463          	bltz	a0,80005026 <sys_pipe+0xfc>
  fd0 = -1;
    80004f62:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f66:	fd043503          	ld	a0,-48(s0)
    80004f6a:	fffff097          	auipc	ra,0xfffff
    80004f6e:	4f8080e7          	jalr	1272(ra) # 80004462 <fdalloc>
    80004f72:	fca42223          	sw	a0,-60(s0)
    80004f76:	08054b63          	bltz	a0,8000500c <sys_pipe+0xe2>
    80004f7a:	fc843503          	ld	a0,-56(s0)
    80004f7e:	fffff097          	auipc	ra,0xfffff
    80004f82:	4e4080e7          	jalr	1252(ra) # 80004462 <fdalloc>
    80004f86:	fca42023          	sw	a0,-64(s0)
    80004f8a:	06054863          	bltz	a0,80004ffa <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f8e:	4691                	li	a3,4
    80004f90:	fc440613          	addi	a2,s0,-60
    80004f94:	fd843583          	ld	a1,-40(s0)
    80004f98:	68a8                	ld	a0,80(s1)
    80004f9a:	ffffc097          	auipc	ra,0xffffc
    80004f9e:	b60080e7          	jalr	-1184(ra) # 80000afa <copyout>
    80004fa2:	02054063          	bltz	a0,80004fc2 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004fa6:	4691                	li	a3,4
    80004fa8:	fc040613          	addi	a2,s0,-64
    80004fac:	fd843583          	ld	a1,-40(s0)
    80004fb0:	0591                	addi	a1,a1,4
    80004fb2:	68a8                	ld	a0,80(s1)
    80004fb4:	ffffc097          	auipc	ra,0xffffc
    80004fb8:	b46080e7          	jalr	-1210(ra) # 80000afa <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004fbc:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fbe:	06055463          	bgez	a0,80005026 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80004fc2:	fc442783          	lw	a5,-60(s0)
    80004fc6:	07e9                	addi	a5,a5,26
    80004fc8:	078e                	slli	a5,a5,0x3
    80004fca:	97a6                	add	a5,a5,s1
    80004fcc:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004fd0:	fc042783          	lw	a5,-64(s0)
    80004fd4:	07e9                	addi	a5,a5,26
    80004fd6:	078e                	slli	a5,a5,0x3
    80004fd8:	94be                	add	s1,s1,a5
    80004fda:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004fde:	fd043503          	ld	a0,-48(s0)
    80004fe2:	fffff097          	auipc	ra,0xfffff
    80004fe6:	9a0080e7          	jalr	-1632(ra) # 80003982 <fileclose>
    fileclose(wf);
    80004fea:	fc843503          	ld	a0,-56(s0)
    80004fee:	fffff097          	auipc	ra,0xfffff
    80004ff2:	994080e7          	jalr	-1644(ra) # 80003982 <fileclose>
    return -1;
    80004ff6:	57fd                	li	a5,-1
    80004ff8:	a03d                	j	80005026 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80004ffa:	fc442783          	lw	a5,-60(s0)
    80004ffe:	0007c763          	bltz	a5,8000500c <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005002:	07e9                	addi	a5,a5,26
    80005004:	078e                	slli	a5,a5,0x3
    80005006:	97a6                	add	a5,a5,s1
    80005008:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000500c:	fd043503          	ld	a0,-48(s0)
    80005010:	fffff097          	auipc	ra,0xfffff
    80005014:	972080e7          	jalr	-1678(ra) # 80003982 <fileclose>
    fileclose(wf);
    80005018:	fc843503          	ld	a0,-56(s0)
    8000501c:	fffff097          	auipc	ra,0xfffff
    80005020:	966080e7          	jalr	-1690(ra) # 80003982 <fileclose>
    return -1;
    80005024:	57fd                	li	a5,-1
}
    80005026:	853e                	mv	a0,a5
    80005028:	70e2                	ld	ra,56(sp)
    8000502a:	7442                	ld	s0,48(sp)
    8000502c:	74a2                	ld	s1,40(sp)
    8000502e:	6121                	addi	sp,sp,64
    80005030:	8082                	ret
	...

0000000080005040 <kernelvec>:
    80005040:	7111                	addi	sp,sp,-256
    80005042:	e006                	sd	ra,0(sp)
    80005044:	e40a                	sd	sp,8(sp)
    80005046:	e80e                	sd	gp,16(sp)
    80005048:	ec12                	sd	tp,24(sp)
    8000504a:	f016                	sd	t0,32(sp)
    8000504c:	f41a                	sd	t1,40(sp)
    8000504e:	f81e                	sd	t2,48(sp)
    80005050:	fc22                	sd	s0,56(sp)
    80005052:	e0a6                	sd	s1,64(sp)
    80005054:	e4aa                	sd	a0,72(sp)
    80005056:	e8ae                	sd	a1,80(sp)
    80005058:	ecb2                	sd	a2,88(sp)
    8000505a:	f0b6                	sd	a3,96(sp)
    8000505c:	f4ba                	sd	a4,104(sp)
    8000505e:	f8be                	sd	a5,112(sp)
    80005060:	fcc2                	sd	a6,120(sp)
    80005062:	e146                	sd	a7,128(sp)
    80005064:	e54a                	sd	s2,136(sp)
    80005066:	e94e                	sd	s3,144(sp)
    80005068:	ed52                	sd	s4,152(sp)
    8000506a:	f156                	sd	s5,160(sp)
    8000506c:	f55a                	sd	s6,168(sp)
    8000506e:	f95e                	sd	s7,176(sp)
    80005070:	fd62                	sd	s8,184(sp)
    80005072:	e1e6                	sd	s9,192(sp)
    80005074:	e5ea                	sd	s10,200(sp)
    80005076:	e9ee                	sd	s11,208(sp)
    80005078:	edf2                	sd	t3,216(sp)
    8000507a:	f1f6                	sd	t4,224(sp)
    8000507c:	f5fa                	sd	t5,232(sp)
    8000507e:	f9fe                	sd	t6,240(sp)
    80005080:	d25fc0ef          	jal	ra,80001da4 <kerneltrap>
    80005084:	6082                	ld	ra,0(sp)
    80005086:	6122                	ld	sp,8(sp)
    80005088:	61c2                	ld	gp,16(sp)
    8000508a:	7282                	ld	t0,32(sp)
    8000508c:	7322                	ld	t1,40(sp)
    8000508e:	73c2                	ld	t2,48(sp)
    80005090:	7462                	ld	s0,56(sp)
    80005092:	6486                	ld	s1,64(sp)
    80005094:	6526                	ld	a0,72(sp)
    80005096:	65c6                	ld	a1,80(sp)
    80005098:	6666                	ld	a2,88(sp)
    8000509a:	7686                	ld	a3,96(sp)
    8000509c:	7726                	ld	a4,104(sp)
    8000509e:	77c6                	ld	a5,112(sp)
    800050a0:	7866                	ld	a6,120(sp)
    800050a2:	688a                	ld	a7,128(sp)
    800050a4:	692a                	ld	s2,136(sp)
    800050a6:	69ca                	ld	s3,144(sp)
    800050a8:	6a6a                	ld	s4,152(sp)
    800050aa:	7a8a                	ld	s5,160(sp)
    800050ac:	7b2a                	ld	s6,168(sp)
    800050ae:	7bca                	ld	s7,176(sp)
    800050b0:	7c6a                	ld	s8,184(sp)
    800050b2:	6c8e                	ld	s9,192(sp)
    800050b4:	6d2e                	ld	s10,200(sp)
    800050b6:	6dce                	ld	s11,208(sp)
    800050b8:	6e6e                	ld	t3,216(sp)
    800050ba:	7e8e                	ld	t4,224(sp)
    800050bc:	7f2e                	ld	t5,232(sp)
    800050be:	7fce                	ld	t6,240(sp)
    800050c0:	6111                	addi	sp,sp,256
    800050c2:	10200073          	sret
    800050c6:	00000013          	nop
    800050ca:	00000013          	nop
    800050ce:	0001                	nop

00000000800050d0 <timervec>:
    800050d0:	34051573          	csrrw	a0,mscratch,a0
    800050d4:	e10c                	sd	a1,0(a0)
    800050d6:	e510                	sd	a2,8(a0)
    800050d8:	e914                	sd	a3,16(a0)
    800050da:	6d0c                	ld	a1,24(a0)
    800050dc:	7110                	ld	a2,32(a0)
    800050de:	6194                	ld	a3,0(a1)
    800050e0:	96b2                	add	a3,a3,a2
    800050e2:	e194                	sd	a3,0(a1)
    800050e4:	4589                	li	a1,2
    800050e6:	14459073          	csrw	sip,a1
    800050ea:	6914                	ld	a3,16(a0)
    800050ec:	6510                	ld	a2,8(a0)
    800050ee:	610c                	ld	a1,0(a0)
    800050f0:	34051573          	csrrw	a0,mscratch,a0
    800050f4:	30200073          	mret
	...

00000000800050fa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800050fa:	1141                	addi	sp,sp,-16
    800050fc:	e422                	sd	s0,8(sp)
    800050fe:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005100:	0c0007b7          	lui	a5,0xc000
    80005104:	4705                	li	a4,1
    80005106:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005108:	c3d8                	sw	a4,4(a5)
}
    8000510a:	6422                	ld	s0,8(sp)
    8000510c:	0141                	addi	sp,sp,16
    8000510e:	8082                	ret

0000000080005110 <plicinithart>:

void
plicinithart(void)
{
    80005110:	1141                	addi	sp,sp,-16
    80005112:	e406                	sd	ra,8(sp)
    80005114:	e022                	sd	s0,0(sp)
    80005116:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005118:	ffffc097          	auipc	ra,0xffffc
    8000511c:	cf6080e7          	jalr	-778(ra) # 80000e0e <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005120:	0085171b          	slliw	a4,a0,0x8
    80005124:	0c0027b7          	lui	a5,0xc002
    80005128:	97ba                	add	a5,a5,a4
    8000512a:	40200713          	li	a4,1026
    8000512e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005132:	00d5151b          	slliw	a0,a0,0xd
    80005136:	0c2017b7          	lui	a5,0xc201
    8000513a:	97aa                	add	a5,a5,a0
    8000513c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005140:	60a2                	ld	ra,8(sp)
    80005142:	6402                	ld	s0,0(sp)
    80005144:	0141                	addi	sp,sp,16
    80005146:	8082                	ret

0000000080005148 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005148:	1141                	addi	sp,sp,-16
    8000514a:	e406                	sd	ra,8(sp)
    8000514c:	e022                	sd	s0,0(sp)
    8000514e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005150:	ffffc097          	auipc	ra,0xffffc
    80005154:	cbe080e7          	jalr	-834(ra) # 80000e0e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005158:	00d5151b          	slliw	a0,a0,0xd
    8000515c:	0c2017b7          	lui	a5,0xc201
    80005160:	97aa                	add	a5,a5,a0
  return irq;
}
    80005162:	43c8                	lw	a0,4(a5)
    80005164:	60a2                	ld	ra,8(sp)
    80005166:	6402                	ld	s0,0(sp)
    80005168:	0141                	addi	sp,sp,16
    8000516a:	8082                	ret

000000008000516c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000516c:	1101                	addi	sp,sp,-32
    8000516e:	ec06                	sd	ra,24(sp)
    80005170:	e822                	sd	s0,16(sp)
    80005172:	e426                	sd	s1,8(sp)
    80005174:	1000                	addi	s0,sp,32
    80005176:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005178:	ffffc097          	auipc	ra,0xffffc
    8000517c:	c96080e7          	jalr	-874(ra) # 80000e0e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005180:	00d5151b          	slliw	a0,a0,0xd
    80005184:	0c2017b7          	lui	a5,0xc201
    80005188:	97aa                	add	a5,a5,a0
    8000518a:	c3c4                	sw	s1,4(a5)
}
    8000518c:	60e2                	ld	ra,24(sp)
    8000518e:	6442                	ld	s0,16(sp)
    80005190:	64a2                	ld	s1,8(sp)
    80005192:	6105                	addi	sp,sp,32
    80005194:	8082                	ret

0000000080005196 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005196:	1141                	addi	sp,sp,-16
    80005198:	e406                	sd	ra,8(sp)
    8000519a:	e022                	sd	s0,0(sp)
    8000519c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000519e:	479d                	li	a5,7
    800051a0:	04a7cc63          	blt	a5,a0,800051f8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800051a4:	00015797          	auipc	a5,0x15
    800051a8:	82c78793          	addi	a5,a5,-2004 # 800199d0 <disk>
    800051ac:	97aa                	add	a5,a5,a0
    800051ae:	0187c783          	lbu	a5,24(a5)
    800051b2:	ebb9                	bnez	a5,80005208 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051b4:	00451693          	slli	a3,a0,0x4
    800051b8:	00015797          	auipc	a5,0x15
    800051bc:	81878793          	addi	a5,a5,-2024 # 800199d0 <disk>
    800051c0:	6398                	ld	a4,0(a5)
    800051c2:	9736                	add	a4,a4,a3
    800051c4:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800051c8:	6398                	ld	a4,0(a5)
    800051ca:	9736                	add	a4,a4,a3
    800051cc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800051d0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800051d4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800051d8:	97aa                	add	a5,a5,a0
    800051da:	4705                	li	a4,1
    800051dc:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800051e0:	00015517          	auipc	a0,0x15
    800051e4:	80850513          	addi	a0,a0,-2040 # 800199e8 <disk+0x18>
    800051e8:	ffffc097          	auipc	ra,0xffffc
    800051ec:	35e080e7          	jalr	862(ra) # 80001546 <wakeup>
}
    800051f0:	60a2                	ld	ra,8(sp)
    800051f2:	6402                	ld	s0,0(sp)
    800051f4:	0141                	addi	sp,sp,16
    800051f6:	8082                	ret
    panic("free_desc 1");
    800051f8:	00003517          	auipc	a0,0x3
    800051fc:	4c850513          	addi	a0,a0,1224 # 800086c0 <syscalls+0x300>
    80005200:	00001097          	auipc	ra,0x1
    80005204:	a0c080e7          	jalr	-1524(ra) # 80005c0c <panic>
    panic("free_desc 2");
    80005208:	00003517          	auipc	a0,0x3
    8000520c:	4c850513          	addi	a0,a0,1224 # 800086d0 <syscalls+0x310>
    80005210:	00001097          	auipc	ra,0x1
    80005214:	9fc080e7          	jalr	-1540(ra) # 80005c0c <panic>

0000000080005218 <virtio_disk_init>:
{
    80005218:	1101                	addi	sp,sp,-32
    8000521a:	ec06                	sd	ra,24(sp)
    8000521c:	e822                	sd	s0,16(sp)
    8000521e:	e426                	sd	s1,8(sp)
    80005220:	e04a                	sd	s2,0(sp)
    80005222:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005224:	00003597          	auipc	a1,0x3
    80005228:	4bc58593          	addi	a1,a1,1212 # 800086e0 <syscalls+0x320>
    8000522c:	00015517          	auipc	a0,0x15
    80005230:	8cc50513          	addi	a0,a0,-1844 # 80019af8 <disk+0x128>
    80005234:	00001097          	auipc	ra,0x1
    80005238:	e80080e7          	jalr	-384(ra) # 800060b4 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000523c:	100017b7          	lui	a5,0x10001
    80005240:	4398                	lw	a4,0(a5)
    80005242:	2701                	sext.w	a4,a4
    80005244:	747277b7          	lui	a5,0x74727
    80005248:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000524c:	14f71b63          	bne	a4,a5,800053a2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005250:	100017b7          	lui	a5,0x10001
    80005254:	43dc                	lw	a5,4(a5)
    80005256:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005258:	4709                	li	a4,2
    8000525a:	14e79463          	bne	a5,a4,800053a2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000525e:	100017b7          	lui	a5,0x10001
    80005262:	479c                	lw	a5,8(a5)
    80005264:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005266:	12e79e63          	bne	a5,a4,800053a2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000526a:	100017b7          	lui	a5,0x10001
    8000526e:	47d8                	lw	a4,12(a5)
    80005270:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005272:	554d47b7          	lui	a5,0x554d4
    80005276:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000527a:	12f71463          	bne	a4,a5,800053a2 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000527e:	100017b7          	lui	a5,0x10001
    80005282:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005286:	4705                	li	a4,1
    80005288:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000528a:	470d                	li	a4,3
    8000528c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000528e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005290:	c7ffe6b7          	lui	a3,0xc7ffe
    80005294:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdca0f>
    80005298:	8f75                	and	a4,a4,a3
    8000529a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000529c:	472d                	li	a4,11
    8000529e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800052a0:	5bbc                	lw	a5,112(a5)
    800052a2:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800052a6:	8ba1                	andi	a5,a5,8
    800052a8:	10078563          	beqz	a5,800053b2 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052ac:	100017b7          	lui	a5,0x10001
    800052b0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800052b4:	43fc                	lw	a5,68(a5)
    800052b6:	2781                	sext.w	a5,a5
    800052b8:	10079563          	bnez	a5,800053c2 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052bc:	100017b7          	lui	a5,0x10001
    800052c0:	5bdc                	lw	a5,52(a5)
    800052c2:	2781                	sext.w	a5,a5
  if(max == 0)
    800052c4:	10078763          	beqz	a5,800053d2 <virtio_disk_init+0x1ba>
  if(max < NUM)
    800052c8:	471d                	li	a4,7
    800052ca:	10f77c63          	bgeu	a4,a5,800053e2 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    800052ce:	ffffb097          	auipc	ra,0xffffb
    800052d2:	e4c080e7          	jalr	-436(ra) # 8000011a <kalloc>
    800052d6:	00014497          	auipc	s1,0x14
    800052da:	6fa48493          	addi	s1,s1,1786 # 800199d0 <disk>
    800052de:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800052e0:	ffffb097          	auipc	ra,0xffffb
    800052e4:	e3a080e7          	jalr	-454(ra) # 8000011a <kalloc>
    800052e8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800052ea:	ffffb097          	auipc	ra,0xffffb
    800052ee:	e30080e7          	jalr	-464(ra) # 8000011a <kalloc>
    800052f2:	87aa                	mv	a5,a0
    800052f4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800052f6:	6088                	ld	a0,0(s1)
    800052f8:	cd6d                	beqz	a0,800053f2 <virtio_disk_init+0x1da>
    800052fa:	00014717          	auipc	a4,0x14
    800052fe:	6de73703          	ld	a4,1758(a4) # 800199d8 <disk+0x8>
    80005302:	cb65                	beqz	a4,800053f2 <virtio_disk_init+0x1da>
    80005304:	c7fd                	beqz	a5,800053f2 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005306:	6605                	lui	a2,0x1
    80005308:	4581                	li	a1,0
    8000530a:	ffffb097          	auipc	ra,0xffffb
    8000530e:	e70080e7          	jalr	-400(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    80005312:	00014497          	auipc	s1,0x14
    80005316:	6be48493          	addi	s1,s1,1726 # 800199d0 <disk>
    8000531a:	6605                	lui	a2,0x1
    8000531c:	4581                	li	a1,0
    8000531e:	6488                	ld	a0,8(s1)
    80005320:	ffffb097          	auipc	ra,0xffffb
    80005324:	e5a080e7          	jalr	-422(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    80005328:	6605                	lui	a2,0x1
    8000532a:	4581                	li	a1,0
    8000532c:	6888                	ld	a0,16(s1)
    8000532e:	ffffb097          	auipc	ra,0xffffb
    80005332:	e4c080e7          	jalr	-436(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005336:	100017b7          	lui	a5,0x10001
    8000533a:	4721                	li	a4,8
    8000533c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000533e:	4098                	lw	a4,0(s1)
    80005340:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005344:	40d8                	lw	a4,4(s1)
    80005346:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000534a:	6498                	ld	a4,8(s1)
    8000534c:	0007069b          	sext.w	a3,a4
    80005350:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005354:	9701                	srai	a4,a4,0x20
    80005356:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000535a:	6898                	ld	a4,16(s1)
    8000535c:	0007069b          	sext.w	a3,a4
    80005360:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005364:	9701                	srai	a4,a4,0x20
    80005366:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000536a:	4705                	li	a4,1
    8000536c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000536e:	00e48c23          	sb	a4,24(s1)
    80005372:	00e48ca3          	sb	a4,25(s1)
    80005376:	00e48d23          	sb	a4,26(s1)
    8000537a:	00e48da3          	sb	a4,27(s1)
    8000537e:	00e48e23          	sb	a4,28(s1)
    80005382:	00e48ea3          	sb	a4,29(s1)
    80005386:	00e48f23          	sb	a4,30(s1)
    8000538a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000538e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005392:	0727a823          	sw	s2,112(a5)
}
    80005396:	60e2                	ld	ra,24(sp)
    80005398:	6442                	ld	s0,16(sp)
    8000539a:	64a2                	ld	s1,8(sp)
    8000539c:	6902                	ld	s2,0(sp)
    8000539e:	6105                	addi	sp,sp,32
    800053a0:	8082                	ret
    panic("could not find virtio disk");
    800053a2:	00003517          	auipc	a0,0x3
    800053a6:	34e50513          	addi	a0,a0,846 # 800086f0 <syscalls+0x330>
    800053aa:	00001097          	auipc	ra,0x1
    800053ae:	862080e7          	jalr	-1950(ra) # 80005c0c <panic>
    panic("virtio disk FEATURES_OK unset");
    800053b2:	00003517          	auipc	a0,0x3
    800053b6:	35e50513          	addi	a0,a0,862 # 80008710 <syscalls+0x350>
    800053ba:	00001097          	auipc	ra,0x1
    800053be:	852080e7          	jalr	-1966(ra) # 80005c0c <panic>
    panic("virtio disk should not be ready");
    800053c2:	00003517          	auipc	a0,0x3
    800053c6:	36e50513          	addi	a0,a0,878 # 80008730 <syscalls+0x370>
    800053ca:	00001097          	auipc	ra,0x1
    800053ce:	842080e7          	jalr	-1982(ra) # 80005c0c <panic>
    panic("virtio disk has no queue 0");
    800053d2:	00003517          	auipc	a0,0x3
    800053d6:	37e50513          	addi	a0,a0,894 # 80008750 <syscalls+0x390>
    800053da:	00001097          	auipc	ra,0x1
    800053de:	832080e7          	jalr	-1998(ra) # 80005c0c <panic>
    panic("virtio disk max queue too short");
    800053e2:	00003517          	auipc	a0,0x3
    800053e6:	38e50513          	addi	a0,a0,910 # 80008770 <syscalls+0x3b0>
    800053ea:	00001097          	auipc	ra,0x1
    800053ee:	822080e7          	jalr	-2014(ra) # 80005c0c <panic>
    panic("virtio disk kalloc");
    800053f2:	00003517          	auipc	a0,0x3
    800053f6:	39e50513          	addi	a0,a0,926 # 80008790 <syscalls+0x3d0>
    800053fa:	00001097          	auipc	ra,0x1
    800053fe:	812080e7          	jalr	-2030(ra) # 80005c0c <panic>

0000000080005402 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005402:	7119                	addi	sp,sp,-128
    80005404:	fc86                	sd	ra,120(sp)
    80005406:	f8a2                	sd	s0,112(sp)
    80005408:	f4a6                	sd	s1,104(sp)
    8000540a:	f0ca                	sd	s2,96(sp)
    8000540c:	ecce                	sd	s3,88(sp)
    8000540e:	e8d2                	sd	s4,80(sp)
    80005410:	e4d6                	sd	s5,72(sp)
    80005412:	e0da                	sd	s6,64(sp)
    80005414:	fc5e                	sd	s7,56(sp)
    80005416:	f862                	sd	s8,48(sp)
    80005418:	f466                	sd	s9,40(sp)
    8000541a:	f06a                	sd	s10,32(sp)
    8000541c:	ec6e                	sd	s11,24(sp)
    8000541e:	0100                	addi	s0,sp,128
    80005420:	8aaa                	mv	s5,a0
    80005422:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005424:	00c52d03          	lw	s10,12(a0)
    80005428:	001d1d1b          	slliw	s10,s10,0x1
    8000542c:	1d02                	slli	s10,s10,0x20
    8000542e:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80005432:	00014517          	auipc	a0,0x14
    80005436:	6c650513          	addi	a0,a0,1734 # 80019af8 <disk+0x128>
    8000543a:	00001097          	auipc	ra,0x1
    8000543e:	d0a080e7          	jalr	-758(ra) # 80006144 <acquire>
  for(int i = 0; i < 3; i++){
    80005442:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005444:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005446:	00014b97          	auipc	s7,0x14
    8000544a:	58ab8b93          	addi	s7,s7,1418 # 800199d0 <disk>
  for(int i = 0; i < 3; i++){
    8000544e:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005450:	00014c97          	auipc	s9,0x14
    80005454:	6a8c8c93          	addi	s9,s9,1704 # 80019af8 <disk+0x128>
    80005458:	a08d                	j	800054ba <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000545a:	00fb8733          	add	a4,s7,a5
    8000545e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005462:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005464:	0207c563          	bltz	a5,8000548e <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    80005468:	2905                	addiw	s2,s2,1
    8000546a:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000546c:	05690c63          	beq	s2,s6,800054c4 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005470:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005472:	00014717          	auipc	a4,0x14
    80005476:	55e70713          	addi	a4,a4,1374 # 800199d0 <disk>
    8000547a:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000547c:	01874683          	lbu	a3,24(a4)
    80005480:	fee9                	bnez	a3,8000545a <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005482:	2785                	addiw	a5,a5,1
    80005484:	0705                	addi	a4,a4,1
    80005486:	fe979be3          	bne	a5,s1,8000547c <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000548a:	57fd                	li	a5,-1
    8000548c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000548e:	01205d63          	blez	s2,800054a8 <virtio_disk_rw+0xa6>
    80005492:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005494:	000a2503          	lw	a0,0(s4)
    80005498:	00000097          	auipc	ra,0x0
    8000549c:	cfe080e7          	jalr	-770(ra) # 80005196 <free_desc>
      for(int j = 0; j < i; j++)
    800054a0:	2d85                	addiw	s11,s11,1
    800054a2:	0a11                	addi	s4,s4,4
    800054a4:	ff2d98e3          	bne	s11,s2,80005494 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054a8:	85e6                	mv	a1,s9
    800054aa:	00014517          	auipc	a0,0x14
    800054ae:	53e50513          	addi	a0,a0,1342 # 800199e8 <disk+0x18>
    800054b2:	ffffc097          	auipc	ra,0xffffc
    800054b6:	030080e7          	jalr	48(ra) # 800014e2 <sleep>
  for(int i = 0; i < 3; i++){
    800054ba:	f8040a13          	addi	s4,s0,-128
{
    800054be:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800054c0:	894e                	mv	s2,s3
    800054c2:	b77d                	j	80005470 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800054c4:	f8042503          	lw	a0,-128(s0)
    800054c8:	00a50713          	addi	a4,a0,10
    800054cc:	0712                	slli	a4,a4,0x4

  if(write)
    800054ce:	00014797          	auipc	a5,0x14
    800054d2:	50278793          	addi	a5,a5,1282 # 800199d0 <disk>
    800054d6:	00e786b3          	add	a3,a5,a4
    800054da:	01803633          	snez	a2,s8
    800054de:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800054e0:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    800054e4:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800054e8:	f6070613          	addi	a2,a4,-160
    800054ec:	6394                	ld	a3,0(a5)
    800054ee:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800054f0:	00870593          	addi	a1,a4,8
    800054f4:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800054f6:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800054f8:	0007b803          	ld	a6,0(a5)
    800054fc:	9642                	add	a2,a2,a6
    800054fe:	46c1                	li	a3,16
    80005500:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005502:	4585                	li	a1,1
    80005504:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005508:	f8442683          	lw	a3,-124(s0)
    8000550c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005510:	0692                	slli	a3,a3,0x4
    80005512:	9836                	add	a6,a6,a3
    80005514:	058a8613          	addi	a2,s5,88
    80005518:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000551c:	0007b803          	ld	a6,0(a5)
    80005520:	96c2                	add	a3,a3,a6
    80005522:	40000613          	li	a2,1024
    80005526:	c690                	sw	a2,8(a3)
  if(write)
    80005528:	001c3613          	seqz	a2,s8
    8000552c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005530:	00166613          	ori	a2,a2,1
    80005534:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005538:	f8842603          	lw	a2,-120(s0)
    8000553c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005540:	00250693          	addi	a3,a0,2
    80005544:	0692                	slli	a3,a3,0x4
    80005546:	96be                	add	a3,a3,a5
    80005548:	58fd                	li	a7,-1
    8000554a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000554e:	0612                	slli	a2,a2,0x4
    80005550:	9832                	add	a6,a6,a2
    80005552:	f9070713          	addi	a4,a4,-112
    80005556:	973e                	add	a4,a4,a5
    80005558:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000555c:	6398                	ld	a4,0(a5)
    8000555e:	9732                	add	a4,a4,a2
    80005560:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005562:	4609                	li	a2,2
    80005564:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005568:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000556c:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80005570:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005574:	6794                	ld	a3,8(a5)
    80005576:	0026d703          	lhu	a4,2(a3)
    8000557a:	8b1d                	andi	a4,a4,7
    8000557c:	0706                	slli	a4,a4,0x1
    8000557e:	96ba                	add	a3,a3,a4
    80005580:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005584:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005588:	6798                	ld	a4,8(a5)
    8000558a:	00275783          	lhu	a5,2(a4)
    8000558e:	2785                	addiw	a5,a5,1
    80005590:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005594:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005598:	100017b7          	lui	a5,0x10001
    8000559c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800055a0:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    800055a4:	00014917          	auipc	s2,0x14
    800055a8:	55490913          	addi	s2,s2,1364 # 80019af8 <disk+0x128>
  while(b->disk == 1) {
    800055ac:	4485                	li	s1,1
    800055ae:	00b79c63          	bne	a5,a1,800055c6 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800055b2:	85ca                	mv	a1,s2
    800055b4:	8556                	mv	a0,s5
    800055b6:	ffffc097          	auipc	ra,0xffffc
    800055ba:	f2c080e7          	jalr	-212(ra) # 800014e2 <sleep>
  while(b->disk == 1) {
    800055be:	004aa783          	lw	a5,4(s5)
    800055c2:	fe9788e3          	beq	a5,s1,800055b2 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800055c6:	f8042903          	lw	s2,-128(s0)
    800055ca:	00290713          	addi	a4,s2,2
    800055ce:	0712                	slli	a4,a4,0x4
    800055d0:	00014797          	auipc	a5,0x14
    800055d4:	40078793          	addi	a5,a5,1024 # 800199d0 <disk>
    800055d8:	97ba                	add	a5,a5,a4
    800055da:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800055de:	00014997          	auipc	s3,0x14
    800055e2:	3f298993          	addi	s3,s3,1010 # 800199d0 <disk>
    800055e6:	00491713          	slli	a4,s2,0x4
    800055ea:	0009b783          	ld	a5,0(s3)
    800055ee:	97ba                	add	a5,a5,a4
    800055f0:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800055f4:	854a                	mv	a0,s2
    800055f6:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800055fa:	00000097          	auipc	ra,0x0
    800055fe:	b9c080e7          	jalr	-1124(ra) # 80005196 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005602:	8885                	andi	s1,s1,1
    80005604:	f0ed                	bnez	s1,800055e6 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005606:	00014517          	auipc	a0,0x14
    8000560a:	4f250513          	addi	a0,a0,1266 # 80019af8 <disk+0x128>
    8000560e:	00001097          	auipc	ra,0x1
    80005612:	bea080e7          	jalr	-1046(ra) # 800061f8 <release>
}
    80005616:	70e6                	ld	ra,120(sp)
    80005618:	7446                	ld	s0,112(sp)
    8000561a:	74a6                	ld	s1,104(sp)
    8000561c:	7906                	ld	s2,96(sp)
    8000561e:	69e6                	ld	s3,88(sp)
    80005620:	6a46                	ld	s4,80(sp)
    80005622:	6aa6                	ld	s5,72(sp)
    80005624:	6b06                	ld	s6,64(sp)
    80005626:	7be2                	ld	s7,56(sp)
    80005628:	7c42                	ld	s8,48(sp)
    8000562a:	7ca2                	ld	s9,40(sp)
    8000562c:	7d02                	ld	s10,32(sp)
    8000562e:	6de2                	ld	s11,24(sp)
    80005630:	6109                	addi	sp,sp,128
    80005632:	8082                	ret

0000000080005634 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005634:	1101                	addi	sp,sp,-32
    80005636:	ec06                	sd	ra,24(sp)
    80005638:	e822                	sd	s0,16(sp)
    8000563a:	e426                	sd	s1,8(sp)
    8000563c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000563e:	00014497          	auipc	s1,0x14
    80005642:	39248493          	addi	s1,s1,914 # 800199d0 <disk>
    80005646:	00014517          	auipc	a0,0x14
    8000564a:	4b250513          	addi	a0,a0,1202 # 80019af8 <disk+0x128>
    8000564e:	00001097          	auipc	ra,0x1
    80005652:	af6080e7          	jalr	-1290(ra) # 80006144 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005656:	10001737          	lui	a4,0x10001
    8000565a:	533c                	lw	a5,96(a4)
    8000565c:	8b8d                	andi	a5,a5,3
    8000565e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005660:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005664:	689c                	ld	a5,16(s1)
    80005666:	0204d703          	lhu	a4,32(s1)
    8000566a:	0027d783          	lhu	a5,2(a5)
    8000566e:	04f70863          	beq	a4,a5,800056be <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005672:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005676:	6898                	ld	a4,16(s1)
    80005678:	0204d783          	lhu	a5,32(s1)
    8000567c:	8b9d                	andi	a5,a5,7
    8000567e:	078e                	slli	a5,a5,0x3
    80005680:	97ba                	add	a5,a5,a4
    80005682:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005684:	00278713          	addi	a4,a5,2
    80005688:	0712                	slli	a4,a4,0x4
    8000568a:	9726                	add	a4,a4,s1
    8000568c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005690:	e721                	bnez	a4,800056d8 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005692:	0789                	addi	a5,a5,2
    80005694:	0792                	slli	a5,a5,0x4
    80005696:	97a6                	add	a5,a5,s1
    80005698:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000569a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000569e:	ffffc097          	auipc	ra,0xffffc
    800056a2:	ea8080e7          	jalr	-344(ra) # 80001546 <wakeup>

    disk.used_idx += 1;
    800056a6:	0204d783          	lhu	a5,32(s1)
    800056aa:	2785                	addiw	a5,a5,1
    800056ac:	17c2                	slli	a5,a5,0x30
    800056ae:	93c1                	srli	a5,a5,0x30
    800056b0:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800056b4:	6898                	ld	a4,16(s1)
    800056b6:	00275703          	lhu	a4,2(a4)
    800056ba:	faf71ce3          	bne	a4,a5,80005672 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800056be:	00014517          	auipc	a0,0x14
    800056c2:	43a50513          	addi	a0,a0,1082 # 80019af8 <disk+0x128>
    800056c6:	00001097          	auipc	ra,0x1
    800056ca:	b32080e7          	jalr	-1230(ra) # 800061f8 <release>
}
    800056ce:	60e2                	ld	ra,24(sp)
    800056d0:	6442                	ld	s0,16(sp)
    800056d2:	64a2                	ld	s1,8(sp)
    800056d4:	6105                	addi	sp,sp,32
    800056d6:	8082                	ret
      panic("virtio_disk_intr status");
    800056d8:	00003517          	auipc	a0,0x3
    800056dc:	0d050513          	addi	a0,a0,208 # 800087a8 <syscalls+0x3e8>
    800056e0:	00000097          	auipc	ra,0x0
    800056e4:	52c080e7          	jalr	1324(ra) # 80005c0c <panic>

00000000800056e8 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800056e8:	1141                	addi	sp,sp,-16
    800056ea:	e422                	sd	s0,8(sp)
    800056ec:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800056ee:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800056f2:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800056f6:	0037979b          	slliw	a5,a5,0x3
    800056fa:	02004737          	lui	a4,0x2004
    800056fe:	97ba                	add	a5,a5,a4
    80005700:	0200c737          	lui	a4,0x200c
    80005704:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005708:	000f4637          	lui	a2,0xf4
    8000570c:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005710:	9732                	add	a4,a4,a2
    80005712:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005714:	00259693          	slli	a3,a1,0x2
    80005718:	96ae                	add	a3,a3,a1
    8000571a:	068e                	slli	a3,a3,0x3
    8000571c:	00014717          	auipc	a4,0x14
    80005720:	3f470713          	addi	a4,a4,1012 # 80019b10 <timer_scratch>
    80005724:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005726:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005728:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000572a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000572e:	00000797          	auipc	a5,0x0
    80005732:	9a278793          	addi	a5,a5,-1630 # 800050d0 <timervec>
    80005736:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000573a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000573e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005742:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005746:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000574a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000574e:	30479073          	csrw	mie,a5
}
    80005752:	6422                	ld	s0,8(sp)
    80005754:	0141                	addi	sp,sp,16
    80005756:	8082                	ret

0000000080005758 <start>:
{
    80005758:	1141                	addi	sp,sp,-16
    8000575a:	e406                	sd	ra,8(sp)
    8000575c:	e022                	sd	s0,0(sp)
    8000575e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005760:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005764:	7779                	lui	a4,0xffffe
    80005766:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdcaaf>
    8000576a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000576c:	6705                	lui	a4,0x1
    8000576e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005772:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005774:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005778:	ffffb797          	auipc	a5,0xffffb
    8000577c:	ba878793          	addi	a5,a5,-1112 # 80000320 <main>
    80005780:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005784:	4781                	li	a5,0
    80005786:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000578a:	67c1                	lui	a5,0x10
    8000578c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000578e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005792:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005796:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000579a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000579e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057a2:	57fd                	li	a5,-1
    800057a4:	83a9                	srli	a5,a5,0xa
    800057a6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057aa:	47bd                	li	a5,15
    800057ac:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800057b0:	00000097          	auipc	ra,0x0
    800057b4:	f38080e7          	jalr	-200(ra) # 800056e8 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057b8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800057bc:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800057be:	823e                	mv	tp,a5
  asm volatile("mret");
    800057c0:	30200073          	mret
}
    800057c4:	60a2                	ld	ra,8(sp)
    800057c6:	6402                	ld	s0,0(sp)
    800057c8:	0141                	addi	sp,sp,16
    800057ca:	8082                	ret

00000000800057cc <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800057cc:	715d                	addi	sp,sp,-80
    800057ce:	e486                	sd	ra,72(sp)
    800057d0:	e0a2                	sd	s0,64(sp)
    800057d2:	fc26                	sd	s1,56(sp)
    800057d4:	f84a                	sd	s2,48(sp)
    800057d6:	f44e                	sd	s3,40(sp)
    800057d8:	f052                	sd	s4,32(sp)
    800057da:	ec56                	sd	s5,24(sp)
    800057dc:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800057de:	04c05763          	blez	a2,8000582c <consolewrite+0x60>
    800057e2:	8a2a                	mv	s4,a0
    800057e4:	84ae                	mv	s1,a1
    800057e6:	89b2                	mv	s3,a2
    800057e8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800057ea:	5afd                	li	s5,-1
    800057ec:	4685                	li	a3,1
    800057ee:	8626                	mv	a2,s1
    800057f0:	85d2                	mv	a1,s4
    800057f2:	fbf40513          	addi	a0,s0,-65
    800057f6:	ffffc097          	auipc	ra,0xffffc
    800057fa:	14a080e7          	jalr	330(ra) # 80001940 <either_copyin>
    800057fe:	01550d63          	beq	a0,s5,80005818 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005802:	fbf44503          	lbu	a0,-65(s0)
    80005806:	00000097          	auipc	ra,0x0
    8000580a:	784080e7          	jalr	1924(ra) # 80005f8a <uartputc>
  for(i = 0; i < n; i++){
    8000580e:	2905                	addiw	s2,s2,1
    80005810:	0485                	addi	s1,s1,1
    80005812:	fd299de3          	bne	s3,s2,800057ec <consolewrite+0x20>
    80005816:	894e                	mv	s2,s3
  }

  return i;
}
    80005818:	854a                	mv	a0,s2
    8000581a:	60a6                	ld	ra,72(sp)
    8000581c:	6406                	ld	s0,64(sp)
    8000581e:	74e2                	ld	s1,56(sp)
    80005820:	7942                	ld	s2,48(sp)
    80005822:	79a2                	ld	s3,40(sp)
    80005824:	7a02                	ld	s4,32(sp)
    80005826:	6ae2                	ld	s5,24(sp)
    80005828:	6161                	addi	sp,sp,80
    8000582a:	8082                	ret
  for(i = 0; i < n; i++){
    8000582c:	4901                	li	s2,0
    8000582e:	b7ed                	j	80005818 <consolewrite+0x4c>

0000000080005830 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005830:	7159                	addi	sp,sp,-112
    80005832:	f486                	sd	ra,104(sp)
    80005834:	f0a2                	sd	s0,96(sp)
    80005836:	eca6                	sd	s1,88(sp)
    80005838:	e8ca                	sd	s2,80(sp)
    8000583a:	e4ce                	sd	s3,72(sp)
    8000583c:	e0d2                	sd	s4,64(sp)
    8000583e:	fc56                	sd	s5,56(sp)
    80005840:	f85a                	sd	s6,48(sp)
    80005842:	f45e                	sd	s7,40(sp)
    80005844:	f062                	sd	s8,32(sp)
    80005846:	ec66                	sd	s9,24(sp)
    80005848:	e86a                	sd	s10,16(sp)
    8000584a:	1880                	addi	s0,sp,112
    8000584c:	8aaa                	mv	s5,a0
    8000584e:	8a2e                	mv	s4,a1
    80005850:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005852:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005856:	0001c517          	auipc	a0,0x1c
    8000585a:	3fa50513          	addi	a0,a0,1018 # 80021c50 <cons>
    8000585e:	00001097          	auipc	ra,0x1
    80005862:	8e6080e7          	jalr	-1818(ra) # 80006144 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005866:	0001c497          	auipc	s1,0x1c
    8000586a:	3ea48493          	addi	s1,s1,1002 # 80021c50 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000586e:	0001c917          	auipc	s2,0x1c
    80005872:	47a90913          	addi	s2,s2,1146 # 80021ce8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005876:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005878:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000587a:	4ca9                	li	s9,10
  while(n > 0){
    8000587c:	07305b63          	blez	s3,800058f2 <consoleread+0xc2>
    while(cons.r == cons.w){
    80005880:	0984a783          	lw	a5,152(s1)
    80005884:	09c4a703          	lw	a4,156(s1)
    80005888:	02f71763          	bne	a4,a5,800058b6 <consoleread+0x86>
      if(killed(myproc())){
    8000588c:	ffffb097          	auipc	ra,0xffffb
    80005890:	5ae080e7          	jalr	1454(ra) # 80000e3a <myproc>
    80005894:	ffffc097          	auipc	ra,0xffffc
    80005898:	ef6080e7          	jalr	-266(ra) # 8000178a <killed>
    8000589c:	e535                	bnez	a0,80005908 <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    8000589e:	85a6                	mv	a1,s1
    800058a0:	854a                	mv	a0,s2
    800058a2:	ffffc097          	auipc	ra,0xffffc
    800058a6:	c40080e7          	jalr	-960(ra) # 800014e2 <sleep>
    while(cons.r == cons.w){
    800058aa:	0984a783          	lw	a5,152(s1)
    800058ae:	09c4a703          	lw	a4,156(s1)
    800058b2:	fcf70de3          	beq	a4,a5,8000588c <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800058b6:	0017871b          	addiw	a4,a5,1
    800058ba:	08e4ac23          	sw	a4,152(s1)
    800058be:	07f7f713          	andi	a4,a5,127
    800058c2:	9726                	add	a4,a4,s1
    800058c4:	01874703          	lbu	a4,24(a4)
    800058c8:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800058cc:	077d0563          	beq	s10,s7,80005936 <consoleread+0x106>
    cbuf = c;
    800058d0:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058d4:	4685                	li	a3,1
    800058d6:	f9f40613          	addi	a2,s0,-97
    800058da:	85d2                	mv	a1,s4
    800058dc:	8556                	mv	a0,s5
    800058de:	ffffc097          	auipc	ra,0xffffc
    800058e2:	00c080e7          	jalr	12(ra) # 800018ea <either_copyout>
    800058e6:	01850663          	beq	a0,s8,800058f2 <consoleread+0xc2>
    dst++;
    800058ea:	0a05                	addi	s4,s4,1
    --n;
    800058ec:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    800058ee:	f99d17e3          	bne	s10,s9,8000587c <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800058f2:	0001c517          	auipc	a0,0x1c
    800058f6:	35e50513          	addi	a0,a0,862 # 80021c50 <cons>
    800058fa:	00001097          	auipc	ra,0x1
    800058fe:	8fe080e7          	jalr	-1794(ra) # 800061f8 <release>

  return target - n;
    80005902:	413b053b          	subw	a0,s6,s3
    80005906:	a811                	j	8000591a <consoleread+0xea>
        release(&cons.lock);
    80005908:	0001c517          	auipc	a0,0x1c
    8000590c:	34850513          	addi	a0,a0,840 # 80021c50 <cons>
    80005910:	00001097          	auipc	ra,0x1
    80005914:	8e8080e7          	jalr	-1816(ra) # 800061f8 <release>
        return -1;
    80005918:	557d                	li	a0,-1
}
    8000591a:	70a6                	ld	ra,104(sp)
    8000591c:	7406                	ld	s0,96(sp)
    8000591e:	64e6                	ld	s1,88(sp)
    80005920:	6946                	ld	s2,80(sp)
    80005922:	69a6                	ld	s3,72(sp)
    80005924:	6a06                	ld	s4,64(sp)
    80005926:	7ae2                	ld	s5,56(sp)
    80005928:	7b42                	ld	s6,48(sp)
    8000592a:	7ba2                	ld	s7,40(sp)
    8000592c:	7c02                	ld	s8,32(sp)
    8000592e:	6ce2                	ld	s9,24(sp)
    80005930:	6d42                	ld	s10,16(sp)
    80005932:	6165                	addi	sp,sp,112
    80005934:	8082                	ret
      if(n < target){
    80005936:	0009871b          	sext.w	a4,s3
    8000593a:	fb677ce3          	bgeu	a4,s6,800058f2 <consoleread+0xc2>
        cons.r--;
    8000593e:	0001c717          	auipc	a4,0x1c
    80005942:	3af72523          	sw	a5,938(a4) # 80021ce8 <cons+0x98>
    80005946:	b775                	j	800058f2 <consoleread+0xc2>

0000000080005948 <consputc>:
{
    80005948:	1141                	addi	sp,sp,-16
    8000594a:	e406                	sd	ra,8(sp)
    8000594c:	e022                	sd	s0,0(sp)
    8000594e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005950:	10000793          	li	a5,256
    80005954:	00f50a63          	beq	a0,a5,80005968 <consputc+0x20>
    uartputc_sync(c);
    80005958:	00000097          	auipc	ra,0x0
    8000595c:	560080e7          	jalr	1376(ra) # 80005eb8 <uartputc_sync>
}
    80005960:	60a2                	ld	ra,8(sp)
    80005962:	6402                	ld	s0,0(sp)
    80005964:	0141                	addi	sp,sp,16
    80005966:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005968:	4521                	li	a0,8
    8000596a:	00000097          	auipc	ra,0x0
    8000596e:	54e080e7          	jalr	1358(ra) # 80005eb8 <uartputc_sync>
    80005972:	02000513          	li	a0,32
    80005976:	00000097          	auipc	ra,0x0
    8000597a:	542080e7          	jalr	1346(ra) # 80005eb8 <uartputc_sync>
    8000597e:	4521                	li	a0,8
    80005980:	00000097          	auipc	ra,0x0
    80005984:	538080e7          	jalr	1336(ra) # 80005eb8 <uartputc_sync>
    80005988:	bfe1                	j	80005960 <consputc+0x18>

000000008000598a <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    8000598a:	1101                	addi	sp,sp,-32
    8000598c:	ec06                	sd	ra,24(sp)
    8000598e:	e822                	sd	s0,16(sp)
    80005990:	e426                	sd	s1,8(sp)
    80005992:	e04a                	sd	s2,0(sp)
    80005994:	1000                	addi	s0,sp,32
    80005996:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005998:	0001c517          	auipc	a0,0x1c
    8000599c:	2b850513          	addi	a0,a0,696 # 80021c50 <cons>
    800059a0:	00000097          	auipc	ra,0x0
    800059a4:	7a4080e7          	jalr	1956(ra) # 80006144 <acquire>

  switch(c){
    800059a8:	47d5                	li	a5,21
    800059aa:	0af48663          	beq	s1,a5,80005a56 <consoleintr+0xcc>
    800059ae:	0297ca63          	blt	a5,s1,800059e2 <consoleintr+0x58>
    800059b2:	47a1                	li	a5,8
    800059b4:	0ef48763          	beq	s1,a5,80005aa2 <consoleintr+0x118>
    800059b8:	47c1                	li	a5,16
    800059ba:	10f49a63          	bne	s1,a5,80005ace <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800059be:	ffffc097          	auipc	ra,0xffffc
    800059c2:	fd8080e7          	jalr	-40(ra) # 80001996 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800059c6:	0001c517          	auipc	a0,0x1c
    800059ca:	28a50513          	addi	a0,a0,650 # 80021c50 <cons>
    800059ce:	00001097          	auipc	ra,0x1
    800059d2:	82a080e7          	jalr	-2006(ra) # 800061f8 <release>
}
    800059d6:	60e2                	ld	ra,24(sp)
    800059d8:	6442                	ld	s0,16(sp)
    800059da:	64a2                	ld	s1,8(sp)
    800059dc:	6902                	ld	s2,0(sp)
    800059de:	6105                	addi	sp,sp,32
    800059e0:	8082                	ret
  switch(c){
    800059e2:	07f00793          	li	a5,127
    800059e6:	0af48e63          	beq	s1,a5,80005aa2 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800059ea:	0001c717          	auipc	a4,0x1c
    800059ee:	26670713          	addi	a4,a4,614 # 80021c50 <cons>
    800059f2:	0a072783          	lw	a5,160(a4)
    800059f6:	09872703          	lw	a4,152(a4)
    800059fa:	9f99                	subw	a5,a5,a4
    800059fc:	07f00713          	li	a4,127
    80005a00:	fcf763e3          	bltu	a4,a5,800059c6 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a04:	47b5                	li	a5,13
    80005a06:	0cf48763          	beq	s1,a5,80005ad4 <consoleintr+0x14a>
      consputc(c);
    80005a0a:	8526                	mv	a0,s1
    80005a0c:	00000097          	auipc	ra,0x0
    80005a10:	f3c080e7          	jalr	-196(ra) # 80005948 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005a14:	0001c797          	auipc	a5,0x1c
    80005a18:	23c78793          	addi	a5,a5,572 # 80021c50 <cons>
    80005a1c:	0a07a683          	lw	a3,160(a5)
    80005a20:	0016871b          	addiw	a4,a3,1
    80005a24:	0007061b          	sext.w	a2,a4
    80005a28:	0ae7a023          	sw	a4,160(a5)
    80005a2c:	07f6f693          	andi	a3,a3,127
    80005a30:	97b6                	add	a5,a5,a3
    80005a32:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005a36:	47a9                	li	a5,10
    80005a38:	0cf48563          	beq	s1,a5,80005b02 <consoleintr+0x178>
    80005a3c:	4791                	li	a5,4
    80005a3e:	0cf48263          	beq	s1,a5,80005b02 <consoleintr+0x178>
    80005a42:	0001c797          	auipc	a5,0x1c
    80005a46:	2a67a783          	lw	a5,678(a5) # 80021ce8 <cons+0x98>
    80005a4a:	9f1d                	subw	a4,a4,a5
    80005a4c:	08000793          	li	a5,128
    80005a50:	f6f71be3          	bne	a4,a5,800059c6 <consoleintr+0x3c>
    80005a54:	a07d                	j	80005b02 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005a56:	0001c717          	auipc	a4,0x1c
    80005a5a:	1fa70713          	addi	a4,a4,506 # 80021c50 <cons>
    80005a5e:	0a072783          	lw	a5,160(a4)
    80005a62:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005a66:	0001c497          	auipc	s1,0x1c
    80005a6a:	1ea48493          	addi	s1,s1,490 # 80021c50 <cons>
    while(cons.e != cons.w &&
    80005a6e:	4929                	li	s2,10
    80005a70:	f4f70be3          	beq	a4,a5,800059c6 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005a74:	37fd                	addiw	a5,a5,-1
    80005a76:	07f7f713          	andi	a4,a5,127
    80005a7a:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005a7c:	01874703          	lbu	a4,24(a4)
    80005a80:	f52703e3          	beq	a4,s2,800059c6 <consoleintr+0x3c>
      cons.e--;
    80005a84:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005a88:	10000513          	li	a0,256
    80005a8c:	00000097          	auipc	ra,0x0
    80005a90:	ebc080e7          	jalr	-324(ra) # 80005948 <consputc>
    while(cons.e != cons.w &&
    80005a94:	0a04a783          	lw	a5,160(s1)
    80005a98:	09c4a703          	lw	a4,156(s1)
    80005a9c:	fcf71ce3          	bne	a4,a5,80005a74 <consoleintr+0xea>
    80005aa0:	b71d                	j	800059c6 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005aa2:	0001c717          	auipc	a4,0x1c
    80005aa6:	1ae70713          	addi	a4,a4,430 # 80021c50 <cons>
    80005aaa:	0a072783          	lw	a5,160(a4)
    80005aae:	09c72703          	lw	a4,156(a4)
    80005ab2:	f0f70ae3          	beq	a4,a5,800059c6 <consoleintr+0x3c>
      cons.e--;
    80005ab6:	37fd                	addiw	a5,a5,-1
    80005ab8:	0001c717          	auipc	a4,0x1c
    80005abc:	22f72c23          	sw	a5,568(a4) # 80021cf0 <cons+0xa0>
      consputc(BACKSPACE);
    80005ac0:	10000513          	li	a0,256
    80005ac4:	00000097          	auipc	ra,0x0
    80005ac8:	e84080e7          	jalr	-380(ra) # 80005948 <consputc>
    80005acc:	bded                	j	800059c6 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005ace:	ee048ce3          	beqz	s1,800059c6 <consoleintr+0x3c>
    80005ad2:	bf21                	j	800059ea <consoleintr+0x60>
      consputc(c);
    80005ad4:	4529                	li	a0,10
    80005ad6:	00000097          	auipc	ra,0x0
    80005ada:	e72080e7          	jalr	-398(ra) # 80005948 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005ade:	0001c797          	auipc	a5,0x1c
    80005ae2:	17278793          	addi	a5,a5,370 # 80021c50 <cons>
    80005ae6:	0a07a703          	lw	a4,160(a5)
    80005aea:	0017069b          	addiw	a3,a4,1
    80005aee:	0006861b          	sext.w	a2,a3
    80005af2:	0ad7a023          	sw	a3,160(a5)
    80005af6:	07f77713          	andi	a4,a4,127
    80005afa:	97ba                	add	a5,a5,a4
    80005afc:	4729                	li	a4,10
    80005afe:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b02:	0001c797          	auipc	a5,0x1c
    80005b06:	1ec7a523          	sw	a2,490(a5) # 80021cec <cons+0x9c>
        wakeup(&cons.r);
    80005b0a:	0001c517          	auipc	a0,0x1c
    80005b0e:	1de50513          	addi	a0,a0,478 # 80021ce8 <cons+0x98>
    80005b12:	ffffc097          	auipc	ra,0xffffc
    80005b16:	a34080e7          	jalr	-1484(ra) # 80001546 <wakeup>
    80005b1a:	b575                	j	800059c6 <consoleintr+0x3c>

0000000080005b1c <consoleinit>:

void
consoleinit(void)
{
    80005b1c:	1141                	addi	sp,sp,-16
    80005b1e:	e406                	sd	ra,8(sp)
    80005b20:	e022                	sd	s0,0(sp)
    80005b22:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b24:	00003597          	auipc	a1,0x3
    80005b28:	c9c58593          	addi	a1,a1,-868 # 800087c0 <syscalls+0x400>
    80005b2c:	0001c517          	auipc	a0,0x1c
    80005b30:	12450513          	addi	a0,a0,292 # 80021c50 <cons>
    80005b34:	00000097          	auipc	ra,0x0
    80005b38:	580080e7          	jalr	1408(ra) # 800060b4 <initlock>

  uartinit();
    80005b3c:	00000097          	auipc	ra,0x0
    80005b40:	32c080e7          	jalr	812(ra) # 80005e68 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b44:	00013797          	auipc	a5,0x13
    80005b48:	e3478793          	addi	a5,a5,-460 # 80018978 <devsw>
    80005b4c:	00000717          	auipc	a4,0x0
    80005b50:	ce470713          	addi	a4,a4,-796 # 80005830 <consoleread>
    80005b54:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b56:	00000717          	auipc	a4,0x0
    80005b5a:	c7670713          	addi	a4,a4,-906 # 800057cc <consolewrite>
    80005b5e:	ef98                	sd	a4,24(a5)
}
    80005b60:	60a2                	ld	ra,8(sp)
    80005b62:	6402                	ld	s0,0(sp)
    80005b64:	0141                	addi	sp,sp,16
    80005b66:	8082                	ret

0000000080005b68 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005b68:	7179                	addi	sp,sp,-48
    80005b6a:	f406                	sd	ra,40(sp)
    80005b6c:	f022                	sd	s0,32(sp)
    80005b6e:	ec26                	sd	s1,24(sp)
    80005b70:	e84a                	sd	s2,16(sp)
    80005b72:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005b74:	c219                	beqz	a2,80005b7a <printint+0x12>
    80005b76:	08054763          	bltz	a0,80005c04 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005b7a:	2501                	sext.w	a0,a0
    80005b7c:	4881                	li	a7,0
    80005b7e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005b82:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005b84:	2581                	sext.w	a1,a1
    80005b86:	00003617          	auipc	a2,0x3
    80005b8a:	c6a60613          	addi	a2,a2,-918 # 800087f0 <digits>
    80005b8e:	883a                	mv	a6,a4
    80005b90:	2705                	addiw	a4,a4,1
    80005b92:	02b577bb          	remuw	a5,a0,a1
    80005b96:	1782                	slli	a5,a5,0x20
    80005b98:	9381                	srli	a5,a5,0x20
    80005b9a:	97b2                	add	a5,a5,a2
    80005b9c:	0007c783          	lbu	a5,0(a5)
    80005ba0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005ba4:	0005079b          	sext.w	a5,a0
    80005ba8:	02b5553b          	divuw	a0,a0,a1
    80005bac:	0685                	addi	a3,a3,1
    80005bae:	feb7f0e3          	bgeu	a5,a1,80005b8e <printint+0x26>

  if(sign)
    80005bb2:	00088c63          	beqz	a7,80005bca <printint+0x62>
    buf[i++] = '-';
    80005bb6:	fe070793          	addi	a5,a4,-32
    80005bba:	00878733          	add	a4,a5,s0
    80005bbe:	02d00793          	li	a5,45
    80005bc2:	fef70823          	sb	a5,-16(a4)
    80005bc6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005bca:	02e05763          	blez	a4,80005bf8 <printint+0x90>
    80005bce:	fd040793          	addi	a5,s0,-48
    80005bd2:	00e784b3          	add	s1,a5,a4
    80005bd6:	fff78913          	addi	s2,a5,-1
    80005bda:	993a                	add	s2,s2,a4
    80005bdc:	377d                	addiw	a4,a4,-1
    80005bde:	1702                	slli	a4,a4,0x20
    80005be0:	9301                	srli	a4,a4,0x20
    80005be2:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005be6:	fff4c503          	lbu	a0,-1(s1)
    80005bea:	00000097          	auipc	ra,0x0
    80005bee:	d5e080e7          	jalr	-674(ra) # 80005948 <consputc>
  while(--i >= 0)
    80005bf2:	14fd                	addi	s1,s1,-1
    80005bf4:	ff2499e3          	bne	s1,s2,80005be6 <printint+0x7e>
}
    80005bf8:	70a2                	ld	ra,40(sp)
    80005bfa:	7402                	ld	s0,32(sp)
    80005bfc:	64e2                	ld	s1,24(sp)
    80005bfe:	6942                	ld	s2,16(sp)
    80005c00:	6145                	addi	sp,sp,48
    80005c02:	8082                	ret
    x = -xx;
    80005c04:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c08:	4885                	li	a7,1
    x = -xx;
    80005c0a:	bf95                	j	80005b7e <printint+0x16>

0000000080005c0c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c0c:	1101                	addi	sp,sp,-32
    80005c0e:	ec06                	sd	ra,24(sp)
    80005c10:	e822                	sd	s0,16(sp)
    80005c12:	e426                	sd	s1,8(sp)
    80005c14:	1000                	addi	s0,sp,32
    80005c16:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c18:	0001c797          	auipc	a5,0x1c
    80005c1c:	0e07ac23          	sw	zero,248(a5) # 80021d10 <pr+0x18>
  printf("panic: ");
    80005c20:	00003517          	auipc	a0,0x3
    80005c24:	ba850513          	addi	a0,a0,-1112 # 800087c8 <syscalls+0x408>
    80005c28:	00000097          	auipc	ra,0x0
    80005c2c:	02e080e7          	jalr	46(ra) # 80005c56 <printf>
  printf(s);
    80005c30:	8526                	mv	a0,s1
    80005c32:	00000097          	auipc	ra,0x0
    80005c36:	024080e7          	jalr	36(ra) # 80005c56 <printf>
  printf("\n");
    80005c3a:	00002517          	auipc	a0,0x2
    80005c3e:	40e50513          	addi	a0,a0,1038 # 80008048 <etext+0x48>
    80005c42:	00000097          	auipc	ra,0x0
    80005c46:	014080e7          	jalr	20(ra) # 80005c56 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005c4a:	4785                	li	a5,1
    80005c4c:	00003717          	auipc	a4,0x3
    80005c50:	c8f72023          	sw	a5,-896(a4) # 800088cc <panicked>
  for(;;)
    80005c54:	a001                	j	80005c54 <panic+0x48>

0000000080005c56 <printf>:
{
    80005c56:	7131                	addi	sp,sp,-192
    80005c58:	fc86                	sd	ra,120(sp)
    80005c5a:	f8a2                	sd	s0,112(sp)
    80005c5c:	f4a6                	sd	s1,104(sp)
    80005c5e:	f0ca                	sd	s2,96(sp)
    80005c60:	ecce                	sd	s3,88(sp)
    80005c62:	e8d2                	sd	s4,80(sp)
    80005c64:	e4d6                	sd	s5,72(sp)
    80005c66:	e0da                	sd	s6,64(sp)
    80005c68:	fc5e                	sd	s7,56(sp)
    80005c6a:	f862                	sd	s8,48(sp)
    80005c6c:	f466                	sd	s9,40(sp)
    80005c6e:	f06a                	sd	s10,32(sp)
    80005c70:	ec6e                	sd	s11,24(sp)
    80005c72:	0100                	addi	s0,sp,128
    80005c74:	8a2a                	mv	s4,a0
    80005c76:	e40c                	sd	a1,8(s0)
    80005c78:	e810                	sd	a2,16(s0)
    80005c7a:	ec14                	sd	a3,24(s0)
    80005c7c:	f018                	sd	a4,32(s0)
    80005c7e:	f41c                	sd	a5,40(s0)
    80005c80:	03043823          	sd	a6,48(s0)
    80005c84:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005c88:	0001cd97          	auipc	s11,0x1c
    80005c8c:	088dad83          	lw	s11,136(s11) # 80021d10 <pr+0x18>
  if(locking)
    80005c90:	020d9b63          	bnez	s11,80005cc6 <printf+0x70>
  if (fmt == 0)
    80005c94:	040a0263          	beqz	s4,80005cd8 <printf+0x82>
  va_start(ap, fmt);
    80005c98:	00840793          	addi	a5,s0,8
    80005c9c:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005ca0:	000a4503          	lbu	a0,0(s4)
    80005ca4:	14050f63          	beqz	a0,80005e02 <printf+0x1ac>
    80005ca8:	4981                	li	s3,0
    if(c != '%'){
    80005caa:	02500a93          	li	s5,37
    switch(c){
    80005cae:	07000b93          	li	s7,112
  consputc('x');
    80005cb2:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005cb4:	00003b17          	auipc	s6,0x3
    80005cb8:	b3cb0b13          	addi	s6,s6,-1220 # 800087f0 <digits>
    switch(c){
    80005cbc:	07300c93          	li	s9,115
    80005cc0:	06400c13          	li	s8,100
    80005cc4:	a82d                	j	80005cfe <printf+0xa8>
    acquire(&pr.lock);
    80005cc6:	0001c517          	auipc	a0,0x1c
    80005cca:	03250513          	addi	a0,a0,50 # 80021cf8 <pr>
    80005cce:	00000097          	auipc	ra,0x0
    80005cd2:	476080e7          	jalr	1142(ra) # 80006144 <acquire>
    80005cd6:	bf7d                	j	80005c94 <printf+0x3e>
    panic("null fmt");
    80005cd8:	00003517          	auipc	a0,0x3
    80005cdc:	b0050513          	addi	a0,a0,-1280 # 800087d8 <syscalls+0x418>
    80005ce0:	00000097          	auipc	ra,0x0
    80005ce4:	f2c080e7          	jalr	-212(ra) # 80005c0c <panic>
      consputc(c);
    80005ce8:	00000097          	auipc	ra,0x0
    80005cec:	c60080e7          	jalr	-928(ra) # 80005948 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cf0:	2985                	addiw	s3,s3,1
    80005cf2:	013a07b3          	add	a5,s4,s3
    80005cf6:	0007c503          	lbu	a0,0(a5)
    80005cfa:	10050463          	beqz	a0,80005e02 <printf+0x1ac>
    if(c != '%'){
    80005cfe:	ff5515e3          	bne	a0,s5,80005ce8 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d02:	2985                	addiw	s3,s3,1
    80005d04:	013a07b3          	add	a5,s4,s3
    80005d08:	0007c783          	lbu	a5,0(a5)
    80005d0c:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005d10:	cbed                	beqz	a5,80005e02 <printf+0x1ac>
    switch(c){
    80005d12:	05778a63          	beq	a5,s7,80005d66 <printf+0x110>
    80005d16:	02fbf663          	bgeu	s7,a5,80005d42 <printf+0xec>
    80005d1a:	09978863          	beq	a5,s9,80005daa <printf+0x154>
    80005d1e:	07800713          	li	a4,120
    80005d22:	0ce79563          	bne	a5,a4,80005dec <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005d26:	f8843783          	ld	a5,-120(s0)
    80005d2a:	00878713          	addi	a4,a5,8
    80005d2e:	f8e43423          	sd	a4,-120(s0)
    80005d32:	4605                	li	a2,1
    80005d34:	85ea                	mv	a1,s10
    80005d36:	4388                	lw	a0,0(a5)
    80005d38:	00000097          	auipc	ra,0x0
    80005d3c:	e30080e7          	jalr	-464(ra) # 80005b68 <printint>
      break;
    80005d40:	bf45                	j	80005cf0 <printf+0x9a>
    switch(c){
    80005d42:	09578f63          	beq	a5,s5,80005de0 <printf+0x18a>
    80005d46:	0b879363          	bne	a5,s8,80005dec <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005d4a:	f8843783          	ld	a5,-120(s0)
    80005d4e:	00878713          	addi	a4,a5,8
    80005d52:	f8e43423          	sd	a4,-120(s0)
    80005d56:	4605                	li	a2,1
    80005d58:	45a9                	li	a1,10
    80005d5a:	4388                	lw	a0,0(a5)
    80005d5c:	00000097          	auipc	ra,0x0
    80005d60:	e0c080e7          	jalr	-500(ra) # 80005b68 <printint>
      break;
    80005d64:	b771                	j	80005cf0 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005d66:	f8843783          	ld	a5,-120(s0)
    80005d6a:	00878713          	addi	a4,a5,8
    80005d6e:	f8e43423          	sd	a4,-120(s0)
    80005d72:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005d76:	03000513          	li	a0,48
    80005d7a:	00000097          	auipc	ra,0x0
    80005d7e:	bce080e7          	jalr	-1074(ra) # 80005948 <consputc>
  consputc('x');
    80005d82:	07800513          	li	a0,120
    80005d86:	00000097          	auipc	ra,0x0
    80005d8a:	bc2080e7          	jalr	-1086(ra) # 80005948 <consputc>
    80005d8e:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d90:	03c95793          	srli	a5,s2,0x3c
    80005d94:	97da                	add	a5,a5,s6
    80005d96:	0007c503          	lbu	a0,0(a5)
    80005d9a:	00000097          	auipc	ra,0x0
    80005d9e:	bae080e7          	jalr	-1106(ra) # 80005948 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005da2:	0912                	slli	s2,s2,0x4
    80005da4:	34fd                	addiw	s1,s1,-1
    80005da6:	f4ed                	bnez	s1,80005d90 <printf+0x13a>
    80005da8:	b7a1                	j	80005cf0 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005daa:	f8843783          	ld	a5,-120(s0)
    80005dae:	00878713          	addi	a4,a5,8
    80005db2:	f8e43423          	sd	a4,-120(s0)
    80005db6:	6384                	ld	s1,0(a5)
    80005db8:	cc89                	beqz	s1,80005dd2 <printf+0x17c>
      for(; *s; s++)
    80005dba:	0004c503          	lbu	a0,0(s1)
    80005dbe:	d90d                	beqz	a0,80005cf0 <printf+0x9a>
        consputc(*s);
    80005dc0:	00000097          	auipc	ra,0x0
    80005dc4:	b88080e7          	jalr	-1144(ra) # 80005948 <consputc>
      for(; *s; s++)
    80005dc8:	0485                	addi	s1,s1,1
    80005dca:	0004c503          	lbu	a0,0(s1)
    80005dce:	f96d                	bnez	a0,80005dc0 <printf+0x16a>
    80005dd0:	b705                	j	80005cf0 <printf+0x9a>
        s = "(null)";
    80005dd2:	00003497          	auipc	s1,0x3
    80005dd6:	9fe48493          	addi	s1,s1,-1538 # 800087d0 <syscalls+0x410>
      for(; *s; s++)
    80005dda:	02800513          	li	a0,40
    80005dde:	b7cd                	j	80005dc0 <printf+0x16a>
      consputc('%');
    80005de0:	8556                	mv	a0,s5
    80005de2:	00000097          	auipc	ra,0x0
    80005de6:	b66080e7          	jalr	-1178(ra) # 80005948 <consputc>
      break;
    80005dea:	b719                	j	80005cf0 <printf+0x9a>
      consputc('%');
    80005dec:	8556                	mv	a0,s5
    80005dee:	00000097          	auipc	ra,0x0
    80005df2:	b5a080e7          	jalr	-1190(ra) # 80005948 <consputc>
      consputc(c);
    80005df6:	8526                	mv	a0,s1
    80005df8:	00000097          	auipc	ra,0x0
    80005dfc:	b50080e7          	jalr	-1200(ra) # 80005948 <consputc>
      break;
    80005e00:	bdc5                	j	80005cf0 <printf+0x9a>
  if(locking)
    80005e02:	020d9163          	bnez	s11,80005e24 <printf+0x1ce>
}
    80005e06:	70e6                	ld	ra,120(sp)
    80005e08:	7446                	ld	s0,112(sp)
    80005e0a:	74a6                	ld	s1,104(sp)
    80005e0c:	7906                	ld	s2,96(sp)
    80005e0e:	69e6                	ld	s3,88(sp)
    80005e10:	6a46                	ld	s4,80(sp)
    80005e12:	6aa6                	ld	s5,72(sp)
    80005e14:	6b06                	ld	s6,64(sp)
    80005e16:	7be2                	ld	s7,56(sp)
    80005e18:	7c42                	ld	s8,48(sp)
    80005e1a:	7ca2                	ld	s9,40(sp)
    80005e1c:	7d02                	ld	s10,32(sp)
    80005e1e:	6de2                	ld	s11,24(sp)
    80005e20:	6129                	addi	sp,sp,192
    80005e22:	8082                	ret
    release(&pr.lock);
    80005e24:	0001c517          	auipc	a0,0x1c
    80005e28:	ed450513          	addi	a0,a0,-300 # 80021cf8 <pr>
    80005e2c:	00000097          	auipc	ra,0x0
    80005e30:	3cc080e7          	jalr	972(ra) # 800061f8 <release>
}
    80005e34:	bfc9                	j	80005e06 <printf+0x1b0>

0000000080005e36 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e36:	1101                	addi	sp,sp,-32
    80005e38:	ec06                	sd	ra,24(sp)
    80005e3a:	e822                	sd	s0,16(sp)
    80005e3c:	e426                	sd	s1,8(sp)
    80005e3e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e40:	0001c497          	auipc	s1,0x1c
    80005e44:	eb848493          	addi	s1,s1,-328 # 80021cf8 <pr>
    80005e48:	00003597          	auipc	a1,0x3
    80005e4c:	9a058593          	addi	a1,a1,-1632 # 800087e8 <syscalls+0x428>
    80005e50:	8526                	mv	a0,s1
    80005e52:	00000097          	auipc	ra,0x0
    80005e56:	262080e7          	jalr	610(ra) # 800060b4 <initlock>
  pr.locking = 1;
    80005e5a:	4785                	li	a5,1
    80005e5c:	cc9c                	sw	a5,24(s1)
}
    80005e5e:	60e2                	ld	ra,24(sp)
    80005e60:	6442                	ld	s0,16(sp)
    80005e62:	64a2                	ld	s1,8(sp)
    80005e64:	6105                	addi	sp,sp,32
    80005e66:	8082                	ret

0000000080005e68 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005e68:	1141                	addi	sp,sp,-16
    80005e6a:	e406                	sd	ra,8(sp)
    80005e6c:	e022                	sd	s0,0(sp)
    80005e6e:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005e70:	100007b7          	lui	a5,0x10000
    80005e74:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005e78:	f8000713          	li	a4,-128
    80005e7c:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005e80:	470d                	li	a4,3
    80005e82:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005e86:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005e8a:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005e8e:	469d                	li	a3,7
    80005e90:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005e94:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005e98:	00003597          	auipc	a1,0x3
    80005e9c:	97058593          	addi	a1,a1,-1680 # 80008808 <digits+0x18>
    80005ea0:	0001c517          	auipc	a0,0x1c
    80005ea4:	e7850513          	addi	a0,a0,-392 # 80021d18 <uart_tx_lock>
    80005ea8:	00000097          	auipc	ra,0x0
    80005eac:	20c080e7          	jalr	524(ra) # 800060b4 <initlock>
}
    80005eb0:	60a2                	ld	ra,8(sp)
    80005eb2:	6402                	ld	s0,0(sp)
    80005eb4:	0141                	addi	sp,sp,16
    80005eb6:	8082                	ret

0000000080005eb8 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005eb8:	1101                	addi	sp,sp,-32
    80005eba:	ec06                	sd	ra,24(sp)
    80005ebc:	e822                	sd	s0,16(sp)
    80005ebe:	e426                	sd	s1,8(sp)
    80005ec0:	1000                	addi	s0,sp,32
    80005ec2:	84aa                	mv	s1,a0
  push_off();
    80005ec4:	00000097          	auipc	ra,0x0
    80005ec8:	234080e7          	jalr	564(ra) # 800060f8 <push_off>

  if(panicked){
    80005ecc:	00003797          	auipc	a5,0x3
    80005ed0:	a007a783          	lw	a5,-1536(a5) # 800088cc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005ed4:	10000737          	lui	a4,0x10000
  if(panicked){
    80005ed8:	c391                	beqz	a5,80005edc <uartputc_sync+0x24>
    for(;;)
    80005eda:	a001                	j	80005eda <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005edc:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005ee0:	0207f793          	andi	a5,a5,32
    80005ee4:	dfe5                	beqz	a5,80005edc <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005ee6:	0ff4f513          	zext.b	a0,s1
    80005eea:	100007b7          	lui	a5,0x10000
    80005eee:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005ef2:	00000097          	auipc	ra,0x0
    80005ef6:	2a6080e7          	jalr	678(ra) # 80006198 <pop_off>
}
    80005efa:	60e2                	ld	ra,24(sp)
    80005efc:	6442                	ld	s0,16(sp)
    80005efe:	64a2                	ld	s1,8(sp)
    80005f00:	6105                	addi	sp,sp,32
    80005f02:	8082                	ret

0000000080005f04 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f04:	00003797          	auipc	a5,0x3
    80005f08:	9cc7b783          	ld	a5,-1588(a5) # 800088d0 <uart_tx_r>
    80005f0c:	00003717          	auipc	a4,0x3
    80005f10:	9cc73703          	ld	a4,-1588(a4) # 800088d8 <uart_tx_w>
    80005f14:	06f70a63          	beq	a4,a5,80005f88 <uartstart+0x84>
{
    80005f18:	7139                	addi	sp,sp,-64
    80005f1a:	fc06                	sd	ra,56(sp)
    80005f1c:	f822                	sd	s0,48(sp)
    80005f1e:	f426                	sd	s1,40(sp)
    80005f20:	f04a                	sd	s2,32(sp)
    80005f22:	ec4e                	sd	s3,24(sp)
    80005f24:	e852                	sd	s4,16(sp)
    80005f26:	e456                	sd	s5,8(sp)
    80005f28:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f2a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f2e:	0001ca17          	auipc	s4,0x1c
    80005f32:	deaa0a13          	addi	s4,s4,-534 # 80021d18 <uart_tx_lock>
    uart_tx_r += 1;
    80005f36:	00003497          	auipc	s1,0x3
    80005f3a:	99a48493          	addi	s1,s1,-1638 # 800088d0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005f3e:	00003997          	auipc	s3,0x3
    80005f42:	99a98993          	addi	s3,s3,-1638 # 800088d8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f46:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005f4a:	02077713          	andi	a4,a4,32
    80005f4e:	c705                	beqz	a4,80005f76 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f50:	01f7f713          	andi	a4,a5,31
    80005f54:	9752                	add	a4,a4,s4
    80005f56:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005f5a:	0785                	addi	a5,a5,1
    80005f5c:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005f5e:	8526                	mv	a0,s1
    80005f60:	ffffb097          	auipc	ra,0xffffb
    80005f64:	5e6080e7          	jalr	1510(ra) # 80001546 <wakeup>
    
    WriteReg(THR, c);
    80005f68:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005f6c:	609c                	ld	a5,0(s1)
    80005f6e:	0009b703          	ld	a4,0(s3)
    80005f72:	fcf71ae3          	bne	a4,a5,80005f46 <uartstart+0x42>
  }
}
    80005f76:	70e2                	ld	ra,56(sp)
    80005f78:	7442                	ld	s0,48(sp)
    80005f7a:	74a2                	ld	s1,40(sp)
    80005f7c:	7902                	ld	s2,32(sp)
    80005f7e:	69e2                	ld	s3,24(sp)
    80005f80:	6a42                	ld	s4,16(sp)
    80005f82:	6aa2                	ld	s5,8(sp)
    80005f84:	6121                	addi	sp,sp,64
    80005f86:	8082                	ret
    80005f88:	8082                	ret

0000000080005f8a <uartputc>:
{
    80005f8a:	7179                	addi	sp,sp,-48
    80005f8c:	f406                	sd	ra,40(sp)
    80005f8e:	f022                	sd	s0,32(sp)
    80005f90:	ec26                	sd	s1,24(sp)
    80005f92:	e84a                	sd	s2,16(sp)
    80005f94:	e44e                	sd	s3,8(sp)
    80005f96:	e052                	sd	s4,0(sp)
    80005f98:	1800                	addi	s0,sp,48
    80005f9a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005f9c:	0001c517          	auipc	a0,0x1c
    80005fa0:	d7c50513          	addi	a0,a0,-644 # 80021d18 <uart_tx_lock>
    80005fa4:	00000097          	auipc	ra,0x0
    80005fa8:	1a0080e7          	jalr	416(ra) # 80006144 <acquire>
  if(panicked){
    80005fac:	00003797          	auipc	a5,0x3
    80005fb0:	9207a783          	lw	a5,-1760(a5) # 800088cc <panicked>
    80005fb4:	e7c9                	bnez	a5,8000603e <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005fb6:	00003717          	auipc	a4,0x3
    80005fba:	92273703          	ld	a4,-1758(a4) # 800088d8 <uart_tx_w>
    80005fbe:	00003797          	auipc	a5,0x3
    80005fc2:	9127b783          	ld	a5,-1774(a5) # 800088d0 <uart_tx_r>
    80005fc6:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005fca:	0001c997          	auipc	s3,0x1c
    80005fce:	d4e98993          	addi	s3,s3,-690 # 80021d18 <uart_tx_lock>
    80005fd2:	00003497          	auipc	s1,0x3
    80005fd6:	8fe48493          	addi	s1,s1,-1794 # 800088d0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005fda:	00003917          	auipc	s2,0x3
    80005fde:	8fe90913          	addi	s2,s2,-1794 # 800088d8 <uart_tx_w>
    80005fe2:	00e79f63          	bne	a5,a4,80006000 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005fe6:	85ce                	mv	a1,s3
    80005fe8:	8526                	mv	a0,s1
    80005fea:	ffffb097          	auipc	ra,0xffffb
    80005fee:	4f8080e7          	jalr	1272(ra) # 800014e2 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005ff2:	00093703          	ld	a4,0(s2)
    80005ff6:	609c                	ld	a5,0(s1)
    80005ff8:	02078793          	addi	a5,a5,32
    80005ffc:	fee785e3          	beq	a5,a4,80005fe6 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006000:	0001c497          	auipc	s1,0x1c
    80006004:	d1848493          	addi	s1,s1,-744 # 80021d18 <uart_tx_lock>
    80006008:	01f77793          	andi	a5,a4,31
    8000600c:	97a6                	add	a5,a5,s1
    8000600e:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006012:	0705                	addi	a4,a4,1
    80006014:	00003797          	auipc	a5,0x3
    80006018:	8ce7b223          	sd	a4,-1852(a5) # 800088d8 <uart_tx_w>
  uartstart();
    8000601c:	00000097          	auipc	ra,0x0
    80006020:	ee8080e7          	jalr	-280(ra) # 80005f04 <uartstart>
  release(&uart_tx_lock);
    80006024:	8526                	mv	a0,s1
    80006026:	00000097          	auipc	ra,0x0
    8000602a:	1d2080e7          	jalr	466(ra) # 800061f8 <release>
}
    8000602e:	70a2                	ld	ra,40(sp)
    80006030:	7402                	ld	s0,32(sp)
    80006032:	64e2                	ld	s1,24(sp)
    80006034:	6942                	ld	s2,16(sp)
    80006036:	69a2                	ld	s3,8(sp)
    80006038:	6a02                	ld	s4,0(sp)
    8000603a:	6145                	addi	sp,sp,48
    8000603c:	8082                	ret
    for(;;)
    8000603e:	a001                	j	8000603e <uartputc+0xb4>

0000000080006040 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006040:	1141                	addi	sp,sp,-16
    80006042:	e422                	sd	s0,8(sp)
    80006044:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006046:	100007b7          	lui	a5,0x10000
    8000604a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000604e:	8b85                	andi	a5,a5,1
    80006050:	cb81                	beqz	a5,80006060 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006052:	100007b7          	lui	a5,0x10000
    80006056:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000605a:	6422                	ld	s0,8(sp)
    8000605c:	0141                	addi	sp,sp,16
    8000605e:	8082                	ret
    return -1;
    80006060:	557d                	li	a0,-1
    80006062:	bfe5                	j	8000605a <uartgetc+0x1a>

0000000080006064 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80006064:	1101                	addi	sp,sp,-32
    80006066:	ec06                	sd	ra,24(sp)
    80006068:	e822                	sd	s0,16(sp)
    8000606a:	e426                	sd	s1,8(sp)
    8000606c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000606e:	54fd                	li	s1,-1
    80006070:	a029                	j	8000607a <uartintr+0x16>
      break;
    consoleintr(c);
    80006072:	00000097          	auipc	ra,0x0
    80006076:	918080e7          	jalr	-1768(ra) # 8000598a <consoleintr>
    int c = uartgetc();
    8000607a:	00000097          	auipc	ra,0x0
    8000607e:	fc6080e7          	jalr	-58(ra) # 80006040 <uartgetc>
    if(c == -1)
    80006082:	fe9518e3          	bne	a0,s1,80006072 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006086:	0001c497          	auipc	s1,0x1c
    8000608a:	c9248493          	addi	s1,s1,-878 # 80021d18 <uart_tx_lock>
    8000608e:	8526                	mv	a0,s1
    80006090:	00000097          	auipc	ra,0x0
    80006094:	0b4080e7          	jalr	180(ra) # 80006144 <acquire>
  uartstart();
    80006098:	00000097          	auipc	ra,0x0
    8000609c:	e6c080e7          	jalr	-404(ra) # 80005f04 <uartstart>
  release(&uart_tx_lock);
    800060a0:	8526                	mv	a0,s1
    800060a2:	00000097          	auipc	ra,0x0
    800060a6:	156080e7          	jalr	342(ra) # 800061f8 <release>
}
    800060aa:	60e2                	ld	ra,24(sp)
    800060ac:	6442                	ld	s0,16(sp)
    800060ae:	64a2                	ld	s1,8(sp)
    800060b0:	6105                	addi	sp,sp,32
    800060b2:	8082                	ret

00000000800060b4 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800060b4:	1141                	addi	sp,sp,-16
    800060b6:	e422                	sd	s0,8(sp)
    800060b8:	0800                	addi	s0,sp,16
  lk->name = name;
    800060ba:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800060bc:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800060c0:	00053823          	sd	zero,16(a0)
}
    800060c4:	6422                	ld	s0,8(sp)
    800060c6:	0141                	addi	sp,sp,16
    800060c8:	8082                	ret

00000000800060ca <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800060ca:	411c                	lw	a5,0(a0)
    800060cc:	e399                	bnez	a5,800060d2 <holding+0x8>
    800060ce:	4501                	li	a0,0
  return r;
}
    800060d0:	8082                	ret
{
    800060d2:	1101                	addi	sp,sp,-32
    800060d4:	ec06                	sd	ra,24(sp)
    800060d6:	e822                	sd	s0,16(sp)
    800060d8:	e426                	sd	s1,8(sp)
    800060da:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800060dc:	6904                	ld	s1,16(a0)
    800060de:	ffffb097          	auipc	ra,0xffffb
    800060e2:	d40080e7          	jalr	-704(ra) # 80000e1e <mycpu>
    800060e6:	40a48533          	sub	a0,s1,a0
    800060ea:	00153513          	seqz	a0,a0
}
    800060ee:	60e2                	ld	ra,24(sp)
    800060f0:	6442                	ld	s0,16(sp)
    800060f2:	64a2                	ld	s1,8(sp)
    800060f4:	6105                	addi	sp,sp,32
    800060f6:	8082                	ret

00000000800060f8 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800060f8:	1101                	addi	sp,sp,-32
    800060fa:	ec06                	sd	ra,24(sp)
    800060fc:	e822                	sd	s0,16(sp)
    800060fe:	e426                	sd	s1,8(sp)
    80006100:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006102:	100024f3          	csrr	s1,sstatus
    80006106:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000610a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000610c:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006110:	ffffb097          	auipc	ra,0xffffb
    80006114:	d0e080e7          	jalr	-754(ra) # 80000e1e <mycpu>
    80006118:	5d3c                	lw	a5,120(a0)
    8000611a:	cf89                	beqz	a5,80006134 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000611c:	ffffb097          	auipc	ra,0xffffb
    80006120:	d02080e7          	jalr	-766(ra) # 80000e1e <mycpu>
    80006124:	5d3c                	lw	a5,120(a0)
    80006126:	2785                	addiw	a5,a5,1
    80006128:	dd3c                	sw	a5,120(a0)
}
    8000612a:	60e2                	ld	ra,24(sp)
    8000612c:	6442                	ld	s0,16(sp)
    8000612e:	64a2                	ld	s1,8(sp)
    80006130:	6105                	addi	sp,sp,32
    80006132:	8082                	ret
    mycpu()->intena = old;
    80006134:	ffffb097          	auipc	ra,0xffffb
    80006138:	cea080e7          	jalr	-790(ra) # 80000e1e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000613c:	8085                	srli	s1,s1,0x1
    8000613e:	8885                	andi	s1,s1,1
    80006140:	dd64                	sw	s1,124(a0)
    80006142:	bfe9                	j	8000611c <push_off+0x24>

0000000080006144 <acquire>:
{
    80006144:	1101                	addi	sp,sp,-32
    80006146:	ec06                	sd	ra,24(sp)
    80006148:	e822                	sd	s0,16(sp)
    8000614a:	e426                	sd	s1,8(sp)
    8000614c:	1000                	addi	s0,sp,32
    8000614e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006150:	00000097          	auipc	ra,0x0
    80006154:	fa8080e7          	jalr	-88(ra) # 800060f8 <push_off>
  if(holding(lk))
    80006158:	8526                	mv	a0,s1
    8000615a:	00000097          	auipc	ra,0x0
    8000615e:	f70080e7          	jalr	-144(ra) # 800060ca <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006162:	4705                	li	a4,1
  if(holding(lk))
    80006164:	e115                	bnez	a0,80006188 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006166:	87ba                	mv	a5,a4
    80006168:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000616c:	2781                	sext.w	a5,a5
    8000616e:	ffe5                	bnez	a5,80006166 <acquire+0x22>
  __sync_synchronize();
    80006170:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006174:	ffffb097          	auipc	ra,0xffffb
    80006178:	caa080e7          	jalr	-854(ra) # 80000e1e <mycpu>
    8000617c:	e888                	sd	a0,16(s1)
}
    8000617e:	60e2                	ld	ra,24(sp)
    80006180:	6442                	ld	s0,16(sp)
    80006182:	64a2                	ld	s1,8(sp)
    80006184:	6105                	addi	sp,sp,32
    80006186:	8082                	ret
    panic("acquire");
    80006188:	00002517          	auipc	a0,0x2
    8000618c:	68850513          	addi	a0,a0,1672 # 80008810 <digits+0x20>
    80006190:	00000097          	auipc	ra,0x0
    80006194:	a7c080e7          	jalr	-1412(ra) # 80005c0c <panic>

0000000080006198 <pop_off>:

void
pop_off(void)
{
    80006198:	1141                	addi	sp,sp,-16
    8000619a:	e406                	sd	ra,8(sp)
    8000619c:	e022                	sd	s0,0(sp)
    8000619e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800061a0:	ffffb097          	auipc	ra,0xffffb
    800061a4:	c7e080e7          	jalr	-898(ra) # 80000e1e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061a8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800061ac:	8b89                	andi	a5,a5,2
  if(intr_get())
    800061ae:	e78d                	bnez	a5,800061d8 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800061b0:	5d3c                	lw	a5,120(a0)
    800061b2:	02f05b63          	blez	a5,800061e8 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800061b6:	37fd                	addiw	a5,a5,-1
    800061b8:	0007871b          	sext.w	a4,a5
    800061bc:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800061be:	eb09                	bnez	a4,800061d0 <pop_off+0x38>
    800061c0:	5d7c                	lw	a5,124(a0)
    800061c2:	c799                	beqz	a5,800061d0 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061c4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800061c8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061cc:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800061d0:	60a2                	ld	ra,8(sp)
    800061d2:	6402                	ld	s0,0(sp)
    800061d4:	0141                	addi	sp,sp,16
    800061d6:	8082                	ret
    panic("pop_off - interruptible");
    800061d8:	00002517          	auipc	a0,0x2
    800061dc:	64050513          	addi	a0,a0,1600 # 80008818 <digits+0x28>
    800061e0:	00000097          	auipc	ra,0x0
    800061e4:	a2c080e7          	jalr	-1492(ra) # 80005c0c <panic>
    panic("pop_off");
    800061e8:	00002517          	auipc	a0,0x2
    800061ec:	64850513          	addi	a0,a0,1608 # 80008830 <digits+0x40>
    800061f0:	00000097          	auipc	ra,0x0
    800061f4:	a1c080e7          	jalr	-1508(ra) # 80005c0c <panic>

00000000800061f8 <release>:
{
    800061f8:	1101                	addi	sp,sp,-32
    800061fa:	ec06                	sd	ra,24(sp)
    800061fc:	e822                	sd	s0,16(sp)
    800061fe:	e426                	sd	s1,8(sp)
    80006200:	1000                	addi	s0,sp,32
    80006202:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006204:	00000097          	auipc	ra,0x0
    80006208:	ec6080e7          	jalr	-314(ra) # 800060ca <holding>
    8000620c:	c115                	beqz	a0,80006230 <release+0x38>
  lk->cpu = 0;
    8000620e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006212:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006216:	0f50000f          	fence	iorw,ow
    8000621a:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000621e:	00000097          	auipc	ra,0x0
    80006222:	f7a080e7          	jalr	-134(ra) # 80006198 <pop_off>
}
    80006226:	60e2                	ld	ra,24(sp)
    80006228:	6442                	ld	s0,16(sp)
    8000622a:	64a2                	ld	s1,8(sp)
    8000622c:	6105                	addi	sp,sp,32
    8000622e:	8082                	ret
    panic("release");
    80006230:	00002517          	auipc	a0,0x2
    80006234:	60850513          	addi	a0,a0,1544 # 80008838 <digits+0x48>
    80006238:	00000097          	auipc	ra,0x0
    8000623c:	9d4080e7          	jalr	-1580(ra) # 80005c0c <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
