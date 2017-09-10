//falta cancion, definir si es sabado, testear guitarras de luis

object joaquin {
	var solista
	method leSale(cancion) = cancion.dura()>300
	method habilidad(solista) {
		if (solista) return 20
		else return 25
	}
	method cobra(presentacion) {
		if (presentacion.quienes().size()>1) return 50
		else return 100
	}
}

object lucia {
	method leSale(cancion) = cancion.letra().contains("familia")
	method habilidad() = 70	
	method cobra(presentacion) {
		if (presentacion.lugar().esConcurrido(presentacion.esSabado())) return 500
		else return 400
	}
}

object luisAlberto {
	var guitarra = fender
	method leSale(cancion) = true
	method habilidad() {
		var h = 8*guitarra.vale()
		if (h<100) return h
		else return 100
	}
	method agarrarGuitarra(g){
		guitarra = g
	}
	method romperGibson(r){
		gibson.cambiarEstado(r)
	}
	method cobra(presentacion) {
		if (presentacion.cuando()>=new Date(1,9,2017)) return 1200
		else return 1000
	}
}

object fender {
	method vale()=10
}
object gibson {
	var estaRota
	method cambiarEstado(r){
		estaRota = r
	}
	method vale(){
		if (estaRota) return 5
		else return 15
	}
}
class Cancion {
	var duracion
	var titulo
	constructor(d, t) {
		duracion = d
		titulo = t
	}
	method dura() = duracion
	method titulada() = titulo
}


class Presentacion {
	var quienes 
	var lugar 
	var cuando 
	var sabado
	constructor(q,l,c,s) {
		quienes = q
		lugar = l
		cuando = c
		sabado = s
	}
	method quienes() = quienes
	method lugar() = lugar
	method cuando() = cuando
	method esSabado() = sabado
	method costo() = quienes.fold(0, {a, artista => a+artista.cobra(self)})
	
}

object lunaPark{
	method esConcurrido(esSabado) = true
}
object trastienda{
	method esConcurrido(esSabado) = esSabado
}

//var pres1 = new Presentacion([luisAlberto, joaquin, lucia],lunaPark,new Date(20,04,2017),false)
//var pres2= new Presentacion([luisAlberto, joaquin, lucia],trastienda,new Date(15,11,2017),false)

