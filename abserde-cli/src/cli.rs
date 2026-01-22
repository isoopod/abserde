use clap::{ Parser, Subcommand };

#[derive(Parser)]
pub struct Cli {
    #[command(subcommand)]
    pub command: Command,
}

#[derive(Subcommand)]
pub enum Command {
    // Add your subcommands here
    Init,
}

pub fn parse() -> Cli {
    Cli::parse()
}
