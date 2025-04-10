# PageTurner

[![Ruby Version](https://img.shields.io/badge/Ruby-3.3.0-red.svg)](https://ruby-lang.org)
[![Rails Version](https://img.shields.io/badge/Rails-8.0.0-blue.svg)](https://rubyonrails.org)


PageTurner è un progetto che permette a topi di biblioteca da tutto il mondo di socializzare parlando delle loro ultime letture. L'obiettivo è allontanarsi dal marketing continuo dell’industria dell’editoria, che vede la letteratura solamente come prodotto da vendere, pubblicizzare, recensire e sfruttare. PageTurner si impegna per creare un ambiente dove ciò che conta sono le emozioni che possono nascere solo da un buon libro, una comoda poltrona e una tazza della tua bevanda preferita. Rinuncia alle sgradevoli esperienze di e-commerce il cui unico interesse è vendere il prossimo libro, entra in una comunità di lettori come te e condividi le tue riflessioni in uno spazio moderato, gestito da Curatori scelti per le loro capacità di favorire il dibattito sano e rispettoso.
Pensiamo sarebbe meglio trovare localmente un club del libro, magari presso una biblioteca pubblica vicino a te, e ti spingiamo a farlo e a sostenere le iniziative dei centri culturali a te vicini! Purtroppo per tanti motivi ciò può non essere possibile, oppure semplicemente i libri proposti possono essere molto lontani dalla tua sensibilità. Questo non deve essere motivo per un lettore di allontanarsi dalla gioia che deriva dal parlare del nuovo libro di una collana o dell’ultimo capitolo letto. PageTurner rappresenta la tua possibilità di prendere parte a un club del libro che si riunisce ogni settimana all’altro capo del mondo senza spendere nulla per l’aeroplano. 
Insieme al tuo gruppo puoi decidere i libri da esplorare e comunicare obiettivi di lettura per ritrovarvi intorno al fuoco e raccontare cosa vi ha comunicato ciò che avete letto. Tieni traccia del tuo passato da lettore, realizza cataloghi di libri e condividi selezioni con i tuoi amici. Mantieni un occhio sulle tue letture preferite, osserva le tue caratteristiche da lettore e scegli cosa leggere indipendentemente da quello che gli editori vorrebbero che tu leggessi. La lettura non deve essere un passatempo solitario, e per poter trovare felicità nel discutere un libro non serve essere critici letterari.
Il servizio è gestito attraverso l’API di OpenLibrary, che mette a disposizione un archivio importante su tutte le pubblicazioni, autori e edizioni. I nostri database si interfacciano con OpenLibrary per trovare informazioni sui libri letti e realizzare tabelle, grafici e statistiche disponibili all’utente sulle sue abitudini di lettura.


---

## Table of Contents
- [Work in Progress](#work-in-progress)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Running the App](#running-the-app)
- [License](#license)

---

## Work in Progress

- [x] Fix navbar "logout" button not displaying correctly
- [ ] Style report buttons
- [ ] Add "Report Club" functionality
- [ ] Add tab icon in browser

### Homepage 
- [ ] Add "New post" button/form
- [x] Add Guest User homepage 
- [ ] Divide special bookshelves from user-created
- [ ] Add club infocard to the right

### Users
- [ ] Fix user description on user profile
- [ ] Fix curator's club bookshelves showing up on profile
- [ ] Add a way to request becoming a curator
- [ ] Add favorite book

### Books
- [ ] Fix books input from user
- [ ] Fix books show (only admin can edit Books)

### Bookshelves
- [ ] Special Bookshelves should not be modifiable
- [ ] Bookshelf creation
- [ ] Add "Add book to Bookshelf" functionality
- [ ] Display Posts made about the books in the bookshelf

### Posts
- [x] Add interaction (comments, likes) support
- [ ] Style comments and likes

### Bookclubs
- [ ] Add "New post" button/form
- [ ] Add support for "Community posts" from curator
- [ ] Add events
- [ ] Add support for group reading
- [ ] Add calendar (?)

### Admin
- [ ] Add "Make User into Curator" support
- [ ] Add "Make User into Author" support
- [ ] Should not be able edit post

### Routing
- [ ] Add "Credits" redirect on footer

### Database refactor
- [x] Users -> club (string (name)) to is_curator
- [x] Bookshelf_contains -> book (isbn) to book_id and (name, creator) to bookshelf_id 
- [x] Bookshelf -> creator (email) to creator_id (references user)
- [x] Clubs -> curator (email) to curator_id (references user)
- [ ] Posts -> creator (email) to poster_id (references user), [club, curator] to club_id, book (isbn) to book_id 

### Testing

### Errors
- [ ] Fix error navbar not showing correctly
- [ ] Render correct errors based on context







#

---

## Prerequisites
- Ruby `3.3.0`
- Rails `8.0.0`

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/kastanomata/PageTurner.git
   cd PageTurner
   ```

2. **Install dependencies**:
   ```bash
   bundle install
   ```

3. **Set up the database**:
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   bin/rails db:seed  # seed data is included 
   ```
---

## Configuration
**Environment Variables**

You should save your own provider information in config/credentials.yml.enc by creating your own master.key file and by using the command
```bash
$ EDITOR=vim rails credentials:edit
```
Add these lines to your credentials.yml.enc and it should easily work
```
oauth:
  provider:
    client_id: YOUR-CLIENT-ID-HERE
    client_secret: YOUR-CLIENT-SECRET-HERE
```




---

## Running the App
- **Start the server**:
  ```bash
  bin/rails server
  ```
  Visit `http://localhost:3000`.
---

## License
Distributed under the GNU General Public License. See `LICENSE` for details.

---

 
