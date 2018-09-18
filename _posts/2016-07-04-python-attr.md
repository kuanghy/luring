---
layout: post
title: "Python 对象属性的访问"
keywords: Python dict attribute 描述符 属性
description: "Python 访问属性时会按照优先级链的顺序取搜索属性"
category: Python
tags: python
---

在 Python 中，一切皆对象。属性访问可以理解为是从一个已有的对象中获得另一个对象的方法。对象属性的访问涉及到对象的 `__dict__` 属性、描述符等概念，以及 `__getattribute__`、`__getattr__` 等方法。

## 对象 dict 属性

Python 中的对象有一个 `__dict__` 属性，其是一个字典类型，对象当前可用的属性和方法都保存在合格字典中。它存储着对象属性的名称与值的键值对。示例(在 Python 2.7 环境测试)：

```python
>>> class C(object):
...     x = 1
...
>>> C.__dict__
dict_proxy({
    '__dict__': <attribute '__dict__' of 'C' objects>,
    'x': 1, '__module__': '__console__',
    '__weakref__': <attribute '__weakref__' of 'C' objects>,
    '__doc__': None
})
>>> c = C()
>>> c.__dict__
{}
>>> c.y = 1
>>> c.__dict__
{'y': 1}
>>> c.x
1
>>> c.x = 2
>>> c.x
2
>>> C.x
1
>>> c.__dict__
{'y': 1, 'x': 2}
```

由上例应该注意到，类变量 x 存储在类 C 的 dict 属性中，而由 C 初始化的对象 c 的属性 y 则在 c 的 dict 中。对象 c 仍然可以访问其类型 C 中的类变量 x。但是，如果在对象 c 中重新设置属性 x 之后，则 C 与 c 中各自有自己的 x 属性，此时 c.x 不再访问其类的属性，而是访问自己的 x 属性。

还应注意到，类对象的 `__dict__` 属性为普通的 dict 类型，而类定义的 `__dict__` 则为 dict_proxy 类型（在 Python3 中为 mappingproxy 类型）。类对象的该属性时可以被直接修改的，而类的确不行。因为类的 `__dict__` 是只读的，所以其命名中加入了 proxy 字眼，这样做的目的是为了防止其被意外修改而导致意想不到的错误发生。

```python
>>> c.__dict__['x'] = 5
>>> C.__dict__['x'] = 6
Traceback (most recent call last):
  File "<input>", line 1, in <module>
    C.__dict__['x'] = 6
TypeError: 'dictproxy' object does not support item assignment
>>> c.x
5
>>> C.x
1
>>> c.__dict__ = {}
>>> C.__dict__ = {}
Traceback (most recent call last):
  File "<input>", line 1, in <module>
    C.__dict__ = {}
AttributeError: attribute '__dict__' of 'type' objects is not writable
>>> c.__dict__
{}
>>> c.x
1
>>> C.x
1
```

并不是所有的对象都有 `__dict__` 这个属性，例如实现了 `__slots__` 属性的类的对象。拥有 `__slots__` 属性的类在实例化对象时不会自动分配 `__dict__`， 只有在 `__slots__` 中的属性才能被使用，但它的设置只对对象真正的属性有限制作用。如果是用 property 修饰的属性以及属性是一个描述符对象时是不受限制的。

## 描述符

描述符是实现了描述符协议的对象，本质上是一种拥有绑定行为的对象属性。描述符的访问行为被如下的描述符协议方法覆盖：

```python
__get__(self, obj, type=None) --> value

__set__(self, obj, value) --> None

__delete__(self, obj) --> None
```

描述符协议只是一种在模型中引用属性时指定将要发生事件的方法。实现了以上描述符协议三个方法中任意一个的对象即是描述符。同时定义了 `__get__` 和 `__set__` 方法的对象就叫作数据描述符(Data Descriptor)，也被成为资源描述符。而只定义了 `__get__` 方法的对象被叫做非数据描述符(Non-data Descriptor)。实际上类方法(classmethod)即为一个非数据描述符。数据描述符与非数据描述会影响其被访问的顺序。如果实例中存在与数据描述符同名的属性，则会优先访问数据描述符。如果实例中存在与非数据描述符同名的属性，则优先访问实例属性。一个描述符的定义类似如下形式：

```python
class Descriptor(object):  

    def __init__(slef):
        pass

    def __get__(self, instance, owner):
        """用于访问属性

        返回属性的值，或者在所请求的属性不存在的情况下出现 AttributeError 异常
        """
        pass

    def __set__(self, instance, value):
        """用于设置属性值

        将在属性分配操作中调用，不会返回任何内容
        """
        pass

    def __delete__(self, ):
        """用于删除属性

        控制删除操作，不会返回内容
        """
        pass
```

描述符将某种特殊类型的类的`实例`指派给另一个类的`属性`(**注意：** 这里是类属性，而不是对象属性，即描述符被分配给一个类，而不是实例)。描述符相当于是一种创建托管属性的方法。托管属性可以用于保护属性不受修改，对传递的值做检查，或自动更新某个依赖属性的值。下面是一个简单的示例：

```python
class Descriptor(object):

    def __init__(self, m):
        self.m = m

    def __get__(self, instance, owner):
        return instance.n * self.m

    def __set__(self, instance, value):
        if value < 0:
            raise ValueError("Negative value not allowed: %s" % value)
        instance.n = value


class Foo(object):

    bar = Descriptor(0)
    har = Descriptor(1)
    tar = Descriptor(2)
    yar = Descriptor(3)

    def __init__(self, n):
        self.n = n

"""
>>> f = Foo(10)
>>> f.bar
0
>>> f.bar = 100
>>> f.bar
0
>>> f.har
100
>>> f.har = 10
>>> f.har
10
>>> f.yar
30
>>> f.yar = 12345
>>> f.yar
37035
"""
```

Python 中的类方法装饰器 classmethod、staticmethod 实际上是一个非数据描述符，下面是他们的纯 Python 实现示例：

```python
class StaticMethod(object):

    def __init__(self, f):
        self.f = f

    def __get__(self, instance, owner):
        return self.f


class ClassMethod(object):

    def __init__(self, f):
        self.f = f

    def __get__(self, instance, owner):
        if owner is None:
            owner = type(instance)

        def _func(*args):
            return self.f(owner, *args)

        return _func
```

## 对象访问顺序

在 Python 中，解释器将按照如下的优先级顺序在对象中搜索属性:

- 1. 类属性
- 2. 数据描述符（也被称为资料描述符，data descriptor）
- 3. 实例属性
- 4. 非数据描述符

object.__getattribute__(self, name)
类 中的 数据描述符
object.__dict__.get(name) 自身属性字典
object.__class__.__dict__.get(name) 类属性字典 / 非数据描述符
object.__getattr__(name)


下面来了解下与对象属性访问有关的几个方法：

- `__get__`

该方法用来实现 Python 的描述器，与 `__set__`、`__delete__` 一样属于描述符协议的一员。同时实现了 `__get__` 和 `__set__` 的称之为资料描述器（data descriptor），仅仅实现 `__get__` 的则为非描述器，这两个概念涉及到属性的搜索优先级顺序问题。

- `__getattr__`

在访问对象的属性时，首先需要从 `object.__dict__` 属性中搜索该属性，再从 `__getattr__` 方法中查找。该方法与 `__setattr__`、`__delattr__` 方法一样，在访问的属性不存在时被调用。这是 Python 动态语言特性的体现。可以对这三个方法进行重载来实现一些特殊的需求。例如：

```python
class Foo(object):
    def __init__(self):
        pass

    def __getattr__(self, key):
        try:
            return self.__dict__[key]
        except KeyError:
            return None

    def __setattr__(self, key, value):
        self.__dict__[key] = value

    def __delattr__(self, key):
        try:
            del self.__dict__[key]
        except KeyError:
            return None


# Script starts from here

if __name__ == "__main__":
    f = Foo()
    print f.bar
    f.bar = 10
    print f.bar
    del f.bar

# 执行结果：
#   None
#   10
```

- `__getattribute__`

该方法会在每次查找属性和方法时无条件的被调用。在优先级链中，类字典中发现的数据描述符的优先级高于实例变量，实例变量优先级高于非数据描述符，如果提供了 `__getattr__()`，优先级链会为 `__getattr__()` 分配最低优先级。重写该方法时，不能使用 `self.xxx` 的形式访问自己的属性，这样会导致无限递归，而需要访问自己的属性时，应该调用基类的方法。

还有一个与字典相关的方法，这个方法虽然与属性访问无关，这里也做一下简单的介绍。

- `__missing__`

这个方法属于字典，当访问的键不存在时，`dict.__getitem__()` 方法会自动调用该方法。需要注意的是 dict 中并没这个方法，需要在子类中实现。示例：

```python
class FooDict(dict):
    def __missing__(self, key):
        self[key] = "Yes"
        return "Yes"

if __name__ == "__main__":
    fdict = FooDict()
    print fdict
    print fdict["bar"]

# 执行结果：
#   {}
#   Yes
```

可以用该方法来实现一个缺省字典：

```python
class defaultdict(dict):
    def __init__(self, default_factory=None, *a, **kw):
      dict.__init__(self, *a, **kw)
      self.default_factory = default_factory

    def __missing__(self, key):
      self[key] = value = self.default_factory()
      return value
```

## 参考资料

- [https://docs.python.org/3/howto/descriptor.html](https://docs.python.org/3/howto/descriptor.html)
