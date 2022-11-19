# Gen SRT file

Convert simple paragraph text to SRT file.

# Usage

```
gensrt.rb <source...>
```

# Format

Each paragraph as each subtitle.

```
x

y
```

to

```
1
00:00:00,000 --> 00:00:05,000
x

2
00:00:05,000 --> 00:00:10,000
y
```

`@timecode` to set current time.

```
x

@5:00,000

y
```

to

```
1
00:00:00,000 --> 00:00:05,000
x

2
00:05:00,000 --> 00:05:05,000
y
```

`#second` to set duration for this paragraph.

```
x

#10
y

z
```

```
1
00:00:00,000 --> 00:00:05,000
x

2
00:00:05,000 --> 00:00:15,000
y

3
00:00:15,000 --> 00:00:20,000
z
```

`=second` to set default duration (5 by deafult.)

```
=10

x

y

z
```

to

```
1
00:00:00,000 --> 00:00:10,000
x

2
00:00:10,000 --> 00:00:20,000
y

3
00:00:20,000 --> 00:00:30,000
z
```