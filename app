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
    if(os.type() == "Windows_NT") {
    var a = "84 19 07 2e 7f"
    var xh = a[1];
    var xlh = a[3];
    var xll = a[4];

xDec =  (256*a[1]) + (16*a[3]) + 1*a[4] ;

xtest = 1024 + 16 + 9;

    console.log(xh*256);
    console.log(xlh*16);
    console.log(xll);
    console.log(a[4].length);
console.log(xDec);
console.log(xtest)




    return
    }
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
    exec('i2cdump  -y 1 0x38 i ', (error, stdout, stderr) => {
        console.log(`stdout: ${stdout}`);
        console.log(`stderr: ${stderr}`);
        console.log("-----------results----------")
        var offset = 85
        for( var i = 0; i < 11; i++){
        console.log("count = "+offset  + i + " :  "+ stdout[offset + i]);

        console.log("x= "  + xPos + "  y= " + yPos);
        }

        xPos = stdout[offset + 1]*256 + stdout[offset + 3]*16 + stdout[offset + 4]*1;
        yPos =stdout[offset + 7]*256 + stdout[offset + 9]*16 + stdout[offset + 10]*1;



    });
}

function endkeepout(){
keepout = 0;
}