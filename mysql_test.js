// import in mysql2 package
const mysql = require('mysql2/promise');


// create a database connection to our MySQL server
async function main() {
    // getting a connection is asynchrnous
    const connection = await mysql.createConnection({
        'host':'localhost',
        'user':'root',
        'database':'Chinook'
    })

    let query = "select * from Album";
    // connection.execute returns an array
    // doing array destructuring here, basically [rows] is taking the first element of the array that is returned from connection.execute
    let [rows] = await connection.execute(query);
    console.log(rows)
    
}

main ();