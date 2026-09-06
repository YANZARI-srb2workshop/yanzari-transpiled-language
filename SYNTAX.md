# Syntax
This is the language's syntax. \
I was inspired by C++.

I styled it in a way that's similar to C++, but it also incorporates elements of Python, Java, and Lua (obviously).

## Functions
```ytl
    // Single Return

    int foo(int v1,int v2) {
        return v1+v2
    }
    // Multiple Returns

    int,int foo2(int v1,...) {
        any[] me = [...]
        number[] you
        for (k,v) in ipairs(me) {
            you:insert(k)
        } 
        return table->unpack(you)
    }
    // Call

    print(foo(1,2))
```

## Variables
> supports Unicode characters.
to initialize a variable:
```ytl
    int me1 // integer (signed 32bits)
    float me2 // fixed point
    string me3 // string
    int16 me4 // 16bits integer
    uint16 me5 // unsigned 16bits integer
    auto me6 = "string" // now its string
```
if you want to assign a value later:
```ytl
    me1 = 1
    me2 = 2.3
    me3 = "hello" // string is immutable
    me4 = -40
    me5 = 10
    me6 = 0b00001111 // error
```

## Types of Numbers
```ytl
    1 // integer
    2.3 // float
    1e2 // exponent
    0b01010101 // binary
    0xFF // hexadecimal
    0o12 // octal
```

## Types of Strings
```ytl
    "string" // string
    'string' // string
    """
        Fine
    """ // Long String
    '''
        Fine
    ''' // Long String
    `Day` // Template
```

## Classes
without Inheritance:
```ytl
    class Point {
    private:
        float x;
        float y;
    public:
        constructor new(float x, float y) { // Constructor
            self->x = x
            self->y = y
        }
        void print() {
            System.out->println("Point")
            System.out->println(self->x)
            System.out->println(self->y)
        }
    }
```
with Inheritance:
```ytl
    class CustomPoint: Point {
    public:
        void print() {
            System.out->println('CustomPoint')
            System.out->println(self->x)
            System.out->println(self->y)
        }
    }
```

## Switch
```ytl
int day = 4;
string cout
switch (day) {
  case 1:
    cout = "Monday";
    break;
  case 2:
    cout = "Tuesday";
    break;
  case 3:
    cout = "Wednesday";
    break;
  case 4:
    cout = "Thursday";
    break;
  case 5:
    cout = "Friday";
    break;
  case 6:
    cout = "Saturday";
    break;
  case 7:
    cout = "Sunday";
    break;
}
System.out->println(cout)
```

## If
```ytl
int age = 20;
boolean isCitizen = true;

if (age >= 18) {
  System.out->println("Old enough to vote.\n");

  if (isCitizen) {
    System.out->println("And you are a citizen, so you can vote!\n");
  } else {
    System.out->println("But you must be a citizen to vote.\n");
  }
} else {
  System.out->println("Not old enough to vote.\n");
}

```

## Enum
```ytl
enum Level {
  LOW,
  MEDIUM,
  HIGH
}; 
```

## While
```ytl
int countdown = 3;

while (countdown > 0) {
  cout << countdown << "\n";
  countdown--;
}
```

## Break
```ytl
int i = 0;
while (i < 10) {
  System.out->println(i);
  i++;
  if (i == 4) {
    break;
  }
}
```

## Continue
```ytl
int i = 0;
while (i < 10) {
  if (i == 4) {
    i++;
    continue;
  }
  System.out->println(i);
  i++;
}
```

## Namespace
```ytl
namespace YTL {
  int x = 42;
}
```

## Imports
```ytl
import * from "me.ytl" as me
import i_like_potato from "you.ytl"
// ...
```

## Exports
```ytl
// ...
export {
    me,
    you,
    us
}
```

## Typing
If you want to type a variable using Generics:
```ytl
    Box<int> me
    Box<string> you
    Box<boolean> you_cant_beat_us
```
If you want to type a class using Generics:
```ytl
template<T>
struct Box {
    T value;
};
```

## Metaprogramming
```ytl
@cpp_dont_have_that(1,"hehe")
int lets_test() {
    return 1+1
}
```