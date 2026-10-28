# fer-or-lab
FER 2026./2027. - Otvoreno računarstvo - Laboratorijske vježbe

---

# LICENCIJA
[GPL-3.0 licence](LICENCE)

---

## Autori
**Antonio Šantak**

---

## Verzija
`v1.0`

---

## Jezici otvorenih podataka
- engleski jezik (*naziv atributa i objekata*)
- hrvatski jezik (*vrijednosti atributa*)

---

## Opis podataka
Modeliraju se stanice i kolodvori (*station*) koje se nalaze na određenim lokacijama, tj. mjestima (*place*), a sadrže vlakove.
Vlakovi koji nisu na stanicama nisu u interesu, samo se motre vlakovi koji se zadržavaju na stanicama.

Glavni predmet ovih podataka su stanice. Njih nadopunjuju podaci kao što su njihova mjesta i pripadajući vlakovi.

---


## Baza podataka
Koristi se PostgreSQL baza podataka.
Baza podataka je sačinjena od 3 relacijske tablice: *place*, *station*, *train*.

Odnos tablica je sljedeći:
*place* -> __(1 : N)__ => *station* -> __(1 : N)__ => *train*

Opis tablica i njihovih atributa:


### `place` (*mjesto*)

Definiranje jedinstvenog, geografskog mjesta.

| naziv atributa | vrsta atributa | opis atributa |
| -- | -- | -- |
| place_id | primarni ključ | jedinstvena oznaka mjesta |
| address | znakovni niz | adresa |
| city | znakovni niz | grad / naselje |
| country_tag | znakovni niz | oznaka države |
| latitude | broj pomičnog zareza dvostruke preciznosti | geografska širina |
| longitude | broj pomičnog zareza dvostruke preciznosti | geografska dužina |

#

### `station` (*stanica / kolodvor*)

Definicija jedinstvenih željezničkih stanica i kolodvora.

| naziv atributa | vrsta atributa | opis atributa |
| -- | -- | -- |
| station_id | primarni ključ | jedinstvena oznaka stanice |
| name | znakovni niz | naziv stanice |
| place_id | strani ključ | ID mjesta na kojem se stanica nalazi |
| number_of_platforms | cijeli broj | broj perona |
| number_of_tracks | cijeli broj | broj kolosijeka |
| length | broj pomičnog zareza dvostruke preciznosti | dužina stanice |
| establishing_date | datum | dan nastanka |
| opening_time | vrijeme | vrijeme otvaranja |
| closing_time | vrijeme | vrijeme zatvaranja |
| available | logička vrijednost | dostupnost |
| train_capacity | cijeli broj | kapacitet vlakova na stanici |
| owner | znakovni niz | vlasnik stanice / kolodvora |
| owner_contact | znakovni niz | kontakt vlasnika |

#

### `train` (*vlak*)

Definicija pojedinačnih vlakova koji mogu, ali ne moraju biti na stanici.

| naziv atributa | vrsta atributa | opis atributa |
| -- | -- | -- |
| train_id | primarni ključ | jedinstvena oznaka vlaka |
| station_id | strani ključ | ID stanice na kojoj se vlak može nalaziti, inače NULL ako nije na stanici |
| train_type | znakovni niz | vrsta vlaka (putnički ili teretni) |
| number_of_wagons | cijeli broj | broj vagona |
| passenger_capacity | cijeli broj | kapacitet putnika ako je vlak putničkog tipa  |
| latitude | broj pomičnog zareza dvostruke preciznosti | geografska širina |
| longitude | broj pomičnog zareza dvostruke preciznosti | geografska dužina |

#

## Pojednostavljeni dijagram entiteta baze podataka

```mermaid
graph LR
A[place] -->B[station]
B[station]-->C[train]
```

---

## Poredak atributa u CSV datoteci
Kada se uzmu atributi iz baze podataka, obrišu se primarni i strani ključevi te se poredaju atributi iz mjesta, stanica i vlakova dobije se oblik koji odgovara zaglavlju CSV datoteke:
```
name,address,city,country_tag,latitude,longitude,number_of_platforms,number_of_tracks,length,establishing_date,opening_time,closing_time,available,train_capacity,owner,owner_contact,train_type,number_of_wagons,passenger_capacity,latitude,longitude
```

## Poredak atributa u JSON datoteci
Sljedeći odlomak prikazuje strukturu jednog objekta stanice s pripadajućim atributima bez podataka (nije valjani JSON format, samo reprezentacija atributa i objekata):
```
{
    "name",
    "place": { "address", "city", "country_tag", "latitude", "longitude" },
    "trains": [
        { "train_type", "number_of_wagons", "passenger_capacity", "latitude", "longitude" }
    ],
    "number_of_platforms", "number_of_tracks", "length", "establishing_date", "opening_time", "closing_time", "available", "train_capacity", "owner", "owner_contact"
}
```
Struktura prikazuje kako su objekti mjesta (*place*) uklopljeni unutar objekta stanice, a više vlakova (*train*) je poredano kao lista (*JSON array*) unutar objekta.

---

## Generiranje CSV i JSON datoteka iz baze podataka
Za generiranje potrebnih datoteka, koristili su se `COPY` SQL upiti unutar sučelja pgAdmin-a.
Za CSV i JSON izvoz izvode se posebni `SELECT` upiti koji učaruhuju izvoz u potrebni format, a JSON posebno koristi i specifične procedure za stvaranje proizvoljnih objekata.

Kod se nalazi u datoteci [generate_csv_json.sql](generate_csv_json.sql).

---

## *Dump* baze podataka
Izvoz baze podataka je učinjen pomoću alata *pg_dump*.
Alat je program ponuđen od strane pgAdmin-a, a omogućuje jednostavan izvoz bazi podataka.
Za potrebe ovih podataka, izvoz je izvršen sljedećom naredbom u naredbenom redku (radni direktorij alata *pg_dump*):

`>>> pg_dump.exe -h localhost -U postgres -d fer-or-lab -f /fer-or-lab.sql `

Uz naredbu su dodani korisničko ime, naziv baze podataka i ostali podaci nužni za izvoz.

---