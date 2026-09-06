{% snapshot snap_comptes %}

{{
    config(
        target_schema='SNAPSHOTS',
        unique_key='compte_id',
        strategy='check',
        check_cols=['statut']
    )
}}

select
    id as compte_id,
    nom_client,
    type_compte,
    statut,
    date_ouverture,
    solde_initial
from {{ source('fintrack_raw', 'raw_comptes') }}

{% endsnapshot %}
