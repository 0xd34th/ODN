module mecha::traits {
    use std::string::String;
    use sui::object::new;

    public struct Helmet has key, store {
        id: UID,
        part_0: String,
        part_1: String,
    }

    public struct Stomach has key, store {
        id: UID,
        part_0: String,
        part_1: String,
    }

    public struct Body has key, store {
        id: UID,
        part_0: String,
        part_1: String,
        part_2: String,
        part_3: String,
    }

    public struct Wings has key, store {
        id: UID,
        part_0: String,
        part_1: String,
        part_2: String,
        part_3: String,
        part_4: String,
        part_5: String,
    }

    public fun upload_helmet(p0: String, p1: String, ctx: &mut TxContext) {
        let h = Helmet {
            id: new(ctx),
            part_0: p0,
            part_1: p1,
        };
        transfer::transfer(h, tx_context::sender(ctx));
    }

    public fun upload_stomach(p0: String, p1: String, ctx: &mut TxContext) {
        let s = Stomach {
            id: new(ctx),
            part_0: p0,
            part_1: p1,
        };
        transfer::transfer(s, tx_context::sender(ctx));
    }

    public fun upload_body(p0: String, p1: String, p2: String, p3: String, ctx: &mut TxContext) {
        let b = Body {
            id: new(ctx),
            part_0: p0,
            part_1: p1,
            part_2: p2,
            part_3: p3,
        };
        transfer::transfer(b, tx_context::sender(ctx));
    }

    public fun upload_wings(
        p0: String, p1: String, p2: String, p3: String, p4: String, p5: String,
        ctx: &mut TxContext
    ) {
        let w = Wings {
            id: new(ctx),
            part_0: p0,
            part_1: p1,
            part_2: p2,
            part_3: p3,
            part_4: p4,
            part_5: p5,
        };
        transfer::transfer(w, tx_context::sender(ctx));
    }

    public fun get_helmet_parts(h: &Helmet): (String, String) {
        (h.part_0, h.part_1)
    }

    public fun get_stomach_parts(s: &Stomach): (String, String) {
        (s.part_0, s.part_1)
    }

    public fun get_body_parts(b: &Body): (String, String, String, String) {
        (b.part_0, b.part_1, b.part_2, b.part_3)
    }

    public fun get_wings_parts(w: &Wings): (String, String, String, String, String, String) {
        (w.part_0, w.part_1, w.part_2, w.part_3, w.part_4, w.part_5)
    }
}
