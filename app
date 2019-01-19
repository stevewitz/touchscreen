var exec = require('child_process').exec;
var os = require('os');
var keepout = 0;

if(os.type() != "Windows_NT") {
    var Gpio = require('onoff').Gpio;

        //  led = new Gpio(59, 'out'),
        //   button = new Gpio(78, 'in', 'both');
    touch = new Gpio(25, 'in', 'both'); //left

}

 setupTouch();

function setupTouch(){
    if(os.type() == "Windows_NT") {return}
    console.log("We are at GPIO 25");
    touch.watch(function (err,value){
        if(err){
            console.log(err);
        }
        if(keepout) {
        console.log("timeout in effect");
        return;
        }

        switch(value){

            case 0:
                console.log("Screen has been touched")
                 keepout = 1;
                 setTimeout(endkeepout, 500);
                gettouch();

                break;
            case 1:
                console.log("screen untouched")

                break;
        }

    });
}

function gettouch(){

    var child = exec('i2cdump  -y 1 0x38 i');
    child.stdout.on('data', function (data) {
    console.log(data + '%');
    console.log(data[0x13]);
    console.log(data[0x14]);
    console.log(data[0x15]);
    console.log(data[0x16]);
    console.log(data[0x17]);
    console.log(data[0x18]);
    console.log(data[0x19]);
    console.log(data[0x20]);

    });
}

function endkeepout(){
keepout = 0;
}