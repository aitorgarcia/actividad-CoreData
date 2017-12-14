//
//  PeliculaTableViewController.swift
//  listadoActoresCD
//
//  Created by Aitor Garcia on 13/12/17.
//  Copyright © 2017 Aitor García Luiz. All rights reserved.
//

import UIKit
import CoreData

class PeliculaTableViewController: UITableViewController {

    var peliculas = [NSManagedObject]()
    
    
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
        return peliculas.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PeliculaTableViewCell", forIndexPath: indexPath) as! PeliculaTableViewCell
        
        let pelicula = peliculas[indexPath.row]
        
        cell.tituloPeliculaLB.text = pelicula.valueForKey("tituloAtr") as? String
        cell.anioPeliculaLB.text = pelicula.valueForKey("anioAtr") as? String

        return cell
    }
    
    
    //Alert para aniadir una nueva pelicula
    @IBAction func addPelicula(sender: AnyObject) {
        let alertController = UIAlertController(title: "Nueva película:",
                                                message: "Rellena los campos de texto para añadir una nueva película.",
                                                preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler({ (textField) in textField.placeholder = "Introduce un título" })
        alertController.addTextFieldWithConfigurationHandler({ (textField) in textField.placeholder = "Introduce un año" })
        
        let confirmAction = UIAlertAction(title: "Confirmar", style: UIAlertActionStyle.Default, handler: ({
            (_) in
            if let field1 = alertController.textFields![0] as? UITextField{
                if let field2 = alertController.textFields![1] as? UITextField{
                    self.guardarPelicula(field1.text!, anioToSave: field2.text!)
                    self.tableView.reloadData()
                }
                }
            }
        
        ))
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    //Guardar pelicula
    func guardarPelicula(tituloToSave: String, anioToSave: String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("PeliculaEntity", inManagedObjectContext: managedContext)
        let pelicula = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        pelicula.setValue(tituloToSave, forKey: "tituloAtr")
        pelicula.setValue(anioToSave, forKey: "anioAtr")
        
        do {
            try managedContext.save()
            
            peliculas.append(pelicula)
        }
        catch{
            print("Error al guardar la pelicula")
        }
    }
    
    
    //Cargar pelicula
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "PeliculaEntity")
        
        do{
            let results = try managedContext.executeFetchRequest(fetchRequest)
            peliculas = results as! [NSManagedObject]
        }
        catch {
            print("Error al cargar las peliculas")
        }
    }
    
    
    
    //Eliminar pelicula
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)
        
        managedContext.deleteObject(peliculas[indexPath.row])
        peliculas.removeAtIndex(indexPath.row)
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Eliminar"
    }
}
