---
layout: post
title: Python 正则表达式简介
keywords: Python regex re 正则表达式
category: Python
tags: python 正则表达式
---

**正则表达式**，又称**正规表示法**、**常规表示法**（英语：Regular Expression，在代码中常简写为regex、regexp或RE），计算机科学的一个概念。正则表达式使用单个字符串来描述、匹配一系列符合某个句法规则的字符串。在很多文本编辑器里，正则表达式通常被用来检索、替换那些符合某个模式的文本。

应用正则表达式来处理文本信息和数据非常方便，Python 对正则表达式有很好的支持。在学习正则表达式的过程中，可将正则表达式的内容分为几个点来学习，这样便于学习和记忆。

## 正则表达式规则

### 1. 元字符

<div class="hblock"><pre>
. 	匹配除换行符以外的任意字符
\w 	匹配字母或数字或下划线或汉字, 即构成词汇的字符（word）
\s 	匹配任意的空白符，即 \n,\t, \r, \v, \f
\S	匹配任何非空白字符，即 [^ \f\n\r\t\v]
\n	匹配一个换行符，等价于 \x0a 和 \cJ
\r	匹配一个回车符，等价于 \x0d 和 \cM
\t	匹配一个制表符，等价于 \x09 和 \cI
\d 	匹配数字, 即 0-9

\b	匹配一个单词边界，即字与空格间的位置
\B	非单词边界匹配
^ 	匹配字符串的开始，位置控制
$ 	匹配字符串的结束，位置控制

[]  匹配字符集合中的任一字符，如 [0-9A-Fa-f] 匹配任何十六进制数位
</pre></div>

**举例：** <br/>

\ba\w*\b 以字母a开头的单词（仅匹配一个单词）<br/>
\bks 以ks开头的内容 <br/>
huoty\b 以huoty结束的内容 <br/>
^\d{5, 12}$ 匹配5-12位的QQ号

**注：**\b......\b 与 ^......$ 等价，都用于匹配一个单词。

### 2. 重复

<div class="hblock"><pre>
* 	    重复零次或更多次，即任意次数
+ 	    重复一次或更多次，即至少一次
? 	    重复零次或一次，即最多一次
{n} 	重复n次
{n,} 	重复n次或更多次
{n,m} 	重复n到m次
</pre></div>

### 3. 分支条件（或）

用于分支条件的正则表达式规则是一条竖线"**|**"，即或的意思，示例：

> 0\d{2}-\d{8}|0\d{3}-\d{7}

这个表达式匹配两种以连字号分隔的电话号码：一种是三位区号，8位本地号(如010-12345678)，一种是4位区号，7位本地号(如0376-2233445)

### 4. 分组
小括号 `()` 用于指定子表达式（也叫做分组）。子表达式可以用于多个字符的重复，即可以为子表达式指定重复次数。例如：

> (\d{1,3}\.){3}\d{1,3}

一个简单的 IP 地址匹配表达式。

### 5. 反义

所谓的反义匹配，其实就是对元字符的取反引用。

<div class="hblock"><pre>
\W 	        匹配任意不是字母，数字，下划线，汉字的字符
\S 	        匹配任意不是空白符的字符
\D 	        匹配任意非数字的字符
\B 	        匹配不是单词开头或结束的位置
[^x] 	    匹配除了x以外的任意字符
[^aeiou] 	匹配除了aeiou这几个字母以外的任意字符
</pre></div>

举例：<br/>
\S+ 匹配不包含空白符的字符串。<br/>
[a[^>]+\ 匹配用方括号括起来的以a开头的字符串。<br/>

### 6. 反向引用
使用小括号指定一个子表达式后，匹配这个子表达式的文本（也就是此分组捕获的内容）可以在表达式或其他程序中作进一步处理（例如Python的re模块中的group和groups方法）。默认情况下每个分组拥有一个组号，规则是，从左到右，以分组的左括号为标志，第一个出现的分组的组号为1，第二个为2，一次类推。**分组号为0对应整个正则表达式**。

反向引用用于重复搜索前面某个分组匹配的文本，例如：\1 代表分组1匹配的文本。示例：

> \b(\w+)\b\s+\1\b

这个表达式用于匹配重复的单词，如 “go go”，“huoty huoty”等。

**分组的组号可以自定义，也可以为分组指定名字，这里不做详细说明。**

### 7. 贪婪和非贪婪

**贪婪模式：** 匹配尽可能多的字符 <br/>
**非贪婪模式：** 匹配尽可能少的字符

默认为贪婪模式，需要用到非贪婪模式时，只需要在限定符后加上“？”即可：

```
*? 	重复任意次，但尽可能少重复
+? 	重复1次或更多次，但尽可能少重复
?? 	重复0次或1次，但尽可能少重复
{n,m}? 	重复n到m次，但尽可能少重复
{n,}? 	重复n次以上，但尽可能少重复
```


## Python 的 re 模块

Python 的 `re` 模块提供对正则表达式的支持。使用 re 一般是先将正则表达式的匹配规则字符串编译（compile）为 Pattern 对象，然后使用 Pattern 对象处理文本并获得匹配结果（一个 Match 对象），最后使用 Match 对象获得想要的信息。

```
import re

pattern = re.compile(r"hello")
match = pattern.match("hello world")
if match:
    print(match.group())

# 输出：hello
```

### 1. re.compile

```
re.compile(strPattern[, flag])
```

该方法用于将字符串形式的正则表达式规则编译为 Pattern 对象。 第二个参数 flag 是匹配模式，取值可以使用按位或运算符 '|' 表示同时生效，比如 re.I | re.M。另外，也可以在 regex 字符串中指定模式，比如 re.compile('pattern', re.I | re.M) 与 re.compile('(?im)pattern') 是等价的。 flag 的可选值有：

- **re.I**(全拼：IGNORECASE): 忽略大小写（括号内是完整写法，下同）
- **re.M**(全拼：MULTILINE): 多行模式，改变 '^' 和 '$' 的行为
- **re.S**(全拼：DOTALL): 点任意匹配模式，改变 '.' 的行为
- **re.L**(全拼：LOCALE): 使预定字符类 \w \W \b \B \s \S 取决于当前区域设定
- **re.U**(全拼：UNICODE): 使预定字符类 \w \W \b \B \s \S \d \D 取决于 unicode 定义的字符属性
- **re.X**(全拼：VERBOSE): 详细模式。这个模式下正则表达式可以是多行，忽略空白字符，并可以加入注释。

### 2. Pattern 对象

Pattern 对象是一个编译好的正则表达式，通过 Pattern 提供的一系列方法可以对文本进行匹配查找。其不能直接实例化，必须使用 re.compile() 进行构造。Pattern提供了几个可读属性用于获取表达式的相关信息：

- **pattern**: 编译时用的表达式字符串
- **flags**: 编译时用的匹配模式，数字形式
- **groups**: 表达式中分组的数量
- **groupindex**: 以表达式中有别名的组的别名为键、以该组对应的编号为值的字典，没有别名的组不包含在内

```python
>>> import re
>>> p = re.compile(r'(\w+) (\w+)(?P<sign>.*)', re.DOTALL)
>>> p.pattern
'(\\w+) (\\w+)(?P<sign>.*)'
>>> p.flags
48    
>>> p.groups
3
>>> p.groupindex
mappingproxy({'sign': 3})
```

Pattern 对象的实例方法与 re 模块提供的函数用法基本相同，只不过 re 模块的函数使用时第一个参数必须是一个 Pattern 对象实例或者 string 类型的匹配模式。具体方法包括：

- **match(string[, pos[, endpos]]) | re.match(pattern, string[, flags])**
- **search(string[, pos[, endpos]]) | re.search(pattern, string[, flags])**
- **split(string[, maxsplit]) | re.split(pattern, string[, maxsplit])**
- **findall(string[, pos[, endpos]]) | re.findall(pattern, string[, flags])**
- **finditer(string[, pos[, endpos]]) | re.finditer(pattern, string[, flags])**
- **sub(repl, string[, count]) | re.sub(pattern, repl, string[, count])**
- **subn(repl, string[, count]) | re.sub(pattern, repl, string[, count])**

如果匹配模式会被重复调用，则建议先编译成 Pattern 对象再使用。

### 3. re.match

```
pattern.match(string[, pos[, endpos]]) | re.match(pattern, string[, flags])
```

该方法将从 string 的 pos 下标处起尝试匹配 pattern；如果 pattern 结束时仍可匹配，则返回一个 **Match 对象**；如果匹配过程中 pattern 无法匹配，或者匹配未结束就已到达 endpos，则返回 None。pos 和 endpos 的默认值分别为 0和 len(string)；re.match()无法指定这两个参数，参数flags用于编译pattern时指定匹配模式。

### 4. Match 对象

Match 对象是一次匹配的结果，包含此次匹配相关的信息，可以使用 Match 提供的可读属性或方法来获取这些信息。

**属性：**

- (1)**string**: 匹配时使用的文本
- (2)**re**: 匹配时使用的 Patter 对象
- (3)**pos**: 文本中正则表达式开始搜索的索引，值与 Pattern.match() 和 Pattern.search() 方法的同名参数相同
- (4)**endpos**: 文本中正则表达式结束搜索的索引，值与 Pattern.match() 和 Pattern.search() 方法的同名参数相同
- (5)**lastindex**: 最后一个被捕获的分组在文本中的索引，如果没有被捕获的分组，将为 None
- (6)**lastgroup**: 最后一个被捕获的分组的别名，如果这个分组没有别名或者没有被捕获的分组，将为 None

**方法：**

- (1)**group([group1, …]):**
获得一个或多个分组截获的字符串；指定多个参数时将以元组形式返回。group1 可以使用编号也可以使用别名；编号 0 代表整个匹配的子串；不填写参数时，返回 group(0)；没有截获字符串的组返回 None；截获了多次的组返回最后一次截获的子串
- (2)**groups([default]):**
以元组形式返回全部分组截获的字符串。相当于调用 group(1,2,…last)。default 表示没有截获字符串的组以这个值替代，默认为 None
- (3)**groupdict([default]):**
返回以有别名的组的别名为键、以该组截获的子串为值的字典，没有别名的组不包含在内。default 含义同上
- (4)**start([group]):**
返回指定的组截获的子串在string中的起始索引（子串第一个字符的索引）。group 默认值为 0
- (5)**end([group]):**
返回指定的组截获的子串在string中的结束索引（子串最后一个字符的索引+1）。group默认值为0
- (6)**span([group]):**
返回(start(group), end(group))
- (7)**expand(template):**
将匹配到的分组代入template中然后返回。template中可以使用 \id 或 \g、\g 引用分组，但不能使用编号 0。\id 与 \g 是等价的；但 \10 将被认为是第 10 个分组，如果你想表达 \1 之后是字符 '0'，只能使用 \g0

### 5. re.search

```
pattern.search(string[, pos[, endpos]]) | re.search(pattern, string[, flags])
```
这个方法用于查找字符串中可以匹配成功的子串。从 string 的 pos 下标处起尝试匹配 pattern，如果 pattern 结束时仍可匹配，则返回一个 Match 对象；若无法匹配，则将 pos 加 1 后重新尝试匹配；直到 pos=endpos 时仍无法匹配则返回 None。pos 和 endpos 的默认值分别为 0 和 len(string))；re.search() 无法指定这两个参数，参数 flags 用于编译 pattern 时指定匹配模式。

### 6. re.split

```
pattern.split(string[, maxsplit]) | re.split(pattern, string[, maxsplit])
```

按照能够匹配的子串将 string 分割后返回列表。maxsplit 用于指定最大分割次数，不指定将全部分割。

### 7. re.findall

```
pattern.findall(string[, pos[, endpos]]) | re.findall(pattern, string[, flags])
```

搜索 string，以列表形式返回全部能匹配的子串。

### 8. re.finditer

```
pattern.finditer(string[, pos[, endpos]]) | re.finditer(pattern, string[, flags])
```

搜索string，返回一个顺序访问每一个匹配结果（Match对象）的迭代器。

### 9. re.sub

```
pattern.sub(repl, string[, count]) | re.sub(pattern, repl, string[, count])
```

使用 repl 替换 string 中每一个匹配的子串后返回替换后的字符串。当 repl 是一个字符串时，可以使用 \id 或 \g<id>、\g<name> 引用分组，但不能使用编号 0。当 repl 是一个方法时，这个方法应当只接受一个参数（Match对象），并返回一个字符串用于替换（返回的字符串中不能再引用分组）。count用于指定最多替换次数，不指定时全部替换。

### 10. re.subn

```
pattern.subn(repl, string[, count]) | re.sub(pattern, repl, string[, count])
```

返回 (sub(repl, string[, count]), 替换次数)

## Re 模块常用方法总结

![Re 模块常用方法总结](http://ww3.sinaimg.cn/mw690/c3c88275gw1f53scpabgoj20ei0e7dhf.jpg)


## 参考资料

- [https://www.cnblogs.com/huxi/archive/2010/07/04/1771073.html](https://www.cnblogs.com/huxi/archive/2010/07/04/1771073.html)
- [https://docs.python.org/3/library/re.html](https://docs.python.org/3/library/re.html)
