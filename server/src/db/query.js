import { pool } from "./pool.js";

export async function getAll(){
    const result = await pool.query(
        "SELECT name, address, city, country_tag, p.latitude AS place_latitude, p.longitude AS place_longitude, number_of_platforms, number_of_tracks, length, establishing_date, opening_time, closing_time, available, train_capacity, owner, owner_contact, train_type, number_of_wagons, passenger_capacity, t.latitude AS train_latitude, t.longitude AS train_longitude \
         FROM station s \
         LEFT JOIN place p ON p.place_id = s.place_id \
         LEFT JOIN train t ON t.station_id = s.station_id \
         ORDER BY s.station_id, t.train_id ASC"
    );
    return result.rows;
}

export async function weakSearchByAttribute(attribute, value){
    const result = await pool.query(
        `SELECT name, address, city, country_tag, p.latitude AS place_latitude, p.longitude AS place_longitude, number_of_platforms, number_of_tracks, length, establishing_date, opening_time, closing_time, available, train_capacity, owner, owner_contact, train_type, number_of_wagons, passenger_capacity, t.latitude AS train_latitude, t.longitude AS train_longitude
        FROM station s
        LEFT JOIN place p ON p.place_id = s.place_id
        LEFT JOIN train t ON t.station_id = s.station_id
        WHERE ${attribute}::text LIKE '%' || $1 || '%'
        ORDER BY s.station_id, t.train_id ASC`,
        [value]
    );    
    return result.rows;
}

export async function weakSearchAll(value){
    const result = await pool.query(
        `WITH result AS (
            SELECT s.station_id AS station_id, t.train_id AS train_id, name, address, city, country_tag, p.latitude AS place_latitude, p.longitude AS place_longitude, number_of_platforms, number_of_tracks, length, establishing_date, opening_time, closing_time, available, train_capacity, owner, owner_contact, train_type, number_of_wagons, passenger_capacity, t.latitude AS train_latitude, t.longitude AS train_longitude
            FROM station s
            LEFT JOIN place p ON p.place_id = s.place_id
            LEFT JOIN train t ON t.station_id = s.station_id
        )
        SELECT r.name, r.address, r.city, r.country_tag, r.place_latitude, r.place_longitude, r.number_of_platforms, r.number_of_tracks, r.length, r.establishing_date, r.opening_time, r.closing_time, r.available, r.train_capacity, r.owner, r.owner_contact, r.train_type, r.number_of_wagons, r.passenger_capacity, r.train_latitude, r.train_longitude
        FROM result r
        WHERE EXISTS (
            SELECT 1
            FROM jsonb_each_text(to_jsonb(r) - 'station_id' - 'train_id') kv
            WHERE kv.value LIKE '%' || $1 || '%'
        )
        ORDER BY r.station_id, r.train_id
        `,
        [value]
    );
    return result.rows;
}