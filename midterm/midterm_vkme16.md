
# VKM Midterm 2016

## Data

'Midterm'-mappen indeholder, ud over denne opgavebeskrivelse, en zip-fil der indeholder filen `ebdata.csv`. Filen er en data frame gemt i kommasepareret format.

`ebdata.csv` indeholder et udvalg af variable fra [Mannheim Eurobarometer Trend File 1970-2002](http://www.gesis.org/eurobarometer-data-service/search-data-access/eb-trends-trend-files/mannheim-eb-trend-file/). Trendfilen samler surveysvar fra det europæiske surveyprogram Eurobarometer i årene 1970-2002. Filen har omkring 1,1 mio. surveysvar.

Variablene `nation2`-`membrshp` i `ebdata.csv` er fra den oprindelige trendfil. Alle trendfilens variable, herunder dem der indgår i `ebdata.csv`, er beskrevet i trendfilens kodebog, som er gemt i mappen som `codebook.pdf`.

`ebdata.csv` indeholder hertil to variable:

- `cntryname`: Navnet på det land, respondenten bor i.
- `catholicpct`: Andelen af katolikker i landet, baseret på opgørelsen hos [Catholic Hierarchy](http://www.catholic-hierarchy.org/). Tallet for det enkelte land er konstant over tid.

## Opgaver

Du bedes besvare flg. opgaver:

1. Beskriv gennemsnit og standardafvigelse i opbakningen til medlemskab af EU (`membrshp`) i hvert land. I hvilke lande er opbakningen størst hhv. mindst?

1. Opstil en lineær regressionsmodel, der forklarer opbakningen til medlemskab af EU (`membrshp`) som funktion af respondentens indkomst. Begynd med en bivariat model, tilføj dernæst demografiske variable, og dernæst andre variable. Forklar fortolkningen af koefficienten, og giv et bud på hvordan ændringer i koefficienten på indkomst på tværs af modeller skal fortolkes.

1. Kan koefficienten på indkomst fortolkes kausalt? Hvorfor/hvorfor ikke? Hvilken af de modeller du opstillede under pkt. 2 er tættest på at kunne fortolkes kausalt?

1. Man kunne forestille sig at effekten af indkomst på holdninger er størst blandt individer med kortere uddannelser. Hvordan vil du teste sådan en hypotese? Test hypotesen. Visualiser hvordan den marginale effekt af indkomst varierer med uddannelsesniveau.

1. Estimer de samme modeller som under pkt. 2, men inkluder fixed effects for lande og år. Hvordan ændrer koefficienterne sig? Hvad fortæller ændringen os om sammenhængene i data?

1. Estimer modeller der belyser sammenhængen mellem andel katolikker i et land og støtten til EU-medlemskab, først som en almindelig OLS-model, dernæst en multilevelmodel. Hvad tager multilevelmodellen højde for som OLS-modellen ikke gør? Hvordan påvirker det konklusionerne?

1. Forestil dig at variablen der angiver andelen af katolikker i hvert land varierede over tid. Hvordan kunne man statistisk udnytte tidsvariationen til at styrke argumentet om en kausal effekt af katolicisme? Hvilke kritikker ville sådan en tilgang fortsat være sårbar over for?

1. Det kunne tænkes at betydningen af indkomst varierer på tværs af lande. Estimer en model der tillader koefficienten for indkomst at variere på tværs af lande. Præsenter den landespecifikke koefficient for hvert land i en tabel.

1. Det kunne tænkes at sammenhængen mellem indkomst og støtte til medlemskab er stærkere i mere katolske lande. Test hypotesen i en regressionsmodel.

1. Estimer de samme modeller som i pkt. 2, men med respondenter som er matchet på køn, alder, uddannelse, højre/venstre-placering og materialisme/postmaterialisme. Præsenter L1-balancemålet før og efter matching. Hvordan påvirker det koefficienterne? Giv et bud på hvordan forskellen påvirker dine konklusioner om effekten af indkomst. (Tip: kommandoerne kan være meget lang tid om at processere data. Du kan analysere på en stikprøve på 5 pct. af data ved at gemme et nyt dataobjekt med `sample_frac(df,.05)` fra `dplyr`-pakken).

## Aflevering

Besvarelsen skal skrives i et dokument med skrifttypen Times New Roman, skriftsstørrelse 12, halvanden linjeafstand og 2 cm margen på alle sider. **Dokumentet skal gemmes i pdf-format**.

Besvarelsen kan indeholde output kopieret direkte ind fra R's konsol, såfremt det er letlæseligt. R-output skal gengives i skrifttypen Courier New i skriftstørrrelse 10.

Afevering sker ved at uploade besvarelsen under *Assignments* på fagets side på KUnet, hvor der er oprettet en assignment under navnet *VKM Midterm*. Aflevering skal ske **senest mandag d. 17. oktober kl. 13**.

## Nyttige funktioner

- csv-filer kan indlæses i R med kommandoen `read.csv()`.
- man kan udregne deskriptiv statistik for gruppekategorier ved hjælp af `tapply()`.
- der er mange måder at sætte bestemte værdier af en variabel til missing. En nem måde er funktionen `convert_to_NA()` i `janitor`-pakken.
- pakken `stargazer` kan producere regressionstabeller for flere parallelle modeller. Brug optionen `omit="factor"` i `stargazer()`-funktionen for at udelade fixed effects fra tabellen. Optionen `type="text"` producerer output i tekstformat, der kan kopieres ind i et word-dokument.
