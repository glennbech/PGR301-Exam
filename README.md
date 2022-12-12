# DevOps med gode intensjoner

## Del 1

### Utfordringer med Shopifly
Dagens systemutviklingsprosess har flere utfordringer som fører til brudd på DevOps prinsipper som *flow* og *feedback* vet å
ha manuelle steg, uferdige prosjekter, og ingen branch protection. 

Det er flere steder i koden man kan finne prosjekter som er påbegynt, men
som har blitt forlatt på grunn av vansklighetsgrad. Dette sørger for at man har flere prosjekter samtidig, og at man bryter
*Limit work in process (WIP)*. Dette fører til at utvikleren må endre kontekst mellom prosjekter og bruke tid på å sette seg inn i det
igjen.

Etter som at selskapet har ansatt testere som må gå gjennom og godkjenne alle leveranser, skaper dette flere *handoffs* enn nødvendig.
Dette kan føre til mer arbeid som blir puttet på vent, og det tar lenger tid før produktet er ute i produksjon. Et annet problem er at
konteksten prosjektet hadde, kan bli endret om det er for mange handoffs.

Man kan gjøre pull requests til main uten noen sjekker. Ingen tester eller godkjenning av kode før merge. Dette fører til lite *feedback*
noe som er et viktig prinsipp i DevOps. Det å jobbe trygt i et komplekst system, og være sikker på at errorer blir oppdaget lenge før
de skaper katastrofer er essensielt.

### Problemet med mindre hyppig, mer kontrollert og QA funksjonaliteter
Som nevnt tidligere skaper det flere handoffs om en kode går fra en person til en annen. Dette fører til tregere utvikling, og
resultatet kan ende opp som noe annet. Det å holde på kode over lenger tid før release kan også skape flere utfordringer for
utvikleren. Motivasjonen er ikke like høy når man må sitte med samme problem i flere uker, og etter hvert sitter man kanskje med
flere prosjekter samtidig, som fører til mindre oversikt og overskudd.

Det er viktig å oppdage problemer under veis i utviklingen slik at man ikke møter på alle ved release. Derfor er feedback og
feedforward loops viktig å implementere slik at man finner veilen umiddelbart og kan handle. Dette vil føre til at det er mindre feil
under release av ny funksjonalitet.

### Gevinster ved DevOps
Når et team overleverer kode til et annet er det største problemet feilkommunikasjon og forvirring, samt tidsforbruk. Et nytt team
er nødt til å sette seg inn i det noen andre har laget. Dette fører til timer med unødvendig arbeid, før man
faktisk kan begynne å gjøre noe fornuftig. I tillegg kan man mistolke og misforstå. Da fører man kanskje produktet i en annen retning
enn det som var ment. For å unngå slike problemer må utviklere også drive drift. På denne måten vet man nøyaktig hva koden gjør
og man må ikke bruke noe mer tid på å sette seg inn i det. Dette vil skape mye bedre flyt i arbeidet og produktet blir ferdig raskere.

### Hyppige leveranser
En utfordring med å release kode ofte er at man får merge-konflikter, som innebærer at flere har kode som ikke spiller på lag. I tillegg
kan man ha skrevet to forskjellige logikker som gjør at produktet ikke fungerer når disse settes sammen. En annen utfordring er at
koden man har skrevet ikke er testet før push og når den skal tas i bruk i produksjon, er det bugs og feil.

Her kommer Continuous Integration (CI) og Continuous Delivery (CD) inn.
CI sørger for continuous testing slik at det blir raskere bug-fiksing, bedre sammarbeid, og kodekvalitet.
CD sørger for at det nye produktet blir automatisk testet og sendt tilbake om det er nødvedige bug-fikser. Deretter er den automatisk
retestet og pushet. Så kan man release til produksjonsmiljøet. CD sørger altså for at koden som blir sendt til produksjon er
bug-free, effektiv, fungerende og pålitelig.


## Del 2

### Oppgave 1 / 2

Når det står:
`Start med å få workflowen til å kjøre når det lages en pull request, og på hver push til main branch`
var jeg usikker på om det var ment at pull request er uavhengig av branch, mens push er kun på main.
Eller om det er ment som at pull og push skal skje kun på main. Derfor har jeg tatt utgangspunkt i det første.
Kun push på main, mens pull fra alle branches.

Når det så videre står:
`Workflowen skal kompilere javakoden og kjøre enhetstester på hver eneste push, uavhengig av branch`
har jeg fortsatt tatt utgangspunkt i at pull allerede skjer på alle branches, så derfor kan både push og pull skje
uavhengig av branch.

### Oppgave 3

For å opprette *branch protection* og *status check* på main må man:
* Gå til Settings -> Branches (Under *Code and automation*).
* Under *Branch Protection Rules* legg til ny regel (*Add rule*).
* Det er viktig at *Branch name pattern* heter det samme som head-branch. F.eks *main* eller *master*.
* For å sette opp pull request med minst en godkjenning, må man huke av *Require a pull request before merging*.
* Det er viktig at *Require approvals* også er checked og at *Required number of approvals before merging* er 1 eller flere.
* For status bekreftelse og at koden er verifisert av GitHub Actions må man checke av *Require status checks to pass before merging*,
  og søke etter *build* under *Status checks that are required*.
* Til slutt velger man *Do not allow bypassing the above settings* og lagrer.


## Del 3

### Oppgave 1

I filen `docker.yml` under `jobs.builds.steps` med *name: Login to Docker Hub* er docker hub brukernavn og passord satt som "secrets".
Dette er for at ingen andre skal kunne se din private informasjon. Derfor under Settings -> Secrets -> Actions i GitHub må man legge til to
nye *Repository secrets*. Uten disse, klarer ikke workflowen å kjøre og den vil feile. Navnet må matche det navnet som står etter "secrets" i docker.yml filen. 
Passordet skal være en Docker Hub access token. For å få denne, må man gå til https://hub.docker.com/settings/security og legge til en ny *Access Token*.

### Oppgave 3

I `docker.yml` skal man autentisere docker mot AWS ECR. For å få til dette, bruker man en ID og en KEY. Disse oppretter man i AWS.

* Først søker man etter "IAM" i AWS.
* Under "Quick Links" på høyre side finner man "My security credentials".
* Under "Access keys for CLI, SDK, & API access" kan man velge å lage en access key.
* Gå til Settings -> Secrets -> Actions i GitHub og legg til ID og secret KEY. Bruk navnene som står etter "secrets" i `docker.yml`.


## Del 5

### Oppgave 1

`provider.tf` mangler en 'backend'-blokk som spesifiserer hvor tilstanden til terraform-konfigurasjonen skal lagres. Denne skal lagres
i en 'S3'-bucket. Uten denne .state-filen, vet ikke terraform noe om infrastruktur-tilstanden.

### Oppgave 2

Når det står:
`Fullfør workflow filen cloudwatch_dashboard.yml filen slik at apply bare bli kjørt på push mot main branch, og terraform plan
på når det lages en Pull request`
tar jeg utgangspunkt i at apply kun kjøres på main, mens plan kjøres uavhengig av branch etter som det ikke står 'pull request
mot main branch'.