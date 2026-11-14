import express from "express";
import "dotenv/config";
import { getAll, weakSearchAll, weakSearchByAttribute } from "./db/query.js";
import cors from "cors";

const externalUrl = process.env.RENDER_EXTERNAL_URL;    // U slucaju deploya na Renderu
const port = process.env.PORT ? parseInt(process.env.PORT) : 3000;
const baseURL = externalUrl || `http://localhost:${port}`;
const hostname = externalUrl ? '0.0.0.0': '127.0.0.1';

const app = express();
app.use(express.json());
app.use(cors());

function processAttribute(attribute){
    switch(attribute){  // ovo može biti brže, ali na ovaj način radimo restrikciju nad nazivima atributa
        case "s_name": return "s.name";
        case "p_address": return "p.address";
        case "p_city": return "p.city";
        case "p_country_tag": return "p.country_tag";
        case "p_latitude": return "p.latitude";
        case "p_longitude": return "p.longitude";
        case "s_number_of_platforms": return "s.number_of_platforms";
        case "s_number_of_tracks": return "s.number_of_tracks";
        case "s_length": return "s.length";
        case "s_establishing_date": return "s.establishing_date";
        case "s_opening_time": return "s.opening_time";
        case "s_closing_time": return "s.closing_time";
        case "s_available": return "s.available";
        case "s_train_capacity": return "s.train_capacity";
        case "s_owner": return "s.owner";
        case "s_owner_contact": return "s.owner_contact";
        case "t_train_type": return "t.train_type";
        case "t_number_of_wagons": return "t.number_of_wagons";
        case "t_passenger_capacity": return "t.passenger_capacity";
        case "t_latitude": return "t.latitude";
        case "t_longitude": return "t.longitude";
        default: return null;
    }
}

app.get("/", async (req, res) => {
    const result = await getAll();
    res.send(result);
});

app.post("/search", async (req, res) => {
    if(req.body == undefined || req.body.value == undefined || req.body.attribute == undefined){
        res.status(400).send();
    }

    const attribute = processAttribute(req.body.attribute);

    let data;
    if(attribute === null){
        data = await weakSearchAll(req.body.value);
    }
    else{
        data = await weakSearchByAttribute(attribute, req.body.value);
    }

    res.send(data);
});

app.listen(port, hostname, () => {
    console.log(`Poslužitelj pokrenut na ${hostname}:${port}`);
});