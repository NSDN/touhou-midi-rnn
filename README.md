# touhou-midi-rnn
auto generated touhou-style midi tunes with torch-rnn

---
## Introduction
This project downloads midi tracks from [www.touhoumidi.altervista.org](http://www.touhoumidi.altervista.org) and feeds them to LSTM network ([torch-rnn](https://github.com/jcjohnson/torch-rnn)) to produce touhou-style midi tunes

---
## 简介

受 [这些工作](https://highnoongmt.wordpress.com/2015/08/11/deep-learning-for-assisting-the-process-of-music-composition-part-1/) 的启发，这个项目从 [www.touhoumidi.altervista.org](http://www.touhoumidi.altervista.org) 上下载东方相关的 midi 文件，转换处理为 abc 标记文本后，来训练 LSTM 网络 ([torch-rnn](https://github.com/jcjohnson/torch-rnn))，并使用训练好的网络生成 midi 片段。

下载到的 midi 文件大概有两百多首，用不同的处理方法和网络配置训练了几个批次：

* data/alice：仅使用带有多音轨的 midi 文件，将多个音轨摊开并去掉了注释，转换后的文本约 5MB。使用两层 512 节点的 LSTM 网络训练。有明显的 overfitting 注意
  * Sample: <audio controls src="https://github.com/NSDN/touhou-midi-rnn/raw/master/mp3/alice-s1.mp3"></audio>
  * Sample: <audio controls src="https://github.com/NSDN/touhou-midi-rnn/raw/master/mp3/alice-s2.mp3"></audio>
  * Sample: <audio controls src="https://github.com/NSDN/touhou-midi-rnn/raw/master/mp3/alice-s3.mp3"></audio>
  * Sample: <audio controls src="https://github.com/NSDN/touhou-midi-rnn/raw/master/mp3/alice-s4.mp3"></audio>
  * Sample: <audio controls src="https://github.com/NSDN/touhou-midi-rnn/raw/master/mp3/alice-s5.mp3"></audio>
  * Sample: <audio controls src="https://github.com/NSDN/touhou-midi-rnn/raw/master/mp3/alice-s6.mp3"></audio>

* data/sakuya：约 11MB 的文本，两层 256 节点的网络。多了不少狂气注意
  * Sample: <audio controls src="https://github.com/NSDN/touhou-midi-rnn/raw/master/mp3/sakuya-s1.mp3"></audio>
  * Sample: <audio controls src="https://github.com/NSDN/touhou-midi-rnn/raw/master/mp3/sakuya-s2.mp3"></audio>
  * Sample: <audio controls src="https://github.com/NSDN/touhou-midi-rnn/raw/master/mp3/sakuya-s3.mp3"></audio>

* data/aya：将音轨合并后输出产生约 14MB 的文本。两层 256 节点的网络。大量脸滚键盘注意
  * Sample: <audio controls src="https://github.com/NSDN/touhou-midi-rnn/raw/master/mp3/aya-s1.mp3"></audio>
  * Sample: <audio controls src="https://github.com/NSDN/touhou-midi-rnn/raw/master/mp3/aya-s2.mp3"></audio>

更多示例 midi 输出见 [这里](https://github.com/NSDB/touhou-midi-rnn/tree/master/samples)

## 使用

项目库里仅包含使用的部分脚本和训练生成 checkpoint 文件与示例，并不提供用来训练的 midi 源文件。

```shell
# 在 ~ 下安装 torch 和 torch-rnn（省略）
# ...

# 依赖 abcmidi
sudo apt-get install abcmidi

# 旧版本 ubuntu 需要自行编译 midicsv
sudo apt-get install midicsv

# 下载数据并生成样本
./make_inputs.sh data/input

# 开始训练或从最新的 checkpoint 继续
./start_traning.sh data/input

# 使用最新的 checkpoint 输出
./output_sample.sh data/input
```

