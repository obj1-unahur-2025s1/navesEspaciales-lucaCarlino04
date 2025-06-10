class Nave {
  var velocidad
  var direccion
  var combustible = 10000

  method acelerar(cuanto) {
    velocidad = (velocidad + cuanto).min(100000)
  }
  method desacelerar(cuanto) {
    velocidad = (velocidad - cuanto).max(0)
  }
  method irHaciaElSol() {
    direccion = 10
  }
  method escaparDelSol() {
    direccion = -10
  }
  method ponerseParaleloAlSol() {
    direccion = 0
  }
  method acercarseUnPocoAlSol() {
    direccion = (direccion + 1).min(10)
  }
  method alejarseUnPocoDelSol() {
    direccion = (direccion - 1).max(-10)
  }
  method cargarCombustible(cantidad) {
    combustible += cantidad
  }
  method descargarCombustible(cantidad) {
    combustible = (combustible -cantidad).max(0)
  }
  method estaTranquila() {
    return combustible >= 4000 and velocidad < 12000
  }
  method prepararViaje() {
    self.cargarCombustible(30000)
    self.acelerar(5000)
  }
  method recibirAmenaza() {}
  method estaDeRelajo() {
    return self.estaTranquila()
  }
}

class NaveBaliza inherits Nave {
  var color
  var cambioDeColor = false

  method cambiarColorDeBaliza(colorNuevo) {
    color = colorNuevo
    cambioDeColor = true
  }
  override method prepararViaje() {
    super()
    self.cambiarColorDeBaliza("verde")
    self.ponerseParaleloAlSol()
  }
  override method estaTranquila() {
    return super() and color != "rojo"
  }
  override method recibirAmenaza() {
    self.irHaciaElSol()
    self.cambiarColorDeBaliza("rojo")
  }
  override method estaDeRelajo() {
    return super() and !cambioDeColor
  }

}

class NavePasajeros inherits Nave {
  var cantidadPasajeros
  var comida = 0
  var bebida = 0
  var comidaServida = 0

  method cargarComida(unaCantidad) {
    comida += unaCantidad
  }
  method cargarBebida(unaCantidad) {
    bebida += unaCantidad
  }
  method descargarComida(unaCantidad) {
    comida = (comida-unaCantidad).max(0)
    comidaServida += unaCantidad
  }
  method descargarBebida(unaCantidad) {
    bebida = (bebida-unaCantidad).max(0)
  }
  override method prepararViaje() {
    super()
    self.cargarComida(4 * cantidadPasajeros)
    self.cargarBebida(6 * cantidadPasajeros)
    self.acercarseUnPocoAlSol()
  }
  override method recibirAmenaza() {
    self.acelerar(velocidad * 2)
    self.descargarBebida(2 * cantidadPasajeros)
    self.descargarComida(cantidadPasajeros)
  }
  override method estaDeRelajo() {
    return super() and comidaServida < 50
  }
}

class NaveCombate inherits Nave {
  var visible = true
  var misiles = true
  const mensajesEmitidos = []

  method ponerseVisible() {
    visible = true
  }
  method ponerseInvisible() {
    visible = false
  }
  method estaInvisible() {
    return !visible
  }
  method desplegarMisiles() {
    misiles = true
  }
  method replegarMisiles() {
    misiles = false
  }
  method misilesDesplegados() {
    return misiles
  }
  method emitirMensaje(mensaje) {
    mensajesEmitidos.add(mensaje)
  }
  method mensajesEmitidos() {
    return mensajesEmitidos
  }
  method primerMensajeEmitido() {
    return mensajesEmitidos.first()
  }
  method ultimoMensajeEmitido() {
    return mensajesEmitidos.last()
  }
  method esEscueta() {
    return mensajesEmitidos.all {mensaje => !mensaje.size() > 30}
  }
  method emitioMensaje(mensaje) {
    return mensajesEmitidos.contains(mensaje)
  }
  override method estaTranquila() {
    return super() and !self.misilesDesplegados()
  }
  override method prepararViaje() {
    super()
    self.ponerseVisible()
    self.replegarMisiles()
    self.acelerar(15000)
    self.emitirMensaje("Saliendo en misión")
  }
  override method recibirAmenaza() {
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
    self.emitirMensaje("Amenaza recibida")
  } 
}

class NaveHospital inherits NavePasajeros {
  var quirofanosPreparados = false

  method quirofanosPreparados() = quirofanosPreparados
  method prepararQuirofanos() {
    quirofanosPreparados = true
  }
  override method estaTranquila() {
    return super() and !self.quirofanosPreparados()
  }
  override method recibirAmenaza() {
    super()
    self.prepararQuirofanos()
  } 
}

class NaveCombateSigilosa inherits NaveCombate {
  override method estaTranquila() {
    return super() and !self.estaInvisible()
  }
  override method recibirAmenaza() {
    super()
    self.desplegarMisiles()
    self.ponerseInvisible()
  } 
}