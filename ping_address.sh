#!/bin/bash

# Запрашиваем ввод пользователя для адреса пингования
read -p "Введите адрес для пингования: " address

fail_count=0

# Бесконечный цикл
while true; do
    ping_result=$(ping -c 1 $address 2>&1)
    if [[ $? -ne 0 ]]; then
        ((fail_count++))
        echo "Не удалось выполнить пинг (попытка $fail_count из 3)"
    else
        ping_time=$(echo $ping_result | grep -oP 'time=\K[0-9]+')
        if [[ $ping_time -gt 100 ]]; then
            echo "Время пинга превышает 100 мс: $ping_time мс"
        fi
        fail_count=0
    fi
    
    # Проверяем, было ли 3 последовательные неудачные попытки
    if [[ $fail_count -ge 3 ]]; then
        echo "Не удалось выполнить пинг 3 раза подряд"
        fail_count=0
    fi

    sleep 1
done



