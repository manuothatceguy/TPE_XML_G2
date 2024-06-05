(: Se pasan los docs a variables para mayor claridad del código :)
let $driversList := doc("drivers_list.xml")
let $driversStandings := doc("drivers_standings.xml")

(: Crear un archivo XML de salida y agregar datos a medida que se procesa la consulta :)

return <nascar_data>
    {
    for $driver in $driversList//series/season/driver
    return <driver>
      <full_name>{$driver/@full_name}</full_name>
      <country>{$driver/@country}</country>
      <birth_date>{$driver/@birth_date}</birth_date>
      <birth_place>{$driver/@birth_place}</birth_place>
      if (count($driver/car) > 0)
        then <car>{$driver//driver[@id = $driver/@id]}</car>
        else ()
        </driver>
    }
  </nascar_data>

    
  
