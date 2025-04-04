# [miniLZO](http://www.oberhumer.com/opensource/lzo/)

miniLZO是一种轻量级的压缩和解压缩库，它是基于LZO压缩和解压缩算法实现的。LZO虽然功能强大，但是编译后的库文件较大，而minilzo编译后的库则小于5kb，因此miniLZO为那些仅需要简单压缩和解压缩功能的程序而设计，所以适用于单片机等嵌入式系统使用。另外miniLZO的压缩率并不是很高，LZO算法看重的是压缩和解压的速度。与LZO相比，UCL算法实现了更好的压缩率，但解压缩速度稍慢。


