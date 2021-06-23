const express = require('express');
const hbs = require('hbs');
const wax = require('wax-on');
const mysql = require('mysql2/promise');

// create express app
let app = express();

// set view engine to hbs
app.set('view engine', 'hbs')

// all css, image files and js files are in public folder
app.use(express.static('public'));

// set up template inheritance
wax.on(hbs.handlebars);
wax.setLayoutPath('./views/layouts');


// set up forms handling
app.use(express.urlencoded({
    extended:false
}))

// routes
async function main (){
    // getting a connection is asynchrnous
    const connection = await mysql.createConnection({
        'host':'localhost',
        'user':'root',
        'database':'sakila'
    })

    app.get('/',(req,res)=>{
        res.send('Hello world')
    })
}

main();


// start server
app.listen('3000', ()=>{
    console.log("Server Started")
} )