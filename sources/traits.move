module mecha::traits {
    use std::string::{Self, String};
    use sui::object::{Self, UID};

    public struct Trait has key, store {
        id: UID,
        data: String,
    }

    /// Create a new Trait object on-chain
    public fun new(data: String, ctx: &mut TxContext) {
        let trait = Trait {
            id: object::new(ctx),
            data,
        };
        transfer::transfer(trait, tx_context::sender(ctx));
    }
    public fun get_data(t: &Trait): &String {
        &t.data
    }
}
