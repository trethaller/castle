package cdb.jq;

class Client {

	var j : JQuery;
	var doms : Map<Int,Dom>;
	var root : Dom;
	var eventID : Int = 0;
	var events : Map<Int,Event -> Void>;

	function new() {
		doms = new Map();
		root = new Dom(this);
		doms.remove(root.id);
		root.id = 0;
		doms.set(root.id, root);
		events = new Map();
		j = new JQuery(this,root);
	}

	inline function J( ?elt : Dom, ?query : String ) {
		return new JQuery(this, elt, query);
	}

	public function send( msg : Message ) {
		sendBytes(BinSerializer.serialize(msg));
	}

	function sendBytes( b : haxe.io.Bytes ) {
	}

	public function allocEvent( e : Event -> Void ) {
		var id = eventID++;
		events.set(id, e);
		return id;
	}

	function handle( msg : Message.Answer ) {
		switch( msg ) {
		case Event(id, keyCode, value):
			var e = new Event();
			e.keyCode = keyCode;
			e.value = value;
			events.get(id)(e);
		case SetValue(id, v):
			doms.get(id).value = v;
		}
	}

}