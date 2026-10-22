SET search_path TO
    input_{{ dag_run.conf.get('process_id', params.process_id) }}, -- Schema modelo simplificado
    output_{{ dag_run.conf.get('process_id', params.process_id) }}, -- schema modelo LADM extendido
    public;

--====================================================
-- RHC_Responsabilidad: la autoridad ambiental define la estrategia de manejo
-- Una responsabilidad por estrategia: se vincula al unico interesado o a la
-- agrupacion de sus miembros. Sin interesados no se crean responsabilidades.
-- col_rrrInteresado esta integrada en estas dos columnas del DRR por ili2pg.
--====================================================
with interesado_responsable as (
    select
        t_id as interesado,
        null::bigint as agrupacion
    from rhc_interesado
    where (select count(*) from rhc_interesado) = 1
    union all
    select
        null::bigint,
        agrupacion
    from col_miembros
    group by agrupacion
    having count(distinct interesado_rhc_interesado) > 1
)
insert into rhc_responsabilidad (
    t_basket,
    t_ili_tid,
    tipo,
    descripcion,
    interesado_rhc_interesado,
    interesado_rhc_agrupacioninteresados,
    unidad_rhc_uab_estrategiamanejoambiental,
    comienzo_vida_util_version,
    espacio_de_nombres,
    local_id
)
select
    (select t_id from output_{{ dag_run.conf.get('process_id', params.process_id) }}.t_ili2db_basket where topic = 'LADM_COL_v_1_0_0_Ext_RHC.RHC' limit 1) as t_basket,
    uuid_generate_v4() as t_ili_tid,
    'Definir_Estrategia_Manejo_Ambiental' as tipo,
    uab.nombre as descripcion,
    ir.interesado as interesado_rhc_interesado,
    ir.agrupacion as interesado_rhc_agrupacioninteresados,
    uab.t_id as unidad_rhc_uab_estrategiamanejoambiental,
    now() as comienzo_vida_util_version,
    'rhc_responsabilidad' as espacio_de_nombres,
    row_number() over (order by uab.t_id)::text as local_id
from rhc_uab_estrategiamanejoambiental uab
cross join interesado_responsable ir;
