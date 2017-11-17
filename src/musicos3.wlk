class Artista {
	var albumes = []
	var canciones = []
	var habilidad
	var solista
	
	constructor(h, s, _albumes){
		albumes = _albumes
		_albumes.forEach({album => canciones.addAll(album.canciones())})
		habilidad = h
		solista = s
	}
	method leSale(c) = 
		self.habilidad()>60 or (canciones.contains(c))
	
	method hacerseSolista(s){
		solista = s
	}
	method albumes() = albumes
	method lanzarAlbum(album) {
		albumes.add(album)
		canciones.addAll(album.canciones())
	}
	method habilidad() = habilidad
	method setHabilidad(h) { habilidad = h }
	method canciones() = canciones
	method esMinimalista() = canciones.all({c => c.esCorta()})
	method cancionesTienen(palabra) = canciones.filter({c => c.contiene(palabra)})
	method duracionTotal() = canciones.fold(0, {duracion, c=> duracion+c.dura()})
	method laPego() = albumes.all({a => (a.vendidos()>(a.lanzados()*0.75))})
}

class MusicoDeGrupo inherits Artista{
	var mejoraEnGrupo
	constructor (m, h, s, _albumes) = super(h, s, _albumes) {
		mejoraEnGrupo = m
	}
	override method habilidad() {
		if (!solista) return habilidad+mejoraEnGrupo
		else return habilidad
	}
	override method leSale(cancion) = 
		(cancion.dura()>300) or (super(cancion)) 
	
}

class VocalistaPopular inherits Artista{
	var palabraClave
	constructor (h, s, _albumes, c) = super(h, s, _albumes){
		palabraClave = c
	}
	override method leSale(cancion) = 
		cancion.contiene(palabraClave) or (super(cancion))
}
object joaquin inherits MusicoDeGrupo(5, 20, false, []){

	method cobra(presentacion) {
		if (presentacion.quienes().contains(pimpinela)) return 50
		if (presentacion.quienes().contains(self)) return 100
		else return 0
	}
}

object lucia inherits VocalistaPopular(70,false,[],"familia") {
	override method habilidad() {
		if (solista) return habilidad
		else return (habilidad-20)
	}
	method cobra(presentacion) {
		if (presentacion.lugar().capacidad(presentacion.cuando())>5000) return 500 //
		else return 400
	}

}
object pimpinela {
	method cobra(presentacion){
		return joaquin.cobra(presentacion) + lucia.cobra(presentacion)
	}
}
object luisAlberto inherits Artista(8,true,[]) {
	var guitarra = fender
	override method leSale(cancion) = true
	override method habilidad() {
		var h = 8*guitarra.vale()
		if (h<100) return h
		else return 100
	}
	method agarrarGuitarra(g){
		guitarra = g
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
	var estaRota = false
	method romperse(r){
		estaRota = r
	}
	method vale(){
		if (estaRota) return 5
		else return 15
	}
}

class Album{
	var titulo
	var fecha
	var canciones
	var lanzados
	var vendidos
	
	var porLetra = {c => c.letra().size()}
	var porDuracion = {c => c.dura()}
	var porAlfa = {c => c.titulo()}
		
	constructor (t,f,l,v,c){
		titulo = t
		fecha = f
		lanzados = l
		vendidos = v
		canciones = c
	}
	method vendidos() = vendidos
	method lanzados() = lanzados
	method canciones() = canciones
	
	method getBiggest(criterio) = canciones.sortedBy({ cMenos, cMas => criterio.apply(cMas) < criterio.apply(cMenos) }).first()
	method getMasLetra() = self.getBiggest(porLetra)
	method getMasTiempo() = self.getBiggest(porDuracion)
	method getMasAlfa() = self.getBiggest(porAlfa)

}
class Cancion {
	var duracion
	var titulo
	var letra
	constructor(d, t, l) {
		duracion = d
		titulo = t
		letra = l
	}
	method dura() = duracion
	method titulada() = titulo
	method letra() = letra
	method esCorta() = duracion<180
	method contiene(palabra) {
		if (letra.contains(palabra)) return true
		return (letra.contains(palabra.take(1).toUpperCase() + palabra.drop(1).toLowerCase()))
	}
	method remixar() = new Cancion(duracion*3, titulo+" remix", "mueve tu cuelpo baby "+letra+" yeah oh yeah")
	method mashupear(c2) {
		var d
		var t
		var l
		d = self.dura().max(c2.dura())
		t = self.titulada() + " " + c2.titulada()//no entendi
		l = self.letra() + " " + c2.letra()
		return new Cancion(d, t, l)
	}
}


class Presentacion {
	var quienes 
	var lugar 
	var cuando 
	constructor(q,l,c) {
		quienes = q
		lugar = l
		cuando = c
	}
	method agregarArtista(artista) {quienes.add(artista)}
	method sacarArtista(artista) {quienes.remove(artista)}
	method quienes() = quienes
	method lugar() = lugar
	method cuando() = cuando
	method costo() = quienes.fold(0, {a, artista => a+artista.cobra(self)})
	
}
object pdpalooza inherits Presentacion([], lunaPark, new Date(15,12,2017)){
	override method agregarArtista(artista) {
		if (artista.habilidad()<70) throw new Exception("no tiene suficiente habilidad")
		if (artista.canciones().size()==0) throw new Exception("no compuso canciones")
		if (not(artista.leSale(new Cancion(510,"Cancion de Alicia en el pais","Quién sabe Alicia, este país no estuvo hecho porque sí. Te vas a ir, vas a salir pero te quedas, ¿dónde más vas a ir? Y es que aquí, sabes el trabalenguas, trabalenguas, el asesino te asesina, y es mucho para ti. Se acabó ese juego que te hacía feliz.")))) 
			throw new Exception("no le sale 'Alicia'")
		super(artista)
		} 
	}
object lunaPark{
	method capacidad(fecha) = 9290
}
object trastienda{
	method capacidad(fecha) {
		if(fecha.dayOfWeek()==6) return 700
		return 400
	}
}


