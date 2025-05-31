module mecha::traits {
    use std::string::{Self, String};
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    /// A single base64 image fragment
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

    /// Return the base64 string directly (cheap copy thanks to `has copy`)
    public fun get_data(t: &Trait): String {
        t.data
    }
}
