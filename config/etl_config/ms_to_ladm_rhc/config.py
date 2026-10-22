# ETL INFO
DAG_NAME = 'ms_to_ladm_rhc_dag'
DAG_DESCRIPTION = 'ETL que transforma los datos del modelo simplificado al modelo extendido LADM_COL del OTL de rondas hídricas acotadas.'
ETL_NAME = 'ms_to_ladm_rhc'
ETL_VERSION = '0.1'
ETL_TAGS = [ETL_NAME, ETL_VERSION, "ETL", "LADM_COL", "OTL", "Rondas hídricas acotadas"]


# MODELS INFO
SIMPLIFIED_MODEL_NAME = 'MS_RondasHidricas_V0_1'
LADM_COL_MODEL_NAME = 'LADM_COL_v_1_0_0_Ext_RHC'

# XTF de ejemplo modelo simplificado

SIMPLIFIED_MODEL_EXAMPLE_XTF = 'https://terrainfo.nyc3.cdn.digitaloceanspaces.com/OTLS/ms_rhc.xtf'

# ===========================================================================
# ETL WORKFLOW
#
# Lista de SQL que deben ser ejecutados para la transformación de datos
# del modelo simplificado al modelo extendido LADM_COL.
# ===========================================================================

ETL_TASKS = [
    (
        "preparar_estructura_etl",
        "ms_to_ladm_rhc/sql/000_preparar_estructura_etl.sql",
    ),
    (
        "migrar_interesados",
        "ms_to_ladm_rhc/sql/010_migrar_interesados.sql",
    ),
    (
        "migrar_fuentes_administrativas",
        "ms_to_ladm_rhc/sql/020_migrar_fuentes_administrativas.sql",
    ),
    (
        "migrar_unidad_administrativa",
        "ms_to_ladm_rhc/sql/030_migrar_unidad_administrativa.sql",
    ),
    (
        "migrar_unidad_espacial",
        "ms_to_ladm_rhc/sql/040_migrar_unidad_espacial.sql",
    ),
    (
        "diligenciar_relacion_entre_unidad_administrativa_y_espacial",
        "ms_to_ladm_rhc/sql/050_diligenciar_relacion_entre_unidad_administrativa_y_espacial.sql",
    ),
    (
        "crear_estructura_col_area_valor",
        "ms_to_ladm_rhc/sql/060_crear_estructura_col_area_valor.sql",
    ),
    (
        "crear_agrupacion_interesados",
        "ms_to_ladm_rhc/sql/070_crear_agrupacion_interesados.sql",
    ),
    (
        "crear_derechos",
        "ms_to_ladm_rhc/sql/075_crear_derechos.sql",
    ),
    (
        "crear_responsabilidades",
        "ms_to_ladm_rhc/sql/080_crear_responsabilidades.sql",
    ),
    (
        "diligenciar_relacion_col_rrrfuente",
        "ms_to_ladm_rhc/sql/090_diligenciar_relacion_col_rrrfuente.sql",
    ),
]
