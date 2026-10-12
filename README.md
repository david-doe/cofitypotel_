# Étude Cofitypotel : profils de conseillers et score de bon vendeur

Thibault Perz et David Doe · encadrés par David Sestu · Master SIAD, Université de Lille · 2025-2026

Cofitypotel vend du crédit à la consommation par téléphone. Ses conseillers ont tous les mêmes objectifs, mais chacun organise son travail à sa façon : beaucoup d'appels ou des entretiens longs, des relances ou non. La direction voulait savoir s'il existe des façons de travailler bien distinctes, et lesquelles vont avec de bonnes ventes.

L'étude d'origine a été faite en R. Ce dépôt la refait en Python, de bout en bout, et ajoute un tableau de bord Power BI.

## Résultats

| | |
|---|---|
| Données | 907 observations conseiller × trimestre, 251 conseillers, 8 trimestres (2003-2004), 13 indicateurs téléphoniques |
| Typologie | 4 profils (ACP, CAH de Ward puis K-means), retrouvés à 92 % par l'analyse discriminante en validation croisée |
| Score de bon vendeur | Régression logistique à 4 variables : AUC de 0,818 sur l'échantillon test, 0,812 sur l'apprentissage |
| Croisement | Les actifs qualitatifs vendent le mieux (70 % de bons vendeurs), les spécialistes sortants le moins bien (17 %) |

| Profil | Effectif | Ce qui le distingue | Bons vendeurs |
|---|---|---|---|
| Actifs standard | 467 | Proches de la moyenne, 70 % de conseillers habilités au crédit en ligne | 47 % |
| Actifs qualitatifs | 288 | Beaucoup d'appels entrants, très peu de relances | 70 % |
| Spécialistes sortants | 139 | Grande part de relances, peu d'appels entrants | 17 % |
| Relanceurs intensifs | 13 | Très actifs sur les entrants et les sortants | trop peu nombreux pour conclure |

**Ce qui va avec de bonnes ventes** (odds ratios pour une hausse d'un écart-type) : la part du temps disponible passée en conversation (2,45), le nombre d'appels pris par jour (2,16) et par heure (1,62). Seule variable défavorable : la part des appels sortants (0,71).

**Recommandation principale** : former en priorité les spécialistes sortants à mieux convertir sur les appels entrants. Pour les augmentations de réserves, la vente se fait surtout quand le client appelle lui-même.

## Ce qui change par rapport aux rapports d'origine

En refaisant l'étude, deux problèmes de la version R sont apparus et ont été corrigés :

1. **Le temps de retrait était tronqué à 24 heures.** Il est stocké en fraction de jour dans Excel, et seule l'heure du jour était gardée. Un quart des lignes mensuelles était touché.
2. **Le tableau de croisement du rapport n°2 ne reposait pas sur la même partition que la typologie** (264 relanceurs intensifs au lieu de 13). Recalculé sur la bonne partition, le classement change : ce sont les actifs qualitatifs, et non les relanceurs, qui vendent le mieux. C'est d'ailleurs ce que disait déjà la conclusion écrite du rapport.

Le score lui-même change peu (AUC de 0,811 dans le rapport, 0,818 ici). Les groupes sont aussi moins stables que ne le disait le rapport : d'un trimestre au suivant, la moitié des conseillers change de groupe.

## Contenu du dépôt

| Dossier | Contenu |
|---|---|
| `notebooks/cofitypotel.ipynb` | Toute l'analyse, exécutée et commentée : préparation, typologie, analyse discriminante, migrations, ventes par groupe, score, croisement. |
| `figures/` | Les graphiques principaux en PNG. |
| `sorties/` | Les tables produites par le notebook (codes des conseillers anonymisés), lues par Power BI. |
| `powerbi/` | Le tableau de bord `cofitypotel.pbix`, les requêtes Power Query et les mesures DAX. |
| `donnees/` | Vide : le fichier du cours n'est pas publié (voir `donnees/LISEZMOI.md`). |

## Relancer l'analyse

1. Placer `Donnees_Cofitypotel.xls` dans `donnees/`.
2. Installer les bibliothèques et exécuter le notebook :

```bash
pip install -r requirements.txt
cd notebooks
jupyter nbconvert --to notebook --execute --inplace cofitypotel.ipynb
```

Les graines sont fixées (`random_state = 42`) : on retrouve les mêmes chiffres à chaque exécution.

Pour Power BI, ouvrir `powerbi/cofitypotel.pbix`. Si le dépôt est ailleurs sur votre disque, changer le paramètre `DossierSorties` (Transformer les données > Gérer les paramètres) pour qu'il pointe vers le dossier `sorties/`.

## Limites

- Huit trimestres et 251 conseillers, c'est court.
- Le choix de quatre groupes est un choix d'interprétation : la qualité de la classification est presque la même avec deux ou trois groupes.
- Le groupe des relanceurs intensifs (13 observations) est trop petit pour en tirer des règles.
- Le score ne vaut que pour les augmentations de réserves, et un lien statistique ne prouve pas qu'imiter un groupe ferait vendre plus.
