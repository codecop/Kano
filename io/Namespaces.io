Namespaces := Object clone do(
  //doc Namespaces Default The default namespace.
  Default := Namespace clone do(
    _default := task(
      if(System args size < 2,
        "No task was specified. See -T for list of available tasks." println))
  )

  /*doc Namespaces Options
  Tasks from this namespace are called only if their name is prepended with an dash. They can't take arguments.<br/>
  <code>kano -tasks</code>*/
  Options := Namespace clone do(
    T := option(
      """Lists all available tasks and options."""
      scriptName := System launchScript split("/") last

      Namespaces foreachSlot(nsName, ns,
        if(nsName == "type", continue)

        (nsName .. ":") println
        prettyNsName := if(nsName == "Default", "", (nsName asMutable makeFirstCharacterLowercase) .. ":")
        (nsName == "Options") ifTrue(prettyNsName = "-")

        # TODO: Add namespace descriptions
        "  Usage: #{scriptName} #{prettyNsName}<task>\n" interpolate println

        nsSlots := ns slotNames\
          select(exSlice(0, 1) != "_")\
          select(slot, ns getLocalSlot(slot) type == "Block")\
          sort

        nsSlots foreach(slot,
          slotArgs := ns getSlot(slot) argumentNames map(arg, "<" .. arg ..">") join(" ")
          "  #{slot} #{slotArgs}" interpolate println
          ns getSlot(slot) description split("\n") map(line, "    " .. line) join("\n") println
          "" println)))

    ns := option(
      """Lists all namespaces."""
      Namespaces slotNames remove("type") sort join(", ") println)

    V := option(
      """Prints Kano version."""
      # version := Eerie Env named("_base") packageNamed("Kano") config at("meta") at("version")
      version := File thisSourceFile parentDirectory parentDirectory at("package.json") contents parseJson at("version")
      ("Kano v" .. version) println)

    help := option(
      """Quick usage notes."""

      options := Namespaces Options slotNames remove("type") sort join("|")
      "Usage: #{System launchScript} [-#{options}] [namespace:]taskName arg1 arg2..." interpolate println)
  )
)
