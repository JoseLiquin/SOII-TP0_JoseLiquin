#!/usr/bin/env bash
# ==============================================================================
# SISTEMAS OPERATIVOS II - 2026
# SUITE DE PRUEBAS AUTOMATIZADAS - TRABAJO PRÁCTICO N° 0
# ==============================================================================

# Colores para terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

PUNTAJE_TOTAL=0
MAX_PUNTAJE=100
FALLOS=0

imprimir_banner() {
    echo -e "${BLUE}================================================================${NC}"
    echo -e "${BOLD}       SISTEMAS OPERATIVOS II - EVALUACIÓN AUTOMÁTICA TP 0       ${NC}"
    echo -e "${BLUE}================================================================${NC}"
}

# Cargar script del alumno
if [ ! -f "ejercicios.sh" ]; then
    echo -e "${RED}[ERROR CRÍTICO] No se encontró el archivo 'ejercicios.sh'.${NC}"
    exit 1
fi

source ./ejercicios.sh

# Crear directorio de soluciones limpio si no existe
mkdir -p soluciones

# ------------------------------------------------------------------------------
# Test Ejercicio 1 (20 pts)
# ------------------------------------------------------------------------------
test_ejercicio1() {
    echo -e "\n${BOLD}Verificando Ejercicio 1: Estructura de Directorios...${NC}"
    ejercicio1_estructura > /dev/null 2>&1
    
    local error=0
    
    if [ ! -d "soluciones/entorno/config" ]; then
        echo -e "  ${RED}✗ Falta el directorio 'soluciones/entorno/config/'${NC}"
        error=1
    fi
    if [ ! -d "soluciones/entorno/logs" ]; then
        echo -e "  ${RED}✗ Falta el directorio 'soluciones/entorno/logs/'${NC}"
        error=1
    fi
    if [ ! -d "soluciones/entorno/backup" ]; then
        echo -e "  ${RED}✗ Falta el directorio 'soluciones/entorno/backup/'${NC}"
        error=1
    fi
    if [ ! -f "soluciones/entorno/config/app.conf" ]; then
        echo -e "  ${RED}✗ Falta el archivo 'soluciones/entorno/config/app.conf'${NC}"
        error=1
    fi
    if [ ! -f "soluciones/entorno/config/version.txt" ]; then
        echo -e "  ${RED}✗ Falta el archivo 'soluciones/entorno/config/version.txt'${NC}"
        error=1
    else
        local contenido
        contenido=$(cat soluciones/entorno/config/version.txt | tr -d '\r\n')
        if [[ "$contenido" != *"Sistemas Operativos II - 2026"* ]]; then
            echo -e "  ${RED}✗ El contenido de 'version.txt' es incorrecto. Se esperaba: 'Sistemas Operativos II - 2026'${NC}"
            error=1
        fi
    fi
    
    if [ $error -eq 0 ]; then
        echo -e "  ${GREEN}✓ [PASS] Ejercicio 1 completado correctamente (+20 Pts)${NC}"
        PUNTAJE_TOTAL=$((PUNTAJE_TOTAL + 20))
    else
        echo -e "  ${RED}✗ [FAIL] Ejercicio 1 falló (+0 Pts)${NC}"
        FALLOS=$((FALLOS + 1))
    fi
}

# ------------------------------------------------------------------------------
# Test Ejercicio 2 (20 pts)
# ------------------------------------------------------------------------------
test_ejercicio2() {
    echo -e "\n${BOLD}Verificando Ejercicio 2: Redirecciones y Conteo...${NC}"
    ejercicio2_redirecciones > /dev/null 2>&1
    
    local error=0
    
    if [ ! -f "soluciones/primeros_15.log" ]; then
        echo -e "  ${RED}✗ No se generó 'soluciones/primeros_15.log'${NC}"
        error=1
    else
        local lineas_15
        lineas_15=$(wc -l < soluciones/primeros_15.log | tr -d ' ')
        if [ "$lineas_15" -ne 15 ]; then
            echo -e "  ${RED}✗ 'soluciones/primeros_15.log' tiene $lineas_15 líneas en lugar de 15.${NC}"
            error=1
        fi
    fi
    
    if [ ! -f "soluciones/total_lineas.txt" ]; then
        echo -e "  ${RED}✗ No se generó 'soluciones/total_lineas.txt'${NC}"
        error=1
    else
        local num_lineas
        num_lineas=$(cat soluciones/total_lineas.txt | tr -d ' \r\n\t')
        if [ "$num_lineas" -ne 20 ]; then
            echo -e "  ${RED}✗ El archivo 'total_lineas.txt' contiene '$num_lineas'. Se esperaba el número '20'.${NC}"
            echo -e "    ${YELLOW}Consejo: Use 'wc -l < datos/servidores.log' o 'cat ... | wc -l' para evitar imprimir el nombre del archivo.${NC}"
            error=1
        fi
    fi
    
    if [ $error -eq 0 ]; then
        echo -e "  ${GREEN}✓ [PASS] Ejercicio 2 completado correctamente (+20 Pts)${NC}"
        PUNTAJE_TOTAL=$((PUNTAJE_TOTAL + 20))
    else
        echo -e "  ${RED}✗ [FAIL] Ejercicio 2 falló (+0 Pts)${NC}"
        FALLOS=$((FALLOS + 1))
    fi
}

# ------------------------------------------------------------------------------
# Test Ejercicio 3 (20 pts)
# ------------------------------------------------------------------------------
test_ejercicio3() {
    echo -e "\n${BOLD}Verificando Ejercicio 3: Filtro de IPs con ERROR (grep, cut, sort)...${NC}"
    ejercicio3_tuberias > /dev/null 2>&1
    
    local error=0
    local esperado="192.168.1.10
192.168.1.120
192.168.1.50
192.168.1.99"
    
    if [ ! -f "soluciones/ips_con_error.txt" ]; then
        echo -e "  ${RED}✗ No se generó 'soluciones/ips_con_error.txt'${NC}"
        error=1
    else
        local obtenido
        obtenido=$(cat soluciones/ips_con_error.txt | sed '/^[[:space:]]*$/d' | tr -d '\r')
        if [ "$obtenido" != "$esperado" ]; then
            echo -e "  ${RED}✗ Las IPs obtenidas no coinciden con las esperadas.${NC}"
            echo -e "    ${YELLOW}Esperado:${NC}\n$esperado"
            echo -e "    ${YELLOW}Obtenido:${NC}\n$obtenido"
            error=1
        fi
    fi
    
    if [ $error -eq 0 ]; then
        echo -e "  ${GREEN}✓ [PASS] Ejercicio 3 completado correctamente (+20 Pts)${NC}"
        PUNTAJE_TOTAL=$((PUNTAJE_TOTAL + 20))
    else
        echo -e "  ${RED}✗ [FAIL] Ejercicio 3 falló (+0 Pts)${NC}"
        FALLOS=$((FALLOS + 1))
    fi
}

# ------------------------------------------------------------------------------
# Test Ejercicio 4 (20 pts)
# ------------------------------------------------------------------------------
test_ejercicio4() {
    echo -e "\n${BOLD}Verificando Ejercicio 4: Filtrado y ordenamiento de CSV...${NC}"
    ejercicio4_usuarios > /dev/null 2>&1
    
    local error=0
    local esperado="Carlos Perez
Esteban Diaz
Gonzalo Benitez
Mariano Romero
Martin Rodriguez"
    
    if [ ! -f "soluciones/usuarios_sistemas_activos.txt" ]; then
        echo -e "  ${RED}✗ No se generó 'soluciones/usuarios_sistemas_activos.txt'${NC}"
        error=1
    else
        local obtenido
        obtenido=$(cat soluciones/usuarios_sistemas_activos.txt | sed '/^[[:space:]]*$/d' | tr -d '\r')
        if [ "$obtenido" != "$esperado" ]; then
            echo -e "  ${RED}✗ La lista de usuarios activos de Sistemas no coincide.${NC}"
            echo -e "    ${YELLOW}Esperado:${NC}\n$esperado"
            echo -e "    ${YELLOW}Obtenido:${NC}\n$obtenido"
            error=1
        fi
    fi
    
    if [ $error -eq 0 ]; then
        echo -e "  ${GREEN}✓ [PASS] Ejercicio 4 completado correctamente (+20 Pts)${NC}"
        PUNTAJE_TOTAL=$((PUNTAJE_TOTAL + 20))
    else
        echo -e "  ${RED}✗ [FAIL] Ejercicio 4 falló (+0 Pts)${NC}"
        FALLOS=$((FALLOS + 1))
    fi
}

# ------------------------------------------------------------------------------
# Test Ejercicio 5 (20 pts)
# ------------------------------------------------------------------------------
test_ejercicio5() {
    echo -e "\n${BOLD}Verificando Ejercicio 5: Script de reporte y permisos...${NC}"
    ejercicio5_script_reporte > /dev/null 2>&1
    
    local error=0
    local script="soluciones/generar_reporte.sh"
    
    if [ ! -f "$script" ]; then
        echo -e "  ${RED}✗ No se encontró el script '$script'${NC}"
        error=1
    else
        # Verificar permisos de ejecución
        if [ ! -x "$script" ]; then
            echo -e "  ${RED}✗ El archivo '$script' no tiene permisos de ejecución (chmod +x).${NC}"
            error=1
        fi
        
        # Ejecutar el script y analizar salida
        local salida
        salida=$("$script" 2>/dev/null)
        
        if [[ "$salida" != *"=== REPORTE DEL SISTEMA ==="* ]]; then
            echo -e "  ${RED}✗ El script no imprime la cabecera '=== REPORTE DEL SISTEMA ==='${NC}"
            error=1
        fi
        if [[ "$salida" != *"Usuario:"* ]]; then
            echo -e "  ${RED}✗ El script no imprime el campo 'Usuario:'${NC}"
            error=1
        fi
    fi
    
    if [ $error -eq 0 ]; then
        echo -e "  ${GREEN}✓ [PASS] Ejercicio 5 completado correctamente (+20 Pts)${NC}"
        PUNTAJE_TOTAL=$((PUNTAJE_TOTAL + 20))
    else
        echo -e "  ${RED}✗ [FAIL] Ejercicio 5 falló (+0 Pts)${NC}"
        FALLOS=$((FALLOS + 1))
    fi
}

# Ejecutar todos los tests
imprimir_banner
test_ejercicio1
test_ejercicio2
test_ejercicio3
test_ejercicio4
test_ejercicio5

# Resumen final
echo -e "\n${BLUE}================================================================${NC}"
if [ $PUNTAJE_TOTAL -eq 100 ]; then
    echo -e "${GREEN}${BOLD}  RESULTADO: EXCELENTE! PUNTAJE FINAL: ${PUNTAJE_TOTAL} / ${MAX_PUNTAJE} PTS  ${NC}"
    echo -e "${GREEN}  Todos los tests pasaron exitosamente. Listo para git push!  ${NC}"
    echo -e "${BLUE}================================================================${NC}"
    exit 0
else
    echo -e "${YELLOW}${BOLD}  RESULTADO: PUNTAJE FINAL: ${PUNTAJE_TOTAL} / ${MAX_PUNTAJE} PTS (${FALLOS} fallos)  ${NC}"
    echo -e "${YELLOW}  Revise los errores indicados arriba, ajuste su código y vuelva a ejecutar ./test.sh${NC}"
    echo -e "${BLUE}================================================================${NC}"
    exit 1
fi
