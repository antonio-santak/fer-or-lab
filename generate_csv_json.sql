------------------------------------------------------------

COPY (
    SELECT json_agg(station_json)
    FROM (
        SELECT json_build_object(
            'name', s.name,
            'place',    CASE WHEN p.place_id IS NOT NULL THEN json_build_object(
                            'address', p.address,
                            'city', p.city,
                            'country_tag', p.country_tag,
                            'latitude', p.latitude,
                            'longitude', p.longitude
                            ) ELSE NULL
                        END,
            'trains', COALESCE((
                SELECT json_agg(json_build_object(
                    'train_type', t.train_type,
                    'number_of_wagons', t.number_of_wagons,
                    'passenger_capacity', t.passenger_capacity,
                    'latitude', t.latitude,
                    'longitude', t.longitude
                    ))
                FROM train t
                WHERE t.station_id = s.station_id
            ), '[]'::json),
            'number_of_platforms', s.number_of_platforms,
            'number_of_tracks', s.number_of_tracks,
            'length', s.length,
            'establishing_date', s.establishing_date,
            'opening_time', s.opening_time,
            'closing_time', s.closing_time,
            'available', s.available,
            'train_capacity', s.train_capacity,
            'owner', s.owner,
            'owner_contact', s.owner_contact
        ) 
        AS station_json
        FROM station s
        LEFT JOIN place p ON s.place_id = p.place_id
        ORDER BY s.station_id
    )
    aggregated_data
)
TO 'D:/fer/or/labosi/lab1/fer-or-lab/fer-or-lab.json'

------------------------------------------------------------

COPY (
    SELECT s.name, p.address, p.city, p.country_tag, p.latitude, p.longitude, s.number_of_platforms, s.number_of_tracks, s.length, s.establishing_date, s.opening_time, s.closing_time, s.available, s.train_capacity, s.owner, s.owner_contact, t.train_type, t.number_of_wagons, t.passenger_capacity, t.latitude, t.longitude
    FROM station s 
    LEFT JOIN place p ON s.place_id = p.place_id 
    LEFT JOIN train t ON s.station_id = t.station_id 
    ORDER BY s.station_id
)
TO 'D:/fer/or/labosi/lab1/fer-or-lab/fer-or-lab.csv'
WITH (FORMAT CSV, HEADER);

------------------------------------------------------------