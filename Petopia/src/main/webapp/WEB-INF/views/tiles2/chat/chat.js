var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var config = require('./config.json');

app.get('/', function (req, res) {
    res.send(__dirname + '/videochat.jsp');
});

io.on('connection', function (socket) {
    console.log('상대가 접속을 했습니다.');
    var name = "${Name}";
    console.log('${Name}');
    
    socket.on('disconnect', function () {
        console.log('상대가 접속해제를 했습니다.');
    });
 
    socket.on('send_msg', function (name,msg) {
        //콘솔로 출력을 한다.
    	var message = name + ': ' + msg; 
        console.log(msg);
        //다시, 소켓을 통해 이벤트를 전송한다.
        io.emit('send_msg', message);
    });
});
 
http.listen(3000, function () {
    console.log('서버에연결되었습니다!');
});

