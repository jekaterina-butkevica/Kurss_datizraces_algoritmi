Asociācijas
================
Jekaterīna Butkeviča,
2025. gads 01. oktobris

## Uzdevums

Par veiktajiem eksperimentiem uzrakstiet īsas atskaites ar “lietišķajiem
pierādījumiem”, kas apliecinātu, ka eksperimenti patiešām ir veikti.

1)  Atrodiet internetā kādu interesantu datu kopu, kurā var meklēt
    asociācijas.
    1)  Aprakstiet, kā Jūs sapratāt šos datus.
    2)  Padarbiniet Apriori algoritmu ar parametru vērtībām, kas liekas
        piemērotas.
    3)  Kādas patiesi interesantas asociācijas atradāt? Ar kādam
        parametru vērtībām tas izdevās.
    4)  Cik lielas un cik daudz biežo kopu (frequent itemsets) algoritms
        atrada un izmantoja?
2)  (neobligāts) Atkārtojiet savus eksperimentus ar izvēlēto datu kopu,
    izmantojot algoritmu FPGrowth vai jebkuru citu asociāciju meklēšanas
    algoritmu. Vai rezultāts iznāca interesantāks nekā Apriori?

## Pirmais uzdevums - “Apriori” algoritms

### 1.1. Datu kopa

Analīzēju datukopu `Groceries` no R pakotnes “arules” (Hahsler et al.,
2006). Šī datu kopa satur 1 mēneša (30 dienu) īstu tirdzniecības vietu
transakciju datus no tipiska vietējā pārtikas veikala. Datu kopā ir 9835
tranzakcijas, un preces ir sadalītas 169 kategorijās.

#### Datu sagatavošana “Apriori” algoritmam

Dati sākotnēji bija `TRUE/FALSE` kodējumā, tos pārveidoju uz `1/0`.
Tāpat pārliecinājos, ka visi mainīgie ir faktoru tipa, jo to pieprasa
WEKA. Datu kopu saglabāju WEKA lasāmā formātā – .arff.

Un tā kā, izmēģinot “Apriori” algoritmu uz pilniem datiem vairākas
reizes, visos gadījumos WEKA darbība tika pārtraukta atmiņas pārpildes
dēļ, es samazināju datu kopas rindu skaitu uz pusi, rindas izvēloties
nejauši. Tomēr tas nepalīdzēja, un bija nepieciešams samazināt arī
kolonnu skaitu. Gala analīzei tika izmantota datu kopa, kas sastāv no
4917 rindām un 25 kolonnām. Dati tika sagatavoti, izmantojot šādas R
rindas:

``` r
data("Groceries")

m <- as(Groceries, "matrix")
m_num <- ifelse(m, 1, 0)

set.seed(124)                       # lai rezultāts būtu reproducējams
m_num_small <- m_num[sample(nrow(m_num), nrow(m_num) *0.5),]

set.seed(344)  # reproducējamība
cols_keep <- sample(ncol(m_num_small), 25)
m_num_small <- m_num_small[, cols_keep]

# Pārveido katru kolonnu par faktoru
m_fact <- as.data.frame(lapply(as.data.frame(m_num_small), factor))

write.arff(m_fact, file = "./Data/Groceries_05_25.arff")
```

### 1.2., 1.3. “Apriori” algoritma iestatījumi un iegūtās asociācijas

“Apriori” algoritmam tika pielietoti sekojoši iestatījumi:

- lowerBoundMinSupport = 0.7

- metricType = Confidence

- minMetric = 0.9

Iegūtais rezultāts ir šāds:

    Apriori
    =======

    Minimum support: 0.95 (4671 instances)
    Minimum metric <confidence>: 0.9
    Number of cycles performed: 1


    Best rules found:

     1. rice=0 4878 ==> decalcifier=0 4875    <conf:(1)> lift:(1) lev:(0) [0] conv:(0.99)
     2. rubbing.alcohol=0 rice=0 4873 ==> decalcifier=0 4870    <conf:(1)> lift:(1) lev:(0) [0] conv:(0.99)
     3. honey=0 rice=0 4869 ==> decalcifier=0 4866    <conf:(1)> lift:(1) lev:(0) [0] conv:(0.99)
     4. cooking.chocolate=0 rice=0 4865 ==> decalcifier=0 4862    <conf:(1)> lift:(1) lev:(0) [0] conv:(0.99)
     5. rice=0 cookware=0 4864 ==> decalcifier=0 4861    <conf:(1)> lift:(1) lev:(0) [0] conv:(0.99)
     6. honey=0 rubbing.alcohol=0 rice=0 4864 ==> decalcifier=0 4861    <conf:(1)> lift:(1) lev:(0) [0] conv:(0.99)
     7. bathroom.cleaner=0 rice=0 4860 ==> decalcifier=0 4857    <conf:(1)> lift:(1) lev:(0) [0] conv:(0.99)
     8. cooking.chocolate=0 rubbing.alcohol=0 rice=0 4860 ==> decalcifier=0 4857    <conf:(1)> lift:(1) lev:(0) [0] conv:(0.99)
     9. nuts.prunes=0 rice=0 4859 ==> decalcifier=0 4856    <conf:(1)> lift:(1) lev:(0) [0] conv:(0.99)
    10. rubbing.alcohol=0 rice=0 cookware=0 4859 ==> decalcifier=0 4856    <conf:(1)> lift:(1) lev:(0) [0] conv:(0.99)

Iegūtais rezultāts atšķiras no sagaidītā. Neskatoties uz minimālo
atbalsta slieksni, kas tika iestatīts uz 0,7, programma patvaļīgi to
palielināja līdz 0,95. Kopā ar faktu, ka visas piedāvātās asociācijas
balstās uz vērtību “0”, t.i., produkta “nenopirkšanu”, tas norāda, ka
datos ir ļoti daudz produktu, kas netiek iegādāti 95% gadījumu.
Piedāvātajās kombinācijās iekļautie produkti šķietami ir izvēlēti
nejauši (kas, protams, nav patiesība – tie ir atlasīti, balstoties uz
neparādīšanās kombināciju frekvencēm datu kopā), taču šāda informācija
nav analītiski noderīga un, manuprāt, lielā mērā datu rašanās brīdī ir
pakļautā nejaušības ietekmēi. Tādēļ neuzskatu par lietderīgu interpretēt
iegūtās asociācijas.

Mēģināju palaist “Apriori” algoritmu vēlreiz, šoreiz ievērojami
samazinot minimālā atbalsta līmeni, taču rezultāts nemainījās.

Nākamajā mēģinājumā “Apriori” algoritmu palaidu, kā galveno metriku
izmantojot “Lift”. Aprēķinu laiks ievērojami pieauga, un pēc 80 minūšu
gaidīšanas procesu nācās pārtraukt, tādēļ rezultāts netika saņemts.

Manuprāt, problēma lielā mērā ir saistīta ar manis izmantoto datu kopas
“samazināšanu”. Ja gadījumu, kad produkts tiek nopirkts (vērtība “1”),
jau sākotnēji ir maz, tad, divkārt samazinot rindu skaitu, pirkšanas
gadījumu skaits kļuva pavisam niecīgs. Turklāt, izslēdzot lielu daļu
kolonnu, vairs nebija iespējams izsekot atkārtojošās pirkšanas
kombinācijām, jo palika tikai daži nejauši atlasīti produkti. Tomēr
citādā veidā palaist “Apriori” algoritmu man neizdevās.

### 1.4. Biežu un lielu kopu skaits

Atgriežoties pie pirmā iegūtā rezultāta, kur tika izmantota metrika
Confidence, tika iegūts šāds biežo kopu sadalījums:

    Generated sets of large itemsets:

    Size of set of large itemsets L(1): 19

    Size of set of large itemsets L(2): 170

    Size of set of large itemsets L(3): 910

    Size of set of large itemsets L(4): 3158

    Size of set of large itemsets L(5): 7401

    Size of set of large itemsets L(6): 11646

    Size of set of large itemsets L(7): 12198

    Size of set of large itemsets L(8): 8498

    Size of set of large itemsets L(9): 3963

    Size of set of large itemsets L(10): 1206

    Size of set of large itemsets L(11): 204

    Size of set of large itemsets L(12): 13

L(1) - 19 kopas: Tas nozīmē, ka 19 no 25 produktiem ir bieži
individuāli. Ņemot vērā, ka visi asociāciju noteikumi balstāš uz vērtību
“0”, tas nozīmē, ka 19 produkti netiek pirkti vismaz 95% gadījumu. (Jo
izmantotais minimalais atbalsts ir 0,95).

L(2) - 170 kopas: Lai divu elementu kopa būtu bieža (A=0 un B=0), abiem
produktiem jābūt biežiem (kas ir, L(1)) un abiem produktiem jābūt
nenopirktiem vienlaicīgi vismaz 95% gadījumu. Kopu skaits, ko var
izveidot ar 19 elementiem ir:$$\frac{19 \times 18}{2} = 171$$

Tātad, no 171 potenciālās 2-elementu kopas 170 atbilst 95% atbalsta
slieksnim. Tas nozīmē, ka tikai viena divu produktu kombinācija nav
bieža (t.i., vismaz 5% gadījumu abi produkti tika nopirkti kopā, vai
viens tika nopirkts, un otrs nē).

Rezultātā iegūst ļoti daudz biežu lielāku kopu. Visticamāk tas saistīts
ar pašu datu struktūru – pārsātinājumu ar nullēm. Citiem vārdiem,
gandrīz visi produkti netiek pirkti gandrīz nekad.

**Secinājums:** Es izvēlējos neveiksmīgu datu kopu, kuras analīzei man
nepietika datorresursu, un ar samazināto versiju iztikt nesanāca.

## Otrais uzdevums – algoritms “FPGrowth”

Ar “Apriori” algoritmu izmantoto datu kopu neizdevās apstrādāt ar
“FPGrowth” algoritmu. Tika iegūts šāds ziņojums:

    === Associator model (full training set) ===

    No rules found!

Tad, atceroties, ka šis algoritms efektīvāk izmanto atmiņas resursus un
neveic liekus aprēķinus, es nolēmu to palaist ar pilno (oriģinālo) datu
kopu.

### Datu sagatavošana

Vienkārši saglabāju pilnu datu kopu pēc pirmajā uzdevumā aprakstīto
sagatavošanas soļu veikšanas.

``` r
fact <- as.data.frame(lapply(as.data.frame(m_num), factor))
write.arff(m_fact, file = "./Data/Groceries_full.arff")
```

### Algoritms “FPGrowth”

Algoritms “FPGrowth” tika palaists ar sekojošiem iestatījumiem:

- lowerBoundMinSupport = 0.05

- metricType = Lift

- minMetric = 0.2

Ar augstāko atbalsta slieksni asociācijas noteikumi netika atrasti.

Šajā gadījumā, manuprāt, vispiemērotākā ir lift metrika, jo tā lielā
mērā novērš nejaušības ietekmi, aprēķinot, cik reizes biežāk tiek pirkts
B, ja tiek pirkts A, salīdzinot ar to, kā tas būtu gaidāms nejauši.

Iegūtais rezultāts ir šāds:

    === Associator model (full training set) ===

    FPGrowth found 6 rules (displaying top 6)

    1. [whole.milk=1]: 2513 ==> [yogurt=1]: 551   conf:(0.22) <lift:(1.57)> lev:(0.02) conv:(1.1) 
    2. [yogurt=1]: 1372 ==> [whole.milk=1]: 551   conf:(0.4) <lift:(1.57)> lev:(0.02) conv:(1.24) 
    3. [whole.milk=1]: 2513 ==> [other.vegetables=1]: 736   conf:(0.29) <lift:(1.51)> lev:(0.03) conv:(1.14) 
    4. [other.vegetables=1]: 1903 ==> [whole.milk=1]: 736   conf:(0.39) <lift:(1.51)> lev:(0.03) conv:(1.21) 
    5. [whole.milk=1]: 2513 ==> [rolls.buns=1]: 557   conf:(0.22) <lift:(1.21)> lev:(0.01) conv:(1.05) 
    6. [rolls.buns=1]: 1809 ==> [whole.milk=1]: 557   conf:(0.31) <lift:(1.21)> lev:(0.01) conv:(1.07) 

Atšķirībā no “Apriori” algoritma, “FPGrowth” uzreiz fokusējas uz
nopirktajām precēm (vērtība = 1). Lai iegūtu jebkādu rezultātu, bija
jāizmanto ļoti zems atbalsta slieksnis, jo dati ir pārsātināti ar
nullēm. Minimālais atbalsta slieksnis tika iestatīts uz 5% (0,05), kas
nozīmē, ka elementu kopai jāparādās vismaz 9835\*0.05≈492 darījumos, lai
tā tiktu rādīta. Tas norāda, ka pat pilnajos datos gadījumu, kad
konkrēta prece tika nopirkta, ir ļoti maz.

Asociācijas tika veidotas pa pāriem:

Pāris 1. un 2.: Piens un jogurts - stiprākas asociācijas:

(whole.milk=1⇒yogurt=1) 22% no pircējiem, kas pērk pilnpienu, nopērk arī
jogurtu. Jogurts tiek pirkts 1.57 reizes biežāk kopā ar pienu, nekā tas
notiktu nejauši. Šī ir spēcīga pozitīva saistība.

(yogurt=1⇒whole.milk=1) 40% no pircējiem, kas pērk jogurtu, nopērk arī
pienu. Interesanti, ka pilnpiena pircēju bāze ir lielāka (2513
darījumi), bet jogurta pircējiem ir lielāka tendence iekļaut savā
pirkumā pienu.

Pāris 3. un 4. whole.milk=1⇒other.vegetables=1: Lift (1.51): Dārzeņi
tiek pirkti 1.51 reizi biežāk kopā ar pienu utt..

**Secinājums:** Manuprāt, šis algoritms ir daudz piemērotāks
eksistējošiem datiem, jo asociācijas, kas veidotas, pamatojoties uz
preces nopirkšanas faktu, ir daudz jēgpilnākas nekā asociācijas, kas
balstītas uz to “nenopirkšanu”.
