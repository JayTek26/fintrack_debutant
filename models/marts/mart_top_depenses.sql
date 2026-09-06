with depenses_par_categorie as (

    select
        compte_id,
        nom_client,
        categorie_id,
        nom_categorie,
        sum(abs(montant_signe)) as total

    from {{ ref('fct_transactions') }}
    where montant_signe < 0
    group by compte_id, nom_client, categorie_id, nom_categorie

),

classement as (

    select
        *,
        row_number() over (
            partition by compte_id order by total desc
        ) as rang

    from depenses_par_categorie

)

select
    compte_id,
    nom_client,
    categorie_id,
    nom_categorie,
    total,
    rang
from classement
where rang <= 3
order by compte_id, rang
