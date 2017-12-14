//
//  ActorTableViewController.swift
//  listadoActoresCD
//
//  Created by Aitor Garcia on 13/12/17.
//  Copyright © 2017 Aitor García Luiz. All rights reserved.
//

import UIKit
import CoreData

class ActorTableViewController: UITableViewController {

    var actores: [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actores.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let actor = actores[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("ActorTableViewCell", forIndexPath: indexPath) as! ActorTableViewCell
        cell.nombreActorLB?.text = actor.valueForKey("nameAtr") as? String

        return cell
    }
    
    
    //Alert para aniadir una nueva pelicula
    @IBAction func addActor(sender: AnyObject) {
        let alertController = UIAlertController(title: "Nuevo actor:",
                                                message: "Introduce el nombre y apellidos para añadir un nuevo actor.",
                                                preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler({ (textField) in textField.placeholder = "" })
        
        let confirmAction = UIAlertAction(title: "Confirmar", style: UIAlertActionStyle.Default, handler: ({
            (_) in
            if let field1 = alertController.textFields![0] as? UITextField{
                    self.guardarActor(field1.text!)
                    self.tableView.reloadData()
            }
            }
            
        ))
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    //Guardar actor
    func guardarActor(nameToSave: String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("ActorEntity", inManagedObjectContext: managedContext)
        let actor = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        actor.setValue(nameToSave, forKey: "nameAtr")
        
        do {
            try managedContext.save()
            
            actores.append(actor)
        }
        catch{
            print("Error al guardar el actor")
        }
    }
    
    
    //Cargar actor
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "ActorEntity")
        
        do{
            actores = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        }
        catch {
            print("Error al cargar los actores")
        }
    }
    
    
    
    // Eliminar actores
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)
        
        managedContext.deleteObject(actores[indexPath.row])
        actores.removeAtIndex(indexPath.row)
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Eliminar"
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != "Peliculas" { return }
        let celdaRef = sender as! ActorTableViewCell
        let destinoVC = segue.destinationViewController as! PeliculaTableViewController
        let filaSeleccionada = tableView.indexPathForCell(celdaRef)
        destinoVC.selectedActor = actores[(filaSeleccionada?.row)!]
    }
    
}
