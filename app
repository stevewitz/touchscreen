var exec = require('child_process').exec;
var os = require('os');
var keepout = 0;

if(os.type() != "Windows_NT") {
    var Gpio = require('onoff').Gpio;

    touch = new Gpio(25, 'in', 'falling'); //left

}

 setupTouch();


function setupTouch(){
    if(os.type() == "Windows_NT") {
        var a = "8a 19 07 2e 7f"
        var xh = a[1];
        var xlh = a[3];
        var xll = a[4];

        xDec =  (256*("0x" + a[1])) + (16*a[3]) + 1*a[4] ;
        xtest = 1024 + 16 + 9;
        console.log(xh*256);
        console.log(xlh*16);
        console.log(xll);
        console.log(a[4].length);
        console.log(xDec);
        console.log(xtest)
        return
    }
    // if not Windows_NT then come here
    console.log("We are at GPIO 25");
    touch.watch(function (err,value){
        if(err){
            console.log(err);
        }
        if(keepout) {
       // console.log("timeout in effect");
        return;
        }

        switch(value){
            case 0:
             //  console.log("Screen has been touched")
                 keepout = 1; // sort of debounce  only take first touch, then nothing for 500 ms
                 setTimeout(endkeepout, 500);
                 gettouch();
                    getbatt();  //just for testiing battery here
                break;
            case 1:
             //   console.log("screen untouched")

                break;
        }

    });
}

function gettouch(){
    var offset = 85;
    exec('i2cdump  -y 1 0x38 i ', (error, stdout, stderr) => {
        xPos = ("0x" + stdout[offset + 1])*256 + ("0x" + stdout[offset + 3])*16 + ("0x" + stdout[offset + 4])*1;
        yPos =("0x" + stdout[offset + 7])*256 + ("0x" + stdout[offset + 9])*16 + ("0x" + stdout[offset + 10])*1;
        console.log("x= "  + xPos + "  y= " + yPos);
    });
}

function getbatt(){
    var batt
    exec('i2cget -y 1 0x36 0x04', (error, stdout, stderr) => {
    console.log("stdout = " + stdout);
    batt = ("0x" + stdout[0])*16 + ("0x" +stdout[1]);
    console.log("BATTERY % = " + batt)

    });
}

function endkeepout(){
    keepout = 0;
}