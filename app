var exec = require('child_process').exec;
gettouch();

function gettouch(){
    exec('i2cdump  -y 1 0x38 i ', (error, stdout, stderr) => {
        console.log(`stdout: ${stdout}`);
        console.log(`stderr: ${stderr}`);
    })
}