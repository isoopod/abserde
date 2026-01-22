use crate::cli::{ Cli, Command };

mod init;

pub fn dispatch(cli: Cli) -> anyhow::Result<()> {
    match cli.command {
        Command::Init => init::run(),
    }
}
