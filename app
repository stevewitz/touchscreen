var exec = require('child_process').exec;
var os = require('os');
var timeout = 0;

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
        if(timeout) {
        console,log("timeout in effect");
        return;
        }

        switch(value){
        timeout = 1;
        setTimeout(timeout=0, 500);
            case 0:
                console.log("Screen has been touched")
                gettouch();
                break;
            case 1:
                console.log("screen untouched")

                break;
        }

    });
}

function gettouch(){
    exec('i2cdump  -y 1 0x38 i ', (error, stdout, stderr) => {
        console.log(`stdout: ${stdout}`);
        console.log(`stderr: ${stderr}`);
    })
}