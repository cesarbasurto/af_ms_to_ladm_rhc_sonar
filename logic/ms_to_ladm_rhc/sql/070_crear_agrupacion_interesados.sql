SET search_path TO
    input_{{ dag_run.conf.get('process_id', params.process_id) }}, -- Schema modelo simplificado
    output_{{ dag_run.conf.get('process_id', params.process_id) }}, -- schema modelo LADM extendido
    public;

--====================================================
-- Agrupacion de autoridades ambientales: se crea solo si hay mas de un interesado.
-- Los miembros son los interesados reales importados del modelo simplificado.
--====================================================
with nueva_agrupacion as (
    insert into rhc_agrupacioninteresados (
        t_basket,
        t_ili_tid,
        tipo,
        nombre,
        tipo_interesado,
        comienzo_vida_util_version,
        espacio_de_nombres,
        local_id
    )
    select
        (select t_id from output_{{ dag_run.conf.get('process_id', params.process_id) }}.t_ili2db_basket where topic = 'LADM_COL_v_1_0_0_Ext_RHC.RHC' limit 1) as t_basket,
        uuid_generate_v4() as t_ili_tid,
        'Grupo_Empresarial' as tipo,
        'Comisión conjunta de ordenación de rondas hídricas' as nombre,
        'Persona_Juridica' as tipo_interesado,
        now() as comienzo_vida_util_version,
        'rhc_agrupacioninteresados' as espacio_de_nombres,
        '1' as local_id
    where (select count(*) from rhc_interesado) > 1
    returning t_id, t_basket
)
insert into col_miembros (
    t_basket,
    interesado_rhc_interesado,
    agrupacion
)
select
    g.t_basket as t_basket,
    i.t_id as interesado_rhc_interesado,
    g.t_id as agrupacion
from nueva_agrupacion g
cross join rhc_interesado i;
