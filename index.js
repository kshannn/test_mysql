const express = require('express');
const hbs = require('hbs');
const wax = require('wax-on');
const mysql = require('mysql2/promise');
const helpers = require('handlebars-helpers')({
    handlebars: hbs.handlebars
});

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

    app.get('/',async (req,res)=>{
        let [actors] = await connection.execute('select * from actor');
        res.render('actors', {
            'actors':actors
        })
    })

    app.get('/city', async(req,res)=>{
        let query = `select * from city join country on city.country_id = country.country_id`;
        let [cities] = await connection.execute(query);
        res.render('cities',{
            'cities': cities
        })
    })

    app.get('/customer', async(req,res)=>{
        let query = 'select * from customer';
        let [customers]= await connection.execute(query);
        res.render ('customers', {
            'customers': customers
        })
    })

    // search for customer
    app.get('/customer/search', async(req,res)=>{
        let query = 'select * from customer where 1';

        if (req.query.search_terms){
            query += ` and first_name like '%${req.query.search_terms}%'`; 
        }

        let [customers]= await connection.execute(query);
        res.render ('customers', {
            'customers': customers,
            'search_terms': req.query.search_terms
        })
    })



    //search for actor
    app.get('/search', async (req,res) => {

        // the MASTER query (the always true query)
        let query = 'select * from actor where 1';

        if (req.query.search_terms){
            query += ` and first_name like '%${req.query.search_terms}%'`
        }

        let [actors] = await connection.execute(query);
        res.render('search', {
            'actors':actors,
            'search_terms': req.query.search_terms
        })
    })

    // Show Country Page
    app.get('/countries', async (req,res)=>{
        let query = 'select * from country';
        let [countries] = await connection.execute(query);
        res.render('countries', {
            'countries': countries
        })
    })

    // Post country
    app.post('/countries', async (req,res)=>{
        let country = req.body.country
        let query = 'insert into country (country) values (?);'
        let bindings = [country]

        // why can't do this -> complicate things if there's seach engine involved, also does not allow people to bookmark the url as form will expire, also keep have a popup if you try to go back to the previous page
        // let [countries] = await connection.execute(query,bindings);
        // res.render('countries', {
        //     'countries': countries
        // })
        // do this
        await connection.execute(query, bindings);
        res.redirect('/countries')
    })

    // Update country

    // First, retrieve specific country
    app.get('/countries/:country_id/edit', async(req,res)=>{
        let query = 'select * from country where country_id=?;'
        let [country] = await connection.execute(query,[req.params.country_id]);
        let targetCountry = country[0]
        res.render('edit_country',{
            'country': targetCountry
        })
    })

    // Next, update the country and redirect to countries page
    app.post('/countries/:country_id/edit', async(req,res)=> {
        let country = req.body.country
        let query = `update country set country=? where country_id=?;`
        let bindings = [country, req.params.country_id]
        await connection.execute(query,bindings)
        res.redirect('/countries')

    })

    // Delete country
    // Retrieve country you want to delete
    // app.get('/countries/:country_id/delete', async(req,res)=>{
    //     let query = 'select * from country where country_id=?'
    //     let [country] = await connection.execute(query, [req.params.country_id])
    //     let targetCountry = country[0]
    //     res.render('delete_country',{
    //         'country': targetCountry
    //     })
    // })

    // app.post('/countries/:country_id/delete', async(req,res)=>{
    //     let query = 'delete * from country where country_id=?'
    //     await connection.execute(query,[req.params.country_id]) 
    // })
        

    // create a new city
    app.get('/cities/create', async(req,res)=>{
        let query = 'select * from country order by country;'
        let [countries] = await connection.execute(query);

        res.render('create_city',{
            'countries': countries
        })
    })


    app.post('/cities/create', async (req,res)=>{
        console.log(req.body)
        let {city, country} = req.body;

        // add query to insert into mySQL database
        let query = 'insert into city (city, country_id) values (?, ?)';
        let bindings = [city,country]
        await connection.execute(query,bindings)
        res.send("success")
    })

    // update city
    app.get('/cities/:city_id/edit', async (req,res)=>{

        // select target city to edit
        let query = 'select * from city where city_id=?'
        let [city] = await connection.execute(query, [req.params.city_id]);
        let targetCity = city[0]

        // pass in the country for the dropdown
        let [countries] = await connection.execute('select * from country order by country');
        

        res.render('edit_city',{
            'city': targetCity,
            'countries': countries
        })
    })

    app.post('/cities/:city_id/edit', async(req,res)=>{
        let {city,country} = req.body
        // query to update row
        let query = `update city set city=?, country_id=? where city_id = ?`
        let bindings = [city, country, req.params.city_id]
        await connection.execute(query,bindings)
        res.send("City succesfully updated")
    })


    




    
    
    



}

main();


// start server
app.listen('3000', ()=>{
    console.log("Server Started")
} )