let form = document.getElementById("datatable_form");
let table_body = document.getElementById("table_body");

var table_data;
var table_csv_data;

form.addEventListener("submit", async (e) => {
    e.preventDefault();

    const data = Object.fromEntries(new FormData(form));

    if(!data){
        alert("Neuspješno predati podaci iz forme!");
        return;
    }

    if(data.search_query == undefined || data.search_query.length > 500 || data.search_attribute == undefined ||  data.search_attribute === '' || data.search_attribute.length > 100){
        alert("Upit nije moguće predati!");
        return;
    }

    try{
        const response = await fetch("http://localhost:3000/search", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                attribute: data.search_attribute,
                value: data.search_query
            })
        });

        if(!response.ok){
            alert("Pogreška prilikom komuniciranja s poslužiteljem! Pogledati konzolu za detalje.");
            console.error(`Pogreška ${response.status}: ${response.statusText}`);
            return;
        }

        const result = await response.json();

        fillTable(result, data.search_query, data.search_attribute);
        confirmTableData(result);
    }
    catch(error){
        alert("Pogreška pri obradi zahtjeva! Pogledati konzolu za detalje.");
        console.error(`Pogreška: ${error}`);
        return;
    }
})

window.onload=async()=>{
    try{
        const response = await fetch("http://localhost:3000/search", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                attribute: "default",
                value: ""
            })
        });

        if(!response.ok){
            alert("Pogreška prilikom komuniciranja s poslužiteljem! Pogledati konzolu za detalje.");
            console.error(`Pogreška ${response.status}: ${response.statusText}`);
            return;
        }

        const result = await response.json();

        fillTable(result);
        confirmTableData(result);
    }
    catch(error){
        alert("Pogreška pri obradi zahtjeva! Pogledati konzolu za detalje.");
        console.error(`Pogreška: ${error}`);
        return;
    }
}

function fillTable(data, value=null, attribute=null){
    let component = "";

    for(const row of data){
        component += "<tr>"

        component += `<td class="border-right">${row.name}</td>\n`;
        component += `<td>${row.address}</td>\n`;
        component += `<td>${row.city}</td>\n`;
        component += `<td>${row.country_tag}</td>\n`;
        component += `<td>${row.place_latitude}</td>\n`;
        component += `<td class="border-right">${row.place_longitude}</td>\n`;
        component += `<td>${row.number_of_platforms}</td>\n`;
        component += `<td>${row.number_of_tracks}</td>\n`;
        component += `<td>${row.length}</td>\n`;
        component += `<td>${row.establishing_date}</td>\n`;
        component += `<td>${row.opening_time}</td>\n`;
        component += `<td>${row.closing_time}</td>\n`;
        component += `<td>${row.available}</td>\n`;
        component += `<td>${row.train_capacity}</td>\n`;
        component += `<td>${row.owner}</td>\n`;
        component += `<td class="border-right">${row.owner_contact}</td>\n`;
        component += `<td>${row.train_type}</td>\n`;
        component += `<td>${row.number_of_wagons}</td>\n`;
        component += `<td>${row.passenger_capacity}</td>\n`;
        component += `<td>${row.train_latitude}</td>\n`;
        component += `<td>${row.train_longitude}</td>\n`;

        component += "</tr>";
    }

    if(value && (!attribute || attribute === "default")) component = component.replaceAll(`${value}`,`<span class='mark'>${value}</span>`);
    component = component.replaceAll("null","");

    table_body.innerHTML = component;
}

function confirmTableData(data){
    table_data = data;
    table_csv_data = jsonToCsv(data);
}

function jsonToCsv(data){
    if (!data || data.length == 0) return "";

    const headers = ["name","address","city","country_tag","place_latitude","place_longitude","number_of_platforms","number_of_tracks","length","establishing_date","opening_time","closing_time","available","train_capacity","owner","owner_contact","train_type","number_of_wagons","passenger_capacity","train_latitude","train_longitude"];

    const csvRows = [
        "name,address,city,country_tag,latitude,longitude,number_of_platforms,number_of_tracks,length,establishing_date,opening_time,closing_time,available,train_capacity,owner,owner_contact,train_type,number_of_wagons,passenger_capacity,latitude,longitude",
        ...data.map(row => 
        headers.map(key => {
            const escaped = String(row[key] ?? "").replace(/"/g, '""');
            return `"${escaped}"`;
        }).join(",")
        )
    ];

    return csvRows.join("\n");
}


function downloadFile(content, filename, mimeType) {
    const blob = new Blob([content], {
        type: mimeType
    });

    const url = URL.createObjectURL(blob);

    const a = document.createElement("a");
    a.href = url;
    a.download = filename;

    document.body.appendChild(a);
    a.click();
    a.remove();

    URL.revokeObjectURL(url);
}

document.getElementById("download_csv").addEventListener("click", ()=>{
    downloadFile(
        "\uFEFF"+table_csv_data,
        new Date().toISOString().replaceAll(/[.:TZ-]/g,"-")+"fer-or-lab.csv",
        "text/csv;charset=utf-8;"
    );
});


document.getElementById("download_json").addEventListener("click", ()=>{
    downloadFile(
        JSON.stringify(table_data, null, 4),
        new Date().toISOString().replaceAll(/[.:TZ-]/g,"-")+"fer-or-lab.json",
        "application/json"
    );
});