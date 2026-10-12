# Tableau de bord Power BI : modèle et mesures

Le rapport `cofitypotel.pbix` lit les fichiers CSV produits par le notebook dans `sorties/`. Le code Power Query de chaque table est dans `requetes/`, et les mesures au format TMDL dans `mesures.tmdl`. Le chemin du dossier est un paramètre, `DossierSorties`.

## Les tables

| Table | Fichier | Une ligne = |
|---|---|---|
| `conseillers_trimestres` | `sorties/conseillers_trimestres.csv` | un conseiller (code anonymisé) sur un trimestre : groupe, score, bon vendeur, 13 indicateurs téléphoniques, ventes par jour |
| `groupes` | `sorties/groupes.csv` | un groupe comportemental, avec son nom et sa couleur |
| `indices_groupes` | `sorties/indices_groupes.csv` | un groupe × un indicateur, indice base 100 |
| `migrations` | `sorties/migrations.csv` | un passage d'un groupe à un autre entre deux trimestres |
| `odds_ratios` | `sorties/odds_ratios.csv` | une variable du modèle de score |

Relation : `groupes[groupe]` 1 → * `conseillers_trimestres[groupe]`.

Les CSV utilisent `;` comme séparateur et `,` comme décimale (paramètres régionaux français).

## Les mesures DAX

```dax
Observations = COUNTROWS ( conseillers_trimestres )

Conseillers = DISTINCTCOUNT ( conseillers_trimestres[code_op] )

% bons vendeurs = AVERAGE ( conseillers_trimestres[bon_vendeur] )

Score moyen = AVERAGE ( conseillers_trimestres[score] )

% HML =
DIVIDE (
    CALCULATE ( [Observations], conseillers_trimestres[metier] = "HML" ),
    [Observations]
)

Augmentations par jour = AVERAGE ( conseillers_trimestres[aug_fl_nb_j] )

CA par jour = AVERAGE ( conseillers_trimestres[ca_total_j] )

Part de sortants = AVERAGE ( conseillers_trimestres[part_sortant_conv_w] )

Appels pris par jour = AVERAGE ( conseillers_trimestres[appels_pris_j_w] )
```

## Les pages

1. **Profils** : part de bons vendeurs par groupe, nombre d'observations par groupe et par métier, indices base 100 des 13 indicateurs (matrice colorée), chiffres clés et segment HML / NHML.
2. **Score et suivi** : odds ratios du modèle, score moyen par groupe, part de bons vendeurs par trimestre et par groupe, matrice des passages d'un groupe à l'autre.
